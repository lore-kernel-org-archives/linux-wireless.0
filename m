Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab0DODa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:58 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 94/97] ath9k: add LDPC support
Date: Wed, 14 Apr 2010 23:30:48 -0400
Message-Id: <1271302251-9075-95-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

LDPC is enabled by the rate control if the its determined
that the target peer supports LDPC. We would have already
intersected the HT capabilities so if our peer supports
LDPC so do we.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    3 +++
 drivers/net/wireless/ath/ath9k/rc.c   |    9 +++++++++
 drivers/net/wireless/ath/ath9k/xmit.c |   14 ++++++++++----
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 299ec05..ca6e781 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -191,6 +191,9 @@ static void setup_ht_cap(struct ath_softc *sc,
 		       IEEE80211_HT_CAP_SGI_40 |
 		       IEEE80211_HT_CAP_DSSSCCK40;
 
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_LDPC)
+		ht_info->cap |= IEEE80211_HT_CAP_LDPC_CODING;
+
 	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
 	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index ee81291..bf3ad7a 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -691,6 +691,15 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	rate_table = sc->cur_rate_table;
 	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table, &is_probe);
 
+	/*
+	 * If we're in HT mode and both us and our peer supports LDPC.
+	 * We don't need to check our own device's capabilities as our own
+	 * ht capabilities would have already been intersected with our peer's.
+	 */
+	if (conf_is_ht(&sc->hw->conf) &&
+	    (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING))
+		tx_info->flags |= IEEE80211_TX_CTL_LDPC;
+
 	if (is_probe) {
 		/* set one try for probe rates. For the
 		 * probes don't enable rts */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 33c7027..34dcb75 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1482,8 +1482,7 @@ static void assign_aggr_tid_seqno(struct sk_buff *skb,
 	INCR(tid->seq_next, IEEE80211_SEQ_MAX);
 }
 
-static int setup_tx_flags(struct ath_softc *sc, struct sk_buff *skb,
-			  struct ath_txq *txq)
+static int setup_tx_flags(struct sk_buff *skb, bool use_ldpc)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	int flags = 0;
@@ -1494,6 +1493,9 @@ static int setup_tx_flags(struct ath_softc *sc, struct sk_buff *skb,
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
 		flags |= ATH9K_TXDESC_NOACK;
 
+	if (use_ldpc)
+		flags |= ATH9K_TXDESC_LDPC;
+
 	return flags;
 }
 
@@ -1645,6 +1647,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 	int hdrlen;
 	__le16 fc;
 	int padpos, padsize;
+	bool use_ldpc = false;
 
 	tx_info->pad[0] = 0;
 	switch (txctl->frame_type) {
@@ -1671,10 +1674,13 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 		bf->bf_frmlen -= padsize;
 	}
 
-	if (conf_is_ht(&hw->conf))
+	if (conf_is_ht(&hw->conf)) {
 		bf->bf_state.bf_type |= BUF_HT;
+		if (tx_info->flags & IEEE80211_TX_CTL_LDPC)
+			use_ldpc = true;
+	}
 
-	bf->bf_flags = setup_tx_flags(sc, skb, txctl->txq);
+	bf->bf_flags = setup_tx_flags(skb, use_ldpc);
 
 	bf->bf_keytype = get_hw_crypto_keytype(skb);
 	if (bf->bf_keytype != ATH9K_KEY_TYPE_CLEAR) {
-- 
1.6.3.3

