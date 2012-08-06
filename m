Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6610 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab2HFQom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 12:44:42 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20511.62502.380685.674021@gargle.gargle.HOWL> (sfid-20120806_184447_787042_415E3968)
Date: Mon, 6 Aug 2012 22:13:18 +0530
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3.5.y 2/2] compat-wireless: Add new cherry-picked patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 ...art-noisefloor-calibration-after-MCI-rese.patch |  37 ++
 ...-not-load-noise-floor-readings-when-it-is.patch |  42 ++
 ...ullsleep-power-consumption-when-BTCOEX-is.patch |  59 +++
 ...ower-consumption-on-network-sleep-when-BT.patch |  89 ++++
 ...k_hw-fix-AR9462-2g5g-switch-on-full-reset.patch |  57 +++
 .../0117-ath9k-Fix-MCI-cleanup.patch               |  35 ++
 ...the-BTCOEX-timers-before-disabling-BTCOEX.patch |  46 +++
 ...move-debugging-masks-from-AR_MCI_INTERRUP.patch |  34 ++
 .../0143-ath9k-Fix-beacon-setup.patch              | 309 ++++++++++++++
 ...4-ath9k_hw-Cleanup-ath9k_hw_set_tsfadjust.patch |  90 +++++
 .../0145-ath9k-Cleanup-interface-handling.patch    |  62 +++
 .../0146-ath9k-Simplify-ASSOC-handling.patch       | 197 +++++++++
 .../0147-ath9k-Cleanup-beacon-logic.patch          | 448 +++++++++++++++++++++
 .../0148-ath9k-Remove-is_bslot_active.patch        |  88 ++++
 ...-ath9k-Cleanup-beacon-queue-configuration.patch | 119 ++++++
 ...0-ath9k-Set-the-TSF-adjust-value-properly.patch |  61 +++
 .../0151-ath9k-Cleanup-the-beacon-tasklet.patch    | 281 +++++++++++++
 .../0152-ath9k-Fix-ANI-management.patch            | 206 ++++++++++
 ...0153-ath9k-Reconfigure-VIF-state-properly.patch |  73 ++++
 .../0154-ath9k-Fix-race-in-reset-work-usage.patch  | 256 ++++++++++++
 20 files changed, 2589 insertions(+)
 create mode 100644 linux-next-cherry-picks/0092-ath9k_hw-start-noisefloor-calibration-after-MCI-rese.patch
 create mode 100644 linux-next-cherry-picks/0093-ath9k_hw-do-not-load-noise-floor-readings-when-it-is.patch
 create mode 100644 linux-next-cherry-picks/0094-ath9k-fix-fullsleep-power-consumption-when-BTCOEX-is.patch
 create mode 100644 linux-next-cherry-picks/0095-ath9k-fix-power-consumption-on-network-sleep-when-BT.patch
 create mode 100644 linux-next-cherry-picks/0096-ath9k_hw-fix-AR9462-2g5g-switch-on-full-reset.patch
 create mode 100644 linux-next-cherry-picks/0117-ath9k-Fix-MCI-cleanup.patch
 create mode 100644 linux-next-cherry-picks/0118-ath9k-Stop-the-BTCOEX-timers-before-disabling-BTCOEX.patch
 create mode 100644 linux-next-cherry-picks/0119-ath9k_hw-remove-debugging-masks-from-AR_MCI_INTERRUP.patch
 create mode 100644 linux-next-cherry-picks/0143-ath9k-Fix-beacon-setup.patch
 create mode 100644 linux-next-cherry-picks/0144-ath9k_hw-Cleanup-ath9k_hw_set_tsfadjust.patch
 create mode 100644 linux-next-cherry-picks/0145-ath9k-Cleanup-interface-handling.patch
 create mode 100644 linux-next-cherry-picks/0146-ath9k-Simplify-ASSOC-handling.patch
 create mode 100644 linux-next-cherry-picks/0147-ath9k-Cleanup-beacon-logic.patch
 create mode 100644 linux-next-cherry-picks/0148-ath9k-Remove-is_bslot_active.patch
 create mode 100644 linux-next-cherry-picks/0149-ath9k-Cleanup-beacon-queue-configuration.patch
 create mode 100644 linux-next-cherry-picks/0150-ath9k-Set-the-TSF-adjust-value-properly.patch
 create mode 100644 linux-next-cherry-picks/0151-ath9k-Cleanup-the-beacon-tasklet.patch
 create mode 100644 linux-next-cherry-picks/0152-ath9k-Fix-ANI-management.patch
 create mode 100644 linux-next-cherry-picks/0153-ath9k-Reconfigure-VIF-state-properly.patch
 create mode 100644 linux-next-cherry-picks/0154-ath9k-Fix-race-in-reset-work-usage.patch

diff --git a/linux-next-cherry-picks/0092-ath9k_hw-start-noisefloor-calibration-after-MCI-rese.patch b/linux-next-cherry-picks/0092-ath9k_hw-start-noisefloor-calibration-after-MCI-rese.patch
new file mode 100644
index 0000000..bbed3d8
--- /dev/null
+++ b/linux-next-cherry-picks/0092-ath9k_hw-start-noisefloor-calibration-after-MCI-rese.patch
@@ -0,0 +1,37 @@
+From 1fe860edb0787fa2df6d043e34a55dc739e235f0 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Sun, 1 Jul 2012 19:53:51 +0530
+Subject: [PATCH] ath9k_hw: start noisefloor calibration after MCI reset
+
+noisefloor calibration has to be loaded and started after
+chip reset completion and restoring chainmask. Right now it is
+being started before MCI reset completion on full reset. Fix that.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/hw.c | 6 +++---
+ 1 file changed, 3 insertions(+), 3 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -1949,9 +1949,6 @@ int ath9k_hw_reset(struct ath_hw *ah, st
+ 	if (!ath9k_hw_init_cal(ah, chan))
+ 		return -EIO;
+ 
+-	ath9k_hw_loadnf(ah, chan);
+-	ath9k_hw_start_nfcal(ah, true);
+-
+ 	if (ath9k_hw_mci_is_enabled(ah) && ar9003_mci_end_reset(ah, chan, caldata))
+ 		return -EIO;
+ 
+@@ -2000,6 +1997,9 @@ int ath9k_hw_reset(struct ath_hw *ah, st
+ 	if (ath9k_hw_mci_is_enabled(ah))
+ 		ar9003_mci_check_bt(ah);
+ 
++	ath9k_hw_loadnf(ah, chan);
++	ath9k_hw_start_nfcal(ah, true);
++
+ 	if (AR_SREV_9300_20_OR_LATER(ah)) {
+ 		ar9003_hw_bb_watchdog_config(ah);
+ 
diff --git a/linux-next-cherry-picks/0093-ath9k_hw-do-not-load-noise-floor-readings-when-it-is.patch b/linux-next-cherry-picks/0093-ath9k_hw-do-not-load-noise-floor-readings-when-it-is.patch
new file mode 100644
index 0000000..635fd6a
--- /dev/null
+++ b/linux-next-cherry-picks/0093-ath9k_hw-do-not-load-noise-floor-readings-when-it-is.patch
@@ -0,0 +1,42 @@
+From 54717e5330318d53180a1f3026f617509031ee68 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Sun, 1 Jul 2012 19:53:52 +0530
+Subject: [PATCH] ath9k_hw: do not load noise floor readings when it is
+ running
+
+Noise floor calibration is performed on longcal interval and
+the reading will be updated in history buffer. On rare occasions,
+the previous noisefloor calibration might not be completed within
+the period and trying to load nf reading will be failed. In such
+situation, postpone the nf cabliration to next cycle to give
+enough time to complete the calibration. This was already taken
+care for ar9002 chips.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_calib.c | 13 +++++--------
+ 1 file changed, 5 insertions(+), 8 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+@@ -159,14 +159,11 @@ static bool ar9003_hw_calibrate(struct a
+ 		}
+ 	}
+ 
+-	/* Do NF cal only at longer intervals */
+-	if (longcal) {
+-		/*
+-		 * Get the value from the previous NF cal and update
+-		 * history buffer.
+-		 */
+-		ath9k_hw_getnf(ah, chan);
+-
++	/*
++	 * Do NF cal only at longer intervals. Get the value from
++	 * the previous NF cal and update history buffer.
++	 */
++	if (longcal && ath9k_hw_getnf(ah, chan)) {
+ 		/*
+ 		 * Load the NF from history buffer of the current channel.
+ 		 * NF is slow time-variant, so it is OK to use a historical
diff --git a/linux-next-cherry-picks/0094-ath9k-fix-fullsleep-power-consumption-when-BTCOEX-is.patch b/linux-next-cherry-picks/0094-ath9k-fix-fullsleep-power-consumption-when-BTCOEX-is.patch
new file mode 100644
index 0000000..d59005a
--- /dev/null
+++ b/linux-next-cherry-picks/0094-ath9k-fix-fullsleep-power-consumption-when-BTCOEX-is.patch
@@ -0,0 +1,59 @@
+From b73f3e78047abdcc8bc33f97445ef6691ce3cc3d Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Sun, 1 Jul 2012 19:53:53 +0530
+Subject: [PATCH] ath9k: fix fullsleep power consumption when BTCOEX is
+ enabled
+
+As soon as the interface brought up, btcoex timer starts running
+eventhough the interface is in idle state and WLAN chip is moved
+to full sleep mode. There is no point in running btcoex timer when
+the wlan interface is in sleep mode and also it might consumes
+more power on WLAN idle unassociated state. So lets stop the
+btcoex when wlan is idle state.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/main.c | 11 +++++------
+ 1 file changed, 5 insertions(+), 6 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -666,8 +666,6 @@ static int ath9k_start(struct ieee80211_
+ 
+ 	spin_unlock_bh(&sc->sc_pcu_lock);
+ 
+-	ath9k_start_btcoex(sc);
+-
+ 	if (ah->caps.pcie_lcr_extsync_en && common->bus_ops->extn_synch_en)
+ 		common->bus_ops->extn_synch_en(common);
+ 
+@@ -774,8 +772,6 @@ static void ath9k_stop(struct ieee80211_
+ 	/* Ensure HW is awake when we try to shut it down. */
+ 	ath9k_ps_wakeup(sc);
+ 
+-	ath9k_stop_btcoex(sc);
+-
+ 	spin_lock_bh(&sc->sc_pcu_lock);
+ 
+ 	/* prevent tasklets to enable interrupts once we disable them */
+@@ -1139,14 +1135,17 @@ static int ath9k_config(struct ieee80211
+ 
+ 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+ 		sc->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
+-		if (sc->ps_idle)
++		if (sc->ps_idle) {
+ 			ath_cancel_work(sc);
+-		else
++			ath9k_stop_btcoex(sc);
++		} else {
++			ath9k_start_btcoex(sc);
+ 			/*
+ 			 * The chip needs a reset to properly wake up from
+ 			 * full sleep
+ 			 */
+ 			reset_channel = ah->chip_fullsleep;
++		}
+ 	}
+ 
+ 	/*
diff --git a/linux-next-cherry-picks/0095-ath9k-fix-power-consumption-on-network-sleep-when-BT.patch b/linux-next-cherry-picks/0095-ath9k-fix-power-consumption-on-network-sleep-when-BT.patch
new file mode 100644
index 0000000..b18fffd
--- /dev/null
+++ b/linux-next-cherry-picks/0095-ath9k-fix-power-consumption-on-network-sleep-when-BT.patch
@@ -0,0 +1,89 @@
+From 08d4df410a9ff02c999e69268ec2f4fbfeaac8d7 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Sun, 1 Jul 2012 19:53:54 +0530
+Subject: [PATCH] ath9k: fix power consumption on network sleep when BTCOEX is
+ enabled
+
+The chip is waken up for every 45ms in btcoex timer cycle to
+for sharing the radio between BT and WLAN. Whenever the wlan
+interface is in network sleep mode, do not schedule hw timers.
+This could reduce power consumption on idle associated state.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h |  4 ++++
+ drivers/net/wireless/ath/ath9k/gpio.c  | 16 ++++++++++++++++
+ drivers/net/wireless/ath/ath9k/main.c  |  2 ++
+ 3 files changed, 22 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -481,6 +481,7 @@ void ath9k_btcoex_timer_resume(struct at
+ void ath9k_btcoex_timer_pause(struct ath_softc *sc);
+ void ath9k_btcoex_handle_interrupt(struct ath_softc *sc, u32 status);
+ u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen);
++void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc);
+ #else
+ static inline int ath9k_init_btcoex(struct ath_softc *sc)
+ {
+@@ -504,6 +505,9 @@ static inline u16 ath9k_btcoex_aggr_limi
+ {
+ 	return 0;
+ }
++static inline void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc)
++{
++}
+ #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
+ 
+ /********************/
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -194,6 +194,14 @@ static void ath_btcoex_period_timer(unsi
+ 	struct ath_mci_profile *mci = &btcoex->mci;
+ 	u32 timer_period;
+ 	bool is_btscan;
++	unsigned long flags;
++
++	spin_lock_irqsave(&sc->sc_pm_lock, flags);
++	if (sc->sc_ah->power_mode == ATH9K_PM_NETWORK_SLEEP) {
++		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
++		goto skip_hw_wakeup;
++	}
++	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+ 
+ 	ath9k_ps_wakeup(sc);
+ 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
+@@ -232,6 +240,7 @@ static void ath_btcoex_period_timer(unsi
+ 	}
+ 
+ 	ath9k_ps_restore(sc);
++skip_hw_wakeup:
+ 	timer_period = btcoex->btcoex_period;
+ 	mod_timer(&btcoex->period_timer, jiffies + msecs_to_jiffies(timer_period));
+ }
+@@ -328,6 +337,13 @@ void ath9k_btcoex_timer_pause(struct ath
+ 	btcoex->hw_timer_enabled = false;
+ }
+ 
++void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc)
++{
++	struct ath_btcoex *btcoex = &sc->btcoex;
++
++	ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
++}
++
+ u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen)
+ {
+ 	struct ath_btcoex *btcoex = &sc->btcoex;
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -130,6 +130,8 @@ void ath9k_ps_restore(struct ath_softc *
+ 				     PS_WAIT_FOR_PSPOLL_DATA |
+ 				     PS_WAIT_FOR_TX_ACK))) {
+ 		mode = ATH9K_PM_NETWORK_SLEEP;
++		if (ath9k_hw_btcoex_is_enabled(sc->sc_ah))
++			ath9k_btcoex_stop_gen_timer(sc);
+ 	} else {
+ 		goto unlock;
+ 	}
diff --git a/linux-next-cherry-picks/0096-ath9k_hw-fix-AR9462-2g5g-switch-on-full-reset.patch b/linux-next-cherry-picks/0096-ath9k_hw-fix-AR9462-2g5g-switch-on-full-reset.patch
new file mode 100644
index 0000000..cf159ac
--- /dev/null
+++ b/linux-next-cherry-picks/0096-ath9k_hw-fix-AR9462-2g5g-switch-on-full-reset.patch
@@ -0,0 +1,57 @@
+From 83bfea42190b72acc1a1653bc10b21e741490087 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Sun, 1 Jul 2012 19:53:55 +0530
+Subject: [PATCH] ath9k_hw: fix AR9462 2g5g switch on full reset
+
+On full reset, mci reset will put LNA update on 2G mode. And
+Whenever 2g5g_switch is forced at the end of full reset, lna
+update should not be skipped. Not doing so, is affecting WLAN
+rx and causing beacon loss when BTCOEX is enabled on AR9462.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c | 18 ++++++------------
+ 1 file changed, 6 insertions(+), 12 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -1015,12 +1015,9 @@ void ar9003_mci_2g5g_switch(struct ath_h
+ 		return;
+ 
+ 	if (mci->is_2g) {
+-		if (!force) {
+-			ar9003_mci_send_2g5g_status(ah, true);
+-
+-			ar9003_mci_send_lna_transfer(ah, true);
+-			udelay(5);
+-		}
++		ar9003_mci_send_2g5g_status(ah, true);
++		ar9003_mci_send_lna_transfer(ah, true);
++		udelay(5);
+ 
+ 		REG_CLR_BIT(ah, AR_MCI_TX_CTRL,
+ 			    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
+@@ -1030,10 +1027,8 @@ void ar9003_mci_2g5g_switch(struct ath_h
+ 		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
+ 			ar9003_mci_osla_setup(ah, true);
+ 	} else {
+-		if (!force) {
+-			ar9003_mci_send_lna_take(ah, true);
+-			udelay(5);
+-		}
++		ar9003_mci_send_lna_take(ah, true);
++		udelay(5);
+ 
+ 		REG_SET_BIT(ah, AR_MCI_TX_CTRL,
+ 			    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
+@@ -1041,8 +1036,7 @@ void ar9003_mci_2g5g_switch(struct ath_h
+ 			    AR_BTCOEX_CTRL_BT_OWN_SPDT_CTRL);
+ 
+ 		ar9003_mci_osla_setup(ah, false);
+-		if (!force)
+-			ar9003_mci_send_2g5g_status(ah, true);
++		ar9003_mci_send_2g5g_status(ah, true);
+ 	}
+ }
+ 
diff --git a/linux-next-cherry-picks/0117-ath9k-Fix-MCI-cleanup.patch b/linux-next-cherry-picks/0117-ath9k-Fix-MCI-cleanup.patch
new file mode 100644
index 0000000..9696abb
--- /dev/null
+++ b/linux-next-cherry-picks/0117-ath9k-Fix-MCI-cleanup.patch
@@ -0,0 +1,35 @@
+From dd89f05a7572684bbbc1483c60418504cc91cfe6 Mon Sep 17 00:00:00 2001
+From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Date: Fri, 6 Jul 2012 20:09:16 +0530
+Subject: [PATCH] ath9k: Fix MCI cleanup
+
+We are doing MCI cleanup eventhough BTCOEX is not enabled
+via module parameter. This means we do ath_mci_cleanup
+though we skipped calling ath_mci_setup. Yet it does not
+causes any issues now  as we free the DMA buffer allocated
+only when it is allocated during ath_mci_setup.
+
+Reviewed-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/gpio.c | 4 +++-
+ 1 file changed, 3 insertions(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -403,11 +403,13 @@ void ath9k_stop_btcoex(struct ath_softc
+ 
+ void ath9k_deinit_btcoex(struct ath_softc *sc)
+ {
++	struct ath_hw *ah = sc->sc_ah;
++
+         if ((sc->btcoex.no_stomp_timer) &&
+ 	    ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_3WIRE)
+ 		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
+ 
+-	if (AR_SREV_9462(sc->sc_ah))
++	if (ath9k_hw_mci_is_enabled(ah))
+ 		ath_mci_cleanup(sc);
+ }
+ 
diff --git a/linux-next-cherry-picks/0118-ath9k-Stop-the-BTCOEX-timers-before-disabling-BTCOEX.patch b/linux-next-cherry-picks/0118-ath9k-Stop-the-BTCOEX-timers-before-disabling-BTCOEX.patch
new file mode 100644
index 0000000..4acb062
--- /dev/null
+++ b/linux-next-cherry-picks/0118-ath9k-Stop-the-BTCOEX-timers-before-disabling-BTCOEX.patch
@@ -0,0 +1,46 @@
+From c32cdbd84ffe289a1386eccb794b047a8366913d Mon Sep 17 00:00:00 2001
+From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Date: Fri, 6 Jul 2012 20:09:32 +0530
+Subject: [PATCH] ath9k: Stop the BTCOEX timers before disabling BTCOEX
+
+Its safe to stop the BTCOEX timers 'period_timer' and
+'no_stomp_timer' before disabling BTCOEX. These timers
+can call ath9k_hw_btcoex_enable (or) change the BT
+stomp type if they seem to be running after we had
+called ath9k_hw_btcoex_disable, which is obviously
+not correct.
+
+Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Cc: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/gpio.c | 2 +-
+ drivers/net/wireless/ath/ath9k/mci.c  | 2 +-
+ 2 files changed, 2 insertions(+), 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -393,9 +393,9 @@ void ath9k_stop_btcoex(struct ath_softc
+ 
+ 	if (ah->btcoex_hw.enabled &&
+ 	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
+-		ath9k_hw_btcoex_disable(ah);
+ 		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
+ 			ath9k_btcoex_timer_pause(sc);
++		ath9k_hw_btcoex_disable(ah);
+ 		if (AR_SREV_9462(ah))
+ 			ath_mci_flush_profile(&sc->btcoex.mci);
+ 	}
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -174,8 +174,8 @@ skip_tuning:
+ 			btcoex->btcoex_period >>= 1;
+ 	}
+ 
+-	ath9k_hw_btcoex_disable(sc->sc_ah);
+ 	ath9k_btcoex_timer_pause(sc);
++	ath9k_hw_btcoex_disable(sc->sc_ah);
+ 
+ 	if (IS_CHAN_5GHZ(sc->sc_ah->curchan))
+ 		return;
diff --git a/linux-next-cherry-picks/0119-ath9k_hw-remove-debugging-masks-from-AR_MCI_INTERRUP.patch b/linux-next-cherry-picks/0119-ath9k_hw-remove-debugging-masks-from-AR_MCI_INTERRUP.patch
new file mode 100644
index 0000000..252e4f3
--- /dev/null
+++ b/linux-next-cherry-picks/0119-ath9k_hw-remove-debugging-masks-from-AR_MCI_INTERRUP.patch
@@ -0,0 +1,34 @@
+From d081257c78ace442db2a59f0aa4c52c69b252663 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Sun, 8 Jul 2012 12:53:16 +0530
+Subject: [PATCH] ath9k_hw: remove debugging masks from
+ AR_MCI_INTERRUPT_RX_MSG_DEFAULT
+
+Remove the CONT_* and LNA_* messages from
+AR_MCI_INTERRUPT_RX_MSG_DEFAULT. Those MCI rx messages only
+meant for debugging purpose. Including them in default rx_msg
+series could raise huge amount of MCI interrupts when BT traffic
+is going on. And also it increases power consumption when WLAN
+is scanning.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/reg.h | 6 ------
+ 1 file changed, 6 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/reg.h
++++ b/drivers/net/wireless/ath/ath9k/reg.h
+@@ -2077,12 +2077,6 @@ enum {
+ 					 AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET| \
+ 					 AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING  | \
+ 					 AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING| \
+-					 AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO   | \
+-					 AR_MCI_INTERRUPT_RX_MSG_LNA_CONTROL | \
+-					 AR_MCI_INTERRUPT_RX_MSG_LNA_INFO    | \
+-					 AR_MCI_INTERRUPT_RX_MSG_CONT_NACK   | \
+-					 AR_MCI_INTERRUPT_RX_MSG_CONT_INFO   | \
+-					 AR_MCI_INTERRUPT_RX_MSG_CONT_RST    | \
+ 					 AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE)
+ 
+ #define AR_MCI_CPU_INT					0x1840
diff --git a/linux-next-cherry-picks/0143-ath9k-Fix-beacon-setup.patch b/linux-next-cherry-picks/0143-ath9k-Fix-beacon-setup.patch
new file mode 100644
index 0000000..31c3f4c
--- /dev/null
+++ b/linux-next-cherry-picks/0143-ath9k-Fix-beacon-setup.patch
@@ -0,0 +1,309 @@
+From 130ef6e9dc76f821caf98fa9ed6e2dafe15f3b1f Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Tue, 17 Jul 2012 17:15:30 +0530
+Subject: [PATCH] ath9k: Fix beacon setup
+
+This patch revamps interface addition and deletion and simplifies
+slot allocation. There is no need to setup the beacon buffer
+in add/remove interface, remove this and use simple APIs for
+assigning/deleting slots.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h  |   4 +-
+ drivers/net/wireless/ath/ath9k/beacon.c | 141 ++++++++------------------------
+ drivers/net/wireless/ath/ath9k/main.c   |  48 +++--------
+ 3 files changed, 47 insertions(+), 146 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -413,8 +413,8 @@ struct ath_beacon {
+ 
+ void ath_beacon_tasklet(unsigned long data);
+ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
+-int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif);
+-void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
++void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
++void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
+ int ath_beaconq_config(struct ath_softc *sc);
+ void ath_set_beacon(struct ath_softc *sc);
+ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
+--- a/drivers/net/wireless/ath/ath9k/beacon.c
++++ b/drivers/net/wireless/ath/ath9k/beacon.c
+@@ -222,132 +222,57 @@ static struct ath_buf *ath_beacon_genera
+ 	return bf;
+ }
+ 
+-int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif)
++void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif)
+ {
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+-	struct ath_vif *avp;
+-	struct ath_buf *bf;
+-	struct sk_buff *skb;
+-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+-	__le64 tstamp;
+-
+-	avp = (void *)vif->drv_priv;
+-
+-	/* Allocate a beacon descriptor if we haven't done so. */
+-	if (!avp->av_bcbuf) {
+-		/* Allocate beacon state for hostap/ibss.  We know
+-		 * a buffer is available. */
+-		avp->av_bcbuf = list_first_entry(&sc->beacon.bbuf,
+-						 struct ath_buf, list);
+-		list_del(&avp->av_bcbuf->list);
+-
+-		if (ath9k_uses_beacons(vif->type)) {
+-			int slot;
+-			/*
+-			 * Assign the vif to a beacon xmit slot. As
+-			 * above, this cannot fail to find one.
+-			 */
+-			avp->av_bslot = 0;
+-			for (slot = 0; slot < ATH_BCBUF; slot++)
+-				if (sc->beacon.bslot[slot] == NULL) {
+-					avp->av_bslot = slot;
+-					avp->is_bslot_active = false;
+-
+-					/* NB: keep looking for a double slot */
+-					if (slot == 0 || !sc->beacon.bslot[slot-1])
+-						break;
+-				}
+-			BUG_ON(sc->beacon.bslot[avp->av_bslot] != NULL);
+-			sc->beacon.bslot[avp->av_bslot] = vif;
+-			sc->nbcnvifs++;
+-		}
+-	}
++	struct ath_vif *avp = (void *)vif->drv_priv;
++	int slot;
+ 
+-	/* release the previous beacon frame, if it already exists. */
+-	bf = avp->av_bcbuf;
+-	if (bf->bf_mpdu != NULL) {
+-		skb = bf->bf_mpdu;
+-		dma_unmap_single(sc->dev, bf->bf_buf_addr,
+-				 skb->len, DMA_TO_DEVICE);
+-		dev_kfree_skb_any(skb);
+-		bf->bf_mpdu = NULL;
+-		bf->bf_buf_addr = 0;
+-	}
++	avp->av_bcbuf = list_first_entry(&sc->beacon.bbuf, struct ath_buf, list);
++	list_del(&avp->av_bcbuf->list);
+ 
+-	/* NB: the beacon data buffer must be 32-bit aligned. */
+-	skb = ieee80211_beacon_get(sc->hw, vif);
+-	if (skb == NULL)
+-		return -ENOMEM;
+-
+-	tstamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
+-	sc->beacon.bc_tstamp = (u32) le64_to_cpu(tstamp);
+-	/* Calculate a TSF adjustment factor required for staggered beacons. */
+-	if (avp->av_bslot > 0) {
+-		u64 tsfadjust;
+-		int intval;
+-
+-		intval = cur_conf->beacon_interval ? : ATH_DEFAULT_BINTVAL;
+-
+-		/*
+-		 * Calculate the TSF offset for this beacon slot, i.e., the
+-		 * number of usecs that need to be added to the timestamp field
+-		 * in Beacon and Probe Response frames. Beacon slot 0 is
+-		 * processed at the correct offset, so it does not require TSF
+-		 * adjustment. Other slots are adjusted to get the timestamp
+-		 * close to the TBTT for the BSS.
+-		 */
+-		tsfadjust = TU_TO_USEC(intval * avp->av_bslot) / ATH_BCBUF;
+-		avp->tsf_adjust = cpu_to_le64(tsfadjust);
+-
+-		ath_dbg(common, BEACON,
+-			"stagger beacons, bslot %d intval %u tsfadjust %llu\n",
+-			avp->av_bslot, intval, (unsigned long long)tsfadjust);
+-
+-		((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp =
+-			avp->tsf_adjust;
+-	} else
+-		avp->tsf_adjust = cpu_to_le64(0);
+-
+-	bf->bf_mpdu = skb;
+-	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
+-					 skb->len, DMA_TO_DEVICE);
+-	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
+-		dev_kfree_skb_any(skb);
+-		bf->bf_mpdu = NULL;
+-		bf->bf_buf_addr = 0;
+-		ath_err(common, "dma_mapping_error on beacon alloc\n");
+-		return -ENOMEM;
++	for (slot = 0; slot < ATH_BCBUF; slot++) {
++		if (sc->beacon.bslot[slot] == NULL) {
++			avp->av_bslot = slot;
++			avp->is_bslot_active = false;
++			break;
++		}
+ 	}
+-	avp->is_bslot_active = true;
+ 
+-	return 0;
++	sc->beacon.bslot[avp->av_bslot] = vif;
++	sc->nbcnvifs++;
++
++	ath_dbg(common, CONFIG, "Added interface at beacon slot: %d\n",
++		avp->av_bslot);
+ }
+ 
+-void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
++void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif)
+ {
+-	if (avp->av_bcbuf != NULL) {
+-		struct ath_buf *bf;
++	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
++	struct ath_vif *avp = (void *)vif->drv_priv;
++	struct ath_buf *bf = avp->av_bcbuf;
+ 
+-		avp->is_bslot_active = false;
+-		if (avp->av_bslot != -1) {
+-			sc->beacon.bslot[avp->av_bslot] = NULL;
+-			sc->nbcnvifs--;
+-			avp->av_bslot = -1;
+-		}
++	ath_dbg(common, CONFIG, "Removing interface at beacon slot: %d\n",
++		avp->av_bslot);
+ 
+-		bf = avp->av_bcbuf;
+-		if (bf->bf_mpdu != NULL) {
+-			struct sk_buff *skb = bf->bf_mpdu;
+-			dma_unmap_single(sc->dev, bf->bf_buf_addr,
+-					 skb->len, DMA_TO_DEVICE);
+-			dev_kfree_skb_any(skb);
+-			bf->bf_mpdu = NULL;
+-			bf->bf_buf_addr = 0;
+-		}
+-		list_add_tail(&bf->list, &sc->beacon.bbuf);
++	tasklet_disable(&sc->bcon_tasklet);
+ 
+-		avp->av_bcbuf = NULL;
++	if (bf && bf->bf_mpdu) {
++		struct sk_buff *skb = bf->bf_mpdu;
++		dma_unmap_single(sc->dev, bf->bf_buf_addr,
++				 skb->len, DMA_TO_DEVICE);
++		dev_kfree_skb_any(skb);
++		bf->bf_mpdu = NULL;
++		bf->bf_buf_addr = 0;
+ 	}
++
++	avp->av_bcbuf = NULL;
++	avp->is_bslot_active = false;
++	sc->beacon.bslot[avp->av_bslot] = NULL;
++	sc->nbcnvifs--;
++	list_add_tail(&bf->list, &sc->beacon.bbuf);
++
++	tasklet_enable(&sc->bcon_tasklet);
+ }
+ 
+ void ath_beacon_tasklet(unsigned long data)
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -840,16 +840,6 @@ bool ath9k_uses_beacons(int type)
+ 	}
+ }
+ 
+-static void ath9k_reclaim_beacon(struct ath_softc *sc,
+-				 struct ieee80211_vif *vif)
+-{
+-	struct ath_vif *avp = (void *)vif->drv_priv;
+-
+-	ath9k_set_beaconing_status(sc, false);
+-	ath_beacon_return(sc, avp);
+-	ath9k_set_beaconing_status(sc, true);
+-}
+-
+ static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+ {
+ 	struct ath9k_vif_iter_data *iter_data = data;
+@@ -965,22 +955,6 @@ static void ath9k_calculate_summary_stat
+ 	}
+ }
+ 
+-/* Called with sc->mutex held, vif counts set up properly. */
+-static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
+-				   struct ieee80211_vif *vif)
+-{
+-	struct ath_softc *sc = hw->priv;
+-
+-	ath9k_calculate_summary_state(hw, vif);
+-
+-	if (ath9k_uses_beacons(vif->type)) {
+-		/* Reserve a beacon slot for the vif */
+-		ath9k_set_beaconing_status(sc, false);
+-		ath_beacon_alloc(sc, vif);
+-		ath9k_set_beaconing_status(sc, true);
+-	}
+-}
+-
+ static int ath9k_add_interface(struct ieee80211_hw *hw,
+ 			       struct ieee80211_vif *vif)
+ {
+@@ -1020,7 +994,10 @@ static int ath9k_add_interface(struct ie
+ 
+ 	sc->nvifs++;
+ 
+-	ath9k_do_vif_add_setup(hw, vif);
++	ath9k_calculate_summary_state(hw, vif);
++	if (ath9k_uses_beacons(vif->type))
++		ath9k_beacon_assign_slot(sc, vif);
++
+ out:
+ 	mutex_unlock(&sc->mutex);
+ 	ath9k_ps_restore(sc);
+@@ -1037,6 +1014,7 @@ static int ath9k_change_interface(struct
+ 	int ret = 0;
+ 
+ 	ath_dbg(common, CONFIG, "Change Interface\n");
++
+ 	mutex_lock(&sc->mutex);
+ 	ath9k_ps_wakeup(sc);
+ 
+@@ -1049,15 +1027,16 @@ static int ath9k_change_interface(struct
+ 		}
+ 	}
+ 
+-	/* Clean up old vif stuff */
+ 	if (ath9k_uses_beacons(vif->type))
+-		ath9k_reclaim_beacon(sc, vif);
++		ath9k_beacon_remove_slot(sc, vif);
+ 
+-	/* Add new settings */
+ 	vif->type = new_type;
+ 	vif->p2p = p2p;
+ 
+-	ath9k_do_vif_add_setup(hw, vif);
++	ath9k_calculate_summary_state(hw, vif);
++	if (ath9k_uses_beacons(vif->type))
++		ath9k_beacon_assign_slot(sc, vif);
++
+ out:
+ 	ath9k_ps_restore(sc);
+ 	mutex_unlock(&sc->mutex);
+@@ -1077,9 +1056,8 @@ static void ath9k_remove_interface(struc
+ 
+ 	sc->nvifs--;
+ 
+-	/* Reclaim beacon resources */
+ 	if (ath9k_uses_beacons(vif->type))
+-		ath9k_reclaim_beacon(sc, vif);
++		ath9k_beacon_remove_slot(sc, vif);
+ 
+ 	ath9k_calculate_summary_state(hw, NULL);
+ 
+@@ -1597,9 +1575,7 @@ static void ath9k_bss_info_changed(struc
+ 	     (changed & BSS_CHANGED_BEACON_ENABLED) ||
+ 	     (changed & BSS_CHANGED_BEACON_INT))) {
+ 		ath9k_set_beaconing_status(sc, false);
+-		if (bss_conf->enable_beacon)
+-			ath_beacon_alloc(sc, vif);
+-		else
++		if (!bss_conf->enable_beacon)
+ 			avp->is_bslot_active = false;
+ 		ath_beacon_config(sc, vif);
+ 		ath9k_set_beaconing_status(sc, true);
diff --git a/linux-next-cherry-picks/0144-ath9k_hw-Cleanup-ath9k_hw_set_tsfadjust.patch b/linux-next-cherry-picks/0144-ath9k_hw-Cleanup-ath9k_hw_set_tsfadjust.patch
new file mode 100644
index 0000000..5d0aa16
--- /dev/null
+++ b/linux-next-cherry-picks/0144-ath9k_hw-Cleanup-ath9k_hw_set_tsfadjust.patch
@@ -0,0 +1,90 @@
+From 60ca9f8744d29b8fdfd33d3dec8fc2cfc9ec381a Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Tue, 17 Jul 2012 17:15:37 +0530
+Subject: [PATCH] ath9k_hw: Cleanup ath9k_hw_set_tsfadjust
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/htc_drv_main.c |  2 +-
+ drivers/net/wireless/ath/ath9k/hw.c           |  4 ++--
+ drivers/net/wireless/ath/ath9k/hw.h           |  2 +-
+ drivers/net/wireless/ath/ath9k/main.c         | 10 ++--------
+ 4 files changed, 6 insertions(+), 12 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
++++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+@@ -1106,7 +1106,7 @@ static int ath9k_htc_add_interface(struc
+ 
+ 	if ((priv->ah->opmode == NL80211_IFTYPE_AP) &&
+ 	    !(priv->op_flags & OP_ANI_RUNNING)) {
+-		ath9k_hw_set_tsfadjust(priv->ah, 1);
++		ath9k_hw_set_tsfadjust(priv->ah, true);
+ 		ath9k_htc_start_ani(priv);
+ 	}
+ 
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -2891,9 +2891,9 @@ void ath9k_hw_reset_tsf(struct ath_hw *a
+ }
+ EXPORT_SYMBOL(ath9k_hw_reset_tsf);
+ 
+-void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
++void ath9k_hw_set_tsfadjust(struct ath_hw *ah, bool set)
+ {
+-	if (setting)
++	if (set)
+ 		ah->misc_mode |= AR_PCU_TX_ADD_TSF;
+ 	else
+ 		ah->misc_mode &= ~AR_PCU_TX_ADD_TSF;
+--- a/drivers/net/wireless/ath/ath9k/hw.h
++++ b/drivers/net/wireless/ath/ath9k/hw.h
+@@ -941,7 +941,7 @@ u32 ath9k_hw_gettsf32(struct ath_hw *ah)
+ u64 ath9k_hw_gettsf64(struct ath_hw *ah);
+ void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
+ void ath9k_hw_reset_tsf(struct ath_hw *ah);
+-void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting);
++void ath9k_hw_set_tsfadjust(struct ath_hw *ah, bool set);
+ void ath9k_hw_init_global_settings(struct ath_hw *ah);
+ u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah);
+ void ath9k_hw_set11nmac2040(struct ath_hw *ah);
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -907,17 +907,15 @@ static void ath9k_calculate_summary_stat
+ 
+ 	ath9k_calculate_iter_data(hw, vif, &iter_data);
+ 
+-	/* Set BSSID mask. */
+ 	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
+ 	ath_hw_setbssidmask(common);
+ 
+-	/* Set op-mode & TSF */
+ 	if (iter_data.naps > 0) {
+-		ath9k_hw_set_tsfadjust(ah, 1);
++		ath9k_hw_set_tsfadjust(ah, true);
+ 		set_bit(SC_OP_TSF_RESET, &sc->sc_flags);
+ 		ah->opmode = NL80211_IFTYPE_AP;
+ 	} else {
+-		ath9k_hw_set_tsfadjust(ah, 0);
++		ath9k_hw_set_tsfadjust(ah, false);
+ 		clear_bit(SC_OP_TSF_RESET, &sc->sc_flags);
+ 
+ 		if (iter_data.nmeshes)
+@@ -930,9 +928,6 @@ static void ath9k_calculate_summary_stat
+ 			ah->opmode = NL80211_IFTYPE_STATION;
+ 	}
+ 
+-	/*
+-	 * Enable MIB interrupts when there are hardware phy counters.
+-	 */
+ 	if ((iter_data.nstations + iter_data.nadhocs + iter_data.nmeshes) > 0)
+ 		ah->imask |= ATH9K_INT_TSFOOR;
+ 	else
+@@ -940,7 +935,6 @@ static void ath9k_calculate_summary_stat
+ 
+ 	ath9k_hw_set_interrupts(ah);
+ 
+-	/* Set up ANI */
+ 	if (iter_data.naps > 0) {
+ 		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
+ 
diff --git a/linux-next-cherry-picks/0145-ath9k-Cleanup-interface-handling.patch b/linux-next-cherry-picks/0145-ath9k-Cleanup-interface-handling.patch
new file mode 100644
index 0000000..7d60233
--- /dev/null
+++ b/linux-next-cherry-picks/0145-ath9k-Cleanup-interface-handling.patch
@@ -0,0 +1,62 @@
+From df35d29e171ef043976b339812276ff96d1f4c21 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Tue, 17 Jul 2012 17:15:43 +0530
+Subject: [PATCH] ath9k: Cleanup interface handling
+
+* Do not set/clear TSF when adding/deleting an interface.
+  This should be done when the BSS is set up and should also
+  take into account the existence of other interfaces.
+
+* Set opmode explicitly.
+
+* ANI setup needs to be decided based on multiple interfaces.
+  This can be done via the bss_info_changed() callback.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/main.c | 17 ++---------------
+ 1 file changed, 2 insertions(+), 15 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -912,11 +912,9 @@ static void ath9k_calculate_summary_stat
+ 
+ 	if (iter_data.naps > 0) {
+ 		ath9k_hw_set_tsfadjust(ah, true);
+-		set_bit(SC_OP_TSF_RESET, &sc->sc_flags);
+ 		ah->opmode = NL80211_IFTYPE_AP;
+ 	} else {
+ 		ath9k_hw_set_tsfadjust(ah, false);
+-		clear_bit(SC_OP_TSF_RESET, &sc->sc_flags);
+ 
+ 		if (iter_data.nmeshes)
+ 			ah->opmode = NL80211_IFTYPE_MESH_POINT;
+@@ -928,25 +926,14 @@ static void ath9k_calculate_summary_stat
+ 			ah->opmode = NL80211_IFTYPE_STATION;
+ 	}
+ 
++	ath9k_hw_setopmode(ah);
++
+ 	if ((iter_data.nstations + iter_data.nadhocs + iter_data.nmeshes) > 0)
+ 		ah->imask |= ATH9K_INT_TSFOOR;
+ 	else
+ 		ah->imask &= ~ATH9K_INT_TSFOOR;
+ 
+ 	ath9k_hw_set_interrupts(ah);
+-
+-	if (iter_data.naps > 0) {
+-		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
+-
+-		if (!common->disable_ani) {
+-			set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+-			ath_start_ani(common);
+-		}
+-
+-	} else {
+-		clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+-		del_timer_sync(&common->ani.timer);
+-	}
+ }
+ 
+ static int ath9k_add_interface(struct ieee80211_hw *hw,
diff --git a/linux-next-cherry-picks/0146-ath9k-Simplify-ASSOC-handling.patch b/linux-next-cherry-picks/0146-ath9k-Simplify-ASSOC-handling.patch
new file mode 100644
index 0000000..c097e7f
--- /dev/null
+++ b/linux-next-cherry-picks/0146-ath9k-Simplify-ASSOC-handling.patch
@@ -0,0 +1,197 @@
+From 6c43c090a92938c3e89ce3b7459f91c5159535e2 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Tue, 17 Jul 2012 17:15:50 +0530
+Subject: [PATCH] ath9k: Simplify ASSOC handling
+
+Cleanup the messy logic dealing with station association
+and disassociation.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/beacon.c |   2 +-
+ drivers/net/wireless/ath/ath9k/main.c   | 118 +++++++++++++-------------------
+ 2 files changed, 49 insertions(+), 71 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/beacon.c
++++ b/drivers/net/wireless/ath/ath9k/beacon.c
+@@ -472,7 +472,7 @@ static void ath_beacon_config_sta(struct
+ 	int num_beacons, offset, dtim_dec_count, cfp_dec_count;
+ 
+ 	/* No need to configure beacon if we are not associated */
+-	if (!common->curaid) {
++	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+ 		ath_dbg(common, BEACON,
+ 			"STA is not yet associated..skipping beacon config\n");
+ 		return;
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -1418,86 +1418,53 @@ static int ath9k_set_key(struct ieee8021
+ 
+ 	return ret;
+ }
+-static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
++
++static void ath9k_set_assoc_state(struct ath_softc *sc,
++				  struct ieee80211_vif *vif)
+ {
+-	struct ath_softc *sc = data;
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+-	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+ 	struct ath_vif *avp = (void *)vif->drv_priv;
++	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+ 	unsigned long flags;
++
++	set_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
++	avp->primary_sta_vif = true;
++
+ 	/*
+-	 * Skip iteration if primary station vif's bss info
+-	 * was not changed
++	 * Set the AID, BSSID and do beacon-sync only when
++	 * the HW opmode is STATION.
++	 *
++	 * But the primary bit is set above in any case.
+ 	 */
+-	if (test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
++	if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
+ 		return;
+ 
+-	if (bss_conf->assoc) {
+-		set_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
+-		avp->primary_sta_vif = true;
+-		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+-		common->curaid = bss_conf->aid;
+-		ath9k_hw_write_associd(sc->sc_ah);
+-		ath_dbg(common, CONFIG, "Bss Info ASSOC %d, bssid: %pM\n",
+-			bss_conf->aid, common->curbssid);
+-		ath_beacon_config(sc, vif);
+-		/*
+-		 * Request a re-configuration of Beacon related timers
+-		 * on the receipt of the first Beacon frame (i.e.,
+-		 * after time sync with the AP).
+-		 */
+-		spin_lock_irqsave(&sc->sc_pm_lock, flags);
+-		sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
+-		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+-
+-		/* Reset rssi stats */
+-		sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
+-		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
+-
+-		ath_start_rx_poll(sc, 3);
+-
+-		if (!common->disable_ani) {
+-			set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+-			ath_start_ani(common);
+-		}
+-
+-	}
++	memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
++	common->curaid = bss_conf->aid;
++	ath9k_hw_write_associd(sc->sc_ah);
++
++	sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
++	sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
++
++	spin_lock_irqsave(&sc->sc_pm_lock, flags);
++	sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
++	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
++
++	ath_dbg(common, CONFIG,
++		"Primary Station interface: %pM, BSSID: %pM\n",
++		vif->addr, common->curbssid);
+ }
+ 
+-static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
++static void ath9k_bss_assoc_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+ {
+-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
++	struct ath_softc *sc = data;
+ 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+-	struct ath_vif *avp = (void *)vif->drv_priv;
+ 
+-	if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
++	if (test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
+ 		return;
+ 
+-	/* Reconfigure bss info */
+-	if (avp->primary_sta_vif && !bss_conf->assoc) {
+-		ath_dbg(common, CONFIG, "Bss Info DISASSOC %d, bssid %pM\n",
+-			common->curaid, common->curbssid);
+-		clear_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
+-		clear_bit(SC_OP_BEACONS, &sc->sc_flags);
+-		avp->primary_sta_vif = false;
+-		memset(common->curbssid, 0, ETH_ALEN);
+-		common->curaid = 0;
+-	}
+-
+-	ieee80211_iterate_active_interfaces_atomic(
+-			sc->hw, ath9k_bss_iter, sc);
+-
+-	/*
+-	 * None of station vifs are associated.
+-	 * Clear bssid & aid
+-	 */
+-	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+-		ath9k_hw_write_associd(sc->sc_ah);
+-		clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+-		del_timer_sync(&common->ani.timer);
+-		del_timer_sync(&sc->rx_poll_timer);
+-		memset(&sc->caldata, 0, sizeof(sc->caldata));
+-	}
++	if (bss_conf->assoc)
++		ath9k_set_assoc_state(sc, vif);
+ }
+ 
+ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
+@@ -1515,30 +1482,41 @@ static void ath9k_bss_info_changed(struc
+ 	mutex_lock(&sc->mutex);
+ 
+ 	if (changed & BSS_CHANGED_ASSOC) {
+-		ath9k_config_bss(sc, vif);
++		ath_dbg(common, CONFIG, "BSSID %pM Changed ASSOC %d\n",
++			bss_conf->bssid, bss_conf->assoc);
++
++		if (avp->primary_sta_vif && !bss_conf->assoc) {
++			clear_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
++			avp->primary_sta_vif = false;
++
++			if (ah->opmode == NL80211_IFTYPE_STATION)
++				clear_bit(SC_OP_BEACONS, &sc->sc_flags);
++		}
+ 
+-		ath_dbg(common, CONFIG, "BSSID: %pM aid: 0x%x\n",
+-			common->curbssid, common->curaid);
++		ieee80211_iterate_active_interfaces_atomic(sc->hw,
++						   ath9k_bss_assoc_iter, sc);
++
++		if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags) &&
++		    ah->opmode == NL80211_IFTYPE_STATION) {
++			memset(common->curbssid, 0, ETH_ALEN);
++			common->curaid = 0;
++			ath9k_hw_write_associd(sc->sc_ah);
++		}
+ 	}
+ 
+ 	if (changed & BSS_CHANGED_IBSS) {
+-		/* There can be only one vif available */
+ 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+ 		common->curaid = bss_conf->aid;
+ 		ath9k_hw_write_associd(sc->sc_ah);
+ 
+ 		if (bss_conf->ibss_joined) {
+-			sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
+-
+ 			if (!common->disable_ani) {
+ 				set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+ 				ath_start_ani(common);
+ 			}
+-
+ 		} else {
+ 			clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+ 			del_timer_sync(&common->ani.timer);
+-			del_timer_sync(&sc->rx_poll_timer);
+ 		}
+ 	}
+ 
diff --git a/linux-next-cherry-picks/0147-ath9k-Cleanup-beacon-logic.patch b/linux-next-cherry-picks/0147-ath9k-Cleanup-beacon-logic.patch
new file mode 100644
index 0000000..762a380
--- /dev/null
+++ b/linux-next-cherry-picks/0147-ath9k-Cleanup-beacon-logic.patch
@@ -0,0 +1,448 @@
+From ef4ad63368e6162fb0b18861748fac49edfcbd03 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Tue, 17 Jul 2012 17:15:56 +0530
+Subject: [PATCH] ath9k: Cleanup beacon logic
+
+* The beaconing status routine is not required, since in
+  multi-VIF cases the HW beacon parameters should not be
+  re-configured.
+
+* Remove SC_OP_TSF_RESET - when a beaconing interface comes
+  up the first time, the TSF has to be reset.
+
+* Simplify ath9k_allow_beacon_config().
+
+* Handle setting/clearing the SWBA interrupt properly.
+
+* Remove the TSF mangling in IBSS mode, it is not required.
+
+* General code cleanup.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h  |   8 +-
+ drivers/net/wireless/ath/ath9k/beacon.c | 226 ++++++++++++--------------------
+ drivers/net/wireless/ath/ath9k/main.c   |  24 +---
+ drivers/net/wireless/ath/ath9k/recv.c   |   2 +-
+ 4 files changed, 98 insertions(+), 162 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -386,6 +386,7 @@ struct ath_beacon_config {
+ 	u16 dtim_period;
+ 	u16 bmiss_timeout;
+ 	u8 dtim_count;
++	bool enable_beacon;
+ };
+ 
+ struct ath_beacon {
+@@ -412,11 +413,13 @@ struct ath_beacon {
+ };
+ 
+ void ath_beacon_tasklet(unsigned long data);
+-void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
++bool ath9k_allow_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
++void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
++			 u32 changed);
+ void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
+ void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
+ int ath_beaconq_config(struct ath_softc *sc);
+-void ath_set_beacon(struct ath_softc *sc);
++void ath9k_set_beacon(struct ath_softc *sc);
+ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
+ 
+ /*******************/
+@@ -613,7 +616,6 @@ enum sc_op_flags {
+ 	SC_OP_INVALID,
+ 	SC_OP_BEACONS,
+ 	SC_OP_RXFLUSH,
+-	SC_OP_TSF_RESET,
+ 	SC_OP_ANI_RUN,
+ 	SC_OP_PRIM_STA_VIF,
+ 	SC_OP_HW_RESET,
+--- a/drivers/net/wireless/ath/ath9k/beacon.c
++++ b/drivers/net/wireless/ath/ath9k/beacon.c
+@@ -315,7 +315,6 @@ void ath_beacon_tasklet(unsigned long da
+ 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
+ 			ath_dbg(common, BSTUCK, "beacon is officially stuck\n");
+ 			sc->beacon.bmisscnt = 0;
+-			set_bit(SC_OP_TSF_RESET, &sc->sc_flags);
+ 			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+ 		}
+ 
+@@ -401,21 +400,16 @@ void ath_beacon_tasklet(unsigned long da
+ 	}
+ }
+ 
+-static void ath9k_beacon_init(struct ath_softc *sc,
+-			      u32 next_beacon,
+-			      u32 beacon_period)
++static void ath9k_beacon_init(struct ath_softc *sc, u32 nexttbtt, u32 intval)
+ {
+-	if (test_bit(SC_OP_TSF_RESET, &sc->sc_flags)) {
+-		ath9k_ps_wakeup(sc);
+-		ath9k_hw_reset_tsf(sc->sc_ah);
+-	}
+-
+-	ath9k_hw_beaconinit(sc->sc_ah, next_beacon, beacon_period);
++	struct ath_hw *ah = sc->sc_ah;
+ 
+-	if (test_bit(SC_OP_TSF_RESET, &sc->sc_flags)) {
+-		ath9k_ps_restore(sc);
+-		clear_bit(SC_OP_TSF_RESET, &sc->sc_flags);
+-	}
++	ath9k_hw_disable_interrupts(ah);
++	ath9k_hw_reset_tsf(ah);
++	ath9k_hw_beaconinit(ah, nexttbtt, intval);
++	sc->beacon.bmisscnt = 0;
++	ath9k_hw_set_interrupts(ah);
++	ath9k_hw_enable_interrupts(ah);
+ }
+ 
+ /*
+@@ -423,32 +417,28 @@ static void ath9k_beacon_init(struct ath
+  * burst together.  For the former arrange for the SWBA to be delivered for each
+  * slot. Slots that are not occupied will generate nothing.
+  */
+-static void ath_beacon_config_ap(struct ath_softc *sc,
+-				 struct ath_beacon_config *conf)
++static void ath9k_beacon_config_ap(struct ath_softc *sc,
++				   struct ath_beacon_config *conf)
+ {
+ 	struct ath_hw *ah = sc->sc_ah;
++	struct ath_common *common = ath9k_hw_common(ah);
+ 	u32 nexttbtt, intval;
+ 
+ 	/* NB: the beacon interval is kept internally in TU's */
+ 	intval = TU_TO_USEC(conf->beacon_interval);
+-	intval /= ATH_BCBUF;    /* for staggered beacons */
++	intval /= ATH_BCBUF;
+ 	nexttbtt = intval;
+ 
+-	/*
+-	 * In AP mode we enable the beacon timers and SWBA interrupts to
+-	 * prepare beacon frames.
+-	 */
+-	ah->imask |= ATH9K_INT_SWBA;
+-	ath_beaconq_config(sc);
++	if (conf->enable_beacon)
++		ah->imask |= ATH9K_INT_SWBA;
++	else
++		ah->imask &= ~ATH9K_INT_SWBA;
+ 
+-	/* Set the computed AP beacon timers */
++	ath_dbg(common, BEACON, "AP nexttbtt: %u intval: %u conf_intval: %u\n",
++		nexttbtt, intval, conf->beacon_interval);
+ 
+-	ath9k_hw_disable_interrupts(ah);
+-	set_bit(SC_OP_TSF_RESET, &sc->sc_flags);
++	ath_beaconq_config(sc);
+ 	ath9k_beacon_init(sc, nexttbtt, intval);
+-	sc->beacon.bmisscnt = 0;
+-	ath9k_hw_set_interrupts(ah);
+-	ath9k_hw_enable_interrupts(ah);
+ }
+ 
+ /*
+@@ -459,8 +449,8 @@ static void ath_beacon_config_ap(struct
+  * we'll receive a BMISS interrupt when we stop seeing beacons from the AP
+  * we've associated with.
+  */
+-static void ath_beacon_config_sta(struct ath_softc *sc,
+-				  struct ath_beacon_config *conf)
++static void ath9k_beacon_config_sta(struct ath_softc *sc,
++				    struct ath_beacon_config *conf)
+ {
+ 	struct ath_hw *ah = sc->sc_ah;
+ 	struct ath_common *common = ath9k_hw_common(ah);
+@@ -579,97 +569,66 @@ static void ath_beacon_config_sta(struct
+ 	ath9k_hw_enable_interrupts(ah);
+ }
+ 
+-static void ath_beacon_config_adhoc(struct ath_softc *sc,
+-				    struct ath_beacon_config *conf)
++static void ath9k_beacon_config_adhoc(struct ath_softc *sc,
++				      struct ath_beacon_config *conf)
+ {
+ 	struct ath_hw *ah = sc->sc_ah;
+ 	struct ath_common *common = ath9k_hw_common(ah);
+-	u32 tsf, intval, nexttbtt;
++	u32 intval, nexttbtt;
+ 
+ 	ath9k_reset_beacon_status(sc);
+-	if (!test_bit(SC_OP_BEACONS, &sc->sc_flags))
+-		ath9k_hw_settsf64(ah, sc->beacon.bc_tstamp);
+ 
+ 	intval = TU_TO_USEC(conf->beacon_interval);
+-	tsf = roundup(ath9k_hw_gettsf32(ah) + TU_TO_USEC(FUDGE), intval);
+-	nexttbtt = tsf + intval;
++	nexttbtt = intval;
+ 
+-	ath_dbg(common, BEACON, "IBSS nexttbtt %u intval %u (%u)\n",
+-		nexttbtt, intval, conf->beacon_interval);
++	if (conf->enable_beacon)
++		ah->imask |= ATH9K_INT_SWBA;
++	else
++		ah->imask &= ~ATH9K_INT_SWBA;
+ 
+-	/*
+-	 * In IBSS mode enable the beacon timers but only enable SWBA interrupts
+-	 * if we need to manually prepare beacon frames.  Otherwise we use a
+-	 * self-linked tx descriptor and let the hardware deal with things.
+-	 */
+-	ah->imask |= ATH9K_INT_SWBA;
++	ath_dbg(common, BEACON, "IBSS nexttbtt: %u intval: %u conf_intval: %u\n",
++		nexttbtt, intval, conf->beacon_interval);
+ 
+ 	ath_beaconq_config(sc);
+-
+-	/* Set the computed ADHOC beacon timers */
+-
+-	ath9k_hw_disable_interrupts(ah);
+ 	ath9k_beacon_init(sc, nexttbtt, intval);
+-	sc->beacon.bmisscnt = 0;
+-
+-	ath9k_hw_set_interrupts(ah);
+-	ath9k_hw_enable_interrupts(ah);
+ }
+ 
+-static bool ath9k_allow_beacon_config(struct ath_softc *sc,
+-				      struct ieee80211_vif *vif)
++bool ath9k_allow_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
+ {
+-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+-	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+ 	struct ath_vif *avp = (void *)vif->drv_priv;
+ 
+-	/*
+-	 * Can not have different beacon interval on multiple
+-	 * AP interface case
+-	 */
+-	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) &&
+-	    (sc->nbcnvifs > 1) &&
+-	    (vif->type == NL80211_IFTYPE_AP) &&
+-	    (cur_conf->beacon_interval != bss_conf->beacon_int)) {
+-		ath_dbg(common, CONFIG,
+-			"Changing beacon interval of multiple AP interfaces !\n");
+-		return false;
+-	}
+-	/*
+-	 * Can not configure station vif's beacon config
+-	 * while on AP opmode
+-	 */
+-	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) &&
+-	    (vif->type != NL80211_IFTYPE_AP)) {
+-		ath_dbg(common, CONFIG,
+-			"STA vif's beacon not allowed on AP mode\n");
+-		return false;
++	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
++		if ((vif->type != NL80211_IFTYPE_AP) ||
++		    (sc->nbcnvifs > 1)) {
++			ath_dbg(common, CONFIG,
++				"An AP interface is already present !\n");
++			return false;
++		}
+ 	}
+-	/*
+-	 * Do not allow beacon config if HW was already configured
+-	 * with another STA vif
+-	 */
+-	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
+-	    (vif->type == NL80211_IFTYPE_STATION) &&
+-	    test_bit(SC_OP_BEACONS, &sc->sc_flags) &&
+-	    !avp->primary_sta_vif) {
+-		ath_dbg(common, CONFIG,
+-			"Beacon already configured for a station interface\n");
+-		return false;
++
++	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION) {
++		if ((vif->type == NL80211_IFTYPE_STATION) &&
++		    test_bit(SC_OP_BEACONS, &sc->sc_flags) &&
++		    !avp->primary_sta_vif) {
++			ath_dbg(common, CONFIG,
++				"Beacon already configured for a station interface\n");
++			return false;
++		}
+ 	}
++
+ 	return true;
+ }
+ 
+-void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
++static void ath9k_cache_beacon_config(struct ath_softc *sc,
++				      struct ieee80211_bss_conf *bss_conf)
+ {
++	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+ 	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+-	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+ 
+-	if (!ath9k_allow_beacon_config(sc, vif))
+-		return;
++	ath_dbg(common, BEACON,
++		"Caching beacon data for BSS: %pM\n", bss_conf->bssid);
+ 
+-	/* Setup the beacon configuration parameters */
+ 	cur_conf->beacon_interval = bss_conf->beacon_int;
+ 	cur_conf->dtim_period = bss_conf->dtim_period;
+ 	cur_conf->listen_interval = 1;
+@@ -694,73 +653,62 @@ void ath_beacon_config(struct ath_softc
+ 	if (cur_conf->dtim_period == 0)
+ 		cur_conf->dtim_period = 1;
+ 
+-	ath_set_beacon(sc);
+ }
+ 
+-static bool ath_has_valid_bslot(struct ath_softc *sc)
++void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
++			 u32 changed)
+ {
+-	struct ath_vif *avp;
+-	int slot;
+-	bool found = false;
+-
+-	for (slot = 0; slot < ATH_BCBUF; slot++) {
+-		if (sc->beacon.bslot[slot]) {
+-			avp = (void *)sc->beacon.bslot[slot]->drv_priv;
+-			if (avp->is_bslot_active) {
+-				found = true;
+-				break;
++	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
++	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
++
++	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION) {
++		ath9k_cache_beacon_config(sc, bss_conf);
++		ath9k_set_beacon(sc);
++		set_bit(SC_OP_BEACONS, &sc->sc_flags);
++	} else {
++		/*
++		 * Take care of multiple interfaces when
++		 * enabling/disabling SWBA.
++		 */
++		if (changed & BSS_CHANGED_BEACON_ENABLED) {
++			if (!bss_conf->enable_beacon &&
++			    (sc->nbcnvifs <= 1)) {
++				cur_conf->enable_beacon = false;
++			} else if (bss_conf->enable_beacon) {
++				cur_conf->enable_beacon = true;
++				ath9k_cache_beacon_config(sc, bss_conf);
+ 			}
+ 		}
++
++		if (cur_conf->beacon_interval) {
++			ath9k_set_beacon(sc);
++
++			if (cur_conf->enable_beacon)
++				set_bit(SC_OP_BEACONS, &sc->sc_flags);
++			else
++				clear_bit(SC_OP_BEACONS, &sc->sc_flags);
++		}
+ 	}
+-	return found;
+ }
+ 
+-
+-void ath_set_beacon(struct ath_softc *sc)
++void ath9k_set_beacon(struct ath_softc *sc)
+ {
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+ 	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+ 
+ 	switch (sc->sc_ah->opmode) {
+ 	case NL80211_IFTYPE_AP:
+-		if (ath_has_valid_bslot(sc))
+-			ath_beacon_config_ap(sc, cur_conf);
++		ath9k_beacon_config_ap(sc, cur_conf);
+ 		break;
+ 	case NL80211_IFTYPE_ADHOC:
+ 	case NL80211_IFTYPE_MESH_POINT:
+-		ath_beacon_config_adhoc(sc, cur_conf);
++		ath9k_beacon_config_adhoc(sc, cur_conf);
+ 		break;
+ 	case NL80211_IFTYPE_STATION:
+-		ath_beacon_config_sta(sc, cur_conf);
++		ath9k_beacon_config_sta(sc, cur_conf);
+ 		break;
+ 	default:
+ 		ath_dbg(common, CONFIG, "Unsupported beaconing mode\n");
+ 		return;
+ 	}
+-
+-	set_bit(SC_OP_BEACONS, &sc->sc_flags);
+-}
+-
+-void ath9k_set_beaconing_status(struct ath_softc *sc, bool status)
+-{
+-	struct ath_hw *ah = sc->sc_ah;
+-
+-	if (!ath_has_valid_bslot(sc)) {
+-		clear_bit(SC_OP_BEACONS, &sc->sc_flags);
+-		return;
+-	}
+-
+-	ath9k_ps_wakeup(sc);
+-	if (status) {
+-		/* Re-enable beaconing */
+-		ah->imask |= ATH9K_INT_SWBA;
+-		ath9k_hw_set_interrupts(ah);
+-	} else {
+-		/* Disable SWBA interrupt */
+-		ah->imask &= ~ATH9K_INT_SWBA;
+-		ath9k_hw_set_interrupts(ah);
+-		tasklet_kill(&sc->bcon_tasklet);
+-		ath9k_hw_stop_dma_queue(ah, sc->beacon.beaconq);
+-	}
+-	ath9k_ps_restore(sc);
+ }
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -235,7 +235,7 @@ static bool ath_complete_reset(struct at
+ 		if (!test_bit(SC_OP_BEACONS, &sc->sc_flags))
+ 			goto work;
+ 
+-		ath_set_beacon(sc);
++		ath9k_set_beacon(sc);
+ 
+ 		if (ah->opmode == NL80211_IFTYPE_STATION &&
+ 		    test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+@@ -1520,24 +1520,10 @@ static void ath9k_bss_info_changed(struc
+ 		}
+ 	}
+ 
+-	/*
+-	 * In case of AP mode, the HW TSF has to be reset
+-	 * when the beacon interval changes.
+-	 */
+-	if ((changed & BSS_CHANGED_BEACON_INT) &&
+-	    (vif->type == NL80211_IFTYPE_AP))
+-		set_bit(SC_OP_TSF_RESET, &sc->sc_flags);
+-
+-	/* Configure beaconing (AP, IBSS, MESH) */
+-	if (ath9k_uses_beacons(vif->type) &&
+-	    ((changed & BSS_CHANGED_BEACON) ||
+-	     (changed & BSS_CHANGED_BEACON_ENABLED) ||
+-	     (changed & BSS_CHANGED_BEACON_INT))) {
+-		ath9k_set_beaconing_status(sc, false);
+-		if (!bss_conf->enable_beacon)
+-			avp->is_bslot_active = false;
+-		ath_beacon_config(sc, vif);
+-		ath9k_set_beaconing_status(sc, true);
++	if ((changed & BSS_CHANGED_BEACON_ENABLED) ||
++	    (changed & BSS_CHANGED_BEACON_INT)) {
++		if (ath9k_allow_beacon_config(sc, vif))
++			ath9k_beacon_config(sc, vif, changed);
+ 	}
+ 
+ 	if (changed & BSS_CHANGED_ERP_SLOT) {
+--- a/drivers/net/wireless/ath/ath9k/recv.c
++++ b/drivers/net/wireless/ath/ath9k/recv.c
+@@ -550,7 +550,7 @@ static void ath_rx_ps_beacon(struct ath_
+ 		sc->ps_flags &= ~PS_BEACON_SYNC;
+ 		ath_dbg(common, PS,
+ 			"Reconfigure Beacon timers based on timestamp from the AP\n");
+-		ath_set_beacon(sc);
++		ath9k_set_beacon(sc);
+ 	}
+ 
+ 	if (ath_beacon_dtim_pending_cab(skb)) {
diff --git a/linux-next-cherry-picks/0148-ath9k-Remove-is_bslot_active.patch b/linux-next-cherry-picks/0148-ath9k-Remove-is_bslot_active.patch
new file mode 100644
index 0000000..5e70d09
--- /dev/null
+++ b/linux-next-cherry-picks/0148-ath9k-Remove-is_bslot_active.patch
@@ -0,0 +1,88 @@
+From aa45fe9683ba861bf49d51479b11b3d482b57416 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Tue, 17 Jul 2012 17:16:03 +0530
+Subject: [PATCH] ath9k: Remove is_bslot_active
+
+In the tx_last_beacon() callback, mac80211's beaconing
+status can be used instead. The beacon tasklet doesn't require
+it because it is disabled when removing a slot.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h  |  2 +-
+ drivers/net/wireless/ath/ath9k/beacon.c | 15 +++++----------
+ drivers/net/wireless/ath/ath9k/main.c   |  5 +++--
+ 3 files changed, 9 insertions(+), 13 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -360,7 +360,7 @@ void ath_tx_aggr_sleep(struct ieee80211_
+ 
+ struct ath_vif {
+ 	int av_bslot;
+-	bool is_bslot_active, primary_sta_vif;
++	bool primary_sta_vif;
+ 	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
+ 	struct ath_buf *av_bcbuf;
+ };
+--- a/drivers/net/wireless/ath/ath9k/beacon.c
++++ b/drivers/net/wireless/ath/ath9k/beacon.c
+@@ -134,20 +134,17 @@ static struct ath_buf *ath_beacon_genera
+ 	struct ath_softc *sc = hw->priv;
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+ 	struct ath_buf *bf;
+-	struct ath_vif *avp;
++	struct ath_vif *avp = (void *)vif->drv_priv;
+ 	struct sk_buff *skb;
+-	struct ath_txq *cabq;
++	struct ath_txq *cabq = sc->beacon.cabq;
+ 	struct ieee80211_tx_info *info;
+ 	int cabq_depth;
+ 
+-	ath9k_reset_beacon_status(sc);
+-
+-	avp = (void *)vif->drv_priv;
+-	cabq = sc->beacon.cabq;
+-
+-	if ((avp->av_bcbuf == NULL) || !avp->is_bslot_active)
++	if (avp->av_bcbuf == NULL)
+ 		return NULL;
+ 
++	ath9k_reset_beacon_status(sc);
++
+ 	/* Release the old beacon first */
+ 
+ 	bf = avp->av_bcbuf;
+@@ -234,7 +231,6 @@ void ath9k_beacon_assign_slot(struct ath
+ 	for (slot = 0; slot < ATH_BCBUF; slot++) {
+ 		if (sc->beacon.bslot[slot] == NULL) {
+ 			avp->av_bslot = slot;
+-			avp->is_bslot_active = false;
+ 			break;
+ 		}
+ 	}
+@@ -267,7 +263,6 @@ void ath9k_beacon_remove_slot(struct ath
+ 	}
+ 
+ 	avp->av_bcbuf = NULL;
+-	avp->is_bslot_active = false;
+ 	sc->beacon.bslot[avp->av_bslot] = NULL;
+ 	sc->nbcnvifs--;
+ 	list_add_tail(&bf->list, &sc->beacon.bbuf);
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -1775,10 +1775,11 @@ static int ath9k_tx_last_beacon(struct i
+ 	if (!vif)
+ 		return 0;
+ 
+-	avp = (void *)vif->drv_priv;
+-	if (!avp->is_bslot_active)
++	if (!vif->bss_conf.enable_beacon)
+ 		return 0;
+ 
++	avp = (void *)vif->drv_priv;
++
+ 	if (!sc->beacon.tx_processed && !edma) {
+ 		tasklet_disable(&sc->bcon_tasklet);
+ 
diff --git a/linux-next-cherry-picks/0149-ath9k-Cleanup-beacon-queue-configuration.patch b/linux-next-cherry-picks/0149-ath9k-Cleanup-beacon-queue-configuration.patch
new file mode 100644
index 0000000..59977be
--- /dev/null
+++ b/linux-next-cherry-picks/0149-ath9k-Cleanup-beacon-queue-configuration.patch
@@ -0,0 +1,119 @@
+From 7e52c8aa35c987236a80b7063c418a3d29b51052 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Tue, 17 Jul 2012 17:16:09 +0530
+Subject: [PATCH] ath9k: Cleanup beacon queue configuration
+
+Setup the beacon queue parameters after disabling
+interrupts. Also, remove the redundant call in conf_tx()
+for IBSS mode since the queue would be configured
+with the appropriate cwmin/cwmax values when beaconing
+is enabled.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h  |  1 -
+ drivers/net/wireless/ath/ath9k/beacon.c | 11 ++++-------
+ drivers/net/wireless/ath/ath9k/main.c   |  4 ----
+ drivers/net/wireless/ath/ath9k/xmit.c   | 10 ----------
+ 4 files changed, 4 insertions(+), 22 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -418,7 +418,6 @@ void ath9k_beacon_config(struct ath_soft
+ 			 u32 changed);
+ void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
+ void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
+-int ath_beaconq_config(struct ath_softc *sc);
+ void ath9k_set_beacon(struct ath_softc *sc);
+ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
+ 
+--- a/drivers/net/wireless/ath/ath9k/beacon.c
++++ b/drivers/net/wireless/ath/ath9k/beacon.c
+@@ -30,7 +30,7 @@ static void ath9k_reset_beacon_status(st
+  *  the operating mode of the station (AP or AdHoc).  Parameters are AIFS
+  *  settings and channel width min/max
+ */
+-int ath_beaconq_config(struct ath_softc *sc)
++static void ath9k_beaconq_config(struct ath_softc *sc)
+ {
+ 	struct ath_hw *ah = sc->sc_ah;
+ 	struct ath_common *common = ath9k_hw_common(ah);
+@@ -38,6 +38,7 @@ int ath_beaconq_config(struct ath_softc
+ 	struct ath_txq *txq;
+ 
+ 	ath9k_hw_get_txq_props(ah, sc->beacon.beaconq, &qi);
++
+ 	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
+ 		/* Always burst out beacon and CAB traffic. */
+ 		qi.tqi_aifs = 1;
+@@ -56,12 +57,9 @@ int ath_beaconq_config(struct ath_softc
+ 	}
+ 
+ 	if (!ath9k_hw_set_txq_props(ah, sc->beacon.beaconq, &qi)) {
+-		ath_err(common,
+-			"Unable to update h/w beacon queue parameters\n");
+-		return 0;
++		ath_err(common, "Unable to update h/w beacon queue parameters\n");
+ 	} else {
+ 		ath9k_hw_resettxqueue(ah, sc->beacon.beaconq);
+-		return 1;
+ 	}
+ }
+ 
+@@ -401,6 +399,7 @@ static void ath9k_beacon_init(struct ath
+ 
+ 	ath9k_hw_disable_interrupts(ah);
+ 	ath9k_hw_reset_tsf(ah);
++	ath9k_beaconq_config(sc);
+ 	ath9k_hw_beaconinit(ah, nexttbtt, intval);
+ 	sc->beacon.bmisscnt = 0;
+ 	ath9k_hw_set_interrupts(ah);
+@@ -432,7 +431,6 @@ static void ath9k_beacon_config_ap(struc
+ 	ath_dbg(common, BEACON, "AP nexttbtt: %u intval: %u conf_intval: %u\n",
+ 		nexttbtt, intval, conf->beacon_interval);
+ 
+-	ath_beaconq_config(sc);
+ 	ath9k_beacon_init(sc, nexttbtt, intval);
+ }
+ 
+@@ -584,7 +582,6 @@ static void ath9k_beacon_config_adhoc(st
+ 	ath_dbg(common, BEACON, "IBSS nexttbtt: %u intval: %u conf_intval: %u\n",
+ 		nexttbtt, intval, conf->beacon_interval);
+ 
+-	ath_beaconq_config(sc);
+ 	ath9k_beacon_init(sc, nexttbtt, intval);
+ }
+ 
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -1346,10 +1346,6 @@ static int ath9k_conf_tx(struct ieee8021
+ 	if (ret)
+ 		ath_err(common, "TXQ Update failed\n");
+ 
+-	if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)
+-		if (queue == WME_AC_BE && !ret)
+-			ath_beaconq_config(sc);
+-
+ 	mutex_unlock(&sc->mutex);
+ 	ath9k_ps_restore(sc);
+ 
+--- a/drivers/net/wireless/ath/ath9k/xmit.c
++++ b/drivers/net/wireless/ath/ath9k/xmit.c
+@@ -1403,16 +1403,6 @@ int ath_txq_update(struct ath_softc *sc,
+ 	int error = 0;
+ 	struct ath9k_tx_queue_info qi;
+ 
+-	if (qnum == sc->beacon.beaconq) {
+-		/*
+-		 * XXX: for beacon queue, we just save the parameter.
+-		 * It will be picked up by ath_beaconq_config when
+-		 * it's necessary.
+-		 */
+-		sc->beacon.beacon_qi = *qinfo;
+-		return 0;
+-	}
+-
+ 	BUG_ON(sc->tx.txq[qnum].axq_qnum != qnum);
+ 
+ 	ath9k_hw_get_txq_props(ah, qnum, &qi);
diff --git a/linux-next-cherry-picks/0150-ath9k-Set-the-TSF-adjust-value-properly.patch b/linux-next-cherry-picks/0150-ath9k-Set-the-TSF-adjust-value-properly.patch
new file mode 100644
index 0000000..8163d66
--- /dev/null
+++ b/linux-next-cherry-picks/0150-ath9k-Set-the-TSF-adjust-value-properly.patch
@@ -0,0 +1,61 @@
+From 2f8e82e8ab4629e648925c566cc26bdcf25f0aec Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Tue, 17 Jul 2012 17:16:16 +0530
+Subject: [PATCH] ath9k: Set the TSF adjust value properly
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h  |  1 +
+ drivers/net/wireless/ath/ath9k/beacon.c | 17 +++++++++++++++++
+ drivers/net/wireless/ath/ath9k/main.c   |  3 +++
+ 3 files changed, 21 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -418,6 +418,7 @@ void ath9k_beacon_config(struct ath_soft
+ 			 u32 changed);
+ void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
+ void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
++void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif);
+ void ath9k_set_beacon(struct ath_softc *sc);
+ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
+ 
+--- a/drivers/net/wireless/ath/ath9k/beacon.c
++++ b/drivers/net/wireless/ath/ath9k/beacon.c
+@@ -268,6 +268,23 @@ void ath9k_beacon_remove_slot(struct ath
+ 	tasklet_enable(&sc->bcon_tasklet);
+ }
+ 
++void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif)
++{
++	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
++	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
++	struct ath_vif *avp = (void *)vif->drv_priv;
++	u64 tsfadjust;
++
++	if (avp->av_bslot == 0)
++		return;
++
++	tsfadjust = cur_conf->beacon_interval * avp->av_bslot / ATH_BCBUF;
++	avp->tsf_adjust = cpu_to_le64(TU_TO_USEC(tsfadjust));
++
++	ath_dbg(common, CONFIG, "tsfadjust is: %llu for bslot: %d\n",
++		(unsigned long long)tsfadjust, avp->av_bslot);
++}
++
+ void ath_beacon_tasklet(unsigned long data)
+ {
+ 	struct ath_softc *sc = (struct ath_softc *)data;
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -1518,6 +1518,9 @@ static void ath9k_bss_info_changed(struc
+ 
+ 	if ((changed & BSS_CHANGED_BEACON_ENABLED) ||
+ 	    (changed & BSS_CHANGED_BEACON_INT)) {
++		if (ah->opmode == NL80211_IFTYPE_AP &&
++		    bss_conf->enable_beacon)
++			ath9k_set_tsfadjust(sc, vif);
+ 		if (ath9k_allow_beacon_config(sc, vif))
+ 			ath9k_beacon_config(sc, vif, changed);
+ 	}
diff --git a/linux-next-cherry-picks/0151-ath9k-Cleanup-the-beacon-tasklet.patch b/linux-next-cherry-picks/0151-ath9k-Cleanup-the-beacon-tasklet.patch
new file mode 100644
index 0000000..27cc216
--- /dev/null
+++ b/linux-next-cherry-picks/0151-ath9k-Cleanup-the-beacon-tasklet.patch
@@ -0,0 +1,281 @@
+From fb6e252f8d262d05da3ae023b4a6f83d0eec17d9 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Tue, 17 Jul 2012 17:16:22 +0530
+Subject: [PATCH] ath9k: Cleanup the beacon tasklet
+
+Remove unused variables, use a helper function to choose
+the slot and reset beaconing status at one place.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h  |   3 +-
+ drivers/net/wireless/ath/ath9k/beacon.c | 126 ++++++++++++++++----------------
+ drivers/net/wireless/ath/ath9k/init.c   |   2 +-
+ 3 files changed, 63 insertions(+), 68 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -398,7 +398,6 @@ struct ath_beacon {
+ 
+ 	u32 beaconq;
+ 	u32 bmisscnt;
+-	u32 ast_be_xmit;
+ 	u32 bc_tstamp;
+ 	struct ieee80211_vif *bslot[ATH_BCBUF];
+ 	int slottime;
+@@ -412,7 +411,7 @@ struct ath_beacon {
+ 	bool tx_last;
+ };
+ 
+-void ath_beacon_tasklet(unsigned long data);
++void ath9k_beacon_tasklet(unsigned long data);
+ bool ath9k_allow_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
+ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
+ 			 u32 changed);
+--- a/drivers/net/wireless/ath/ath9k/beacon.c
++++ b/drivers/net/wireless/ath/ath9k/beacon.c
+@@ -68,7 +68,7 @@ static void ath9k_beaconq_config(struct
+  *  up rate codes, and channel flags. Beacons are always sent out at the
+  *  lowest rate, and are not retried.
+ */
+-static void ath_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
++static void ath9k_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
+ 			     struct ath_buf *bf, int rateidx)
+ {
+ 	struct sk_buff *skb = bf->bf_mpdu;
+@@ -79,8 +79,6 @@ static void ath_beacon_setup(struct ath_
+ 	u8 chainmask = ah->txchainmask;
+ 	u8 rate = 0;
+ 
+-	ath9k_reset_beacon_status(sc);
+-
+ 	sband = &sc->sbands[common->hw->conf.channel->band];
+ 	rate = sband->bitrates[rateidx].hw_value;
+ 	if (vif->bss_conf.use_short_preamble)
+@@ -109,7 +107,7 @@ static void ath_beacon_setup(struct ath_
+ 	ath9k_hw_set_txdesc(ah, bf->bf_desc, &info);
+ }
+ 
+-static void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
++static void ath9k_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
+ {
+ 	struct ath_softc *sc = hw->priv;
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+@@ -126,8 +124,8 @@ static void ath_tx_cabq(struct ieee80211
+ 	}
+ }
+ 
+-static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
+-					   struct ieee80211_vif *vif)
++static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
++					     struct ieee80211_vif *vif)
+ {
+ 	struct ath_softc *sc = hw->priv;
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+@@ -136,15 +134,12 @@ static struct ath_buf *ath_beacon_genera
+ 	struct sk_buff *skb;
+ 	struct ath_txq *cabq = sc->beacon.cabq;
+ 	struct ieee80211_tx_info *info;
++	struct ieee80211_mgmt *mgmt_hdr;
+ 	int cabq_depth;
+ 
+ 	if (avp->av_bcbuf == NULL)
+ 		return NULL;
+ 
+-	ath9k_reset_beacon_status(sc);
+-
+-	/* Release the old beacon first */
+-
+ 	bf = avp->av_bcbuf;
+ 	skb = bf->bf_mpdu;
+ 	if (skb) {
+@@ -154,14 +149,14 @@ static struct ath_buf *ath_beacon_genera
+ 		bf->bf_buf_addr = 0;
+ 	}
+ 
+-	/* Get a new beacon from mac80211 */
+-
+ 	skb = ieee80211_beacon_get(hw, vif);
+-	bf->bf_mpdu = skb;
+ 	if (skb == NULL)
+ 		return NULL;
+-	((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp =
+-		avp->tsf_adjust;
++
++	bf->bf_mpdu = skb;
++
++	mgmt_hdr = (struct ieee80211_mgmt *)skb->data;
++	mgmt_hdr->u.beacon.timestamp = avp->tsf_adjust;
+ 
+ 	info = IEEE80211_SKB_CB(skb);
+ 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+@@ -207,10 +202,10 @@ static struct ath_buf *ath_beacon_genera
+ 		}
+ 	}
+ 
+-	ath_beacon_setup(sc, vif, bf, info->control.rates[0].idx);
++	ath9k_beacon_setup(sc, vif, bf, info->control.rates[0].idx);
+ 
+ 	while (skb) {
+-		ath_tx_cabq(hw, skb);
++		ath9k_tx_cabq(hw, skb);
+ 		skb = ieee80211_get_buffered_bc(hw, vif);
+ 	}
+ 
+@@ -268,6 +263,33 @@ void ath9k_beacon_remove_slot(struct ath
+ 	tasklet_enable(&sc->bcon_tasklet);
+ }
+ 
++static int ath9k_beacon_choose_slot(struct ath_softc *sc)
++{
++	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
++	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
++	u16 intval;
++	u32 tsftu;
++	u64 tsf;
++	int slot;
++
++	if (sc->sc_ah->opmode != NL80211_IFTYPE_AP) {
++		ath_dbg(common, BEACON, "slot 0, tsf: %llu\n",
++			ath9k_hw_gettsf64(sc->sc_ah));
++		return 0;
++	}
++
++	intval = cur_conf->beacon_interval ? : ATH_DEFAULT_BINTVAL;
++	tsf = ath9k_hw_gettsf64(sc->sc_ah);
++	tsf += TU_TO_USEC(sc->sc_ah->config.sw_beacon_response_time);
++	tsftu = TSF_TO_TU((tsf * ATH_BCBUF) >>32, tsf * ATH_BCBUF);
++	slot = (tsftu % (intval * ATH_BCBUF)) / intval;
++
++	ath_dbg(common, BEACON, "slot: %d tsf: %llu tsftu: %u\n",
++		slot, tsf, tsftu / ATH_BCBUF);
++
++	return slot;
++}
++
+ void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif)
+ {
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+@@ -285,17 +307,15 @@ void ath9k_set_tsfadjust(struct ath_soft
+ 		(unsigned long long)tsfadjust, avp->av_bslot);
+ }
+ 
+-void ath_beacon_tasklet(unsigned long data)
++void ath9k_beacon_tasklet(unsigned long data)
+ {
+ 	struct ath_softc *sc = (struct ath_softc *)data;
+-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+ 	struct ath_hw *ah = sc->sc_ah;
+ 	struct ath_common *common = ath9k_hw_common(ah);
+ 	struct ath_buf *bf = NULL;
+ 	struct ieee80211_vif *vif;
+ 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
+ 	int slot;
+-	u32 bfaddr, bc = 0;
+ 
+ 	if (work_pending(&sc->hw_reset_work)) {
+ 		ath_dbg(common, RESET,
+@@ -331,48 +351,19 @@ void ath_beacon_tasklet(unsigned long da
+ 		return;
+ 	}
+ 
+-	/*
+-	 * Generate beacon frames. we are sending frames
+-	 * staggered so calculate the slot for this frame based
+-	 * on the tsf to safeguard against missing an swba.
+-	 */
+-
+-
+-	if (ah->opmode == NL80211_IFTYPE_AP) {
+-		u16 intval;
+-		u32 tsftu;
+-		u64 tsf;
+-
+-		intval = cur_conf->beacon_interval ? : ATH_DEFAULT_BINTVAL;
+-		tsf = ath9k_hw_gettsf64(ah);
+-		tsf += TU_TO_USEC(ah->config.sw_beacon_response_time);
+-		tsftu = TSF_TO_TU((tsf * ATH_BCBUF) >>32, tsf * ATH_BCBUF);
+-		slot = (tsftu % (intval * ATH_BCBUF)) / intval;
+-		vif = sc->beacon.bslot[slot];
+-
+-		ath_dbg(common, BEACON,
+-			"slot %d [tsf %llu tsftu %u intval %u] vif %p\n",
+-			slot, tsf, tsftu / ATH_BCBUF, intval, vif);
+-	} else {
+-		slot = 0;
+-		vif = sc->beacon.bslot[slot];
+-	}
++	slot = ath9k_beacon_choose_slot(sc);
++	vif = sc->beacon.bslot[slot];
+ 
++	if (!vif || !vif->bss_conf.enable_beacon)
++		return;
+ 
+-	bfaddr = 0;
+-	if (vif) {
+-		bf = ath_beacon_generate(sc->hw, vif);
+-		if (bf != NULL) {
+-			bfaddr = bf->bf_daddr;
+-			bc = 1;
+-		}
++	bf = ath9k_beacon_generate(sc->hw, vif);
++	WARN_ON(!bf);
+ 
+-		if (sc->beacon.bmisscnt != 0) {
+-			ath_dbg(common, BSTUCK,
+-				"resume beacon xmit after %u misses\n",
+-				sc->beacon.bmisscnt);
+-			sc->beacon.bmisscnt = 0;
+-		}
++	if (sc->beacon.bmisscnt != 0) {
++		ath_dbg(common, BSTUCK, "resume beacon xmit after %u misses\n",
++			sc->beacon.bmisscnt);
++		sc->beacon.bmisscnt = 0;
+ 	}
+ 
+ 	/*
+@@ -392,21 +383,26 @@ void ath_beacon_tasklet(unsigned long da
+ 	 *     set to ATH_BCBUF so this check is a noop.
+ 	 */
+ 	if (sc->beacon.updateslot == UPDATE) {
+-		sc->beacon.updateslot = COMMIT; /* commit next beacon */
++		sc->beacon.updateslot = COMMIT;
+ 		sc->beacon.slotupdate = slot;
+-	} else if (sc->beacon.updateslot == COMMIT && sc->beacon.slotupdate == slot) {
++	} else if (sc->beacon.updateslot == COMMIT &&
++		   sc->beacon.slotupdate == slot) {
+ 		ah->slottime = sc->beacon.slottime;
+ 		ath9k_hw_init_global_settings(ah);
+ 		sc->beacon.updateslot = OK;
+ 	}
+-	if (bfaddr != 0) {
++
++	if (bf) {
++		ath9k_reset_beacon_status(sc);
++
++		ath_dbg(common, BEACON,
++			"Transmitting beacon for slot: %d\n", slot);
++
+ 		/* NB: cabq traffic should already be queued and primed */
+-		ath9k_hw_puttxbuf(ah, sc->beacon.beaconq, bfaddr);
++		ath9k_hw_puttxbuf(ah, sc->beacon.beaconq, bf->bf_daddr);
+ 
+ 		if (!edma)
+ 			ath9k_hw_txstart(ah, sc->beacon.beaconq);
+-
+-		sc->beacon.ast_be_xmit += bc;     /* XXX per-vif? */
+ 	}
+ }
+ 
+--- a/drivers/net/wireless/ath/ath9k/init.c
++++ b/drivers/net/wireless/ath/ath9k/init.c
+@@ -560,7 +560,7 @@ static int ath9k_init_softc(u16 devid, s
+ 	spin_lock_init(&sc->debug.samp_lock);
+ #endif
+ 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
+-	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
++	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
+ 		     (unsigned long)sc);
+ 
+ 	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
diff --git a/linux-next-cherry-picks/0152-ath9k-Fix-ANI-management.patch b/linux-next-cherry-picks/0152-ath9k-Fix-ANI-management.patch
new file mode 100644
index 0000000..96b7757
--- /dev/null
+++ b/linux-next-cherry-picks/0152-ath9k-Fix-ANI-management.patch
@@ -0,0 +1,206 @@
+From da0d45f7b1dd08ab1ea4f542db797a0c51724281 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Tue, 17 Jul 2012 17:16:29 +0530
+Subject: [PATCH] ath9k: Fix ANI management
+
+Currently, there are problems with how ANI is handled in
+multi-VIF scenarios. This patch addresses them by unifying
+the start/stop logic.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h |  4 ++-
+ drivers/net/wireless/ath/ath9k/debug.c |  5 ++-
+ drivers/net/wireless/ath/ath9k/link.c  | 60 ++++++++++++++++++++++++++++++----
+ drivers/net/wireless/ath/ath9k/main.c  | 29 +++++++---------
+ 4 files changed, 70 insertions(+), 28 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -444,7 +444,9 @@ void ath_rx_poll(unsigned long data);
+ void ath_start_rx_poll(struct ath_softc *sc, u8 nbeacon);
+ void ath_paprd_calibrate(struct work_struct *work);
+ void ath_ani_calibrate(unsigned long data);
+-void ath_start_ani(struct ath_common *common);
++void ath_start_ani(struct ath_softc *sc);
++void ath_stop_ani(struct ath_softc *sc);
++void ath_check_ani(struct ath_softc *sc);
+ int ath_update_survey_stats(struct ath_softc *sc);
+ void ath_update_survey_nf(struct ath_softc *sc, int channel);
+ 
+--- a/drivers/net/wireless/ath/ath9k/debug.c
++++ b/drivers/net/wireless/ath/ath9k/debug.c
+@@ -206,10 +206,9 @@ static ssize_t write_file_disable_ani(st
+ 
+ 	if (disable_ani) {
+ 		clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+-		del_timer_sync(&common->ani.timer);
++		ath_stop_ani(sc);
+ 	} else {
+-		set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+-		ath_start_ani(common);
++		ath_check_ani(sc);
+ 	}
+ 
+ 	return count;
+--- a/drivers/net/wireless/ath/ath9k/link.c
++++ b/drivers/net/wireless/ath/ath9k/link.c
+@@ -432,26 +432,72 @@ set_timer:
+ 	}
+ }
+ 
+-void ath_start_ani(struct ath_common *common)
++void ath_start_ani(struct ath_softc *sc)
+ {
+-	struct ath_hw *ah = common->ah;
++	struct ath_hw *ah = sc->sc_ah;
++	struct ath_common *common = ath9k_hw_common(ah);
+ 	unsigned long timestamp = jiffies_to_msecs(jiffies);
+-	struct ath_softc *sc = (struct ath_softc *) common->priv;
+ 
+-	if (!test_bit(SC_OP_ANI_RUN, &sc->sc_flags))
+-		return;
+-
+-	if (sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
++	if (common->disable_ani ||
++	    !test_bit(SC_OP_ANI_RUN, &sc->sc_flags) ||
++	    (sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
+ 		return;
+ 
+ 	common->ani.longcal_timer = timestamp;
+ 	common->ani.shortcal_timer = timestamp;
+ 	common->ani.checkani_timer = timestamp;
+ 
++	ath_dbg(common, ANI, "Starting ANI\n");
+ 	mod_timer(&common->ani.timer,
+ 		  jiffies + msecs_to_jiffies((u32)ah->config.ani_poll_interval));
+ }
+ 
++void ath_stop_ani(struct ath_softc *sc)
++{
++	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
++
++	ath_dbg(common, ANI, "Stopping ANI\n");
++	del_timer_sync(&common->ani.timer);
++}
++
++void ath_check_ani(struct ath_softc *sc)
++{
++	struct ath_hw *ah = sc->sc_ah;
++	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
++
++	/*
++	 * Check for the various conditions in which ANI has to
++	 * be stopped.
++	 */
++	if (ah->opmode == NL80211_IFTYPE_ADHOC) {
++		if (!cur_conf->enable_beacon)
++			goto stop_ani;
++	} else if (ah->opmode == NL80211_IFTYPE_AP) {
++		if (!cur_conf->enable_beacon) {
++			/*
++			 * Disable ANI only when there are no
++			 * associated stations.
++			 */
++			if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
++				goto stop_ani;
++		}
++	} else if (ah->opmode == NL80211_IFTYPE_STATION) {
++		if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
++			goto stop_ani;
++	}
++
++	if (!test_bit(SC_OP_ANI_RUN, &sc->sc_flags)) {
++		set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
++		ath_start_ani(sc);
++	}
++
++	return;
++
++stop_ani:
++	clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
++	ath_stop_ani(sc);
++}
++
+ void ath_update_survey_nf(struct ath_softc *sc, int channel)
+ {
+ 	struct ath_hw *ah = sc->sc_ah;
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -167,8 +167,6 @@ static void ath_cancel_work(struct ath_s
+ 
+ static void ath_restart_work(struct ath_softc *sc)
+ {
+-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+-
+ 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
+ 
+ 	if (AR_SREV_9485(sc->sc_ah) || AR_SREV_9340(sc->sc_ah))
+@@ -176,21 +174,18 @@ static void ath_restart_work(struct ath_
+ 				     msecs_to_jiffies(ATH_PLL_WORK_INTERVAL));
+ 
+ 	ath_start_rx_poll(sc, 3);
+-
+-	if (!common->disable_ani)
+-		ath_start_ani(common);
++	ath_start_ani(sc);
+ }
+ 
+ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
+ {
+ 	struct ath_hw *ah = sc->sc_ah;
+-	struct ath_common *common = ath9k_hw_common(ah);
+ 	bool ret = true;
+ 
+ 	ieee80211_stop_queues(sc->hw);
+ 
+ 	sc->hw_busy_count = 0;
+-	del_timer_sync(&common->ani.timer);
++	ath_stop_ani(sc);
+ 	del_timer_sync(&sc->rx_poll_timer);
+ 
+ 	ath9k_debug_samp_bb_mac(sc);
+@@ -1468,6 +1463,11 @@ static void ath9k_bss_info_changed(struc
+ 				   struct ieee80211_bss_conf *bss_conf,
+ 				   u32 changed)
+ {
++#define CHECK_ANI				\
++	(BSS_CHANGED_ASSOC |			\
++	 BSS_CHANGED_IBSS |			\
++	 BSS_CHANGED_BEACON_ENABLED)
++
+ 	struct ath_softc *sc = hw->priv;
+ 	struct ath_hw *ah = sc->sc_ah;
+ 	struct ath_common *common = ath9k_hw_common(ah);
+@@ -1504,16 +1504,6 @@ static void ath9k_bss_info_changed(struc
+ 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+ 		common->curaid = bss_conf->aid;
+ 		ath9k_hw_write_associd(sc->sc_ah);
+-
+-		if (bss_conf->ibss_joined) {
+-			if (!common->disable_ani) {
+-				set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+-				ath_start_ani(common);
+-			}
+-		} else {
+-			clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+-			del_timer_sync(&common->ani.timer);
+-		}
+ 	}
+ 
+ 	if ((changed & BSS_CHANGED_BEACON_ENABLED) ||
+@@ -1544,8 +1534,13 @@ static void ath9k_bss_info_changed(struc
+ 		}
+ 	}
+ 
++	if (changed & CHECK_ANI)
++		ath_check_ani(sc);
++
+ 	mutex_unlock(&sc->mutex);
+ 	ath9k_ps_restore(sc);
++
++#undef CHECK_ANI
+ }
+ 
+ static u64 ath9k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
diff --git a/linux-next-cherry-picks/0153-ath9k-Reconfigure-VIF-state-properly.patch b/linux-next-cherry-picks/0153-ath9k-Reconfigure-VIF-state-properly.patch
new file mode 100644
index 0000000..5809ea6
--- /dev/null
+++ b/linux-next-cherry-picks/0153-ath9k-Reconfigure-VIF-state-properly.patch
@@ -0,0 +1,73 @@
+From 6dcc344469d60a1f0d72cc638967e8c83c6e166e Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Tue, 17 Jul 2012 17:16:36 +0530
+Subject: [PATCH] ath9k: Reconfigure VIF state properly
+
+When an interface in AP or P2P-GO mode is removed,
+check whether a station interface is already present and
+reconfigure the beacon timers etc. properly if it's
+associated.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/main.c | 27 +++++++++++++++++++++++++++
+ 1 file changed, 27 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -19,6 +19,9 @@
+ #include "ath9k.h"
+ #include "btcoex.h"
+ 
++static void ath9k_set_assoc_state(struct ath_softc *sc,
++				  struct ieee80211_vif *vif);
++
+ u8 ath9k_parse_mpdudensity(u8 mpdudensity)
+ {
+ 	/*
+@@ -866,6 +869,18 @@ static void ath9k_vif_iter(void *data, u
+ 	}
+ }
+ 
++static void ath9k_sta_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
++{
++	struct ath_softc *sc = data;
++	struct ath_vif *avp = (void *)vif->drv_priv;
++
++	if (vif->type != NL80211_IFTYPE_STATION)
++		return;
++
++	if (avp->primary_sta_vif)
++		ath9k_set_assoc_state(sc, vif);
++}
++
+ /* Called with sc->mutex held. */
+ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
+ 			       struct ieee80211_vif *vif,
+@@ -899,6 +914,7 @@ static void ath9k_calculate_summary_stat
+ 	struct ath_hw *ah = sc->sc_ah;
+ 	struct ath_common *common = ath9k_hw_common(ah);
+ 	struct ath9k_vif_iter_data iter_data;
++	enum nl80211_iftype old_opmode = ah->opmode;
+ 
+ 	ath9k_calculate_iter_data(hw, vif, &iter_data);
+ 
+@@ -929,6 +945,17 @@ static void ath9k_calculate_summary_stat
+ 		ah->imask &= ~ATH9K_INT_TSFOOR;
+ 
+ 	ath9k_hw_set_interrupts(ah);
++
++	/*
++	 * If we are changing the opmode to STATION,
++	 * a beacon sync needs to be done.
++	 */
++	if (ah->opmode == NL80211_IFTYPE_STATION &&
++	    old_opmode == NL80211_IFTYPE_AP &&
++	    test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
++		ieee80211_iterate_active_interfaces_atomic(sc->hw,
++						   ath9k_sta_vif_iter, sc);
++	}
+ }
+ 
+ static int ath9k_add_interface(struct ieee80211_hw *hw,
diff --git a/linux-next-cherry-picks/0154-ath9k-Fix-race-in-reset-work-usage.patch b/linux-next-cherry-picks/0154-ath9k-Fix-race-in-reset-work-usage.patch
new file mode 100644
index 0000000..4a82e86
--- /dev/null
+++ b/linux-next-cherry-picks/0154-ath9k-Fix-race-in-reset-work-usage.patch
@@ -0,0 +1,256 @@
+From 124b979baeb2d7a0593be8d392f43725578478c1 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Tue, 17 Jul 2012 17:16:42 +0530
+Subject: [PATCH] ath9k: Fix race in reset-work usage
+
+Using work_pending() to defer certain operations when
+a HW-reset work has been queued is racy since the check
+would return false when the work item is actually in
+execution. Use SC_OP_HW_RESET instead to fix this race.
+Also, unify the reset debug statistics maintenance.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h  |  1 +
+ drivers/net/wireless/ath/ath9k/beacon.c |  5 +++--
+ drivers/net/wireless/ath/ath9k/debug.h  | 24 +++++++++++++-----------
+ drivers/net/wireless/ath/ath9k/link.c   | 13 ++++++-------
+ drivers/net/wireless/ath/ath9k/main.c   | 17 +++++++++++------
+ drivers/net/wireless/ath/ath9k/mci.c    |  2 +-
+ drivers/net/wireless/ath/ath9k/xmit.c   | 13 ++++++-------
+ 7 files changed, 41 insertions(+), 34 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -449,6 +449,7 @@ void ath_stop_ani(struct ath_softc *sc);
+ void ath_check_ani(struct ath_softc *sc);
+ int ath_update_survey_stats(struct ath_softc *sc);
+ void ath_update_survey_nf(struct ath_softc *sc, int channel);
++void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
+ 
+ /**********/
+ /* BTCOEX */
+--- a/drivers/net/wireless/ath/ath9k/beacon.c
++++ b/drivers/net/wireless/ath/ath9k/beacon.c
+@@ -317,11 +317,12 @@ void ath9k_beacon_tasklet(unsigned long
+ 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
+ 	int slot;
+ 
+-	if (work_pending(&sc->hw_reset_work)) {
++	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags)) {
+ 		ath_dbg(common, RESET,
+ 			"reset work is pending, skip beaconing now\n");
+ 		return;
+ 	}
++
+ 	/*
+ 	 * Check if the previous beacon has gone out.  If
+ 	 * not don't try to post another, skip this period
+@@ -345,7 +346,7 @@ void ath9k_beacon_tasklet(unsigned long
+ 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
+ 			ath_dbg(common, BSTUCK, "beacon is officially stuck\n");
+ 			sc->beacon.bmisscnt = 0;
+-			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
++			ath9k_queue_reset(sc, RESET_TYPE_BEACON_STUCK);
+ 		}
+ 
+ 		return;
+--- a/drivers/net/wireless/ath/ath9k/debug.h
++++ b/drivers/net/wireless/ath/ath9k/debug.h
+@@ -32,6 +32,19 @@ struct ath_buf;
+ #define RESET_STAT_INC(sc, type) do { } while (0)
+ #endif
+ 
++enum ath_reset_type {
++	RESET_TYPE_BB_HANG,
++	RESET_TYPE_BB_WATCHDOG,
++	RESET_TYPE_FATAL_INT,
++	RESET_TYPE_TX_ERROR,
++	RESET_TYPE_TX_HANG,
++	RESET_TYPE_PLL_HANG,
++	RESET_TYPE_MAC_HANG,
++	RESET_TYPE_BEACON_STUCK,
++	RESET_TYPE_MCI,
++	__RESET_TYPE_MAX
++};
++
+ #ifdef CONFIG_ATH9K_DEBUGFS
+ 
+ /**
+@@ -209,17 +222,6 @@ struct ath_rx_stats {
+ 	u32 rx_frags;
+ };
+ 
+-enum ath_reset_type {
+-	RESET_TYPE_BB_HANG,
+-	RESET_TYPE_BB_WATCHDOG,
+-	RESET_TYPE_FATAL_INT,
+-	RESET_TYPE_TX_ERROR,
+-	RESET_TYPE_TX_HANG,
+-	RESET_TYPE_PLL_HANG,
+-	RESET_TYPE_MAC_HANG,
+-	__RESET_TYPE_MAX
+-};
+-
+ struct ath_stats {
+ 	struct ath_interrupt_stats istats;
+ 	struct ath_tx_stats txstats[ATH9K_NUM_TX_QUEUES];
+--- a/drivers/net/wireless/ath/ath9k/link.c
++++ b/drivers/net/wireless/ath/ath9k/link.c
+@@ -50,8 +50,7 @@ void ath_tx_complete_poll_work(struct wo
+ 	if (needreset) {
+ 		ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
+ 			"tx hung, resetting the chip\n");
+-		RESET_STAT_INC(sc, RESET_TYPE_TX_HANG);
+-		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
++		ath9k_queue_reset(sc, RESET_TYPE_TX_HANG);
+ 		return;
+ 	}
+ 
+@@ -69,6 +68,7 @@ void ath_hw_check(struct work_struct *wo
+ 	unsigned long flags;
+ 	int busy;
+ 	u8 is_alive, nbeacon = 1;
++	enum ath_reset_type type;
+ 
+ 	ath9k_ps_wakeup(sc);
+ 	is_alive = ath9k_hw_check_alive(sc->sc_ah);
+@@ -78,7 +78,7 @@ void ath_hw_check(struct work_struct *wo
+ 	else if (!is_alive && AR_SREV_9300(sc->sc_ah)) {
+ 		ath_dbg(common, RESET,
+ 			"DCU stuck is detected. Schedule chip reset\n");
+-		RESET_STAT_INC(sc, RESET_TYPE_MAC_HANG);
++		type = RESET_TYPE_MAC_HANG;
+ 		goto sched_reset;
+ 	}
+ 
+@@ -90,7 +90,7 @@ void ath_hw_check(struct work_struct *wo
+ 		busy, sc->hw_busy_count + 1);
+ 	if (busy >= 99) {
+ 		if (++sc->hw_busy_count >= 3) {
+-			RESET_STAT_INC(sc, RESET_TYPE_BB_HANG);
++			type = RESET_TYPE_BB_HANG;
+ 			goto sched_reset;
+ 		}
+ 	} else if (busy >= 0) {
+@@ -102,7 +102,7 @@ void ath_hw_check(struct work_struct *wo
+ 	goto out;
+ 
+ sched_reset:
+-	ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
++	ath9k_queue_reset(sc, type);
+ out:
+ 	ath9k_ps_restore(sc);
+ }
+@@ -119,8 +119,7 @@ static bool ath_hw_pll_rx_hang_check(str
+ 		count++;
+ 		if (count == 3) {
+ 			ath_dbg(common, RESET, "PLL WAR, resetting the chip\n");
+-			RESET_STAT_INC(sc, RESET_TYPE_PLL_HANG);
+-			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
++			ath9k_queue_reset(sc, RESET_TYPE_PLL_HANG);
+ 			count = 0;
+ 			return true;
+ 		}
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -362,6 +362,7 @@ void ath9k_tasklet(unsigned long data)
+ 	struct ath_softc *sc = (struct ath_softc *)data;
+ 	struct ath_hw *ah = sc->sc_ah;
+ 	struct ath_common *common = ath9k_hw_common(ah);
++	enum ath_reset_type type;
+ 	unsigned long flags;
+ 	u32 status = sc->intrstatus;
+ 	u32 rxmask;
+@@ -371,18 +372,13 @@ void ath9k_tasklet(unsigned long data)
+ 
+ 	if ((status & ATH9K_INT_FATAL) ||
+ 	    (status & ATH9K_INT_BB_WATCHDOG)) {
+-#ifdef CONFIG_ATH9K_DEBUGFS
+-		enum ath_reset_type type;
+ 
+ 		if (status & ATH9K_INT_FATAL)
+ 			type = RESET_TYPE_FATAL_INT;
+ 		else
+ 			type = RESET_TYPE_BB_WATCHDOG;
+ 
+-		RESET_STAT_INC(sc, type);
+-#endif
+-		set_bit(SC_OP_HW_RESET, &sc->sc_flags);
+-		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
++		ath9k_queue_reset(sc, type);
+ 		goto out;
+ 	}
+ 
+@@ -572,6 +568,15 @@ static int ath_reset(struct ath_softc *s
+ 	return r;
+ }
+ 
++void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type)
++{
++#ifdef CONFIG_ATH9K_DEBUGFS
++	RESET_STAT_INC(sc, type);
++#endif
++	set_bit(SC_OP_HW_RESET, &sc->sc_flags);
++	ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
++}
++
+ void ath_reset_work(struct work_struct *work)
+ {
+ 	struct ath_softc *sc = container_of(work, struct ath_softc, hw_reset_work);
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -202,7 +202,7 @@ static void ath_mci_cal_msg(struct ath_s
+ 	case MCI_GPM_BT_CAL_REQ:
+ 		if (mci_hw->bt_state == MCI_BT_AWAKE) {
+ 			ar9003_mci_state(ah, MCI_STATE_SET_BT_CAL_START);
+-			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
++			ath9k_queue_reset(sc, RESET_TYPE_MCI);
+ 		}
+ 		ath_dbg(common, MCI, "MCI State : %d\n", mci_hw->bt_state);
+ 		break;
+--- a/drivers/net/wireless/ath/ath9k/xmit.c
++++ b/drivers/net/wireless/ath/ath9k/xmit.c
+@@ -614,10 +614,8 @@ static void ath_tx_complete_aggr(struct
+ 
+ 	rcu_read_unlock();
+ 
+-	if (needreset) {
+-		RESET_STAT_INC(sc, RESET_TYPE_TX_ERROR);
+-		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
+-	}
++	if (needreset)
++		ath9k_queue_reset(sc, RESET_TYPE_TX_ERROR);
+ }
+ 
+ static bool ath_lookup_legacy(struct ath_buf *bf)
+@@ -1576,7 +1574,8 @@ void ath_txq_schedule(struct ath_softc *
+ 	struct ath_atx_ac *ac, *ac_tmp, *last_ac;
+ 	struct ath_atx_tid *tid, *last_tid;
+ 
+-	if (work_pending(&sc->hw_reset_work) || list_empty(&txq->axq_acq) ||
++	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags) ||
++	    list_empty(&txq->axq_acq) ||
+ 	    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
+ 		return;
+ 
+@@ -2181,7 +2180,7 @@ static void ath_tx_processq(struct ath_s
+ 
+ 	ath_txq_lock(sc, txq);
+ 	for (;;) {
+-		if (work_pending(&sc->hw_reset_work))
++		if (test_bit(SC_OP_HW_RESET, &sc->sc_flags))
+ 			break;
+ 
+ 		if (list_empty(&txq->axq_q)) {
+@@ -2264,7 +2263,7 @@ void ath_tx_edma_tasklet(struct ath_soft
+ 	int status;
+ 
+ 	for (;;) {
+-		if (work_pending(&sc->hw_reset_work))
++		if (test_bit(SC_OP_HW_RESET, &sc->sc_flags))
+ 			break;
+ 
+ 		status = ath9k_hw_txprocdesc(ah, NULL, (void *)&ts);
-- 
1.7.11.4

