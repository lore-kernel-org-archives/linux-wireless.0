Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48958 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbaICHzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 03:55:18 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 2/5] ath9k: Fix ath_startrecv()
Date: Wed,  3 Sep 2014 13:25:26 +0530
Message-Id: <1409730929-30208-3-git-send-email-sujith@msujith.org> (sfid-20140903_095531_319265_512B0C38)
In-Reply-To: <1409730929-30208-1-git-send-email-sujith@msujith.org>
References: <1409730929-30208-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since ath_startrecv() doesn't return an error value,
cleanup the callsites.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 2 +-
 drivers/net/wireless/ath/ath9k/main.c  | 8 +-------
 drivers/net/wireless/ath/ath9k/recv.c  | 6 ++----
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b4ac51e..12cdabb 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -527,7 +527,7 @@ static inline void ath_chanctx_check_active(struct ath_softc *sc,
 #endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
 
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
-int ath_startrecv(struct ath_softc *sc);
+void ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
 u32 ath_calcrxfilter(struct ath_softc *sc);
 int ath_rx_init(struct ath_softc *sc, int nbufs);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5d9f4d7..18e5e91 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -225,15 +225,9 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	unsigned long flags;
 
 	ath9k_calculate_summary_state(sc, sc->cur_chan);
-
-	if (ath_startrecv(sc) != 0) {
-		ath_err(common, "Unable to restart recv logic\n");
-		return false;
-	}
-
+	ath_startrecv(sc);
 	ath9k_cmn_update_txpow(ah, sc->curtxpow,
 			       sc->cur_chan->txpower, &sc->curtxpow);
-
 	clear_bit(ATH_OP_HW_RESET, &common->op_flags);
 
 	if (!sc->cur_chan->offchannel && start) {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 2aaf233..04b02b5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -433,14 +433,14 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 
 }
 
-int ath_startrecv(struct ath_softc *sc)
+void ath_startrecv(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_rxbuf *bf, *tbf;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		ath_edma_start_recv(sc);
-		return 0;
+		return;
 	}
 
 	if (list_empty(&sc->rx.rxbuf))
@@ -463,8 +463,6 @@ int ath_startrecv(struct ath_softc *sc)
 start_recv:
 	ath_opmode_init(sc);
 	ath9k_hw_startpcureceive(ah, sc->cur_chan->offchannel);
-
-	return 0;
 }
 
 static void ath_flushrecv(struct ath_softc *sc)
-- 
2.1.0

