Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21347 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1G1R3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 13:29:41 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/9] ath9k: Remove virtual wiphy specific frame type
Date: Thu, 28 Jul 2011 22:59:30 +0530
Message-ID: <1311874176-27569-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110728_192944_403758_C41D3CBE)
In-Reply-To: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleanups virtual wiphy specific frametype structure

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 ---
 drivers/net/wireless/ath/ath9k/rc.h    |    6 ------
 drivers/net/wireless/ath/ath9k/xmit.c  |    6 ++----
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 298a941..dcd97e2 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -216,7 +216,6 @@ struct ath_buf_state {
 	u8 bf_type;
 	u8 bfs_paprd;
 	unsigned long bfs_paprd_timestamp;
-	enum ath9k_internal_frame_type bfs_ftype;
 };
 
 struct ath_buf {
@@ -272,8 +271,6 @@ struct ath_node {
 struct ath_tx_control {
 	struct ath_txq *txq;
 	struct ath_node *an;
-	int if_id;
-	enum ath9k_internal_frame_type frame_type;
 	u8 paprd;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index c3d8502..b7a4bcd 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -221,12 +221,6 @@ struct ath_rate_priv {
 	struct ath_rc_stats rcstats[RATE_TABLE_SIZE];
 };
 
-enum ath9k_internal_frame_type {
-	ATH9K_IFT_NOT_INTERNAL,
-	ATH9K_IFT_PAUSE,
-	ATH9K_IFT_UNPAUSE
-};
-
 #ifdef CONFIG_ATH9K_RATE_CONTROL
 int ath_rate_control_register(void);
 void ath_rate_control_unregister(void);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f210e2b..70a512f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1792,7 +1792,6 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 		INIT_LIST_HEAD(&bf_head);
 		list_add_tail(&bf->list, &bf_head);
 
-		bf->bf_state.bfs_ftype = txctl->frame_type;
 		bf->bf_state.bfs_paprd = txctl->paprd;
 
 		if (bf->bf_state.bfs_paprd)
@@ -1891,7 +1890,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 /*****************/
 
 static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
-			    int tx_flags, int ftype, struct ath_txq *txq)
+			    int tx_flags, struct ath_txq *txq)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -1976,8 +1975,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 			complete(&sc->paprd_complete);
 	} else {
 		ath_debug_stat_tx(sc, bf, ts, txq);
-		ath_tx_complete(sc, skb, tx_flags,
-				bf->bf_state.bfs_ftype, txq);
+		ath_tx_complete(sc, skb, tx_flags, txq);
 	}
 	/* At this point, skb (bf->bf_mpdu) is consumed...make sure we don't
 	 * accidentally reference it later.
-- 
1.7.6

