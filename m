Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2G0LJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:09:40 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: rename sta to new_sta
Date: Fri, 27 Jul 2012 13:09:36 +0200
Message-Id: <1343387377-7768-1-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130943_742391_03E0FF36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In ieee80211_prep_connection(), the station (if not NULL)
is the new station (representing the AP) that needs to be
added. Rename the variable to "new_sta" to clarify this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b5ba74b..06bd450 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3031,7 +3031,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss *bss = (void *)cbss->priv;
-	struct sta_info *sta = NULL;
+	struct sta_info *new_sta = NULL;
 	bool have_sta = false;
 	int err;
 	int ht_cfreq;
@@ -3050,8 +3050,8 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (!have_sta) {
-		sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
-		if (!sta)
+		new_sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
+		if (!new_sta)
 			return -ENOMEM;
 	}
 
@@ -3122,7 +3122,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	local->oper_channel = cbss->channel;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
-	if (sta) {
+	if (new_sta) {
 		u32 rates = 0, basic_rates = 0;
 		bool have_higher_than_11mbit;
 		int min_rate = INT_MAX, min_rate_index = -1;
@@ -3147,7 +3147,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 			basic_rates = BIT(min_rate_index);
 		}
 
-		sta->sta.supp_rates[cbss->channel->band] = rates;
+		new_sta->sta.supp_rates[cbss->channel->band] = rates;
 		sdata->vif.bss_conf.basic_rates = basic_rates;
 
 		/* cf. IEEE 802.11 9.2.12 */
@@ -3170,10 +3170,10 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 			BSS_CHANGED_BEACON_INT);
 
 		if (assoc)
-			sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
+			sta_info_pre_move_state(new_sta, IEEE80211_STA_AUTH);
 
-		err = sta_info_insert(sta);
-		sta = NULL;
+		err = sta_info_insert(new_sta);
+		new_sta = NULL;
 		if (err) {
 			sdata_info(sdata,
 				   "failed to insert STA entry for the AP (error %d)\n",
-- 
1.7.10.4

