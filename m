Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZKEGJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 01:09:47 -0500
Date: Thu, 05 Nov 2009 00:09:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Remove deprecated 'qual' from returned RX status
Message-ID: <4af26c2f.v0dYcKOlddHI9QEQ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The qual member of ieee80211_rx_status is deprecated. As a result, this
driver no longer needs to calculate a quality value.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.33 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -320,7 +320,6 @@ static void rtl8187_rx_cb(struct urb *ur
 	struct ieee80211_rx_status rx_status = { 0 };
 	int rate, signal;
 	u32 flags;
-	u32 quality;
 	unsigned long f;
 
 	spin_lock_irqsave(&priv->rx_queue.lock, f);
@@ -338,10 +337,9 @@ static void rtl8187_rx_cb(struct urb *ur
 			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
 		flags = le32_to_cpu(hdr->flags);
 		/* As with the RTL8187B below, the AGC is used to calculate
-		 * signal strength and quality. In this case, the scaling
+		 * signal strength. In this case, the scaling
 		 * constants are derived from the output of p54usb.
 		 */
-		quality = 130 - ((41 * hdr->agc) >> 6);
 		signal = -4 - ((27 * hdr->agc) >> 6);
 		rx_status.antenna = (hdr->signal >> 7) & 1;
 		rx_status.mactime = le64_to_cpu(hdr->mac_time);
@@ -354,23 +352,18 @@ static void rtl8187_rx_cb(struct urb *ur
 		 * In testing, none of these quantities show qualitative
 		 * agreement with AP signal strength, except for the AGC,
 		 * which is inversely proportional to the strength of the
-		 * signal. In the following, the quality and signal strength
-		 * are derived from the AGC. The arbitrary scaling constants
+		 * signal. In the following, the signal strength
+		 * is derived from the AGC. The arbitrary scaling constants
 		 * are chosen to make the results close to the values obtained
 		 * for a BCM4312 using b43 as the driver. The noise is ignored
 		 * for now.
 		 */
 		flags = le32_to_cpu(hdr->flags);
-		quality = 170 - hdr->agc;
 		signal = 14 - hdr->agc / 2;
 		rx_status.antenna = (hdr->rssi >> 7) & 1;
 		rx_status.mactime = le64_to_cpu(hdr->mac_time);
 	}
 
-	if (quality > 100)
-		quality = 100;
-	rx_status.qual = quality;
-	priv->quality = quality;
 	rx_status.signal = signal;
 	priv->signal = signal;
 	rate = (flags >> 20) & 0xF;
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187.h
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
@@ -119,7 +119,6 @@ struct rtl8187_priv {
 	} hw_rev;
 	struct sk_buff_head rx_queue;
 	u8 signal;
-	u8 quality;
 	u8 noise;
 	u8 slot_time;
 	u8 aifsn[4];
