Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42116 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab2DCUWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 16:22:51 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Gather and report bus-timeout errors.
Date: Tue,  3 Apr 2012 13:22:25 -0700
Message-Id: <1333484545-14273-1-git-send-email-greearb@candelatech.com> (sfid-20120403_222314_474556_D0890CAB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Seems like a useful stat to report (when debugfs
is enabled).

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 7b6417b... ec4fc16... M	drivers/net/wireless/ath/ath9k/ar9002_mac.c
:100644 100644 09b8c9d... 4948f54... M	drivers/net/wireless/ath/ath9k/ar9003_mac.c
:100644 100644 43d84db... 016476e... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 a2eb043... 664ec90... M	drivers/net/wireless/ath/ath9k/debug.h
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |    3 ++
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    6 +++-
 drivers/net/wireless/ath/ath9k/debug.c      |   50 ++++++++++++++------------
 drivers/net/wireless/ath/ath9k/debug.h      |    9 +++++
 4 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 7b6417b..ec4fc16 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -16,6 +16,8 @@
 
 #include "hw.h"
 #include <linux/export.h>
+#include "debug.h"
+#include "ath9k.h"
 
 #define AR_BufLen           0x00000fff
 
@@ -162,6 +164,7 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
 			ath_dbg(common, INTERRUPT,
 				"AR_INTR_SYNC_LOCAL_TIMEOUT\n");
+			ATH_INCR_IRQ_STAT_COMMON(common, sync_local_timeout);
 		}
 
 		REG_WRITE(ah, AR_INTR_SYNC_CAUSE_CLR, sync_cause);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 09b8c9d..4948f54 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -16,6 +16,8 @@
 #include <linux/export.h>
 #include "hw.h"
 #include "ar9003_mac.h"
+#include "debug.h"
+#include "ath9k.h"
 
 static void ar9003_hw_rx_enable(struct ath_hw *hw)
 {
@@ -332,9 +334,11 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 			*masked |= ATH9K_INT_FATAL;
 		}
 
-		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT)
+		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
 			ath_dbg(common, INTERRUPT,
 				"AR_INTR_SYNC_LOCAL_TIMEOUT\n");
+			ATH_INCR_IRQ_STAT_COMMON(common, sync_local_timeout);
+		}
 
 		REG_WRITE(ah, AR_INTR_SYNC_CAUSE_CLR, sync_cause);
 		(void) REG_READ(ah, AR_INTR_SYNC_CAUSE_CLR);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 43d84db..016476e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -385,57 +385,61 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
-	char buf[512];
+	char buf[800];
 	unsigned int len = 0;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		len += snprintf(buf + len, sizeof(buf) - len,
-			"%8s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);
+			"%11s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);
 		len += snprintf(buf + len, sizeof(buf) - len,
-			"%8s: %10u\n", "RXHP", sc->debug.stats.istats.rxhp);
+			"%11s: %10u\n", "RXHP", sc->debug.stats.istats.rxhp);
 		len += snprintf(buf + len, sizeof(buf) - len,
-			"%8s: %10u\n", "WATCHDOG",
+			"%11s: %10u\n", "WATCHDOG",
 			sc->debug.stats.istats.bb_watchdog);
 	} else {
 		len += snprintf(buf + len, sizeof(buf) - len,
-			"%8s: %10u\n", "RX", sc->debug.stats.istats.rxok);
+			"%11s: %10u\n", "RX", sc->debug.stats.istats.rxok);
 	}
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RXEOL", sc->debug.stats.istats.rxeol);
+		"%11s: %10u\n", "RXEOL", sc->debug.stats.istats.rxeol);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%11s: %10u\n", "RXORN", sc->debug.stats.istats.rxorn);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RXORN", sc->debug.stats.istats.rxorn);
+		"%11s: %10u\n", "TX", sc->debug.stats.istats.txok);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TX", sc->debug.stats.istats.txok);
+		"%11s: %10u\n", "TXURN", sc->debug.stats.istats.txurn);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TXURN", sc->debug.stats.istats.txurn);
+		"%11s: %10u\n", "MIB", sc->debug.stats.istats.mib);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "MIB", sc->debug.stats.istats.mib);
+		"%11s: %10u\n", "RXPHY", sc->debug.stats.istats.rxphyerr);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RXPHY", sc->debug.stats.istats.rxphyerr);
+			"%11s: %10u\n", "RXKCM",
+			sc->debug.stats.istats.rx_keycache_miss);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "RXKCM", sc->debug.stats.istats.rx_keycache_miss);
+		"%11s: %10u\n", "SWBA", sc->debug.stats.istats.swba);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "SWBA", sc->debug.stats.istats.swba);
+		"%11s: %10u\n", "BMISS", sc->debug.stats.istats.bmiss);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "BMISS", sc->debug.stats.istats.bmiss);
+		"%11s: %10u\n", "BNR", sc->debug.stats.istats.bnr);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "BNR", sc->debug.stats.istats.bnr);
+		"%11s: %10u\n", "CST", sc->debug.stats.istats.cst);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "CST", sc->debug.stats.istats.cst);
+		"%11s: %10u\n", "GTT", sc->debug.stats.istats.gtt);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "GTT", sc->debug.stats.istats.gtt);
+		"%11s: %10u\n", "TIM", sc->debug.stats.istats.tim);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TIM", sc->debug.stats.istats.tim);
+		"%11s: %10u\n", "CABEND", sc->debug.stats.istats.cabend);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "CABEND", sc->debug.stats.istats.cabend);
+		"%11s: %10u\n", "DTIMSYNC", sc->debug.stats.istats.dtimsync);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "DTIMSYNC", sc->debug.stats.istats.dtimsync);
+		"%11s: %10u\n", "DTIM", sc->debug.stats.istats.dtim);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "DTIM", sc->debug.stats.istats.dtim);
+		"%11s: %10u\n", "TSFOOR", sc->debug.stats.istats.tsfoor);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TSFOOR", sc->debug.stats.istats.tsfoor);
+		"%11s: %10u\n", "TOTAL", sc->debug.stats.istats.total);
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"%8s: %10u\n", "TOTAL", sc->debug.stats.istats.total);
+			"%11s: %10u\n", "Bus-Timeout",
+			sc->debug.stats.istats.sync_local_timeout);
 
 
 	if (len > sizeof(buf))
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index a2eb043..664ec90 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -60,6 +60,7 @@ struct ath_buf;
  * @tsfoor: TSF out of range, indicates that the corrected TSF received
  * from a beacon differs from the PCU's internal TSF by more than a
  * (programmable) threshold
+ * @sync_local_timeout: Internal bus timeout.
  */
 struct ath_interrupt_stats {
 	u32 total;
@@ -85,8 +86,15 @@ struct ath_interrupt_stats {
 	u32 dtim;
 	u32 bb_watchdog;
 	u32 tsfoor;
+	u32 sync_local_timeout;
 };
 
+#define ATH_INCR_IRQ_STAT_COMMON(c, s)					\
+	do {								\
+		struct ath_softc *sc = (struct ath_softc *) (c)->priv;	\
+		sc->debug.stats.istats.s++;				\
+	} while (0);
+
 /**
  * struct ath_tx_stats - Statistics about TX
  * @tx_pkts_all:  No. of total frames transmitted, including ones that
@@ -272,6 +280,7 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs);
 #else
 
 #define RX_STAT_INC(c) /* NOP */
+#define ATH_INCR_IRQ_STAT_COMMON(c, s) /* NOP */
 
 static inline int ath9k_init_debug(struct ath_hw *ah)
 {
-- 
1.7.3.4

