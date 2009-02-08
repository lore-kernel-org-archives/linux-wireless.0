Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59083 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZBHNc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 08:32:27 -0500
Subject: [PATCH] mac80211: calculate wstats_flags on the fly
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 08 Feb 2009 14:32:20 +0100
Message-Id: <1234099940.4175.121.camel@johannes.local> (sfid-20090208_143231_751353_10D7BC06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to make wext.c more self-contained.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/main.c        |    8 --------
 net/mac80211/wext.c        |   21 ++++++++++++++++++---
 3 files changed, 18 insertions(+), 12 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-02-08 13:21:16.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-02-08 13:21:18.000000000 +0100
@@ -596,7 +596,6 @@ struct ieee80211_local {
 	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss;
 	unsigned int filter_flags; /* FIF_* */
 	struct iw_statistics wstats;
-	u8 wstats_flags;
 	bool tim_in_locked_section; /* see ieee80211_beacon_get() */
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
--- wireless-testing.orig/net/mac80211/main.c	2009-02-08 13:21:16.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-02-08 13:23:46.000000000 +0100
@@ -910,14 +910,6 @@ int ieee80211_register_hw(struct ieee802
 
 	local->hw.conf.listen_interval = local->hw.max_listen_interval;
 
-	local->wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
-						  IEEE80211_HW_SIGNAL_DBM) ?
-			       IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
-	local->wstats_flags |= local->hw.flags & IEEE80211_HW_NOISE_DBM ?
-			       IW_QUAL_NOISE_UPDATED : IW_QUAL_NOISE_INVALID;
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
-		local->wstats_flags |= IW_QUAL_DBM;
-
 	result = sta_info_start(local);
 	if (result < 0)
 		goto fail_sta_info;
--- wireless-testing.orig/net/mac80211/wext.c	2009-02-08 13:21:16.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-02-08 13:23:43.000000000 +0100
@@ -145,6 +145,21 @@ static int ieee80211_ioctl_siwgenie(stru
 	return -EOPNOTSUPP;
 }
 
+static u8 ieee80211_get_wstats_flags(struct ieee80211_local *local)
+{
+	u8 wstats_flags = 0;
+
+	wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
+					   IEEE80211_HW_SIGNAL_DBM) ?
+				IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
+	wstats_flags |= local->hw.flags & IEEE80211_HW_NOISE_DBM ?
+				IW_QUAL_NOISE_UPDATED : IW_QUAL_NOISE_INVALID;
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+		wstats_flags |= IW_QUAL_DBM;
+
+	return wstats_flags;
+}
+
 static int ieee80211_ioctl_giwrange(struct net_device *dev,
 				 struct iw_request_info *info,
 				 struct iw_point *data, char *extra)
@@ -187,13 +202,13 @@ static int ieee80211_ioctl_giwrange(stru
 		range->max_qual.noise = 0;
 
 	range->max_qual.qual = 100;
-	range->max_qual.updated = local->wstats_flags;
+	range->max_qual.updated = ieee80211_get_wstats_flags(local);
 
 	range->avg_qual.qual = 50;
 	/* not always true but better than nothing */
 	range->avg_qual.level = range->max_qual.level / 2;
 	range->avg_qual.noise = range->max_qual.noise / 2;
-	range->avg_qual.updated = local->wstats_flags;
+	range->avg_qual.updated = ieee80211_get_wstats_flags(local);
 
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
@@ -967,7 +982,7 @@ static struct iw_statistics *ieee80211_g
 		wstats->qual.level = sta->last_signal;
 		wstats->qual.qual = sta->last_qual;
 		wstats->qual.noise = sta->last_noise;
-		wstats->qual.updated = local->wstats_flags;
+		wstats->qual.updated = ieee80211_get_wstats_flags(local);
 	}
 
 	rcu_read_unlock();


