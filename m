Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57701 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbbH1Iw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 04:52:59 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] mac80211: remove last_beacon/ave_beacon debugfs files
Date: Fri, 28 Aug 2015 10:52:52 +0200
Message-Id: <1440751974-8075-1-git-send-email-johannes@sipsolutions.net> (sfid-20150828_105305_616339_D8C9D173)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These file aren't really useful:
 - if per beacon data is required then you need to use
   radiotap or similar anyway, debugfs won't help much
 - average beacon signal is reported in station info in
   nl80211 and can be looked up with iw

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_netdev.c | 12 ------------
 net/mac80211/ieee80211_i.h    |  3 ---
 net/mac80211/mlme.c           |  1 -
 3 files changed, 16 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 1021e87c051f..1d94419801f8 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -114,14 +114,6 @@ static ssize_t ieee80211_if_fmt_##name(					\
 	return scnprintf(buf, buflen, "%pM\n", sdata->field);		\
 }
 
-#define IEEE80211_IF_FMT_DEC_DIV_16(name, field)			\
-static ssize_t ieee80211_if_fmt_##name(					\
-	const struct ieee80211_sub_if_data *sdata,			\
-	char *buf, int buflen)						\
-{									\
-	return scnprintf(buf, buflen, "%d\n", sdata->field / 16);	\
-}
-
 #define IEEE80211_IF_FMT_JIFFIES_TO_MS(name, field)			\
 static ssize_t ieee80211_if_fmt_##name(					\
 	const struct ieee80211_sub_if_data *sdata,			\
@@ -247,8 +239,6 @@ IEEE80211_IF_FILE_R(hw_queues);
 /* STA attributes */
 IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
 IEEE80211_IF_FILE(aid, u.mgd.aid, DEC);
-IEEE80211_IF_FILE(last_beacon, u.mgd.last_beacon_signal, DEC);
-IEEE80211_IF_FILE(ave_beacon, u.mgd.ave_beacon_signal, DEC_DIV_16);
 IEEE80211_IF_FILE(beacon_timeout, u.mgd.beacon_timeout, JIFFIES_TO_MS);
 
 static int ieee80211_set_smps(struct ieee80211_sub_if_data *sdata,
@@ -606,8 +596,6 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(bssid);
 	DEBUGFS_ADD(aid);
-	DEBUGFS_ADD(last_beacon);
-	DEBUGFS_ADD(ave_beacon);
 	DEBUGFS_ADD(beacon_timeout);
 	DEBUGFS_ADD_MODE(smps, 0600);
 	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6e52659f923f..e5b2dcbb6606 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -490,9 +490,6 @@ struct ieee80211_if_managed {
 
 	s16 p2p_noa_index;
 
-	/* Signal strength from the last Beacon frame in the current BSS. */
-	int last_beacon_signal;
-
 	/*
 	 * Weighted average of the signal strength from Beacon frames in the
 	 * current BSS. This is in units of 1/16 of the signal unit to maintain
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 705ef1d040ed..a56a3274236c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3374,7 +3374,6 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	bssid = ifmgd->associated->bssid;
 
 	/* Track average RSSI from the Beacon frames of the current AP */
-	ifmgd->last_beacon_signal = rx_status->signal;
 	if (ifmgd->flags & IEEE80211_STA_RESET_SIGNAL_AVE) {
 		ifmgd->flags &= ~IEEE80211_STA_RESET_SIGNAL_AVE;
 		ifmgd->ave_beacon_signal = rx_status->signal * 16;
-- 
2.1.4

