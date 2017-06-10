Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60208 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751955AbdFJKwz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Jun 2017 06:52:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Sat, 10 Jun 2017 13:52:44 +0300
Message-Id: <20170610105246.26455-3-luca@coelho.fi> (sfid-20170610_125402_879959_6F3C08DB)
In-Reply-To: <20170610105246.26455-1-luca@coelho.fi>
References: <20170610105246.26455-1-luca@coelho.fi>
Subject: [PATCH 2/4] mac80211: remove 5/10 MHz rate code from station MLME
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need for the station MLME code to handle bitrates for 5
or 10 MHz channels when it can't ever create such a configuration.
Remove the unnecessary code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 570d9ab61950..1929bce8e518 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -601,7 +601,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *chan;
-	u32 rate_flags, rates = 0;
+	u32 rates = 0;
 
 	sdata_assert_lock(sdata);
 
@@ -612,7 +612,6 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 	chan = chanctx_conf->def.chan;
-	rate_flags = ieee80211_chandef_rate_flags(&chanctx_conf->def);
 	rcu_read_unlock();
 	sband = local->hw.wiphy->bands[chan->band];
 	shift = ieee80211_vif_get_shift(&sdata->vif);
@@ -636,9 +635,6 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		 */
 		rates_len = 0;
 		for (i = 0; i < sband->n_bitrates; i++) {
-			if ((rate_flags & sband->bitrates[i].flags)
-			    != rate_flags)
-				continue;
 			rates |= BIT(i);
 			rates_len++;
 		}
@@ -2817,7 +2813,7 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
 				u32 *rates, u32 *basic_rates,
 				bool *have_higher_than_11mbit,
 				int *min_rate, int *min_rate_index,
-				int shift, u32 rate_flags)
+				int shift)
 {
 	int i, j;
 
@@ -2845,8 +2841,6 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
 			int brate;
 
 			br = &sband->bitrates[j];
-			if ((rate_flags & br->flags) != rate_flags)
-				continue;
 
 			brate = DIV_ROUND_UP(br->bitrate, (1 << shift) * 5);
 			if (brate == rate) {
@@ -4414,27 +4408,15 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		u32 rates = 0, basic_rates = 0;
 		bool have_higher_than_11mbit;
 		int min_rate = INT_MAX, min_rate_index = -1;
-		struct ieee80211_chanctx_conf *chanctx_conf;
 		const struct cfg80211_bss_ies *ies;
 		int shift = ieee80211_vif_get_shift(&sdata->vif);
-		u32 rate_flags;
-
-		rcu_read_lock();
-		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-		if (WARN_ON(!chanctx_conf)) {
-			rcu_read_unlock();
-			sta_info_free(local, new_sta);
-			return -EINVAL;
-		}
-		rate_flags = ieee80211_chandef_rate_flags(&chanctx_conf->def);
-		rcu_read_unlock();
 
 		ieee80211_get_rates(sband, bss->supp_rates,
 				    bss->supp_rates_len,
 				    &rates, &basic_rates,
 				    &have_higher_than_11mbit,
 				    &min_rate, &min_rate_index,
-				    shift, rate_flags);
+				    shift);
 
 		/*
 		 * This used to be a workaround for basic rates missing
-- 
2.11.0
