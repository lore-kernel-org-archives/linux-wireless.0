Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2414 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYDASda (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 14:33:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8187b work in progress...
Date: Tue,  1 Apr 2008 14:24:28 -0400
Message-Id: <1207074268-16335-1-git-send-email-linville@tuxdriver.com> (sfid-20080401_193337_435098_A72DF665)
In-Reply-To: <pan.2008.04.01.18.07.31.772700@gimpelevich.san-francisco.ca.us>
References: <pan.2008.04.01.18.07.31.772700@gimpelevich.san-francisco.ca.us>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No idea if it even compiles...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl8187.h     |   20 ++++-
 drivers/net/wireless/rtl8187_dev.c |  161 +++++++++++++++++++++++-------------
 2 files changed, 123 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/rtl8187.h b/drivers/net/wireless/rtl8187.h
index 076d88b..4c297d1 100644
--- a/drivers/net/wireless/rtl8187.h
+++ b/drivers/net/wireless/rtl8187.h
@@ -50,15 +50,29 @@ struct rtl8187_tx_info {
 	struct ieee80211_hw *dev;
 };
 
-struct rtl8187_tx_hdr {
-	__le32 flags;
+/* Tx flags are common between rtl8187 and rtl8187b */
 #define RTL8187_TX_FLAG_NO_ENCRYPT	(1 << 15)
 #define RTL8187_TX_FLAG_MORE_FRAG	(1 << 17)
 #define RTL8187_TX_FLAG_CTS		(1 << 18)
 #define RTL8187_TX_FLAG_RTS		(1 << 23)
+
+struct rtl8187_tx_hdr {
+	__le32 flags;
+	__le16 rts_duration;
+	__le16 len;
+	__le32 retry;
+} __attribute__((packed));
+
+struct rtl8187b_tx_hdr {
+	__le32 flags;
 	__le16 rts_duration;
 	__le16 len;
+	__le32 unused_1;
+	__le16 tx_duration;
+	__le16 unused_2;
+	__le32 unused_3;
 	__le32 retry;
+	__le32 unused_4[2];
 } __attribute__((packed));
 
 struct rtl8187_priv {
@@ -76,6 +90,8 @@ struct rtl8187_priv {
 	u32 rx_conf;
 	u16 txpwr_base;
 	u8 asic_rev;
+	u8 is_rtl8187b;
+	/* reorder this? */
 	struct sk_buff_head rx_queue;
 };
 
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index c03834d..ec7f80b 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -27,19 +27,23 @@
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
-MODULE_DESCRIPTION("RTL8187 USB wireless driver");
+MODULE_DESCRIPTION("RTL8187/RTL8187B USB wireless driver");
 MODULE_LICENSE("GPL");
 
 static struct usb_device_id rtl8187_table[] __devinitdata = {
-	/* Realtek */
-	{USB_DEVICE(0x0bda, 0x8187)},
+	/* Realtek 8187 */
+	{USB_DEVICE(0x0bda, 0x8187), .driver_info = DEVICE_RTL8187},
 	/* Netgear */
-	{USB_DEVICE(0x0846, 0x6100)},
-	{USB_DEVICE(0x0846, 0x6a00)},
+	{USB_DEVICE(0x0846, 0x6100), .driver_info = DEVICE_RTL8187},
+	{USB_DEVICE(0x0846, 0x6a00), .driver_info = DEVICE_RTL8187},
 	/* HP */
-	{USB_DEVICE(0x03f0, 0xca02)},
+	{USB_DEVICE(0x03f0, 0xca02), .driver_info = DEVICE_RTL8187},
 	/* Sitecom */
-	{USB_DEVICE(0x0df6, 0x000d)},
+	{USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
+
+	/* Realtek 8187B */
+	{USB_DEVICE(0x0bda, 0x8189), .driver_info = DEVICE_RTL8187B},
+	{USB_DEVICE(0x0bda, 0x8197), .driver_info = DEVICE_RTL8187B},
 	{}
 };
 
@@ -165,6 +169,7 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 {
 	struct rtl8187_priv *priv = dev->priv;
 	struct rtl8187_tx_hdr *hdr;
+	struct rtl8187b_tx_hdr *hdr_b;
 	struct rtl8187_tx_info *info;
 	struct urb *urb;
 	__le16 rts_dur = 0;
@@ -196,18 +201,31 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 		flags |= control->rts_cts_rate->hw_value << 19;
 	}
 
-	hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
-	hdr->flags = cpu_to_le32(flags);
-	hdr->len = 0;
-	hdr->rts_duration = rts_dur;
-	hdr->retry = cpu_to_le32(control->retry_limit << 8);
+	if (!priv->is_rtl8187b) {
+		hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
+		hdr->flags = cpu_to_le32(flags);
+		hdr->len = 0;
+		hdr->rts_duration = rts_dur;
+		hdr->retry = cpu_to_le32(control->retry_limit << 8);
+	} else {
+		hdr_b = (struct rtl8187b_tx_hdr *)skb_push(skb, sizeof(*hdr_b));
+		hdr_b->flags = cpu_to_le32(flags);
+		hdr_b->len = 0;
+		hdr_b->rts_duration = rts_dur;
+		hdr_b->tx_duration =
+			ieee80211_generic_frame_duration(dev, priv->vif,
+							 skb->len,
+							 control->tx_rate);
+		hdr_b->retry = cpu_to_le32(control->retry_limit << 8);
+	}
 
 	info = (struct rtl8187_tx_info *)skb->cb;
 	info->control = kmemdup(control, sizeof(*control), GFP_ATOMIC);
 	info->urb = urb;
 	info->dev = dev;
 	usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, 2),
-			  hdr, skb->len, rtl8187_tx_cb, skb);
+			  priv->is_rtl8187b ? hdr_b : hdr,
+			  skb->len, rtl8187_tx_cb, skb);
 	usb_submit_urb(urb, GFP_ATOMIC);
 
 	return 0;
@@ -306,7 +324,8 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
 			break;
 		}
 		usb_fill_bulk_urb(entry, priv->udev,
-				  usb_rcvbulkpipe(priv->udev, 1),
+				  usb_rcvbulkpipe(priv->udev,
+					priv->is_rtl8187b ? 3 : 1),
 				  skb_tail_pointer(skb),
 				  RTL8187_MAX_RX, rtl8187_rx_cb, skb);
 		info = (struct rtl8187_rx_info *)skb->cb;
@@ -326,21 +345,29 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 	int i;
 
 	/* reset */
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
-	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_ON);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
-
-	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
-
-	msleep(200);
-	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x10);
-	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x11);
-	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x00);
-	msleep(200);
+	if (!priv->is_rtl8187b) {
+		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+				 RTL818X_EEPROM_CMD_CONFIG);
+		reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+		rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+				 reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
+				  RTL8225_ANAPARAM_ON);
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
+				  RTL8225_ANAPARAM2_ON);
+		rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+				 reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
+		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+				 RTL818X_EEPROM_CMD_NORMAL);
+
+		rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
+
+		msleep(200);
+		rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x10);
+		rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x11);
+		rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x00);
+		msleep(200);
+	}
 
 	reg = rtl818x_ioread8(priv, &priv->map->CMD);
 	reg &= (1 << 1);
@@ -377,18 +404,27 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 		return -ETIMEDOUT;
 	}
 
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
-	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_ON);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+	if (!priv->is_rtl8187b) {
+		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+				 RTL818X_EEPROM_CMD_CONFIG);
+		reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+		rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+				 reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
+				  RTL8225_ANAPARAM_ON);
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
+				  RTL8225_ANAPARAM2_ON);
+		rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+				 reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
+		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+				 RTL818X_EEPROM_CMD_NORMAL);
+	}
 
 	/* setup card */
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0);
 	rtl818x_iowrite8(priv, &priv->map->GPIO, 0);
 
+	/* light blink! */
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, (4 << 8));
 	rtl818x_iowrite8(priv, &priv->map->GPIO, 1);
 	rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, 0);
@@ -424,6 +460,7 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x80);
 	msleep(100);
 
+	/* this is part of RF init */
 	rtl818x_iowrite32(priv, &priv->map->RF_TIMING, 0x000a8008);
 	rtl818x_iowrite16(priv, &priv->map->BRSR, 0xFFFF);
 	rtl818x_iowrite32(priv, &priv->map->RF_PARA, 0x00100044);
@@ -476,26 +513,36 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 	priv->rx_conf = reg;
 	rtl818x_iowrite32(priv, &priv->map->RX_CONF, reg);
 
-	reg = rtl818x_ioread8(priv, &priv->map->CW_CONF);
-	reg &= ~RTL818X_CW_CONF_PERPACKET_CW_SHIFT;
-	reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
-	rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
-
-	reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
-	reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT;
-	reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT;
-	reg &= ~RTL818X_TX_AGC_CTL_FEEDBACK_ANT;
-	rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg);
-
-	reg  = RTL818X_TX_CONF_CW_MIN |
-	       (7 << 21 /* MAX TX DMA */) |
-	       RTL818X_TX_CONF_NO_ICV;
-	rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
+	if (priv->is_rtl8187b) {
+		reg  = RTL818X_TX_CONF_HW_SEQNUM |
+		       (7 << 21 /* MAX TX DMA */);
+		rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
 
-	reg = rtl818x_ioread8(priv, &priv->map->CMD);
-	reg |= RTL818X_CMD_TX_ENABLE;
-	reg |= RTL818X_CMD_RX_ENABLE;
-	rtl818x_iowrite8(priv, &priv->map->CMD, reg);
+		reg = rtl818x_ioread8(priv, &priv->map->MSR);
+		reg |= RTL818X_MSR_ENEDCA;
+		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
+	} else {
+		reg = rtl818x_ioread8(priv, &priv->map->CW_CONF);
+		reg &= ~RTL818X_CW_CONF_PERPACKET_CW_SHIFT;
+		reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
+		rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
+
+		reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
+		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT;
+		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT;
+		reg &= ~RTL818X_TX_AGC_CTL_FEEDBACK_ANT;
+		rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg);
+
+		reg  = RTL818X_TX_CONF_CW_MIN |
+		       (7 << 21 /* MAX TX DMA */) |
+		       RTL818X_TX_CONF_NO_ICV;
+		rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
+
+		reg = rtl818x_ioread8(priv, &priv->map->CMD);
+		reg |= RTL818X_CMD_TX_ENABLE;
+		reg |= RTL818X_CMD_RX_ENABLE;
+		rtl818x_iowrite8(priv, &priv->map->CMD, reg);
+	}
 
 	return 0;
 }
@@ -711,6 +758,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	}
 
 	priv = dev->priv;
+	priv->is_rtl8187b = (id->driver_info == DEVICE_RTL8187B);
 
 	SET_IEEE80211_DEV(dev, &intf->dev);
 	usb_set_intfdata(intf, dev);
@@ -738,7 +786,8 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS;
-	dev->extra_tx_headroom = sizeof(struct rtl8187_tx_hdr);
+	dev->extra_tx_headroom = max(sizeof(struct rtl8187_tx_hdr),
+					sizeof(struct rtl8187b_tx_hdr));
 	dev->queues = 1;
 	dev->max_rssi = 65;
 	dev->max_signal = 64;
-- 
1.5.3.3

