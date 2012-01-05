Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab2AEPdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 10:33:42 -0500
Message-Id: <20120105153229.158186702@sipsolutions.net> (sfid-20120105_163350_152735_5498BCE5)
Date: Thu, 05 Jan 2012 16:30:50 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] mac80211: call rate control only after init
References: <20120105153043.568616380@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are situations where we don't have the
necessary rate control information yet for
station entries, e.g. when associating. This
currently doesn't really happen due to the
dummy station handling; explicitly disabling
rate control when it's not initialised will
allow us to remove dummy stations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c |    4 ++--
 net/mac80211/rate.c        |    2 +-
 net/mac80211/rate.h        |    1 +
 net/mac80211/sta_info.h    |    2 ++
 4 files changed, 6 insertions(+), 3 deletions(-)

--- a/net/mac80211/debugfs_sta.c	2012-01-05 09:16:57.000000000 +0100
+++ b/net/mac80211/debugfs_sta.c	2012-01-05 11:21:10.000000000 +0100
@@ -63,7 +63,7 @@ static ssize_t sta_flags_read(struct fil
 	test_sta_flag(sta, WLAN_STA_##flg) ? #flg "\n" : ""
 
 	int res = scnprintf(buf, sizeof(buf),
-			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
+			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
 			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
 			    TEST(PS_DRIVER), TEST(AUTHORIZED),
 			    TEST(SHORT_PREAMBLE),
@@ -71,7 +71,7 @@ static ssize_t sta_flags_read(struct fil
 			    TEST(MFP), TEST(BLOCK_BA), TEST(PSPOLL),
 			    TEST(UAPSD), TEST(SP), TEST(TDLS_PEER),
 			    TEST(TDLS_PEER_AUTH), TEST(4ADDR_EVENT),
-			    TEST(INSERTED));
+			    TEST(INSERTED), TEST(RATE_CONTROL));
 #undef TEST
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
--- a/net/mac80211/rate.c	2011-12-10 17:32:28.000000000 +0100
+++ b/net/mac80211/rate.c	2012-01-05 11:22:11.000000000 +0100
@@ -336,7 +336,7 @@ void rate_control_get_rate(struct ieee80
 	int i;
 	u32 mask;
 
-	if (sta) {
+	if (sta && test_sta_flag(sta, WLAN_STA_RATE_CONTROL)) {
 		ista = &sta->sta;
 		priv_sta = sta->rate_ctrl_priv;
 	}
--- a/net/mac80211/rate.h	2011-11-03 13:48:28.000000000 +0100
+++ b/net/mac80211/rate.h	2012-01-05 11:22:05.000000000 +0100
@@ -62,6 +62,7 @@ static inline void rate_control_rate_ini
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
+	set_sta_flag(sta, WLAN_STA_RATE_CONTROL);
 }
 
 static inline void rate_control_rate_update(struct ieee80211_local *local,
--- a/net/mac80211/sta_info.h	2012-01-05 11:20:04.000000000 +0100
+++ b/net/mac80211/sta_info.h	2012-01-05 11:20:53.000000000 +0100
@@ -53,6 +53,7 @@
  *	reply to other uAPSD trigger frames or PS-Poll.
  * @WLAN_STA_4ADDR_EVENT: 4-addr event was already sent for this frame.
  * @WLAN_STA_INSERTED: This station is inserted into the hash table.
+ * @WLAN_STA_RATE_CONTROL: rate control was initialized for this station.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH,
@@ -73,6 +74,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_SP,
 	WLAN_STA_4ADDR_EVENT,
 	WLAN_STA_INSERTED,
+	WLAN_STA_RATE_CONTROL,
 };
 
 #define STA_TID_NUM 16


