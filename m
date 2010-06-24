Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29514 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0FXJmv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 05:42:51 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 24 Jun 2010 02:42:51 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath9k: Fix bug in paprd
Date: Thu, 24 Jun 2010 02:42:44 -0700
Message-ID: <1277372566-22883-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is possbile that the transmission of paprd test frame
might not get completed in 100ms if tx is stuck. Freeing
this skb upon timeout in ath_paprd_calibrate() will result
in accessing already freed memory when the associated pending
buffer is drained in txq. This patch fixes this issue.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 +++
 drivers/net/wireless/ath/ath9k/main.c  |    5 +++--
 drivers/net/wireless/ath/ath9k/xmit.c  |   12 ++++++++++--
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 6218890..6c561fa 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -226,6 +226,7 @@ struct ath_buf_state {
 	int bfs_retries;
 	u8 bf_type;
 	u8 bfs_paprd;
+	unsigned long bfs_paprd_timestamp;
 	u32 bfs_keyix;
 	enum ath9k_key_type bfs_keytype;
 };
@@ -425,6 +426,8 @@ int ath_beaconq_config(struct ath_softc *sc);
 #define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
 #define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
 
+#define ATH_PAPRD_TIMEOUT	100 /* msecs */
+
 void ath_paprd_calibrate(struct work_struct *work);
 void ath_ani_calibrate(unsigned long data);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 41a317d..6d57877 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -310,13 +310,13 @@ void ath_paprd_calibrate(struct work_struct *work)
 			break;
 
 		time_left = wait_for_completion_timeout(&sc->paprd_complete,
-							100);
+				msecs_to_jiffies(ATH_PAPRD_TIMEOUT));
 		if (!time_left) {
 			ath_print(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
 				  "Timeout waiting for paprd training on "
 				  "TX chain %d\n",
 				  chain);
-			break;
+			goto fail_paprd;
 		}
 
 		if (!ar9003_paprd_is_done(ah))
@@ -334,6 +334,7 @@ void ath_paprd_calibrate(struct work_struct *work)
 		ath_paprd_activate(sc);
 	}
 
+fail_paprd:
 	ath9k_ps_restore(sc);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 20221b8..edbeffb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1644,6 +1644,8 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 	}
 
 	bf->bf_state.bfs_paprd = txctl->paprd;
+	if (txctl->paprd)
+		bf->bf_state.bfs_paprd_timestamp = jiffies;
 	bf->bf_flags = setup_tx_flags(skb, use_ldpc);
 
 	bf->bf_keytype = get_hw_crypto_keytype(skb);
@@ -1944,8 +1946,14 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	dma_unmap_single(sc->dev, bf->bf_dmacontext, skb->len, DMA_TO_DEVICE);
 
 	if (bf->bf_state.bfs_paprd) {
-		sc->paprd_txok = txok;
-		complete(&sc->paprd_complete);
+		if (time_after(jiffies,
+			       bf->bf_state.bfs_paprd_timestamp +
+			       msecs_to_jiffies(ATH_PAPRD_TIMEOUT))) {
+			dev_kfree_skb_any(skb);
+		} else {
+			sc->paprd_txok = txok;
+			complete(&sc->paprd_complete);
+		}
 	} else {
 		ath_tx_complete(sc, skb, bf->aphy, tx_flags);
 		ath_debug_stat_tx(sc, txq, bf, ts);
-- 
1.7.0.4

