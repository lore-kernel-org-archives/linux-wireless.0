Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13647 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaLNIno (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2014 03:43:44 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: Fix ignored HT override configurations
Date: Sun, 14 Dec 2014 10:38:59 +0200
Message-Id: <1418546339-8782-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141214_094411_571815_8C778AEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

HT override configurations was ignored when choosing the channel
(until now, the override configuration affected only the
capabilities shown in the IEs).

The override configurations received only on association time,
so in this case we should determine the channel again.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 75a9bf5..9ae4c48 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -157,14 +157,18 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct cfg80211_chan_def vht_chandef;
+	struct ieee80211_sta_ht_cap sta_ht_cap;
 	u32 ht_cfreq, ret;
 
+	memcpy(&sta_ht_cap, &sband->ht_cap, sizeof(sta_ht_cap));
+	ieee80211_apply_htcap_overrides(sdata, &sta_ht_cap);
+
 	chandef->chan = channel;
 	chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
 	chandef->center_freq1 = channel->center_freq;
 	chandef->center_freq2 = 0;
 
-	if (!ht_cap || !ht_oper || !sband->ht_cap.ht_supported) {
+	if (!ht_cap || !ht_oper || !sta_ht_cap.ht_supported) {
 		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
 		goto out;
 	}
@@ -197,7 +201,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* check 40 MHz support, if we have it */
-	if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+	if (sta_ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
 		switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 			chandef->width = NL80211_CHAN_WIDTH_40;
@@ -4196,9 +4200,13 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss *bss = (void *)cbss->priv;
 	struct sta_info *new_sta = NULL;
-	bool have_sta = false;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_sta_ht_cap sta_ht_cap;
+	bool have_sta = false, is_override = false;
 	int err;
 
+	sband = local->hw.wiphy->bands[cbss->channel->band];
+
 	if (WARN_ON(!ifmgd->auth_data && !ifmgd->assoc_data))
 		return -EINVAL;
 
@@ -4213,24 +4221,30 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		if (!new_sta)
 			return -ENOMEM;
 	}
-	if (new_sta) {
-		u32 rates = 0, basic_rates = 0;
-		bool have_higher_than_11mbit;
-		int min_rate = INT_MAX, min_rate_index = -1;
-		struct ieee80211_chanctx_conf *chanctx_conf;
-		struct ieee80211_supported_band *sband;
-		const struct cfg80211_bss_ies *ies;
-		int shift;
-		u32 rate_flags;
 
-		sband = local->hw.wiphy->bands[cbss->channel->band];
+	memcpy(&sta_ht_cap, &sband->ht_cap, sizeof(sta_ht_cap));
+	ieee80211_apply_htcap_overrides(sdata, &sta_ht_cap);
 
+	is_override = (sta_ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) !=
+		      (sband->ht_cap.cap &
+		       IEEE80211_HT_CAP_SUP_WIDTH_20_40);
+
+	if (new_sta || is_override) {
 		err = ieee80211_prep_channel(sdata, cbss);
 		if (err) {
 			sta_info_free(local, new_sta);
 			return -EINVAL;
 		}
-		shift = ieee80211_vif_get_shift(&sdata->vif);
+	}
+
+	if (new_sta) {
+		u32 rates = 0, basic_rates = 0;
+		bool have_higher_than_11mbit;
+		int min_rate = INT_MAX, min_rate_index = -1;
+		struct ieee80211_chanctx_conf *chanctx_conf;
+		const struct cfg80211_bss_ies *ies;
+		int shift = ieee80211_vif_get_shift(&sdata->vif);
+		u32 rate_flags;
 
 		rcu_read_lock();
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-- 
1.9.1

