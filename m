Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:3718 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbaJ1MU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 08:20:57 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/3] ath: use seq_file api for ath9k debugfs files
Date: Tue, 28 Oct 2014 13:19:11 +0100
Message-ID: <1414498752-9746-3-git-send-email-arend@broadcom.com> (sfid-20141028_132100_810905_29293D7F)
In-Reply-To: <1414498752-9746-1-git-send-email-arend@broadcom.com>
References: <1414498752-9746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debugfs files that are defined in debug.c which are read-only
and using a simple_open as .open file operation have been modified
to use the single_open seq_file API. This simplifies the read
functions defining the file contents.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 425 +++++++++++++--------------------
 drivers/net/wireless/ath/ath9k/debug.h |   3 +-
 2 files changed, 173 insertions(+), 255 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 46f20a3..1d6bfda 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -401,22 +401,14 @@ static const struct file_operations fops_antenna_diversity = {
 	.llseek = default_llseek,
 };
 
-static ssize_t read_file_dma(struct file *file, char __user *user_buf,
-			     size_t count, loff_t *ppos)
+static int read_file_dma(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_softc *sc = file->private;
 	struct ath_hw *ah = sc->sc_ah;
-	char *buf;
-	int retval;
-	unsigned int len = 0;
 	u32 val[ATH9K_NUM_DMA_DEBUG_REGS];
 	int i, qcuOffset = 0, dcuOffset = 0;
 	u32 *qcuBase = &val[0], *dcuBase = &val[4];
 
-	buf = kmalloc(DMA_BUF_LEN, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
 	ath9k_ps_wakeup(sc);
 
 	REG_WRITE_D(ah, AR_MACMISC,
@@ -424,21 +416,18 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 		   (AR_MACMISC_MISC_OBS_BUS_1 <<
 		    AR_MACMISC_MISC_OBS_BUS_MSB_S)));
 
-	len += scnprintf(buf + len, DMA_BUF_LEN - len,
-			 "Raw DMA Debug values:\n");
+	seq_printf(file, "Raw DMA Debug values:\n");
 
 	for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++) {
 		if (i % 4 == 0)
-			len += scnprintf(buf + len, DMA_BUF_LEN - len, "\n");
+			seq_printf(file, "\n");
 
 		val[i] = REG_READ_D(ah, AR_DMADBG_0 + (i * sizeof(u32)));
-		len += scnprintf(buf + len, DMA_BUF_LEN - len, "%d: %08x ",
-				 i, val[i]);
+		seq_printf(file, "%d: %08x ", i, val[i]);
 	}
 
-	len += scnprintf(buf + len, DMA_BUF_LEN - len, "\n\n");
-	len += scnprintf(buf + len, DMA_BUF_LEN - len,
-			 "Num QCU: chain_st fsp_ok fsp_st DCU: chain_st\n");
+	seq_printf(file, "\n\n");
+	seq_printf(file, "Num QCU: chain_st fsp_ok fsp_st DCU: chain_st\n");
 
 	for (i = 0; i < ATH9K_NUM_QUEUES; i++, qcuOffset += 4, dcuOffset += 5) {
 		if (i == 8) {
@@ -451,55 +440,47 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 			dcuBase++;
 		}
 
-		len += scnprintf(buf + len, DMA_BUF_LEN - len,
-			 "%2d          %2x      %1x     %2x           %2x\n",
+		seq_printf(file, "%2d          %2x      %1x     %2x           %2x\n",
 			 i, (*qcuBase & (0x7 << qcuOffset)) >> qcuOffset,
 			 (*qcuBase & (0x8 << qcuOffset)) >> (qcuOffset + 3),
 			 val[2] & (0x7 << (i * 3)) >> (i * 3),
 			 (*dcuBase & (0x1f << dcuOffset)) >> dcuOffset);
 	}
 
-	len += scnprintf(buf + len, DMA_BUF_LEN - len, "\n");
+	seq_printf(file, "\n");
 
-	len += scnprintf(buf + len, DMA_BUF_LEN - len,
-		"qcu_stitch state:   %2x    qcu_fetch state:        %2x\n",
+	seq_printf(file, "qcu_stitch state:   %2x    qcu_fetch state:        %2x\n",
 		(val[3] & 0x003c0000) >> 18, (val[3] & 0x03c00000) >> 22);
-	len += scnprintf(buf + len, DMA_BUF_LEN - len,
-		"qcu_complete state: %2x    dcu_complete state:     %2x\n",
+	seq_printf(file, "qcu_complete state: %2x    dcu_complete state:     %2x\n",
 		(val[3] & 0x1c000000) >> 26, (val[6] & 0x3));
-	len += scnprintf(buf + len, DMA_BUF_LEN - len,
-		"dcu_arb state:      %2x    dcu_fp state:           %2x\n",
+	seq_printf(file, "dcu_arb state:      %2x    dcu_fp state:           %2x\n",
 		(val[5] & 0x06000000) >> 25, (val[5] & 0x38000000) >> 27);
-	len += scnprintf(buf + len, DMA_BUF_LEN - len,
-		"chan_idle_dur:     %3d    chan_idle_dur_valid:     %1d\n",
+	seq_printf(file, "chan_idle_dur:     %3d    chan_idle_dur_valid:     %1d\n",
 		(val[6] & 0x000003fc) >> 2, (val[6] & 0x00000400) >> 10);
-	len += scnprintf(buf + len, DMA_BUF_LEN - len,
-		"txfifo_valid_0:      %1d    txfifo_valid_1:          %1d\n",
+	seq_printf(file, "txfifo_valid_0:      %1d    txfifo_valid_1:          %1d\n",
 		(val[6] & 0x00000800) >> 11, (val[6] & 0x00001000) >> 12);
-	len += scnprintf(buf + len, DMA_BUF_LEN - len,
-		"txfifo_dcu_num_0:   %2d    txfifo_dcu_num_1:       %2d\n",
+	seq_printf(file, "txfifo_dcu_num_0:   %2d    txfifo_dcu_num_1:       %2d\n",
 		(val[6] & 0x0001e000) >> 13, (val[6] & 0x001e0000) >> 17);
 
-	len += scnprintf(buf + len, DMA_BUF_LEN - len, "pcu observe: 0x%x\n",
-			 REG_READ_D(ah, AR_OBS_BUS_1));
-	len += scnprintf(buf + len, DMA_BUF_LEN - len,
-			 "AR_CR: 0x%x\n", REG_READ_D(ah, AR_CR));
+	seq_printf(file, "pcu observe: 0x%x\n", REG_READ_D(ah, AR_OBS_BUS_1));
+	seq_printf(file, "AR_CR: 0x%x\n", REG_READ_D(ah, AR_CR));
 
 	ath9k_ps_restore(sc);
 
-	if (len > DMA_BUF_LEN)
-		len = DMA_BUF_LEN;
+	return 0;
+}
 
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-	return retval;
+static int open_file_dma(struct inode *inode, struct file *f)
+{
+	return single_open(f, read_file_dma, inode->i_private);
 }
 
 static const struct file_operations fops_dma = {
-	.read = read_file_dma,
-	.open = simple_open,
+	.open = open_file_dma,
+	.read = seq_read,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = seq_lseek,
+	.release = single_release,
 };
 
 
@@ -556,22 +537,14 @@ void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status)
 		sc->debug.stats.istats.gen_timer++;
 }
 
-static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
-				   size_t count, loff_t *ppos)
+static int read_file_interrupt(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private_data;
-	unsigned int len = 0;
-	int rv;
-	int mxlen = 4000;
-	char *buf = kmalloc(mxlen, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	struct ath_softc *sc = file->private;
 
 #define PR_IS(a, s)						\
 	do {							\
-		len += scnprintf(buf + len, mxlen - len,	\
-				 "%21s: %10u\n", a,		\
-				 sc->debug.stats.istats.s);	\
+		seq_printf(file, "%21s: %10u\n", a,		\
+			   sc->debug.stats.istats.s);		\
 	} while (0)
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
@@ -602,8 +575,7 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 	PR_IS("GENTIMER", gen_timer);
 	PR_IS("TOTAL", total);
 
-	len += scnprintf(buf + len, mxlen - len,
-			 "SYNC_CAUSE stats:\n");
+	seq_printf(file, "SYNC_CAUSE stats:\n");
 
 	PR_IS("Sync-All", sync_cause_all);
 	PR_IS("RTC-IRQ", sync_rtc_irq);
@@ -625,35 +597,27 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 	PR_IS("MAC-Asleep", mac_asleep);
 	PR_IS("MAC-Sleep-Access", mac_sleep_access);
 
-	if (len > mxlen)
-		len = mxlen;
+	return 0;
+}
 
-	rv = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-	return rv;
+static int open_file_interrupt(struct inode *inode, struct file *f)
+{
+	return single_open(f, read_file_interrupt, inode->i_private);
 }
 
 static const struct file_operations fops_interrupt = {
-	.read = read_file_interrupt,
-	.open = simple_open,
+	.read = seq_read,
+	.open = open_file_interrupt,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = seq_lseek,
+	.release = single_release,
 };
 
-static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
-			      size_t count, loff_t *ppos)
+static int read_file_xmit(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private_data;
-	char *buf;
-	unsigned int len = 0, size = 2048;
-	ssize_t retval = 0;
+	struct ath_softc *sc = file->private;
 
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	len += sprintf(buf, "%30s %10s%10s%10s\n\n",
-		       "BE", "BK", "VI", "VO");
+	seq_printf(file, "%30s %10s%10s%10s\n\n", "BE", "BK", "VI", "VO");
 
 	PR("MPDUs Queued:    ", queued);
 	PR("MPDUs Completed: ", completed);
@@ -678,153 +642,115 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("HW-tx-proc-desc: ", txprocdesc);
 	PR("TX-Failed:       ", txfailed);
 
-	if (len > size)
-		len = size;
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
+	return 0;
 }
 
-static ssize_t print_queue(struct ath_softc *sc, struct ath_txq *txq,
-			   char *buf, ssize_t size)
+static void print_queue(struct ath_softc *sc, struct ath_txq *txq,
+			struct seq_file *file)
 {
-	ssize_t len = 0;
-
 	ath_txq_lock(sc, txq);
 
-	len += scnprintf(buf + len, size - len, "%s: %d ",
-			 "qnum", txq->axq_qnum);
-	len += scnprintf(buf + len, size - len, "%s: %2d ",
-			 "qdepth", txq->axq_depth);
-	len += scnprintf(buf + len, size - len, "%s: %2d ",
-			 "ampdu-depth", txq->axq_ampdu_depth);
-	len += scnprintf(buf + len, size - len, "%s: %3d ",
-			 "pending", txq->pending_frames);
-	len += scnprintf(buf + len, size - len, "%s: %d\n",
-			 "stopped", txq->stopped);
+	seq_printf(file, "%s: %d ", "qnum", txq->axq_qnum);
+	seq_printf(file, "%s: %2d ", "qdepth", txq->axq_depth);
+	seq_printf(file, "%s: %2d ", "ampdu-depth", txq->axq_ampdu_depth);
+	seq_printf(file, "%s: %3d ", "pending", txq->pending_frames);
+	seq_printf(file, "%s: %d\n", "stopped", txq->stopped);
 
 	ath_txq_unlock(sc, txq);
-	return len;
 }
 
-static ssize_t read_file_queues(struct file *file, char __user *user_buf,
-				size_t count, loff_t *ppos)
+static int read_file_queues(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_softc *sc = file->private;
 	struct ath_txq *txq;
-	char *buf;
-	unsigned int len = 0;
-	const unsigned int size = 1024;
-	ssize_t retval = 0;
 	int i;
 	static const char *qname[4] = {
 		"VO", "VI", "BE", "BK"
 	};
 
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		txq = sc->tx.txq_map[i];
-		len += scnprintf(buf + len, size - len, "(%s):  ", qname[i]);
-		len += print_queue(sc, txq, buf + len, size - len);
+		seq_printf(file, "(%s):  ", qname[i]);
+		print_queue(sc, txq, file);
 	}
 
-	len += scnprintf(buf + len, size - len, "(CAB): ");
-	len += print_queue(sc, sc->beacon.cabq, buf + len, size - len);
-
-	if (len > size)
-		len = size;
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
+	seq_printf(file, "(CAB): ");
+	print_queue(sc, sc->beacon.cabq, file);
 
-	return retval;
+	return 0;
 }
 
-static ssize_t read_file_misc(struct file *file, char __user *user_buf,
-			      size_t count, loff_t *ppos)
+static int read_file_misc(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_softc *sc = file->private;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath9k_vif_iter_data iter_data;
 	struct ath_chanctx *ctx;
-	char buf[512];
-	unsigned int len = 0;
-	ssize_t retval = 0;
 	unsigned int reg;
 	u32 rxfilter, i;
 
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "BSSID: %pM\n", common->curbssid);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "BSSID-MASK: %pM\n", common->bssidmask);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "OPMODE: %s\n",
-			 ath_opmode_to_string(sc->sc_ah->opmode));
+	seq_printf(file, "BSSID: %pM\n", common->curbssid);
+	seq_printf(file, "BSSID-MASK: %pM\n", common->bssidmask);
+	seq_printf(file, "OPMODE: %s\n",
+		   ath_opmode_to_string(sc->sc_ah->opmode));
 
 	ath9k_ps_wakeup(sc);
 	rxfilter = ath9k_hw_getrxfilter(sc->sc_ah);
 	ath9k_ps_restore(sc);
 
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "RXFILTER: 0x%x", rxfilter);
+	seq_printf(file, "RXFILTER: 0x%x", rxfilter);
 
 	if (rxfilter & ATH9K_RX_FILTER_UCAST)
-		len += scnprintf(buf + len, sizeof(buf) - len, " UCAST");
+		seq_printf(file, " UCAST");
 	if (rxfilter & ATH9K_RX_FILTER_MCAST)
-		len += scnprintf(buf + len, sizeof(buf) - len, " MCAST");
+		seq_printf(file, " MCAST");
 	if (rxfilter & ATH9K_RX_FILTER_BCAST)
-		len += scnprintf(buf + len, sizeof(buf) - len, " BCAST");
+		seq_printf(file, " BCAST");
 	if (rxfilter & ATH9K_RX_FILTER_CONTROL)
-		len += scnprintf(buf + len, sizeof(buf) - len, " CONTROL");
+		seq_printf(file, " CONTROL");
 	if (rxfilter & ATH9K_RX_FILTER_BEACON)
-		len += scnprintf(buf + len, sizeof(buf) - len, " BEACON");
+		seq_printf(file, " BEACON");
 	if (rxfilter & ATH9K_RX_FILTER_PROM)
-		len += scnprintf(buf + len, sizeof(buf) - len, " PROM");
+		seq_printf(file, " PROM");
 	if (rxfilter & ATH9K_RX_FILTER_PROBEREQ)
-		len += scnprintf(buf + len, sizeof(buf) - len, " PROBEREQ");
+		seq_printf(file, " PROBEREQ");
 	if (rxfilter & ATH9K_RX_FILTER_PHYERR)
-		len += scnprintf(buf + len, sizeof(buf) - len, " PHYERR");
+		seq_printf(file, " PHYERR");
 	if (rxfilter & ATH9K_RX_FILTER_MYBEACON)
-		len += scnprintf(buf + len, sizeof(buf) - len, " MYBEACON");
+		seq_printf(file, " MYBEACON");
 	if (rxfilter & ATH9K_RX_FILTER_COMP_BAR)
-		len += scnprintf(buf + len, sizeof(buf) - len, " COMP_BAR");
+		seq_printf(file, " COMP_BAR");
 	if (rxfilter & ATH9K_RX_FILTER_PSPOLL)
-		len += scnprintf(buf + len, sizeof(buf) - len, " PSPOLL");
+		seq_printf(file, " PSPOLL");
 	if (rxfilter & ATH9K_RX_FILTER_PHYRADAR)
-		len += scnprintf(buf + len, sizeof(buf) - len, " PHYRADAR");
+		seq_printf(file, " PHYRADAR");
 	if (rxfilter & ATH9K_RX_FILTER_MCAST_BCAST_ALL)
-		len += scnprintf(buf + len, sizeof(buf) - len, " MCAST_BCAST_ALL");
+		seq_printf(file, " MCAST_BCAST_ALL");
 	if (rxfilter & ATH9K_RX_FILTER_CONTROL_WRAPPER)
-		len += scnprintf(buf + len, sizeof(buf) - len, " CONTROL_WRAPPER");
+		seq_printf(file, " CONTROL_WRAPPER");
 
-	len += scnprintf(buf + len, sizeof(buf) - len, "\n");
+	seq_printf(file, "\n");
 
 	reg = sc->sc_ah->imask;
 
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "INTERRUPT-MASK: 0x%x", reg);
+	seq_printf(file, "INTERRUPT-MASK: 0x%x", reg);
 
 	if (reg & ATH9K_INT_SWBA)
-		len += scnprintf(buf + len, sizeof(buf) - len, " SWBA");
+		seq_printf(file, " SWBA");
 	if (reg & ATH9K_INT_BMISS)
-		len += scnprintf(buf + len, sizeof(buf) - len, " BMISS");
+		seq_printf(file, " BMISS");
 	if (reg & ATH9K_INT_CST)
-		len += scnprintf(buf + len, sizeof(buf) - len, " CST");
+		seq_printf(file, " CST");
 	if (reg & ATH9K_INT_RX)
-		len += scnprintf(buf + len, sizeof(buf) - len, " RX");
+		seq_printf(file, " RX");
 	if (reg & ATH9K_INT_RXHP)
-		len += scnprintf(buf + len, sizeof(buf) - len, " RXHP");
+		seq_printf(file, " RXHP");
 	if (reg & ATH9K_INT_RXLP)
-		len += scnprintf(buf + len, sizeof(buf) - len, " RXLP");
+		seq_printf(file, " RXLP");
 	if (reg & ATH9K_INT_BB_WATCHDOG)
-		len += scnprintf(buf + len, sizeof(buf) - len, " BB_WATCHDOG");
+		seq_printf(file, " BB_WATCHDOG");
 
-	len += scnprintf(buf + len, sizeof(buf) - len, "\n");
+	seq_printf(file, "\n");
 
 	i = 0;
 	ath_for_each_chanctx(sc, ctx) {
@@ -832,61 +758,42 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 			continue;
 		ath9k_calculate_iter_data(sc, ctx, &iter_data);
 
-		len += scnprintf(buf + len, sizeof(buf) - len,
-			"VIF-COUNTS: CTX %i AP: %i STA: %i MESH: %i WDS: %i",
-			i++, iter_data.naps, iter_data.nstations,
-			iter_data.nmeshes, iter_data.nwds);
-		len += scnprintf(buf + len, sizeof(buf) - len,
-			" ADHOC: %i TOTAL: %hi BEACON-VIF: %hi\n",
-			iter_data.nadhocs, sc->cur_chan->nvifs, sc->nbcnvifs);
+		seq_printf(file,
+			   "VIF-COUNTS: CTX %i AP: %i STA: %i MESH: %i WDS: %i",
+			   i++, iter_data.naps, iter_data.nstations,
+			   iter_data.nmeshes, iter_data.nwds);
+		seq_printf(file, " ADHOC: %i TOTAL: %hi BEACON-VIF: %hi\n",
+			   iter_data.nadhocs, sc->cur_chan->nvifs,
+			   sc->nbcnvifs);
 	}
 
-	if (len > sizeof(buf))
-		len = sizeof(buf);
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	return retval;
+	return 0;
 }
 
-static ssize_t read_file_reset(struct file *file, char __user *user_buf,
-			       size_t count, loff_t *ppos)
+static int read_file_reset(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private_data;
-	char buf[512];
-	unsigned int len = 0;
-
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "Baseband Hang",
-			 sc->debug.stats.reset[RESET_TYPE_BB_HANG]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "Baseband Watchdog",
-			 sc->debug.stats.reset[RESET_TYPE_BB_WATCHDOG]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "Fatal HW Error",
-			 sc->debug.stats.reset[RESET_TYPE_FATAL_INT]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "TX HW error",
-			 sc->debug.stats.reset[RESET_TYPE_TX_ERROR]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "TX Path Hang",
-			 sc->debug.stats.reset[RESET_TYPE_TX_HANG]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "PLL RX Hang",
-			 sc->debug.stats.reset[RESET_TYPE_PLL_HANG]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "MAC Hang",
-			 sc->debug.stats.reset[RESET_TYPE_MAC_HANG]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "Stuck Beacon",
-			 sc->debug.stats.reset[RESET_TYPE_BEACON_STUCK]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "MCI Reset",
-			 sc->debug.stats.reset[RESET_TYPE_MCI]);
-
-	if (len > sizeof(buf))
-		len = sizeof(buf);
+	struct ath_softc *sc = file->private;
+
+	seq_printf(file, "%17s: %2d\n", "Baseband Hang",
+		   sc->debug.stats.reset[RESET_TYPE_BB_HANG]);
+	seq_printf(file, "%17s: %2d\n", "Baseband Watchdog",
+		   sc->debug.stats.reset[RESET_TYPE_BB_WATCHDOG]);
+	seq_printf(file, "%17s: %2d\n", "Fatal HW Error",
+		   sc->debug.stats.reset[RESET_TYPE_FATAL_INT]);
+	seq_printf(file, "%17s: %2d\n", "TX HW error",
+		   sc->debug.stats.reset[RESET_TYPE_TX_ERROR]);
+	seq_printf(file, "%17s: %2d\n", "TX Path Hang",
+		   sc->debug.stats.reset[RESET_TYPE_TX_HANG]);
+	seq_printf(file, "%17s: %2d\n", "PLL RX Hang",
+		   sc->debug.stats.reset[RESET_TYPE_PLL_HANG]);
+	seq_printf(file, "%17s: %2d\n", "MAC Hang",
+		   sc->debug.stats.reset[RESET_TYPE_MAC_HANG]);
+	seq_printf(file, "%17s: %2d\n", "Stuck Beacon",
+		   sc->debug.stats.reset[RESET_TYPE_BEACON_STUCK]);
+	seq_printf(file, "%17s: %2d\n", "MCI Reset",
+		   sc->debug.stats.reset[RESET_TYPE_MCI]);
 
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	return 0;
 }
 
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
@@ -926,32 +833,56 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		TX_STAT_INC(qnum, delim_underrun);
 }
 
+static int open_file_xmit(struct inode *inode, struct file *f)
+{
+	return single_open(f, read_file_xmit, inode->i_private);
+}
+
 static const struct file_operations fops_xmit = {
-	.read = read_file_xmit,
-	.open = simple_open,
+	.read = seq_read,
+	.open = open_file_xmit,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = seq_lseek,
+	.release = single_release,
 };
 
+static int open_file_queues(struct inode *inode, struct file *f)
+{
+	return single_open(f, read_file_queues, inode->i_private);
+}
+
 static const struct file_operations fops_queues = {
-	.read = read_file_queues,
-	.open = simple_open,
+	.read = seq_read,
+	.open = open_file_queues,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = seq_lseek,
+	.release = single_release,
 };
 
+static int open_file_misc(struct inode *inode, struct file *f)
+{
+	return single_open(f, read_file_misc, inode->i_private);
+}
+
 static const struct file_operations fops_misc = {
-	.read = read_file_misc,
-	.open = simple_open,
+	.read = seq_read,
+	.open = open_file_misc,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = seq_lseek,
+	.release = single_release,
 };
 
+static int open_file_reset(struct inode *inode, struct file *f)
+{
+	return single_open(f, read_file_reset, inode->i_private);
+}
+
 static const struct file_operations fops_reset = {
-	.read = read_file_reset,
-	.open = simple_open,
+	.read = seq_read,
+	.open = open_file_reset,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = seq_lseek,
+	.release = single_release,
 };
 
 void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
@@ -960,7 +891,7 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 }
 
 static ssize_t read_file_regidx(struct file *file, char __user *user_buf,
-                                size_t count, loff_t *ppos)
+				size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
 	char buf[32];
@@ -1081,57 +1012,45 @@ static const struct file_operations fops_regdump = {
 	.llseek = default_llseek,/* read accesses f_pos */
 };
 
-static ssize_t read_file_dump_nfcal(struct file *file, char __user *user_buf,
-				    size_t count, loff_t *ppos)
+static int read_file_dump_nfcal(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_softc *sc = file->private;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_nfcal_hist *h = sc->cur_chan->caldata.nfCalHist;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &common->hw->conf;
-	u32 len = 0, size = 1500;
 	u32 i, j;
-	ssize_t retval = 0;
-	char *buf;
 	u8 chainmask = (ah->rxchainmask << 3) | ah->rxchainmask;
 	u8 nread;
 
-	buf = kzalloc(size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	len += scnprintf(buf + len, size - len,
-			 "Channel Noise Floor : %d\n", ah->noise);
-	len += scnprintf(buf + len, size - len,
-			 "Chain | privNF | # Readings | NF Readings\n");
+	seq_printf(file, "Channel Noise Floor : %d\n", ah->noise);
+	seq_printf(file, "Chain | privNF | # Readings | NF Readings\n");
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		if (!(chainmask & (1 << i)) ||
 		    ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf)))
 			continue;
 
 		nread = AR_PHY_CCA_FILTERWINDOW_LENGTH - h[i].invalidNFcount;
-		len += scnprintf(buf + len, size - len, " %d\t %d\t %d\t\t",
-				 i, h[i].privNF, nread);
+		seq_printf(file, " %d\t %d\t %d\t\t", i, h[i].privNF, nread);
 		for (j = 0; j < nread; j++)
-			len += scnprintf(buf + len, size - len,
-					 " %d", h[i].nfCalBuffer[j]);
-		len += scnprintf(buf + len, size - len, "\n");
+			seq_printf(file, " %d", h[i].nfCalBuffer[j]);
+		seq_printf(file, "\n");
 	}
 
-	if (len > size)
-		len = size;
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
+	return 0;
+}
 
-	return retval;
+static int open_file_dump_nfcal(struct inode *inode, struct file *f)
+{
+	return single_open(f, read_file_dump_nfcal, inode->i_private);
 }
 
 static const struct file_operations fops_dump_nfcal = {
-	.read = read_file_dump_nfcal,
-	.open = simple_open,
+	.read = seq_read,
+	.open = open_file_dump_nfcal,
 	.owner = THIS_MODULE,
-	.llseek = default_llseek,
+	.llseek = seq_lseek,
+	.release = single_release,
 };
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 53ae15b..824ff5a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -195,8 +195,7 @@ struct ath_tx_stats {
 #define TXSTATS sc->debug.stats.txstats
 #define PR(str, elem)							\
 	do {								\
-		len += scnprintf(buf + len, size - len,			\
-				 "%s%13u%11u%10u%10u\n", str,		\
+		seq_printf(file, "%s%13u%11u%10u%10u\n", str,		\
 				 TXSTATS[PR_QNUM(IEEE80211_AC_BE)].elem,\
 				 TXSTATS[PR_QNUM(IEEE80211_AC_BK)].elem,\
 				 TXSTATS[PR_QNUM(IEEE80211_AC_VI)].elem,\
-- 
1.9.1

