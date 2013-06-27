Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:45124 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3F0Moh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 08:44:37 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 02/18] mac80211/rc80211: add chandef to rate initialization
Date: Thu, 27 Jun 2013 14:44:08 +0200
Message-Id: <1372337064-19254-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_144449_052788_6E5B9F1B)
In-Reply-To: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

5 and 10 MHz support needs to know the current operating channel width,
add the chandef to the rate control API.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/rc.c     |    2 ++
 drivers/net/wireless/iwlegacy/3945-rs.c |    1 +
 drivers/net/wireless/iwlegacy/4965-rs.c |    1 +
 drivers/net/wireless/iwlwifi/dvm/rs.c   |    3 ++-
 drivers/net/wireless/iwlwifi/mvm/rs.c   |    5 +++--
 drivers/net/wireless/rtlwifi/rc.c       |    1 +
 include/net/mac80211.h                  |    2 ++
 net/mac80211/rate.h                     |   22 +++++++++++++++++-----
 net/mac80211/rc80211_minstrel.c         |    3 ++-
 net/mac80211/rc80211_minstrel_ht.c      |   10 +++++++---
 net/mac80211/rc80211_pid_algo.c         |    1 +
 11 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 7eb1f4b..a3c4ca0 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1275,6 +1275,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 }
 
 static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
+			  struct cfg80211_chan_def *chandef,
                           struct ieee80211_sta *sta, void *priv_sta)
 {
 	struct ath_softc *sc = priv;
@@ -1313,6 +1314,7 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 }
 
 static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
+			    struct cfg80211_chan_def *chandef,
 			    struct ieee80211_sta *sta, void *priv_sta,
 			    u32 changed)
 {
diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index fe31590..aea667b 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -887,6 +887,7 @@ il3945_remove_debugfs(void *il, void *il_sta)
  */
 static void
 il3945_rs_rate_init_stub(void *il_r, struct ieee80211_supported_band *sband,
+			 struct cfg80211_chan_def *chandef,
 			 struct ieee80211_sta *sta, void *il_sta)
 {
 }
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index ed3c42a..3ccbaf7 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2803,6 +2803,7 @@ il4965_rs_remove_debugfs(void *il, void *il_sta)
  */
 static void
 il4965_rs_rate_init_stub(void *il_r, struct ieee80211_supported_band *sband,
+			 struct cfg80211_chan_def *chandef,
 			 struct ieee80211_sta *sta, void *il_sta)
 {
 }
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index 8fe76dc..3bf8ae0 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -3338,7 +3338,8 @@ static void rs_remove_debugfs(void *priv, void *priv_sta)
  * station is added we ignore it.
  */
 static void rs_rate_init_stub(void *priv_r, struct ieee80211_supported_band *sband,
-			 struct ieee80211_sta *sta, void *priv_sta)
+			      struct cfg80211_chan_def *chandef,
+			      struct ieee80211_sta *sta, void *priv_sta)
 {
 }
 static struct rate_control_ops rs_ops = {
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 31587a3..af27967 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -3165,8 +3165,9 @@ static void rs_remove_debugfs(void *mvm, void *mvm_sta)
  * station is added we ignore it.
  */
 static void rs_rate_init_stub(void *mvm_r,
-				 struct ieee80211_supported_band *sband,
-				 struct ieee80211_sta *sta, void *mvm_sta)
+			      struct ieee80211_supported_band *sband,
+			      struct cfg80211_chan_def *chandef,
+			      struct ieee80211_sta *sta, void *mvm_sta)
 {
 }
 static struct rate_control_ops rs_mvm_ops = {
diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index f9f059d..a98acef 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -218,6 +218,7 @@ static void rtl_tx_status(void *ppriv,
 
 static void rtl_rate_init(void *ppriv,
 			  struct ieee80211_supported_band *sband,
+			  struct cfg80211_chan_def *chandef,
 			  struct ieee80211_sta *sta, void *priv_sta)
 {
 }
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a405a7a..9445f38 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4202,8 +4202,10 @@ struct rate_control_ops {
 
 	void *(*alloc_sta)(void *priv, struct ieee80211_sta *sta, gfp_t gfp);
 	void (*rate_init)(void *priv, struct ieee80211_supported_band *sband,
+			  struct cfg80211_chan_def *chandef,
 			  struct ieee80211_sta *sta, void *priv_sta);
 	void (*rate_update)(void *priv, struct ieee80211_supported_band *sband,
+			    struct cfg80211_chan_def *chandef,
 			    struct ieee80211_sta *sta, void *priv_sta,
 			    u32 changed);
 	void (*free_sta)(void *priv, struct ieee80211_sta *sta,
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index d35a5dd..5dedc56 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -66,11 +66,12 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 	}
 
 	sband = local->hw.wiphy->bands[chanctx_conf->def.chan->band];
-	rcu_read_unlock();
 
 	ieee80211_sta_set_rx_nss(sta);
 
-	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
+	ref->ops->rate_init(ref->priv, sband, &chanctx_conf->def, ista,
+			    priv_sta);
+	rcu_read_unlock();
 	set_sta_flag(sta, WLAN_STA_RATE_CONTROL);
 }
 
@@ -81,10 +82,21 @@ static inline void rate_control_rate_update(struct ieee80211_local *local,
 	struct rate_control_ref *ref = local->rate_ctrl;
 	struct ieee80211_sta *ista = &sta->sta;
 	void *priv_sta = sta->rate_ctrl_priv;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 
-	if (ref && ref->ops->rate_update)
-		ref->ops->rate_update(ref->priv, sband, ista,
-				      priv_sta, changed);
+	if (ref && ref->ops->rate_update) {
+		rcu_read_lock();
+
+		chanctx_conf = rcu_dereference(sta->sdata->vif.chanctx_conf);
+		if (WARN_ON(!chanctx_conf)) {
+			rcu_read_unlock();
+			return;
+		}
+
+		ref->ops->rate_update(ref->priv, sband, &chanctx_conf->def,
+				      ista, priv_sta, changed);
+		rcu_read_unlock();
+	}
 	drv_sta_rc_update(local, sta->sdata, &sta->sta, changed);
 }
 
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index ac7ef54..5b25966 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -417,7 +417,8 @@ init_sample_table(struct minstrel_sta_info *mi)
 
 static void
 minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
-               struct ieee80211_sta *sta, void *priv_sta)
+		   struct cfg80211_chan_def *chandef,
+		   struct ieee80211_sta *sta, void *priv_sta)
 {
 	struct minstrel_sta_info *mi = priv_sta;
 	struct minstrel_priv *mp = priv;
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 5b2d301..5256297 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -836,6 +836,7 @@ minstrel_ht_update_cck(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 
 static void
 minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
+			struct cfg80211_chan_def *chandef,
                         struct ieee80211_sta *sta, void *priv_sta)
 {
 	struct minstrel_priv *mp = priv;
@@ -931,22 +932,25 @@ use_legacy:
 	memset(&msp->legacy, 0, sizeof(msp->legacy));
 	msp->legacy.r = msp->ratelist;
 	msp->legacy.sample_table = msp->sample_table;
-	return mac80211_minstrel.rate_init(priv, sband, sta, &msp->legacy);
+	return mac80211_minstrel.rate_init(priv, sband, chandef, sta,
+					   &msp->legacy);
 }
 
 static void
 minstrel_ht_rate_init(void *priv, struct ieee80211_supported_band *sband,
+		      struct cfg80211_chan_def *chandef,
                       struct ieee80211_sta *sta, void *priv_sta)
 {
-	minstrel_ht_update_caps(priv, sband, sta, priv_sta);
+	minstrel_ht_update_caps(priv, sband, chandef, sta, priv_sta);
 }
 
 static void
 minstrel_ht_rate_update(void *priv, struct ieee80211_supported_band *sband,
+			struct cfg80211_chan_def *chandef,
                         struct ieee80211_sta *sta, void *priv_sta,
                         u32 changed)
 {
-	minstrel_ht_update_caps(priv, sband, sta, priv_sta);
+	minstrel_ht_update_caps(priv, sband, chandef, sta, priv_sta);
 }
 
 static void *
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index 502d3ec..958fad0 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -293,6 +293,7 @@ rate_control_pid_get_rate(void *priv, struct ieee80211_sta *sta,
 
 static void
 rate_control_pid_rate_init(void *priv, struct ieee80211_supported_band *sband,
+			   struct cfg80211_chan_def *chandef,
 			   struct ieee80211_sta *sta, void *priv_sta)
 {
 	struct rc_pid_sta_info *spinfo = priv_sta;
-- 
1.7.10.4

