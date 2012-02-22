Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23078 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab2BVHK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:10:57 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38120.827135.226403@gargle.gargle.HOWL> (sfid-20120222_081100_676833_81CABF92)
Date: Wed, 22 Feb 2012 12:40:32 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 06/26] ath9k: Process BTCOEX interrupts using a helper
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/gpio.c  |   12 ++++++++++++
 drivers/net/wireless/ath/ath9k/main.c  |    7 +------
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2ede897..acf5372 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -460,6 +460,7 @@ void ath9k_start_btcoex(struct ath_softc *sc);
 void ath9k_stop_btcoex(struct ath_softc *sc);
 void ath9k_btcoex_timer_resume(struct ath_softc *sc);
 void ath9k_btcoex_timer_pause(struct ath_softc *sc);
+void ath9k_btcoex_handle_interrupt(struct ath_softc *sc, u32 status);
 
 /********************/
 /*   LED Control    */
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 1ca2ca5..a24aa67 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -318,6 +318,18 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc)
 	btcoex->hw_timer_enabled = false;
 }
 
+void ath9k_btcoex_handle_interrupt(struct ath_softc *sc, u32 status)
+{
+	struct ath_hw *ah = sc->sc_ah;
+
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
+		if (status & ATH9K_INT_GENTIMER)
+			ath_gen_timer_isr(sc->sc_ah);
+
+	if ((status & ATH9K_INT_MCI) && ATH9K_HW_CAP_MCI)
+		ath_mci_intr(sc);
+}
+
 void ath9k_start_btcoex(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ee5335c..14df586 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -739,12 +739,7 @@ void ath9k_tasklet(unsigned long data)
 			ath_tx_tasklet(sc);
 	}
 
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
-		if (status & ATH9K_INT_GENTIMER)
-			ath_gen_timer_isr(sc->sc_ah);
-
-	if ((status & ATH9K_INT_MCI) && ATH9K_HW_CAP_MCI)
-		ath_mci_intr(sc);
+	ath9k_btcoex_handle_interrupt(sc, status);
 
 out:
 	/* re-enable hardware interrupt */
-- 
1.7.9.1

