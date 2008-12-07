Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58011 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbYLGQPz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 11:15:55 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 08:15:55 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18747.62973.573.264948@gargle.gargle.HOWL> (sfid-20081207_171612_151241_C590FC6A)
Date: Sun, 7 Dec 2008 21:42:44 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/6] ath9k: Add a debugfs file to show interrupt statistics
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Location: ath9k/<phy>/interrupt

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h  |   55 +++++++++++++++++++
 drivers/net/wireless/ath9k/debug.c |  102 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/main.c  |    2 +
 3 files changed, 159 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 23844e0..9abdbd8 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -88,16 +88,66 @@ enum ATH_DEBUG {
 
 #ifdef CONFIG_ATH9K_DEBUG
 
+/**
+ * struct ath_interrupt_stats - Contains statistics about interrupts
+ * @total: Total no. of interrupts generated so far
+ * @rxok: RX with no errors
+ * @rxeol: RX with no more RXDESC available
+ * @rxorn: RX FIFO overrun
+ * @txok: TX completed at the requested rate
+ * @txurn: TX FIFO underrun
+ * @mib: MIB regs reaching its threshold
+ * @rxphyerr: RX with phy errors
+ * @rx_keycache_miss: RX with key cache misses
+ * @swba: Software Beacon Alert
+ * @bmiss: Beacon Miss
+ * @bnr: Beacon Not Ready
+ * @cst: Carrier Sense TImeout
+ * @gtt: Global TX Timeout
+ * @tim: RX beacon TIM occurrence
+ * @cabend: RX End of CAB traffic
+ * @dtimsync: DTIM sync lossage
+ * @dtim: RX Beacon with DTIM
+ */
+struct ath_interrupt_stats {
+	u32 total;
+	u32 rxok;
+	u32 rxeol;
+	u32 rxorn;
+	u32 txok;
+	u32 txeol;
+	u32 txurn;
+	u32 mib;
+	u32 rxphyerr;
+	u32 rx_keycache_miss;
+	u32 swba;
+	u32 bmiss;
+	u32 bnr;
+	u32 cst;
+	u32 gtt;
+	u32 tim;
+	u32 cabend;
+	u32 dtimsync;
+	u32 dtim;
+};
+
+struct ath_stats {
+	struct ath_interrupt_stats istats;
+};
+
 struct ath9k_debug {
 	int debug_mask;
 	struct dentry *debugfs_root;
 	struct dentry *debugfs_phy;
 	struct dentry *debugfs_dma;
+	struct dentry *debugfs_interrupt;
+	struct ath_stats stats;
 };
 
 void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...);
 int ath9k_init_debug(struct ath_softc *sc);
 void ath9k_exit_debug(struct ath_softc *sc);
+void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
 
 #else
 
@@ -115,6 +165,11 @@ static inline void ath9k_exit_debug(struct ath_softc *sc)
 {
 }
 
+static inline void ath_debug_stat_interrupt(struct ath_softc *sc,
+					    enum ath9k_int status)
+{
+}
+
 #endif /* CONFIG_ATH9K_DEBUG */
 
 struct ath_config {
diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index da52812..a80ed57 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -128,6 +128,100 @@ static const struct file_operations fops_dma = {
 	.owner = THIS_MODULE
 };
 
+
+void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status)
+{
+	if (status)
+		sc->sc_debug.stats.istats.total++;
+	if (status & ATH9K_INT_RX)
+		sc->sc_debug.stats.istats.rxok++;
+	if (status & ATH9K_INT_RXEOL)
+		sc->sc_debug.stats.istats.rxeol++;
+	if (status & ATH9K_INT_RXORN)
+		sc->sc_debug.stats.istats.rxorn++;
+	if (status & ATH9K_INT_TX)
+		sc->sc_debug.stats.istats.txok++;
+	if (status & ATH9K_INT_TXURN)
+		sc->sc_debug.stats.istats.txurn++;
+	if (status & ATH9K_INT_MIB)
+		sc->sc_debug.stats.istats.mib++;
+	if (status & ATH9K_INT_RXPHY)
+		sc->sc_debug.stats.istats.rxphyerr++;
+	if (status & ATH9K_INT_RXKCM)
+		sc->sc_debug.stats.istats.rx_keycache_miss++;
+	if (status & ATH9K_INT_SWBA)
+		sc->sc_debug.stats.istats.swba++;
+	if (status & ATH9K_INT_BMISS)
+		sc->sc_debug.stats.istats.bmiss++;
+	if (status & ATH9K_INT_BNR)
+		sc->sc_debug.stats.istats.bnr++;
+	if (status & ATH9K_INT_CST)
+		sc->sc_debug.stats.istats.cst++;
+	if (status & ATH9K_INT_GTT)
+		sc->sc_debug.stats.istats.gtt++;
+	if (status & ATH9K_INT_TIM)
+		sc->sc_debug.stats.istats.tim++;
+	if (status & ATH9K_INT_CABEND)
+		sc->sc_debug.stats.istats.cabend++;
+	if (status & ATH9K_INT_DTIMSYNC)
+		sc->sc_debug.stats.istats.dtimsync++;
+	if (status & ATH9K_INT_DTIM)
+		sc->sc_debug.stats.istats.dtim++;
+}
+
+static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[512];
+	unsigned int len = 0;
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "RX", sc->sc_debug.stats.istats.rxok);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "RXEOL", sc->sc_debug.stats.istats.rxeol);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "RXORN", sc->sc_debug.stats.istats.rxorn);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "TX", sc->sc_debug.stats.istats.txok);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "TXURN", sc->sc_debug.stats.istats.txurn);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "MIB", sc->sc_debug.stats.istats.mib);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "RXPHY", sc->sc_debug.stats.istats.rxphyerr);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "RXKCM", sc->sc_debug.stats.istats.rx_keycache_miss);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "SWBA", sc->sc_debug.stats.istats.swba);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "BMISS", sc->sc_debug.stats.istats.bmiss);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "BNR", sc->sc_debug.stats.istats.bnr);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "CST", sc->sc_debug.stats.istats.cst);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "GTT", sc->sc_debug.stats.istats.gtt);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "TIM", sc->sc_debug.stats.istats.tim);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "CABEND", sc->sc_debug.stats.istats.cabend);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "DTIMSYNC", sc->sc_debug.stats.istats.dtimsync);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "DTIM", sc->sc_debug.stats.istats.dtim);
+	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "TOTAL", sc->sc_debug.stats.istats.total);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_interrupt = {
+	.read = read_file_interrupt,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE
+};
+
 int ath9k_init_debug(struct ath_softc *sc)
 {
 	sc->sc_debug.debug_mask = ath9k_debug;
@@ -146,6 +240,13 @@ int ath9k_init_debug(struct ath_softc *sc)
 	if (!sc->sc_debug.debugfs_dma)
 		goto err;
 
+	sc->sc_debug.debugfs_interrupt = debugfs_create_file("interrupt",
+						     S_IRUGO,
+						     sc->sc_debug.debugfs_phy,
+						     sc, &fops_interrupt);
+	if (!sc->sc_debug.debugfs_interrupt)
+		goto err;
+
 	return 0;
 err:
 	ath9k_exit_debug(sc);
@@ -154,6 +255,7 @@ err:
 
 void ath9k_exit_debug(struct ath_softc *sc)
 {
+	debugfs_remove(sc->sc_debug.debugfs_interrupt);
 	debugfs_remove(sc->sc_debug.debugfs_dma);
 	debugfs_remove(sc->sc_debug.debugfs_phy);
 	debugfs_remove(sc->sc_debug.debugfs_root);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 5c6a1b0..11cd52e 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -598,6 +598,8 @@ static irqreturn_t ath_isr(int irq, void *dev)
 		}
 	} while (0);
 
+	ath_debug_stat_interrupt(sc, status);
+
 	if (sched) {
 		/* turn off every interrupt except SWBA */
 		ath9k_hw_set_interrupts(ah, (sc->sc_imask & ATH9K_INT_SWBA));
-- 
1.6.0.3

