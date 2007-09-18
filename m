Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:63090 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756199AbXIRVnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 17:43:49 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 2/3] rtl8187: Adapt to filter configuration API
Date: Tue, 18 Sep 2007 17:42:28 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Message-Id: <200709181742.28750.flamingice@sourmilk.net>
In-Reply-To: <20070918213833.8850.90828.stgit@magic.sourmilk.net>
References: <20070918213833.8850.90828.stgit@magic.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This makes rtl8187 use the new filter configuration API in mac80211.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8187.h     |    5 +
 drivers/net/wireless/rtl8187_dev.c |  129 +++++++++++++++++++++++++++++++-----
 drivers/net/wireless/rtl818x.h     |    1 
 3 files changed, 113 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/rtl8187.h b/drivers/net/wireless/rtl8187.h
index 7993b3d..6ad322e 100644
--- a/drivers/net/wireless/rtl8187.h
+++ b/drivers/net/wireless/rtl8187.h
@@ -36,8 +36,7 @@ struct rtl8187_rx_info {
 };
 
 struct rtl8187_rx_hdr {
-	__le16 len;
-	__le16 rate;
+	__le32 flags;
 	u8 noise;
 	u8 signal;
 	u8 agc;
@@ -74,7 +73,7 @@ struct rtl8187_priv {
 	struct ieee80211_rate rates[12];
 	struct ieee80211_hw_mode modes[2];
 	struct usb_device *udev;
-	u8 *hwaddr;
+	u32 rx_conf;
 	u16 txpwr_base;
 	u8 asic_rev;
 	struct sk_buff_head rx_queue;
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index 7dbf11e..815d576 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -41,6 +41,57 @@ static struct usb_device_id rtl8187_table[] __devinitdata = {
 
 MODULE_DEVICE_TABLE(usb, rtl8187_table);
 
+static void rtl8187_iowrite_async_cb(struct urb *urb)
+{
+	kfree(urb->context);
+	usb_free_urb(urb);
+}
+
+static void rtl8187_iowrite_async(struct rtl8187_priv *priv, __le16 addr,
+				  void *data, u16 len)
+{
+	struct usb_ctrlrequest *dr;
+	struct urb *urb;
+	struct rtl8187_async_write_data {
+		u8 data[4];
+		struct usb_ctrlrequest dr;
+	} *buf;
+
+	buf = kmalloc(sizeof(*buf), GFP_ATOMIC);
+	if (!buf)
+		return;
+
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!urb) {
+		kfree(buf);
+		return;
+	}
+
+	dr = &buf->dr;
+
+	dr->bRequestType = RTL8187_REQT_WRITE;
+	dr->bRequest = RTL8187_REQ_SET_REG;
+	dr->wValue = addr;
+	dr->wIndex = 0;
+	dr->wLength = cpu_to_le16(len);
+
+	memcpy(buf, data, len);
+
+	usb_fill_control_urb(urb, priv->udev, usb_sndctrlpipe(priv->udev, 0),
+			     (unsigned char *)dr, buf, len,
+			     rtl8187_iowrite_async_cb, buf);
+	usb_submit_urb(urb, GFP_ATOMIC);
+}
+
+static inline void rtl818x_iowrite32_async(struct rtl8187_priv *priv,
+					   __le32 *addr, u32 val)
+{
+	__le32 buf = cpu_to_le32(val);
+
+	rtl8187_iowrite_async(priv, cpu_to_le16((unsigned long)addr),
+			      &buf, sizeof(buf));
+}
+
 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
 {
 	struct rtl8187_priv *priv = dev->priv;
@@ -125,6 +176,7 @@ static void rtl8187_rx_cb(struct urb *urb)
 	struct rtl8187_rx_hdr *hdr;
 	struct ieee80211_rx_status rx_status = { 0 };
 	int rate, signal;
+	u32 flags;
 
 	spin_lock(&priv->rx_queue.lock);
 	if (skb->next)
@@ -143,10 +195,11 @@ static void rtl8187_rx_cb(struct urb *urb)
 
 	skb_put(skb, urb->actual_length);
 	hdr = (struct rtl8187_rx_hdr *)(skb_tail_pointer(skb) - sizeof(*hdr));
-	skb_trim(skb, le16_to_cpu(hdr->len) & 0x0FFF);
+	flags = le32_to_cpu(hdr->flags);
+	skb_trim(skb, flags & 0x0FFF);
 
 	signal = hdr->agc >> 1;
-	rate = (le16_to_cpu(hdr->rate) >> 4) & 0xF;
+	rate = (flags >> 20) & 0xF;
 	if (rate > 3) {	/* OFDM rate */
 		if (signal > 90)
 			signal = 90;
@@ -169,6 +222,8 @@ static void rtl8187_rx_cb(struct urb *urb)
 	rx_status.channel = dev->conf.channel;
 	rx_status.phymode = dev->conf.phymode;
 	rx_status.mactime = le64_to_cpu(hdr->mac_time);
+	if (flags & (1 << 13))
+		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 	ieee80211_rx_irqsafe(dev, skb, &rx_status);
 
 	skb = dev_alloc_skb(RTL8187_MAX_RX);
@@ -293,8 +348,6 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 	rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, 0);
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
-	for (i = 0; i < ETH_ALEN; i++)
-		rtl818x_iowrite8(priv, &priv->map->MAC[i], priv->hwaddr[i]);
 
 	rtl818x_iowrite16(priv, (__le16 *)0xFFF4, 0xFFFF);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG1);
@@ -365,7 +418,7 @@ static void rtl8187_set_channel(struct ieee80211_hw *dev, int channel)
 	rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
 }
 
-static int rtl8187_open(struct ieee80211_hw *dev)
+static int rtl8187_start(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	u32 reg;
@@ -383,16 +436,13 @@ static int rtl8187_open(struct ieee80211_hw *dev)
 	      RTL818X_RX_CONF_RX_AUTORESETPHY |
 	      RTL818X_RX_CONF_BSSID |
 	      RTL818X_RX_CONF_MGMT |
-	      RTL818X_RX_CONF_CTRL |
 	      RTL818X_RX_CONF_DATA |
 	      (7 << 13 /* RX FIFO threshold NONE */) |
 	      (7 << 10 /* MAX RX DMA */) |
 	      RTL818X_RX_CONF_BROADCAST |
-	      RTL818X_RX_CONF_MULTICAST |
 	      RTL818X_RX_CONF_NICMAC;
-	if (priv->mode == IEEE80211_IF_TYPE_MNTR)
-		reg |= RTL818X_RX_CONF_MONITOR;
 
+	priv->rx_conf = reg;
 	rtl818x_iowrite32(priv, &priv->map->RX_CONF, reg);
 
 	reg = rtl818x_ioread8(priv, &priv->map->CW_CONF);
@@ -419,7 +469,7 @@ static int rtl8187_open(struct ieee80211_hw *dev)
 	return 0;
 }
 
-static int rtl8187_stop(struct ieee80211_hw *dev)
+static void rtl8187_stop(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	struct rtl8187_rx_info *info;
@@ -445,28 +495,31 @@ static int rtl8187_stop(struct ieee80211_hw *dev)
 		usb_kill_urb(info->urb);
 		kfree_skb(skb);
 	}
-	return 0;
+	return;
 }
 
 static int rtl8187_add_interface(struct ieee80211_hw *dev,
 				 struct ieee80211_if_init_conf *conf)
 {
 	struct rtl8187_priv *priv = dev->priv;
+	int i;
 
-	/* NOTE: using IEEE80211_IF_TYPE_MGMT to indicate no mode selected */
-	if (priv->mode != IEEE80211_IF_TYPE_MGMT)
-		return -1;
+	if (priv->mode != IEEE80211_IF_TYPE_MNTR)
+		return -EOPNOTSUPP;
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_MNTR:
 		priv->mode = conf->type;
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
-	priv->hwaddr = conf->mac_addr ? conf->mac_addr : dev->wiphy->perm_addr;
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
+	for (i = 0; i < ETH_ALEN; i++)
+		rtl818x_iowrite8(priv, &priv->map->MAC[i],
+				 ((u8 *)conf->mac_addr)[i]);
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
 	return 0;
 }
@@ -475,7 +528,7 @@ static void rtl8187_remove_interface(struct ieee80211_hw *dev,
 				     struct ieee80211_if_init_conf *conf)
 {
 	struct rtl8187_priv *priv = dev->priv;
-	priv->mode = IEEE80211_IF_TYPE_MGMT;
+	priv->mode = IEEE80211_IF_TYPE_MNTR;
 }
 
 static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
@@ -523,14 +576,52 @@ static int rtl8187_config_interface(struct ieee80211_hw *dev, int if_id,
 	return 0;
 }
 
+static void rtl8187_configure_filter(struct ieee80211_hw *dev,
+				     unsigned int changed_flags,
+				     unsigned int *total_flags,
+				     int mc_count, struct dev_addr_list *mc_list)
+{
+	struct rtl8187_priv *priv = dev->priv;
+
+	*total_flags = 0;
+
+	if (changed_flags & FIF_PROMISC_IN_BSS)
+		priv->rx_conf ^= RTL818X_RX_CONF_NICMAC;
+	if (changed_flags & FIF_ALLMULTI)
+		priv->rx_conf ^= RTL818X_RX_CONF_MULTICAST;
+	if (changed_flags & FIF_FCSFAIL)
+		priv->rx_conf ^= RTL818X_RX_CONF_FCS;
+	if (changed_flags & FIF_CONTROL)
+		priv->rx_conf ^= RTL818X_RX_CONF_CTRL;
+	if (changed_flags & FIF_OTHER_BSS)
+		priv->rx_conf ^= RTL818X_RX_CONF_MONITOR;
+
+	if (mc_count > 0)
+		priv->rx_conf |= RTL818X_RX_CONF_MULTICAST;
+
+	if (priv->rx_conf & RTL818X_RX_CONF_NICMAC)
+		*total_flags |= FIF_PROMISC_IN_BSS;
+	if (priv->rx_conf & RTL818X_RX_CONF_MULTICAST)
+		*total_flags |= FIF_ALLMULTI;
+	if (priv->rx_conf & RTL818X_RX_CONF_FCS)
+		*total_flags |= FIF_FCSFAIL;
+	if (priv->rx_conf & RTL818X_RX_CONF_CTRL)
+		*total_flags |= FIF_CONTROL;
+	if (priv->rx_conf & RTL818X_RX_CONF_MONITOR)
+		*total_flags |= FIF_OTHER_BSS;
+
+	rtl818x_iowrite32_async(priv, &priv->map->RX_CONF, priv->rx_conf);
+}
+
 static const struct ieee80211_ops rtl8187_ops = {
 	.tx			= rtl8187_tx,
-	.open			= rtl8187_open,
+	.start			= rtl8187_start,
 	.stop			= rtl8187_stop,
 	.add_interface		= rtl8187_add_interface,
 	.remove_interface	= rtl8187_remove_interface,
 	.config			= rtl8187_config,
 	.config_interface	= rtl8187_config_interface,
+	.configure_filter	= rtl8187_configure_filter,
 };
 
 static void rtl8187_eeprom_register_read(struct eeprom_93cx6 *eeprom)
@@ -603,7 +694,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	priv->modes[1].rates = priv->rates;
 	priv->modes[1].num_channels = ARRAY_SIZE(rtl818x_channels);
 	priv->modes[1].channels = priv->channels;
-	priv->mode = IEEE80211_IF_TYPE_MGMT;
+	priv->mode = IEEE80211_IF_TYPE_MNTR;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS;
 	dev->extra_tx_headroom = sizeof(struct rtl8187_tx_hdr);
diff --git a/drivers/net/wireless/rtl818x.h b/drivers/net/wireless/rtl818x.h
index 283de30..880d4be 100644
--- a/drivers/net/wireless/rtl818x.h
+++ b/drivers/net/wireless/rtl818x.h
@@ -71,6 +71,7 @@ struct rtl818x_csr {
 #define RTL818X_RX_CONF_NICMAC		(1 <<  1)
 #define RTL818X_RX_CONF_MULTICAST	(1 <<  2)
 #define RTL818X_RX_CONF_BROADCAST	(1 <<  3)
+#define RTL818X_RX_CONF_FCS		(1 <<  5)
 #define RTL818X_RX_CONF_DATA		(1 << 18)
 #define RTL818X_RX_CONF_CTRL		(1 << 19)
 #define RTL818X_RX_CONF_MGMT		(1 << 20)

