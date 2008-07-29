Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:54862 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbYG2DZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 23:25:13 -0400
Message-ID: <488E8D94.9050405@lwfinger.net> (sfid-20080729_052517_223690_9E90FFD1)
Date: Mon, 28 Jul 2008 22:25:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>
Subject: [PATCH] rtl8187: Improve wireless statistics for RTL8187B
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless statistics produced by the RTL8187B driver are not particularly
informative about the strength of the received signal. From the data sheet
provided by Realtek, I discovered that certain parts of the RX header
should have the information necessary to calculate signal quality and
strength. With testing, it became clear that most of these quantities were
very jittery - only the AGC correlated with the signals expected from nearby
AP's. As a result, the quality and strength are derived from the agc value.
The scaling has been determined so that the numbers are close to those
obtained by b43 under the same conditions. The results are qualitatively
correct.

Statistics derived for the RTL8187 have not been changed.

The RX header variables have been renamed to match the quantites described
in the Realtek data sheet.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John.

This is 2.6.27 material.

Larry


Index: wireless-testing/drivers/net/wireless/rtl8187.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187.h
+++ wireless-testing/drivers/net/wireless/rtl8187.h
@@ -47,11 +47,13 @@ struct rtl8187_rx_hdr {
  struct rtl8187b_rx_hdr {
  	__le32 flags;
  	__le64 mac_time;
-	u8 noise;
-	u8 signal;
+	u8 sq;
+	u8 rssi;
  	u8 agc;
-	u8 reserved;
-	__le32 unused;
+	u8 flags2;
+	__le16 snr_long2end;
+	s8 pwdb_g12;
+	u8 fot;
  } __attribute__((packed));

  /* {rtl8187,rtl8187b}_tx_info is in skb */
Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
@@ -273,6 +266,7 @@ static void rtl8187_rx_cb(struct urb *ur
  	struct ieee80211_rx_status rx_status = { 0 };
  	int rate, signal;
  	u32 flags;
+	u32 quality;

  	spin_lock(&priv->rx_queue.lock);
  	if (skb->next)
@@ -296,44 +290,57 @@ static void rtl8187_rx_cb(struct urb *ur
  		flags = le32_to_cpu(hdr->flags);
  		signal = hdr->signal & 0x7f;
  		rx_status.antenna = (hdr->signal >> 7) & 1;
-		rx_status.signal = signal;
  		rx_status.noise = hdr->noise;
  		rx_status.mactime = le64_to_cpu(hdr->mac_time);
-		priv->signal = signal;
  		priv->quality = signal;
+		rx_status.qual = priv->quality;
  		priv->noise = hdr->noise;
+		rate = (flags >> 20) & 0xF;
+		if (rate > 3) {	/* OFDM rate */
+			if (signal > 90)
+				signal = 90;
+			else if (signal < 25)
+				signal = 25;
+			signal = 90 - signal;
+		} else {	/* CCK rate */
+			if (signal > 95)
+				signal = 95;
+			else if (signal < 30)
+				signal = 30;
+			signal = 95 - signal;
+		}
+		rx_status.signal = signal;
+		priv->signal = signal;
  	} else {
  		struct rtl8187b_rx_hdr *hdr =
  			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
+		/* The Realtek datasheet for the RTL8187B shows that the RX
+		 * header contains the following quantities: signal quality,
+		 * RSSI, AGC, the received power in dB, and the measured SNR.
+		 * In testing, none of these quantities show qualitative
+		 * agreement with AP signal strength, except for the AGC,
+		 * which is inversely proportional to the strength of the
+		 * signal. In the following, the quality and signal strength
+		 * are derived from the AGC. The arbitrary scaling constants
+		 * are chosen to make the results close to the values obtained
+		 * for a BCM4312 using b43 as the driver. The noise is ignored
+		 * for now.
+		 */
  		flags = le32_to_cpu(hdr->flags);
-		signal = hdr->agc >> 1;
-		rx_status.antenna = (hdr->signal >> 7) & 1;
-		rx_status.signal = 64 - min(hdr->noise, (u8)64);
-		rx_status.noise = hdr->noise;
+		quality = 170 - hdr->agc;
+		if (quality > 100)
+			quality = 100;
+		signal = 14 - hdr->agc / 2;
+		rx_status.qual = quality;
+		priv->quality = quality;
+		rx_status.signal = signal;
+		priv->signal = signal;
+		rx_status.antenna = (hdr->rssi >> 7) & 1;
  		rx_status.mactime = le64_to_cpu(hdr->mac_time);
-		priv->signal = hdr->signal;
-		priv->quality = hdr->agc >> 1;
-		priv->noise = hdr->noise;
+		rate = (flags >> 20) & 0xF;
  	}

  	skb_trim(skb, flags & 0x0FFF);
-	rate = (flags >> 20) & 0xF;
-	if (rate > 3) {	/* OFDM rate */
-		if (signal > 90)
-			signal = 90;
-		else if (signal < 25)
-			signal = 25;
-		signal = 90 - signal;
-	} else {	/* CCK rate */
-		if (signal > 95)
-			signal = 95;
-		else if (signal < 30)
-			signal = 30;
-		signal = 95 - signal;
-	}
-
-	rx_status.qual = priv->quality;
-	rx_status.signal = signal;
  	rx_status.rate_idx = rate;
  	rx_status.freq = dev->conf.channel->center_freq;
  	rx_status.band = dev->conf.channel->band;
@@ -1031,9 +1038,7 @@ static int __devinit rtl8187_probe(struc

  	priv->mode = IEEE80211_IF_TYPE_MNTR;
  	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		     IEEE80211_HW_RX_INCLUDES_FCS |
-		     IEEE80211_HW_SIGNAL_UNSPEC;
-	dev->max_signal = 65;
+		     IEEE80211_HW_RX_INCLUDES_FCS;

  	eeprom.data = dev;
  	eeprom.register_read = rtl8187_eeprom_register_read;
@@ -1148,10 +1153,16 @@ static int __devinit rtl8187_probe(struc
  		(*channel++).hw_value = txpwr >> 8;
  	}

-	if (priv->is_rtl8187b)
+	if (priv->is_rtl8187b) {
  		printk(KERN_WARNING "rtl8187: 8187B chip detected. Support "
  			"is EXPERIMENTAL, and could damage your\n"
  			"         hardware, use at your own risk\n");
+		dev->flags |= IEEE80211_HW_SIGNAL_DBM;
+	} else {
+		dev->flags |= IEEE80211_HW_SIGNAL_UNSPEC;
+		dev->max_signal = 65;
+	}
+
  	if ((id->driver_info == DEVICE_RTL8187) && priv->is_rtl8187b)
  		printk(KERN_INFO "rtl8187: inconsistency between id with OEM"
  		       " info!\n");

