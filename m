Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:57853 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754038AbXDTNrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2007 09:47:24 -0400
Date: Fri, 20 Apr 2007 15:46:06 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Andrea Merello <andreamrl@tiscali.it>,
	linux-wireless@vger.kernel.org
Subject: [PATCH #2] rtl818x-mac80211: fix coding style
Message-ID: <20070420154606.1796014e@localhost>
In-Reply-To: <200704200907.13916.flamingice@sourmilk.net>
References: <20070420004258.23848470@localhost>
	<200704191923.31674.flamingice@sourmilk.net>
	<20070420090218.5a51d363@localhost>
	<200704200907.13916.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix coding style.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl8187.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rtl818x/rtl8187.h
+++ wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl8187.h
@@ -68,7 +68,7 @@ static inline u8 rtl818x_ioread8(struct 
 
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, 0, &val, sizeof(val), HZ/2);
+			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
 
 	return val;
 }
@@ -79,7 +79,7 @@ static inline u8 rtl818x_ioread16(struct
 
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, 0, &val, sizeof(val), HZ/2);
+			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
 
 	return le16_to_cpu(val);
 }
@@ -90,7 +90,7 @@ static inline u8 rtl818x_ioread32(struct
 
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, 0, &val, sizeof(val), HZ/2);
+			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
 
 	return le32_to_cpu(val);
 }
@@ -100,7 +100,7 @@ static inline void rtl818x_iowrite8(stru
 {
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, 0, &val, sizeof(val), HZ/2);
+			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
 }
 
 static inline void rtl818x_iowrite16(struct rtl8187_priv *priv,
@@ -110,7 +110,7 @@ static inline void rtl818x_iowrite16(str
 
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, 0, &buf, sizeof(buf), HZ/2);
+			(unsigned long)addr, 0, &buf, sizeof(buf), HZ / 2);
 }
 
 static inline void rtl818x_iowrite32(struct rtl8187_priv *priv,
@@ -120,7 +120,7 @@ static inline void rtl818x_iowrite32(str
 
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, 0, &buf, sizeof(buf), HZ/2);
+			(unsigned long)addr, 0, &buf, sizeof(buf), HZ / 2);
 }
 
 #endif /* RTL8187_H */
Index: wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c
+++ wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c
@@ -58,9 +58,9 @@ void rtl8187_write_phy(struct ieee80211_
 
 static void rtl8187_tx_cb(struct urb *urb)
 {
-	struct ieee80211_tx_status status = {{0}};
+	struct ieee80211_tx_status status = { {0} };
 	struct sk_buff *skb = (struct sk_buff *)urb->context;
-	struct rtl8187_tx_info *info = (struct rtl8187_tx_info *) skb->cb;
+	struct rtl8187_tx_info *info = (struct rtl8187_tx_info *)skb->cb;
 
 	usb_free_urb(info->urb);
 	if (info->control)
@@ -88,30 +88,30 @@ static int rtl8187_tx(struct ieee80211_h
 	}
 
 	if (ieee80211_get_hdrlen_from_skb(skb) >= 24) {
-		ieeehdr = (struct ieee80211_hdr *) skb->data;
+		ieeehdr = (struct ieee80211_hdr *)skb->data;
 		ieeehdr->seq_ctrl = cpu_to_le16(priv->seq_counter);
 		priv->seq_counter += 0x10;
 		priv->seq_counter &= IEEE80211_SCTL_SEQ;
 	}
 
-	hdr = (struct rtl8187_tx_hdr *) skb_push(skb, sizeof(*hdr));
+	hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
 	tmp = skb->len - sizeof(*hdr);
 	tmp |= RTL8187_TX_FLAG_NO_ENCRYPT;
 	tmp |= control->rts_cts_rate << 19;
 	tmp |= control->tx_rate << 24;
-	if(ieee80211_get_morefrag((struct ieee80211_hdr  *)skb))
+	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb))
 		tmp |= RTL8187_TX_FLAG_MORE_FRAG;
-	if(control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
+	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
 		tmp |= RTL8187_TX_FLAG_RTS;
-	if(control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
 		tmp |= RTL8187_TX_FLAG_CTS;
 	hdr->flags = cpu_to_le32(tmp);
-	hdr->rts_duration = 0;	/* TODO : follow RTL sample */
+	hdr->rts_duration = 0;	/* TODO: follow RTL sample */
 	hdr->len = 0;
 	tmp = control->retry_limit << 8;
 	hdr->retry = cpu_to_le32(tmp);
 
-	info = (struct rtl8187_tx_info *) skb->cb;
+	info = (struct rtl8187_tx_info *)skb->cb;
 	info->control = kmemdup(control, sizeof(*control), GFP_ATOMIC);
 	info->urb = urb;
 	info->dev = dev;
@@ -122,15 +122,14 @@ static int rtl8187_tx(struct ieee80211_h
 	return 0;
 }
 
-
 static void rtl8187_rx_cb(struct urb *urb)
 {
-	struct sk_buff *skb = (struct sk_buff *) urb->context;
+	struct sk_buff *skb = (struct sk_buff *)urb->context;
 	struct rtl8187_rx_info *info = (struct rtl8187_rx_info *)skb->cb;
 	struct ieee80211_hw *dev = info->dev;
 	struct rtl8187_priv *priv = dev->priv;
 	struct rtl8187_rx_hdr *hdr;
-	struct ieee80211_rx_status rx_status = {0};
+	struct ieee80211_rx_status rx_status = { 0 };
 	int rate, signal;
 
 	if (unlikely(urb->status)) {
@@ -141,18 +140,18 @@ static void rtl8187_rx_cb(struct urb *ur
 
 	skb_unlink(skb, &priv->rx_queue);
 	skb_put(skb, urb->actual_length);
-	hdr = (struct rtl8187_rx_hdr *) (skb->tail - sizeof(*hdr));
+	hdr = (struct rtl8187_rx_hdr *)(skb->tail - sizeof(*hdr));
 	skb_trim(skb, le16_to_cpu(hdr->len) & 0x0FFF);
 
 	signal = hdr->agc >> 1;
 	rate = (le16_to_cpu(hdr->rate) >> 4) & 0xF;
-	if (rate > 3) {	// OFDM rate.
+	if (rate > 3) {	/* OFDM rate */
 		if (signal > 90)
 			signal = 90;
 		else if (signal < 25)
 			signal = 25;
 		signal = 90 - signal;
-	} else {	// CCK rate.
+	} else {	/* CCK rate */
 		if (signal > 95)
 			signal = 95;
 		else if (signal < 30)
@@ -177,7 +176,7 @@ static void rtl8187_rx_cb(struct urb *ur
 		return;
 	}
 
-	info = (struct rtl8187_rx_info *) skb->cb;
+	info = (struct rtl8187_rx_info *)skb->cb;
 	info->urb = urb;
 	info->dev = dev;
 	urb->transfer_buffer = skb->tail;
@@ -206,7 +205,7 @@ static int rtl8187_init_urbs(struct ieee
 		usb_fill_bulk_urb(entry, priv->udev,
 				  usb_rcvbulkpipe(priv->udev, 1), skb->tail,
 				  RTL8187_MAX_RX, rtl8187_rx_cb, skb);
-		info = (struct rtl8187_rx_info *) skb->cb;
+		info = (struct rtl8187_rx_info *)skb->cb;
 		info->urb = entry;
 		info->dev = dev;
 		skb_queue_tail(&priv->rx_queue, skb);
@@ -246,9 +245,9 @@ static int rtl8187_init_hw(struct ieee80
 
 	mdelay(200);
 
-	// check success of reset
+	/* check success of reset */
 	if (rtl818x_ioread8(priv, &priv->map->CMD) & RTL818X_CMD_RESET) {
-		printk(KERN_ERR "rtl8187: reset timeout!\n");
+		printk(KERN_ERR "rtl8187: Reset timeout!\n");
 		return -ETIMEDOUT;
 	}
 
@@ -291,7 +290,7 @@ static int rtl8187_init_hw(struct ieee80
 	rtl818x_iowrite8(priv, &priv->map->RESP_RATE, (8 << 4) | 0);
 	rtl818x_iowrite16(priv, &priv->map->BRSR, 0x01F3);
 
-	// ehh?
+	// FIXME: ehh?
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
@@ -300,7 +299,7 @@ static int rtl8187_init_hw(struct ieee80
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
-	// host_usb_init
+	/* host_usb_init */
 	rtl818x_iowrite8(priv, (u8 *)0xFF85, 0);
 	rtl818x_iowrite8(priv, &priv->map->GPIO, 0);
 	reg = rtl818x_ioread8(priv, (u8 *)0xFE53);
@@ -367,18 +366,18 @@ static int rtl8187_open(struct ieee80211
 
 	rtl8187_init_urbs(dev);
 
-	reg  = RTL818X_RX_CONF_ONLYERLPKT |
-	       RTL818X_RX_CONF_RX_AUTORESETPHY |
-	       RTL818X_RX_CONF_BSSID |
-	       RTL818X_RX_CONF_MGMT |
-	       RTL818X_RX_CONF_CTRL |
-	       RTL818X_RX_CONF_DATA |
-	       (7 << 13 /* RX FIFO threshold NONE */) |
-	       (7 << 10 /* MAX RX DMA */) |
-	       RTL818X_RX_CONF_BROADCAST |
-	       RTL818X_RX_CONF_MULTICAST |
-	       RTL818X_RX_CONF_NICMAC;
-	if(priv->mode == IEEE80211_IF_TYPE_MNTR)
+	reg = RTL818X_RX_CONF_ONLYERLPKT |
+	      RTL818X_RX_CONF_RX_AUTORESETPHY |
+	      RTL818X_RX_CONF_BSSID |
+	      RTL818X_RX_CONF_MGMT |
+	      RTL818X_RX_CONF_CTRL |
+	      RTL818X_RX_CONF_DATA |
+	      (7 << 13 /* RX FIFO threshold NONE */) |
+	      (7 << 10 /* MAX RX DMA */) |
+	      RTL818X_RX_CONF_BROADCAST |
+	      RTL818X_RX_CONF_MULTICAST |
+	      RTL818X_RX_CONF_NICMAC;
+	if (priv->mode == IEEE80211_IF_TYPE_MNTR)
 		reg |= RTL818X_RX_CONF_MONITOR;
 
 	rtl818x_iowrite32(priv, &priv->map->RX_CONF, reg);
@@ -429,7 +428,7 @@ static int rtl8187_stop(struct ieee80211
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
 	while ((skb = skb_dequeue(&priv->rx_queue))) {
-		info = (struct rtl8187_rx_info *) skb->cb;
+		info = (struct rtl8187_rx_info *)skb->cb;
 		if (!info->urb)
 			continue;
 
@@ -590,7 +589,7 @@ static int __devinit rtl8187_probe(struc
 	skb_queue_head_init(&priv->rx_queue);
 	memcpy(priv->channels, rtl818x_channels, sizeof(rtl818x_channels));
 	memcpy(priv->rates, rtl818x_rates, sizeof(rtl818x_rates));
-	priv->map = (struct rtl818x_csr __iomem *) 0xFF00;
+	priv->map = (struct rtl818x_csr __iomem *)0xFF00;
 	priv->modes[0].mode = MODE_IEEE80211G;
 	priv->modes[0].num_rates = ARRAY_SIZE(rtl818x_rates);
 	priv->modes[0].rates = priv->rates;
@@ -628,7 +627,7 @@ static int __devinit rtl8187_probe(struc
 
 	eeprom_93cx6_multiread(&eeprom, 0x7, dev->wiphy->perm_addr, 3);
 	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
-		printk(KERN_WARNING "rtl8187: Invalid hwaddr! Using randomly generated MAC addr\n");
+		printk(KERN_WARNING "rtl8187: Invalid hwaddr! Using randomly generated MAC address\n");
 		random_ether_addr(dev->wiphy->perm_addr);
 	}
 
@@ -662,8 +661,7 @@ static int __devinit rtl8187_probe(struc
 
 	rtl8225_write(dev, 0, 0x1B7);
 
-	if (rtl8225_read(dev, 8) != 0x588 ||
-	    rtl8225_read(dev, 9) != 0x700)
+	if (rtl8225_read(dev, 8) != 0x588 || rtl8225_read(dev, 9) != 0x700)
 		priv->rf_init = rtl8225_rf_init;
 	else
 		priv->rf_init = rtl8225z2_rf_init;
Index: wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c
+++ wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c
@@ -45,7 +45,7 @@ void rtl8225_write_bitbang(struct ieee80
 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80);
 	udelay(10);
 
-	for(i = 15; i >= 0; i--){
+	for (i = 15; i >= 0; i--) {
 		u16 reg = reg80 | (bangdata & (1 << i)) >> i;
 
 		if (i & 1)
@@ -104,7 +104,7 @@ void rtl8225_write(struct ieee80211_hw *
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	if(priv->asic_rev)
+	if (priv->asic_rev)
 		rtl8225_write_8051(dev, addr, data);
 	else
 		rtl8225_write_bitbang(dev, addr, data);
@@ -230,13 +230,13 @@ static const u8 rtl8225_agc[] = {
 };
 
 static const u8 rtl8225_gain[] = {
-	0x23, 0x88, 0x7c, 0xa5,// -82dbm
-	0x23, 0x88, 0x7c, 0xb5,// -82dbm
-	0x23, 0x88, 0x7c, 0xc5,// -82dbm
-	0x33, 0x80, 0x79, 0xc5,// -78dbm
-	0x43, 0x78, 0x76, 0xc5,// -74dbm
-	0x53, 0x60, 0x73, 0xc5,// -70dbm
-	0x63, 0x58, 0x70, 0xc5,// -66dbm
+	0x23, 0x88, 0x7c, 0xa5,	/* -82dBm */
+	0x23, 0x88, 0x7c, 0xb5,	/* -82dBm */
+	0x23, 0x88, 0x7c, 0xc5,	/* -82dBm */
+	0x33, 0x80, 0x79, 0xc5,	/* -78dBm */
+	0x43, 0x78, 0x76, 0xc5,	/* -74dBm */
+	0x53, 0x60, 0x73, 0xc5,	/* -70dBm */
+	0x63, 0x58, 0x70, 0xc5,	/* -66dBm */
 };
 
 static const u8 rtl8225_threshold[] = {
@@ -301,7 +301,7 @@ static void rtl8225_rf_set_tx_power(stru
 
 	mdelay(1); // FIXME: optional?
 
-	// anaparam2 on
+	/* anaparam2 on */
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
@@ -314,7 +314,7 @@ static void rtl8225_rf_set_tx_power(stru
 	rtl8225_write_phy_ofdm(dev, 8, 0x00);
 
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM,
-			 rtl8225_tx_gain_cck_ofdm[ofdm_power/6] >> 1);
+			 rtl8225_tx_gain_cck_ofdm[ofdm_power / 6] >> 1);
 
 	tmp = &rtl8225_tx_power_ofdm[ofdm_power % 6];
 
@@ -349,14 +349,14 @@ void rtl8225_rf_init(struct ieee80211_hw
 	rtl8225_write(dev, 0x2, 0xC4D); mdelay(200);
 	rtl8225_write(dev, 0x2, 0x44D); mdelay(200);
 
-	if (!(rtl8225_read(dev, 6) & (1 << 7))){
+	if (!(rtl8225_read(dev, 6) & (1 << 7))) {
 		rtl8225_write(dev, 0x02, 0x0c4d);
 		mdelay(200);
 		rtl8225_write(dev, 0x02, 0x044d);
 		mdelay(100);
 		if (!(rtl8225_read(dev, 6) & (1 << 7)))
-			printk("RF Calibration Failed!!!! %x\n",
-				rtl8225_read(dev, 6));
+			printk("rtl8187: RF Calibration Failed! %x\n",
+			       rtl8225_read(dev, 6));
 	}
 
 	rtl8225_write(dev, 0x0, 0x127);
@@ -453,15 +453,15 @@ void rtl8225_rf_init(struct ieee80211_hw
 
 	rtl8225_rf_set_tx_power(dev, 1);
 
-	// RX antenna default to A
-	rtl8225_write_phy_cck(dev, 0x10, 0x9b); mdelay(1);	// B: 0xDB
-	rtl8225_write_phy_ofdm(dev, 0x26, 0x90); mdelay(1);	// B: 0x10
+	/* RX antenna default to A */
+	rtl8225_write_phy_cck(dev, 0x10, 0x9b); mdelay(1);	/* B: 0xDB */
+	rtl8225_write_phy_ofdm(dev, 0x26, 0x90); mdelay(1);	/* B: 0x10 */
 
-	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);	// B: 0x00
+	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);	/* B: 0x00 */
 	mdelay(1);
 	rtl818x_iowrite32(priv, (__le32 *)0xFF94, 0x3dc00002);
 
-	// set sensitivity
+	/* set sensitivity */
 	rtl8225_write(dev, 0x0c, 0x50);
 	rtl8225_write_phy_ofdm(dev, 0x0d, rtl8225_gain[2 * 4]);
 	rtl8225_write_phy_ofdm(dev, 0x1b, rtl8225_gain[2 * 4 + 2]);
@@ -470,7 +470,6 @@ void rtl8225_rf_init(struct ieee80211_hw
 	rtl8225_write_phy_cck(dev, 0x41, rtl8225_threshold[2]);
 }
 
-
 static const u8 rtl8225z2_tx_power_cck_ch14[] = {
 	0x36, 0x35, 0x2e, 0x1b, 0x00, 0x00, 0x00, 0x00
 };
@@ -523,7 +522,7 @@ static void rtl8225z2_rf_set_tx_power(st
 			 rtl8225z2_tx_gain_cck_ofdm[cck_power]);
 	mdelay(1);
 
-	// anaparam2 on
+	/* anaparam2 on */
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
@@ -558,13 +557,13 @@ static const u16 rtl8225z2_rxgain[] = {
 };
 
 static const u8 rtl8225z2_gain_bg[] = {
-	0x23, 0x15, 0xa5, // -82-1dBm
-	0x23, 0x15, 0xb5, // -82-2dBm
-	0x23, 0x15, 0xc5, // -82-3dBm
-	0x33, 0x15, 0xc5, // -78dBm
-	0x43, 0x15, 0xc5, // -74dBm
-	0x53, 0x15, 0xc5, // -70dBm
-	0x63, 0x15, 0xc5  // -66dBm
+	0x23, 0x15, 0xa5, /* -82-1dBm */
+	0x23, 0x15, 0xb5, /* -82-2dBm */
+	0x23, 0x15, 0xc5, /* -82-3dBm */
+	0x33, 0x15, 0xc5, /* -78dBm */
+	0x43, 0x15, 0xc5, /* -74dBm */
+	0x53, 0x15, 0xc5, /* -70dBm */
+	0x63, 0x15, 0xc5  /* -66dBm */
 };
 
 void rtl8225z2_rf_init(struct ieee80211_hw *dev)
@@ -611,8 +610,8 @@ void rtl8225z2_rf_init(struct ieee80211_
 		rtl8225_write(dev, 0x02, 0x044D);
 		mdelay(100);
 		if (!(rtl8225_read(dev, 6) & (1 << 7)))
-			printk("RF Calibration Failed!!!! %x\n",
-				rtl8225_read(dev, 6));
+			printk("rtl8187: RF Calibration Failed! %x\n",
+			       rtl8225_read(dev, 6));
 	}
 
 	mdelay(200);
@@ -706,11 +705,11 @@ void rtl8225z2_rf_init(struct ieee80211_
 
 	rtl8225z2_rf_set_tx_power(dev, 1);
 
-	// RX antenna default to A
-	rtl8225_write_phy_cck(dev, 0x10, 0x9b); mdelay(1);	// B: 0xDB
-	rtl8225_write_phy_ofdm(dev, 0x26, 0x90); mdelay(1);	// B: 0x10
+	/* RX antenna default to A */
+	rtl8225_write_phy_cck(dev, 0x10, 0x9b); mdelay(1);	/* B: 0xDB */
+	rtl8225_write_phy_ofdm(dev, 0x26, 0x90); mdelay(1);	/* B: 0x10 */
 
-	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);	// B: 0x00
+	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);	/* B: 0x00 */
 	mdelay(1);
 	rtl818x_iowrite32(priv, (__le32 *)0xFF94, 0x3dc00002);
 }
@@ -743,5 +742,3 @@ void rtl8225_rf_set_channel(struct ieee8
 	rtl8225_write(dev, 0x7, rtl8225_chan[channel - 1]);
 	mdelay(10);
 }
-
-
Index: wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl818x.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rtl818x/rtl818x.h
+++ wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl818x.h
@@ -105,7 +105,7 @@ struct rtl818x_csr {
 	u8	reserved_17[32];
 	u16	TALLY_CNT;
 	u8	TALLY_SEL;
-} __attribute__ ((packed));
+} __attribute__((packed));
 
 static const struct ieee80211_rate rtl818x_rates[] = {
 	{ .rate = 10,
