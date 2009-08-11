Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:41026 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755374AbZHKT5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 15:57:17 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH v2] usbnet: add rx queue pausing
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com,
	David Brownell <dbrownell@users.sourceforge.net>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Tue, 11 Aug 2009 22:57:16 +0300
Message-ID: <20090811195716.8447.56369.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add rx queue pausing to usbnet. This is needed by rndis_wlan so that it can
control rx queue and prevent received packets from being send forward before
rndis_wlan receives and handles 'media connect'-indication. Without this
establishing WPA connections is hard and fail often.

[v2] - removed unneeded use of skb_clone

Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/usb/usbnet.c          |   44 ++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/rndis_wlan.c |   13 ++++++++++-
 include/linux/usb/usbnet.h        |    6 +++++
 3 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index af1fe46..7d471fc 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -233,6 +233,11 @@ void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
 {
 	int	status;
 
+	if (test_bit(EVENT_RX_PAUSED, &dev->flags)) {
+		skb_queue_tail(&dev->rxq_pause, skb);
+		return;
+	}
+
 	skb->protocol = eth_type_trans (skb, dev->net);
 	dev->net->stats.rx_packets++;
 	dev->net->stats.rx_bytes += skb->len;
@@ -526,6 +531,41 @@ static void intr_complete (struct urb *urb)
 }
 
 /*-------------------------------------------------------------------------*/
+void usbnet_pause_rx(struct usbnet *dev)
+{
+	set_bit(EVENT_RX_PAUSED, &dev->flags);
+
+	if (netif_msg_rx_status(dev))
+		devdbg(dev, "paused rx queue enabled");
+}
+EXPORT_SYMBOL_GPL(usbnet_pause_rx);
+
+void usbnet_resume_rx(struct usbnet *dev)
+{
+	struct sk_buff *skb;
+	int num = 0;
+
+	clear_bit(EVENT_RX_PAUSED, &dev->flags);
+
+	while ((skb = skb_dequeue(&dev->rxq_pause)) != NULL) {
+		usbnet_skb_return(dev, skb);
+		num++;
+	}
+
+	tasklet_schedule(&dev->bh);
+
+	if (netif_msg_rx_status(dev))
+		devdbg(dev, "paused rx queue disabled, %d skbs requeued", num);
+}
+EXPORT_SYMBOL_GPL(usbnet_resume_rx);
+
+void usbnet_purge_paused_rxq(struct usbnet *dev)
+{
+	skb_queue_purge(&dev->rxq_pause);
+}
+EXPORT_SYMBOL_GPL(usbnet_purge_paused_rxq);
+
+/*-------------------------------------------------------------------------*/
 
 // unlink pending rx/tx; completion handlers do all other cleanup
 
@@ -623,6 +663,8 @@ int usbnet_stop (struct net_device *net)
 
 	usb_kill_urb(dev->interrupt);
 
+	usbnet_purge_paused_rxq(dev);
+
 	/* deferred work (task, timer, softirq) must also stop.
 	 * can't flush_scheduled_work() until we drop rtnl (later),
 	 * else workers could deadlock; so make workers a NOP.
@@ -1113,7 +1155,6 @@ static void usbnet_bh (unsigned long param)
 }
 
 
-
 /*-------------------------------------------------------------------------
  *
  * USB Device Driver support
@@ -1210,6 +1251,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	skb_queue_head_init (&dev->rxq);
 	skb_queue_head_init (&dev->txq);
 	skb_queue_head_init (&dev->done);
+	skb_queue_head_init(&dev->rxq_pause);
 	dev->bh.func = usbnet_bh;
 	dev->bh.data = (unsigned long) dev;
 	INIT_WORK (&dev->kevent, kevent);
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 828dc18..d42692d 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1764,8 +1764,15 @@ static int rndis_iw_set_essid(struct net_device *dev,
 
 	if (!wrqu->essid.flags || length == 0)
 		return disassociate(usbdev, 1);
-	else
+	else {
+		/* Pause and purge rx queue, so we don't pass packets before
+		 * 'media connect'-indication.
+		 */
+		usbnet_pause_rx(usbdev);
+		usbnet_purge_paused_rxq(usbdev);
+
 		return set_essid(usbdev, &ssid);
+	}
 }
 
 
@@ -2328,6 +2335,8 @@ get_bssid:
 			memcpy(evt.ap_addr.sa_data, bssid, ETH_ALEN);
 			wireless_send_event(usbdev->net, SIOCGIWAP, &evt, NULL);
 		}
+
+		usbnet_resume_rx(usbdev);
 	}
 
 	if (test_and_clear_bit(WORK_LINK_DOWN, &priv->work_pending)) {
@@ -2541,6 +2550,8 @@ static void rndis_wlan_indication(struct usbnet *usbdev, void *ind, int buflen)
 
 	switch (msg->status) {
 	case RNDIS_STATUS_MEDIA_CONNECT:
+		usbnet_pause_rx(usbdev);
+
 		devinfo(usbdev, "media connect");
 
 		/* queue work to avoid recursive calls into rndis_command */
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index de8b4b1..0951425 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -53,6 +53,7 @@ struct usbnet {
 	struct sk_buff_head	rxq;
 	struct sk_buff_head	txq;
 	struct sk_buff_head	done;
+	struct sk_buff_head	rxq_pause;
 	struct urb		*interrupt;
 	struct tasklet_struct	bh;
 
@@ -63,6 +64,7 @@ struct usbnet {
 #		define EVENT_RX_MEMORY	2
 #		define EVENT_STS_SPLIT	3
 #		define EVENT_LINK_RESET	4
+#		define EVENT_RX_PAUSED	5
 };
 
 static inline struct usb_driver *driver_of(struct usb_interface *intf)
@@ -190,6 +192,10 @@ extern void usbnet_defer_kevent (struct usbnet *, int);
 extern void usbnet_skb_return (struct usbnet *, struct sk_buff *);
 extern void usbnet_unlink_rx_urbs(struct usbnet *);
 
+extern void usbnet_pause_rx(struct usbnet *);
+extern void usbnet_resume_rx(struct usbnet *);
+extern void usbnet_purge_paused_rxq(struct usbnet *);
+
 extern int usbnet_get_settings (struct net_device *net, struct ethtool_cmd *cmd);
 extern int usbnet_set_settings (struct net_device *net, struct ethtool_cmd *cmd);
 extern u32 usbnet_get_link (struct net_device *net);

