Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55998 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530Ab2EXMcj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 08:32:39 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.5 1/4] ath9k: stop rx dma before stopping tx
Date: Thu, 24 May 2012 14:32:19 +0200
Message-Id: <1337862742-10574-1-git-send-email-nbd@openwrt.org> (sfid-20120524_143244_825753_3BB4DFE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It has been found that active Rx can interfere with stopping tx DMA, which
could result in at least parts of those "Failed to stop Tx DMA!" messages.
Stopping rx before tx should prevent that.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dfa78e8..4de4473 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -239,7 +239,7 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	bool ret;
+	bool ret = true;
 
 	ieee80211_stop_queues(sc->hw);
 
@@ -250,11 +250,12 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 	ath9k_debug_samp_bb_mac(sc);
 	ath9k_hw_disable_interrupts(ah);
 
-	ret = ath_drain_all_txq(sc, retry_tx);
-
 	if (!ath_stoprecv(sc))
 		ret = false;
 
+	if (!ath_drain_all_txq(sc, retry_tx))
+		ret = false;
+
 	if (!flush) {
 		if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 			ath_rx_tasklet(sc, 1, true);
-- 
1.7.3.2

