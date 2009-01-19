Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2115 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbZASQXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 11:23:19 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v3 3/3] ath5k: remove stop/start calls from within suspend/resume
Date: Mon, 19 Jan 2009 11:20:54 -0500
Message-Id: <1232382054-15931-4-git-send-email-me@bobcopeland.com> (sfid-20090119_172327_005774_2CCF6231)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 now takes down interfaces automatically during suspend
so doing it in the driver is unnecessary.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |   31 +++++++------------------------
 1 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index d317873..747b496 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -347,9 +347,9 @@ static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
 }
 
 /* Interrupt handling */
-static int 	ath5k_init(struct ath5k_softc *sc, bool is_resume);
+static int 	ath5k_init(struct ath5k_softc *sc);
 static int 	ath5k_stop_locked(struct ath5k_softc *sc);
-static int 	ath5k_stop_hw(struct ath5k_softc *sc, bool is_suspend);
+static int 	ath5k_stop_hw(struct ath5k_softc *sc);
 static irqreturn_t ath5k_intr(int irq, void *dev_id);
 static void 	ath5k_tasklet_reset(unsigned long data);
 
@@ -653,8 +653,6 @@ ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	ath5k_led_off(sc);
 
-	ath5k_stop_hw(sc, true);
-
 	free_irq(pdev->irq, sc);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
@@ -689,14 +687,9 @@ ath5k_pci_resume(struct pci_dev *pdev)
 		goto err_no_irq;
 	}
 
-	err = ath5k_init(sc, true);
-	if (err)
-		goto err_irq;
 	ath5k_led_enable(sc);
-
 	return 0;
-err_irq:
-	free_irq(pdev->irq, sc);
+
 err_no_irq:
 	pci_disable_device(pdev);
 	return err;
@@ -2226,18 +2219,13 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 \********************/
 
 static int
-ath5k_init(struct ath5k_softc *sc, bool is_resume)
+ath5k_init(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 	int ret, i;
 
 	mutex_lock(&sc->lock);
 
-	if (is_resume && !test_bit(ATH_STAT_STARTED, sc->status))
-		goto out_ok;
-
-	__clear_bit(ATH_STAT_STARTED, sc->status);
-
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
 
 	/*
@@ -2269,15 +2257,12 @@ ath5k_init(struct ath5k_softc *sc, bool is_resume)
 	for (i = 0; i < AR5K_KEYTABLE_SIZE; i++)
 		ath5k_hw_reset_key(ah, i);
 
-	__set_bit(ATH_STAT_STARTED, sc->status);
-
 	/* Set ack to be sent at low bit-rates */
 	ath5k_hw_set_ack_bitrate_high(ah, false);
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
 			msecs_to_jiffies(ath5k_calinterval * 1000)));
 
-out_ok:
 	ret = 0;
 done:
 	mmiowb();
@@ -2332,7 +2317,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
  * stop is preempted).
  */
 static int
-ath5k_stop_hw(struct ath5k_softc *sc, bool is_suspend)
+ath5k_stop_hw(struct ath5k_softc *sc)
 {
 	int ret;
 
@@ -2363,8 +2348,6 @@ ath5k_stop_hw(struct ath5k_softc *sc, bool is_suspend)
 		}
 	}
 	ath5k_txbuf_free(sc, sc->bbuf);
-	if (!is_suspend)
-		__clear_bit(ATH_STAT_STARTED, sc->status);
 
 	mmiowb();
 	mutex_unlock(&sc->lock);
@@ -2771,12 +2754,12 @@ ath5k_reset_wake(struct ath5k_softc *sc)
 
 static int ath5k_start(struct ieee80211_hw *hw)
 {
-	return ath5k_init(hw->priv, false);
+	return ath5k_init(hw->priv);
 }
 
 static void ath5k_stop(struct ieee80211_hw *hw)
 {
-	ath5k_stop_hw(hw->priv, false);
+	ath5k_stop_hw(hw->priv);
 }
 
 static int ath5k_add_interface(struct ieee80211_hw *hw,
-- 
1.6.0.6


