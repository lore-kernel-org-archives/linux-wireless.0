Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51762 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2DDEV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 00:21:29 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] ath9k:  Gather and report IRQ sync_cause errors.
Date: Tue,  3 Apr 2012 21:20:50 -0700
Message-Id: <1333513250-30478-1-git-send-email-greearb@candelatech.com> (sfid-20120404_062203_613828_9FC21B6A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Report all defined sync_cause errors in debugfs
to aid with debugging.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Lots of changes.  Report all sync-cause errors instead of just one.
     Use method to gather them instead of individual macros.
     Increase width of the interrupts debugfs columns to 21 chars to fit labels.

   I do not know what all of these really mean, so didn't add comments to the
   ath_interrupt_stats kdoc header.  Someone with docs might be able to fill
   that in.

:100644 100644 7b6417b... 87ee5b1... M	drivers/net/wireless/ath/ath9k/ar9002_mac.c
:100644 100644 09b8c9d... 666de70... M	drivers/net/wireless/ath/ath9k/ar9003_mac.c
:100644 100644 43d84db... 83f0201... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 a2eb043... 301266f... M	drivers/net/wireless/ath/ath9k/debug.h
:100644 100644 87db1ee... d116c56... M	drivers/net/wireless/ath/ath9k/hw.c
:100644 100644 c8261d4... d1e8ad97.. M	drivers/net/wireless/ath/ath9k/hw.h
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    2 +
 drivers/net/wireless/ath/ath9k/debug.c      |  169 +++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/debug.h      |   23 ++++
 drivers/net/wireless/ath/ath9k/hw.c         |   49 ++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |    6 +
 6 files changed, 199 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 7b6417b..87ee5b1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -136,6 +136,7 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	}
 
 	if (sync_cause) {
+		ath9k_debug_sync_cause(common, sync_cause);
 		fatal_int =
 			(sync_cause &
 			 (AR_INTR_SYNC_HOST1_FATAL | AR_INTR_SYNC_HOST1_PERR))
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 09b8c9d..666de70 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -326,6 +326,8 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	}
 
 	if (sync_cause) {
+		ath9k_debug_sync_cause(common, sync_cause);
+
 		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
 			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
 			REG_WRITE(ah, AR_RC, 0);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 43d84db..83f0201 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -385,63 +385,130 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
-	char buf[512];
 	unsigned int len = 0;
+	int rv;
+	int mxlen = 4000;
+	char *buf = kmalloc(mxlen, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
-		len += snprintf(buf + len, sizeof(buf) - len,
-			"%8s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);
-		len += snprintf(buf + len, sizeof(buf) - len,
-			"%8s: %10u\n", "RXHP", sc->debug.stats.istats.rxhp);
-		len += snprintf(buf + len, sizeof(buf) - len,
-			"%8s: %10u\n", "WATCHDOG",
+		len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);
+		len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "RXHP", sc->debug.stats.istats.rxhp);
+		len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "WATCHDOG",
 			sc->debug.stats.istats.bb_watchdog);
 	} else {
-		len += snprintf(buf + len, sizeof(buf) - len,
-			"%8s: %10u\n", "RX", sc->debug.stats.istats.rxok);
+		len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "RX", sc->debug.stats.istats.rxok);
 	}
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RXEOL", sc->debug.stats.istats.rxeol);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RXORN", sc->debug.stats.istats.rxorn);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TX", sc->debug.stats.istats.txok);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TXURN", sc->debug.stats.istats.txurn);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "MIB", sc->debug.stats.istats.mib);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RXPHY", sc->debug.stats.istats.rxphyerr);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RXKCM", sc->debug.stats.istats.rx_keycache_miss);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "SWBA", sc->debug.stats.istats.swba);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "BMISS", sc->debug.stats.istats.bmiss);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "BNR", sc->debug.stats.istats.bnr);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "CST", sc->debug.stats.istats.cst);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "GTT", sc->debug.stats.istats.gtt);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TIM", sc->debug.stats.istats.tim);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "CABEND", sc->debug.stats.istats.cabend);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "DTIMSYNC", sc->debug.stats.istats.dtimsync);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "DTIM", sc->debug.stats.istats.dtim);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TSFOOR", sc->debug.stats.istats.tsfoor);
-	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TOTAL", sc->debug.stats.istats.total);
-
-
-	if (len > sizeof(buf))
-		len = sizeof(buf);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "RXEOL", sc->debug.stats.istats.rxeol);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "RXORN", sc->debug.stats.istats.rxorn);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "TX", sc->debug.stats.istats.txok);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "TXURN", sc->debug.stats.istats.txurn);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "MIB", sc->debug.stats.istats.mib);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "RXPHY", sc->debug.stats.istats.rxphyerr);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "RXKCM",
+			sc->debug.stats.istats.rx_keycache_miss);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "SWBA", sc->debug.stats.istats.swba);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "BMISS", sc->debug.stats.istats.bmiss);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "BNR", sc->debug.stats.istats.bnr);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "CST", sc->debug.stats.istats.cst);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "GTT", sc->debug.stats.istats.gtt);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "TIM", sc->debug.stats.istats.tim);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "CABEND", sc->debug.stats.istats.cabend);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "DTIMSYNC", sc->debug.stats.istats.dtimsync);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "DTIM", sc->debug.stats.istats.dtim);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "TSFOOR", sc->debug.stats.istats.tsfoor);
+	len += snprintf(buf + len, mxlen - len,
+		"%21s: %10u\n", "TOTAL", sc->debug.stats.istats.total);
+
+	len += snprintf(buf + len, mxlen - len,
+			"SYNC_CAUSE stats:\n");
+
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "Sync-All",
+			sc->debug.stats.istats.sync_cause_all);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "RTC-IRQ",
+			sc->debug.stats.istats.sync_rtc_irq);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "MAC-IRQ",
+			sc->debug.stats.istats.sync_mac_irq);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "EEPROM-Illegal-Access",
+			sc->debug.stats.istats.eeprom_illegal_access);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "APB-Timeout",
+			sc->debug.stats.istats.apb_timeout);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "PCI-Mode-Conflict",
+			sc->debug.stats.istats.pci_mode_conflict);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "HOST1-Fatal",
+			sc->debug.stats.istats.host1_fatal);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "HOST1-Perr",
+			sc->debug.stats.istats.host1_perr);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "TRCV-FIFO-Perr",
+			sc->debug.stats.istats.trcv_fifo_perr);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "RADM-CPL-EP",
+			sc->debug.stats.istats.radm_cpl_ep);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "RADM-CPL-DLLP-Abort",
+			sc->debug.stats.istats.radm_cpl_dllp_abort);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "RADM-CPL-TLP-Abort",
+			sc->debug.stats.istats.radm_cpl_tlp_abort);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "RADM-CPL-ECRC-Err",
+			sc->debug.stats.istats.radm_cpl_ecrc_err);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "RADM-CPL-Timeout",
+			sc->debug.stats.istats.radm_cpl_timeout);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "Local-Bus-Timeout",
+			sc->debug.stats.istats.local_timeout);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "PM-Access",
+			sc->debug.stats.istats.pm_access);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "MAC-Awake",
+			sc->debug.stats.istats.mac_awake);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "MAC-Asleep",
+			sc->debug.stats.istats.mac_asleep);
+	len += snprintf(buf + len, mxlen - len,
+			"%21s: %10u\n", "MAC-Sleep-Access",
+			sc->debug.stats.istats.mac_sleep_access);
+
+	if (len > mxlen)
+		len = mxlen;
+
+	rv = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+	return rv;
 }
 
 static const struct file_operations fops_interrupt = {
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index a2eb043..301266f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -60,6 +60,7 @@ struct ath_buf;
  * @tsfoor: TSF out of range, indicates that the corrected TSF received
  * from a beacon differs from the PCU's internal TSF by more than a
  * (programmable) threshold
+ * @local_timeout: Internal bus timeout.
  */
 struct ath_interrupt_stats {
 	u32 total;
@@ -85,8 +86,30 @@ struct ath_interrupt_stats {
 	u32 dtim;
 	u32 bb_watchdog;
 	u32 tsfoor;
+
+	/* Sync-cause stats */
+	u32 sync_cause_all;
+	u32 sync_rtc_irq;
+	u32 sync_mac_irq;
+	u32 eeprom_illegal_access;
+	u32 apb_timeout;
+	u32 pci_mode_conflict;
+	u32 host1_fatal;
+	u32 host1_perr;
+	u32 trcv_fifo_perr;
+	u32 radm_cpl_ep;
+	u32 radm_cpl_dllp_abort;
+	u32 radm_cpl_tlp_abort;
+	u32 radm_cpl_ecrc_err;
+	u32 radm_cpl_timeout;
+	u32 local_timeout;
+	u32 pm_access;
+	u32 mac_awake;
+	u32 mac_asleep;
+	u32 mac_sleep_access;
 };
 
+
 /**
  * struct ath_tx_stats - Statistics about TX
  * @tx_pkts_all:  No. of total frames transmitted, including ones that
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 87db1ee..d116c56 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -23,6 +23,8 @@
 #include "hw-ops.h"
 #include "rc.h"
 #include "ar9003_mac.h"
+#include "debug.h"
+#include "ath9k.h"
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
 
@@ -82,6 +84,53 @@ static void ath9k_hw_ani_cache_ini_regs(struct ath_hw *ah)
 /* Helper Functions */
 /********************/
 
+#ifdef CONFIG_ATH9K_DEBUGFS
+
+void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause)
+{
+	struct ath_softc *sc = common->priv;
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
+#endif
+
+
 static void ath9k_hw_set_clockrate(struct ath_hw *ah)
 {
 	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c8261d4..d1e8ad97 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1129,6 +1129,12 @@ bool ath9k_hw_check_alive(struct ath_hw *ah);
 
 bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode);
 
+#ifdef CONFIG_ATH9K_DEBUGFS
+void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause);
+#else
+static void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause) {}
+#endif
+
 /* Generic hw timer primitives */
 struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 					  void (*trigger)(void *),
-- 
1.7.3.4

