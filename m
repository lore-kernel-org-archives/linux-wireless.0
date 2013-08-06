Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57816 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab3HFMSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 08:18:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 12/12] ath9k: use software queueing for multicast traffic
Date: Tue,  6 Aug 2013 14:18:13 +0200
Message-Id: <1375791493-83971-12-git-send-email-nbd@openwrt.org> (sfid-20130806_141841_879616_66181391)
In-Reply-To: <1375791493-83971-1-git-send-email-nbd@openwrt.org>
References: <1375791493-83971-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create a per-vif dummy node entry for keeping the multicast software
queues. This helps in setups with a lot of mulitcast traffic that could
otherwise potentially drown out unicast traffic to stations.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  2 ++
 drivers/net/wireless/ath/ath9k/main.c  | 11 +++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c  | 12 ++++++++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 41ea3fd..505c615 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -265,6 +265,7 @@ struct ath_node {
 	u8 mpdudensity;
 
 	bool sleeping;
+	bool no_ps_filter;
 
 #if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_DEBUGFS)
 	struct dentry *node_stat;
@@ -364,6 +365,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 /********/
 
 struct ath_vif {
+	struct ath_node mcast_node;
 	int av_bslot;
 	bool primary_sta_vif;
 	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 252497a..911744f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -963,6 +963,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_vif *avp = (void *)vif->drv_priv;
+	struct ath_node *an = &avp->mcast_node;
 
 	mutex_lock(&sc->mutex);
 
@@ -976,6 +978,12 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_assign_slot(sc, vif);
 
+	an->sc = sc;
+	an->sta = NULL;
+	an->vif = vif;
+	an->no_ps_filter = true;
+	ath_tx_node_init(sc, an);
+
 	mutex_unlock(&sc->mutex);
 	return 0;
 }
@@ -1013,6 +1021,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_vif *avp = (void *)vif->drv_priv;
 
 	ath_dbg(common, CONFIG, "Detach Interface\n");
 
@@ -1027,6 +1036,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	ath9k_calculate_summary_state(hw, NULL);
 	ath9k_ps_restore(sc);
 
+	ath_tx_node_cleanup(sc, &avp->mcast_node);
+
 	mutex_unlock(&sc->mutex);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f9e6eb2..d8dfb3e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -135,6 +135,9 @@ static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
 
 static void ath_send_bar(struct ath_atx_tid *tid, u16 seqno)
 {
+	if (!tid->an->sta)
+		return;
+
 	ieee80211_send_bar(tid->an->vif, tid->an->sta->addr, tid->tidno,
 			   seqno << IEEE80211_SEQ_SEQ_SHIFT);
 }
@@ -1382,7 +1385,7 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	if (list_empty(&bf_q))
 		return false;
 
-	if (tid->ac->clear_ps_filter) {
+	if (tid->ac->clear_ps_filter || tid->an->no_ps_filter) {
 		tid->ac->clear_ps_filter = false;
 		tx_info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 	}
@@ -1572,7 +1575,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 			sent++;
 			TX_STAT_INC(txq->axq_qnum, a_queued_hw);
 
-			if (!ath_tid_has_buffered(tid))
+			if (an->sta && !ath_tid_has_buffered(tid))
 				ieee80211_sta_set_buffered(an->sta, i, false);
 		}
 		ath_txq_unlock_complete(sc, tid->ac->txq);
@@ -2104,6 +2107,7 @@ static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = txctl->sta;
 	struct ieee80211_vif *vif = info->control.vif;
+	struct ath_vif *avp;
 	struct ath_softc *sc = hw->priv;
 	int frmlen = skb->len + FCS_LEN;
 	int padpos, padsize;
@@ -2111,6 +2115,10 @@ static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
 	/* NOTE:  sta can be NULL according to net/mac80211.h */
 	if (sta)
 		txctl->an = (struct ath_node *)sta->drv_priv;
+	else if (vif && ieee80211_is_data(hdr->frame_control)) {
+		avp = (void *)vif->drv_priv;
+		txctl->an = &avp->mcast_node;
+	}
 
 	if (info->control.hw_key)
 		frmlen += info->control.hw_key->icv_len;
-- 
1.8.0.2

