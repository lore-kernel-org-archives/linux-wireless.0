Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57706 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbbH1Iw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 04:52:59 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: use DECLARE_EWMA for ave_beacon_signal
Date: Fri, 28 Aug 2015 10:52:54 +0200
Message-Id: <1440751974-8075-3-git-send-email-johannes@sipsolutions.net> (sfid-20150828_105310_331835_5AC4CA62)
In-Reply-To: <1440751974-8075-1-git-send-email-johannes@sipsolutions.net>
References: <1440751974-8075-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It doesn't seem problematic to change the weight for the average
beacon signal from 3 to 4, so use DECLARE_EWMA. This also makes
the code easier to maintain since bugs like the one fixed in the
previous patch can't happen as easily.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 10 +++-------
 net/mac80211/mlme.c        | 20 ++++++--------------
 net/mac80211/util.c        |  2 +-
 3 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e5b2dcbb6606..904b3bbafd93 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -419,6 +419,8 @@ struct ieee80211_sta_tx_tspec {
 	bool downgraded;
 };
 
+DECLARE_EWMA(beacon_signal, 16, 4)
+
 struct ieee80211_if_managed {
 	struct timer_list timer;
 	struct timer_list conn_mon_timer;
@@ -490,13 +492,7 @@ struct ieee80211_if_managed {
 
 	s16 p2p_noa_index;
 
-	/*
-	 * Weighted average of the signal strength from Beacon frames in the
-	 * current BSS. This is in units of 1/16 of the signal unit to maintain
-	 * accuracy and to speed up calculations, i.e., the value need to be
-	 * divided by 16 to get the actual value.
-	 */
-	int ave_beacon_signal;
+	struct ewma_beacon_signal ave_beacon_signal;
 
 	/*
 	 * Number of Beacon frames used in ave_beacon_signal. This can be used
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b4dd619da21e..cd705e820063 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -82,13 +82,6 @@ MODULE_PARM_DESC(probe_wait_ms,
 		 " before disconnecting (reason 4).");
 
 /*
- * Weight given to the latest Beacon frame when calculating average signal
- * strength for Beacon frames received in the current BSS. This must be
- * between 1 and 15.
- */
-#define IEEE80211_SIGNAL_AVE_WEIGHT	3
-
-/*
  * How many Beacon frames need to have been used in average signal strength
  * before starting to indicate signal change events.
  */
@@ -3376,21 +3369,19 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	/* Track average RSSI from the Beacon frames of the current AP */
 	if (ifmgd->flags & IEEE80211_STA_RESET_SIGNAL_AVE) {
 		ifmgd->flags &= ~IEEE80211_STA_RESET_SIGNAL_AVE;
-		ifmgd->ave_beacon_signal = rx_status->signal * 16;
+		ewma_beacon_signal_init(&ifmgd->ave_beacon_signal);
 		ifmgd->last_cqm_event_signal = 0;
 		ifmgd->count_beacon_signal = 1;
 		ifmgd->last_ave_beacon_signal = 0;
 	} else {
-		ifmgd->ave_beacon_signal =
-			(IEEE80211_SIGNAL_AVE_WEIGHT * rx_status->signal * 16 +
-			 (16 - IEEE80211_SIGNAL_AVE_WEIGHT) *
-			 ifmgd->ave_beacon_signal) / 16;
 		ifmgd->count_beacon_signal++;
 	}
 
+	ewma_beacon_signal_add(&ifmgd->ave_beacon_signal, rx_status->signal);
+
 	if (ifmgd->rssi_min_thold != ifmgd->rssi_max_thold &&
 	    ifmgd->count_beacon_signal >= IEEE80211_SIGNAL_AVE_MIN_COUNT) {
-		int sig = ifmgd->ave_beacon_signal / 16;
+		int sig = ewma_beacon_signal_read(&ifmgd->ave_beacon_signal);
 		int last_sig = ifmgd->last_ave_beacon_signal;
 		struct ieee80211_event event = {
 			.type = RSSI_EVENT,
@@ -3417,10 +3408,11 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	if (bss_conf->cqm_rssi_thold &&
 	    ifmgd->count_beacon_signal >= IEEE80211_SIGNAL_AVE_MIN_COUNT &&
 	    !(sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)) {
-		int sig = ifmgd->ave_beacon_signal / 16;
+		int sig = ewma_beacon_signal_read(&ifmgd->ave_beacon_signal);
 		int last_event = ifmgd->last_cqm_event_signal;
 		int thold = bss_conf->cqm_rssi_thold;
 		int hyst = bss_conf->cqm_rssi_hyst;
+
 		if (sig < thold &&
 		    (last_event == 0 || sig < last_event - hyst)) {
 			ifmgd->last_cqm_event_signal = sig;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1104421bc525..e079b556a990 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2541,7 +2541,7 @@ int ieee80211_ave_rssi(struct ieee80211_vif *vif)
 		/* non-managed type inferfaces */
 		return 0;
 	}
-	return ifmgd->ave_beacon_signal / 16;
+	return ewma_beacon_signal_read(&ifmgd->ave_beacon_signal);
 }
 EXPORT_SYMBOL_GPL(ieee80211_ave_rssi);
 
-- 
2.1.4

