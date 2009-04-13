Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZDMAkU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2009 20:40:20 -0400
Date: Sun, 12 Apr 2009 19:39:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [RFT/RFC] rtl8187: Remove redundant quality calculation
Message-ID: <49e289df.b/+c2+59HqherrPx%Larry.Finger@lwfinger.net> (sfid-20090413_024034_481677_3F3254E5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that mac80211 does the link quality calculation, that code can be
removed from this driver. In addition, the signal noise calculation
used by the vendor driver has been implemented for RYL8187B. The value
for RTL8187L is fictional.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187.h
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
@@ -37,8 +37,8 @@ struct rtl8187_rx_info {
 
 struct rtl8187_rx_hdr {
 	__le32 flags;
-	u8 noise;
-	u8 signal;
+	u8 sq;
+	u8 rssi;
 	u8 agc;
 	u8 reserved;
 	__le64 mac_time;
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -315,7 +315,6 @@ static void rtl8187_rx_cb(struct urb *ur
 	struct ieee80211_rx_status rx_status = { 0 };
 	int rate, signal;
 	u32 flags;
-	u32 quality;
 	unsigned long f;
 
 	spin_lock_irqsave(&priv->rx_queue.lock, f);
@@ -338,13 +337,13 @@ static void rtl8187_rx_cb(struct urb *ur
 			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
 		flags = le32_to_cpu(hdr->flags);
 		/* As with the RTL8187B below, the AGC is used to calculate
-		 * signal strength and quality. In this case, the scaling
-		 * constants are derived from the output of p54usb.
+		 * signal strength. In this case, the scaling constants are
+		 * derived from the output of p54usb.
 		 */
-		quality = 130 - ((41 * hdr->agc) >> 6);
 		signal = -4 - ((27 * hdr->agc) >> 6);
-		rx_status.antenna = (hdr->signal >> 7) & 1;
+		rx_status.antenna = (hdr->rssi >> 7) & 1;
 		rx_status.mactime = le64_to_cpu(hdr->mac_time);
+		rx_status.noise = hdr->sq - 100;
 	} else {
 		struct rtl8187b_rx_hdr *hdr =
 			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
@@ -354,23 +353,18 @@ static void rtl8187_rx_cb(struct urb *ur
 		 * In testing, none of these quantities show qualitative
 		 * agreement with AP signal strength, except for the AGC,
 		 * which is inversely proportional to the strength of the
-		 * signal. In the following, the quality and signal strength
-		 * are derived from the AGC. The arbitrary scaling constants
-		 * are chosen to make the results close to the values obtained
-		 * for a BCM4312 using b43 as the driver. The noise is ignored
-		 * for now.
+		 * signal. In the following, the signal strength is derived
+		 * from the AGC. The arbitrary scaling constants are chosen
+		 * to make the results close to the values obtained for a
+		 * BCM4312 using b43 as the driver.
 		 */
 		flags = le32_to_cpu(hdr->flags);
-		quality = 170 - hdr->agc;
 		signal = 14 - hdr->agc / 2;
 		rx_status.antenna = (hdr->rssi >> 7) & 1;
 		rx_status.mactime = le64_to_cpu(hdr->mac_time);
+		rx_status.noise = hdr->snr_long2end;
 	}
 
-	if (quality > 100)
-		quality = 100;
-	rx_status.qual = quality;
-	priv->quality = quality;
 	rx_status.signal = signal;
 	priv->signal = signal;
 	rate = (flags >> 20) & 0xF;
@@ -1357,6 +1351,7 @@ static int __devinit rtl8187_probe(struc
 	priv->mode = NL80211_IFTYPE_MONITOR;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_SIGNAL_DBM |
+		     IEEE80211_HW_NOISE_DBM |
 		     IEEE80211_HW_RX_INCLUDES_FCS;
 
 	eeprom.data = dev;
