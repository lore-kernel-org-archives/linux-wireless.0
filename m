Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56429 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbaCAUQ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:16:59 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 05/23] ath9k: move sc_flags to ath_common
Date: Sat,  1 Mar 2014 21:15:48 +0100
Message-Id: <1393704966-13985-6-git-send-email-linux@rempel-privat.de> (sfid-20140301_211704_271278_C8C61556)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we will need it for ath9k_htc, may be other drivers too

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath.h          | 10 ++++++++
 drivers/net/wireless/ath/ath9k/ahb.c    |  7 ++---
 drivers/net/wireless/ath/ath9k/ath9k.h  | 10 --------
 drivers/net/wireless/ath/ath9k/beacon.c | 18 +++++++------
 drivers/net/wireless/ath/ath9k/debug.c  |  2 +-
 drivers/net/wireless/ath/ath9k/link.c   | 16 +++++++-----
 drivers/net/wireless/ath/ath9k/main.c   | 45 ++++++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/mci.c    |  2 +-
 drivers/net/wireless/ath/ath9k/pci.c    |  8 +++---
 drivers/net/wireless/ath/ath9k/xmit.c   |  9 ++++---
 10 files changed, 70 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index d0e7ba8..e025ed5 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -56,6 +56,15 @@ enum ath_device_state {
 	ATH_HW_INITIALIZED,
 };
 
+enum ath_op_flags {
+	ATH_OP_INVALID,
+	ATH_OP_BEACONS,
+	ATH_OP_ANI_RUN,
+	ATH_OP_PRIM_STA_VIF,
+	ATH_OP_HW_RESET,
+	ATH_OP_SCANNING,
+};
+
 enum ath_bus_type {
 	ATH_PCI,
 	ATH_AHB,
@@ -130,6 +139,7 @@ struct ath_common {
 	struct ieee80211_hw *hw;
 	int debug_mask;
 	enum ath_device_state state;
+	unsigned long op_flags;
 
 	struct ath_ani ani;
 
diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 2dff276..a5684c3 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -82,6 +82,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	int irq;
 	int ret = 0;
 	struct ath_hw *ah;
+	struct ath_common *common;
 	char hw_name[64];
 
 	if (!dev_get_platdata(&pdev->dev)) {
@@ -124,9 +125,6 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	sc->mem = mem;
 	sc->irq = irq;
 
-	/* Will be cleared in ath9k_start() */
-	set_bit(SC_OP_INVALID, &sc->sc_flags);
-
 	ret = request_irq(irq, ath_isr, IRQF_SHARED, "ath9k", sc);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
@@ -144,6 +142,9 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	wiphy_info(hw->wiphy, "%s mem=0x%lx, irq=%d\n",
 		   hw_name, (unsigned long)mem, irq);
 
+	common = ath9k_hw_common(sc->sc_ah);
+	/* Will be cleared in ath9k_start() */
+	set_bit(ATH_OP_INVALID, &common->op_flags);
 	return 0;
 
  err_irq:
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b54bcae..7f87f33 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -688,15 +688,6 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
 #define MAX_GTT_CNT             5
 
-enum sc_op_flags {
-	SC_OP_INVALID,
-	SC_OP_BEACONS,
-	SC_OP_ANI_RUN,
-	SC_OP_PRIM_STA_VIF,
-	SC_OP_HW_RESET,
-	SC_OP_SCANNING,
-};
-
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
 #define PS_WAIT_FOR_CAB           BIT(1)
@@ -726,7 +717,6 @@ struct ath_softc {
 	struct completion paprd_complete;
 	wait_queue_head_t tx_wait;
 
-	unsigned long sc_flags;
 	unsigned long driver_data;
 
 	u8 gtt_cnt;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 02eb4f1..6372671 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -328,7 +328,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
 	int slot;
 
-	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags)) {
+	if (test_bit(ATH_OP_HW_RESET, &common->op_flags)) {
 		ath_dbg(common, RESET,
 			"reset work is pending, skip beaconing now\n");
 		return;
@@ -524,7 +524,7 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	u64 tsf;
 
 	/* No need to configure beacon if we are not associated */
-	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+	if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
 		ath_dbg(common, BEACON,
 			"STA is not yet associated..skipping beacon config\n");
 		return;
@@ -629,7 +629,7 @@ static void ath9k_beacon_config_adhoc(struct ath_softc *sc,
 	 * joiner case in IBSS mode.
 	 */
 	if (!conf->ibss_creator && conf->enable_beacon)
-		set_bit(SC_OP_BEACONS, &sc->sc_flags);
+		set_bit(ATH_OP_BEACONS, &common->op_flags);
 }
 
 static bool ath9k_allow_beacon_config(struct ath_softc *sc,
@@ -649,7 +649,7 @@ static bool ath9k_allow_beacon_config(struct ath_softc *sc,
 
 	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION) {
 		if ((vif->type == NL80211_IFTYPE_STATION) &&
-		    test_bit(SC_OP_BEACONS, &sc->sc_flags) &&
+		    test_bit(ATH_OP_BEACONS, &common->op_flags) &&
 		    !avp->primary_sta_vif) {
 			ath_dbg(common, CONFIG,
 				"Beacon already configured for a station interface\n");
@@ -700,6 +700,8 @@ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 {
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+        struct ath_hw *ah = sc->sc_ah;
+        struct ath_common *common = ath9k_hw_common(ah);
 	unsigned long flags;
 	bool skip_beacon = false;
 
@@ -712,7 +714,7 @@ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION) {
 		ath9k_cache_beacon_config(sc, bss_conf);
 		ath9k_set_beacon(sc);
-		set_bit(SC_OP_BEACONS, &sc->sc_flags);
+		set_bit(ATH_OP_BEACONS, &common->op_flags);
 		return;
 	}
 
@@ -751,13 +753,13 @@ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 		}
 
 		/*
-		 * Do not set the SC_OP_BEACONS flag for IBSS joiner mode
+		 * Do not set the ATH_OP_BEACONS flag for IBSS joiner mode
 		 * here, it is done in ath9k_beacon_config_adhoc().
 		 */
 		if (cur_conf->enable_beacon && !skip_beacon)
-			set_bit(SC_OP_BEACONS, &sc->sc_flags);
+			set_bit(ATH_OP_BEACONS, &common->op_flags);
 		else
-			clear_bit(SC_OP_BEACONS, &sc->sc_flags);
+			clear_bit(ATH_OP_BEACONS, &common->op_flags);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index ab7264c..c2ec62d 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -209,7 +209,7 @@ static ssize_t write_file_ani(struct file *file,
 	common->disable_ani = !ani;
 
 	if (common->disable_ani) {
-		clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+		clear_bit(ATH_OP_ANI_RUN, &common->op_flags);
 		ath_stop_ani(sc);
 	} else {
 		ath_check_ani(sc);
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 30dcef5..72a715f 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -115,13 +115,14 @@ void ath_hw_pll_work(struct work_struct *work)
 	u32 pll_sqsum;
 	struct ath_softc *sc = container_of(work, struct ath_softc,
 					    hw_pll_work.work);
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	/*
 	 * ensure that the PLL WAR is executed only
 	 * after the STA is associated (or) if the
 	 * beaconing had started in interfaces that
 	 * uses beacons.
 	 */
-	if (!test_bit(SC_OP_BEACONS, &sc->sc_flags))
+	if (!test_bit(ATH_OP_BEACONS, &common->op_flags))
 		return;
 
 	if (sc->tx99_state)
@@ -414,7 +415,7 @@ void ath_start_ani(struct ath_softc *sc)
 	unsigned long timestamp = jiffies_to_msecs(jiffies);
 
 	if (common->disable_ani ||
-	    !test_bit(SC_OP_ANI_RUN, &sc->sc_flags) ||
+	    !test_bit(ATH_OP_ANI_RUN, &common->op_flags) ||
 	    (sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
 		return;
 
@@ -438,6 +439,7 @@ void ath_stop_ani(struct ath_softc *sc)
 void ath_check_ani(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
 
 	/*
@@ -453,23 +455,23 @@ void ath_check_ani(struct ath_softc *sc)
 			 * Disable ANI only when there are no
 			 * associated stations.
 			 */
-			if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
+			if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags))
 				goto stop_ani;
 		}
 	} else if (ah->opmode == NL80211_IFTYPE_STATION) {
-		if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
+		if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags))
 			goto stop_ani;
 	}
 
-	if (!test_bit(SC_OP_ANI_RUN, &sc->sc_flags)) {
-		set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+	if (!test_bit(ATH_OP_ANI_RUN, &common->op_flags)) {
+		set_bit(ATH_OP_ANI_RUN, &common->op_flags);
 		ath_start_ani(sc);
 	}
 
 	return;
 
 stop_ani:
-	clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+	clear_bit(ATH_OP_ANI_RUN, &common->op_flags);
 	ath_stop_ani(sc);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 81f8328..c86f384 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -229,16 +229,16 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	ath9k_cmn_update_txpow(ah, sc->curtxpow,
 			       sc->config.txpowlimit, &sc->curtxpow);
 
-	clear_bit(SC_OP_HW_RESET, &sc->sc_flags);
+	clear_bit(ATH_OP_HW_RESET, &common->op_flags);
 	ath9k_hw_set_interrupts(ah);
 	ath9k_hw_enable_interrupts(ah);
 
 	if (!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL) && start) {
-		if (!test_bit(SC_OP_BEACONS, &sc->sc_flags))
+		if (!test_bit(ATH_OP_BEACONS, &common->op_flags))
 			goto work;
 
 		if (ah->opmode == NL80211_IFTYPE_STATION &&
-		    test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+		    test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
 			spin_lock_irqsave(&sc->sc_pm_lock, flags);
 			sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
 			spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
@@ -336,7 +336,7 @@ static int ath_set_channel(struct ath_softc *sc, struct cfg80211_chan_def *chand
 	int old_pos = -1;
 	int r;
 
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags))
+	if (test_bit(ATH_OP_INVALID, &common->op_flags))
 		return -EIO;
 
 	offchannel = !!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL);
@@ -402,7 +402,7 @@ static int ath_set_channel(struct ath_softc *sc, struct cfg80211_chan_def *chand
 			chan->center_freq);
 	} else {
 		/* perform spectral scan if requested. */
-		if (test_bit(SC_OP_SCANNING, &sc->sc_flags) &&
+		if (test_bit(ATH_OP_SCANNING, &common->op_flags) &&
 			sc->spectral_mode == SPECTRAL_CHANSCAN)
 			ath9k_spectral_scan_trigger(hw);
 	}
@@ -566,6 +566,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 
 	struct ath_softc *sc = dev;
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	enum ath9k_int status;
 	u32 sync_cause = 0;
 	bool sched = false;
@@ -575,7 +576,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 	 * touch anything. Note this can happen early
 	 * on if the IRQ is shared.
 	 */
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags))
+	if (test_bit(ATH_OP_INVALID, &common->op_flags))
 		return IRQ_NONE;
 
 	/* shared irq, not for us */
@@ -583,7 +584,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (!ath9k_hw_intrpend(ah))
 		return IRQ_NONE;
 
-	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags)) {
+	if (test_bit(ATH_OP_HW_RESET, &common->op_flags)) {
 		ath9k_hw_kill_interrupts(ah);
 		return IRQ_HANDLED;
 	}
@@ -684,10 +685,11 @@ int ath_reset(struct ath_softc *sc)
 
 void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 #ifdef CONFIG_ATH9K_DEBUGFS
 	RESET_STAT_INC(sc, type);
 #endif
-	set_bit(SC_OP_HW_RESET, &sc->sc_flags);
+	set_bit(ATH_OP_HW_RESET, &common->op_flags);
 	ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 }
 
@@ -768,7 +770,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	ath_mci_enable(sc);
 
-	clear_bit(SC_OP_INVALID, &sc->sc_flags);
+	clear_bit(ATH_OP_INVALID, &common->op_flags);
 	sc->sc_ah->is_monitoring = false;
 
 	if (!ath_complete_reset(sc, false))
@@ -885,7 +887,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	ath_cancel_work(sc);
 
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
+	if (test_bit(ATH_OP_INVALID, &common->op_flags)) {
 		ath_dbg(common, ANY, "Device not present\n");
 		mutex_unlock(&sc->mutex);
 		return;
@@ -940,7 +942,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	ath9k_ps_restore(sc);
 
-	set_bit(SC_OP_INVALID, &sc->sc_flags);
+	set_bit(ATH_OP_INVALID, &common->op_flags);
 	sc->ps_idle = prev_idle;
 
 	mutex_unlock(&sc->mutex);
@@ -1081,7 +1083,7 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 	 */
 	if (ah->opmode == NL80211_IFTYPE_STATION &&
 	    old_opmode == NL80211_IFTYPE_AP &&
-	    test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+	    test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
 		ieee80211_iterate_active_interfaces_atomic(
 			sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
 			ath9k_sta_vif_iter, sc);
@@ -1590,7 +1592,7 @@ static void ath9k_set_assoc_state(struct ath_softc *sc,
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	unsigned long flags;
 
-	set_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
+	set_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
 	avp->primary_sta_vif = true;
 
 	/*
@@ -1625,8 +1627,9 @@ static void ath9k_bss_assoc_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 {
 	struct ath_softc *sc = data;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-	if (test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
+	if (test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags))
 		return;
 
 	if (bss_conf->assoc)
@@ -1657,18 +1660,18 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			bss_conf->bssid, bss_conf->assoc);
 
 		if (avp->primary_sta_vif && !bss_conf->assoc) {
-			clear_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
+			clear_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
 			avp->primary_sta_vif = false;
 
 			if (ah->opmode == NL80211_IFTYPE_STATION)
-				clear_bit(SC_OP_BEACONS, &sc->sc_flags);
+				clear_bit(ATH_OP_BEACONS, &common->op_flags);
 		}
 
 		ieee80211_iterate_active_interfaces_atomic(
 			sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
 			ath9k_bss_assoc_iter, sc);
 
-		if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags) &&
+		if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags) &&
 		    ah->opmode == NL80211_IFTYPE_STATION) {
 			memset(common->curbssid, 0, ETH_ALEN);
 			common->curaid = 0;
@@ -1897,7 +1900,7 @@ static void ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 		return;
 	}
 
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
+	if (test_bit(ATH_OP_INVALID, &common->op_flags)) {
 		ath_dbg(common, ANY, "Device not present\n");
 		mutex_unlock(&sc->mutex);
 		return;
@@ -2070,13 +2073,15 @@ static int ath9k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
 static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
-	set_bit(SC_OP_SCANNING, &sc->sc_flags);
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	set_bit(ATH_OP_SCANNING, &common->op_flags);
 }
 
 static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
-	clear_bit(SC_OP_SCANNING, &sc->sc_flags);
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	clear_bit(ATH_OP_SCANNING, &common->op_flags);
 }
 
 static void ath9k_channel_switch_beacon(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 71799fc..a0dbcc4 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -555,7 +555,7 @@ void ath_mci_intr(struct ath_softc *sc)
 		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_GPM;
 
 		while (more_data == MCI_GPM_MORE) {
-			if (test_bit(SC_OP_HW_RESET, &sc->sc_flags))
+			if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
 				return;
 
 			pgpm = mci->gpm_buf.bf_addr;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 55724b0..25304ad 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -784,6 +784,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
+	struct ath_common *common;
 	u8 csz;
 	u32 val;
 	int ret = 0;
@@ -858,9 +859,6 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc->mem = pcim_iomap_table(pdev)[0];
 	sc->driver_data = id->driver_data;
 
-	/* Will be cleared in ath9k_start() */
-	set_bit(SC_OP_INVALID, &sc->sc_flags);
-
 	ret = request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath9k", sc);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
@@ -879,6 +877,10 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	wiphy_info(hw->wiphy, "%s mem=0x%lx, irq=%d\n",
 		   hw_name, (unsigned long)sc->mem, pdev->irq);
 
+	/* Will be cleared in ath9k_start() */
+	common = ath9k_hw_common(sc->sc_ah);
+	set_bit(ATH_OP_INVALID, &common->op_flags);
+
 	return 0;
 
 err_init:
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8b31e2e..54af680 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1769,7 +1769,7 @@ bool ath_drain_all_txq(struct ath_softc *sc)
 	int i;
 	u32 npend = 0;
 
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags))
+	if (test_bit(ATH_OP_INVALID, &common->op_flags))
 		return true;
 
 	ath9k_hw_abort_tx_dma(ah);
@@ -1817,11 +1817,12 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
  */
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_ac *ac, *last_ac;
 	struct ath_atx_tid *tid, *last_tid;
 	bool sent = false;
 
-	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags) ||
+	if (test_bit(ATH_OP_HW_RESET, &common->op_flags) ||
 	    list_empty(&txq->axq_acq))
 		return;
 
@@ -2470,7 +2471,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 
 	ath_txq_lock(sc, txq);
 	for (;;) {
-		if (test_bit(SC_OP_HW_RESET, &sc->sc_flags))
+		if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
 			break;
 
 		if (list_empty(&txq->axq_q)) {
@@ -2553,7 +2554,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 	int status;
 
 	for (;;) {
-		if (test_bit(SC_OP_HW_RESET, &sc->sc_flags))
+		if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
 			break;
 
 		status = ath9k_hw_txprocdesc(ah, NULL, (void *)&ts);
-- 
1.9.0

