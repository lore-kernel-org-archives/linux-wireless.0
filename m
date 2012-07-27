Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab2G0LJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:09:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: set channel only once during auth/assoc
Date: Fri, 27 Jul 2012 13:09:51 +0200
Message-Id: <1343387391-7808-1-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130957_390197_DE3CA691)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to set up the channel during auth
and again during assoc, just do it once. Currently
this doesn't result in any changes since calling
hw_config() with an unchanged channel will return
early, but with the channel context work this has
an impact on channel context assignment.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   69 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 06bd450..1ff157e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3025,41 +3025,17 @@ int ieee80211_max_network_latency(struct notifier_block *nb,
 	return 0;
 }
 
-static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
-				     struct cfg80211_bss *cbss, bool assoc)
+static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
+				  struct cfg80211_bss *cbss)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_bss *bss = (void *)cbss->priv;
-	struct sta_info *new_sta = NULL;
-	bool have_sta = false;
-	int err;
 	int ht_cfreq;
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 	const u8 *ht_oper_ie;
 	const struct ieee80211_ht_operation *ht_oper = NULL;
 	struct ieee80211_supported_band *sband;
 
-	if (WARN_ON(!ifmgd->auth_data && !ifmgd->assoc_data))
-		return -EINVAL;
-
-	if (assoc) {
-		rcu_read_lock();
-		have_sta = sta_info_get(sdata, cbss->bssid);
-		rcu_read_unlock();
-	}
-
-	if (!have_sta) {
-		new_sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
-		if (!new_sta)
-			return -ENOMEM;
-	}
-
-	mutex_lock(&local->mtx);
-	ieee80211_recalc_idle(sdata->local);
-	mutex_unlock(&local->mtx);
-
-	/* switch to the right channel */
 	sband = local->hw.wiphy->bands[cbss->channel->band];
 
 	ifmgd->flags &= ~IEEE80211_STA_DISABLE_40MHZ;
@@ -3122,10 +3098,51 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	local->oper_channel = cbss->channel;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
+	return 0;
+}
+
+static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
+				     struct cfg80211_bss *cbss, bool assoc)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_bss *bss = (void *)cbss->priv;
+	struct sta_info *new_sta = NULL;
+	bool have_sta = false;
+	int err;
+
+	if (WARN_ON(!ifmgd->auth_data && !ifmgd->assoc_data))
+		return -EINVAL;
+
+	if (assoc) {
+		rcu_read_lock();
+		have_sta = sta_info_get(sdata, cbss->bssid);
+		rcu_read_unlock();
+	}
+
+	if (!have_sta) {
+		new_sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
+		if (!new_sta)
+			return -ENOMEM;
+	}
+
+	mutex_lock(&local->mtx);
+	ieee80211_recalc_idle(sdata->local);
+	mutex_unlock(&local->mtx);
+
 	if (new_sta) {
 		u32 rates = 0, basic_rates = 0;
 		bool have_higher_than_11mbit;
 		int min_rate = INT_MAX, min_rate_index = -1;
+		struct ieee80211_supported_band *sband;
+
+		sband = local->hw.wiphy->bands[cbss->channel->band];
+
+		err = ieee80211_prep_channel(sdata, cbss);
+		if (err) {
+			sta_info_free(local, new_sta);
+			return err;
+		}
 
 		ieee80211_get_rates(sband, bss->supp_rates,
 				    bss->supp_rates_len,
-- 
1.7.10.4

