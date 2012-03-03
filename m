Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40168 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab2CCORS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 09:17:18 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/5] ath9k: make MAC sample statistics optional
Date: Sat,  3 Mar 2012 15:17:03 +0100
Message-Id: <1330784226-65563-2-git-send-email-nbd@openwrt.org> (sfid-20120303_151725_938527_C65842D5)
In-Reply-To: <1330784226-65563-1-git-send-email-nbd@openwrt.org>
References: <1330784226-65563-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They're more expensive than some of the other debug options and only used
in very rare situations, so it sometimes makes sense to disable them while
leaving in debugfs support.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/Kconfig |    8 ++++++++
 drivers/net/wireless/ath/ath9k/debug.c |   10 ++++++++++
 drivers/net/wireless/ath/ath9k/debug.h |   20 +++++++++++++++-----
 drivers/net/wireless/ath/ath9k/init.c  |    4 +++-
 4 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 595a272..e507e78 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -81,6 +81,14 @@ config ATH9K_DFS_CERTIFIED
 	  developed. At this point enabling this option won't do anything
 	  except increase code size.
 
+config ATH9K_MAC_DEBUG
+	bool "Atheros MAC statistics"
+	depends on ATH9K_DEBUGFS
+	default y
+	---help---
+	  This option enables collection of statistics for Rx/Tx status
+	  data and some other MAC related statistics
+
 config ATH9K_RATE_CONTROL
 	bool "Atheros ath9k rate control"
 	depends on ATH9K
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 228c181..03a4740 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -818,6 +818,7 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 	if (ts->ts_flags & ATH9K_TX_DELIM_UNDERRUN)
 		TX_STAT_INC(qnum, delim_underrun);
 
+#ifdef CONFIG_ATH9K_MAC_DEBUG
 	spin_lock(&sc->debug.samp_lock);
 	TX_SAMP_DBG(jiffies) = jiffies;
 	TX_SAMP_DBG(rssi_ctl0) = ts->ts_rssi_ctl0;
@@ -844,6 +845,7 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 
 	sc->debug.tsidx = (sc->debug.tsidx + 1) % ATH_DBG_MAX_SAMPLES;
 	spin_unlock(&sc->debug.samp_lock);
+#endif
 
 #undef TX_SAMP_DBG
 }
@@ -1019,6 +1021,7 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 
 	sc->debug.stats.rxstats.rs_antenna = rs->rs_antenna;
 
+#ifdef CONFIG_ATH9K_MAC_DEBUG
 	spin_lock(&sc->debug.samp_lock);
 	RX_SAMP_DBG(jiffies) = jiffies;
 	RX_SAMP_DBG(rssi_ctl0) = rs->rs_rssi_ctl0;
@@ -1035,6 +1038,8 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 	sc->debug.rsidx = (sc->debug.rsidx + 1) % ATH_DBG_MAX_SAMPLES;
 	spin_unlock(&sc->debug.samp_lock);
 
+#endif
+
 #undef RX_STAT_INC
 #undef RX_PHY_ERR_INC
 #undef RX_SAMP_DBG
@@ -1278,6 +1283,8 @@ static const struct file_operations fops_modal_eeprom = {
 	.llseek = default_llseek,
 };
 
+#ifdef CONFIG_ATH9K_MAC_DEBUG
+
 void ath9k_debug_samp_bb_mac(struct ath_softc *sc)
 {
 #define ATH_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].c)
@@ -1551,6 +1558,7 @@ static const struct file_operations fops_samps = {
 	.llseek = default_llseek,
 };
 
+#endif
 
 int ath9k_init_debug(struct ath_hw *ah)
 {
@@ -1604,8 +1612,10 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_base_eeprom);
 	debugfs_create_file("modal_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_modal_eeprom);
+#ifdef CONFIG_ATH9K_MAC_DEBUG
 	debugfs_create_file("samples", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_samps);
+#endif
 
 	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 776a24a..7a51958 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -235,16 +235,17 @@ struct ath9k_debug {
 	struct dentry *debugfs_phy;
 	u32 regidx;
 	struct ath_stats stats;
+#ifdef CONFIG_ATH9K_MAC_DEBUG
 	spinlock_t samp_lock;
 	struct ath_dbg_bb_mac_samp bb_mac_samp[ATH_DBG_MAX_SAMPLES];
 	u8 sampidx;
 	u8 tsidx;
 	u8 rsidx;
+#endif
 };
 
 int ath9k_init_debug(struct ath_hw *ah);
 
-void ath9k_debug_samp_bb_mac(struct ath_softc *sc);
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		       struct ath_tx_status *ts, struct ath_txq *txq,
@@ -258,10 +259,6 @@ static inline int ath9k_init_debug(struct ath_hw *ah)
 	return 0;
 }
 
-static inline void ath9k_debug_samp_bb_mac(struct ath_softc *sc)
-{
-}
-
 static inline void ath_debug_stat_interrupt(struct ath_softc *sc,
 					    enum ath9k_int status)
 {
@@ -282,4 +279,17 @@ static inline void ath_debug_stat_rx(struct ath_softc *sc,
 
 #endif /* CONFIG_ATH9K_DEBUGFS */
 
+#ifdef CONFIG_ATH9K_MAC_DEBUG
+
+void ath9k_debug_samp_bb_mac(struct ath_softc *sc);
+
+#else
+
+static inline void ath9k_debug_samp_bb_mac(struct ath_softc *sc)
+{
+}
+
+#endif
+
+
 #endif /* DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index d8b0596..944e9b5 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -555,9 +555,11 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	mutex_init(&sc->mutex);
 #ifdef CONFIG_ATH9K_DEBUGFS
 	spin_lock_init(&sc->nodes_lock);
-	spin_lock_init(&sc->debug.samp_lock);
 	INIT_LIST_HEAD(&sc->nodes);
 #endif
+#ifdef CONFIG_ATH9K_MAC_DEBUG
+	spin_lock_init(&sc->debug.samp_lock);
+#endif
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
 	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
 		     (unsigned long)sc);
-- 
1.7.3.2

