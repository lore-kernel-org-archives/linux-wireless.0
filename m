Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50030 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2KFKbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 05:31:47 -0500
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH 1/2] compat-drivers: Move next-pending patches to cherry-picks
Date: Tue, 6 Nov 2012 16:01:33 +0530
Message-ID: <1352197894-4352-2-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121106_113210_983898_B2F5E29B)
In-Reply-To: <1352197894-4352-1-git-send-email-bkamatch@qca.qualcomm.com>
References: <1352197894-4352-1-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All of the pending patches have been merged in linux-next,
move them to the linux-next-cherry-picks.

Also add new patches to cherry-picks.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 ...5-ath9k-fix-ASPM-initialization-on-resume.patch |   40 +++
 ...-ath9k-improve-suspend-resume-reliability.patch |  117 ++++++++
 .../0088-cfg80211-fix-antenna-gain-handling.patch  |   39 +++
 ...k-Use-a-helper-routine-for-MCI-FTP-tuning.patch |   72 +++++
 .../0090-ath9k-Fix-BT_OP_SCAN-usage.patch          |   95 ++++++
 ...091-ath9k-perform-ANI-cycle-in-idle-state.patch |  107 +++++++
 ...tale-pointers-potentially-causing-access-.patch |   43 +++
 .../0094-ath9k-Send-WLAN-channel-info-to-BT.patch  |  147 +++++++++
 ...oncurrent-WLAN-and-BT-tx-support-for-MCI-.patch |  264 +++++++++++++++++
 .../0096-ath9k-fill-channel-mode-in-caldata.patch  |   44 +++
 ...djust-WLAN-and-BT-concurrent-transmission.patch |  313 ++++++++++++++++++++
 ...00-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch |   42 +++
 ...1-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch |   34 +++
 ...ppropriate-bit-for-AR9565-in-btc-control-.patch |   39 +++
 ...off-RXIQ-calibration-while-re-calibrating.patch |   54 ++++
 ...sable-MCI-stat-counter-by-default-for-AR9.patch |   42 +++
 ...0105-ath9k_hw-Fix-frequent-BT-rx-recovery.patch |   76 +++++
 ...-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch |   34 +++
 ...nfigure-new-switch-table-for-AR9565-BTCOE.patch |   57 ++++
 ...th9k_hw-Set-default-MCI-config-for-AR9565.patch |   27 ++
 ...ust-duty-cycle-for-FTP-profile-for-AR9565.patch |   27 ++
 ...-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch |   52 ++++
 ...111-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch |   63 ++++
 ...9k_hw-Enable-hw-PLL-power-save-for-AR9565.patch |   49 +++
 ...9k_hw-Fix-concurrent-tx-on-lower-tx-power.patch |   51 ++++
 ...9k_hw-validate-MCI-stuck-after-RTC-wakeup.patch |   38 +++
 .../0118-ath9k-Dump-BTCOEX-tuning-parameters.patch |  148 +++++++++
 ...for-TID-only-in-BlockAcks-while-checking-.patch |   65 ++++
 ...01-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch |   34 ---
 ...2-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch |   28 --
 ...ppropriate-bit-for-AR9565-in-btc-control-.patch |   33 --
 ...off-RXIQ-calibration-while-re-calibrating.patch |   46 ---
 ...sable-MCI-stat-counter-by-default-for-AR9.patch |   34 ---
 ...0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch |   66 ----
 ...-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch |   28 --
 ...nfigure-new-switch-table-for-AR9565-BTCOE.patch |   47 ---
 ...th9k_hw-Set-default-MCI-config-for-AR9565.patch |   21 --
 ...ust-duty-cycle-for-FTP-profile-for-AR9565.patch |   21 --
 ...-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch |   44 ---
 ...012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch |   63 ----
 40 files changed, 2179 insertions(+), 465 deletions(-)
 create mode 100644 linux-next-cherry-picks/0085-ath9k-fix-ASPM-initialization-on-resume.patch
 create mode 100644 linux-next-cherry-picks/0086-ath9k-improve-suspend-resume-reliability.patch
 create mode 100644 linux-next-cherry-picks/0088-cfg80211-fix-antenna-gain-handling.patch
 create mode 100644 linux-next-cherry-picks/0089-ath9k-Use-a-helper-routine-for-MCI-FTP-tuning.patch
 create mode 100644 linux-next-cherry-picks/0090-ath9k-Fix-BT_OP_SCAN-usage.patch
 create mode 100644 linux-next-cherry-picks/0091-ath9k-perform-ANI-cycle-in-idle-state.patch
 create mode 100644 linux-next-cherry-picks/0093-ath9k-fix-stale-pointers-potentially-causing-access-.patch
 create mode 100644 linux-next-cherry-picks/0094-ath9k-Send-WLAN-channel-info-to-BT.patch
 create mode 100644 linux-next-cherry-picks/0095-ath9k-Add-concurrent-WLAN-and-BT-tx-support-for-MCI-.patch
 create mode 100644 linux-next-cherry-picks/0096-ath9k-fill-channel-mode-in-caldata.patch
 create mode 100644 linux-next-cherry-picks/0097-ath9k-adjust-WLAN-and-BT-concurrent-transmission.patch
 create mode 100644 linux-next-cherry-picks/0100-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0101-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch
 create mode 100644 linux-next-cherry-picks/0102-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch
 create mode 100644 linux-next-cherry-picks/0103-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch
 create mode 100644 linux-next-cherry-picks/0104-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch
 create mode 100644 linux-next-cherry-picks/0105-ath9k_hw-Fix-frequent-BT-rx-recovery.patch
 create mode 100644 linux-next-cherry-picks/0106-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0107-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch
 create mode 100644 linux-next-cherry-picks/0108-ath9k_hw-Set-default-MCI-config-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0109-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0110-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch
 create mode 100644 linux-next-cherry-picks/0111-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch
 create mode 100644 linux-next-cherry-picks/0115-ath9k_hw-Enable-hw-PLL-power-save-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0116-ath9k_hw-Fix-concurrent-tx-on-lower-tx-power.patch
 create mode 100644 linux-next-cherry-picks/0117-ath9k_hw-validate-MCI-stuck-after-RTC-wakeup.patch
 create mode 100644 linux-next-cherry-picks/0118-ath9k-Dump-BTCOEX-tuning-parameters.patch
 create mode 100644 linux-next-cherry-picks/0119-ath9k-Test-for-TID-only-in-BlockAcks-while-checking-.patch
 delete mode 100644 linux-next-pending/0001-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch
 delete mode 100644 linux-next-pending/0002-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch
 delete mode 100644 linux-next-pending/0003-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch
 delete mode 100644 linux-next-pending/0004-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch
 delete mode 100644 linux-next-pending/0005-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch
 delete mode 100644 linux-next-pending/0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch
 delete mode 100644 linux-next-pending/0007-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch
 delete mode 100644 linux-next-pending/0008-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch
 delete mode 100644 linux-next-pending/0009-ath9k_hw-Set-default-MCI-config-for-AR9565.patch
 delete mode 100644 linux-next-pending/0010-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch
 delete mode 100644 linux-next-pending/0011-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch
 delete mode 100644 linux-next-pending/0012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch

diff --git a/linux-next-cherry-picks/0085-ath9k-fix-ASPM-initialization-on-resume.patch b/linux-next-cherry-picks/0085-ath9k-fix-ASPM-initialization-on-resume.patch
new file mode 100644
index 0000000..4bcad79
--- /dev/null
+++ b/linux-next-cherry-picks/0085-ath9k-fix-ASPM-initialization-on-resume.patch
@@ -0,0 +1,40 @@
+From 93170516a4d64319ffcc43bc9dd61f12775bd297 Mon Sep 17 00:00:00 2001
+From: Felix Fietkau <nbd@openwrt.org>
+Date: Wed, 3 Oct 2012 21:07:50 +0200
+Subject: [PATCH] ath9k: fix ASPM initialization on resume
+
+ath_pci_aspm_init is only called on card init, so PCI registers get reset
+after a suspend/resume cycle.
+
+Signed-off-by: Felix Fietkau <nbd@openwrt.org>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/pci.c |    5 +++++
+ 1 files changed, 5 insertions(+), 0 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
+index 0e630a9..270abf7 100644
+--- a/drivers/net/wireless/ath/ath9k/pci.c
++++ b/drivers/net/wireless/ath/ath9k/pci.c
+@@ -324,6 +324,9 @@ static int ath_pci_suspend(struct device *device)
+ static int ath_pci_resume(struct device *device)
+ {
+ 	struct pci_dev *pdev = to_pci_dev(device);
++	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
++	struct ath_softc *sc = hw->priv;
++	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+ 	u32 val;
+ 
+ 	/*
+@@ -335,6 +338,8 @@ static int ath_pci_resume(struct device *device)
+ 	if ((val & 0x0000ff00) != 0)
+ 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
+ 
++	ath_pci_aspm_init(common);
++
+ 	return 0;
+ }
+ 
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0086-ath9k-improve-suspend-resume-reliability.patch b/linux-next-cherry-picks/0086-ath9k-improve-suspend-resume-reliability.patch
new file mode 100644
index 0000000..c755abd
--- /dev/null
+++ b/linux-next-cherry-picks/0086-ath9k-improve-suspend-resume-reliability.patch
@@ -0,0 +1,117 @@
+From ceb26a6013b962b82f644189ea29d802490fc8fc Mon Sep 17 00:00:00 2001
+From: Felix Fietkau <nbd@openwrt.org>
+Date: Wed, 3 Oct 2012 21:07:51 +0200
+Subject: [PATCH] ath9k: improve suspend/resume reliability
+
+Ensure that drv_start() always returns true, as a failing hw start usually
+eventually leads to crashes when there's still a station entry present.
+Call a power-on reset after a resume and after a hw reset failure to bring
+the hardware back to life again.
+
+Signed-off-by: Felix Fietkau <nbd@openwrt.org>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/hw.c   |    5 +++++
+ drivers/net/wireless/ath/ath9k/hw.h   |    1 +
+ drivers/net/wireless/ath/ath9k/main.c |   13 ++++---------
+ drivers/net/wireless/ath/ath9k/pci.c  |    4 +++-
+ 4 files changed, 13 insertions(+), 10 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
+index f9a6ec5..8e1559a 100644
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -1450,9 +1450,14 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
+ 	REG_WRITE(ah, AR_RTC_FORCE_WAKE,
+ 		  AR_RTC_FORCE_WAKE_EN | AR_RTC_FORCE_WAKE_ON_INT);
+ 
++	if (!ah->reset_power_on)
++		type = ATH9K_RESET_POWER_ON;
++
+ 	switch (type) {
+ 	case ATH9K_RESET_POWER_ON:
+ 		ret = ath9k_hw_set_reset_power_on(ah);
++		if (!ret)
++			ah->reset_power_on = true;
+ 		break;
+ 	case ATH9K_RESET_WARM:
+ 	case ATH9K_RESET_COLD:
+diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
+index 566a4ce..dbc1b7a 100644
+--- a/drivers/net/wireless/ath/ath9k/hw.h
++++ b/drivers/net/wireless/ath/ath9k/hw.h
+@@ -741,6 +741,7 @@ struct ath_hw {
+ 	u32 rfkill_polarity;
+ 	u32 ah_flags;
+ 
++	bool reset_power_on;
+ 	bool htc_reset_init;
+ 
+ 	enum nl80211_iftype opmode;
+diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
+index 31ab82e..e2fe713 100644
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -639,8 +639,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
+ 		ath_err(common,
+ 			"Unable to reset hardware; reset status %d (freq %u MHz)\n",
+ 			r, curchan->center_freq);
+-		spin_unlock_bh(&sc->sc_pcu_lock);
+-		goto mutex_unlock;
++		ah->reset_power_on = false;
+ 	}
+ 
+ 	/* Setup our intr mask. */
+@@ -665,11 +664,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
+ 	clear_bit(SC_OP_INVALID, &sc->sc_flags);
+ 	sc->sc_ah->is_monitoring = false;
+ 
+-	if (!ath_complete_reset(sc, false)) {
+-		r = -EIO;
+-		spin_unlock_bh(&sc->sc_pcu_lock);
+-		goto mutex_unlock;
+-	}
++	if (!ath_complete_reset(sc, false))
++		ah->reset_power_on = false;
+ 
+ 	if (ah->led_pin >= 0) {
+ 		ath9k_hw_cfg_output(ah, ah->led_pin,
+@@ -688,12 +684,11 @@ static int ath9k_start(struct ieee80211_hw *hw)
+ 	if (ah->caps.pcie_lcr_extsync_en && common->bus_ops->extn_synch_en)
+ 		common->bus_ops->extn_synch_en(common);
+ 
+-mutex_unlock:
+ 	mutex_unlock(&sc->mutex);
+ 
+ 	ath9k_ps_restore(sc);
+ 
+-	return r;
++	return 0;
+ }
+ 
+ static void ath9k_tx(struct ieee80211_hw *hw,
+diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
+index 270abf7..f088f4b 100644
+--- a/drivers/net/wireless/ath/ath9k/pci.c
++++ b/drivers/net/wireless/ath/ath9k/pci.c
+@@ -326,7 +326,8 @@ static int ath_pci_resume(struct device *device)
+ 	struct pci_dev *pdev = to_pci_dev(device);
+ 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+ 	struct ath_softc *sc = hw->priv;
+-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
++	struct ath_hw *ah = sc->sc_ah;
++	struct ath_common *common = ath9k_hw_common(ah);
+ 	u32 val;
+ 
+ 	/*
+@@ -339,6 +340,7 @@ static int ath_pci_resume(struct device *device)
+ 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
+ 
+ 	ath_pci_aspm_init(common);
++	ah->reset_power_on = false;
+ 
+ 	return 0;
+ }
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0088-cfg80211-fix-antenna-gain-handling.patch b/linux-next-cherry-picks/0088-cfg80211-fix-antenna-gain-handling.patch
new file mode 100644
index 0000000..b5ee43d
--- /dev/null
+++ b/linux-next-cherry-picks/0088-cfg80211-fix-antenna-gain-handling.patch
@@ -0,0 +1,39 @@
+From c4a9fafc77a5318f5ed26c509bbcddf03e18c201 Mon Sep 17 00:00:00 2001
+From: Felix Fietkau <nbd@openwrt.org>
+Date: Wed, 17 Oct 2012 13:56:19 +0200
+Subject: [PATCH] cfg80211: fix antenna gain handling
+
+No driver initializes chan->max_antenna_gain to something sensible, and
+the only place where it is being used right now is inside ath9k. This
+leads to ath9k potentially using less tx power than it can use, which can
+decrease performance/range in some rare cases.
+
+Rather than going through every single driver, this patch initializes
+chan->orig_mag in wiphy_register(), ignoring whatever value the driver
+left in there. If a driver for some reason wishes to limit it independent
+from regulatory rulesets, it can do so internally.
+
+Signed-off-by: Felix Fietkau <nbd@openwrt.org>
+Cc: stable@vger.kernel.org
+Signed-off-by: Johannes Berg <johannes.berg@intel.com>
+---
+ net/wireless/core.c |    3 +--
+ 1 files changed, 1 insertions(+), 2 deletions(-)
+
+diff --git a/net/wireless/core.c b/net/wireless/core.c
+index 443d4d7..3f72530 100644
+--- a/net/wireless/core.c
++++ b/net/wireless/core.c
+@@ -526,8 +526,7 @@ int wiphy_register(struct wiphy *wiphy)
+ 		for (i = 0; i < sband->n_channels; i++) {
+ 			sband->channels[i].orig_flags =
+ 				sband->channels[i].flags;
+-			sband->channels[i].orig_mag =
+-				sband->channels[i].max_antenna_gain;
++			sband->channels[i].orig_mag = INT_MAX;
+ 			sband->channels[i].orig_mpwr =
+ 				sband->channels[i].max_power;
+ 			sband->channels[i].band = band;
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0089-ath9k-Use-a-helper-routine-for-MCI-FTP-tuning.patch b/linux-next-cherry-picks/0089-ath9k-Use-a-helper-routine-for-MCI-FTP-tuning.patch
new file mode 100644
index 0000000..7262bc7
--- /dev/null
+++ b/linux-next-cherry-picks/0089-ath9k-Use-a-helper-routine-for-MCI-FTP-tuning.patch
@@ -0,0 +1,72 @@
+From 78b1775ba03c2edcc8d765dd53a7e171b18e79ac Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
+Date: Sun, 30 Sep 2012 09:03:20 +0530
+Subject: [PATCH] ath9k: Use a helper routine for MCI/FTP tuning
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/gpio.c |   33 +++++++++++++++++++++------------
+ 1 files changed, 21 insertions(+), 12 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
+index d9ed141..334c98d 100644
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -187,6 +187,25 @@ static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
+ 	}
+ }
+ 
++static void ath_mci_ftp_adjust(struct ath_softc *sc)
++{
++	struct ath_btcoex *btcoex = &sc->btcoex;
++	struct ath_mci_profile *mci = &btcoex->mci;
++	struct ath_hw *ah = sc->sc_ah;
++
++	btcoex->bt_wait_time += btcoex->btcoex_period;
++	if (btcoex->bt_wait_time > ATH_BTCOEX_RX_WAIT_TIME) {
++		if (ar9003_mci_state(ah, MCI_STATE_NEED_FTP_STOMP) &&
++		    (mci->num_pan || mci->num_other_acl))
++			ah->btcoex_hw.mci.stomp_ftp =
++				(sc->rx.num_pkts < ATH_BTCOEX_STOMP_FTP_THRESH);
++		else
++			ah->btcoex_hw.mci.stomp_ftp = false;
++		btcoex->bt_wait_time = 0;
++		sc->rx.num_pkts = 0;
++	}
++}
++
+ /*
+  * This is the master bt coex timer which runs for every
+  * 45ms, bt traffic will be given priority during 55% of this
+@@ -197,7 +216,6 @@ static void ath_btcoex_period_timer(unsigned long data)
+ 	struct ath_softc *sc = (struct ath_softc *) data;
+ 	struct ath_hw *ah = sc->sc_ah;
+ 	struct ath_btcoex *btcoex = &sc->btcoex;
+-	struct ath_mci_profile *mci = &btcoex->mci;
+ 	u32 timer_period;
+ 	bool is_btscan;
+ 	unsigned long flags;
+@@ -214,17 +232,8 @@ static void ath_btcoex_period_timer(unsigned long data)
+ 		ath_detect_bt_priority(sc);
+ 	is_btscan = test_bit(BT_OP_SCAN, &btcoex->op_flags);
+ 
+-	btcoex->bt_wait_time += btcoex->btcoex_period;
+-	if (btcoex->bt_wait_time > ATH_BTCOEX_RX_WAIT_TIME) {
+-		if (ar9003_mci_state(ah, MCI_STATE_NEED_FTP_STOMP) &&
+-		    (mci->num_pan || mci->num_other_acl))
+-			ah->btcoex_hw.mci.stomp_ftp =
+-				(sc->rx.num_pkts < ATH_BTCOEX_STOMP_FTP_THRESH);
+-		else
+-			ah->btcoex_hw.mci.stomp_ftp = false;
+-		btcoex->bt_wait_time = 0;
+-		sc->rx.num_pkts = 0;
+-	}
++	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
++		ath_mci_ftp_adjust(sc);
+ 
+ 	spin_lock_bh(&btcoex->btcoex_lock);
+ 
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0090-ath9k-Fix-BT_OP_SCAN-usage.patch b/linux-next-cherry-picks/0090-ath9k-Fix-BT_OP_SCAN-usage.patch
new file mode 100644
index 0000000..42a0afa
--- /dev/null
+++ b/linux-next-cherry-picks/0090-ath9k-Fix-BT_OP_SCAN-usage.patch
@@ -0,0 +1,95 @@
+From 750f32cf0a6e2a4d798e09da4079ede7d1721e54 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
+Date: Sun, 30 Sep 2012 09:03:37 +0530
+Subject: [PATCH] ath9k: Fix BT_OP_SCAN usage
+
+BT_OP_SCAN is applicable only for pre-MCI WLAN/BT combo chips
+and using it for MCI-based cards is incorrect. Fix this by
+cleaning up its usage.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/gpio.c |   27 ++++++++++++++++++---------
+ 1 files changed, 18 insertions(+), 9 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
+index 334c98d..bf4fb7d 100644
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -216,8 +216,8 @@ static void ath_btcoex_period_timer(unsigned long data)
+ 	struct ath_softc *sc = (struct ath_softc *) data;
+ 	struct ath_hw *ah = sc->sc_ah;
+ 	struct ath_btcoex *btcoex = &sc->btcoex;
++	enum ath_stomp_type stomp_type;
+ 	u32 timer_period;
+-	bool is_btscan;
+ 	unsigned long flags;
+ 
+ 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+@@ -228,19 +228,28 @@ static void ath_btcoex_period_timer(unsigned long data)
+ 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+ 
+ 	ath9k_ps_wakeup(sc);
++
+ 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
+ 		ath_detect_bt_priority(sc);
+-	is_btscan = test_bit(BT_OP_SCAN, &btcoex->op_flags);
+ 
+ 	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
+ 		ath_mci_ftp_adjust(sc);
+ 
+ 	spin_lock_bh(&btcoex->btcoex_lock);
+ 
+-	ath9k_hw_btcoex_bt_stomp(ah, is_btscan ? ATH_BTCOEX_STOMP_ALL :
+-			      btcoex->bt_stomp_type);
++	stomp_type = btcoex->bt_stomp_type;
++	timer_period = btcoex->btcoex_no_stomp;
++
++	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI)) {
++		if (test_bit(BT_OP_SCAN, &btcoex->op_flags)) {
++			stomp_type = ATH_BTCOEX_STOMP_ALL;
++			timer_period = btcoex->btscan_no_stomp;
++		}
++	}
+ 
++	ath9k_hw_btcoex_bt_stomp(ah, stomp_type);
+ 	ath9k_hw_btcoex_enable(ah);
++
+ 	spin_unlock_bh(&btcoex->btcoex_lock);
+ 
+ 	/*
+@@ -252,17 +261,16 @@ static void ath_btcoex_period_timer(unsigned long data)
+ 		if (btcoex->hw_timer_enabled)
+ 			ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
+ 
+-		timer_period = is_btscan ? btcoex->btscan_no_stomp :
+-					   btcoex->btcoex_no_stomp;
+ 		ath9k_gen_timer_start(ah, btcoex->no_stomp_timer, timer_period,
+ 				      timer_period * 10);
+ 		btcoex->hw_timer_enabled = true;
+ 	}
+ 
+ 	ath9k_ps_restore(sc);
++
+ skip_hw_wakeup:
+-	timer_period = btcoex->btcoex_period;
+-	mod_timer(&btcoex->period_timer, jiffies + msecs_to_jiffies(timer_period));
++	mod_timer(&btcoex->period_timer,
++		  jiffies + msecs_to_jiffies(btcoex->btcoex_period));
+ }
+ 
+ /*
+@@ -282,7 +290,8 @@ static void ath_btcoex_no_stomp_timer(void *arg)
+ 	spin_lock_bh(&btcoex->btcoex_lock);
+ 
+ 	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW ||
+-	    test_bit(BT_OP_SCAN, &btcoex->op_flags))
++	    (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI) &&
++	     test_bit(BT_OP_SCAN, &btcoex->op_flags)))
+ 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
+ 	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
+ 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_LOW);
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0091-ath9k-perform-ANI-cycle-in-idle-state.patch b/linux-next-cherry-picks/0091-ath9k-perform-ANI-cycle-in-idle-state.patch
new file mode 100644
index 0000000..1240b27
--- /dev/null
+++ b/linux-next-cherry-picks/0091-ath9k-perform-ANI-cycle-in-idle-state.patch
@@ -0,0 +1,107 @@
+From 424749c75daf3611a68a49eca5940ac2b74e4406 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 10 Oct 2012 23:03:02 +0530
+Subject: [PATCH] ath9k: perform ANI cycle in idle state
+
+As of now the ANI cycle is executed only when the chip is awake.
+On idle state case, the station wakes up from network sleep for
+beacon reception. Since most of the time, ANI cycle is not syncing
+with beacon wakeup, ANI cycle is ignored. Approx 5 mins once, the
+calibration is performed. This could affect the connection stability
+when the station is idle for long. Even though the OFDM and CCK phy
+error rates are too high, ANI is unable to tune its immunity level
+as quick enough due to rare execution.
+
+Here the experiment shows that OFDM and CCK levels are at default
+even on higher phy error rate.
+
+listenTime=44 OFDM:3 errs=121977/s CCK:2 errs=440818/s ofdm_turn=1
+
+This change ensures that ANI calibration will be exectued atleast
+once for every 10 seconds. The below result shows improvements and
+immunity levels are adopted quick enough.
+
+listenTime=557 OFDM:4 errs=752/s CCK:4 errs=125/s ofdm_turn=0
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h |    2 ++
+ drivers/net/wireless/ath/ath9k/hw.h    |    1 +
+ drivers/net/wireless/ath/ath9k/link.c  |   12 +++++++++++-
+ drivers/net/wireless/ath/ath9k/main.c  |    3 ++-
+ 4 files changed, 16 insertions(+), 2 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
+index dfe6a47..77c2c16 100644
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -437,6 +437,7 @@ void ath9k_set_beacon(struct ath_softc *sc);
+ #define ATH_LONG_CALINTERVAL_INT  1000    /* 1000 ms */
+ #define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
+ #define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
++#define ATH_ANI_MAX_SKIP_COUNT  10
+ 
+ #define ATH_PAPRD_TIMEOUT	100 /* msecs */
+ #define ATH_PLL_WORK_INTERVAL   100
+@@ -642,6 +643,7 @@ enum sc_op_flags {
+ #define PS_WAIT_FOR_PSPOLL_DATA   BIT(2)
+ #define PS_WAIT_FOR_TX_ACK        BIT(3)
+ #define PS_BEACON_SYNC            BIT(4)
++#define PS_WAIT_FOR_ANI           BIT(5)
+ 
+ struct ath_rate_table;
+ 
+diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
+index dbc1b7a..1d4f5f1 100644
+--- a/drivers/net/wireless/ath/ath9k/hw.h
++++ b/drivers/net/wireless/ath/ath9k/hw.h
+@@ -834,6 +834,7 @@ struct ath_hw {
+ 	int coarse_low[5];
+ 	int firpwr[5];
+ 	enum ath9k_ani_cmd ani_function;
++	u32 ani_skip_count;
+ 
+ #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+ 	struct ath_btcoex_hw btcoex_hw;
+diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
+index 7b88b9c..223b969 100644
+--- a/drivers/net/wireless/ath/ath9k/link.c
++++ b/drivers/net/wireless/ath/ath9k/link.c
+@@ -350,8 +350,18 @@ void ath_ani_calibrate(unsigned long data)
+ 		ATH_AP_SHORT_CALINTERVAL : ATH_STA_SHORT_CALINTERVAL;
+ 
+ 	/* Only calibrate if awake */
+-	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE)
++	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE) {
++		if (++ah->ani_skip_count >= ATH_ANI_MAX_SKIP_COUNT) {
++			spin_lock_irqsave(&sc->sc_pm_lock, flags);
++			sc->ps_flags |= PS_WAIT_FOR_ANI;
++			spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
++		}
+ 		goto set_timer;
++	}
++	ah->ani_skip_count = 0;
++	spin_lock_irqsave(&sc->sc_pm_lock, flags);
++	sc->ps_flags &= ~PS_WAIT_FOR_ANI;
++	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+ 
+ 	ath9k_ps_wakeup(sc);
+ 
+diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
+index dd45edf..2da62be 100644
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -131,7 +131,8 @@ void ath9k_ps_restore(struct ath_softc *sc)
+ 		   !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
+ 				     PS_WAIT_FOR_CAB |
+ 				     PS_WAIT_FOR_PSPOLL_DATA |
+-				     PS_WAIT_FOR_TX_ACK))) {
++				     PS_WAIT_FOR_TX_ACK |
++				     PS_WAIT_FOR_ANI))) {
+ 		mode = ATH9K_PM_NETWORK_SLEEP;
+ 		if (ath9k_hw_btcoex_is_enabled(sc->sc_ah))
+ 			ath9k_btcoex_stop_gen_timer(sc);
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0093-ath9k-fix-stale-pointers-potentially-causing-access-.patch b/linux-next-cherry-picks/0093-ath9k-fix-stale-pointers-potentially-causing-access-.patch
new file mode 100644
index 0000000..e3a77ab
--- /dev/null
+++ b/linux-next-cherry-picks/0093-ath9k-fix-stale-pointers-potentially-causing-access-.patch
@@ -0,0 +1,43 @@
+From 8c6e30936a7893a85f6222084f0f26aceb81137a Mon Sep 17 00:00:00 2001
+From: Felix Fietkau <nbd@openwrt.org>
+Date: Fri, 26 Oct 2012 00:31:11 +0200
+Subject: [PATCH] ath9k: fix stale pointers potentially causing access to free'd skbs
+
+bf->bf_next is only while buffers are chained as part of an A-MPDU
+in the tx queue. When a tid queue is flushed (e.g. on tearing down
+an aggregation session), frames can be enqueued again as normal
+transmission, without bf_next being cleared. This can lead to the
+old pointer being dereferenced again later.
+
+This patch might fix crashes and "Failed to stop TX DMA!" messages.
+
+Signed-off-by: Felix Fietkau <nbd@openwrt.org>
+Cc: stable@vger.kernel.org
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/xmit.c |    2 ++
+ 1 files changed, 2 insertions(+), 0 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
+index 378bd70..1ffca75 100644
+--- a/drivers/net/wireless/ath/ath9k/xmit.c
++++ b/drivers/net/wireless/ath/ath9k/xmit.c
+@@ -312,6 +312,7 @@ static struct ath_buf *ath_tx_get_buffer(struct ath_softc *sc)
+ 	}
+ 
+ 	bf = list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
++	bf->bf_next = NULL;
+ 	list_del(&bf->list);
+ 
+ 	spin_unlock_bh(&sc->tx.txbuflock);
+@@ -1774,6 +1775,7 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
+ 	list_add_tail(&bf->list, &bf_head);
+ 	bf->bf_state.bf_type = 0;
+ 
++	bf->bf_next = NULL;
+ 	bf->bf_lastbf = bf;
+ 	ath_tx_fill_desc(sc, bf, txq, fi->framelen);
+ 	ath_tx_txqaddbuf(sc, txq, &bf_head, false);
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0094-ath9k-Send-WLAN-channel-info-to-BT.patch b/linux-next-cherry-picks/0094-ath9k-Send-WLAN-channel-info-to-BT.patch
new file mode 100644
index 0000000..c80a290
--- /dev/null
+++ b/linux-next-cherry-picks/0094-ath9k-Send-WLAN-channel-info-to-BT.patch
@@ -0,0 +1,147 @@
+From 50072ebca3d0aec8c5b8543e767d45c6626523af Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Fri, 12 Oct 2012 14:07:22 +0530
+Subject: [PATCH] ath9k: Send WLAN channel info to BT
+
+WLAN updates channel bitmap when associated and disassociated. Channel
+bitmap will reflect whare are the channels used or affected by WLAN and
+BT should avoid using those. Not doing so, could affect BT traffic
+as both WLAN and BT is operating on same channel.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/main.c |    5 +++
+ drivers/net/wireless/ath/ath9k/mci.c  |   50 +++++++++++++++++++++++++++++++++
+ drivers/net/wireless/ath/ath9k/mci.h  |   23 +++++++++++++++
+ 3 files changed, 78 insertions(+), 0 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
+index 2da62be..515e184 100644
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -1450,6 +1450,9 @@ static void ath9k_set_assoc_state(struct ath_softc *sc,
+ 	sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
+ 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+ 
++	if (ath9k_hw_mci_is_enabled(sc->sc_ah))
++		ath9k_mci_update_wlan_channels(sc, false);
++
+ 	ath_dbg(common, CONFIG,
+ 		"Primary Station interface: %pM, BSSID: %pM\n",
+ 		vif->addr, common->curbssid);
+@@ -1506,6 +1509,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
+ 			memset(common->curbssid, 0, ETH_ALEN);
+ 			common->curaid = 0;
+ 			ath9k_hw_write_associd(sc->sc_ah);
++			if (ath9k_hw_mci_is_enabled(sc->sc_ah))
++				ath9k_mci_update_wlan_channels(sc, true);
+ 		}
+ 	}
+ 
+diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
+index ec2d7c8..1733a5a 100644
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -600,3 +600,53 @@ void ath_mci_enable(struct ath_softc *sc)
+ 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
+ 		sc->sc_ah->imask |= ATH9K_INT_MCI;
+ }
++
++void ath9k_mci_update_wlan_channels(struct ath_softc *sc, bool allow_all)
++{
++	struct ath_hw *ah = sc->sc_ah;
++	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
++	struct ath9k_channel *chan = ah->curchan;
++	u32 channelmap[] = {0x00000000, 0xffff0000, 0xffffffff, 0x7fffffff};
++	int i;
++	s16 chan_start, chan_end;
++	u16 wlan_chan;
++
++	if (!chan || !IS_CHAN_2GHZ(chan))
++		return;
++
++	if (allow_all)
++		goto send_wlan_chan;
++
++	wlan_chan = chan->channel - 2402;
++
++	chan_start = wlan_chan - 10;
++	chan_end = wlan_chan + 10;
++
++	if (chan->chanmode == CHANNEL_G_HT40PLUS)
++		chan_end += 20;
++	else if (chan->chanmode == CHANNEL_G_HT40MINUS)
++		chan_start -= 20;
++
++	/* adjust side band */
++	chan_start -= 7;
++	chan_end += 7;
++
++	if (chan_start <= 0)
++		chan_start = 0;
++	if (chan_end >= ATH_MCI_NUM_BT_CHANNELS)
++		chan_end = ATH_MCI_NUM_BT_CHANNELS - 1;
++
++	ath_dbg(ath9k_hw_common(ah), MCI,
++		"WLAN current channel %d mask BT channel %d - %d\n",
++		wlan_chan, chan_start, chan_end);
++
++	for (i = chan_start; i < chan_end; i++)
++		MCI_GPM_CLR_CHANNEL_BIT(&channelmap, i);
++
++send_wlan_chan:
++	/* update and send wlan channels info to BT */
++	for (i = 0; i < 4; i++)
++		mci->wlan_channels[i] = channelmap[i];
++	ar9003_mci_send_wlan_channels(ah);
++	ar9003_mci_state(ah, MCI_STATE_SEND_VERSION_QUERY);
++}
+diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
+index fc14eea..a3df314 100644
+--- a/drivers/net/wireless/ath/ath9k/mci.h
++++ b/drivers/net/wireless/ath/ath9k/mci.h
+@@ -32,6 +32,24 @@
+ #define ATH_MCI_MAX_PROFILE		(ATH_MCI_MAX_ACL_PROFILE +\
+ 					 ATH_MCI_MAX_SCO_PROFILE)
+ 
++#define ATH_MCI_NUM_BT_CHANNELS      79
++
++#define MCI_GPM_SET_CHANNEL_BIT(_p_gpm, _bt_chan)			  \
++	do {								  \
++		if (_bt_chan < ATH_MCI_NUM_BT_CHANNELS) {		  \
++			*(((u8 *)(_p_gpm)) + MCI_GPM_COEX_B_CHANNEL_MAP + \
++				(_bt_chan / 8)) |= (1 << (_bt_chan & 7)); \
++		}							  \
++	} while (0)
++
++#define MCI_GPM_CLR_CHANNEL_BIT(_p_gpm, _bt_chan)			  \
++	do {								  \
++		if (_bt_chan < ATH_MCI_NUM_BT_CHANNELS) {		  \
++			*(((u8 *)(_p_gpm)) + MCI_GPM_COEX_B_CHANNEL_MAP + \
++				(_bt_chan / 8)) &= ~(1 << (_bt_chan & 7));\
++		}							  \
++	} while (0)
++
+ #define INC_PROF(_mci, _info) do {		 \
+ 		switch (_info->type) {		 \
+ 		case MCI_GPM_COEX_PROFILE_RFCOMM:\
+@@ -133,10 +151,15 @@ void ath_mci_intr(struct ath_softc *sc);
+ 
+ #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+ void ath_mci_enable(struct ath_softc *sc);
++void ath9k_mci_update_wlan_channels(struct ath_softc *sc, bool allow_all);
+ #else
+ static inline void ath_mci_enable(struct ath_softc *sc)
+ {
+ }
++static inline void ath9k_mci_update_wlan_channels(struct ath_softc *sc,
++						  bool allow_all)
++{
++}
+ #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
+ 
+ #endif /* MCI_H*/
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0095-ath9k-Add-concurrent-WLAN-and-BT-tx-support-for-MCI-.patch b/linux-next-cherry-picks/0095-ath9k-Add-concurrent-WLAN-and-BT-tx-support-for-MCI-.patch
new file mode 100644
index 0000000..3ea4027
--- /dev/null
+++ b/linux-next-cherry-picks/0095-ath9k-Add-concurrent-WLAN-and-BT-tx-support-for-MCI-.patch
@@ -0,0 +1,264 @@
+From db60428b1af11cf216bb0736b24b2cf0c7b54071 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Fri, 12 Oct 2012 14:07:23 +0530
+Subject: [PATCH] ath9k: Add concurrent WLAN and BT tx support for MCI based chips
+
+This feature enables both WLAN and BT can transmit simultaneously
+by setting WLAN and BT to equal priorities. Whenever both are
+transmitting, it might violate regulatory power limits. To avoid
+regulatory violation, WLAN tx power will be adjusted according to BT
+power index based on avaliability of BT scheduling message. If the
+combined power exceeds threshold, BT transmission will be held off.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.h |    1 -
+ drivers/net/wireless/ath/ath9k/btcoex.c     |   60 +++++++++++++++++++-------
+ drivers/net/wireless/ath/ath9k/btcoex.h     |    3 +
+ drivers/net/wireless/ath/ath9k/mci.c        |   60 +++++++++++++++++++++++++++
+ drivers/net/wireless/ath/ath9k/mci.h        |    3 +
+ 5 files changed, 110 insertions(+), 17 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+index 2a2d018..2928234 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+@@ -196,7 +196,6 @@ enum mci_state_type {
+ 	MCI_STATE_SEND_WLAN_COEX_VERSION,
+ 	MCI_STATE_SEND_VERSION_QUERY,
+ 	MCI_STATE_SEND_STATUS_QUERY,
+-	MCI_STATE_SET_CONCUR_TX_PRI,
+ 	MCI_STATE_RECOVER_RX,
+ 	MCI_STATE_NEED_FTP_STOMP,
+ 	MCI_STATE_DEBUG,
+diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
+index 419e9a3..05d9be5 100644
+--- a/drivers/net/wireless/ath/ath9k/btcoex.c
++++ b/drivers/net/wireless/ath/ath9k/btcoex.c
+@@ -218,27 +218,45 @@ void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
+ 				enum ath_stomp_type stomp_type)
+ {
+ 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
++	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
++	u8 txprio_shift[] = { 24, 16, 16, 0 }; /* tx priority weight */
++	bool concur_tx = (mci_hw->concur_tx && btcoex_hw->tx_prio[stomp_type]);
++	const u32 *weight = ar9003_wlan_weights[stomp_type];
++	int i;
+ 
+-	if (AR_SREV_9300_20_OR_LATER(ah)) {
+-		const u32 *weight = ar9003_wlan_weights[stomp_type];
+-		int i;
+-
+-		if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+-			if ((stomp_type == ATH_BTCOEX_STOMP_LOW) &&
+-			    btcoex_hw->mci.stomp_ftp)
+-				stomp_type = ATH_BTCOEX_STOMP_LOW_FTP;
+-			weight = mci_wlan_weights[stomp_type];
+-		}
+-
+-		for (i = 0; i < AR9300_NUM_WLAN_WEIGHTS; i++) {
+-			btcoex_hw->bt_weight[i] = AR9300_BT_WGHT;
+-			btcoex_hw->wlan_weight[i] = weight[i];
+-		}
+-	} else {
++	if (!AR_SREV_9300_20_OR_LATER(ah)) {
+ 		btcoex_hw->bt_coex_weights =
+ 			SM(bt_weight, AR_BTCOEX_BT_WGHT) |
+ 			SM(wlan_weight, AR_BTCOEX_WL_WGHT);
++		return;
++	}
++
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
++		enum ath_stomp_type stype =
++			((stomp_type == ATH_BTCOEX_STOMP_LOW) &&
++			 btcoex_hw->mci.stomp_ftp) ?
++			ATH_BTCOEX_STOMP_LOW_FTP : stomp_type;
++		weight = mci_wlan_weights[stype];
+ 	}
++
++	for (i = 0; i < AR9300_NUM_WLAN_WEIGHTS; i++) {
++		btcoex_hw->bt_weight[i] = AR9300_BT_WGHT;
++		btcoex_hw->wlan_weight[i] = weight[i];
++		if (concur_tx && i) {
++			btcoex_hw->wlan_weight[i] &=
++				~(0xff << txprio_shift[i-1]);
++			btcoex_hw->wlan_weight[i] |=
++				(btcoex_hw->tx_prio[stomp_type] <<
++				 txprio_shift[i-1]);
++		}
++	}
++	/* Last WLAN weight has to be adjusted wrt tx priority */
++	if (concur_tx) {
++		btcoex_hw->wlan_weight[i-1] &= ~(0xff << txprio_shift[i-1]);
++		btcoex_hw->wlan_weight[i-1] |= (btcoex_hw->tx_prio[stomp_type]
++						      << txprio_shift[i-1]);
++	}
++
+ }
+ EXPORT_SYMBOL(ath9k_hw_btcoex_set_weight);
+ 
+@@ -385,3 +403,13 @@ void ath9k_hw_btcoex_bt_stomp(struct ath_hw *ah,
+ 	}
+ }
+ EXPORT_SYMBOL(ath9k_hw_btcoex_bt_stomp);
++
++void ath9k_hw_btcoex_set_concur_txprio(struct ath_hw *ah, u8 *stomp_txprio)
++{
++	struct ath_btcoex_hw *btcoex = &ah->btcoex_hw;
++	int i;
++
++	for (i = 0; i < ATH_BTCOEX_STOMP_MAX; i++)
++		btcoex->tx_prio[i] = stomp_txprio[i];
++}
++EXPORT_SYMBOL(ath9k_hw_btcoex_set_concur_txprio);
+diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
+index 385197a..a260fcb 100644
+--- a/drivers/net/wireless/ath/ath9k/btcoex.h
++++ b/drivers/net/wireless/ath/ath9k/btcoex.h
+@@ -84,6 +84,7 @@ struct ath9k_hw_mci {
+ 	u8 bt_ver_minor;
+ 	u8 bt_state;
+ 	u8 stomp_ftp;
++	bool concur_tx;
+ };
+ 
+ struct ath_btcoex_hw {
+@@ -98,6 +99,7 @@ struct ath_btcoex_hw {
+ 	u32 bt_coex_mode2; 	/* Register setting for AR_BT_COEX_MODE2 */
+ 	u32 bt_weight[AR9300_NUM_BT_WEIGHTS];
+ 	u32 wlan_weight[AR9300_NUM_WLAN_WEIGHTS];
++	u8 tx_prio[ATH_BTCOEX_STOMP_MAX];
+ };
+ 
+ void ath9k_hw_btcoex_init_scheme(struct ath_hw *ah);
+@@ -112,5 +114,6 @@ void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
+ void ath9k_hw_btcoex_disable(struct ath_hw *ah);
+ void ath9k_hw_btcoex_bt_stomp(struct ath_hw *ah,
+ 			      enum ath_stomp_type stomp_type);
++void ath9k_hw_btcoex_set_concur_txprio(struct ath_hw *ah, u8 *stomp_txprio);
+ 
+ #endif
+diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
+index 1733a5a..b37c8af 100644
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -43,6 +43,7 @@ static bool ath_mci_add_profile(struct ath_common *common,
+ 				struct ath_mci_profile_info *info)
+ {
+ 	struct ath_mci_profile_info *entry;
++	u8 voice_priority[] = { 110, 110, 110, 112, 110, 110, 114, 116, 118 };
+ 
+ 	if ((mci->num_sco == ATH_MCI_MAX_SCO_PROFILE) &&
+ 	    (info->type == MCI_GPM_COEX_PROFILE_VOICE))
+@@ -59,6 +60,12 @@ static bool ath_mci_add_profile(struct ath_common *common,
+ 	memcpy(entry, info, 10);
+ 	INC_PROF(mci, info);
+ 	list_add_tail(&entry->list, &mci->info);
++	if (info->type == MCI_GPM_COEX_PROFILE_VOICE) {
++		if (info->voice_type < sizeof(voice_priority))
++			mci->voice_priority = voice_priority[info->voice_type];
++		else
++			mci->voice_priority = 110;
++	}
+ 
+ 	return true;
+ }
+@@ -250,6 +257,57 @@ static void ath9k_mci_work(struct work_struct *work)
+ 	ath_mci_update_scheme(sc);
+ }
+ 
++static void ath_mci_update_stomp_txprio(u8 cur_txprio, u8 *stomp_prio)
++{
++	if (cur_txprio < stomp_prio[ATH_BTCOEX_STOMP_NONE])
++		stomp_prio[ATH_BTCOEX_STOMP_NONE] = cur_txprio;
++
++	if (cur_txprio > stomp_prio[ATH_BTCOEX_STOMP_ALL])
++		stomp_prio[ATH_BTCOEX_STOMP_ALL] = cur_txprio;
++
++	if ((cur_txprio > ATH_MCI_HI_PRIO) &&
++	    (cur_txprio < stomp_prio[ATH_BTCOEX_STOMP_LOW]))
++		stomp_prio[ATH_BTCOEX_STOMP_LOW] = cur_txprio;
++}
++
++static void ath_mci_set_concur_txprio(struct ath_softc *sc)
++{
++	struct ath_btcoex *btcoex = &sc->btcoex;
++	struct ath_mci_profile *mci = &btcoex->mci;
++	u8 stomp_txprio[] = { 0, 0, 0, 0 }; /* all, low, none, low_ftp */
++
++	if (mci->num_mgmt) {
++		stomp_txprio[ATH_BTCOEX_STOMP_ALL] = ATH_MCI_INQUIRY_PRIO;
++		if (!mci->num_pan && !mci->num_other_acl)
++			stomp_txprio[ATH_BTCOEX_STOMP_NONE] =
++				ATH_MCI_INQUIRY_PRIO;
++	} else {
++		u8 prof_prio[] = { 50, 90, 94, 52 };/* RFCOMM, A2DP, HID, PAN */
++
++		stomp_txprio[ATH_BTCOEX_STOMP_LOW] =
++		stomp_txprio[ATH_BTCOEX_STOMP_NONE] = 0xff;
++
++		if (mci->num_sco)
++			ath_mci_update_stomp_txprio(mci->voice_priority,
++						    stomp_txprio);
++		if (mci->num_other_acl)
++			ath_mci_update_stomp_txprio(prof_prio[0], stomp_txprio);
++		if (mci->num_a2dp)
++			ath_mci_update_stomp_txprio(prof_prio[1], stomp_txprio);
++		if (mci->num_hid)
++			ath_mci_update_stomp_txprio(prof_prio[2], stomp_txprio);
++		if (mci->num_pan)
++			ath_mci_update_stomp_txprio(prof_prio[3], stomp_txprio);
++
++		if (stomp_txprio[ATH_BTCOEX_STOMP_NONE] == 0xff)
++			stomp_txprio[ATH_BTCOEX_STOMP_NONE] = 0;
++
++		if (stomp_txprio[ATH_BTCOEX_STOMP_LOW] == 0xff)
++			stomp_txprio[ATH_BTCOEX_STOMP_LOW] = 0;
++	}
++	ath9k_hw_btcoex_set_concur_txprio(sc->sc_ah, stomp_txprio);
++}
++
+ static u8 ath_mci_process_profile(struct ath_softc *sc,
+ 				  struct ath_mci_profile_info *info)
+ {
+@@ -281,6 +339,7 @@ static u8 ath_mci_process_profile(struct ath_softc *sc,
+ 	} else
+ 		ath_mci_del_profile(common, mci, entry);
+ 
++	ath_mci_set_concur_txprio(sc);
+ 	return 1;
+ }
+ 
+@@ -314,6 +373,7 @@ static u8 ath_mci_process_status(struct ath_softc *sc,
+ 			mci->num_mgmt++;
+ 	} while (++i < ATH_MCI_MAX_PROFILE);
+ 
++	ath_mci_set_concur_txprio(sc);
+ 	if (old_num_mgmt != mci->num_mgmt)
+ 		return 1;
+ 
+diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
+index a3df314..e85a0e9 100644
+--- a/drivers/net/wireless/ath/ath9k/mci.h
++++ b/drivers/net/wireless/ath/ath9k/mci.h
+@@ -32,6 +32,8 @@
+ #define ATH_MCI_MAX_PROFILE		(ATH_MCI_MAX_ACL_PROFILE +\
+ 					 ATH_MCI_MAX_SCO_PROFILE)
+ 
++#define ATH_MCI_INQUIRY_PRIO         62
++#define ATH_MCI_HI_PRIO              60
+ #define ATH_MCI_NUM_BT_CHANNELS      79
+ 
+ #define MCI_GPM_SET_CHANNEL_BIT(_p_gpm, _bt_chan)			  \
+@@ -131,6 +133,7 @@ struct ath_mci_profile {
+ 	u8 num_pan;
+ 	u8 num_other_acl;
+ 	u8 num_bdr;
++	u8 voice_priority;
+ };
+ 
+ struct ath_mci_buf {
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0096-ath9k-fill-channel-mode-in-caldata.patch b/linux-next-cherry-picks/0096-ath9k-fill-channel-mode-in-caldata.patch
new file mode 100644
index 0000000..2819e4e
--- /dev/null
+++ b/linux-next-cherry-picks/0096-ath9k-fill-channel-mode-in-caldata.patch
@@ -0,0 +1,44 @@
+From 77d848372875d2e4cbdbf07030f0e08cab5e7f4d Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Fri, 12 Oct 2012 14:07:24 +0530
+Subject: [PATCH] ath9k: fill channel mode in caldata
+
+It is useful to have channel mode in caldata to find out
+whether operaing channel is in HT40/20 when we are currently
+on offchannel. It will be used by BTCOEX to enable/disable
+concurrent tx mechanism later.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/calib.c |    1 +
+ drivers/net/wireless/ath/ath9k/hw.h    |    1 +
+ 2 files changed, 2 insertions(+), 0 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
+index e5cceb0..f3448a0 100644
+--- a/drivers/net/wireless/ath/ath9k/calib.c
++++ b/drivers/net/wireless/ath/ath9k/calib.c
+@@ -410,6 +410,7 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
+ 
+ 	ah->caldata->channel = chan->channel;
+ 	ah->caldata->channelFlags = chan->channelFlags & ~CHANNEL_CW_INT;
++	ah->caldata->chanmode = chan->chanmode;
+ 	h = ah->caldata->nfCalHist;
+ 	default_nf = ath9k_hw_get_default_nf(ah, chan);
+ 	for (i = 0; i < NUM_NF_READINGS; i++) {
+diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
+index 1d4f5f1..3e73bfe 100644
+--- a/drivers/net/wireless/ath/ath9k/hw.h
++++ b/drivers/net/wireless/ath/ath9k/hw.h
+@@ -401,6 +401,7 @@ enum ath9k_int {
+ struct ath9k_hw_cal_data {
+ 	u16 channel;
+ 	u32 channelFlags;
++	u32 chanmode;
+ 	int32_t CalValid;
+ 	int8_t iCoff;
+ 	int8_t qCoff;
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0097-ath9k-adjust-WLAN-and-BT-concurrent-transmission.patch b/linux-next-cherry-picks/0097-ath9k-adjust-WLAN-and-BT-concurrent-transmission.patch
new file mode 100644
index 0000000..a559028
--- /dev/null
+++ b/linux-next-cherry-picks/0097-ath9k-adjust-WLAN-and-BT-concurrent-transmission.patch
@@ -0,0 +1,313 @@
+From e82cb03f5a645533def34923d55404526bc22fae Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Fri, 12 Oct 2012 14:07:25 +0530
+Subject: [PATCH] ath9k: adjust WLAN and BT concurrent transmission
+
+The simulataneous transmission of both WLAN and BT might cause
+increase in power levels. To avoid regulatory violation, WLAN tx
+power will be adjusted according to BT power index based on avaliability
+of BT scheduling messages. WLAN tx power reduction might affect its
+performance. So WLAN tx power is only be lowered when the signal strength
+is good enough. Otherwise concurrent tx will be disabled and WLAN uses
+it default power levels. Also concurrent tx is disabled whenever WLAN is
+moving to off-channel which might be used by BT.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   18 ++++++-
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c    |   28 +++++++++++-
+ drivers/net/wireless/ath/ath9k/ar9003_mci.h    |    5 ++
+ drivers/net/wireless/ath/ath9k/ath9k.h         |    1 +
+ drivers/net/wireless/ath/ath9k/btcoex.h        |    3 +
+ drivers/net/wireless/ath/ath9k/gpio.c          |    2 +
+ drivers/net/wireless/ath/ath9k/main.c          |    4 ++
+ drivers/net/wireless/ath/ath9k/mci.c           |   59 ++++++++++++++++++++++++
+ drivers/net/wireless/ath/ath9k/mci.h           |    8 +++
+ 9 files changed, 124 insertions(+), 4 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+index 189aeb2..d313998 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -18,6 +18,7 @@
+ #include "hw.h"
+ #include "ar9003_phy.h"
+ #include "ar9003_eeprom.h"
++#include "ar9003_mci.h"
+ 
+ #define COMP_HDR_LEN 4
+ #define COMP_CKSUM_LEN 2
+@@ -41,7 +42,6 @@
+ static int ar9003_hw_power_interpolate(int32_t x,
+ 				       int32_t *px, int32_t *py, u_int16_t np);
+ 
+-
+ static const struct ar9300_eeprom ar9300_default = {
+ 	.eepromVersion = 2,
+ 	.templateVersion = 2,
+@@ -5037,16 +5037,28 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
+ 		case CTL_5GHT20:
+ 		case CTL_2GHT20:
+ 			for (i = ALL_TARGET_HT20_0_8_16;
+-			     i <= ALL_TARGET_HT20_23; i++)
++			     i <= ALL_TARGET_HT20_23; i++) {
+ 				pPwrArray[i] = (u8)min((u16)pPwrArray[i],
+ 						       minCtlPower);
++				if (ath9k_hw_mci_is_enabled(ah))
++					pPwrArray[i] =
++						(u8)min((u16)pPwrArray[i],
++						ar9003_mci_get_max_txpower(ah,
++							pCtlMode[ctlMode]));
++			}
+ 			break;
+ 		case CTL_5GHT40:
+ 		case CTL_2GHT40:
+ 			for (i = ALL_TARGET_HT40_0_8_16;
+-			     i <= ALL_TARGET_HT40_23; i++)
++			     i <= ALL_TARGET_HT40_23; i++) {
+ 				pPwrArray[i] = (u8)min((u16)pPwrArray[i],
+ 						       minCtlPower);
++				if (ath9k_hw_mci_is_enabled(ah))
++					pPwrArray[i] =
++						(u8)min((u16)pPwrArray[i],
++						ar9003_mci_get_max_txpower(ah,
++							pCtlMode[ctlMode]));
++			}
+ 			break;
+ 		default:
+ 			break;
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+index 44c202c..9aa8704 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -818,7 +818,7 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
+ {
+ 	struct ath_common *common = ath9k_hw_common(ah);
+ 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+-	u32 regval;
++	u32 regval, i;
+ 
+ 	ath_dbg(common, MCI, "MCI Reset (full_sleep = %d, is_2g = %d)\n",
+ 		is_full_sleep, is_2g);
+@@ -868,6 +868,18 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
+ 	REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2, AR_BTCOEX_CTRL2_RX_DEWEIGHT, 1);
+ 	REG_RMW_FIELD(ah, AR_PCU_MISC, AR_PCU_BT_ANT_PREVENT_RX, 0);
+ 
++	/* concurrent tx priority */
++	if (mci->config & ATH_MCI_CONFIG_CONCUR_TX) {
++		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2,
++			      AR_BTCOEX_CTRL2_DESC_BASED_TXPWR_ENABLE, 0);
++		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2,
++			      AR_BTCOEX_CTRL2_TXPWR_THRESH, 0x7f);
++		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL,
++			      AR_BTCOEX_CTRL_REDUCE_TXPWR, 0);
++		for (i = 0; i < 8; i++)
++			REG_WRITE(ah, AR_BTCOEX_MAX_TXPWR(i), 0x7f7f7f7f);
++	}
++
+ 	regval = MS(mci->config, ATH_MCI_CONFIG_CLK_DIV);
+ 	REG_RMW_FIELD(ah, AR_MCI_TX_CTRL, AR_MCI_TX_CTRL_CLK_DIV, regval);
+ 	REG_SET_BIT(ah, AR_BTCOEX_CTRL, AR_BTCOEX_CTRL_MCI_MODE_EN);
+@@ -1426,3 +1438,17 @@ void ar9003_mci_send_wlan_channels(struct ath_hw *ah)
+ 	ar9003_mci_send_coex_wlan_channels(ah, true);
+ }
+ EXPORT_SYMBOL(ar9003_mci_send_wlan_channels);
++
++u16 ar9003_mci_get_max_txpower(struct ath_hw *ah, u8 ctlmode)
++{
++	if (!ah->btcoex_hw.mci.concur_tx)
++		goto out;
++
++	if (ctlmode == CTL_2GHT20)
++		return ATH_BTCOEX_HT20_MAX_TXPOWER;
++	else if (ctlmode == CTL_2GHT40)
++		return ATH_BTCOEX_HT40_MAX_TXPOWER;
++
++out:
++	return -1;
++}
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+index 2928234..0910310 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+@@ -277,6 +277,7 @@ void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked);
+ void ar9003_mci_bt_gain_ctrl(struct ath_hw *ah);
+ void ar9003_mci_set_power_awake(struct ath_hw *ah);
+ void ar9003_mci_check_gpm_offset(struct ath_hw *ah);
++u16 ar9003_mci_get_max_txpower(struct ath_hw *ah, u8 ctlmode);
+ 
+ #else
+ 
+@@ -323,6 +324,10 @@ static inline void ar9003_mci_set_power_awake(struct ath_hw *ah)
+ static inline void ar9003_mci_check_gpm_offset(struct ath_hw *ah)
+ {
+ }
++static inline u16 ar9003_mci_get_max_txpower(struct ath_hw *ah, u8 ctlmode)
++{
++	return -1;
++}
+ #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
+ 
+ #endif
+diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
+index 77c2c16..18dfb76 100644
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -479,6 +479,7 @@ struct ath_btcoex {
+ 	u32 btscan_no_stomp; /* in usec */
+ 	u32 duty_cycle;
+ 	u32 bt_wait_time;
++	int rssi_count;
+ 	struct ath_gen_timer *no_stomp_timer; /* Timer for no BT stomping */
+ 	struct ath_mci_profile mci;
+ };
+diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
+index a260fcb..94e9211 100644
+--- a/drivers/net/wireless/ath/ath9k/btcoex.h
++++ b/drivers/net/wireless/ath/ath9k/btcoex.h
+@@ -39,6 +39,9 @@
+ #define ATH_BTCOEX_RX_WAIT_TIME       100
+ #define ATH_BTCOEX_STOMP_FTP_THRESH   5
+ 
++#define ATH_BTCOEX_HT20_MAX_TXPOWER   0x14
++#define ATH_BTCOEX_HT40_MAX_TXPOWER   0x10
++
+ #define AR9300_NUM_BT_WEIGHTS   4
+ #define AR9300_NUM_WLAN_WEIGHTS 4
+ /* Defines the BT AR_BT_COEX_WGHT used */
+diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
+index 9e63a03..64dde1c 100644
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -227,6 +227,8 @@ static void ath_btcoex_period_timer(unsigned long data)
+ 	}
+ 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+ 
++	ath9k_mci_update_rssi(sc);
++
+ 	ath9k_ps_wakeup(sc);
+ 
+ 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
+diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
+index 515e184..578a723 100644
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -293,6 +293,10 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
+ 		goto out;
+ 	}
+ 
++	if (ath9k_hw_mci_is_enabled(sc->sc_ah) &&
++	    (sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
++		ath9k_mci_set_txpower(sc, true, false);
++
+ 	if (!ath_complete_reset(sc, true))
+ 		r = -EIO;
+ 
+diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
+index b37c8af..19dbac4 100644
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -710,3 +710,62 @@ send_wlan_chan:
+ 	ar9003_mci_send_wlan_channels(ah);
+ 	ar9003_mci_state(ah, MCI_STATE_SEND_VERSION_QUERY);
+ }
++
++void ath9k_mci_set_txpower(struct ath_softc *sc, bool setchannel,
++			   bool concur_tx)
++{
++	struct ath_hw *ah = sc->sc_ah;
++	struct ath9k_hw_mci *mci_hw = &sc->sc_ah->btcoex_hw.mci;
++	bool old_concur_tx = mci_hw->concur_tx;
++
++	if (!(mci_hw->config & ATH_MCI_CONFIG_CONCUR_TX)) {
++		mci_hw->concur_tx = false;
++		return;
++	}
++
++	if (!IS_CHAN_2GHZ(ah->curchan))
++		return;
++
++	if (setchannel) {
++		struct ath9k_hw_cal_data *caldata = &sc->caldata;
++		if ((caldata->chanmode == CHANNEL_G_HT40PLUS) &&
++		    (ah->curchan->channel > caldata->channel) &&
++		    (ah->curchan->channel <= caldata->channel + 20))
++			return;
++		if ((caldata->chanmode == CHANNEL_G_HT40MINUS) &&
++		    (ah->curchan->channel < caldata->channel) &&
++		    (ah->curchan->channel >= caldata->channel - 20))
++			return;
++		mci_hw->concur_tx = false;
++	} else
++		mci_hw->concur_tx = concur_tx;
++
++	if (old_concur_tx != mci_hw->concur_tx)
++		ath9k_hw_set_txpowerlimit(ah, sc->config.txpowlimit, false);
++}
++
++void ath9k_mci_update_rssi(struct ath_softc *sc)
++{
++	struct ath_hw *ah = sc->sc_ah;
++	struct ath_btcoex *btcoex = &sc->btcoex;
++	struct ath9k_hw_mci *mci_hw = &sc->sc_ah->btcoex_hw.mci;
++
++	if (!(mci_hw->config & ATH_MCI_CONFIG_CONCUR_TX))
++		return;
++
++	if (ah->stats.avgbrssi >= 40) {
++		if (btcoex->rssi_count < 0)
++			btcoex->rssi_count = 0;
++		if (++btcoex->rssi_count >= ATH_MCI_CONCUR_TX_SWITCH) {
++			btcoex->rssi_count = 0;
++			ath9k_mci_set_txpower(sc, false, true);
++		}
++	} else {
++		if (btcoex->rssi_count > 0)
++			btcoex->rssi_count = 0;
++		if (--btcoex->rssi_count <= -ATH_MCI_CONCUR_TX_SWITCH) {
++			btcoex->rssi_count = 0;
++			ath9k_mci_set_txpower(sc, false, false);
++		}
++	}
++}
+diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
+index e85a0e9..e5f170a 100644
+--- a/drivers/net/wireless/ath/ath9k/mci.h
++++ b/drivers/net/wireless/ath/ath9k/mci.h
+@@ -35,6 +35,7 @@
+ #define ATH_MCI_INQUIRY_PRIO         62
+ #define ATH_MCI_HI_PRIO              60
+ #define ATH_MCI_NUM_BT_CHANNELS      79
++#define ATH_MCI_CONCUR_TX_SWITCH      5
+ 
+ #define MCI_GPM_SET_CHANNEL_BIT(_p_gpm, _bt_chan)			  \
+ 	do {								  \
+@@ -151,10 +152,13 @@ void ath_mci_flush_profile(struct ath_mci_profile *mci);
+ int ath_mci_setup(struct ath_softc *sc);
+ void ath_mci_cleanup(struct ath_softc *sc);
+ void ath_mci_intr(struct ath_softc *sc);
++void ath9k_mci_update_rssi(struct ath_softc *sc);
+ 
+ #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+ void ath_mci_enable(struct ath_softc *sc);
+ void ath9k_mci_update_wlan_channels(struct ath_softc *sc, bool allow_all);
++void ath9k_mci_set_txpower(struct ath_softc *sc, bool setchannel,
++			   bool concur_tx);
+ #else
+ static inline void ath_mci_enable(struct ath_softc *sc)
+ {
+@@ -163,6 +167,10 @@ static inline void ath9k_mci_update_wlan_channels(struct ath_softc *sc,
+ 						  bool allow_all)
+ {
+ }
++static inline void ath9k_mci_set_txpower(struct ath_softc *sc, bool setchannel,
++					 bool concur_tx)
++{
++}
+ #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
+ 
+ #endif /* MCI_H*/
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0100-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch b/linux-next-cherry-picks/0100-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch
new file mode 100644
index 0000000..3747721
--- /dev/null
+++ b/linux-next-cherry-picks/0100-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch
@@ -0,0 +1,42 @@
+From 4c6231a408c1fbec714f82b4742d19f85130ba97 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:45 +0530
+Subject: [PATCH 100/110] ath9k_hw: Enable OSLA hw fix for AR9565
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |    3 +++
+ drivers/net/wireless/ath/ath9k/reg.h        |    4 ++++
+ 2 files changed, 7 insertions(+), 0 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+index 9aa8704..9fa6d22 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -799,6 +799,9 @@ static void ar9003_mci_osla_setup(struct ath_hw *ah, bool enable)
+ 	REG_RMW_FIELD(ah, AR_MCI_SCHD_TABLE_2,
+ 		      AR_MCI_SCHD_TABLE_2_MEM_BASED, 1);
+ 
++	if (AR_SREV_9565(ah))
++		REG_RMW_FIELD(ah, AR_MCI_MISC, AR_MCI_MISC_HW_FIX_EN, 1);
++
+ 	if (!(mci->config & ATH_MCI_CONFIG_DISABLE_AGGR_THRESH)) {
+ 		thresh = MS(mci->config, ATH_MCI_CONFIG_AGGR_THRESH);
+ 		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL,
+diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
+index 4e6760f..c7a9ea7 100644
+--- a/drivers/net/wireless/ath/ath9k/reg.h
++++ b/drivers/net/wireless/ath/ath9k/reg.h
+@@ -2360,4 +2360,8 @@ enum {
+ #define AR_GLB_SWREG_DISCONT_MODE         0x2002c
+ #define AR_GLB_SWREG_DISCONT_EN_BT_WLAN   0x3
+ 
++#define AR_MCI_MISC                    0x1a74
++#define AR_MCI_MISC_HW_FIX_EN          0x00000001
++#define AR_MCI_MISC_HW_FIX_EN_S        0
++
+ #endif
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0101-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch b/linux-next-cherry-picks/0101-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch
new file mode 100644
index 0000000..332f2c0
--- /dev/null
+++ b/linux-next-cherry-picks/0101-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch
@@ -0,0 +1,34 @@
+From 7d47884f306afd1d0215133685f451aaafe3ca7a Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:46 +0530
+Subject: [PATCH 101/110] ath9k_hw: Fix selfgen chainmask for 9565
+
+Self generated MCI messages is configured to use chain 1. As
+ar9565 is 1x1 solution, It can not use Chain 1. Hence fix
+Chain 1 for ar9462 alone. Not doing so, could affect WLAN
+connectivity in ar9565 as LNA sharing is not informed by BT.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |    4 +++-
+ 1 files changed, 3 insertions(+), 1 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+index 9fa6d22..6fbd376 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -1043,7 +1043,9 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force)
+ 
+ 		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
+ 			ar9003_mci_osla_setup(ah, true);
+-		REG_WRITE(ah, AR_SELFGEN_MASK, 0x02);
++
++		if (AR_SREV_9462(ah))
++			REG_WRITE(ah, AR_SELFGEN_MASK, 0x02);
+ 	} else {
+ 		ar9003_mci_send_lna_take(ah, true);
+ 		udelay(5);
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0102-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch b/linux-next-cherry-picks/0102-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch
new file mode 100644
index 0000000..ef41528
--- /dev/null
+++ b/linux-next-cherry-picks/0102-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch
@@ -0,0 +1,39 @@
+From d9575dad59de382dd1f1ddcaa6de38d9844691fe Mon Sep 17 00:00:00 2001
+From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:47 +0530
+Subject: [PATCH 102/110] ath9k: Set appropriate bit for AR9565 in btc control register
+
+Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |   11 +++++++++--
+ 1 files changed, 9 insertions(+), 2 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+index 6fbd376..b2b9941 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -850,11 +850,18 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
+ 		 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
+ 		 SM(1, AR_BTCOEX_CTRL_PA_SHARED) |
+ 		 SM(1, AR_BTCOEX_CTRL_LNA_SHARED) |
+-		 SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
+-		 SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK) |
+ 		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
+ 		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
+ 		 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
++	if (AR_SREV_9565(ah)) {
++		regval |= SM(1, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
++			  SM(1, AR_BTCOEX_CTRL_RX_CHAIN_MASK);
++		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2,
++			      AR_BTCOEX_CTRL2_TX_CHAIN_MASK, 0x1);
++	} else {
++		regval |= SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
++			  SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK);
++	}
+ 
+ 	REG_WRITE(ah, AR_BTCOEX_CTRL, regval);
+ 
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0103-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch b/linux-next-cherry-picks/0103-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch
new file mode 100644
index 0000000..927379b
--- /dev/null
+++ b/linux-next-cherry-picks/0103-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch
@@ -0,0 +1,54 @@
+From b55f6bb7c3f890c3d537516efa8746a4784c058d Mon Sep 17 00:00:00 2001
+From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:48 +0530
+Subject: [PATCH 103/110] ath9k: turn off RXIQ calibration while re-calibrating radio
+
+TXIQ and RXIQ share the same data path to upload the measurement
+result, we should turn off RXIQ calibration while re-calibrating radio
+
+Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |    6 ++++++
+ drivers/net/wireless/ath/ath9k/ar9003_phy.h |    1 +
+ 2 files changed, 7 insertions(+), 0 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+index b2b9941..c46d8f1 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -750,6 +750,9 @@ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
+ 
+ 	mci_hw->bt_state = MCI_BT_AWAKE;
+ 
++	REG_CLR_BIT(ah, AR_PHY_TIMING4,
++		    1 << AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT);
++
+ 	if (caldata) {
+ 		caldata->done_txiqcal_once = false;
+ 		caldata->done_txclcal_once = false;
+@@ -759,6 +762,9 @@ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
+ 	if (!ath9k_hw_init_cal(ah, chan))
+ 		return -EIO;
+ 
++	REG_SET_BIT(ah, AR_PHY_TIMING4,
++		    1 << AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT);
++
+ exit:
+ 	ar9003_mci_enable_interrupt(ah);
+ 	return 0;
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+index 9a48e3d..8f58523 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+@@ -32,6 +32,7 @@
+ #define AR_PHY_SPUR_REG     (AR_CHAN_BASE + 0x1c)
+ #define AR_PHY_RX_IQCAL_CORR_B0    (AR_CHAN_BASE + 0xdc)
+ #define AR_PHY_TX_IQCAL_CONTROL_3  (AR_CHAN_BASE + 0xb0)
++#define AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT 16
+ 
+ #define AR_PHY_TIMING11_SPUR_FREQ_SD    0x3FF00000
+ #define AR_PHY_TIMING11_SPUR_FREQ_SD_S  20
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0104-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch b/linux-next-cherry-picks/0104-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch
new file mode 100644
index 0000000..64966f0
--- /dev/null
+++ b/linux-next-cherry-picks/0104-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch
@@ -0,0 +1,42 @@
+From e9f9fd8cdc5fcb718e2ce778cb5e0eea27e2fdc8 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:49 +0530
+Subject: [PATCH 104/110] ath9k_hw: Disable MCI stat counter by default for AR9565
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |    3 +++
+ drivers/net/wireless/ath/ath9k/reg.h        |    3 +++
+ 2 files changed, 6 insertions(+), 0 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+index c46d8f1..87d9c34 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -938,6 +938,9 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
+ 	mci->ready = true;
+ 	ar9003_mci_prep_interface(ah);
+ 
++	if (AR_SREV_9565(ah))
++		REG_RMW_FIELD(ah, AR_MCI_DBG_CNT_CTRL,
++			      AR_MCI_DBG_CNT_CTRL_ENABLE, 0);
+ 	if (en_int)
+ 		ar9003_mci_enable_interrupt(ah);
+ 
+diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
+index c7a9ea7..8f40dba 100644
+--- a/drivers/net/wireless/ath/ath9k/reg.h
++++ b/drivers/net/wireless/ath/ath9k/reg.h
+@@ -2363,5 +2363,8 @@ enum {
+ #define AR_MCI_MISC                    0x1a74
+ #define AR_MCI_MISC_HW_FIX_EN          0x00000001
+ #define AR_MCI_MISC_HW_FIX_EN_S        0
++#define AR_MCI_DBG_CNT_CTRL            0x1a78
++#define AR_MCI_DBG_CNT_CTRL_ENABLE     0x00000001
++#define AR_MCI_DBG_CNT_CTRL_ENABLE_S   0
+ 
+ #endif
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0105-ath9k_hw-Fix-frequent-BT-rx-recovery.patch b/linux-next-cherry-picks/0105-ath9k_hw-Fix-frequent-BT-rx-recovery.patch
new file mode 100644
index 0000000..29ff7eb
--- /dev/null
+++ b/linux-next-cherry-picks/0105-ath9k_hw-Fix-frequent-BT-rx-recovery.patch
@@ -0,0 +1,76 @@
+From 2097fdd7ebdb1674aaf7343b7a1d6cc2758c1dff Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:50 +0530
+Subject: [PATCH 105/110] ath9k_hw: Fix frequent BT rx recovery
+
+While resuming from S3, BT host issues HCI reset command and it
+causes BT firmware to busy with security key calculation. At this
+movement, WLAN detects MCI hardware error of MCI_CONT_INFO_TIMEOUT
+and then it starts the recovery sequence repeatedly. Too many
+recovery sequences would exhaust the BT kernel message pool. This
+patch imposes a duration between consecutive BT recovery procedure.
+Thus it solves BT firmware panic issue reported in AR9565.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |   10 +++++++++-
+ drivers/net/wireless/ath/ath9k/ar9003_mci.h |    1 +
+ drivers/net/wireless/ath/ath9k/btcoex.h     |    1 +
+ 3 files changed, 11 insertions(+), 1 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+index 87d9c34..b04fa46 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -1203,7 +1203,7 @@ EXPORT_SYMBOL(ar9003_mci_cleanup);
+ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
+ {
+ 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+-	u32 value = 0;
++	u32 value = 0, tsf;
+ 	u8 query_type;
+ 
+ 	switch (state_type) {
+@@ -1261,6 +1261,14 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
+ 		ar9003_mci_send_coex_bt_status_query(ah, true, query_type);
+ 		break;
+ 	case MCI_STATE_RECOVER_RX:
++		tsf = ath9k_hw_gettsf32(ah);
++		if ((tsf - mci->last_recovery) <= MCI_RECOVERY_DUR_TSF) {
++			ath_dbg(ath9k_hw_common(ah), MCI,
++				"(MCI) ignore Rx recovery\n");
++			break;
++		}
++		ath_dbg(ath9k_hw_common(ah), MCI, "(MCI) RECOVER RX\n");
++		mci->last_recovery = tsf;
+ 		ar9003_mci_prep_interface(ah);
+ 		mci->query_bt = true;
+ 		mci->need_flush_btinfo = true;
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+index 0910310..3e51f54 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+@@ -18,6 +18,7 @@
+ #define AR9003_MCI_H
+ 
+ #define MCI_FLAG_DISABLE_TIMESTAMP      0x00000001      /* Disable time stamp */
++#define MCI_RECOVERY_DUR_TSF		(100 * 1000)    /* 100 ms */
+ 
+ /* Default remote BT device MCI COEX version */
+ #define MCI_GPM_COEX_MAJOR_VERSION_DEFAULT  3
+diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
+index 94e9211..2f84ab2 100644
+--- a/drivers/net/wireless/ath/ath9k/btcoex.h
++++ b/drivers/net/wireless/ath/ath9k/btcoex.h
+@@ -88,6 +88,7 @@ struct ath9k_hw_mci {
+ 	u8 bt_state;
+ 	u8 stomp_ftp;
+ 	bool concur_tx;
++	u32 last_recovery;
+ };
+ 
+ struct ath_btcoex_hw {
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0106-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch b/linux-next-cherry-picks/0106-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch
new file mode 100644
index 0000000..cc8949e
--- /dev/null
+++ b/linux-next-cherry-picks/0106-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch
@@ -0,0 +1,34 @@
+From 6f37ff96d3bd2a53e68131a7c10ced933815b390 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:51 +0530
+Subject: [PATCH 106/110] ath9k_hw: Fix max rx rate drop for AR9565
+
+Whenever i_coff of IQ calibration is too high, AR9565 drops max
+rx rate to MCS4. Skipping IQ update at this time can avoid this
+problem for AR9565.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_calib.c |    5 +++++
+ 1 files changed, 5 insertions(+), 0 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+index 84b558d..162401f 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+@@ -276,6 +276,11 @@ static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
+ 				offset_array[i],
+ 				REG_READ(ah, offset_array[i]));
+ 
++			if (AR_SREV_9565(ah) &&
++			    (iCoff == 63 || qCoff == 63 ||
++			     iCoff == -63 || qCoff == -63))
++				return;
++
+ 			REG_RMW_FIELD(ah, offset_array[i],
+ 				      AR_PHY_RX_IQCAL_CORR_IQCORR_Q_I_COFF,
+ 				      iCoff);
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0107-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch b/linux-next-cherry-picks/0107-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch
new file mode 100644
index 0000000..a1057ed
--- /dev/null
+++ b/linux-next-cherry-picks/0107-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch
@@ -0,0 +1,57 @@
+From 506ed95c27b9e4db521df8433860da78b4747cd8 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:52 +0530
+Subject: [PATCH 107/110] ath9k_hw: Configure new switch table for AR9565 BTCOEX
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
+ drivers/net/wireless/ath/ath9k/reg.h           |    4 ----
+ drivers/net/wireless/ath/ath9k/wow.c           |    2 +-
+ 3 files changed, 2 insertions(+), 6 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+index d313998..c86cb640 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -3601,7 +3601,7 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
+ 	 *   7:4 R/W  SWITCH_TABLE_COM_SPDT_WLAN_IDLE
+ 	 * SWITCH_TABLE_COM_SPDT_WLAN_IDLE
+ 	 */
+-	if (AR_SREV_9462_20_OR_LATER(ah)) {
++	if (AR_SREV_9462_20(ah) || AR_SREV_9565(ah)) {
+ 		value = ar9003_switch_com_spdt_get(ah, is2ghz);
+ 		REG_RMW_FIELD(ah, AR_PHY_GLB_CONTROL,
+ 				AR_SWITCH_TABLE_COM_SPDT_ALL, value);
+diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
+index 8f40dba..e9dec13 100644
+--- a/drivers/net/wireless/ath/ath9k/reg.h
++++ b/drivers/net/wireless/ath/ath9k/reg.h
+@@ -907,10 +907,6 @@
+ 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+ 	((_ah)->hw_version.macRev == AR_SREV_REVISION_9462_20))
+ 
+-#define AR_SREV_9462_20_OR_LATER(_ah) \
+-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+-	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9462_20))
+-
+ #define AR_SREV_9565(_ah) \
+ 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565))
+ 
+diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
+index a483d51..9f85630 100644
+--- a/drivers/net/wireless/ath/ath9k/wow.c
++++ b/drivers/net/wireless/ath/ath9k/wow.c
+@@ -118,7 +118,7 @@ static void ath9k_wow_create_keep_alive_pattern(struct ath_hw *ah)
+ 		       (ap_mac_addr[1] << 8) | (ap_mac_addr[0]);
+ 	data_word[5] = (ap_mac_addr[5] << 8) | (ap_mac_addr[4]);
+ 
+-	if (AR_SREV_9462_20_OR_LATER(ah)) {
++	if (AR_SREV_9462_20(ah)) {
+ 		/* AR9462 2.0 has an extra descriptor word (time based
+ 		 * discard) compared to other chips */
+ 		REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + (12 * 4)), 0);
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0108-ath9k_hw-Set-default-MCI-config-for-AR9565.patch b/linux-next-cherry-picks/0108-ath9k_hw-Set-default-MCI-config-for-AR9565.patch
new file mode 100644
index 0000000..4f72260
--- /dev/null
+++ b/linux-next-cherry-picks/0108-ath9k_hw-Set-default-MCI-config-for-AR9565.patch
@@ -0,0 +1,27 @@
+From 3c5c9d04f628135ff57eda5068c9d9513f0a94bf Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:53 +0530
+Subject: [PATCH 108/110] ath9k_hw: Set default MCI config for AR9565
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/btcoex.c |    2 +-
+ 1 files changed, 1 insertions(+), 1 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
+index 05d9be5..c90e9bc 100644
+--- a/drivers/net/wireless/ath/ath9k/btcoex.c
++++ b/drivers/net/wireless/ath/ath9k/btcoex.c
+@@ -195,7 +195,7 @@ void ath9k_hw_btcoex_init_mci(struct ath_hw *ah)
+ 	ah->btcoex_hw.mci.need_flush_btinfo = false;
+ 	ah->btcoex_hw.mci.wlan_cal_seq = 0;
+ 	ah->btcoex_hw.mci.wlan_cal_done = 0;
+-	ah->btcoex_hw.mci.config = 0x2201;
++	ah->btcoex_hw.mci.config = (AR_SREV_9462(ah)) ? 0x2201 : 0xa4c1;
+ }
+ EXPORT_SYMBOL(ath9k_hw_btcoex_init_mci);
+ 
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0109-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch b/linux-next-cherry-picks/0109-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch
new file mode 100644
index 0000000..69d98f5
--- /dev/null
+++ b/linux-next-cherry-picks/0109-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch
@@ -0,0 +1,27 @@
+From f9401b1e74f33d40d97364be5244b715e8cee6ed Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:54 +0530
+Subject: [PATCH 109/110] ath9k: adjust duty cycle for FTP profile for AR9565
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/mci.c |    2 +-
+ 1 files changed, 1 insertions(+), 1 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
+index 19dbac4..0dd2cbb 100644
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -157,7 +157,7 @@ static void ath_mci_update_scheme(struct ath_softc *sc)
+ 			 * For single PAN/FTP profile, allocate 35% for BT
+ 			 * to improve WLAN throughput.
+ 			 */
+-			btcoex->duty_cycle = 35;
++			btcoex->duty_cycle = AR_SREV_9565(sc->sc_ah) ? 40 : 35;
+ 			btcoex->btcoex_period = 53;
+ 			ath_dbg(common, MCI,
+ 				"Single PAN/FTP bt period %d ms dutycycle %d\n",
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0110-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch b/linux-next-cherry-picks/0110-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch
new file mode 100644
index 0000000..24e5f0b
--- /dev/null
+++ b/linux-next-cherry-picks/0110-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch
@@ -0,0 +1,52 @@
+From 7bf7a71e0f7ad69358d01f2a7ba7faa9428db90b Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:55 +0530
+Subject: [PATCH 110/110] ath9k: Add new BT profile info A2DP_Voice
+
+When the BT connection is initiated by headset, it's possible that headset
+requests to make one A2DP and one Voice connection over the same link.
+BT firmware will send a new profile A2DP_Voice in this case. So WLAN
+has to take care of this new profile for tuning BTCOEX parameters.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.h |    1 +
+ drivers/net/wireless/ath/ath9k/mci.h        |    2 ++
+ 2 files changed, 3 insertions(+), 0 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+index 3e51f54..66d7ab9 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+@@ -126,6 +126,7 @@ enum ath_mci_gpm_coex_profile_type {
+ 	MCI_GPM_COEX_PROFILE_HID,
+ 	MCI_GPM_COEX_PROFILE_BNEP,
+ 	MCI_GPM_COEX_PROFILE_VOICE,
++	MCI_GPM_COEX_PROFILE_A2DPVO,
+ 	MCI_GPM_COEX_PROFILE_MAX
+ };
+ 
+diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
+index e5f170a..0695883 100644
+--- a/drivers/net/wireless/ath/ath9k/mci.h
++++ b/drivers/net/wireless/ath/ath9k/mci.h
+@@ -70,6 +70,7 @@
+ 			_mci->num_pan++;	 \
+ 			break;			 \
+ 		case MCI_GPM_COEX_PROFILE_VOICE: \
++		case MCI_GPM_COEX_PROFILE_A2DPVO:\
+ 			_mci->num_sco++;	 \
+ 			break;			 \
+ 		default:			 \
+@@ -94,6 +95,7 @@
+ 			_mci->num_pan--;	 \
+ 			break;			 \
+ 		case MCI_GPM_COEX_PROFILE_VOICE: \
++		case MCI_GPM_COEX_PROFILE_A2DPVO:\
+ 			_mci->num_sco--;	 \
+ 			break;			 \
+ 		default:			 \
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0111-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch b/linux-next-cherry-picks/0111-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch
new file mode 100644
index 0000000..e4a39e9
--- /dev/null
+++ b/linux-next-cherry-picks/0111-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch
@@ -0,0 +1,63 @@
+From 19888b7ee52ffee74a874ad622f44ed5f9706e51 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
+Date: Mon, 15 Oct 2012 16:43:41 +0530
+Subject: [PATCH] cfg80211: Disallow HT/WEP in IBSS mode
+
+Signed-off-by: Sujith Manoharan <c_manoha@qti.qualcomm.com>
+---
+ net/wireless/nl80211.c | 20 +++++++++++++++++---
+ 1 file changed, 17 insertions(+), 3 deletions(-)
+
+--- a/net/wireless/nl80211.c
++++ b/net/wireless/nl80211.c
+@@ -690,7 +690,7 @@ static int nl80211_parse_key(struct genl
+ 
+ static struct cfg80211_cached_keys *
+ nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
+-		       struct nlattr *keys)
++		       struct nlattr *keys, bool *no_ht)
+ {
+ 	struct key_parse parse;
+ 	struct nlattr *key;
+@@ -733,6 +733,12 @@ nl80211_parse_connkeys(struct cfg80211_r
+ 		result->params[parse.idx].key_len = parse.p.key_len;
+ 		result->params[parse.idx].key = result->data[parse.idx];
+ 		memcpy(result->data[parse.idx], parse.p.key, parse.p.key_len);
++
++		if (result->params[parse.idx].cipher == WLAN_CIPHER_SUITE_WEP40 ||
++		    result->params[parse.idx].cipher == WLAN_CIPHER_SUITE_WEP104) {
++			if (no_ht)
++				*no_ht = true;
++		}
+ 	}
+ 
+ 	return result;
+@@ -5318,10 +5324,18 @@ static int nl80211_join_ibss(struct sk_b
+ 		return -EINVAL;
+ 
+ 	if (ibss.privacy && info->attrs[NL80211_ATTR_KEYS]) {
++		bool no_ht = false;
++
+ 		connkeys = nl80211_parse_connkeys(rdev,
+-					info->attrs[NL80211_ATTR_KEYS]);
++					  info->attrs[NL80211_ATTR_KEYS],
++					  &no_ht);
+ 		if (IS_ERR(connkeys))
+ 			return PTR_ERR(connkeys);
++
++		if ((ibss.channel_type != NL80211_CHAN_NO_HT) && no_ht) {
++			kfree(connkeys);
++			return -EINVAL;
++		}
+ 	}
+ 
+ 	ibss.control_port =
+@@ -5621,7 +5635,7 @@ static int nl80211_connect(struct sk_buf
+ 
+ 	if (connect.privacy && info->attrs[NL80211_ATTR_KEYS]) {
+ 		connkeys = nl80211_parse_connkeys(rdev,
+-					info->attrs[NL80211_ATTR_KEYS]);
++					  info->attrs[NL80211_ATTR_KEYS], NULL);
+ 		if (IS_ERR(connkeys))
+ 			return PTR_ERR(connkeys);
+ 	}
diff --git a/linux-next-cherry-picks/0115-ath9k_hw-Enable-hw-PLL-power-save-for-AR9565.patch b/linux-next-cherry-picks/0115-ath9k_hw-Enable-hw-PLL-power-save-for-AR9565.patch
new file mode 100644
index 0000000..823ead5
--- /dev/null
+++ b/linux-next-cherry-picks/0115-ath9k_hw-Enable-hw-PLL-power-save-for-AR9565.patch
@@ -0,0 +1,49 @@
+From 844648423dcf33fed96a4eb65f783f867efbe267 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Thu, 25 Oct 2012 17:16:51 +0530
+Subject: [PATCH 115/118] ath9k_hw: Enable hw PLL power save for AR9565
+
+This reduced the power consumption to half in full and network sleep.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_hw.c         |    4 ++--
+ .../net/wireless/ath/ath9k/ar9565_1p0_initvals.h   |    4 ++--
+ 2 files changed, 4 insertions(+), 4 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+index 0a6b7a3..0693cd9 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+@@ -328,9 +328,9 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
+ 			       ar9565_1p0_Modes_lowest_ob_db_tx_gain_table);
+ 
+ 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
+-			       ar9565_1p0_pciephy_pll_on_clkreq_disable_L1);
++			       ar9565_1p0_pciephy_clkreq_disable_L1);
+ 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+-			       ar9565_1p0_pciephy_pll_on_clkreq_disable_L1);
++			       ar9565_1p0_pciephy_clkreq_disable_L1);
+ 
+ 		INIT_INI_ARRAY(&ah->iniModesFastClock,
+ 				ar9565_1p0_modes_fast_clock);
+diff --git a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
+index 843e79f..0c2ac0c 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
++++ b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
+@@ -768,9 +768,9 @@ static const u32 ar9565_1p0_Modes_lowest_ob_db_tx_gain_table[][5] = {
+ 	{0x00016054, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+ };
+ 
+-static const u32 ar9565_1p0_pciephy_pll_on_clkreq_disable_L1[][2] = {
++static const u32 ar9565_1p0_pciephy_clkreq_disable_L1[][2] = {
+ 	/* Addr      allmodes  */
+-	{0x00018c00, 0x18212ede},
++	{0x00018c00, 0x18213ede},
+ 	{0x00018c04, 0x000801d8},
+ 	{0x00018c08, 0x0003780c},
+ };
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0116-ath9k_hw-Fix-concurrent-tx-on-lower-tx-power.patch b/linux-next-cherry-picks/0116-ath9k_hw-Fix-concurrent-tx-on-lower-tx-power.patch
new file mode 100644
index 0000000..61c0571
--- /dev/null
+++ b/linux-next-cherry-picks/0116-ath9k_hw-Fix-concurrent-tx-on-lower-tx-power.patch
@@ -0,0 +1,51 @@
+From e75d4ed6a9565fcccd579316b0fd933d2191f513 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Thu, 25 Oct 2012 17:16:52 +0530
+Subject: [PATCH 116/118] ath9k_hw: Fix concurrent tx on lower tx power
+
+Whenever WLAN receives scheduling msg from BT, it reduces tx power
+based on RSSI level. And then BT starts simultaneous transmission
+along with WLAN. Sometimes HW MAC compares tx power that is used
+prior to power reduction which is causing BT transmission to defer.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |    5 ++++-
+ drivers/net/wireless/ath/ath9k/reg.h        |    2 ++
+ 2 files changed, 6 insertions(+), 1 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+index b04fa46..42b4412 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -881,9 +881,12 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
+ 	REG_RMW_FIELD(ah, AR_BTCOEX_CTRL3,
+ 		      AR_BTCOEX_CTRL3_CONT_INFO_TIMEOUT, 20);
+ 
+-	REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2, AR_BTCOEX_CTRL2_RX_DEWEIGHT, 1);
++	REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2, AR_BTCOEX_CTRL2_RX_DEWEIGHT, 0);
+ 	REG_RMW_FIELD(ah, AR_PCU_MISC, AR_PCU_BT_ANT_PREVENT_RX, 0);
+ 
++	/* Set the time out to 3.125ms (5 BT slots) */
++	REG_RMW_FIELD(ah, AR_BTCOEX_WL_LNA, AR_BTCOEX_WL_LNA_TIMEOUT, 0x3D090);
++
+ 	/* concurrent tx priority */
+ 	if (mci->config & ATH_MCI_CONFIG_CONCUR_TX) {
+ 		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2,
+diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
+index e9dec13..ad3c82c 100644
+--- a/drivers/net/wireless/ath/ath9k/reg.h
++++ b/drivers/net/wireless/ath/ath9k/reg.h
+@@ -2311,6 +2311,8 @@ enum {
+ #define AR_BTCOEX_MAX_TXPWR(_x)				(0x18c0 + ((_x) << 2))
+ #define AR_BTCOEX_WL_LNA				0x1940
+ #define AR_BTCOEX_RFGAIN_CTRL				0x1944
++#define AR_BTCOEX_WL_LNA_TIMEOUT			0x003FFFFF
++#define AR_BTCOEX_WL_LNA_TIMEOUT_S			0
+ 
+ #define AR_BTCOEX_CTRL2					0x1948
+ #define AR_BTCOEX_CTRL2_TXPWR_THRESH			0x0007F800
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0117-ath9k_hw-validate-MCI-stuck-after-RTC-wakeup.patch b/linux-next-cherry-picks/0117-ath9k_hw-validate-MCI-stuck-after-RTC-wakeup.patch
new file mode 100644
index 0000000..72ad384
--- /dev/null
+++ b/linux-next-cherry-picks/0117-ath9k_hw-validate-MCI-stuck-after-RTC-wakeup.patch
@@ -0,0 +1,38 @@
+From cdbe408da76d5cc294edb013850cc3a972d80968 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Thu, 25 Oct 2012 17:16:53 +0530
+Subject: [PATCH 117/118] ath9k_hw: validate MCI stuck after RTC wakeup
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/hw.c |    6 +++---
+ 1 files changed, 3 insertions(+), 3 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
+index 8e1559a..71cd9f0 100644
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -2153,9 +2153,6 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah)
+ 		    AR_RTC_FORCE_WAKE_EN);
+ 	udelay(50);
+ 
+-	if (ath9k_hw_mci_is_enabled(ah))
+-		ar9003_mci_set_power_awake(ah);
+-
+ 	for (i = POWER_UP_TIME / 50; i > 0; i--) {
+ 		val = REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M;
+ 		if (val == AR_RTC_STATUS_ON)
+@@ -2171,6 +2168,9 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah)
+ 		return false;
+ 	}
+ 
++	if (ath9k_hw_mci_is_enabled(ah))
++		ar9003_mci_set_power_awake(ah);
++
+ 	REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+ 
+ 	return true;
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0118-ath9k-Dump-BTCOEX-tuning-parameters.patch b/linux-next-cherry-picks/0118-ath9k-Dump-BTCOEX-tuning-parameters.patch
new file mode 100644
index 0000000..355d0ba
--- /dev/null
+++ b/linux-next-cherry-picks/0118-ath9k-Dump-BTCOEX-tuning-parameters.patch
@@ -0,0 +1,148 @@
+From 4df50ca869890581020b95958251bd355c1dc6b1 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Thu, 25 Oct 2012 17:16:54 +0530
+Subject: [PATCH 118/118] ath9k: Dump BTCOEX tuning parameters
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h |    6 ++++
+ drivers/net/wireless/ath/ath9k/debug.c |   34 ++++++++++++++++++++++-
+ drivers/net/wireless/ath/ath9k/gpio.c  |   48 ++++++++++++++++++++++++++++++++
+ 3 files changed, 87 insertions(+), 1 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
+index 18dfb76..4e125d8 100644
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -494,6 +494,7 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc);
+ void ath9k_btcoex_handle_interrupt(struct ath_softc *sc, u32 status);
+ u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen);
+ void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc);
++int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 len, u32 size);
+ #else
+ static inline int ath9k_init_btcoex(struct ath_softc *sc)
+ {
+@@ -520,6 +521,11 @@ static inline u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc,
+ static inline void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc)
+ {
+ }
++static inline int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf,
++				    u32 len, u32 size)
++{
++	return 0;
++}
+ #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
+ 
+ struct ath9k_wow_pattern {
+diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
+index 6727b56..a8be94b 100644
+--- a/drivers/net/wireless/ath/ath9k/debug.c
++++ b/drivers/net/wireless/ath/ath9k/debug.c
+@@ -1586,6 +1586,35 @@ static const struct file_operations fops_samps = {
+ 
+ #endif
+ 
++#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
++static ssize_t read_file_btcoex(struct file *file, char __user *user_buf,
++				size_t count, loff_t *ppos)
++{
++	struct ath_softc *sc = file->private_data;
++	u32 len = 0, size = 1500;
++	char *buf;
++	size_t retval;
++
++	buf = kzalloc(size, GFP_KERNEL);
++	if (buf == NULL)
++		return -ENOMEM;
++
++	len = ath9k_dump_btcoex(sc, buf, len, size);
++
++	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
++	kfree(buf);
++
++	return retval;
++}
++
++static const struct file_operations fops_btcoex = {
++	.read = read_file_btcoex,
++	.open = simple_open,
++	.owner = THIS_MODULE,
++	.llseek = default_llseek,
++};
++#endif
++
+ int ath9k_init_debug(struct ath_hw *ah)
+ {
+ 	struct ath_common *common = ath9k_hw_common(ah);
+@@ -1658,6 +1687,9 @@ int ath9k_init_debug(struct ath_hw *ah)
+ 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_val);
+ 	debugfs_create_file("diversity", S_IRUSR | S_IWUSR,
+ 			    sc->debug.debugfs_phy, sc, &fops_ant_diversity);
+-
++#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
++	debugfs_create_file("btcoex", S_IRUSR, sc->debug.debugfs_phy, sc,
++			    &fops_btcoex);
++#endif
+ 	return 0;
+ }
+diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
+index 64dde1c..a8ea57b 100644
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -494,4 +494,52 @@ int ath9k_init_btcoex(struct ath_softc *sc)
+ 	return 0;
+ }
+ 
++int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 len, u32 size)
++{
++#define ATH_DUMP_BTCOEX(_s, _val)                                \
++	do {                                                     \
++		len += snprintf(buf + len, size - len,           \
++				"%20s : %10d\n", _s, (_val));    \
++	} while (0)
++
++	struct ath_btcoex *btcoex = &sc->btcoex;
++	struct ath_mci_profile *mci = &btcoex->mci;
++	struct ath_hw *ah = sc->sc_ah;
++	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
++	int i;
++
++	ATH_DUMP_BTCOEX("Total BT profiles", NUM_PROF(mci));
++	ATH_DUMP_BTCOEX("Number of MGMT", mci->num_mgmt);
++	ATH_DUMP_BTCOEX("Number of SCO", mci->num_sco);
++	ATH_DUMP_BTCOEX("Number of A2DP", mci->num_a2dp);
++	ATH_DUMP_BTCOEX("Number of HID", mci->num_hid);
++	ATH_DUMP_BTCOEX("Number of PAN", mci->num_pan);
++	ATH_DUMP_BTCOEX("Number of ACL", mci->num_other_acl);
++	ATH_DUMP_BTCOEX("Number of BDR", mci->num_bdr);
++	ATH_DUMP_BTCOEX("Aggr. Limit", mci->aggr_limit);
++	ATH_DUMP_BTCOEX("Stomp Type", btcoex->bt_stomp_type);
++	ATH_DUMP_BTCOEX("BTCoex Period (msec)", btcoex->btcoex_period);
++	ATH_DUMP_BTCOEX("Duty Cycle", btcoex->duty_cycle);
++	ATH_DUMP_BTCOEX("BT Wait time", btcoex->bt_wait_time);
++	ATH_DUMP_BTCOEX("Concurrent Tx", btcoex_hw->mci.concur_tx);
++	ATH_DUMP_BTCOEX("Concur RSSI count", btcoex->rssi_count);
++	len += snprintf(buf + len, size - len, "BT Weights: ");
++	for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
++		len += snprintf(buf + len, size - len, "%08x ",
++				btcoex_hw->bt_weight[i]);
++	len += snprintf(buf + len, size - len, "\n");
++	len += snprintf(buf + len, size - len, "WLAN Weights: ");
++	for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
++		len += snprintf(buf + len, size - len, "%08x ",
++				btcoex_hw->wlan_weight[i]);
++	len += snprintf(buf + len, size - len, "\n");
++	len += snprintf(buf + len, size - len, "Tx Priorities: ");
++	for (i = 0; i < ATH_BTCOEX_STOMP_MAX; i++)
++		len += snprintf(buf + len, size - len, "%08x ",
++				btcoex_hw->tx_prio[i]);
++	len += snprintf(buf + len, size - len, "\n");
++#undef ATH_DUMP_BTCOEX
++
++	return len;
++}
+ #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
+-- 
+1.7.4.1
+
diff --git a/linux-next-cherry-picks/0119-ath9k-Test-for-TID-only-in-BlockAcks-while-checking-.patch b/linux-next-cherry-picks/0119-ath9k-Test-for-TID-only-in-BlockAcks-while-checking-.patch
new file mode 100644
index 0000000..7c2f24e
--- /dev/null
+++ b/linux-next-cherry-picks/0119-ath9k-Test-for-TID-only-in-BlockAcks-while-checking-.patch
@@ -0,0 +1,65 @@
+From 6fe7cc71bbf3a0bc28c9cec3c00bc11e81344412 Mon Sep 17 00:00:00 2001
+From: Sven Eckelmann <sven@narfation.org>
+Date: Mon, 29 Oct 2012 13:25:20 +0100
+Subject: [PATCH] ath9k: Test for TID only in BlockAcks while checking tx status
+
+The ath9k xmit functions for AMPDUs can send frames as non-aggregate in case
+only one frame is currently available. The client will then answer using a
+normal Ack instead of a BlockAck. This acknowledgement has no TID stored and
+therefore the hardware is not able to provide us the corresponding TID.
+
+The TID set by the hardware in the tx status descriptor has to be seen as
+undefined and not as a valid TID value for normal acknowledgements. Doing
+otherwise results in a massive amount of retransmissions and stalls of
+connections.
+
+Users may experience low bandwidth and complete connection stalls in
+environments with transfers using multiple TIDs.
+
+This regression was introduced in b11b160defc48e4daa283f785192ea3a23a51f8e
+("ath9k: validate the TID in the tx status information").
+
+Signed-off-by: Sven Eckelmann <sven@narfation.org>
+Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
+Cc: stable@vger.kernel.org
+Acked-by: Felix Fietkau <nbd@openwrt.org>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/xmit.c |    8 ++++++--
+ 1 files changed, 6 insertions(+), 2 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
+index 1ffca75..741918a 100644
+--- a/drivers/net/wireless/ath/ath9k/xmit.c
++++ b/drivers/net/wireless/ath/ath9k/xmit.c
+@@ -394,7 +394,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
+ 	u16 seq_st = 0, acked_cnt = 0, txfail_cnt = 0, seq_first;
+ 	u32 ba[WME_BA_BMP_SIZE >> 5];
+ 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
+-	bool rc_update = true;
++	bool rc_update = true, isba;
+ 	struct ieee80211_tx_rate rates[4];
+ 	struct ath_frame_info *fi;
+ 	int nframes;
+@@ -438,13 +438,17 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
+ 	tidno = ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
+ 	tid = ATH_AN_2_TID(an, tidno);
+ 	seq_first = tid->seq_start;
++	isba = ts->ts_flags & ATH9K_TX_BA;
+ 
+ 	/*
+ 	 * The hardware occasionally sends a tx status for the wrong TID.
+ 	 * In this case, the BA status cannot be considered valid and all
+ 	 * subframes need to be retransmitted
++	 *
++	 * Only BlockAcks have a TID and therefore normal Acks cannot be
++	 * checked
+ 	 */
+-	if (tidno != ts->tid)
++	if (isba && tidno != ts->tid)
+ 		txok = false;
+ 
+ 	isaggr = bf_isaggr(bf);
+-- 
+1.7.4.1
+
diff --git a/linux-next-pending/0001-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch b/linux-next-pending/0001-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch
deleted file mode 100644
index 8f3e87c..0000000
--- a/linux-next-pending/0001-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch
+++ /dev/null
@@ -1,34 +0,0 @@
-From 09504f1ccb52e865e1be861db9c7c1adbf206614 Mon Sep 17 00:00:00 2001
-From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
-Date: Mon, 15 Oct 2012 15:29:45 +0530
-Subject: [PATCH 01/11] ath9k_hw: Enable OSLA hw fix for AR9565
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_mci.c |    3 +++
- drivers/net/wireless/ath/ath9k/reg.h        |    4 ++++
- 2 files changed, 7 insertions(+), 0 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-@@ -799,6 +799,9 @@ static void ar9003_mci_osla_setup(struct
- 	REG_RMW_FIELD(ah, AR_MCI_SCHD_TABLE_2,
- 		      AR_MCI_SCHD_TABLE_2_MEM_BASED, 1);
- 
-+	if (AR_SREV_9565(ah))
-+		REG_RMW_FIELD(ah, AR_MCI_MISC, AR_MCI_MISC_HW_FIX_EN, 1);
-+
- 	if (!(mci->config & ATH_MCI_CONFIG_DISABLE_AGGR_THRESH)) {
- 		thresh = MS(mci->config, ATH_MCI_CONFIG_AGGR_THRESH);
- 		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL,
---- a/drivers/net/wireless/ath/ath9k/reg.h
-+++ b/drivers/net/wireless/ath/ath9k/reg.h
-@@ -2360,4 +2360,8 @@ enum {
- #define AR_GLB_SWREG_DISCONT_MODE         0x2002c
- #define AR_GLB_SWREG_DISCONT_EN_BT_WLAN   0x3
- 
-+#define AR_MCI_MISC                    0x1a74
-+#define AR_MCI_MISC_HW_FIX_EN          0x00000001
-+#define AR_MCI_MISC_HW_FIX_EN_S        0
-+
- #endif
diff --git a/linux-next-pending/0002-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch b/linux-next-pending/0002-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch
deleted file mode 100644
index 84f3447..0000000
--- a/linux-next-pending/0002-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch
+++ /dev/null
@@ -1,28 +0,0 @@
-From 9f477777f199e21ecdeea4df1244f55495827ffe Mon Sep 17 00:00:00 2001
-From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
-Date: Mon, 15 Oct 2012 15:29:46 +0530
-Subject: [PATCH 02/11] ath9k_hw: Fix selfgen chainmask for 9565
-
-Self generated MCI messages is configured to use chain 1. As
-ar9565 is 1x1 solution, It can not use Chain 1. Hence fix
-Chain 1 for ar9462 alone. Not doing so, could affect WLAN
-connectivity in ar9565 as LNA sharing is not informed by BT.
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_mci.c |    4 +++-
- 1 files changed, 3 insertions(+), 1 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-@@ -1031,7 +1031,9 @@ void ar9003_mci_2g5g_switch(struct ath_h
- 
- 		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
- 			ar9003_mci_osla_setup(ah, true);
--		REG_WRITE(ah, AR_SELFGEN_MASK, 0x02);
-+
-+		if (AR_SREV_9462(ah))
-+			REG_WRITE(ah, AR_SELFGEN_MASK, 0x02);
- 	} else {
- 		ar9003_mci_send_lna_take(ah, true);
- 		udelay(5);
diff --git a/linux-next-pending/0003-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch b/linux-next-pending/0003-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch
deleted file mode 100644
index 329a901..0000000
--- a/linux-next-pending/0003-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch
+++ /dev/null
@@ -1,33 +0,0 @@
-From cd8098a5ee084ea3b41f2891e0a5340271988f0d Mon Sep 17 00:00:00 2001
-From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
-Date: Mon, 15 Oct 2012 15:29:47 +0530
-Subject: [PATCH 03/11] ath9k: Set appropriate bit for AR9565 in btc control register
-
-Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_mci.c |   11 +++++++++--
- 1 files changed, 9 insertions(+), 2 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-@@ -850,11 +850,18 @@ int ar9003_mci_reset(struct ath_hw *ah,
- 		 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
- 		 SM(1, AR_BTCOEX_CTRL_PA_SHARED) |
- 		 SM(1, AR_BTCOEX_CTRL_LNA_SHARED) |
--		 SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
--		 SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK) |
- 		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
- 		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
- 		 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
-+	if (AR_SREV_9565(ah)) {
-+		regval |= SM(1, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
-+			  SM(1, AR_BTCOEX_CTRL_RX_CHAIN_MASK);
-+		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2,
-+			      AR_BTCOEX_CTRL2_TX_CHAIN_MASK, 0x1);
-+	} else {
-+		regval |= SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
-+			  SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK);
-+	}
- 
- 	REG_WRITE(ah, AR_BTCOEX_CTRL, regval);
- 
diff --git a/linux-next-pending/0004-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch b/linux-next-pending/0004-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch
deleted file mode 100644
index 9e9819a..0000000
--- a/linux-next-pending/0004-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch
+++ /dev/null
@@ -1,46 +0,0 @@
-From f090327eec6875ce4302173f1638a37b9a5d47b8 Mon Sep 17 00:00:00 2001
-From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
-Date: Mon, 15 Oct 2012 15:29:48 +0530
-Subject: [PATCH 04/11] ath9k: turn off RXIQ calibration while re-calibrating radio
-
-TXIQ and RXIQ share the same data path to upload the measurement
-result, we should turn off RXIQ calibration while re-calibrating radio
-
-Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_mci.c |    6 ++++++
- drivers/net/wireless/ath/ath9k/ar9003_phy.h |    1 +
- 2 files changed, 7 insertions(+), 0 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-@@ -750,6 +750,9 @@ int ar9003_mci_end_reset(struct ath_hw *
- 
- 	mci_hw->bt_state = MCI_BT_AWAKE;
- 
-+	REG_CLR_BIT(ah, AR_PHY_TIMING4,
-+		    1 << AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT);
-+
- 	if (caldata) {
- 		caldata->done_txiqcal_once = false;
- 		caldata->done_txclcal_once = false;
-@@ -759,6 +762,9 @@ int ar9003_mci_end_reset(struct ath_hw *
- 	if (!ath9k_hw_init_cal(ah, chan))
- 		return -EIO;
- 
-+	REG_SET_BIT(ah, AR_PHY_TIMING4,
-+		    1 << AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT);
-+
- exit:
- 	ar9003_mci_enable_interrupt(ah);
- 	return 0;
---- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
-@@ -32,6 +32,7 @@
- #define AR_PHY_SPUR_REG     (AR_CHAN_BASE + 0x1c)
- #define AR_PHY_RX_IQCAL_CORR_B0    (AR_CHAN_BASE + 0xdc)
- #define AR_PHY_TX_IQCAL_CONTROL_3  (AR_CHAN_BASE + 0xb0)
-+#define AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT 16
- 
- #define AR_PHY_TIMING11_SPUR_FREQ_SD    0x3FF00000
- #define AR_PHY_TIMING11_SPUR_FREQ_SD_S  20
diff --git a/linux-next-pending/0005-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch b/linux-next-pending/0005-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch
deleted file mode 100644
index 1d59f1f..0000000
--- a/linux-next-pending/0005-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch
+++ /dev/null
@@ -1,34 +0,0 @@
-From 7b608d7a012d967f08e8500c3e38b94d28daa4c6 Mon Sep 17 00:00:00 2001
-From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
-Date: Mon, 15 Oct 2012 15:29:49 +0530
-Subject: [PATCH 05/11] ath9k_hw: Disable MCI stat counter by default for AR9565
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_mci.c |    3 +++
- drivers/net/wireless/ath/ath9k/reg.h        |    3 +++
- 2 files changed, 6 insertions(+), 0 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-@@ -926,6 +926,9 @@ int ar9003_mci_reset(struct ath_hw *ah,
- 	mci->ready = true;
- 	ar9003_mci_prep_interface(ah);
- 
-+	if (AR_SREV_9565(ah))
-+		REG_RMW_FIELD(ah, AR_MCI_DBG_CNT_CTRL,
-+			      AR_MCI_DBG_CNT_CTRL_ENABLE, 0);
- 	if (en_int)
- 		ar9003_mci_enable_interrupt(ah);
- 
---- a/drivers/net/wireless/ath/ath9k/reg.h
-+++ b/drivers/net/wireless/ath/ath9k/reg.h
-@@ -2363,5 +2363,8 @@ enum {
- #define AR_MCI_MISC                    0x1a74
- #define AR_MCI_MISC_HW_FIX_EN          0x00000001
- #define AR_MCI_MISC_HW_FIX_EN_S        0
-+#define AR_MCI_DBG_CNT_CTRL            0x1a78
-+#define AR_MCI_DBG_CNT_CTRL_ENABLE     0x00000001
-+#define AR_MCI_DBG_CNT_CTRL_ENABLE_S   0
- 
- #endif
diff --git a/linux-next-pending/0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch b/linux-next-pending/0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch
deleted file mode 100644
index 0067334..0000000
--- a/linux-next-pending/0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch
+++ /dev/null
@@ -1,66 +0,0 @@
-From 56e95424248ae3a3f5dd92bdd7ae0446ea3776ba Mon Sep 17 00:00:00 2001
-From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
-Date: Mon, 15 Oct 2012 17:31:41 +0530
-Subject: [PATCH 06/11] ath9k_hw: Fix frequent BT rx recovery
-
-While resuming from S3, BT host issues HCI reset command and it
-causes BT firmware to busy with security key calculation. At this
-movement, WLAN detects MCI hardware error of MCI_CONT_INFO_TIMEOUT
-and then it starts the recovery sequence repeatedly. Too many
-recovery sequences would exhaust the BT kernel message pool. This
-patch imposes a duration between consecutive BT recovery procedure.
-Thus it solves BT firmware panic issue reported in AR9565.
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_mci.c |   10 +++++++++-
- drivers/net/wireless/ath/ath9k/ar9003_mci.h |    1 +
- drivers/net/wireless/ath/ath9k/btcoex.h     |    1 +
- 3 files changed, 11 insertions(+), 1 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-@@ -1191,7 +1191,7 @@ EXPORT_SYMBOL(ar9003_mci_cleanup);
- u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
- {
- 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
--	u32 value = 0;
-+	u32 value = 0, tsf;
- 	u8 query_type;
- 
- 	switch (state_type) {
-@@ -1249,6 +1249,14 @@ u32 ar9003_mci_state(struct ath_hw *ah,
- 		ar9003_mci_send_coex_bt_status_query(ah, true, query_type);
- 		break;
- 	case MCI_STATE_RECOVER_RX:
-+		tsf = ath9k_hw_gettsf32(ah);
-+		if ((tsf - mci->last_recovery) <= MCI_RECOVERY_DUR_TSF) {
-+			ath_dbg(ath9k_hw_common(ah), MCI,
-+				"(MCI) ignore Rx recovery\n");
-+			break;
-+		}
-+		ath_dbg(ath9k_hw_common(ah), MCI, "(MCI) RECOVER RX\n");
-+		mci->last_recovery = tsf;
- 		ar9003_mci_prep_interface(ah);
- 		mci->query_bt = true;
- 		mci->need_flush_btinfo = true;
---- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
-@@ -18,6 +18,7 @@
- #define AR9003_MCI_H
- 
- #define MCI_FLAG_DISABLE_TIMESTAMP      0x00000001      /* Disable time stamp */
-+#define MCI_RECOVERY_DUR_TSF		(100 * 1000)    /* 100 ms */
- 
- /* Default remote BT device MCI COEX version */
- #define MCI_GPM_COEX_MAJOR_VERSION_DEFAULT  3
---- a/drivers/net/wireless/ath/ath9k/btcoex.h
-+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
-@@ -84,6 +84,7 @@ struct ath9k_hw_mci {
- 	u8 bt_ver_minor;
- 	u8 bt_state;
- 	u8 stomp_ftp;
-+	u32 last_recovery;
- };
- 
- struct ath_btcoex_hw {
diff --git a/linux-next-pending/0007-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch b/linux-next-pending/0007-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch
deleted file mode 100644
index 1ac6f84..0000000
--- a/linux-next-pending/0007-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch
+++ /dev/null
@@ -1,28 +0,0 @@
-From f02b45dc2aa6022765a18cea7ce6acff31f59897 Mon Sep 17 00:00:00 2001
-From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
-Date: Mon, 15 Oct 2012 15:29:51 +0530
-Subject: [PATCH 07/11] ath9k_hw: Fix max rx rate drop for AR9565
-
-Whenever i_coff of IQ calibration is too high, AR9565 drops max
-rx rate to MCS4. Skipping IQ update at this time can avoid this
-problem for AR9565.
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_calib.c |    5 +++++
- 1 files changed, 5 insertions(+), 0 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
-@@ -276,6 +276,11 @@ static void ar9003_hw_iqcalibrate(struct
- 				offset_array[i],
- 				REG_READ(ah, offset_array[i]));
- 
-+			if (AR_SREV_9565(ah) &&
-+			    (iCoff == 63 || qCoff == 63 ||
-+			     iCoff == -63 || qCoff == -63))
-+				return;
-+
- 			REG_RMW_FIELD(ah, offset_array[i],
- 				      AR_PHY_RX_IQCAL_CORR_IQCORR_Q_I_COFF,
- 				      iCoff);
diff --git a/linux-next-pending/0008-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch b/linux-next-pending/0008-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch
deleted file mode 100644
index 2ae2a1d..0000000
--- a/linux-next-pending/0008-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch
+++ /dev/null
@@ -1,47 +0,0 @@
-From 2413be8ff29842ba6404dc69e353f481aa7e6f87 Mon Sep 17 00:00:00 2001
-From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
-Date: Mon, 15 Oct 2012 15:29:52 +0530
-Subject: [PATCH 08/11] ath9k_hw: Configure new switch table for AR9565 BTCOEX
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
- drivers/net/wireless/ath/ath9k/reg.h           |    4 ----
- drivers/net/wireless/ath/ath9k/wow.c           |    2 +-
- 3 files changed, 2 insertions(+), 6 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
-@@ -3601,7 +3601,7 @@ static void ar9003_hw_ant_ctrl_apply(str
- 	 *   7:4 R/W  SWITCH_TABLE_COM_SPDT_WLAN_IDLE
- 	 * SWITCH_TABLE_COM_SPDT_WLAN_IDLE
- 	 */
--	if (AR_SREV_9462_20_OR_LATER(ah)) {
-+	if (AR_SREV_9462_20(ah) || AR_SREV_9565(ah)) {
- 		value = ar9003_switch_com_spdt_get(ah, is2ghz);
- 		REG_RMW_FIELD(ah, AR_PHY_GLB_CONTROL,
- 				AR_SWITCH_TABLE_COM_SPDT_ALL, value);
---- a/drivers/net/wireless/ath/ath9k/reg.h
-+++ b/drivers/net/wireless/ath/ath9k/reg.h
-@@ -907,10 +907,6 @@
- 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
- 	((_ah)->hw_version.macRev == AR_SREV_REVISION_9462_20))
- 
--#define AR_SREV_9462_20_OR_LATER(_ah) \
--	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
--	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9462_20))
--
- #define AR_SREV_9565(_ah) \
- 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565))
- 
---- a/drivers/net/wireless/ath/ath9k/wow.c
-+++ b/drivers/net/wireless/ath/ath9k/wow.c
-@@ -118,7 +118,7 @@ static void ath9k_wow_create_keep_alive_
- 		       (ap_mac_addr[1] << 8) | (ap_mac_addr[0]);
- 	data_word[5] = (ap_mac_addr[5] << 8) | (ap_mac_addr[4]);
- 
--	if (AR_SREV_9462_20_OR_LATER(ah)) {
-+	if (AR_SREV_9462_20(ah)) {
- 		/* AR9462 2.0 has an extra descriptor word (time based
- 		 * discard) compared to other chips */
- 		REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + (12 * 4)), 0);
diff --git a/linux-next-pending/0009-ath9k_hw-Set-default-MCI-config-for-AR9565.patch b/linux-next-pending/0009-ath9k_hw-Set-default-MCI-config-for-AR9565.patch
deleted file mode 100644
index 687c8db..0000000
--- a/linux-next-pending/0009-ath9k_hw-Set-default-MCI-config-for-AR9565.patch
+++ /dev/null
@@ -1,21 +0,0 @@
-From 1e902624bc2de514eb4931950fb0533010246ae8 Mon Sep 17 00:00:00 2001
-From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
-Date: Mon, 15 Oct 2012 15:29:53 +0530
-Subject: [PATCH 09/11] ath9k_hw: Set default MCI config for AR9565
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/btcoex.c |    2 +-
- 1 files changed, 1 insertions(+), 1 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/btcoex.c
-+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
-@@ -195,7 +195,7 @@ void ath9k_hw_btcoex_init_mci(struct ath
- 	ah->btcoex_hw.mci.need_flush_btinfo = false;
- 	ah->btcoex_hw.mci.wlan_cal_seq = 0;
- 	ah->btcoex_hw.mci.wlan_cal_done = 0;
--	ah->btcoex_hw.mci.config = 0x2201;
-+	ah->btcoex_hw.mci.config = (AR_SREV_9462(ah)) ? 0x2201 : 0xa4c1;
- }
- EXPORT_SYMBOL(ath9k_hw_btcoex_init_mci);
- 
diff --git a/linux-next-pending/0010-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch b/linux-next-pending/0010-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch
deleted file mode 100644
index 24bfd02..0000000
--- a/linux-next-pending/0010-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch
+++ /dev/null
@@ -1,21 +0,0 @@
-From 31a829f68f4d5f36ea5513b3d4924c5ba372dfc8 Mon Sep 17 00:00:00 2001
-From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
-Date: Mon, 15 Oct 2012 15:29:54 +0530
-Subject: [PATCH 10/11] ath9k: adjust duty cycle for FTP profile for AR9565
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/mci.c |    2 +-
- 1 files changed, 1 insertions(+), 1 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/mci.c
-+++ b/drivers/net/wireless/ath/ath9k/mci.c
-@@ -150,7 +150,7 @@ static void ath_mci_update_scheme(struct
- 			 * For single PAN/FTP profile, allocate 35% for BT
- 			 * to improve WLAN throughput.
- 			 */
--			btcoex->duty_cycle = 35;
-+			btcoex->duty_cycle = AR_SREV_9565(sc->sc_ah) ? 40 : 35;
- 			btcoex->btcoex_period = 53;
- 			ath_dbg(common, MCI,
- 				"Single PAN/FTP bt period %d ms dutycycle %d\n",
diff --git a/linux-next-pending/0011-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch b/linux-next-pending/0011-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch
deleted file mode 100644
index 2d4d4f1..0000000
--- a/linux-next-pending/0011-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch
+++ /dev/null
@@ -1,44 +0,0 @@
-From 2b175a64f5daa777c6509542e38a48dd15f8e1b4 Mon Sep 17 00:00:00 2001
-From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
-Date: Mon, 15 Oct 2012 15:29:55 +0530
-Subject: [PATCH 11/11] ath9k: Add new BT profile info A2DP_Voice
-
-When the BT connection is initiated by headset, it's possible that headset
-requests to make one A2DP and one Voice connection over the same link.
-BT firmware will send a new profile A2DP_Voice in this case. So WLAN
-has to take care of this new profile for tuning BTCOEX parameters.
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_mci.h |    1 +
- drivers/net/wireless/ath/ath9k/mci.h        |    2 ++
- 2 files changed, 3 insertions(+), 0 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
-@@ -126,6 +126,7 @@ enum ath_mci_gpm_coex_profile_type {
- 	MCI_GPM_COEX_PROFILE_HID,
- 	MCI_GPM_COEX_PROFILE_BNEP,
- 	MCI_GPM_COEX_PROFILE_VOICE,
-+	MCI_GPM_COEX_PROFILE_A2DPVO,
- 	MCI_GPM_COEX_PROFILE_MAX
- };
- 
---- a/drivers/net/wireless/ath/ath9k/mci.h
-+++ b/drivers/net/wireless/ath/ath9k/mci.h
-@@ -49,6 +49,7 @@
- 			_mci->num_pan++;	 \
- 			break;			 \
- 		case MCI_GPM_COEX_PROFILE_VOICE: \
-+		case MCI_GPM_COEX_PROFILE_A2DPVO:\
- 			_mci->num_sco++;	 \
- 			break;			 \
- 		default:			 \
-@@ -73,6 +74,7 @@
- 			_mci->num_pan--;	 \
- 			break;			 \
- 		case MCI_GPM_COEX_PROFILE_VOICE: \
-+		case MCI_GPM_COEX_PROFILE_A2DPVO:\
- 			_mci->num_sco--;	 \
- 			break;			 \
- 		default:			 \
diff --git a/linux-next-pending/0012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch b/linux-next-pending/0012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch
deleted file mode 100644
index e4a39e9..0000000
--- a/linux-next-pending/0012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch
+++ /dev/null
@@ -1,63 +0,0 @@
-From 19888b7ee52ffee74a874ad622f44ed5f9706e51 Mon Sep 17 00:00:00 2001
-From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
-Date: Mon, 15 Oct 2012 16:43:41 +0530
-Subject: [PATCH] cfg80211: Disallow HT/WEP in IBSS mode
-
-Signed-off-by: Sujith Manoharan <c_manoha@qti.qualcomm.com>
----
- net/wireless/nl80211.c | 20 +++++++++++++++++---
- 1 file changed, 17 insertions(+), 3 deletions(-)
-
---- a/net/wireless/nl80211.c
-+++ b/net/wireless/nl80211.c
-@@ -690,7 +690,7 @@ static int nl80211_parse_key(struct genl
- 
- static struct cfg80211_cached_keys *
- nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
--		       struct nlattr *keys)
-+		       struct nlattr *keys, bool *no_ht)
- {
- 	struct key_parse parse;
- 	struct nlattr *key;
-@@ -733,6 +733,12 @@ nl80211_parse_connkeys(struct cfg80211_r
- 		result->params[parse.idx].key_len = parse.p.key_len;
- 		result->params[parse.idx].key = result->data[parse.idx];
- 		memcpy(result->data[parse.idx], parse.p.key, parse.p.key_len);
-+
-+		if (result->params[parse.idx].cipher == WLAN_CIPHER_SUITE_WEP40 ||
-+		    result->params[parse.idx].cipher == WLAN_CIPHER_SUITE_WEP104) {
-+			if (no_ht)
-+				*no_ht = true;
-+		}
- 	}
- 
- 	return result;
-@@ -5318,10 +5324,18 @@ static int nl80211_join_ibss(struct sk_b
- 		return -EINVAL;
- 
- 	if (ibss.privacy && info->attrs[NL80211_ATTR_KEYS]) {
-+		bool no_ht = false;
-+
- 		connkeys = nl80211_parse_connkeys(rdev,
--					info->attrs[NL80211_ATTR_KEYS]);
-+					  info->attrs[NL80211_ATTR_KEYS],
-+					  &no_ht);
- 		if (IS_ERR(connkeys))
- 			return PTR_ERR(connkeys);
-+
-+		if ((ibss.channel_type != NL80211_CHAN_NO_HT) && no_ht) {
-+			kfree(connkeys);
-+			return -EINVAL;
-+		}
- 	}
- 
- 	ibss.control_port =
-@@ -5621,7 +5635,7 @@ static int nl80211_connect(struct sk_buf
- 
- 	if (connect.privacy && info->attrs[NL80211_ATTR_KEYS]) {
- 		connkeys = nl80211_parse_connkeys(rdev,
--					info->attrs[NL80211_ATTR_KEYS]);
-+					  info->attrs[NL80211_ATTR_KEYS], NULL);
- 		if (IS_ERR(connkeys))
- 			return PTR_ERR(connkeys);
- 	}
-- 
1.7.4.1

