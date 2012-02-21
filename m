Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46087 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab2BUJWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 04:22:50 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20291.25183.195199.983947@gargle.gargle.HOWL> (sfid-20120221_102255_613847_E56B3F82)
Date: Tue, 21 Feb 2012 14:52:39 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 06/22] ath9k: Process BTCOEX interrupts using a helper
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

