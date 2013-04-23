Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33839 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab3DWGye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 02:54:34 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] ath9k: Remove unused argument "size"
Date: Tue, 23 Apr 2013 12:22:16 +0530
Message-Id: <1366699939-14076-1-git-send-email-sujith@msujith.org> (sfid-20130423_085436_518779_D5D01A3B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ebb8d36..d13faa4 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -130,7 +130,7 @@ static bool ath_rx_edma_buf_link(struct ath_softc *sc,
 }
 
 static void ath_rx_addbuffer_edma(struct ath_softc *sc,
-				  enum ath9k_rx_qtype qtype, int size)
+				  enum ath9k_rx_qtype qtype)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_buf *bf, *tbf;
@@ -250,15 +250,9 @@ rx_init_fail:
 static void ath_edma_start_recv(struct ath_softc *sc)
 {
 	ath9k_hw_rxena(sc->sc_ah);
-
-	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_HP,
-			      sc->rx.rx_edma[ATH9K_RX_QUEUE_HP].rx_fifo_hwsize);
-
-	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_LP,
-			      sc->rx.rx_edma[ATH9K_RX_QUEUE_LP].rx_fifo_hwsize);
-
+	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_HP);
+	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_LP);
 	ath_opmode_init(sc);
-
 	ath9k_hw_startpcureceive(sc->sc_ah, !!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL));
 }
 
-- 
1.8.2.1

