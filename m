Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:48331 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab3GKQHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 12:07:51 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] mac80211: fix regression when initializing ibss wmm params
Date: Thu, 11 Jul 2013 18:07:46 +0200
Message-Id: <1373558866-5756-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130711_180755_480317_D8C02552)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There appear to be two regressions in ibss.c when calling
ieee80211_sta_def_wmm_params():
 * the second argument should be a rate length, not a rate array. This
   was introduced by my commit "mac80211: select and adjust bitrates
   according to channel mode"
 * the third argument is not initialized (anymore), making further
   checks within this function useless.

Since ieee80211_sta_def_wmm_params() is only used by ibss anyway,
remove the function entirely and handle the operating mode decision
immediately.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/mac80211/ibss.c        |   12 ++++++++++--
 net/mac80211/ieee80211_i.h |    3 ---
 net/mac80211/util.c        |   26 --------------------------
 3 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 449702d..83197c3 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -49,9 +49,9 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	struct cfg80211_bss *bss;
 	u32 bss_change, rate_flags, rates = 0, rates_added = 0;
-	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	struct cfg80211_chan_def chandef;
 	enum nl80211_bss_scan_width scan_width;
+	bool have_higher_than_11mbit = false;
 	struct beacon_data *presp;
 	int frame_len;
 	int shift;
@@ -149,6 +149,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
 			continue;
+		if (sband->bitrates[i].bitrate > 110)
+			have_higher_than_11mbit = true;
 
 		rates |= BIT(i);
 		rates_n++;
@@ -270,11 +272,17 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.use_short_slot = chan->band == IEEE80211_BAND_5GHZ;
 	bss_change |= BSS_CHANGED_ERP_SLOT;
 
+	/* cf. IEEE 802.11 9.2.12 */
+	if (chan->band == IEEE80211_BAND_2GHZ && have_higher_than_11mbit)
+		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
+	else
+		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
+
 	sdata->vif.bss_conf.ibss_joined = true;
 	sdata->vif.bss_conf.ibss_creator = creator;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
 
-	ieee80211_sta_def_wmm_params(sdata, rates, supp_rates);
+	ieee80211_set_wmm_default(sdata, true);
 
 	ifibss->state = IEEE80211_IBSS_MLME_JOINED;
 	mod_timer(&ifibss->timer,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 23a191b..3d32df1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1615,9 +1615,6 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      u32 ratemask, bool directed, u32 tx_flags,
 			      struct ieee80211_channel *channel, bool scan);
 
-void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
-				  const size_t supp_rates_len,
-				  const u8 *supp_rates);
 u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band, u32 *basic_rates);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1e45891c..d23c5a7 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1073,32 +1073,6 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
-void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
-				  const size_t supp_rates_len,
-				  const u8 *supp_rates)
-{
-	struct ieee80211_chanctx_conf *chanctx_conf;
-	int i, have_higher_than_11mbit = 0;
-
-	/* cf. IEEE 802.11 9.2.12 */
-	for (i = 0; i < supp_rates_len; i++)
-		if ((supp_rates[i] & 0x7f) * 5 > 110)
-			have_higher_than_11mbit = 1;
-
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-
-	if (chanctx_conf &&
-	    chanctx_conf->def.chan->band == IEEE80211_BAND_2GHZ &&
-	    have_higher_than_11mbit)
-		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
-	else
-		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
-	rcu_read_unlock();
-
-	ieee80211_set_wmm_default(sdata, true);
-}
-
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *da,
-- 
1.7.10.4

