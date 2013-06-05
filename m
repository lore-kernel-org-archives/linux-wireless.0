Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39848 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3FEGyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 02:54:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH] mac80211: fix powersave bug and clean up ieee80211_rx_bss_info
Date: Wed,  5 Jun 2013 08:54:49 +0200
Message-Id: <1370415289-12849-1-git-send-email-johannes@sipsolutions.net> (sfid-20130605_085457_277992_FC27A40D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

ieee80211_rx_bss_info() deals with dtim_period setting and PS update
when associated. Move all these to another locations cleaning this
function. Also, the current implementation is buggy because when it
calls ieee80211_recalc_ps() bss_conf->dtim_period is notset properly
yet and thus nothing will happen.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index df8170a..aa5cd2e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2737,24 +2737,9 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	int freq;
 	struct ieee80211_bss *bss;
 	struct ieee80211_channel *channel;
-	bool need_ps = false;
 
 	sdata_assert_lock(sdata);
 
-	if ((sdata->u.mgd.associated &&
-	     ether_addr_equal(mgmt->bssid, sdata->u.mgd.associated->bssid)) ||
-	    (sdata->u.mgd.assoc_data &&
-	     ether_addr_equal(mgmt->bssid,
-			      sdata->u.mgd.assoc_data->bss->bssid))) {
-		/* not previously set so we may need to recalc */
-		need_ps = sdata->u.mgd.associated && !sdata->u.mgd.dtim_period;
-
-		if (elems->tim && !elems->parse_error) {
-			const struct ieee80211_tim_ie *tim_ie = elems->tim;
-			sdata->u.mgd.dtim_period = tim_ie->dtim_period;
-		}
-	}
-
 	if (elems->ds_params)
 		freq = ieee80211_channel_to_frequency(elems->ds_params[0],
 						      rx_status->band);
@@ -2775,12 +2760,6 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	    !ether_addr_equal(mgmt->bssid, sdata->u.mgd.associated->bssid))
 		return;
 
-	if (need_ps) {
-		mutex_lock(&local->iflist_mtx);
-		ieee80211_recalc_ps(local, -1);
-		mutex_unlock(&local->iflist_mtx);
-	}
-
 	ieee80211_sta_process_chanswitch(sdata, rx_status->mactime,
 					 elems, true);
 
@@ -2894,6 +2873,10 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				       len - baselen, false, &elems);
 
 		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
+		if (elems.tim && !elems.parse_error) {
+			const struct ieee80211_tim_ie *tim_ie = elems.tim;
+			ifmgd->dtim_period = tim_ie->dtim_period;
+		}
 		ifmgd->assoc_data->have_beacon = true;
 		ifmgd->assoc_data->need_beacon = false;
 		if (local->hw.flags & IEEE80211_HW_TIMING_BEACON_ONLY) {
@@ -3096,6 +3079,11 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 
 		changed |= BSS_CHANGED_DTIM_PERIOD;
+
+		mutex_lock(&local->iflist_mtx);
+		ieee80211_recalc_ps(local, -1);
+		mutex_unlock(&local->iflist_mtx);
+
 		ieee80211_recalc_ps_vif(sdata);
 	}
 
-- 
1.8.0

