Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.235]:55561 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbYGHQUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 12:20:22 -0400
Received: by hu-out-0506.google.com with SMTP id 28so8166576hub.21
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 09:20:20 -0700 (PDT)
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Pavel Roskin <proski@gnu.org>
Subject: [PATCH 5/6] rtl8187: change part 2 of rtl8187_dev.c to support RTL8187B
Date: Tue,  8 Jul 2008 17:18:12 +0100
Message-Id: <1215533893-8598-5-git-send-email-HinTak.Leung@gmail.com> (sfid-20080708_182026_570411_6000F12A)
In-Reply-To: <1215533893-8598-4-git-send-email-HinTak.Leung@gmail.com>
References: <1215533893-8598-1-git-send-email-HinTak.Leung@gmail.com>
 <1215533893-8598-2-git-send-email-HinTak.Leung@gmail.com>
 <1215533893-8598-3-git-send-email-HinTak.Leung@gmail.com>
 <1215533893-8598-4-git-send-email-HinTak.Leung@gmail.com>
From: Hin-Tak Leung <hintak.leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/rtl8187_dev.c |  208 +++++++++++++++++++++++++++++-------
 1 files changed, 168 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index b17f237..3bc4a1c 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -155,9 +155,11 @@ static void rtl8187_tx_cb(struct urb *urb)
 	struct sk_buff *skb = (struct sk_buff *)urb->context;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hw *hw = info->driver_data[0];
+	struct rtl8187_priv *priv = hw->priv;
 
 	usb_free_urb(info->driver_data[1]);
-	skb_pull(skb, sizeof(struct rtl8187_tx_hdr));
+	skb_pull(skb, priv->is_rtl8187b ? sizeof(struct rtl8187b_tx_hdr) :
+					  sizeof(struct rtl8187_tx_hdr));
 	memset(&info->status, 0, sizeof(info->status));
 	info->flags |= IEEE80211_TX_STAT_ACK;
 	ieee80211_tx_status_irqsafe(hw, skb);
@@ -167,7 +169,8 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct rtl8187_tx_hdr *hdr;
+	unsigned int ep;
+	void *buf;
 	struct urb *urb;
 	__le16 rts_dur = 0;
 	u32 flags;
@@ -195,16 +198,47 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 		flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
 	}
 
-	hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
-	hdr->flags = cpu_to_le32(flags);
-	hdr->len = 0;
-	hdr->rts_duration = rts_dur;
-	hdr->retry = cpu_to_le32(info->control.retry_limit << 8);
+	if (!priv->is_rtl8187b) {
+		struct rtl8187_tx_hdr *hdr =
+			(struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
+		hdr->flags = cpu_to_le32(flags);
+		hdr->len = 0;
+		hdr->rts_duration = rts_dur;
+		hdr->retry = cpu_to_le32(info->control.retry_limit << 8);
+		buf = hdr;
+
+		ep = 2;
+	} else {
+		/* fc needs to be calculated before skb_push() */
+		unsigned int epmap[4] = { 6, 7, 5, 4 };
+		struct ieee80211_hdr *tx_hdr =
+			(struct ieee80211_hdr *)(skb->data);
+		u16 fc = le16_to_cpu(tx_hdr->frame_control);
+
+		struct rtl8187b_tx_hdr *hdr =
+			(struct rtl8187b_tx_hdr *)skb_push(skb, sizeof(*hdr));
+		struct ieee80211_rate *txrate =
+			ieee80211_get_tx_rate(dev, info);
+		memset(hdr, 0, sizeof(*hdr));
+		hdr->flags = cpu_to_le32(flags);
+		hdr->rts_duration = rts_dur;
+		hdr->retry = cpu_to_le32(info->control.retry_limit << 8);
+		hdr->tx_duration =
+			ieee80211_generic_frame_duration(dev, priv->vif,
+							 skb->len, txrate);
+		buf = hdr;
+
+		if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)
+			ep = 12;
+		else
+			ep = epmap[skb_get_queue_mapping(skb)];
+	}
 
 	info->driver_data[0] = dev;
 	info->driver_data[1] = urb;
-	usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, 2),
-			  hdr, skb->len, rtl8187_tx_cb, skb);
+
+	usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, ep),
+			  buf, skb->len, rtl8187_tx_cb, skb);
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
 	if (rc < 0) {
 		usb_free_urb(urb);
@@ -220,7 +254,6 @@ static void rtl8187_rx_cb(struct urb *urb)
 	struct rtl8187_rx_info *info = (struct rtl8187_rx_info *)skb->cb;
 	struct ieee80211_hw *dev = info->dev;
 	struct rtl8187_priv *priv = dev->priv;
-	struct rtl8187_rx_hdr *hdr;
 	struct ieee80211_rx_status rx_status = { 0 };
 	int rate, signal;
 	u32 flags;
@@ -241,11 +274,33 @@ static void rtl8187_rx_cb(struct urb *urb)
 	}
 
 	skb_put(skb, urb->actual_length);
-	hdr = (struct rtl8187_rx_hdr *)(skb_tail_pointer(skb) - sizeof(*hdr));
-	flags = le32_to_cpu(hdr->flags);
-	skb_trim(skb, flags & 0x0FFF);
+	if (!priv->is_rtl8187b) {
+		struct rtl8187_rx_hdr *hdr =
+			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
+		flags = le32_to_cpu(hdr->flags);
+		signal = hdr->signal & 0x7f;
+		rx_status.antenna = (hdr->signal >> 7) & 1;
+		rx_status.signal = signal;
+		rx_status.noise = hdr->noise;
+		rx_status.mactime = le64_to_cpu(hdr->mac_time);
+		priv->signal = signal;
+		priv->quality = signal;
+		priv->noise = hdr->noise;
+	} else {
+		struct rtl8187b_rx_hdr *hdr =
+			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
+		flags = le32_to_cpu(hdr->flags);
+		signal = hdr->agc >> 1;
+		rx_status.antenna = (hdr->signal >> 7) & 1;
+		rx_status.signal = 64 - min(hdr->noise, (u8)64);
+		rx_status.noise = hdr->noise;
+		rx_status.mactime = le64_to_cpu(hdr->mac_time);
+		priv->signal = hdr->signal;
+		priv->quality = hdr->agc >> 1;
+		priv->noise = hdr->noise;
+	}
 
-	signal = hdr->agc >> 1;
+	skb_trim(skb, flags & 0x0FFF);
 	rate = (flags >> 20) & 0xF;
 	if (rate > 3) {	/* OFDM rate */
 		if (signal > 90)
@@ -261,13 +316,11 @@ static void rtl8187_rx_cb(struct urb *urb)
 		signal = 95 - signal;
 	}
 
-	rx_status.antenna = (hdr->signal >> 7) & 1;
-	rx_status.qual = 64 - min(hdr->noise, (u8)64);
+	rx_status.qual = priv->quality;
 	rx_status.signal = signal;
 	rx_status.rate_idx = rate;
 	rx_status.freq = dev->conf.channel->center_freq;
 	rx_status.band = dev->conf.channel->band;
-	rx_status.mactime = le64_to_cpu(hdr->mac_time);
 	rx_status.flag |= RX_FLAG_TSFT;
 	if (flags & (1 << 13))
 		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
@@ -307,7 +360,8 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
 			break;
 		}
 		usb_fill_bulk_urb(entry, priv->udev,
-				  usb_rcvbulkpipe(priv->udev, 1),
+				  usb_rcvbulkpipe(priv->udev,
+				  priv->is_rtl8187b ? 3 : 1),
 				  skb_tail_pointer(skb),
 				  RTL8187_MAX_RX, rtl8187_rx_cb, skb);
 		info = (struct rtl8187_rx_info *)skb->cb;
@@ -786,18 +840,20 @@ static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 	msleep(10);
 	rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
 
-	rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
-
-	if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
-		rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
-		rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
-		rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x14);
-		rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0x73);
-	} else {
-		rtl818x_iowrite8(priv, &priv->map->SLOT, 0x14);
-		rtl818x_iowrite8(priv, &priv->map->DIFS, 0x24);
-		rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x24);
-		rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0xa5);
+	if (!priv->is_rtl8187b) {
+		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
+
+		if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
+			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
+			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
+			rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x14);
+			rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0x73);
+		} else {
+			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x14);
+			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x24);
+			rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x24);
+			rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0xa5);
+		}
 	}
 
 	rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);
@@ -813,14 +869,20 @@ static int rtl8187_config_interface(struct ieee80211_hw *dev,
 {
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
+	u8 reg;
 
 	for (i = 0; i < ETH_ALEN; i++)
 		rtl818x_iowrite8(priv, &priv->map->BSSID[i], conf->bssid[i]);
 
-	if (is_valid_ether_addr(conf->bssid))
-		rtl818x_iowrite8(priv, &priv->map->MSR, RTL818X_MSR_INFRA);
-	else
-		rtl818x_iowrite8(priv, &priv->map->MSR, RTL818X_MSR_NO_LINK);
+	if (is_valid_ether_addr(conf->bssid)) {
+		reg = RTL818X_MSR_INFRA;
+		if (priv->is_rtl8187b)
+			reg |= RTL818X_MSR_ENEDCA;
+		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
+	} else {
+		reg = RTL818X_MSR_NO_LINK;
+		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
+	}
 
 	return 0;
 }
@@ -907,6 +969,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	struct rtl8187_priv *priv;
 	struct eeprom_93cx6 eeprom;
 	struct ieee80211_channel *channel;
+	const char *chip_name;
 	u16 txpwr, reg;
 	int err, i;
 	DECLARE_MAC_BUF(mac);
@@ -918,6 +981,8 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	}
 
 	priv = dev->priv;
+	priv->is_rtl8187b = (id->driver_info == DEVICE_RTL8187B) ||
+			    !memcmp(udev->product, "RTL8187B", 8);
 
 	SET_IEEE80211_DEV(dev, &intf->dev);
 	usb_set_intfdata(intf, dev);
@@ -946,8 +1011,13 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_UNSPEC;
-	dev->extra_tx_headroom = sizeof(struct rtl8187_tx_hdr);
-	dev->queues = 1;
+	dev->extra_tx_headroom = (!priv->is_rtl8187b) ?
+				  sizeof(struct rtl8187_tx_hdr) :
+				  sizeof(struct rtl8187b_tx_hdr);
+	if (!priv->is_rtl8187b)
+		dev->queues = 1;
+	else
+		dev->queues = 4;
 	dev->max_signal = 65;
 
 	eeprom.data = dev;
@@ -982,10 +1052,24 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 		(*channel++).hw_value = txpwr & 0xFF;
 		(*channel++).hw_value = txpwr >> 8;
 	}
-	for (i = 0; i < 2; i++) {
-		eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_TXPWR_CHAN_6 + i,
+	if (!priv->is_rtl8187b) {
+		for (i = 0; i < 2; i++) {
+			eeprom_93cx6_read(&eeprom,
+					  RTL8187_EEPROM_TXPWR_CHAN_6 + i,
+					  &txpwr);
+			(*channel++).hw_value = txpwr & 0xFF;
+			(*channel++).hw_value = txpwr >> 8;
+		}
+	} else {
+		eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_TXPWR_CHAN_6,
 				  &txpwr);
 		(*channel++).hw_value = txpwr & 0xFF;
+
+		eeprom_93cx6_read(&eeprom, 0x0A, &txpwr);
+		(*channel++).hw_value = txpwr & 0xFF;
+
+		eeprom_93cx6_read(&eeprom, 0x1C, &txpwr);
+		(*channel++).hw_value = txpwr & 0xFF;
 		(*channel++).hw_value = txpwr >> 8;
 	}
 
@@ -1001,6 +1085,50 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
+	if (!priv->is_rtl8187b) {
+		u32 reg32;
+		reg32 = rtl818x_ioread32(priv, &priv->map->TX_CONF);
+		reg32 &= RTL818X_TX_CONF_HWVER_MASK;
+		switch (reg32) {
+		case RTL818X_TX_CONF_R8187vD_1:
+		case RTL818X_TX_CONF_R8187vD_2:
+			chip_name = "RTL8187vD";
+			break;
+		default:
+			chip_name = "RTL8187vB (default)";
+		}
+       } else {
+		printk(KERN_WARNING "rtl8187: 8187B chip detected. Support "
+			"is EXPERIMENTAL, and could damage your\n"
+			"         hardware, use at your own risk\n");
+		/*
+		 * Force USB request to write radio registers for 8187B, Realtek
+		 * only uses it in their sources
+		 */
+		/*if (priv->asic_rev == 0) {
+			printk(KERN_WARNING "rtl8187: Forcing use of USB "
+			       "requests to write to radio registers\n");
+			priv->asic_rev = 1;
+		}*/
+		switch (rtl818x_ioread8(priv, (u8 *)0xFFE1)) {
+		case RTL818X_R8187B_B:
+			chip_name = "RTL8187BvB";
+			priv->hw_rev = RTL8187BvB;
+			break;
+		case RTL818X_R8187B_D:
+			chip_name = "RTL8187BvD";
+			priv->hw_rev = RTL8187BvD;
+			break;
+		case RTL818X_R8187B_E:
+			chip_name = "RTL8187BvE";
+			priv->hw_rev = RTL8187BvE;
+			break;
+		default:
+			chip_name = "RTL8187BvB (default)";
+			priv->hw_rev = RTL8187BvB;
+		}
+	}
+
 	priv->rf = rtl8187_detect_rf(dev);
 
 	err = ieee80211_register_hw(dev);
@@ -1009,9 +1137,9 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 		goto err_free_dev;
 	}
 
-	printk(KERN_INFO "%s: hwaddr %s, rtl8187 V%d + %s\n",
+	printk(KERN_INFO "%s: hwaddr %s, %s V%d + %s\n",
 	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
-	       priv->asic_rev, priv->rf->name);
+	       chip_name, priv->asic_rev, priv->rf->name);
 
 	return 0;
 
-- 
1.5.5.1

