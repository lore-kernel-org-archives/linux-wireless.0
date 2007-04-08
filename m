Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55515
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbXDHKwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 06:52:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: Export duration calculation function
Date: Sun, 8 Apr 2007 12:51:12 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200704081251.12644.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This exports a frame duration calculation library function
to allow drivers easy calculation of the duration field
for some generic frame.

This is needed for drivers like bcm43xx, where we must precalculate
possible duration fields in software (for fallback rates, etc..).


Index: mac80211/include/net/mac80211.h
===================================================================
--- mac80211.orig/include/net/mac80211.h	2007-04-07 23:03:17.000000000 +0200
+++ mac80211/include/net/mac80211.h	2007-04-08 00:50:24.000000000 +0200
@@ -904,6 +904,19 @@ __le16 ieee80211_ctstoself_duration(stru
 				    const struct ieee80211_tx_control *frame_txctl);
 
 /**
+ * ieee80211_generic_frame_duration - Calculate the duration field for a frame
+ * @hw: pointer obtained from ieee80211_alloc_hw().
+ * @frame_len: the length of the frame.
+ * @rate: the rate (in 100kbps) at which the frame is going to be transmitted.
+ *
+ * Calculate the duration field of some generic frame, given its
+ * length and transmission rate (in 100kbps).
+ */
+__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
+					size_t frame_len,
+					int rate);
+
+/**
  * ieee80211_get_buffered_bc - accessing buffered broadcast and multicast frames
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  * @if_id: interface ID from &struct ieee80211_if_init_conf.
Index: mac80211/net/mac80211/ieee80211.c
===================================================================
--- mac80211.orig/net/mac80211/ieee80211.c	2007-04-07 22:55:17.000000000 +0200
+++ mac80211/net/mac80211/ieee80211.c	2007-04-08 01:01:50.000000000 +0200
@@ -205,11 +205,10 @@ void ieee80211_prepare_rates(struct ieee
 			    rate->rate == 60 || rate->rate == 120 ||
 			    rate->rate == 240)
 				rate->flags |= IEEE80211_RATE_MANDATORY;
-			if (rate->rate != 10 && rate->rate != 20 &&
-			    rate->rate != 55 && rate->rate != 110)
-				rate->flags |= IEEE80211_RATE_ERP;
 			break;
 		}
+		if (ieee80211_is_erp_rate(mode->mode, rate->rate))
+			rate->flags |= IEEE80211_RATE_ERP;
 	}
 }
 
@@ -655,6 +654,23 @@ static int ieee80211_frame_duration(stru
 }
 
 
+/* Exported duration function for driver use */
+__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
+					size_t frame_len, int rate)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	u16 dur;
+	int erp;
+
+	erp = ieee80211_is_erp_rate(hw->conf.phymode, rate);
+	dur = ieee80211_frame_duration(local, frame_len, rate,
+				       erp, local->short_preamble);
+
+	return cpu_to_le16(dur);
+}
+EXPORT_SYMBOL(ieee80211_generic_frame_duration);
+
+
 static u16 ieee80211_duration(struct ieee80211_txrx_data *tx, int group_addr,
 			      int next_frag_len)
 {
Index: mac80211/net/mac80211/ieee80211_i.h
===================================================================
--- mac80211.orig/net/mac80211/ieee80211_i.h	2007-04-07 22:55:17.000000000 +0200
+++ mac80211/net/mac80211/ieee80211_i.h	2007-04-08 00:50:24.000000000 +0200
@@ -720,6 +720,23 @@ static inline void bss_tim_clear(struct 
 	spin_unlock_bh(&local->sta_lock);
 }
 
+/**
+ * ieee80211_is_erp_rate - Check if a rate is an ERP rate
+ * @phymode: The PHY-mode for this rate (MODE_IEEE80211...)
+ * @rate: Transmission rate to check, in 100 kbps
+ *
+ * Check if a given rate is an Extended Rate PHY (ERP) rate.
+ */
+static inline int ieee80211_is_erp_rate(int phymode, int rate)
+{
+	if (phymode == MODE_IEEE80211G) {
+		if (rate != 10 && rate != 20 &&
+		    rate != 55 && rate != 110)
+			return 1;
+	}
+	return 0;
+}
+
 /* ieee80211.c */
 int ieee80211_hw_config(struct ieee80211_local *local);
 int ieee80211_if_config(struct net_device *dev);

-- 
Greetings Michael.
