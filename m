Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43150 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985Ab3BKMi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 07:38:27 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 06/14] mac80211: init HT TX data before rate control
Date: Mon, 11 Feb 2013 13:38:10 +0100
Message-Id: <1360586298-15028-7-git-send-email-johannes@sipsolutions.net> (sfid-20130211_133831_623860_AD8B1A58)
In-Reply-To: <1360586298-15028-1-git-send-email-johannes@sipsolutions.net>
References: <[PATCH 00/14] mac80211: HT/VHT handling>
 <1360586298-15028-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In case of connection, the station data is initialised from
the beacon/probe response first and then updated from the
association response. If the latter is different we update
the rate control algorithm and driver. Instead of doing it
this way, set the station data properly with data from the
association response before initializing rate control.

Also simplify the code by passing the station pointer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4487a55..cd00e38 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -175,6 +175,7 @@ static int ecw2cw(int ecw)
 }
 
 static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
+				  struct sta_info *sta,
 				  struct ieee80211_ht_operation *ht_oper,
 				  const u8 *bssid, bool reconfig)
 {
@@ -182,11 +183,13 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *chan;
-	struct sta_info *sta;
 	u32 changed = 0;
 	u16 ht_opmode;
 	bool disable_40 = false;
 
+	if (WARN_ON_ONCE(!sta))
+		return 0;
+
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (WARN_ON(!chanctx_conf)) {
@@ -216,28 +219,19 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 	if (!(ht_oper->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
 		disable_40 = true;
 
-	mutex_lock(&local->sta_mtx);
-	sta = sta_info_get(sdata, bssid);
-
-	if (WARN_ON_ONCE(!sta)) {
-		mutex_unlock(&local->sta_mtx);
-		return changed;
-	}
-
 	if (!(sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
 		disable_40 = true;
 
-	if (!reconfig ||
-	    disable_40 != (sta->sta.bandwidth < IEEE80211_STA_RX_BW_40)) {
+	if (disable_40 != (sta->sta.bandwidth < IEEE80211_STA_RX_BW_40)) {
 		if (disable_40)
 			sta->sta.bandwidth = IEEE80211_STA_RX_BW_20;
 		else
 			sta->sta.bandwidth = ieee80211_sta_cur_vht_bw(sta);
 
-		rate_control_rate_update(local, sband, sta,
-					 IEEE80211_RC_BW_CHANGED);
+		if (reconfig)
+			rate_control_rate_update(local, sband, sta,
+						 IEEE80211_RC_BW_CHANGED);
 	}
-	mutex_unlock(&local->sta_mtx);
 
 	ht_opmode = le16_to_cpu(ht_oper->operation_mode);
 
@@ -2200,6 +2194,12 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
 						    elems.vht_cap_elem, sta);
 
+	if (elems.ht_operation && elems.wmm_param &&
+	    !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
+		changed |= ieee80211_config_ht_tx(sdata, sta,
+						  elems.ht_operation,
+						  cbss->bssid, false);
+
 	rate_control_rate_init(sta);
 
 	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
@@ -2237,11 +2237,6 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		ieee80211_set_wmm_default(sdata, false);
 	changed |= BSS_CHANGED_QOS;
 
-	if (elems.ht_operation && elems.wmm_param &&
-	    !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
-		changed |= ieee80211_config_ht_tx(sdata, elems.ht_operation,
-						  cbss->bssid, false);
-
 	/* set AID and assoc capability,
 	 * ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
@@ -2738,10 +2733,14 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			erp_valid, erp_value);
 
 
+	mutex_lock(&local->sta_mtx);
 	if (elems.ht_cap_elem && elems.ht_operation && elems.wmm_param &&
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
-		changed |= ieee80211_config_ht_tx(sdata, elems.ht_operation,
+		changed |= ieee80211_config_ht_tx(sdata,
+						  sta_info_get(sdata, bssid),
+						  elems.ht_operation,
 						  bssid, true);
+	mutex_unlock(&local->sta_mtx);
 
 	if (elems.country_elem && elems.pwr_constr_elem &&
 	    mgmt->u.probe_resp.capab_info &
-- 
1.8.0

