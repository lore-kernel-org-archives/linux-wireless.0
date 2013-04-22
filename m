Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41211 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab3DVVLx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 17:11:53 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/2] ath9k: add support for the new rate control API
Date: Mon, 22 Apr 2013 23:11:44 +0200
Message-Id: <1366665104-28737-2-git-send-email-nbd@openwrt.org> (sfid-20130422_231159_011298_5354087C)
In-Reply-To: <1366665104-28737-1-git-send-email-nbd@openwrt.org>
References: <1366665104-28737-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/init.c  |  3 ++-
 drivers/net/wireless/ath/ath9k/xmit.c  | 23 ++++++++++++++++-------
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1915f12..8a1888d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -234,6 +234,7 @@ struct ath_buf {
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;	/* physical addr of data buffer, for DMA */
 	bool bf_stale;
+	struct ieee80211_tx_rate rates[4];
 	struct ath_buf_state bf_state;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 6b275e0..0237b28 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -766,7 +766,8 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_SPECTRUM_MGMT |
-		IEEE80211_HW_REPORTS_TX_ACK_STATUS;
+		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+		IEEE80211_HW_SUPPORTS_RC_TABLE;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 108fe5f..eab0fcb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -157,6 +157,13 @@ static void ath_send_bar(struct ath_atx_tid *tid, u16 seqno)
 			   seqno << IEEE80211_SEQ_SEQ_SHIFT);
 }
 
+static void ath_set_rates(struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+			  struct ath_buf *bf)
+{
+	ieee80211_get_tx_rates(vif, sta, bf->bf_mpdu, bf->rates,
+			       ARRAY_SIZE(bf->rates));
+}
+
 static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
 	struct ath_txq *txq = tid->ac->txq;
@@ -189,6 +196,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
 			sendbar = true;
 		} else {
+			ath_set_rates(tid->an->vif, tid->an->sta, bf);
 			ath_tx_send_normal(sc, txq, NULL, skb);
 		}
 	}
@@ -407,7 +415,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	tx_info = IEEE80211_SKB_CB(skb);
 
-	memcpy(rates, tx_info->control.rates, sizeof(rates));
+	memcpy(rates, bf->rates, sizeof(rates));
 
 	retries = ts->ts_longretry + 1;
 	for (i = 0; i < ts->ts_rateindex; i++)
@@ -736,8 +744,6 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 				  bool first_subfrm)
 {
 #define FIRST_DESC_NDELIMS 60
-	struct sk_buff *skb = bf->bf_mpdu;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	u32 nsymbits, nsymbols;
 	u16 minlen;
 	u8 flags, rix;
@@ -778,8 +784,8 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	if (tid->an->mpdudensity == 0)
 		return ndelim;
 
-	rix = tx_info->control.rates[0].idx;
-	flags = tx_info->control.rates[0].flags;
+	rix = bf->rates[0].idx;
+	flags = bf->rates[0].flags;
 	width = (flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ? 1 : 0;
 	half_gi = (flags & IEEE80211_TX_RC_SHORT_GI) ? 1 : 0;
 
@@ -858,6 +864,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 			bf_first = bf;
 
 		if (!rl) {
+			ath_set_rates(tid->an->vif, tid->an->sta, bf);
 			aggr_limit = ath_lookup_rate(sc, bf, tid);
 			rl = 1;
 		}
@@ -998,14 +1005,14 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 
 	skb = bf->bf_mpdu;
 	tx_info = IEEE80211_SKB_CB(skb);
-	rates = tx_info->control.rates;
+	rates = bf->rates;
 	hdr = (struct ieee80211_hdr *)skb->data;
 
 	/* set dur_update_en for l-sig computation except for PS-Poll frames */
 	info->dur_update = !ieee80211_is_pspoll(hdr->frame_control);
 	info->rtscts_rate = fi->rtscts_rate;
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < ARRAY_SIZE(bf->rates); i++) {
 		bool is_40, is_sgi, is_sp;
 		int phy;
 
@@ -1743,6 +1750,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 		return;
 	}
 
+	ath_set_rates(tid->an->vif, tid->an->sta, bf);
 	bf->bf_state.bf_type = BUF_AMPDU;
 	INIT_LIST_HEAD(&bf_head);
 	list_add(&bf->list, &bf_head);
@@ -1993,6 +2001,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (txctl->paprd)
 		bf->bf_state.bfs_paprd_timestamp = jiffies;
 
+	ath_set_rates(vif, sta, bf);
 	ath_tx_send_normal(sc, txctl->txq, tid, skb);
 
 out:
-- 
1.8.0.2

