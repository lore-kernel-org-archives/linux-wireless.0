Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55531 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZCaKRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 06:17:41 -0400
Message-Id: <20090331101316.650149666@sipsolutions.net> (sfid-20090331_121744_132751_D0057CAC)
References: <20090331101204.540183860@sipsolutions.net>
Date: Tue, 31 Mar 2009 12:12:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Subject: [PATCH v3 3/3] mac80211: include HT capabilities in probe request
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Include the HT capabilities in the probe request frame.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: fix the HT IE

 net/mac80211/main.c |    5 +++++
 net/mac80211/util.c |   16 ++++++++++++++++
 2 files changed, 21 insertions(+)

--- wireless-testing.orig/net/mac80211/util.c	2009-03-31 11:48:51.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-03-31 11:48:51.000000000 +0200
@@ -862,6 +862,22 @@ int ieee80211_build_preq_ies(struct ieee
 		*pos++ = rate->bitrate / 5;
 	}
 
+	if (sband->ht_cap.ht_supported) {
+		__le16 tmp = cpu_to_le16(sband->ht_cap.cap);
+
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
+		memcpy(pos, &tmp, sizeof(u16));
+		pos += sizeof(u16);
+		/* TODO: needs a define here for << 2 */
+		*pos++ = sband->ht_cap.ampdu_factor |
+			 (sband->ht_cap.ampdu_density << 2);
+		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
+		pos += sizeof(sband->ht_cap.mcs);
+		pos += 2 + 4 + 1; /* ext info, BF cap, antsel */
+	}
+
 	/*
 	 * If adding more here, adjust code in main.c
 	 * that calculates local->scan_ies_len.
--- wireless-testing.orig/net/mac80211/main.c	2009-03-31 11:48:51.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-03-31 11:48:51.000000000 +0200
@@ -818,6 +818,7 @@ int ieee80211_register_hw(struct ieee802
 	struct net_device *mdev;
 	struct ieee80211_master_priv *mpriv;
 	int channels, i, j, max_bitrates;
+	bool supp_ht;
 
 	/*
 	 * generic code guarantees at least one band,
@@ -826,6 +827,7 @@ int ieee80211_register_hw(struct ieee802
 	 */
 	channels = 0;
 	max_bitrates = 0;
+	supp_ht = false;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		struct ieee80211_supported_band *sband;
 
@@ -842,6 +844,7 @@ int ieee80211_register_hw(struct ieee802
 
 		if (max_bitrates < sband->n_bitrates)
 			max_bitrates = sband->n_bitrates;
+		supp_ht = supp_ht || sband->ht_cap.ht_supported;
 	}
 
 	local->int_scan_req.n_channels = channels;
@@ -868,6 +871,8 @@ int ieee80211_register_hw(struct ieee802
 	 * information -- SSID is the driver's responsibility.
 	 */
 	local->scan_ies_len = 4 + max_bitrates; /* (ext) supp rates */
+	if (supp_ht)
+		local->scan_ies_len += 2 + sizeof(struct ieee80211_ht_cap);
 
 	if (!local->ops->hw_scan) {
 		/* For hw_scan, driver needs to set these up. */

-- 

