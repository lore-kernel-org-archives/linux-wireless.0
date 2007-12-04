Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbXLEKQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 05:16:39 -0500
Subject: [PATCH] wireless: make drivers include the TSF RX flag where
	appropriate
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 20:33:40 +0100
Message-Id: <1196796820.12472.1.camel@johannes.berg> (sfid-20071205_101642_359540_FF8374C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These drivers pass full mactime information to the stack, make them
indicate this via the new RX_FLAG_TSFT to get mac80211 to show this
information in monitor mode.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
iwlwifi does own radiotap headers (well, tries, it's broken) so is not
modified.

 drivers/net/wireless/b43/xmit.c       |    1 +
 drivers/net/wireless/b43legacy/xmit.c |    1 +
 drivers/net/wireless/p54common.c      |    1 +
 drivers/net/wireless/rtl8180_dev.c    |    1 +
 drivers/net/wireless/rtl8187_dev.c    |    1 +
 5 files changed, 5 insertions(+)

--- everything.orig/drivers/net/wireless/p54common.c	2007-12-04 20:32:32.036952636 +0100
+++ everything/drivers/net/wireless/p54common.c	2007-12-04 20:33:17.886948839 +0100
@@ -314,6 +314,7 @@ static void p54_rx_data(struct ieee80211
 	rx_status.phymode = MODE_IEEE80211G;
 	rx_status.antenna = hdr->antenna;
 	rx_status.mactime = le64_to_cpu(hdr->timestamp);
+	rx_status.flag |= RX_FLAG_TSFT;
 
 	skb_pull(skb, sizeof(*hdr));
 	skb_trim(skb, le16_to_cpu(hdr->len));
--- everything.orig/drivers/net/wireless/b43/xmit.c	2007-12-04 20:32:32.096962565 +0100
+++ everything/drivers/net/wireless/b43/xmit.c	2007-12-04 20:33:11.046949707 +0100
@@ -541,6 +541,7 @@ void b43_rx(struct b43_wldev *dev, struc
 		status.mactime += mactime;
 		if (low_mactime_now <= mactime)
 			status.mactime -= 0x10000;
+		status.flag |= RX_FLAG_TSFT;
 	}
 
 	chanid = (chanstat & B43_RX_CHAN_ID) >> B43_RX_CHAN_ID_SHIFT;
--- everything.orig/drivers/net/wireless/b43legacy/xmit.c	2007-12-04 20:32:32.076950086 +0100
+++ everything/drivers/net/wireless/b43legacy/xmit.c	2007-12-04 20:33:13.996951714 +0100
@@ -548,6 +548,7 @@ void b43legacy_rx(struct b43legacy_wldev
 		status.mactime += mactime;
 		if (low_mactime_now <= mactime)
 			status.mactime -= 0x10000;
+		status.flag |= RX_FLAG_TSFT;
 	}
 
 	chanid = (chanstat & B43legacy_RX_CHAN_ID) >>
--- everything.orig/drivers/net/wireless/rtl8180_dev.c	2007-12-04 20:32:32.136949327 +0100
+++ everything/drivers/net/wireless/rtl8180_dev.c	2007-12-04 20:33:21.696948567 +0100
@@ -103,6 +103,7 @@ static void rtl8180_handle_rx(struct iee
 			rx_status.channel = dev->conf.channel;
 			rx_status.phymode = dev->conf.phymode;
 			rx_status.mactime = le64_to_cpu(entry->tsft);
+			rx_status.flag |= RX_FLAG_TSFT;
 			ieee80211_rx_irqsafe(dev, skb, &rx_status);
 
 			skb = new_skb;
--- everything.orig/drivers/net/wireless/rtl8187_dev.c	2007-12-04 20:32:32.166950629 +0100
+++ everything/drivers/net/wireless/rtl8187_dev.c	2007-12-04 20:33:26.936948459 +0100
@@ -228,6 +228,7 @@ static void rtl8187_rx_cb(struct urb *ur
 	rx_status.channel = dev->conf.channel;
 	rx_status.phymode = dev->conf.phymode;
 	rx_status.mactime = le64_to_cpu(hdr->mac_time);
+	rx_status.flag |= RX_FLAG_TSFT;
 	if (flags & (1 << 13))
 		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 	ieee80211_rx_irqsafe(dev, skb, &rx_status);


