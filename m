Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59652 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab3LSRCA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 12:02:00 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 1/4] ath9k: move ath9k_debug_sync_cause out of ath9k_hw
Date: Thu, 19 Dec 2013 18:01:48 +0100
Message-Id: <1387472511-86178-1-git-send-email-nbd@openwrt.org> (sfid-20131219_180209_638730_8DDE23DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw should not depend on any ath9k data structures like ath_softc

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |  6 +++--
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |  6 +++--
 drivers/net/wireless/ath/ath9k/debug.c      | 41 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h      |  7 +++++
 drivers/net/wireless/ath/ath9k/hw-ops.h     |  5 ++--
 drivers/net/wireless/ath/ath9k/hw.c         | 42 -----------------------------
 drivers/net/wireless/ath/ath9k/hw.h         | 10 ++-----
 drivers/net/wireless/ath/ath9k/main.c       |  4 ++-
 8 files changed, 64 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index a366d6b..741b38d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -29,7 +29,8 @@ static void ar9002_hw_set_desc_link(void *ds, u32 ds_link)
 	((struct ath_desc*) ds)->ds_link = ds_link;
 }
 
-static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
+static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked,
+			      u32 *sync_cause_p)
 {
 	u32 isr = 0;
 	u32 mask2 = 0;
@@ -170,7 +171,8 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		return true;
 
 	if (sync_cause) {
-		ath9k_debug_sync_cause(common, sync_cause);
+		if (sync_cause_p)
+			*sync_cause_p = sync_cause;
 		fatal_int =
 			(sync_cause &
 			 (AR_INTR_SYNC_HOST1_FATAL | AR_INTR_SYNC_HOST1_PERR))
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 6eb8657..729ffbf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -175,7 +175,8 @@ static void ar9003_hw_set_desc_link(void *ds, u32 ds_link)
 	ads->ctl10 |= ar9003_calc_ptr_chksum(ads);
 }
 
-static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
+static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked,
+			      u32 *sync_cause_p)
 {
 	u32 isr = 0;
 	u32 mask2 = 0;
@@ -310,7 +311,8 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		ar9003_mci_get_isr(ah, masked);
 
 	if (sync_cause) {
-		ath9k_debug_sync_cause(common, sync_cause);
+		if (sync_cause_p)
+			*sync_cause_p = sync_cause;
 		fatal_int =
 			(sync_cause &
 			 (AR_INTR_SYNC_HOST1_FATAL | AR_INTR_SYNC_HOST1_PERR))
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 4c6f8b1..b041052 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -26,6 +26,47 @@
 #define REG_READ_D(_ah, _reg) \
 	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
 
+void ath9k_debug_sync_cause(struct ath_softc *sc, u32 sync_cause)
+{
+	if (sync_cause)
+		sc->debug.stats.istats.sync_cause_all++;
+	if (sync_cause & AR_INTR_SYNC_RTC_IRQ)
+		sc->debug.stats.istats.sync_rtc_irq++;
+	if (sync_cause & AR_INTR_SYNC_MAC_IRQ)
+		sc->debug.stats.istats.sync_mac_irq++;
+	if (sync_cause & AR_INTR_SYNC_EEPROM_ILLEGAL_ACCESS)
+		sc->debug.stats.istats.eeprom_illegal_access++;
+	if (sync_cause & AR_INTR_SYNC_APB_TIMEOUT)
+		sc->debug.stats.istats.apb_timeout++;
+	if (sync_cause & AR_INTR_SYNC_PCI_MODE_CONFLICT)
+		sc->debug.stats.istats.pci_mode_conflict++;
+	if (sync_cause & AR_INTR_SYNC_HOST1_FATAL)
+		sc->debug.stats.istats.host1_fatal++;
+	if (sync_cause & AR_INTR_SYNC_HOST1_PERR)
+		sc->debug.stats.istats.host1_perr++;
+	if (sync_cause & AR_INTR_SYNC_TRCV_FIFO_PERR)
+		sc->debug.stats.istats.trcv_fifo_perr++;
+	if (sync_cause & AR_INTR_SYNC_RADM_CPL_EP)
+		sc->debug.stats.istats.radm_cpl_ep++;
+	if (sync_cause & AR_INTR_SYNC_RADM_CPL_DLLP_ABORT)
+		sc->debug.stats.istats.radm_cpl_dllp_abort++;
+	if (sync_cause & AR_INTR_SYNC_RADM_CPL_TLP_ABORT)
+		sc->debug.stats.istats.radm_cpl_tlp_abort++;
+	if (sync_cause & AR_INTR_SYNC_RADM_CPL_ECRC_ERR)
+		sc->debug.stats.istats.radm_cpl_ecrc_err++;
+	if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT)
+		sc->debug.stats.istats.radm_cpl_timeout++;
+	if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT)
+		sc->debug.stats.istats.local_timeout++;
+	if (sync_cause & AR_INTR_SYNC_PM_ACCESS)
+		sc->debug.stats.istats.pm_access++;
+	if (sync_cause & AR_INTR_SYNC_MAC_AWAKE)
+		sc->debug.stats.istats.mac_awake++;
+	if (sync_cause & AR_INTR_SYNC_MAC_ASLEEP)
+		sc->debug.stats.istats.mac_asleep++;
+	if (sync_cause & AR_INTR_SYNC_MAC_SLEEP_ACCESS)
+		sc->debug.stats.istats.mac_sleep_access++;
+}
 
 static ssize_t ath9k_debugfs_read_buf(struct file *file, char __user *user_buf,
 				      size_t count, loff_t *ppos)
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 4f596dd..ec02d38 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -295,6 +295,8 @@ void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 void ath9k_debug_stat_ant(struct ath_softc *sc,
 			  struct ath_hw_antcomb_conf *div_ant_conf,
 			  int main_rssi_avg, int alt_rssi_avg);
+void ath9k_debug_sync_cause(struct ath_softc *sc, u32 sync_cause);
+
 #else
 
 #define RX_STAT_INC(c) /* NOP */
@@ -329,6 +331,11 @@ static inline void ath9k_debug_stat_ant(struct ath_softc *sc,
 
 }
 
+static inline void
+ath9k_debug_sync_cause(struct ath_softc *sc, u32 sync_cause)
+{
+}
+
 #endif /* CONFIG_ATH9K_DEBUGFS */
 
 #endif /* DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 4f9378d..cc58a8e 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -49,9 +49,10 @@ static inline bool ath9k_hw_calibrate(struct ath_hw *ah,
 	return ath9k_hw_ops(ah)->calibrate(ah, chan, rxchainmask, longcal);
 }
 
-static inline bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
+static inline bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked,
+				   u32 *sync_cause_p)
 {
-	return ath9k_hw_ops(ah)->get_isr(ah, masked);
+	return ath9k_hw_ops(ah)->get_isr(ah, masked, sync_cause_p);
 }
 
 static inline void ath9k_hw_set_txdesc(struct ath_hw *ah, void *ds,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0e548a4..a4b1ae0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -85,48 +85,6 @@ static void ath9k_hw_ani_cache_ini_regs(struct ath_hw *ah)
 
 #ifdef CONFIG_ATH9K_DEBUGFS
 
-void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause)
-{
-	struct ath_softc *sc = common->priv;
-	if (sync_cause)
-		sc->debug.stats.istats.sync_cause_all++;
-	if (sync_cause & AR_INTR_SYNC_RTC_IRQ)
-		sc->debug.stats.istats.sync_rtc_irq++;
-	if (sync_cause & AR_INTR_SYNC_MAC_IRQ)
-		sc->debug.stats.istats.sync_mac_irq++;
-	if (sync_cause & AR_INTR_SYNC_EEPROM_ILLEGAL_ACCESS)
-		sc->debug.stats.istats.eeprom_illegal_access++;
-	if (sync_cause & AR_INTR_SYNC_APB_TIMEOUT)
-		sc->debug.stats.istats.apb_timeout++;
-	if (sync_cause & AR_INTR_SYNC_PCI_MODE_CONFLICT)
-		sc->debug.stats.istats.pci_mode_conflict++;
-	if (sync_cause & AR_INTR_SYNC_HOST1_FATAL)
-		sc->debug.stats.istats.host1_fatal++;
-	if (sync_cause & AR_INTR_SYNC_HOST1_PERR)
-		sc->debug.stats.istats.host1_perr++;
-	if (sync_cause & AR_INTR_SYNC_TRCV_FIFO_PERR)
-		sc->debug.stats.istats.trcv_fifo_perr++;
-	if (sync_cause & AR_INTR_SYNC_RADM_CPL_EP)
-		sc->debug.stats.istats.radm_cpl_ep++;
-	if (sync_cause & AR_INTR_SYNC_RADM_CPL_DLLP_ABORT)
-		sc->debug.stats.istats.radm_cpl_dllp_abort++;
-	if (sync_cause & AR_INTR_SYNC_RADM_CPL_TLP_ABORT)
-		sc->debug.stats.istats.radm_cpl_tlp_abort++;
-	if (sync_cause & AR_INTR_SYNC_RADM_CPL_ECRC_ERR)
-		sc->debug.stats.istats.radm_cpl_ecrc_err++;
-	if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT)
-		sc->debug.stats.istats.radm_cpl_timeout++;
-	if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT)
-		sc->debug.stats.istats.local_timeout++;
-	if (sync_cause & AR_INTR_SYNC_PM_ACCESS)
-		sc->debug.stats.istats.pm_access++;
-	if (sync_cause & AR_INTR_SYNC_MAC_AWAKE)
-		sc->debug.stats.istats.mac_awake++;
-	if (sync_cause & AR_INTR_SYNC_MAC_ASLEEP)
-		sc->debug.stats.istats.mac_asleep++;
-	if (sync_cause & AR_INTR_SYNC_MAC_SLEEP_ACCESS)
-		sc->debug.stats.istats.mac_sleep_access++;
-}
 #endif
 
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 54932d8..6132ffe 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -667,7 +667,8 @@ struct ath_hw_ops {
 			  struct ath9k_channel *chan,
 			  u8 rxchainmask,
 			  bool longcal);
-	bool (*get_isr)(struct ath_hw *ah, enum ath9k_int *masked);
+	bool (*get_isr)(struct ath_hw *ah, enum ath9k_int *masked,
+			u32 *sync_cause_p);
 	void (*set_txdesc)(struct ath_hw *ah, void *ds,
 			   struct ath_tx_info *i);
 	int (*proc_txdesc)(struct ath_hw *ah, void *ds,
@@ -994,13 +995,6 @@ bool ath9k_hw_check_alive(struct ath_hw *ah);
 
 bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode);
 
-#ifdef CONFIG_ATH9K_DEBUGFS
-void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause);
-#else
-static inline void ath9k_debug_sync_cause(struct ath_common *common,
-					  u32 sync_cause) {}
-#endif
-
 /* Generic hw timer primitives */
 struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 					  void (*trigger)(void *),
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f160abc..cda342e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -541,6 +541,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	enum ath9k_int status;
+	u32 sync_cause;
 	bool sched = false;
 
 	/*
@@ -567,7 +568,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 	 * bits we haven't explicitly enabled so we mask the
 	 * value to insure we only process bits we requested.
 	 */
-	ath9k_hw_getisr(ah, &status);	/* NB: clears ISR too */
+	ath9k_hw_getisr(ah, &status, &sync_cause); /* NB: clears ISR too */
+	ath9k_debug_sync_cause(sc, sync_cause);
 	status &= ah->imask;	/* discard unasked-for bits */
 
 	/*
-- 
1.8.3.4 (Apple Git-47)

