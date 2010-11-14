Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48059 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755724Ab0KNOUW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:22 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 04/13] ath9k: remove bfs_paprd_timestamp from struct ath_buf_state
Date: Sun, 14 Nov 2010 15:20:04 +0100
Message-Id: <1289744413-20789-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289744413-20789-3-git-send-email-nbd@openwrt.org>
References: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
 <1289744413-20789-2-git-send-email-nbd@openwrt.org>
 <1289744413-20789-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/main.c  |    2 ++
 drivers/net/wireless/ath/ath9k/xmit.c  |    7 +------
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7316459..9106d41 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -221,7 +221,6 @@ struct ath_buf_state {
 	int bfs_retries;
 	u8 bf_type;
 	u8 bfs_paprd;
-	unsigned long bfs_paprd_timestamp;
 	u32 bfs_keyix;
 	enum ath9k_internal_frame_type bfs_ftype;
 };
@@ -598,6 +597,7 @@ struct ath_softc {
 	struct work_struct paprd_work;
 	struct work_struct hw_check_work;
 	struct completion paprd_complete;
+	bool paprd_pending;
 
 	u32 intrstatus;
 	u32 sc_flags; /* SC_OP_* */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f8c811a..611797a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -380,6 +380,7 @@ void ath_paprd_calibrate(struct work_struct *work)
 		}
 
 		init_completion(&sc->paprd_complete);
+		sc->paprd_pending = true;
 		ar9003_paprd_setup_gain_table(ah, chain);
 		txctl.paprd = BIT(chain);
 		if (ath_tx_start(hw, skb, &txctl) != 0)
@@ -387,6 +388,7 @@ void ath_paprd_calibrate(struct work_struct *work)
 
 		time_left = wait_for_completion_timeout(&sc->paprd_complete,
 				msecs_to_jiffies(ATH_PAPRD_TIMEOUT));
+		sc->paprd_pending = false;
 		if (!time_left) {
 			ath_print(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
 				  "Timeout waiting for paprd training on "
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 6e0467c..9f3d23a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1698,9 +1698,6 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 		if (bf->bf_state.bfs_paprd)
 			ar9003_hw_set_paprd_txdesc(ah, ds, bf->bf_state.bfs_paprd);
 
-		if (txctl->paprd)
-			bf->bf_state.bfs_paprd_timestamp = jiffies;
-
 		ath_tx_send_normal(sc, txctl->txq, NULL, &bf_head);
 	}
 
@@ -1874,9 +1871,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	bf->bf_buf_addr = 0;
 
 	if (bf->bf_state.bfs_paprd) {
-		if (time_after(jiffies,
-			       bf->bf_state.bfs_paprd_timestamp +
-			       msecs_to_jiffies(ATH_PAPRD_TIMEOUT)))
+		if (!sc->paprd_pending)
 			dev_kfree_skb_any(skb);
 		else
 			complete(&sc->paprd_complete);
-- 
1.7.3.2

