Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2157 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbYKWEmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 23:42:20 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] ath5k: use mac80211 pm callbacks
Date: Sat, 22 Nov 2008 23:41:26 -0500
Message-Id: <1227415286-30179-3-git-send-email-me@bobcopeland.com> (sfid-20081123_054223_739027_7E38E20C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let mac80211 take care of stopping/starting device in PM hooks.
---
 drivers/net/wireless/ath5k/base.c |   34 ++++++++++------------------------
 1 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 4bcea5a..3a6368a 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -341,9 +341,9 @@ static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
 }
 
 /* Interrupt handling */
-static int 	ath5k_init(struct ath5k_softc *sc, bool is_resume);
+static int 	ath5k_init(struct ath5k_softc *sc);
 static int 	ath5k_stop_locked(struct ath5k_softc *sc);
-static int 	ath5k_stop_hw(struct ath5k_softc *sc, bool is_suspend);
+static int 	ath5k_stop_hw(struct ath5k_softc *sc);
 static irqreturn_t ath5k_intr(int irq, void *dev_id);
 static void 	ath5k_tasklet_reset(unsigned long data);
 
@@ -645,9 +645,9 @@ ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath5k_softc *sc = hw->priv;
 
-	ath5k_led_off(sc);
+	ieee80211_suspend(hw);
 
-	ath5k_stop_hw(sc, true);
+	ath5k_led_off(sc);
 
 	free_irq(pdev->irq, sc);
 	pci_save_state(pdev);
@@ -683,14 +683,10 @@ ath5k_pci_resume(struct pci_dev *pdev)
 		goto err_no_irq;
 	}
 
-	err = ath5k_init(sc, true);
-	if (err)
-		goto err_irq;
 	ath5k_led_enable(sc);
-
+	ieee80211_resume(hw);
 	return 0;
-err_irq:
-	free_irq(pdev->irq, sc);
+
 err_no_irq:
 	pci_disable_device(pdev);
 	return err;
@@ -2196,18 +2192,13 @@ ath5k_beacon_config(struct ath5k_softc *sc)
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
@@ -2239,15 +2230,12 @@ ath5k_init(struct ath5k_softc *sc, bool is_resume)
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
@@ -2302,7 +2290,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
  * stop is preempted).
  */
 static int
-ath5k_stop_hw(struct ath5k_softc *sc, bool is_suspend)
+ath5k_stop_hw(struct ath5k_softc *sc)
 {
 	int ret;
 
@@ -2333,8 +2321,6 @@ ath5k_stop_hw(struct ath5k_softc *sc, bool is_suspend)
 		}
 	}
 	ath5k_txbuf_free(sc, sc->bbuf);
-	if (!is_suspend)
-		__clear_bit(ATH_STAT_STARTED, sc->status);
 
 	mmiowb();
 	mutex_unlock(&sc->lock);
@@ -2733,12 +2719,12 @@ ath5k_reset_wake(struct ath5k_softc *sc)
 
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
1.5.4.2.182.gb3092


