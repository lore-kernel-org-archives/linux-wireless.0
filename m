Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46388 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2I0Gwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 02:52:42 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20579.63353.213750.914819@gargle.gargle.HOWL> (sfid-20120927_085246_055966_053EE37C)
Date: Thu, 27 Sep 2012 12:21:37 +0530
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Subject: [PATCH 5/5] compat-drivers: Add a few pending patches for AR9565
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 ...dle-errors-properly-in-MCI-initialization.patch | 128 +++++++++++++++++++++
 ...-debugfs-file-to-adjust-antenna-diversity.patch |  99 ++++++++++++++++
 ...-ath9k-Fix-chainmask-selection-for-AR9462.patch |  43 +++++++
 .../0004-ath9k-Enable-MCI-for-AR9565.patch         |  63 ++++++++++
 4 files changed, 333 insertions(+)
 create mode 100644 linux-next-pending/0001-ath9k-Handle-errors-properly-in-MCI-initialization.patch
 create mode 100644 linux-next-pending/0002-ath9k-Add-a-debugfs-file-to-adjust-antenna-diversity.patch
 create mode 100644 linux-next-pending/0003-ath9k-Fix-chainmask-selection-for-AR9462.patch
 create mode 100644 linux-next-pending/0004-ath9k-Enable-MCI-for-AR9565.patch

diff --git a/linux-next-pending/0001-ath9k-Handle-errors-properly-in-MCI-initialization.patch b/linux-next-pending/0001-ath9k-Handle-errors-properly-in-MCI-initialization.patch
new file mode 100644
index 0000000..33b9b25
--- /dev/null
+++ b/linux-next-pending/0001-ath9k-Handle-errors-properly-in-MCI-initialization.patch
@@ -0,0 +1,128 @@
+From 7eb8fcf8b7da8183ca2e0e851b2d22852eed8ef6 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 21 Sep 2012 10:37:19 +0530
+Subject: [PATCH 1/4] ath9k: Handle errors properly in MCI initialization
+
+The MCI initialization path has various points of failures,
+handle these to ensure that we bail out correctly in such
+cases.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c | 21 +++++++++++----------
+ drivers/net/wireless/ath/ath9k/ar9003_mci.h |  8 ++++----
+ drivers/net/wireless/ath/ath9k/mci.c        | 11 ++++++++---
+ 3 files changed, 23 insertions(+), 17 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -813,8 +813,8 @@ static void ar9003_mci_osla_setup(struct
+ 		      AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN, 1);
+ }
+ 
+-void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
+-		      bool is_full_sleep)
++int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
++		     bool is_full_sleep)
+ {
+ 	struct ath_common *common = ath9k_hw_common(ah);
+ 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+@@ -824,14 +824,13 @@ void ar9003_mci_reset(struct ath_hw *ah,
+ 		is_full_sleep, is_2g);
+ 
+ 	if (!mci->gpm_addr && !mci->sched_addr) {
+-		ath_dbg(common, MCI,
+-			"MCI GPM and schedule buffers are not allocated\n");
+-		return;
++		ath_err(common, "MCI GPM and schedule buffers are not allocated\n");
++		return -ENOMEM;
+ 	}
+ 
+ 	if (REG_READ(ah, AR_BTCOEX_CTRL) == 0xdeadbeef) {
+-		ath_dbg(common, MCI, "BTCOEX control register is dead\n");
+-		return;
++		ath_err(common, "BTCOEX control register is dead\n");
++		return -EINVAL;
+ 	}
+ 
+ 	/* Program MCI DMA related registers */
+@@ -913,6 +912,8 @@ void ar9003_mci_reset(struct ath_hw *ah,
+ 
+ 	if (en_int)
+ 		ar9003_mci_enable_interrupt(ah);
++
++	return 0;
+ }
+ 
+ void ar9003_mci_stop_bt(struct ath_hw *ah, bool save_fullsleep)
+@@ -1144,8 +1145,8 @@ void ar9003_mci_init_cal_done(struct ath
+ 	ar9003_mci_send_message(ah, MCI_GPM, 0, pld, 16, true, false);
+ }
+ 
+-void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
+-		      u16 len, u32 sched_addr)
++int ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
++		     u16 len, u32 sched_addr)
+ {
+ 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+ 
+@@ -1154,7 +1155,7 @@ void ar9003_mci_setup(struct ath_hw *ah,
+ 	mci->gpm_len = len;
+ 	mci->sched_addr = sched_addr;
+ 
+-	ar9003_mci_reset(ah, true, true, true);
++	return ar9003_mci_reset(ah, true, true, true);
+ }
+ EXPORT_SYMBOL(ar9003_mci_setup);
+ 
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+@@ -249,8 +249,8 @@ bool ar9003_mci_send_message(struct ath_
+ 			     u32 *payload, u8 len, bool wait_done,
+ 			     bool check_bt);
+ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type);
+-void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
+-		      u16 len, u32 sched_addr);
++int ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
++		     u16 len, u32 sched_addr);
+ void ar9003_mci_cleanup(struct ath_hw *ah);
+ void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
+ 			      u32 *rx_msg_intr);
+@@ -272,8 +272,8 @@ void ar9003_mci_check_bt(struct ath_hw *
+ bool ar9003_mci_start_reset(struct ath_hw *ah, struct ath9k_channel *chan);
+ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
+ 			 struct ath9k_hw_cal_data *caldata);
+-void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
+-		      bool is_full_sleep);
++int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
++		     bool is_full_sleep);
+ void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked);
+ void ar9003_mci_bt_gain_ctrl(struct ath_hw *ah);
+ void ar9003_mci_set_power_awake(struct ath_hw *ah);
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -392,6 +392,7 @@ int ath_mci_setup(struct ath_softc *sc)
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+ 	struct ath_mci_coex *mci = &sc->mci_coex;
+ 	struct ath_mci_buf *buf = &mci->sched_buf;
++	int ret;
+ 
+ 	buf->bf_addr = dma_alloc_coherent(sc->dev,
+ 				  ATH_MCI_SCHED_BUF_SIZE + ATH_MCI_GPM_BUF_SIZE,
+@@ -411,9 +412,13 @@ int ath_mci_setup(struct ath_softc *sc)
+ 	mci->gpm_buf.bf_addr = (u8 *)mci->sched_buf.bf_addr + mci->sched_buf.bf_len;
+ 	mci->gpm_buf.bf_paddr = mci->sched_buf.bf_paddr + mci->sched_buf.bf_len;
+ 
+-	ar9003_mci_setup(sc->sc_ah, mci->gpm_buf.bf_paddr,
+-			 mci->gpm_buf.bf_addr, (mci->gpm_buf.bf_len >> 4),
+-			 mci->sched_buf.bf_paddr);
++	ret = ar9003_mci_setup(sc->sc_ah, mci->gpm_buf.bf_paddr,
++			       mci->gpm_buf.bf_addr, (mci->gpm_buf.bf_len >> 4),
++			       mci->sched_buf.bf_paddr);
++	if (ret) {
++		ath_err(common, "Failed to initialize MCI\n");
++		return ret;
++	}
+ 
+ 	INIT_WORK(&sc->mci_work, ath9k_mci_work);
+ 	ath_dbg(common, MCI, "MCI Initialized\n");
diff --git a/linux-next-pending/0002-ath9k-Add-a-debugfs-file-to-adjust-antenna-diversity.patch b/linux-next-pending/0002-ath9k-Add-a-debugfs-file-to-adjust-antenna-diversity.patch
new file mode 100644
index 0000000..bd0ee37
--- /dev/null
+++ b/linux-next-pending/0002-ath9k-Add-a-debugfs-file-to-adjust-antenna-diversity.patch
@@ -0,0 +1,99 @@
+From ee97c9a750b560a889a2ee1716c92e8da19168e6 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 21 Sep 2012 12:27:20 +0530
+Subject: [PATCH 2/4] ath9k: Add a debugfs file to adjust antenna diversity
+
+Location: /<debugfs>/ieee80211/phy#/ath9k/diversity
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_phy.c |  2 +-
+ drivers/net/wireless/ath/ath9k/debug.c      | 55 +++++++++++++++++++++++++++--
+ 2 files changed, 54 insertions(+), 3 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+@@ -1360,7 +1360,7 @@ static void ar9003_hw_antctrl_shared_cha
+ 	if (enable) {
+ 		REG_SET_BIT(ah, AR_PHY_MC_GAIN_CTRL,
+ 			    (1 << AR_PHY_ANT_SW_RX_PROT_S));
+-		if (IS_CHAN_2GHZ(ah->curchan))
++		if (ah->curchan && IS_CHAN_2GHZ(ah->curchan))
+ 			REG_SET_BIT(ah, AR_PHY_RESTART,
+ 				    AR_PHY_RESTART_ENABLE_DIV_M2FLAG);
+ 		REG_SET_BIT(ah, AR_BTCOEX_WL_LNADIV,
+--- a/drivers/net/wireless/ath/ath9k/debug.c
++++ b/drivers/net/wireless/ath/ath9k/debug.c
+@@ -222,6 +222,57 @@ static const struct file_operations fops
+ 	.llseek = default_llseek,
+ };
+ 
++static ssize_t read_file_ant_diversity(struct file *file, char __user *user_buf,
++				       size_t count, loff_t *ppos)
++{
++	struct ath_softc *sc = file->private_data;
++	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
++	char buf[32];
++	unsigned int len;
++
++	len = sprintf(buf, "%d\n", common->antenna_diversity);
++	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
++}
++
++static ssize_t write_file_ant_diversity(struct file *file,
++					const char __user *user_buf,
++					size_t count, loff_t *ppos)
++{
++	struct ath_softc *sc = file->private_data;
++	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
++	unsigned long antenna_diversity;
++	char buf[32];
++	ssize_t len;
++
++	len = min(count, sizeof(buf) - 1);
++	if (copy_from_user(buf, user_buf, len))
++		return -EFAULT;
++
++	if (!AR_SREV_9565(sc->sc_ah))
++		goto exit;
++
++	buf[len] = '\0';
++	if (strict_strtoul(buf, 0, &antenna_diversity))
++		return -EINVAL;
++
++	common->antenna_diversity = !!antenna_diversity;
++	ath9k_ps_wakeup(sc);
++	ath_ant_comb_update(sc);
++	ath_dbg(common, CONFIG, "Antenna diversity: %d\n",
++		common->antenna_diversity);
++	ath9k_ps_restore(sc);
++exit:
++	return count;
++}
++
++static const struct file_operations fops_ant_diversity = {
++	.read = read_file_ant_diversity,
++	.write = write_file_ant_diversity,
++	.open = simple_open,
++	.owner = THIS_MODULE,
++	.llseek = default_llseek,
++};
++
+ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
+ 			     size_t count, loff_t *ppos)
+ {
+@@ -1601,12 +1652,12 @@ int ath9k_init_debug(struct ath_hw *ah)
+ 	debugfs_create_file("samples", S_IRUSR, sc->debug.debugfs_phy, sc,
+ 			    &fops_samps);
+ #endif
+-
+ 	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
+ 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
+-
+ 	debugfs_create_u32("gpio_val", S_IRUSR | S_IWUSR,
+ 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_val);
++	debugfs_create_file("diversity", S_IRUSR | S_IWUSR,
++			    sc->debug.debugfs_phy, sc, &fops_ant_diversity);
+ 
+ 	return 0;
+ }
diff --git a/linux-next-pending/0003-ath9k-Fix-chainmask-selection-for-AR9462.patch b/linux-next-pending/0003-ath9k-Fix-chainmask-selection-for-AR9462.patch
new file mode 100644
index 0000000..b349f9b
--- /dev/null
+++ b/linux-next-pending/0003-ath9k-Fix-chainmask-selection-for-AR9462.patch
@@ -0,0 +1,43 @@
+From c18c8444655d7c32d11fb7715b81ae02e976ac1d Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Wed, 26 Sep 2012 12:09:40 +0530
+Subject: [PATCH 3/4] ath9k: Fix chainmask selection for AR9462
+
+Force chain 1 to be used for CCK rates since the target power
+table stored in EEPROM is too high to transmit with both chains.
+This is needed to avoid regulatory violation.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h | 2 ++
+ drivers/net/wireless/ath/ath9k/xmit.c  | 4 ++++
+ 2 files changed, 6 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -173,6 +173,8 @@ void ath_descdma_cleanup(struct ath_soft
+ 
+ #define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
+ 
++#define IS_CCK_RATE(rate) ((rate >= 0x18) && (rate <= 0x1e))
++
+ #define ATH_TX_COMPLETE_POLL_INT	1000
+ 
+ enum ATH_AGGR_STATUS {
+--- a/drivers/net/wireless/ath/ath9k/xmit.c
++++ b/drivers/net/wireless/ath/ath9k/xmit.c
+@@ -1819,10 +1819,14 @@ u8 ath_txchainmask_reduction(struct ath_
+ {
+ 	struct ath_hw *ah = sc->sc_ah;
+ 	struct ath9k_channel *curchan = ah->curchan;
++
+ 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) &&
+ 	    (curchan->channelFlags & CHANNEL_5GHZ) &&
+ 	    (chainmask == 0x7) && (rate < 0x90))
+ 		return 0x3;
++	else if (AR_SREV_9462(ah) && ath9k_hw_btcoex_is_enabled(ah) &&
++		 IS_CCK_RATE(rate))
++		return 0x2;
+ 	else
+ 		return chainmask;
+ }
diff --git a/linux-next-pending/0004-ath9k-Enable-MCI-for-AR9565.patch b/linux-next-pending/0004-ath9k-Enable-MCI-for-AR9565.patch
new file mode 100644
index 0000000..340f42f
--- /dev/null
+++ b/linux-next-pending/0004-ath9k-Enable-MCI-for-AR9565.patch
@@ -0,0 +1,63 @@
+From 1748b1ebc5e8f7ba9a014766fefab969c45d3142 Mon Sep 17 00:00:00 2001
+From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+Date: Wed, 26 Sep 2012 11:34:26 +0000
+Subject: [PATCH 4/4] ath9k: Enable MCI for AR9565
+
+Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/btcoex.c | 6 +++---
+ drivers/net/wireless/ath/ath9k/gpio.c   | 2 +-
+ drivers/net/wireless/ath/ath9k/wow.c    | 2 +-
+ 3 files changed, 5 insertions(+), 5 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/btcoex.c
++++ b/drivers/net/wireless/ath/ath9k/btcoex.c
+@@ -282,7 +282,7 @@ void ath9k_hw_btcoex_enable(struct ath_h
+ 		ath9k_hw_btcoex_enable_2wire(ah);
+ 		break;
+ 	case ATH_BTCOEX_CFG_3WIRE:
+-		if (AR_SREV_9462(ah)) {
++		if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+ 			ath9k_hw_btcoex_enable_mci(ah);
+ 			return;
+ 		}
+@@ -304,7 +304,7 @@ void ath9k_hw_btcoex_disable(struct ath_
+ 	int i;
+ 
+ 	btcoex_hw->enabled = false;
+-	if (AR_SREV_9462(ah)) {
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+ 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
+ 		for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
+ 			REG_WRITE(ah, AR_MCI_COEX_WL_WEIGHTS(i),
+@@ -339,7 +339,7 @@ static void ar9003_btcoex_bt_stomp(struc
+ 	const u32 *weight = ar9003_wlan_weights[stomp_type];
+ 	int i;
+ 
+-	if (AR_SREV_9462(ah)) {
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+ 		if ((stomp_type == ATH_BTCOEX_STOMP_LOW) &&
+ 		    btcoex->mci.stomp_ftp)
+ 			stomp_type = ATH_BTCOEX_STOMP_LOW_FTP;
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -412,7 +412,7 @@ void ath9k_stop_btcoex(struct ath_softc
+ 		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
+ 			ath9k_btcoex_timer_pause(sc);
+ 		ath9k_hw_btcoex_disable(ah);
+-		if (AR_SREV_9462(ah))
++		if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
+ 			ath_mci_flush_profile(&sc->btcoex.mci);
+ 	}
+ }
+--- a/drivers/net/wireless/ath/ath9k/wow.c
++++ b/drivers/net/wireless/ath/ath9k/wow.c
+@@ -497,7 +497,7 @@ void ath9k_hw_wow_enable(struct ath_hw *
+ 
+ 	REG_RMW(ah, AR_PCIE_PM_CTRL, set, clr);
+ 
+-	if (AR_SREV_9462(ah)) {
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+ 		/*
+ 		 * this is needed to prevent the chip waking up
+ 		 * the host within 3-4 seconds with certain
-- 
1.7.12.1

