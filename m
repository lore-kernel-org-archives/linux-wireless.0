Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:55465 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZG3QvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 12:51:09 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 07/10] rndis_host: allow rndis_wlan to see all indications
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	David Brownell <dbrownell@users.sourceforge.net>
Date: Thu, 30 Jul 2009 19:41:52 +0300
Message-ID: <20090730164152.28317.48077.stgit@fate.lan>
In-Reply-To: <20090730164120.28317.53313.stgit@fate.lan>
References: <20090730164120.28317.53313.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow rndis_wlan to see all indications. Currently rndis_host lets rndis_wlan to
know about link state changes only, but there is whole set of other
802.11-specific indications that rndis_wlan should handle properly. So rename
link_change() to indication() and convert rndis_wlan to use it.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: David Brownell <dbrownell@users.sourceforge.net>
---

 drivers/net/usb/rndis_host.c      |   50 +++++++++++++++++++++----------------
 drivers/net/wireless/rndis_wlan.c |   31 +++++++++++++++++++----
 include/linux/usb/usbnet.h        |    5 +---
 3 files changed, 56 insertions(+), 30 deletions(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 2232232..d032bba 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -65,6 +65,32 @@ void rndis_status(struct usbnet *dev, struct urb *urb)
 EXPORT_SYMBOL_GPL(rndis_status);
 
 /*
+ * RNDIS indicate messages.
+ */
+static void rndis_msg_indicate(struct usbnet *dev, struct rndis_indicate *msg,
+				int buflen)
+{
+	struct cdc_state *info = (void *)&dev->data;
+	struct device *udev = &info->control->dev;
+
+	if (dev->driver_info->indication) {
+		dev->driver_info->indication(dev, msg, buflen);
+	} else {
+		switch (msg->status) {
+		case RNDIS_STATUS_MEDIA_CONNECT:
+			dev_info(udev, "rndis media connect\n");
+			break;
+		case RNDIS_STATUS_MEDIA_DISCONNECT:
+			dev_info(udev, "rndis media disconnect\n");
+			break;
+		default:
+			dev_info(udev, "rndis indication: 0x%08x\n",
+					le32_to_cpu(msg->status));
+		}
+	}
+}
+
+/*
  * RPC done RNDIS-style.  Caller guarantees:
  * - message is properly byteswapped
  * - there's no other request pending
@@ -143,27 +169,9 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
 					request_id, xid);
 				/* then likely retry */
 			} else switch (buf->msg_type) {
-			case RNDIS_MSG_INDICATE: {	/* fault/event */
-				struct rndis_indicate *msg = (void *)buf;
-				int state = 0;
-
-				switch (msg->status) {
-				case RNDIS_STATUS_MEDIA_CONNECT:
-					state = 1;
-				case RNDIS_STATUS_MEDIA_DISCONNECT:
-					dev_info(&info->control->dev,
-						"rndis media %sconnect\n",
-						!state?"dis":"");
-					if (dev->driver_info->link_change)
-						dev->driver_info->link_change(
-							dev, state);
-					break;
-				default:
-					dev_info(&info->control->dev,
-						"rndis indication: 0x%08x\n",
-						le32_to_cpu(msg->status));
-				}
-				}
+			case RNDIS_MSG_INDICATE:	/* fault/event */
+				rndis_msg_indicate(dev, (void *)buf, buflen);
+
 				break;
 			case RNDIS_MSG_KEEPALIVE: {	/* ping */
 				struct rndis_keepalive_c *msg = (void *)buf;
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index f6dcbb1..6b6452b 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2211,13 +2211,32 @@ static void rndis_wlan_set_multicast_list(struct net_device *dev)
 	queue_work(priv->workqueue, &priv->work);
 }
 
-static void rndis_wlan_link_change(struct usbnet *usbdev, int state)
+static void rndis_wlan_indication(struct usbnet *usbdev, void *ind, int buflen)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+	struct rndis_indicate *msg = ind;
 
 	/* queue work to avoid recursive calls into rndis_command */
-	set_bit(state ? WORK_LINK_UP : WORK_LINK_DOWN, &priv->work_pending);
-	queue_work(priv->workqueue, &priv->work);
+	switch (msg->status) {
+	case RNDIS_STATUS_MEDIA_CONNECT:
+		devinfo(usbdev, "media connect");
+
+		set_bit(WORK_LINK_UP, &priv->work_pending);
+		queue_work(priv->workqueue, &priv->work);
+		break;
+
+	case RNDIS_STATUS_MEDIA_DISCONNECT:
+		devinfo(usbdev, "media disconnect");
+
+		set_bit(WORK_LINK_DOWN, &priv->work_pending);
+		queue_work(priv->workqueue, &priv->work);
+		break;
+
+	default:
+		devinfo(usbdev, "indication: 0x%08x",
+				le32_to_cpu(msg->status));
+		break;
+	}
 }
 
 
@@ -2666,7 +2685,7 @@ static const struct driver_info	bcm4320b_info = {
 	.reset =	rndis_wlan_reset,
 	.stop =		rndis_wlan_stop,
 	.early_init =	bcm4320b_early_init,
-	.link_change =	rndis_wlan_link_change,
+	.indication =	rndis_wlan_indication,
 };
 
 static const struct driver_info	bcm4320a_info = {
@@ -2681,7 +2700,7 @@ static const struct driver_info	bcm4320a_info = {
 	.reset =	rndis_wlan_reset,
 	.stop =		rndis_wlan_stop,
 	.early_init =	bcm4320a_early_init,
-	.link_change =	rndis_wlan_link_change,
+	.indication =	rndis_wlan_indication,
 };
 
 static const struct driver_info rndis_wlan_info = {
@@ -2696,7 +2715,7 @@ static const struct driver_info rndis_wlan_info = {
 	.reset =	rndis_wlan_reset,
 	.stop =		rndis_wlan_stop,
 	.early_init =	bcm4320a_early_init,
-	.link_change =	rndis_wlan_link_change,
+	.indication =	rndis_wlan_indication,
 };
 
 /*-------------------------------------------------------------------------*/
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index c642f78..de8b4b1 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -122,9 +122,8 @@ struct driver_info {
 	 * right after minidriver have initialized hardware. */
 	int	(*early_init)(struct usbnet *dev);
 
-	/* called by minidriver when link state changes, state: 0=disconnect,
-	 * 1=connect */
-	void	(*link_change)(struct usbnet *dev, int state);
+	/* called by minidriver when receiving indication */
+	void	(*indication)(struct usbnet *dev, void *ind, int indlen);
 
 	/* for new devices, use the descriptor-reading code instead */
 	int		in;		/* rx endpoint */

