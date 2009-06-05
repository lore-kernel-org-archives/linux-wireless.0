Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35535 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbZFEFlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 01:41:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	ipw3945-devel@lists.sourceforge.net,
	Gabor Juhos <juhosg@openwrt.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 14/15] mac80211: move management / no-ack frame rate decision to mac80211
Date: Fri,  5 Jun 2009 01:41:41 -0400
Message-Id: <1244180502-4323-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All rate control algorithms agree to send management and no-ack
frames at the lowest rate. They also agree to do this when sta
and the private rate control data is NULL. We move this to mac80211
and simplify the rate control algorithm code.

Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: ipw3945-devel@lists.sourceforge.net
Cc: Gabor Juhos <juhosg@openwrt.org>
Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c        |   15 --------------
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   20 +------------------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   10 ---------
 net/mac80211/rate.c                        |   29 +++++++++++++++++++++++++++-
 net/mac80211/rc80211_minstrel.c            |   23 ----------------------
 net/mac80211/rc80211_pid_algo.c            |   14 -------------
 6 files changed, 29 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 344b996..2180180 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1538,23 +1538,8 @@ exit:
 static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 			 struct ieee80211_tx_rate_control *txrc)
 {
-	struct ieee80211_supported_band *sband = txrc->sband;
-	struct sk_buff *skb = txrc->skb;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_softc *sc = priv;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
-	__le16 fc = hdr->frame_control;
-
-	/* lowest rate for management and NO_ACK frames */
-	if (!ieee80211_is_data(fc) ||
-	    tx_info->flags & IEEE80211_TX_CTL_NO_ACK || !sta) {
-		tx_info->control.rates[0].idx = rate_lowest_index(sband, sta);
-		tx_info->control.rates[0].count =
-			(tx_info->flags & IEEE80211_TX_CTL_NO_ACK) ?
-				1 : ATH_MGT_TXMAXTRY;
-		return;
-	}
 
 	/* Find tx rate for unicast frames */
 	ath_rc_ratefind(sc, ath_rc_priv, txrc, sta);
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index bd2f709..7b6567b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -673,7 +673,6 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	s8 scale_action = 0;
 	unsigned long flags;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	__le16 fc;
 	u16 rate_mask = 0;
 	s8 max_rate_idx = -1;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
@@ -681,24 +680,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 
 	IWL_DEBUG_RATE(priv, "enter\n");
 
-	if (sta)
-		rate_mask = sta->supp_rates[sband->band];
-
-	/* Send management frames and NO_ACK data using lowest rate. */
-	fc = hdr->frame_control;
-	if (!ieee80211_is_data(fc) || info->flags & IEEE80211_TX_CTL_NO_ACK ||
-	    !sta || !priv_sta) {
-		IWL_DEBUG_RATE(priv, "leave: No STA priv data to update!\n");
-		if (!rate_mask)
-			info->control.rates[0].idx =
-					rate_lowest_index(sband, NULL);
-		else
-			info->control.rates[0].idx =
-					rate_lowest_index(sband, sta);
-		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
-			info->control.rates[0].count = 1;
-		return;
-	}
+	rate_mask = sta->supp_rates[sband->band];
 
 	/* get user max rate if set */
 	max_rate_idx = txrc->max_rate_idx;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index ff20e50..0052e8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2012,7 +2012,6 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 {
 	struct ieee80211_hw *hw = priv->hw;
 	struct ieee80211_conf *conf = &hw->conf;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	int low = IWL_RATE_INVALID;
 	int high = IWL_RATE_INVALID;
@@ -2039,15 +2038,6 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 	IWL_DEBUG_RATE(priv, "rate scale calculate new rate for skb\n");
 
-	/* Send management frames and NO_ACK data using lowest rate. */
-	/* TODO: this could probably be improved.. */
-	if (!ieee80211_is_data(hdr->frame_control) ||
-	    info->flags & IEEE80211_TX_CTL_NO_ACK)
-		return;
-
-	if (!sta || !lq_sta)
-		return;
-
 	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
 
 	tid = rs_tl_add_packet(lq_sta, hdr);
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 4641f00..2795f70 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -198,11 +198,24 @@ static void rate_control_release(struct kref *kref)
 	kfree(ctrl_ref);
 }
 
+static bool rc_no_data_or_no_ack(struct ieee80211_tx_rate_control *txrc)
+{
+	struct sk_buff *skb = txrc->skb;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	__le16 fc;
+
+	fc = hdr->frame_control;
+
+	return ((info->flags & IEEE80211_TX_CTL_NO_ACK) || !ieee80211_is_data(fc));
+}
+
 void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 			   struct sta_info *sta,
 			   struct ieee80211_tx_rate_control *txrc)
 {
 	struct rate_control_ref *ref = sdata->local->rate_ctrl;
+	struct ieee80211_hw *hw = &sdata->local->hw;
 	void *priv_sta = NULL;
 	struct ieee80211_sta *ista = NULL;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
@@ -222,7 +235,21 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	if (sta && sdata->force_unicast_rateidx > -1) {
 		info->control.rates[0].idx = sdata->force_unicast_rateidx;
 	} else {
-		ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
+		/*
+		 * Lets not bother rate control algos with this as they
+		 * all agree to use the lowest rate to send management frames
+		 * and NO_ACK data with the respective hw retries. This also
+		 * guarantees we don't call the rate control get_rate()
+		 * callback with a NULL sta or NULL private RC data.
+		 */
+		if (!ista || !priv_sta || rc_no_data_or_no_ack(txrc)) {
+			info->control.rates[0].idx =
+				rate_lowest_index(txrc->sband, ista);
+			info->control.rates[0].count =
+				(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
+				1 : hw->max_rate_tries;
+		} else
+			ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
 		info->flags |= IEEE80211_TX_INTFL_RCALGO;
 	}
 
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 0e1db92..40c1ba4 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -70,19 +70,6 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
 	return i;
 }
 
-static inline bool
-use_low_rate(struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	__le16 fc;
-
-	fc = hdr->frame_control;
-
-	return ((info->flags & IEEE80211_TX_CTL_NO_ACK) || !ieee80211_is_data(fc));
-}
-
-
 static void
 minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 {
@@ -228,7 +215,6 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 		  void *priv_sta, struct ieee80211_tx_rate_control *txrc)
 {
 	struct sk_buff *skb = txrc->skb;
-	struct ieee80211_supported_band *sband = txrc->sband;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct minstrel_sta_info *mi = priv_sta;
 	struct minstrel_priv *mp = priv;
@@ -241,15 +227,6 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	int mrr_ndx[3];
 	int sample_rate;
 
-	if (!sta || !mi || use_low_rate(skb)) {
-		ar[0].idx = rate_lowest_index(sband, sta);
-		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
-			ar[0].count = 1;
-		else
-			ar[0].count = mp->max_retry;
-		return;
-	}
-
 	mrr = mp->has_mrr && !txrc->rts && !txrc->bss_conf->use_cts_prot;
 
 	if (time_after(jiffies, mi->stats_update + (mp->update_interval *
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index ac6dad6..1dad177 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -274,13 +274,10 @@ rate_control_pid_get_rate(void *priv, struct ieee80211_sta *sta,
 			  void *priv_sta,
 			  struct ieee80211_tx_rate_control *txrc)
 {
-	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_supported_band *sband = txrc->sband;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct rc_pid_sta_info *spinfo = priv_sta;
 	int rateidx;
-	__le16 fc;
 
 	if (txrc->rts)
 		info->control.rates[0].count =
@@ -289,17 +286,6 @@ rate_control_pid_get_rate(void *priv, struct ieee80211_sta *sta,
 		info->control.rates[0].count =
 			txrc->hw->conf.short_frame_max_tx_count;
 
-	/* Send management frames and NO_ACK data using lowest rate. */
-	fc = le16_to_cpu(hdr->frame_control);
-	if (!sta || !spinfo || !ieee80211_is_data(fc) ||
-	    info->flags & IEEE80211_TX_CTL_NO_ACK) {
-		info->control.rates[0].idx = rate_lowest_index(sband, sta);
-		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
-			info->control.rates[0].count = 1;
-
-		return;
-	}
-
 	rateidx = spinfo->txrate_idx;
 
 	if (rateidx >= sband->n_bitrates)
-- 
1.6.0.6

