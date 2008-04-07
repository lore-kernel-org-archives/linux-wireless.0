Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:60100 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbYDGMBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 08:01:19 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] rtl8187b work in progress...
Date: Mon, 7 Apr 2008 09:01:14 -0300
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
References: <pan.2008.04.01.18.07.31.772700@gimpelevich.san-francisco.ca.us> <200804041107.59990.herton@mandriva.com.br> <1207322276.2157.4.camel@dv>
In-Reply-To: <1207322276.2157.4.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804070901.14975.herton@mandriva.com.br> (sfid-20080407_130127_672540_91EA10A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Friday 04 April 2008 12:17:56 Pavel Roskin escreveu:
> On Fri, 2008-04-04 at 11:07 -0300, Herton Ronaldo Krzesinski wrote:
> > Yes, I will later do a patch against linux-wireless, I only posted it as
> > a work in progress. But before I post an updated patch I want to fix it
> > first to use changes made by John (like not duplicating the functions
> > etc.) and there is another fundamental problem that I must first fix: it
> > works and scans for aps, but for some reason I don't get authentication
> > from access point (while normal 8187 gets data with IEEE80211_STYPE_AUTH
> > in 8187b for some reason don't...).
>
> It may be useful to check if the AP is sending that packet.  If it does,
> I would check the rate and the channel and compare them to the packets
> the driver can receive.  I would also check the driver with another AP.
> If it's indeed on the receiving side of the driver, a crosscheck against
> the softmac driver could be helpful.
>
> Good luck fixing it, but if it still doesn't work, I'd like to see your
> patch posted anyway.

I finally made it work \o/, I missed that for rtl8187b you must choose another
endpoint for usb_sndbulkpipe in tx code. Soon I'll make a proper patch and
cleanups (alongside with more checks, removing debugging I placed etc.), for
now just the latest patch just to show latest updates, I still need to integrate
with John's patch and cleanup and do it against linux-wireless git repository:

--- ./rtl8187_rtl8225.h.orig	2007-09-03 05:16:32.000000000 -0300
+++ ./rtl8187_rtl8225.h	2007-09-05 09:02:48.000000000 -0300
@@ -24,7 +24,11 @@ void rtl8225_write(struct ieee80211_hw *
 u16  rtl8225_read(struct ieee80211_hw *, u8 addr);
 
 void rtl8225_rf_init(struct ieee80211_hw *);
-void rtl8225z2_rf_init(struct ieee80211_hw *);
+void rtl8225z2_8187_rf_init(struct ieee80211_hw *);
+void rtl8225z2_8187b_rf_init(struct ieee80211_hw *);
+void rtl8225_rf_set_tx_power(struct ieee80211_hw *, int);
+void rtl8225z2_8187_rf_set_tx_power(struct ieee80211_hw *, int);
+void rtl8225z2_8187b_rf_set_tx_power(struct ieee80211_hw *, int);
 void rtl8225_rf_stop(struct ieee80211_hw *);
 void rtl8225_rf_set_channel(struct ieee80211_hw *, int);
 
--- ./rtl818x.h.orig	2007-09-02 03:12:55.000000000 -0300
+++ ./rtl818x.h	2007-09-11 08:24:58.045841828 -0300
@@ -16,30 +16,30 @@
 #define RTL818X_H
 
 struct rtl818x_csr {
-	u8	MAC[6];
-	u8	reserved_0[2];
-	__le32	MAR[2];
-	u8	RX_FIFO_COUNT;
-	u8	reserved_1;
-	u8	TX_FIFO_COUNT;
-	u8	BQREQ;
-	u8	reserved_2[4];
-	__le32	TSFT[2];
-	__le32	TLPDA;
-	__le32	TNPDA;
-	__le32	THPDA;
-	__le16	BRSR;
-	u8	BSSID[6];
-	u8	RESP_RATE;
-	u8	EIFS;
-	u8	reserved_3[1];
-	u8	CMD;
+	u8	MAC[6];        // 00
+	u8	reserved_0[2]; // 06
+	__le32	MAR[2];        // 08
+	u8	RX_FIFO_COUNT; // 10
+	u8	reserved_1;    // 11
+	u8	TX_FIFO_COUNT; // 12
+	u8	BQREQ;         // 13
+	u8	reserved_2[4]; // 14
+	__le32	TSFT[2];       // 18
+	__le32	TLPDA;         // 20
+	__le32	TNPDA;         // 24
+	__le32	THPDA;         // 28
+	__le16	BRSR;          // 2C
+	u8	BSSID[6];      // 2E
+	u8	RESP_RATE;     // 34
+	u8	EIFS;          // 35
+	u8	reserved_3[1]; // 36
+	u8	CMD;           // 37
 #define RTL818X_CMD_TX_ENABLE		(1 << 2)
 #define RTL818X_CMD_RX_ENABLE		(1 << 3)
 #define RTL818X_CMD_RESET		(1 << 4)
-	u8	reserved_4[4];
-	__le16	INT_MASK;
-	__le16	INT_STATUS;
+	u8	reserved_4[4]; // 38
+	__le16	INT_MASK;      // 3C
+	__le16	INT_STATUS;    // 3E
 #define RTL818X_INT_RX_OK		(1 <<  0)
 #define RTL818X_INT_RX_ERR		(1 <<  1)
 #define RTL818X_INT_TXL_OK		(1 <<  2)
@@ -56,17 +56,22 @@ struct rtl818x_csr {
 #define RTL818X_INT_BEACON		(1 << 13)
 #define RTL818X_INT_TIME_OUT		(1 << 14)
 #define RTL818X_INT_TX_FO		(1 << 15)
-	__le32	TX_CONF;
+	__le32	TX_CONF;       // 40
 #define RTL818X_TX_CONF_LOOPBACK_MAC	(1 << 17)
 #define RTL818X_TX_CONF_NO_ICV		(1 << 19)
 #define RTL818X_TX_CONF_DISCW		(1 << 20)
+#define RTL818X_TX_CONF_MAXDMA_2048	(7 << 21)
 #define RTL818X_TX_CONF_R8180_ABCD	(2 << 25)
 #define RTL818X_TX_CONF_R8180_F		(3 << 25)
 #define RTL818X_TX_CONF_R8185_ABC	(4 << 25)
 #define RTL818X_TX_CONF_R8185_D		(5 << 25)
+#define RTL818X_TX_CONF_R8187_5 	(5 << 25)
+#define RTL818X_TX_CONF_R8187_6 	(6 << 25)
 #define RTL818X_TX_CONF_HWVER_MASK	(7 << 25)
+#define RTL818X_TX_CONF_DISREQQSIZE	(1 << 28)
+#define RTL818X_TX_CONF_DURPROCMODE	(1 << 30)
 #define RTL818X_TX_CONF_CW_MIN		(1 << 31)
-	__le32	RX_CONF;
+	__le32	RX_CONF;       // 44
 #define RTL818X_RX_CONF_MONITOR		(1 <<  0)
 #define RTL818X_RX_CONF_NICMAC		(1 <<  1)
 #define RTL818X_RX_CONF_MULTICAST	(1 <<  2)
@@ -78,9 +83,9 @@ struct rtl818x_csr {
 #define RTL818X_RX_CONF_BSSID		(1 << 23)
 #define RTL818X_RX_CONF_RX_AUTORESETPHY	(1 << 28)
 #define RTL818X_RX_CONF_ONLYERLPKT	(1 << 31)
-	__le32	INT_TIMEOUT;
-	__le32	TBDA;
-	u8	EEPROM_CMD;
+	__le32	INT_TIMEOUT;   // 48
+	__le32	TBDA;          // 4C
+	u8	EEPROM_CMD;    // 50
 #define RTL818X_EEPROM_CMD_READ		(1 << 0)
 #define RTL818X_EEPROM_CMD_WRITE	(1 << 1)
 #define RTL818X_EEPROM_CMD_CK		(1 << 2)
@@ -89,69 +94,77 @@ struct rtl818x_csr {
 #define RTL818X_EEPROM_CMD_LOAD		(1 << 6)
 #define RTL818X_EEPROM_CMD_PROGRAM	(2 << 6)
 #define RTL818X_EEPROM_CMD_CONFIG	(3 << 6)
-	u8	CONFIG0;
-	u8	CONFIG1;
-	u8	CONFIG2;
-	__le32	ANAPARAM;
-	u8	MSR;
+	u8	CONFIG0;       // 51
+	u8	CONFIG1;       // 52
+	u8	CONFIG2;       // 53
+	__le32	ANAPARAM;      // 54
+	u8	MSR;           // 58
 #define RTL818X_MSR_NO_LINK		(0 << 2)
 #define RTL818X_MSR_ADHOC		(1 << 2)
 #define RTL818X_MSR_INFRA		(2 << 2)
-	u8	CONFIG3;
+#define RTL818X_MSR_MASTER		(3 << 2)
+//TODO: use (4 << 2)
+#define RTL818X_MSR_ENEDCA		(1 << 4)
+//#define RTL818X_MSR_ENEDCA		(4 << 2)
+	u8	CONFIG3;       // 59
 #define RTL818X_CONFIG3_ANAPARAM_WRITE	(1 << 6)
-	u8	CONFIG4;
+#define RTL818X_CONFIG3_GNT_SELECT	(1 << 7)
+	u8	CONFIG4;       // 5A
 #define RTL818X_CONFIG4_POWEROFF	(1 << 6)
 #define RTL818X_CONFIG4_VCOOFF		(1 << 7)
-	u8	TESTR;
-	u8	reserved_9[2];
-	__le16	PGSELECT;
-	__le32	ANAPARAM2;
-	u8	reserved_10[12];
-	__le16	BEACON_INTERVAL;
-	__le16	ATIM_WND;
-	__le16	BEACON_INTERVAL_TIME;
-	__le16	ATIMTR_INTERVAL;
-	u8	reserved_11[4];
-	u8	PHY[4];
-	__le16	RFPinsOutput;
-	__le16	RFPinsEnable;
-	__le16	RFPinsSelect;
-	__le16	RFPinsInput;
-	__le32	RF_PARA;
-	__le32	RF_TIMING;
-	u8	GP_ENABLE;
-	u8	GPIO;
-	u8	reserved_12[10];
-	u8	TX_AGC_CTL;
+	u8	TESTR;         // 5B
+	u8	reserved_9[2]; // 5C
+	__le16	PGSELECT;      // 5E
+	__le32	ANAPARAM2;     // 60
+	u8	reserved_10[12]; // 64
+	__le16	BEACON_INTERVAL; // 70
+	__le16	ATIM_WND;        // 72
+	__le16	BEACON_INTERVAL_TIME; // 74
+	__le16	ATIMTR_INTERVAL;      // 76
+	u8	reserved_11[4];       // 78
+	u8	PHY[4];               // 7C
+	__le16	RFPinsOutput;         // 80
+	__le16	RFPinsEnable;         // 82
+	__le16	RFPinsSelect;         // 84
+	__le16	RFPinsInput;          // 86
+	__le32	RF_PARA;              // 88
+	__le32	RF_TIMING;            // 8C
+	u8	GP_ENABLE;            // 90
+	u8	GPIO;                 // 91
+	u8	reserved_12[10];      // 92
+	u8	TX_AGC_CTL;           // 9C
 #define RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT		(1 << 0)
 #define RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT	(1 << 1)
 #define RTL818X_TX_AGC_CTL_FEEDBACK_ANT			(1 << 2)
-	u8	TX_GAIN_CCK;
-	u8	TX_GAIN_OFDM;
-	u8	TX_ANTENNA;
-	u8	reserved_13[16];
-	u8	WPA_CONF;
-	u8	reserved_14[3];
-	u8	SIFS;
-	u8	DIFS;
-	u8	SLOT;
-	u8	reserved_15[5];
-	u8	CW_CONF;
+	u8	TX_GAIN_CCK;          // 9D
+	u8	TX_GAIN_OFDM;         // 9E
+	u8	TX_ANTENNA;           // 9F
+	u8	reserved_13[16];      // A0
+	u8	WPA_CONF;             // B0
+	u8	reserved_14[3];       // B1
+	u8	SIFS;                 // B4
+	u8	DIFS;                 // B5
+	u8	SLOT;                 // B6
+	u8	reserved_15[5];       // B7
+	u8	CW_CONF;              // BC
 #define RTL818X_CW_CONF_PERPACKET_CW_SHIFT	(1 << 0)
 #define RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT	(1 << 1)
-	u8	CW_VAL;
-	u8	RATE_FALLBACK;
-	u8	reserved_16[25];
-	u8	CONFIG5;
-	u8	TX_DMA_POLLING;
-	u8	reserved_17[2];
-	__le16	CWR;
-	u8	RETRY_CTR;
-	u8	reserved_18[5];
-	__le32	RDSAR;
-	u8	reserved_19[18];
-	u16	TALLY_CNT;
-	u8	TALLY_SEL;
+	u8	CW_VAL;               // BD
+	u8	RATE_FALLBACK;        // BE
+	u8	reserved_16[25];      // BF
+	u8	CONFIG5;              // D8
+	u8	TX_DMA_POLLING;       // D9
+	u8	reserved_17[2];       // DA
+	__le16	CWR;                  // DC
+	u8	RETRY_CTR;            // DE
+	u8	reserved_18[5];       // DF
+#define RTL818X_TX_CONF_R8187B_B	0
+#define RTL818X_TX_CONF_R8187B_D	1
+#define RTL818X_TX_CONF_R8187B_E	2
+	__le32	RDSAR;                // E4
+	u8	reserved_19[18];      // E8
+	u16	TALLY_CNT;            // FA
+	u8	TALLY_SEL;            // FC
 } __attribute__((packed));
 
 static const struct ieee80211_rate rtl818x_rates[] = {
--- ./rtl8187_dev.c.orig	2007-09-01 04:02:22.000000000 -0300
+++ ./rtl8187_dev.c	2007-09-11 16:51:39.127839696 -0300
@@ -32,14 +32,15 @@ MODULE_LICENSE("GPL");
 
 static struct usb_device_id rtl8187_table[] __devinitdata = {
 	/* Realtek */
-	{USB_DEVICE(0x0bda, 0x8187)},
+	{USB_DEVICE(0x0bda, 0x8187), .driver_info = RTL8187},
+	{USB_DEVICE(0x0bda, 0x8189), .driver_info = RTL8187B},
 	/* Netgear */
-	{USB_DEVICE(0x0846, 0x6100)},
-	{USB_DEVICE(0x0846, 0x6a00)},
+	{USB_DEVICE(0x0846, 0x6100), .driver_info = RTL8187},
+	{USB_DEVICE(0x0846, 0x6a00), .driver_info = RTL8187},
 	/* HP */
-	{USB_DEVICE(0x03f0, 0xca02)},
+	{USB_DEVICE(0x03f0, 0xca02), .driver_info = RTL8187},
 	/* Sitecom */
-	{USB_DEVICE(0x0df6, 0x000d)},
+	{USB_DEVICE(0x0df6, 0x000d), .driver_info = RTL8187},
 	{}
 };
 
@@ -126,8 +127,24 @@ static void rtl8187_tx_cb(struct urb *ur
 	ieee80211_tx_status_irqsafe(info->dev, skb, &status);
 }
 
-static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
-		      struct ieee80211_tx_control *control)
+//TODO: don't duplicate function
+static void rtl8187b_tx_cb(struct urb *urb)
+{
+	struct ieee80211_tx_status status = { {0} };
+	struct sk_buff *skb = (struct sk_buff *)urb->context;
+	struct rtl8187_tx_info *info = (struct rtl8187_tx_info *)skb->cb;
+
+	usb_free_urb(info->urb);
+	if (info->control)
+		memcpy(&status.control, info->control, sizeof(status.control));
+	kfree(info->control);
+	skb_pull(skb, sizeof(struct rtl8187b_tx_hdr));
+	status.flags |= IEEE80211_TX_STATUS_ACK;
+	ieee80211_tx_status_irqsafe(info->dev, skb, &status);
+}
+
+static int r8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
+		    struct ieee80211_tx_control *control)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	struct rtl8187_tx_hdr *hdr;
@@ -144,6 +161,7 @@ static int rtl8187_tx(struct ieee80211_h
 
 	flags = skb->len;
 	flags |= RTL8187_TX_FLAG_NO_ENCRYPT;
+	// TODO: SHORT_PREAMBLE == (1 << 16)?
 	flags |= control->tx_rate << 24;
 
 	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb->data))
@@ -158,6 +176,8 @@ static int rtl8187_tx(struct ieee80211_h
 		flags |= control->rts_cts_rate << 19;
 	}
 
+
+
 	hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
 	hdr->flags = cpu_to_le32(flags);
 	hdr->len = 0;
@@ -175,6 +195,75 @@ static int rtl8187_tx(struct ieee80211_h
 	return 0;
 }
 
+static int r8187b_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
+		     struct ieee80211_tx_control *control)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	struct rtl8187b_tx_hdr *hdr;
+	struct rtl8187_tx_info *info;
+	struct urb *urb;
+	__le16 rts_dur = 0;
+	u32 flags;
+	unsigned int ep[4] = { 6, 7, 5, 4 };
+
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!urb) {
+		kfree_skb(skb);
+		return 0;
+	}
+
+	flags = skb->len;
+	flags |= RTL8187_TX_FLAG_NO_ENCRYPT;
+	// TODO: SHORT_PREAMBLE == (1 << 16)?
+	flags |= control->tx_rate << 24;
+
+	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb->data))
+		flags |= RTL8187_TX_FLAG_MORE_FRAG;
+	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+		flags |= RTL8187_TX_FLAG_RTS;
+		flags |= control->rts_cts_rate << 19;
+		rts_dur = ieee80211_rts_duration(dev, priv->if_id, skb->len, control);
+	}
+	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+		flags |= RTL8187_TX_FLAG_CTS;
+		flags |= control->rts_cts_rate << 19;
+	}
+
+	hdr = (struct rtl8187b_tx_hdr *)skb_push(skb, sizeof(*hdr));
+	memset(hdr, 0, sizeof(*hdr));
+	hdr->flags = cpu_to_le32(flags);
+	hdr->rts_duration = rts_dur;
+	hdr->retry = cpu_to_le32(11 << 8);
+	if (control->tx_rate < 12)
+		hdr->tx_duration = ieee80211_generic_frame_duration(dev,
+					priv->if_id,
+					skb->len,
+					priv->rates[control->tx_rate].rate);
+
+	info = (struct rtl8187_tx_info *)skb->cb;
+	info->control = kmemdup(control, sizeof(*control), GFP_ATOMIC);
+	info->urb = urb;
+	info->dev = dev;
+	usb_fill_bulk_urb(urb, priv->udev,
+			  usb_sndbulkpipe(priv->udev, ep[skb->priority]),
+			  hdr, skb->len, rtl8187b_tx_cb, skb);
+	usb_submit_urb(urb, GFP_ATOMIC);
+
+	return 0;
+}
+
+// TODO: make this better
+static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
+		      struct ieee80211_tx_control *control)
+{
+	struct rtl8187_priv *priv = dev->priv;
+
+	if (priv->hw_type == RTL8187)
+		return r8187_tx(dev, skb, control);
+	else
+		return r8187b_tx(dev, skb, control);
+}
+
 static void rtl8187_rx_cb(struct urb *urb)
 {
 	struct sk_buff *skb = (struct sk_buff *)urb->context;
@@ -232,6 +321,85 @@ static void rtl8187_rx_cb(struct urb *ur
 	rx_status.mactime = le64_to_cpu(hdr->mac_time);
 	if (flags & (1 << 13))
 		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+
+	ieee80211_rx_irqsafe(dev, skb, &rx_status);
+
+	skb = dev_alloc_skb(RTL8187_MAX_RX);
+	if (unlikely(!skb)) {
+		usb_free_urb(urb);
+		/* TODO check rx queue length and refill *somewhere* */
+		return;
+	}
+
+	info = (struct rtl8187_rx_info *)skb->cb;
+	info->urb = urb;
+	info->dev = dev;
+	urb->transfer_buffer = skb_tail_pointer(skb);
+	urb->context = skb;
+	skb_queue_tail(&priv->rx_queue, skb);
+
+	usb_submit_urb(urb, GFP_ATOMIC);
+}
+
+static void rtl8187b_rx_cb(struct urb *urb)
+{
+	struct sk_buff *skb = (struct sk_buff *)urb->context;
+	struct rtl8187_rx_info *info = (struct rtl8187_rx_info *)skb->cb;
+	struct ieee80211_hw *dev = info->dev;
+	struct rtl8187_priv *priv = dev->priv;
+	struct rtl8187b_rx_hdr *hdr;
+	struct ieee80211_rx_status rx_status = { 0 };
+	int rate, signal;
+	u32 flags;
+
+	spin_lock(&priv->rx_queue.lock);
+	if (skb->next)
+		__skb_unlink(skb, &priv->rx_queue);
+	else {
+		spin_unlock(&priv->rx_queue.lock);
+		return;
+	}
+	spin_unlock(&priv->rx_queue.lock);
+
+	if (unlikely(urb->status)) {
+		usb_free_urb(urb);
+		dev_kfree_skb_irq(skb);
+		return;
+	}
+
+	skb_put(skb, urb->actual_length);
+	hdr = (struct rtl8187b_rx_hdr *)(skb_tail_pointer(skb) - sizeof(*hdr));
+	flags = le32_to_cpu(hdr->flags);
+	skb_trim(skb, flags & 0x0FFF);
+
+	signal = hdr->agc >> 1;
+	rate = (flags >> 20) & 0xF;
+	//TODO: same as r8187?
+	if (rate > 3) {	/* OFDM rate */
+		if (signal > 90)
+			signal = 90;
+		else if (signal < 25)
+			signal = 25;
+		signal = 90 - signal;
+	} else {	/* CCK rate */
+		if (signal > 95)
+			signal = 95;
+		else if (signal < 30)
+			signal = 30;
+		signal = 95 - signal;
+	}
+
+	rx_status.antenna = (hdr->signal >> 7) & 1;
+	rx_status.signal = 64 - min(hdr->noise, (u8)64);
+	rx_status.ssi = signal;
+	rx_status.rate = rate;
+	rx_status.freq = dev->conf.freq;
+	rx_status.channel = dev->conf.channel;
+	rx_status.phymode = dev->conf.phymode;
+	rx_status.mactime = le64_to_cpu(hdr->mac_time);
+	if (flags & (1 << 13))
+		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+
 	ieee80211_rx_irqsafe(dev, skb, &rx_status);
 
 	skb = dev_alloc_skb(RTL8187_MAX_RX);
@@ -258,6 +426,7 @@ static int rtl8187_init_urbs(struct ieee
 	struct sk_buff *skb;
 	struct rtl8187_rx_info *info;
 
+	printk("rtl8187_init_urbs\n");
 	while (skb_queue_len(&priv->rx_queue) < 8) {
 		skb = __dev_alloc_skb(RTL8187_MAX_RX, GFP_KERNEL);
 		if (!skb)
@@ -267,10 +436,16 @@ static int rtl8187_init_urbs(struct ieee
 			kfree_skb(skb);
 			break;
 		}
-		usb_fill_bulk_urb(entry, priv->udev,
-				  usb_rcvbulkpipe(priv->udev, 1),
-				  skb_tail_pointer(skb),
-				  RTL8187_MAX_RX, rtl8187_rx_cb, skb);
+		if (priv->hw_type == RTL8187)
+			usb_fill_bulk_urb(entry, priv->udev,
+					  usb_rcvbulkpipe(priv->udev, 1),
+					  skb_tail_pointer(skb),
+					  RTL8187_MAX_RX, rtl8187_rx_cb, skb);
+		else
+			usb_fill_bulk_urb(entry, priv->udev,
+					  usb_rcvbulkpipe(priv->udev, 3),
+					  skb_tail_pointer(skb),
+					  RTL8187_MAX_RX, rtl8187b_rx_cb, skb);
 		info = (struct rtl8187_rx_info *)skb->cb;
 		info->urb = entry;
 		info->dev = dev;
@@ -281,29 +456,13 @@ static int rtl8187_init_urbs(struct ieee
 	return 0;
 }
 
-static int rtl8187_init_hw(struct ieee80211_hw *dev)
+static int rtl8187_cmd_reset(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	u8 reg;
 	int i;
 
-	/* reset */
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
-
+	printk("rtl8187_cmd_reset\n");
 	reg = rtl818x_ioread8(priv, &priv->map->CMD);
 	reg &= (1 << 1);
 	reg |= RTL818X_CMD_RESET;
@@ -339,6 +498,37 @@ static int rtl8187_init_hw(struct ieee80
 		return -ETIMEDOUT;
 	}
 
+	return 0;
+}
+
+static int rtl8187_init_hw(struct ieee80211_hw *dev)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	u8 reg;
+	int res;
+
+	printk("rtl8187_init_hw\n");
+	/* reset */
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+
+	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
+
+	msleep(200);
+	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x10);
+	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x11);
+	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x00);
+	msleep(200);
+
+	res = rtl8187_cmd_reset(dev);
+	if (res)
+		return res;
+
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
@@ -408,11 +598,87 @@ static int rtl8187_init_hw(struct ieee80
 	return 0;
 }
 
+static int rtl8187b_init_hw(struct ieee80211_hw *dev)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	int res;
+	u8 reg;
+
+	printk("rtl8187b_init_hw\n");
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG); // config start
+
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE | RTL818X_CONFIG3_GNT_SELECT;
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, 0x727f3f52);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, 0x45090658);
+	rtl818x_iowrite8(priv, (u8 *)0xFFEE, 0); // TODO: define ANAPARAM3
+
+	// TODO: optimize this (see ANAPARAM2 above == 0xFF60)
+	rtl818x_iowrite8(priv, (u8 *)0xFF61, 0x10);
+	reg = rtl818x_ioread8(priv, (u8 *)0xFF62);
+	rtl818x_iowrite8(priv, (u8 *)0xFF62, reg & (~(0x1<<5)));
+	rtl818x_iowrite8(priv, (u8 *)0xFF62, reg | (0x1<<5));
+
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	reg &= ~RTL818X_CONFIG3_ANAPARAM_WRITE;
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL); //config end
+
+	//res = rtl8187_cmd_reset(dev);
+	//if (res)
+	//	return res;
+	// reset from realtek source...
+	reg = rtl818x_ioread8(priv, &priv->map->CMD);
+	reg &= 2;
+	reg |= (1 << 4);
+	rtl818x_iowrite8(priv, &priv->map->CMD, reg);
+	msleep(200);
+
+	//BLA
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
+	priv->rf_init(dev);
+
+	reg = RTL818X_CMD_TX_ENABLE | RTL818X_CMD_RX_ENABLE;
+	rtl818x_iowrite8(priv, &priv->map->CMD, reg);
+	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0xFFFF);
+
+	rtl818x_iowrite8(priv, (u8 *)0xFE41, 0xF4);
+	rtl818x_iowrite8(priv, (u8 *)0xFE40, 0x00);
+	rtl818x_iowrite8(priv, (u8 *)0xFE42, 0x00);
+	rtl818x_iowrite8(priv, (u8 *)0xFE42, 0x01);
+	rtl818x_iowrite8(priv, (u8 *)0xFE40, 0x0F);
+	rtl818x_iowrite8(priv, (u8 *)0xFE42, 0x00);
+	rtl818x_iowrite8(priv, (u8 *)0xFE42, 0x01);
+
+	reg = rtl818x_ioread8(priv, (u8 *)0xFFDB);
+	rtl818x_iowrite8(priv, (u8 *)0xFFDB, reg | (1 << 2));
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF72, 0x59FA, 3);
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF74, 0x59D2, 3);
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF76, 0x59D2, 3);
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF78, 0x19FA, 3);
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF7A, 0x19FA, 3);
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF7C, 0x00D0, 3);
+	rtl818x_iowrite8(priv, (u8 *)0xFF61, 0);
+	rtl818x_iowrite8_idx(priv, (u8 *)0xFF80, 0x0F, 1);
+	rtl818x_iowrite8_idx(priv, (u8 *)0xFF83, 0x03, 1);
+	rtl818x_iowrite8(priv, (u8 *)0xFFDA, 0x10);
+	rtl818x_iowrite8_idx(priv, (u8 *)0xFF4D, 0x08, 2);
+
+	rtl818x_iowrite32(priv, (__le32 *)0xFF94, 0x0600321B); // TODO: add HSSI_PARA
+
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFEC, 0x0800, 1);
+
+	return 0;
+}
+
 static void rtl8187_set_channel(struct ieee80211_hw *dev, int channel)
 {
 	u32 reg;
 	struct rtl8187_priv *priv = dev->priv;
 
+	printk("rtl8187_set_channel\n");
 	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
 	/* Enable TX loopback on MAC level to avoid TX during channel
 	 * changes, as this has be seen to causes problems and the
@@ -432,10 +698,41 @@ static int rtl8187_start(struct ieee8021
 	u32 reg;
 	int ret;
 
-	ret = rtl8187_init_hw(dev);
+	printk("rtl8187_start\n");
+	ret = (priv->hw_type == RTL8187) ? rtl8187_init_hw(dev) :
+					   rtl8187b_init_hw(dev);
 	if (ret)
 		return ret;
 
+	if (priv->hw_type == RTL8187B) {
+		reg = RTL818X_RX_CONF_MGMT |
+		      RTL818X_RX_CONF_DATA |
+		      RTL818X_RX_CONF_BROADCAST |
+		      RTL818X_RX_CONF_NICMAC |
+		      RTL818X_RX_CONF_BSSID |
+		      (7 << 13 /* RX FIFO threshold NONE */) |
+		      (7 << 10 /* MAX RX DMA */) |
+		      RTL818X_RX_CONF_RX_AUTORESETPHY |
+		      RTL818X_RX_CONF_ONLYERLPKT |
+		      /*RTL818X_RX_CONF_CTRL |*/
+		      RTL818X_RX_CONF_MULTICAST;
+		priv->rx_conf = reg;
+		rtl818x_iowrite32(priv, &priv->map->RX_CONF, reg);
+
+		rtl818x_iowrite32(priv, &priv->map->TX_CONF,
+				  RTL818X_TX_CONF_DURPROCMODE |
+				  RTL818X_TX_CONF_DISREQQSIZE |
+				  RTL818X_TX_CONF_MAXDMA_2048 |
+				  (7 << 8) | 7); //TODO: define, short-long retry limit
+
+		reg = rtl818x_ioread8(priv, &priv->map->MSR);
+		reg |= RTL818X_MSR_ENEDCA;
+		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
+
+		rtl8187_init_urbs(dev);
+		return 0;
+	}
+
 	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0xFFFF);
 
 	rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);
@@ -487,6 +784,7 @@ static void rtl8187_stop(struct ieee8021
 	struct sk_buff *skb;
 	u32 reg;
 
+	printk("rtl8187_stop\n");
 	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
 
 	reg = rtl818x_ioread8(priv, &priv->map->CMD);
@@ -515,6 +813,7 @@ static int rtl8187_add_interface(struct 
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
 
+	printk("rtl8187_add_interface\n");
 	if (priv->mode != IEEE80211_IF_TYPE_MNTR)
 		return -EOPNOTSUPP;
 
@@ -540,6 +839,7 @@ static void rtl8187_remove_interface(str
 {
 	struct rtl8187_priv *priv = dev->priv;
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	printk("rtl8187_remove_interface\n");
 }
 
 static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
@@ -547,18 +847,21 @@ static int rtl8187_config(struct ieee802
 	struct rtl8187_priv *priv = dev->priv;
 	rtl8187_set_channel(dev, conf->channel);
 
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
+	printk("rtl8187_config\n");
+	if (priv->hw_type == RTL8187) {
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
@@ -573,16 +876,42 @@ static int rtl8187_config_interface(stru
 {
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
+	u8 reg;
 
+	printk("rtl8187_config_interface\n");
 	priv->if_id = if_id;
 
 	for (i = 0; i < ETH_ALEN; i++)
 		rtl818x_iowrite8(priv, &priv->map->BSSID[i], conf->bssid[i]);
+	printk("BSSID in hardware: ");
+	for (i = 0; i < ETH_ALEN; i++)
+		printk("%02x ", rtl818x_ioread8(priv, &priv->map->BSSID[i]));
+	printk("\n");
 
 	if (is_valid_ether_addr(conf->bssid))
-		rtl818x_iowrite8(priv, &priv->map->MSR, RTL818X_MSR_INFRA);
+	{
+		printk("RTL818X_MSR_INFRA\n");
+
+		//reg = rtl818x_ioread8(priv, &priv->map->MSR);
+		//reg &= ~((1<<2)|(1<<3));
+		reg = RTL818X_MSR_INFRA | RTL818X_MSR_ENEDCA; //bla ENEDCA
+		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
+
+		//rtl818x_iowrite8(priv, &priv->map->MSR, RTL818X_MSR_INFRA);
+
+		rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);
+		rtl818x_iowrite16(priv, &priv->map->ATIMTR_INTERVAL, 100);
+		rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
+		rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL_TIME, 100);
+	}
 	else
-		rtl818x_iowrite8(priv, &priv->map->MSR, RTL818X_MSR_NO_LINK);
+	{
+		printk("RTL818X_MSR_NO_LINK\n");
+		//reg = rtl818x_ioread8(priv, &priv->map->MSR);
+		//reg &= ~((1<<2)|(1<<3));
+		reg = RTL818X_MSR_NO_LINK;
+		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
+	}
 
 	return 0;
 }
@@ -594,6 +923,7 @@ static void rtl8187_configure_filter(str
 {
 	struct rtl8187_priv *priv = dev->priv;
 
+	printk("rtl8187_configure_filter\n");
 	if (changed_flags & FIF_FCSFAIL)
 		priv->rx_conf ^= RTL818X_RX_CONF_FCS;
 	if (changed_flags & FIF_CONTROL)
@@ -669,10 +999,13 @@ static int __devinit rtl8187_probe(struc
 	struct rtl8187_priv *priv;
 	struct eeprom_93cx6 eeprom;
 	struct ieee80211_channel *channel;
+	const char *chip_name;
 	u16 txpwr, reg;
+	u32 reg32;
 	int err, i;
 	DECLARE_MAC_BUF(mac);
 
+	printk("rtl8187_probe\n");
 	dev = ieee80211_alloc_hw(sizeof(*priv), &rtl8187_ops);
 	if (!dev) {
 		printk(KERN_ERR "rtl8187: ieee80211 alloc failed\n");
@@ -690,6 +1023,7 @@ static int __devinit rtl8187_probe(struc
 	skb_queue_head_init(&priv->rx_queue);
 	memcpy(priv->channels, rtl818x_channels, sizeof(rtl818x_channels));
 	memcpy(priv->rates, rtl818x_rates, sizeof(rtl818x_rates));
+	priv->hw_type = id->driver_info;
 	priv->map = (struct rtl818x_csr *)0xFF00;
 	priv->modes[0].mode = MODE_IEEE80211G;
 	priv->modes[0].num_rates = ARRAY_SIZE(rtl818x_rates);
@@ -704,7 +1038,9 @@ static int __devinit rtl8187_probe(struc
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS;
-	dev->extra_tx_headroom = sizeof(struct rtl8187_tx_hdr);
+	dev->extra_tx_headroom = (priv->hw_type == RTL8187) ?
+				  sizeof(struct rtl8187_tx_hdr) :
+				  sizeof(struct rtl8187b_tx_hdr);
 	dev->queues = 1;
 	dev->max_rssi = 65;
 	dev->max_signal = 64;
@@ -726,6 +1062,15 @@ static int __devinit rtl8187_probe(struc
 
 	eeprom_93cx6_multiread(&eeprom, RTL8187_EEPROM_MAC_ADDR,
 			       (__le16 __force *)dev->wiphy->perm_addr, 3);
+	/* Don't ask me why, realtek sources also increments last mac addr */
+	/* TODO: REMOVE THIS */
+	if (priv->hw_type == RTL8187B) {
+		printk("a: perm_addr[5] = %x\n",
+			dev->wiphy->perm_addr[5]);
+		dev->wiphy->perm_addr[5] += 1;
+		printk("d: perm_addr[5] = %x\n",
+			dev->wiphy->perm_addr[5]);
+	}
 	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
 		printk(KERN_WARNING "rtl8187: Invalid hwaddr! Using randomly "
 		       "generated MAC address\n");
@@ -745,10 +1090,24 @@ static int __devinit rtl8187_probe(struc
 		(*channel++).val = txpwr & 0xFF;
 		(*channel++).val = txpwr >> 8;
 	}
-	for (i = 0; i < 2; i++) {
-		eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_TXPWR_CHAN_6 + i,
+	if (priv->hw_type == RTL8187) {
+		for (i = 0; i < 2; i++) {
+			eeprom_93cx6_read(&eeprom,
+					  RTL8187_EEPROM_TXPWR_CHAN_6 + i,
+					  &txpwr);
+			(*channel++).val = txpwr & 0xFF;
+			(*channel++).val = txpwr >> 8;
+		}
+	} else {
+		eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_TXPWR_CHAN_6,
 				  &txpwr);
 		(*channel++).val = txpwr & 0xFF;
+
+		eeprom_93cx6_read(&eeprom, 0x0A, &txpwr);
+		(*channel++).val = txpwr & 0xFF;
+
+		eeprom_93cx6_read(&eeprom, 0x1C, &txpwr);
+		(*channel++).val = txpwr & 0xFF;
 		(*channel++).val = txpwr >> 8;
 	}
 
@@ -764,14 +1123,53 @@ static int __devinit rtl8187_probe(struc
 	rtl818x_iowrite16(priv, &priv->map->PGSELECT, reg);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
-	rtl8225_write(dev, 0, 0x1B7);
+	if (priv->hw_type == RTL8187) {
+		reg32 = rtl818x_ioread32(priv, &priv->map->TX_CONF);
+		reg32 &= RTL818X_TX_CONF_HWVER_MASK;
+		switch (reg32) {
+		case RTL818X_TX_CONF_R8187_5:
+		case RTL818X_TX_CONF_R8187_6:
+			chip_name = "RTL8187vD";
+			break;
+		default:
+			chip_name = "RTL8187vB (default)";
+		}
+		rtl8225_write(dev, 0, 0x1B7);
+		if (rtl8225_read(dev, 8) != 0x588 || rtl8225_read(dev, 9) != 0x700) {
+			priv->rf_init = rtl8225_rf_init;
+			priv->rf_set_tx_power = rtl8225_rf_set_tx_power;
+		} else {
+			priv->rf_init = rtl8225z2_8187_rf_init;
+			priv->rf_set_tx_power = rtl8225z2_8187_rf_set_tx_power;
+		}
+		rtl8225_write(dev, 0, 0x0B7);
+	} else {
+		reg32 = rtl818x_ioread8(priv, &priv->map->reserved_18[2]);
+		switch (reg32) {
+		case RTL818X_TX_CONF_R8187B_B:
+			chip_name = "RTL8187BvB";
+			priv->hw_rev = RTL8187BvB;
+			break;
+		case RTL818X_TX_CONF_R8187B_D:
+			chip_name = "RTL8187BvD";
+			priv->hw_rev = RTL8187BvD;
+			break;
+		case RTL818X_TX_CONF_R8187B_E:
+			chip_name = "RTL8187BvE";
+			priv->hw_rev = RTL8187BvE;
+			break;
+		default:
+			chip_name = "RTL8187BvB (default)";
+			priv->hw_rev = RTL8187BvB;
+		}
+		priv->rf_init = rtl8225z2_8187b_rf_init;
+		priv->rf_set_tx_power = rtl8225z2_8187b_rf_set_tx_power;
+	}
 
-	if (rtl8225_read(dev, 8) != 0x588 || rtl8225_read(dev, 9) != 0x700)
+	/*if (rtl8225_read(dev, 8) != 0x588 || rtl8225_read(dev, 9) != 0x700)
 		priv->rf_init = rtl8225_rf_init;
 	else
-		priv->rf_init = rtl8225z2_rf_init;
-
-	rtl8225_write(dev, 0, 0x0B7);
+		priv->rf_init = rtl8225z2_rf_init;*/
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
@@ -779,9 +1177,9 @@ static int __devinit rtl8187_probe(struc
 		goto err_free_dev;
 	}
 
-	printk(KERN_INFO "%s: hwaddr %s, rtl8187 V%d + %s\n",
+	printk(KERN_INFO "%s: hwaddr %s, %s asic_rev=%d + %s\n",
 	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
-	       priv->asic_rev, priv->rf_init == rtl8225_rf_init ?
+	       chip_name, priv->asic_rev, priv->rf_init == rtl8225_rf_init ?
 	       "rtl8225" : "rtl8225z2");
 
 	return 0;
@@ -798,6 +1196,7 @@ static void __devexit rtl8187_disconnect
 	struct ieee80211_hw *dev = usb_get_intfdata(intf);
 	struct rtl8187_priv *priv;
 
+	printk("rtl8187_disconnect\n");
 	if (!dev)
 		return;
 
--- ./rtl8187.h.orig	2007-09-02 06:43:09.000000000 -0300
+++ ./rtl8187.h	2007-09-09 03:33:48.000000000 -0300
@@ -44,27 +44,51 @@ struct rtl8187_rx_hdr {
 	__le64 mac_time;
 } __attribute__((packed));
 
+struct rtl8187b_rx_hdr {
+	__le32 flags;
+	__le64 mac_time;
+	u8 noise;
+	u8 signal;
+	u8 agc;
+	u8 reserved;
+	__le32 unused; // TODO: num_mcsi, snr_long2end, cfo_bias, pwdb_g12, fot ?
+} __attribute__((packed));
+
 struct rtl8187_tx_info {
 	struct ieee80211_tx_control *control;
 	struct urb *urb;
 	struct ieee80211_hw *dev;
 };
 
-struct rtl8187_tx_hdr {
-	__le32 flags;
 #define RTL8187_TX_FLAG_NO_ENCRYPT	(1 << 15)
 #define RTL8187_TX_FLAG_MORE_FRAG	(1 << 17)
 #define RTL8187_TX_FLAG_CTS		(1 << 18)
 #define RTL8187_TX_FLAG_RTS		(1 << 23)
+
+struct rtl8187_tx_hdr {
+	__le32 flags;
 	__le16 rts_duration;
 	__le16 len;
 	__le32 retry;
 } __attribute__((packed));
 
+struct rtl8187b_tx_hdr {
+	__le32 flags;
+	__le16 rts_duration;
+	__le16 len;
+	__le32 reserved1;
+	__le16 reserved2;
+	__le16 tx_duration;
+	__le32 reserved3;
+	__le32 retry;
+	__le64 reserved4;
+} __attribute__((packed));
+
 struct rtl8187_priv {
 	/* common between rtl818x drivers */
 	struct rtl818x_csr *map;
 	void (*rf_init)(struct ieee80211_hw *);
+	void (*rf_set_tx_power)(struct ieee80211_hw *dev, int channel);
 	int mode;
 	int if_id;
 
@@ -76,70 +100,98 @@ struct rtl8187_priv {
 	u32 rx_conf;
 	u16 txpwr_base;
 	u8 asic_rev;
+	enum {
+		RTL8187,
+		RTL8187B
+	} hw_type;
+	enum {
+		RTL8187BvB,
+		RTL8187BvD,
+		RTL8187BvE
+	} hw_rev;
 	struct sk_buff_head rx_queue;
 };
 
 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
 
-static inline u8 rtl818x_ioread8(struct rtl8187_priv *priv, u8 *addr)
+static inline u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv, u8 *addr, u8 idx)
 {
 	u8 val;
 
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
+			(unsigned long)addr, idx & 0x03, &val,
+			sizeof(val), HZ / 2);
 
 	return val;
 }
 
-static inline u16 rtl818x_ioread16(struct rtl8187_priv *priv, __le16 *addr)
+#define rtl818x_ioread8(priv, addr) rtl818x_ioread8_idx(priv, addr, 0)
+
+static inline u16 rtl818x_ioread16_idx(struct rtl8187_priv *priv, __le16 *addr, u8 idx)
 {
 	__le16 val;
 
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
+			(unsigned long)addr, idx & 0x03, &val,
+			sizeof(val), HZ / 2);
 
 	return le16_to_cpu(val);
 }
 
-static inline u32 rtl818x_ioread32(struct rtl8187_priv *priv, __le32 *addr)
+#define rtl818x_ioread16(priv, addr) rtl818x_ioread16_idx(priv, addr, 0)
+
+static inline u32 rtl818x_ioread32_idx(struct rtl8187_priv *priv, __le32 *addr, u8 idx)
 {
 	__le32 val;
 
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
+			(unsigned long)addr, idx & 0x03, &val,
+			sizeof(val), HZ / 2);
 
 	return le32_to_cpu(val);
 }
 
-static inline void rtl818x_iowrite8(struct rtl8187_priv *priv,
-				    u8 *addr, u8 val)
+#define rtl818x_ioread32(priv, addr) rtl818x_ioread32_idx(priv, addr, 0)
+
+static inline void rtl818x_iowrite8_idx(struct rtl8187_priv *priv,
+					u8 *addr, u8 val, u8 idx)
 {
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
+			(unsigned long)addr, idx & 0x03, &val,
+			sizeof(val), HZ / 2);
 }
 
-static inline void rtl818x_iowrite16(struct rtl8187_priv *priv,
-				     __le16 *addr, u16 val)
+#define rtl818x_iowrite8(priv, addr, val) \
+	rtl818x_iowrite8_idx(priv, addr, val, 0)
+
+static inline void rtl818x_iowrite16_idx(struct rtl8187_priv *priv,
+					 __le16 *addr, u16 val, u8 idx)
 {
 	__le16 buf = cpu_to_le16(val);
 
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, 0, &buf, sizeof(buf), HZ / 2);
+			(unsigned long)addr, idx & 0x03, &buf, sizeof(buf), HZ / 2);
 }
 
-static inline void rtl818x_iowrite32(struct rtl8187_priv *priv,
-				     __le32 *addr, u32 val)
+#define rtl818x_iowrite16(priv, addr, val) \
+	rtl818x_iowrite16_idx(priv, addr, val, 0)
+
+static inline void rtl818x_iowrite32_idx(struct rtl8187_priv *priv,
+					 __le32 *addr, u32 val, u8 idx)
 {
 	__le32 buf = cpu_to_le32(val);
 
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, 0, &buf, sizeof(buf), HZ / 2);
+			(unsigned long)addr, idx & 0x03, &buf, sizeof(buf), HZ / 2);
 }
 
+#define rtl818x_iowrite32(priv, addr, val) \
+	rtl818x_iowrite32_idx(priv, addr, val, 0)
+
 #endif /* RTL8187_H */
--- ./rtl8187_rtl8225.c.orig	2007-09-01 05:30:26.000000000 -0300
+++ ./rtl8187_rtl8225.c	2007-09-11 17:01:46.903838410 -0300
@@ -275,7 +275,7 @@ static const u32 rtl8225_chan[] = {
 	0x0bdc, 0x0c5c, 0x0cdc, 0x0d5c, 0x0ddc, 0x0e5c, 0x0f72
 };
 
-static void rtl8225_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
+void rtl8225_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	u8 cck_power, ofdm_power;
@@ -471,12 +471,43 @@ void rtl8225_rf_init(struct ieee80211_hw
 	rtl8225_write_phy_cck(dev, 0x41, rtl8225_threshold[2]);
 }
 
+// TODO: check 8187 too
+static const u8 rtl8225z2_agc[] = {
+	0x5e, 0x5e, 0x5e, 0x5e, 0x5d, 0x5b, 0x59, 0x57, 0x55, 0x53, 0x51, 0x4f,
+	0x4d, 0x4b, 0x49, 0x47, 0x45, 0x43, 0x41, 0x3f, 0x3d, 0x3b, 0x39, 0x37,
+	0x35, 0x33, 0x31, 0x2f, 0x2d, 0x2b, 0x29, 0x27, 0x25, 0x23, 0x21, 0x1f,
+	0x1d, 0x1b, 0x19, 0x17, 0x15, 0x13, 0x11, 0x0f, 0x0d, 0x0b, 0x09, 0x07,
+	0x05, 0x03, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+	0x01, 0x01, 0x01, 0x01, 0x19, 0x19, 0x19, 0x19, 0x19, 0x19, 0x19, 0x19,
+	0x19, 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x26, 0x27, 0x27, 0x28,
+	0x28, 0x29, 0x2a, 0x2a, 0x2a, 0x2b, 0x2b, 0x2b, 0x2c, 0x2c, 0x2c, 0x2d,
+	0x2d, 0x2d, 0x2d, 0x2e, 0x2e, 0x2e, 0x2e, 0x2f, 0x2f, 0x2f, 0x30, 0x30,
+	0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31,
+	0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31
+};
+static const u8 rtl8225z2_ofdm[] = {
+	0x10, 0x0d, 0x01, 0x00, 0x14, 0xfb, 0xfb, 0x60,
+	0x00, 0x60, 0x00, 0x00, 0x00, 0x5c, 0x00, 0x00,
+	0x40, 0x00, 0x40, 0x00, 0x00, 0x00, 0xa8, 0x26,
+	0x32, 0x33, 0x07, 0xa5, 0x6f, 0x55, 0xc8, 0xb3,
+	0x0a, 0xe1, 0x2C, 0x8a, 0x86, 0x83, 0x34, 0x0f,
+	0x4f, 0x24, 0x6f, 0xc2, 0x6b, 0x40, 0x80, 0x00,
+	0xc0, 0xc1, 0x58, 0xf1, 0x00, 0xe4, 0x90, 0x3e,
+	0x6d, 0x3c, 0xfb, 0x07
+};
+
 static const u8 rtl8225z2_tx_power_cck_ch14[] = {
-	0x36, 0x35, 0x2e, 0x1b, 0x00, 0x00, 0x00, 0x00
+	0x36, 0x35, 0x2e, 0x1b, 0x00, 0x00, 0x00, 0x00,
+	0x30, 0x2f, 0x29, 0x15, 0x00, 0x00, 0x00, 0x00,
+	0x30, 0x2f, 0x29, 0x15, 0x00, 0x00, 0x00, 0x00,
+	0x30, 0x2f, 0x29, 0x15, 0x00, 0x00, 0x00, 0x00
 };
 
 static const u8 rtl8225z2_tx_power_cck[] = {
-	0x36, 0x35, 0x2e, 0x25, 0x1c, 0x12, 0x09, 0x04
+	0x36, 0x35, 0x2e, 0x25, 0x1c, 0x12, 0x09, 0x04,
+	0x30, 0x2f, 0x29, 0x21, 0x19, 0x10, 0x08, 0x03,
+	0x2b, 0x2a, 0x25, 0x1e, 0x16, 0x0e, 0x07, 0x03,
+	0x26, 0x25, 0x21, 0x1b, 0x14, 0x0d, 0x06, 0x03
 };
 
 static const u8 rtl8225z2_tx_power_ofdm[] = {
@@ -492,7 +523,7 @@ static const u8 rtl8225z2_tx_gain_cck_of
 	0x1e, 0x1f, 0x20, 0x21, 0x22, 0x23
 };
 
-static void rtl8225z2_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
+void rtl8225z2_8187_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	u8 cck_power, ofdm_power;
@@ -542,6 +573,85 @@ static void rtl8225z2_rf_set_tx_power(st
 	msleep(1);
 }
 
+void rtl8225z2_8187b_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	u8 cck_power, ofdm_power;
+	const u8 *tmp;
+	int i;
+
+	cck_power = priv->channels[channel - 1].val & 0xF;
+	ofdm_power = priv->channels[channel - 1].val >> 4;
+
+	if (cck_power > 15)
+		cck_power = (priv->hw_rev == RTL8187BvB) ? 15 : 22;
+	else
+		cck_power += (priv->hw_rev == RTL8187BvB) ? 0 : 7;
+	cck_power += priv->txpwr_base & 0xF;
+	cck_power = min(cck_power, (u8)35);
+
+	if (ofdm_power > 15)
+		ofdm_power = (priv->hw_rev == RTL8187BvB) ? 17 : 25;
+	else
+		ofdm_power += (priv->hw_rev == RTL8187BvB) ? 2 : 10;
+	ofdm_power += (priv->txpwr_base >> 4) & 0xF;
+	ofdm_power = min(ofdm_power, (u8)35);
+
+	if (channel == 14)
+		tmp = rtl8225z2_tx_power_cck_ch14;
+	else
+		tmp = rtl8225z2_tx_power_cck;
+
+	if (priv->hw_rev == RTL8187BvB) {
+		if (cck_power <= 6)
+			; /* do nothing */
+		else if (cck_power <= 11)
+			tmp += 8;
+		else
+			tmp += 16;
+	} else {
+		if (cck_power <= 5)
+			; /* do nothing */
+		else if (cck_power <= 11)
+			tmp += 8;
+		else if (cck_power <= 17)
+			tmp += 16;
+		else
+			tmp += 24;
+	}
+
+	for (i = 0; i < 8; i++)
+		rtl8225_write_phy_cck(dev, 0x44 + i, *tmp++);
+
+	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK,
+			 rtl8225z2_tx_gain_cck_ofdm[cck_power]);
+	msleep(1);
+
+	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM,
+			 rtl8225z2_tx_gain_cck_ofdm[ofdm_power] << 1);
+	if (priv->hw_rev == RTL8187BvB) {
+		if (ofdm_power <= 11) {
+			rtl8225_write_phy_ofdm(dev, 0x87, 0x60);
+			rtl8225_write_phy_ofdm(dev, 0x89, 0x60);
+		} else {
+			rtl8225_write_phy_ofdm(dev, 0x87, 0x5c);
+			rtl8225_write_phy_ofdm(dev, 0x89, 0x5c);
+		}
+	} else {
+		if (ofdm_power <= 11) {
+			rtl8225_write_phy_ofdm(dev, 0x87, 0x5c);
+			rtl8225_write_phy_ofdm(dev, 0x89, 0x5c);
+		} else if (ofdm_power <= 17) {
+			rtl8225_write_phy_ofdm(dev, 0x87, 0x54);
+			rtl8225_write_phy_ofdm(dev, 0x89, 0x54);
+		} else {
+			rtl8225_write_phy_ofdm(dev, 0x87, 0x50);
+			rtl8225_write_phy_ofdm(dev, 0x89, 0x50);
+		}
+	}
+	msleep(1);
+}
+
 static const u16 rtl8225z2_rxgain[] = {
 	0x0400, 0x0401, 0x0402, 0x0403, 0x0404, 0x0405, 0x0408, 0x0409,
 	0x040a, 0x040b, 0x0502, 0x0503, 0x0504, 0x0505, 0x0540, 0x0541,
@@ -567,7 +677,7 @@ static const u8 rtl8225z2_gain_bg[] = {
 	0x63, 0x15, 0xc5  /* -66dBm */
 };
 
-void rtl8225z2_rf_init(struct ieee80211_hw *dev)
+void rtl8225z2_8187_rf_init(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
@@ -704,7 +814,7 @@ void rtl8225z2_rf_init(struct ieee80211_
 
 	rtl818x_iowrite8(priv, (u8 *)0xFF5B, 0x0D); msleep(1);
 
-	rtl8225z2_rf_set_tx_power(dev, 1);
+	priv->rf_set_tx_power(dev, 1);
 
 	/* RX antenna default to A */
 	rtl8225_write_phy_cck(dev, 0x10, 0x9b); msleep(1);	/* B: 0xDB */
@@ -715,6 +825,220 @@ void rtl8225z2_rf_init(struct ieee80211_
 	rtl818x_iowrite32(priv, (__le32 *)0xFF94, 0x3dc00002);
 }
 
+static u32 rtl8187b_reg_table[][3] = {
+	{0xF0, 0x32, 0000}, {0xF1, 0x32, 0000}, {0xF2, 0x00, 0000}, {0xF3, 0x00, 0000},
+	{0xF4, 0x32, 0000}, {0xF5, 0x43, 0000}, {0xF6, 0x00, 0000}, {0xF7, 0x00, 0000},
+	{0xF8, 0x46, 0000}, {0xF9, 0xA4, 0000}, {0xFA, 0x00, 0000}, {0xFB, 0x00, 0000},
+	{0xFC, 0x96, 0000}, {0xFD, 0xA4, 0000}, {0xFE, 0x00, 0000}, {0xFF, 0x00, 0000},
+
+	{0x58, 0x4B, 0001}, {0x59, 0x00, 0001}, {0x5A, 0x4B, 0001}, {0x5B, 0x00, 0001},
+	{0x60, 0x4B, 0001}, {0x61, 0x09, 0001}, {0x62, 0x4B, 0001}, {0x63, 0x09, 0001},
+	{0xCE, 0x0F, 0001}, {0xCF, 0x00, 0001}, {0xE0, 0xFF, 0001}, {0xE1, 0x0F, 0001},
+	{0xE2, 0x00, 0001}, {0xF0, 0x4E, 0001}, {0xF1, 0x01, 0001}, {0xF2, 0x02, 0001},
+	{0xF3, 0x03, 0001}, {0xF4, 0x04, 0001}, {0xF5, 0x05, 0001}, {0xF6, 0x06, 0001},
+	{0xF7, 0x07, 0001}, {0xF8, 0x08, 0001},
+
+	{0x4E, 0x00, 0002}, {0x0C, 0x04, 0002}, {0x21, 0x61, 0002}, {0x22, 0x68, 0002},
+	{0x23, 0x6F, 0002}, {0x24, 0x76, 0002}, {0x25, 0x7D, 0002}, {0x26, 0x84, 0002},
+	{0x27, 0x8D, 0002}, {0x4D, 0x08, 0002}, {0x50, 0x05, 0002}, {0x51, 0xF5, 0002},
+	{0x52, 0x04, 0002}, {0x53, 0xA0, 0002}, {0x54, 0x1F, 0002}, {0x55, 0x23, 0002},
+	{0x56, 0x45, 0002}, {0x57, 0x67, 0002}, {0x58, 0x08, 0002}, {0x59, 0x08, 0002},
+	{0x5A, 0x08, 0002}, {0x5B, 0x08, 0002}, {0x60, 0x08, 0002}, {0x61, 0x08, 0002},
+	{0x62, 0x08, 0002}, {0x63, 0x08, 0002}, {0x64, 0xCF, 0002}, {0x72, 0x56, 0002},
+	{0x73, 0x9A, 0002},
+
+	{0x34, 0xF0, 0000}, {0x35, 0x0F, 0000}, {0x5B, 0x40, 0000}, {0x84, 0x88, 0000},
+	{0x85, 0x24, 0000}, {0x88, 0x54, 0000}, {0x8B, 0xB8, 0000}, {0x8C, 0x07, 0000},
+	{0x8D, 0x00, 0000}, {0x94, 0x1B, 0000}, {0x95, 0x12, 0000}, {0x96, 0x00, 0000},
+	{0x97, 0x06, 0000}, {0x9D, 0x1A, 0000}, {0x9F, 0x10, 0000}, {0xB4, 0x22, 0000},
+	{0xBE, 0x80, 0000}, {0xDB, 0x00, 0000}, {0xEE, 0x00, 0000}, {0x91, 0x03, 0000},
+
+	{0x4C, 0x00, 0002}, {0x9F, 0x00, 0003}, {0x8C, 0x01, 0000}, {0x8D, 0x10, 0000},
+	{0x8E, 0x08, 0000}, {0x8F, 0x00, 0000}
+};
+
+//TODO: unify rf_init, same as 8187 z2 init
+void rtl8225z2_8187b_rf_init(struct ieee80211_hw *dev)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	u8 reg;
+	int i;
+
+	printk("rtl8225z2_8187b_rf_init\n");
+	//TODO: move code to hw_init
+
+	//InitializeExtraRegsOn8185, TODO: verify
+	rtl818x_iowrite16(priv, (__le16 *)0xFF2D, 0x0fff);
+	reg = rtl818x_ioread8(priv, (u8 *)0xFFBC);
+	rtl818x_iowrite8(priv, (u8 *)0xFFBC, reg | 0x02);
+	reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
+	rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg | 0x01);
+	reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
+	rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg | 0x02);
+
+	reg = rtl818x_ioread8(priv, &priv->map->RATE_FALLBACK);
+	reg &= ~0x80;
+	//rtl818x_iowrite16_idx(priv, (__le16 *)0xFFE0, 0x0fff, 1);
+	rtl818x_iowrite8(priv, &priv->map->RATE_FALLBACK, reg | 0x80);
+
+	/* Default network type to 'No  Link' (from Realtek driver) */
+	reg = rtl818x_ioread8(priv, &priv->map->MSR);
+	rtl818x_iowrite8(priv, &priv->map->MSR, reg & 0xF3);
+
+	//TODO: optimize this (reading MSR two times, unecessary?)
+
+	/* Avoid tx stall (from Realtek driver) */
+	reg = rtl818x_ioread8(priv, &priv->map->MSR);
+	rtl818x_iowrite8(priv, &priv->map->MSR, reg | RTL818X_MSR_ENEDCA);
+	rtl818x_iowrite8(priv, &priv->map->reserved_16[0], 0); // TODO: check (ACM_CONTROL)
+
+	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
+	rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFD4, 0xFFFF, 1);
+
+	/* turn on bit 5:Clkrun_mode (from Realtek driver) */
+	//BLA rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG1);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG1, (reg & 0x3F) | 0x80);
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+
+	//why? ALREADY DONE ON rtl8187_add_interface
+	//write_nic_dword(dev, MAC0, ((u32*)dev->dev_addr)[0]);
+	//write_nic_word(dev, MAC4, ((u32*)dev->dev_addr)[1] & 0xffff );
+        //rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
+	printk("SETTING MAC_ADDR: ");
+        for (i = 0; i < ETH_ALEN; i++) {
+                rtl818x_iowrite8(priv, &priv->map->MAC[i],
+                                 dev->wiphy->perm_addr[i]);
+		printk("%x ", dev->wiphy->perm_addr[i]);
+	}
+	printk("\n");
+        //rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+
+	rtl818x_iowrite8(priv, &priv->map->WPA_CONF, 0);
+	//TODO: can we use ARRAY_SIZE?
+	for(i = 0; i < (sizeof(rtl8187b_reg_table)/3)/sizeof(u32); i++) {
+		rtl818x_iowrite8_idx(priv,
+				     (u8 *) (rtl8187b_reg_table[i][0] | 0xFF00),
+				     rtl8187b_reg_table[i][1],
+				     rtl8187b_reg_table[i][2]);
+	}
+
+	rtl818x_iowrite16(priv, (__le16 *)0xFFE8, 0xFA50); // TODO: add flag TID_AC_MAP
+	rtl818x_iowrite16(priv, (__le16 *)0xFFE2, 0); // TODO: add flag INT_MIG
+
+	// Prevent TPC to cause CRC error. Added by Annie (???)
+	rtl818x_iowrite32_idx(priv, (__le32 *)0xFFF0, 0, 1);
+	rtl818x_iowrite32_idx(priv, (__le32 *)0xFFF4, 0, 1);
+	rtl818x_iowrite8_idx(priv, (u8 *)0xFFF8, 0, 1);
+
+	rtl818x_iowrite32(priv, &priv->map->RF_TIMING, 0x00004001);
+
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF72, 0x569A, 2);
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE;
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+
+	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
+	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x2488);
+	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
+	msleep(100); msleep(1000); //TODO: why so long?
+
+	//PhyConfig8187 ???
+	rtl8225_write(dev, 0x0, 0x0B7); msleep(1);
+	rtl8225_write(dev, 0x1, 0xEE0); msleep(1);
+	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
+	rtl8225_write(dev, 0x3, 0x441); msleep(1);
+	rtl8225_write(dev, 0x4, 0x8C3); msleep(1);
+	rtl8225_write(dev, 0x5, 0xC72); msleep(1);
+	rtl8225_write(dev, 0x6, 0x0E6); msleep(1);
+	rtl8225_write(dev, 0x7, 0x82A); msleep(1);
+	rtl8225_write(dev, 0x8, 0x03F); msleep(1);
+	rtl8225_write(dev, 0x9, 0x335); msleep(1);
+	rtl8225_write(dev, 0xa, 0x9D4); msleep(1);
+	rtl8225_write(dev, 0xb, 0x7BB); msleep(1);
+	rtl8225_write(dev, 0xc, 0x850); msleep(1);
+	rtl8225_write(dev, 0xd, 0xCDF); msleep(1);
+	rtl8225_write(dev, 0xe, 0x02B); msleep(1);
+	rtl8225_write(dev, 0xf, 0x114); msleep(1);
+
+	rtl8225_write(dev, 0x0, 0x1B7); msleep(1);
+
+	for (i = 0; i < ARRAY_SIZE(rtl8225z2_rxgain); i++) {
+		rtl8225_write(dev, 0x1, i + 1); msleep(1);
+		rtl8225_write(dev, 0x2, rtl8225z2_rxgain[i]); msleep(1);
+	}
+
+	rtl8225_write(dev, 0x3, 0x080); msleep(1);
+	rtl8225_write(dev, 0x5, 0x004); msleep(1);
+	rtl8225_write(dev, 0x0, 0x0B7); msleep(1);
+	msleep(1000); msleep(1000); msleep(1000); //TODO: why so long?
+
+	rtl8225_write(dev, 0x2, 0xC4D); msleep(1);
+	msleep(1000); msleep(1000); //TODO: why so long?
+
+	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
+	rtl8225_write(dev, 0x0, 0x2BF); msleep(1);
+
+	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK, 0x03);
+	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM, 0x07);
+	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);
+
+	rtl8225_write_phy_ofdm(dev, 0x80, 0x12);
+	for (i = 0; i < ARRAY_SIZE(rtl8225z2_agc); i++) {
+		rtl8225_write_phy_ofdm(dev, 0xF, rtl8225z2_agc[i]);
+		rtl8225_write_phy_ofdm(dev, 0xE, 0x80 + i);
+		rtl8225_write_phy_ofdm(dev, 0xE, 0);
+	}
+	rtl8225_write_phy_ofdm(dev, 0x80, 0x10);
+
+	for (i = 0; i < ARRAY_SIZE(rtl8225z2_ofdm); i++) {
+		rtl8225_write_phy_ofdm(dev, i, rtl8225z2_ofdm[i]);
+	}
+
+	// huh?
+	//ActSetWirelessMode8187(dev, (u8)(InitWirelessMode));
+	/*ChnlAccessSetting->SIFS_Timer = 0x22;
+	ChnlAccessSetting->SlotTimeTimer = 9;
+	ChnlAccessSetting->DIFS_Timer = 28;
+	ChnlAccessSetting->EIFS_Timer = 0x5B;
+	ChnlAccessSetting->CWminIndex = 3;
+	ChnlAccessSetting->CWmaxIndex = 7;
+	write_nic_byte(dev, SIFS, ChnlAccessSetting->SIFS_Timer);
+	write_nic_byte(dev, SLOT, ChnlAccessSetting->SlotTimeTimer);
+	u8 u1bAIFS = 28;
+	write_nic_byte(dev, AC_VO_PARAM, u1bAIFS);
+	write_nic_byte(dev, AC_VI_PARAM, u1bAIFS);
+	write_nic_byte(dev, AC_BE_PARAM, u1bAIFS);
+	write_nic_byte(dev, AC_BK_PARAM, u1bAIFS);
+	write_nic_byte(dev, EIFS_8187B, ChnlAccessSetting->EIFS_Timer);
+	write_nic_byte(dev, AckTimeOutReg, 0x5B);
+	u4bAcParam = (7 << 12) | (3 << 8) | 28*/
+
+	rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
+	rtl818x_iowrite8(priv, &priv->map->SLOT, 9);
+	rtl818x_iowrite8(priv, (u8 *)0xFFF0, 28);
+	rtl818x_iowrite8(priv, (u8 *)0xFFF4, 28);
+	rtl818x_iowrite8(priv, (u8 *)0xFFF8, 28);
+	rtl818x_iowrite8(priv, (u8 *)0xFFFC, 28);
+	rtl818x_iowrite8(priv, (u8 *)0xFF2D, 0x5B);
+	rtl818x_iowrite8(priv, (u8 *)0xFF79, 0x5B);
+	rtl818x_iowrite32(priv, (__le32 *)0xFFF0, (7 << 12) | (3 << 8) | 28);
+	rtl818x_iowrite32(priv, (__le32 *)0xFFF4, (7 << 12) | (3 << 8) | 28);
+	rtl818x_iowrite32(priv, (__le32 *)0xFFF8, (7 << 12) | (3 << 8) | 28);
+	rtl818x_iowrite32(priv, (__le32 *)0xFFFC, (7 << 12) | (3 << 8) | 28);
+	rtl818x_iowrite8(priv, (u8 *)0xFFBF, 0);
+
+	//added for init gain TODO: why?
+	rtl8225_write_phy_ofdm(dev, 0x97, 0x46); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0xa4, 0xb6); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x85, 0xfc); msleep(1);
+	rtl8225_write_phy_cck(dev, 0xc1, 0x88); msleep(1);
+}
+
 void rtl8225_rf_stop(struct ieee80211_hw *dev)
 {
 	u8 reg;
@@ -735,10 +1059,7 @@ void rtl8225_rf_set_channel(struct ieee8
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	if (priv->rf_init == rtl8225_rf_init)
-		rtl8225_rf_set_tx_power(dev, channel);
-	else
-		rtl8225z2_rf_set_tx_power(dev, channel);
+	priv->rf_set_tx_power(dev, channel);
 
 	rtl8225_write(dev, 0x7, rtl8225_chan[channel - 1]);
 	msleep(10);


-- 
[]'s
Herton
