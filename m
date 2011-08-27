Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6242 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab1H0Kru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 06:47:50 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: Add debugfs support for mac/baseband samples
Date: Sat, 27 Aug 2011 16:17:47 +0530
Message-ID: <1314442067-11799-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110827_124800_472295_5A3669CA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch keep track of number of samples that includes
DMA debugs registers, PCU observe, CR, channel noise,
cycle conters, noisefloor history buffer and last N number
of tx and rx descriptor status. These samples are grouped
in table manner which dumping in debgufs.

Debugfs file location:
    <debugfs_mnt>/ieee80211/phy#/ath9k/samples

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |  310 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h |   47 +++++
 drivers/net/wireless/ath/ath9k/init.c  |    1 +
 drivers/net/wireless/ath/ath9k/mac.h   |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    2 +
 drivers/net/wireless/ath/ath9k/recv.c  |   22 +--
 6 files changed, 369 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index da45f32..fbec5f7 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -828,6 +828,8 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		       struct ath_tx_status *ts, struct ath_txq *txq)
 {
+#define TX_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].ts\
+			[sc->debug.tsidx].c)
 	int qnum = txq->axq_qnum;
 
 	TX_STAT_INC(qnum, tx_pkts_all);
@@ -857,6 +859,26 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		TX_STAT_INC(qnum, data_underrun);
 	if (ts->ts_flags & ATH9K_TX_DELIM_UNDERRUN)
 		TX_STAT_INC(qnum, delim_underrun);
+
+	spin_lock(&sc->debug.samp_lock);
+	TX_SAMP_DBG(jiffies) = jiffies;
+	TX_SAMP_DBG(rssi_ctl0) = ts->ts_rssi_ctl0;
+	TX_SAMP_DBG(rssi_ctl1) = ts->ts_rssi_ctl1;
+	TX_SAMP_DBG(rssi_ctl2) = ts->ts_rssi_ctl2;
+	TX_SAMP_DBG(rssi_ext0) = ts->ts_rssi_ext0;
+	TX_SAMP_DBG(rssi_ext1) = ts->ts_rssi_ext1;
+	TX_SAMP_DBG(rssi_ext2) = ts->ts_rssi_ext2;
+	TX_SAMP_DBG(rateindex) = ts->ts_rateindex;
+	TX_SAMP_DBG(isok) = !!(ts->ts_status & ATH9K_TXERR_MASK);
+	TX_SAMP_DBG(rts_fail_cnt) = ts->ts_shortretry;
+	TX_SAMP_DBG(data_fail_cnt) = ts->ts_longretry;
+	TX_SAMP_DBG(rssi) = ts->ts_rssi;
+	TX_SAMP_DBG(tid) = ts->tid;
+	TX_SAMP_DBG(qid) = ts->qid;
+	sc->debug.tsidx = (sc->debug.tsidx + 1) % ATH_DBG_MAX_SAMPLES;
+	spin_unlock(&sc->debug.samp_lock);
+
+#undef TX_SAMP_DBG
 }
 
 static const struct file_operations fops_xmit = {
@@ -995,6 +1017,8 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 {
 #define RX_STAT_INC(c) sc->debug.stats.rxstats.c++
 #define RX_PHY_ERR_INC(c) sc->debug.stats.rxstats.phy_err_stats[c]++
+#define RX_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].rs\
+			[sc->debug.rsidx].c)
 
 	u32 phyerr;
 
@@ -1030,8 +1054,25 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 
 	sc->debug.stats.rxstats.rs_antenna = rs->rs_antenna;
 
+	spin_lock(&sc->debug.samp_lock);
+	RX_SAMP_DBG(jiffies) = jiffies;
+	RX_SAMP_DBG(rssi_ctl0) = rs->rs_rssi_ctl0;
+	RX_SAMP_DBG(rssi_ctl1) = rs->rs_rssi_ctl1;
+	RX_SAMP_DBG(rssi_ctl2) = rs->rs_rssi_ctl2;
+	RX_SAMP_DBG(rssi_ext0) = rs->rs_rssi_ext0;
+	RX_SAMP_DBG(rssi_ext1) = rs->rs_rssi_ext1;
+	RX_SAMP_DBG(rssi_ext2) = rs->rs_rssi_ext2;
+	RX_SAMP_DBG(antenna) = rs->rs_antenna;
+	RX_SAMP_DBG(rssi) = rs->rs_rssi;
+	RX_SAMP_DBG(rate) = rs->rs_rate;
+	RX_SAMP_DBG(is_mybeacon) = rs->is_mybeacon;
+
+	sc->debug.rsidx = (sc->debug.rsidx + 1) % ATH_DBG_MAX_SAMPLES;
+	spin_unlock(&sc->debug.samp_lock);
+
 #undef RX_STAT_INC
 #undef RX_PHY_ERR_INC
+#undef RX_SAMP_DBG
 }
 
 static const struct file_operations fops_recv = {
@@ -1272,6 +1313,269 @@ static const struct file_operations fops_modal_eeprom = {
 	.llseek = default_llseek,
 };
 
+void ath9k_debug_samp_bb_mac(struct ath_softc *sc)
+{
+#define ATH_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].c)
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	unsigned long flags;
+	int i;
+
+	ath9k_ps_wakeup(sc);
+
+	spin_lock_irqsave(&common->cc_lock, flags);
+	ath_hw_cycle_counters_update(common);
+	spin_unlock_irqrestore(&common->cc_lock, flags);
+
+	spin_lock_bh(&sc->debug.samp_lock);
+
+	ATH_SAMP_DBG(cc.cycles) = common->cc_ani.cycles;
+	ATH_SAMP_DBG(cc.rx_busy) = common->cc_ani.rx_busy;
+	ATH_SAMP_DBG(cc.rx_frame) = common->cc_ani.rx_frame;
+	ATH_SAMP_DBG(cc.tx_frame) = common->cc_ani.tx_frame;
+	ATH_SAMP_DBG(noise) = ah->noise;
+
+	REG_WRITE_D(ah, AR_MACMISC,
+		  ((AR_MACMISC_DMA_OBS_LINE_8 << AR_MACMISC_DMA_OBS_S) |
+		   (AR_MACMISC_MISC_OBS_BUS_1 <<
+		    AR_MACMISC_MISC_OBS_BUS_MSB_S)));
+
+	for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++)
+		ATH_SAMP_DBG(dma_dbg_reg_vals[i]) = REG_READ_D(ah,
+				AR_DMADBG_0 + (i * sizeof(u32)));
+
+	ATH_SAMP_DBG(pcu_obs) = REG_READ_D(ah, AR_OBS_BUS_1);
+	ATH_SAMP_DBG(pcu_cr) = REG_READ_D(ah, AR_CR);
+
+	memcpy(ATH_SAMP_DBG(nfCalHist), sc->caldata.nfCalHist,
+			sizeof(ATH_SAMP_DBG(nfCalHist)));
+
+	sc->debug.sampidx = (sc->debug.sampidx + 1) % ATH_DBG_MAX_SAMPLES;
+	spin_unlock_bh(&sc->debug.samp_lock);
+	ath9k_ps_restore(sc);
+
+#undef ATH_SAMP_DBG
+}
+
+static int open_file_bb_mac_samps(struct inode *inode, struct file *file)
+{
+#define ATH_SAMP_DBG(c) bb_mac_samp[sampidx].c
+	struct ath_softc *sc = inode->i_private;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_conf *conf = &common->hw->conf;
+	struct ath_dbg_bb_mac_samp *bb_mac_samp;
+	struct ath9k_nfcal_hist *h;
+	int i, j, qcuOffset = 0, dcuOffset = 0;
+	u32 *qcuBase, *dcuBase, size = 30000, len = 0;
+	u32 sampidx = 0;
+	u8 *buf;
+	u8 chainmask = (ah->rxchainmask << 3) | ah->rxchainmask;
+	u8 nread;
+
+	buf = vmalloc(size);
+	if (!buf)
+		return -ENOMEM;
+	bb_mac_samp = vmalloc(sizeof(*bb_mac_samp) * ATH_DBG_MAX_SAMPLES);
+	if (!bb_mac_samp) {
+		vfree(buf);
+		return -ENOMEM;
+	}
+
+	spin_lock_bh(&sc->debug.samp_lock);
+	memcpy(bb_mac_samp, sc->debug.bb_mac_samp,
+			sizeof(*bb_mac_samp) * ATH_DBG_MAX_SAMPLES);
+	spin_unlock_bh(&sc->debug.samp_lock);
+
+	len += snprintf(buf + len, size - len,
+			"Raw DMA Debug Dump:\n");
+	len += snprintf(buf + len, size - len, "Sample |\t");
+	for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++)
+		len += snprintf(buf + len, size - len, " DMA Reg%d |\t", i);
+	len += snprintf(buf + len, size - len, "\n");
+
+	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
+		len += snprintf(buf + len, size - len, "%d\t", sampidx);
+
+		for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++)
+			len += snprintf(buf + len, size - len, " %08x\t",
+					ATH_SAMP_DBG(dma_dbg_reg_vals[i]));
+		len += snprintf(buf + len, size - len, "\n");
+	}
+	len += snprintf(buf + len, size - len, "\n");
+
+	len += snprintf(buf + len, size - len,
+			"Sample Num QCU: chain_st fsp_ok fsp_st DCU: chain_st\n");
+	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
+		qcuBase = &ATH_SAMP_DBG(dma_dbg_reg_vals[0]);
+		dcuBase = &ATH_SAMP_DBG(dma_dbg_reg_vals[4]);
+
+		for (i = 0; i < ATH9K_NUM_QUEUES; i++,
+				qcuOffset += 4, dcuOffset += 5) {
+			if (i == 8) {
+				qcuOffset = 0;
+				qcuBase++;
+			}
+
+			if (i == 6) {
+				dcuOffset = 0;
+				dcuBase++;
+			}
+			if (!sc->debug.stats.txstats[i].queued)
+				continue;
+
+			len += snprintf(buf + len, size - len,
+				"%4d %7d    %2x      %1x     %2x         %2x\n",
+				sampidx, i,
+				(*qcuBase & (0x7 << qcuOffset)) >> qcuOffset,
+				(*qcuBase & (0x8 << qcuOffset)) >>
+				(qcuOffset + 3),
+				ATH_SAMP_DBG(dma_dbg_reg_vals[2]) &
+				(0x7 << (i * 3)) >> (i * 3),
+				(*dcuBase & (0x1f << dcuOffset)) >> dcuOffset);
+		}
+		len += snprintf(buf + len, size - len, "\n");
+	}
+	len += snprintf(buf + len, size - len,
+			"samp qcu_sh qcu_fh qcu_comp dcu_comp dcu_arb dcu_fp "
+			"ch_idle_dur ch_idle_dur_val txfifo_val0 txfifo_val1 "
+			"txfifo_dcu0 txfifo_dcu1 pcu_obs AR_CR\n");
+
+	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
+		qcuBase = &ATH_SAMP_DBG(dma_dbg_reg_vals[0]);
+		dcuBase = &ATH_SAMP_DBG(dma_dbg_reg_vals[4]);
+
+		len += snprintf(buf + len, size - len, "%4d %5x %5x ", sampidx,
+			(ATH_SAMP_DBG(dma_dbg_reg_vals[3]) & 0x003c0000) >> 18,
+			(ATH_SAMP_DBG(dma_dbg_reg_vals[3]) & 0x03c00000) >> 22);
+		len += snprintf(buf + len, size - len, "%7x %8x ",
+			(ATH_SAMP_DBG(dma_dbg_reg_vals[3]) & 0x1c000000) >> 26,
+			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x3));
+		len += snprintf(buf + len, size - len, "%7x %7x ",
+			(ATH_SAMP_DBG(dma_dbg_reg_vals[5]) & 0x06000000) >> 25,
+			(ATH_SAMP_DBG(dma_dbg_reg_vals[5]) & 0x38000000) >> 27);
+		len += snprintf(buf + len, size - len, "%7d %12d ",
+			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x000003fc) >> 2,
+			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x00000400) >> 10);
+		len += snprintf(buf + len, size - len, "%12d %12d ",
+			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x00000800) >> 11,
+			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x00001000) >> 12);
+		len += snprintf(buf + len, size - len, "%12d %12d ",
+			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x0001e000) >> 13,
+			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x001e0000) >> 17);
+		len += snprintf(buf + len, size - len, "0x%07x 0x%07x\n",
+				ATH_SAMP_DBG(pcu_obs), ATH_SAMP_DBG(pcu_cr));
+	}
+
+	len += snprintf(buf + len, size - len,
+			"Sample ChNoise Chain privNF #Reading Readings\n");
+	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
+		h = ATH_SAMP_DBG(nfCalHist);
+		if (!ATH_SAMP_DBG(noise))
+			continue;
+
+		for (i = 0; i < NUM_NF_READINGS; i++) {
+			if (!(chainmask & (1 << i)) ||
+			    ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf)))
+				continue;
+
+			nread = AR_PHY_CCA_FILTERWINDOW_LENGTH -
+				h[i].invalidNFcount;
+			len += snprintf(buf + len, size - len,
+					"%4d %5d %4d\t   %d\t %d\t",
+					sampidx, ATH_SAMP_DBG(noise),
+					i, h[i].privNF, nread);
+			for (j = 0; j < nread; j++)
+				len += snprintf(buf + len, size - len,
+					" %d", h[i].nfCalBuffer[j]);
+			len += snprintf(buf + len, size - len, "\n");
+		}
+	}
+	len += snprintf(buf + len, size - len, "\nCycle counters:\n"
+			"Sample Total    Rxbusy   Rxframes Txframes\n");
+	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
+		if (!ATH_SAMP_DBG(cc.cycles))
+			continue;
+		len += snprintf(buf + len, size - len,
+				"%4d %08x %08x %08x %08x\n",
+				sampidx, ATH_SAMP_DBG(cc.cycles),
+				ATH_SAMP_DBG(cc.rx_busy),
+				ATH_SAMP_DBG(cc.rx_frame),
+				ATH_SAMP_DBG(cc.tx_frame));
+	}
+
+	len += snprintf(buf + len, size - len, "Tx status Dump :\n");
+	len += snprintf(buf + len, size - len,
+			"Sample rssi:- ctl0 ctl1 ctl2 ext0 ext1 ext2 comb "
+			"isok rts_fail data_fail rate tid qid tx_before(ms)\n");
+	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
+		for (i = 0; i < ATH_DBG_MAX_SAMPLES; i++) {
+			if (!ATH_SAMP_DBG(ts[i].jiffies))
+				continue;
+			len += snprintf(buf + len, size - len, "%4d \t"
+				"%8d %4d %4d %4d %4d %4d %4d %4d %4d "
+				"%4d %4d %2d %2d %d\n",
+				sampidx,
+				ATH_SAMP_DBG(ts[i].rssi_ctl0),
+				ATH_SAMP_DBG(ts[i].rssi_ctl1),
+				ATH_SAMP_DBG(ts[i].rssi_ctl2),
+				ATH_SAMP_DBG(ts[i].rssi_ext0),
+				ATH_SAMP_DBG(ts[i].rssi_ext1),
+				ATH_SAMP_DBG(ts[i].rssi_ext2),
+				ATH_SAMP_DBG(ts[i].rssi),
+				ATH_SAMP_DBG(ts[i].isok),
+				ATH_SAMP_DBG(ts[i].rts_fail_cnt),
+				ATH_SAMP_DBG(ts[i].data_fail_cnt),
+				ATH_SAMP_DBG(ts[i].rateindex),
+				ATH_SAMP_DBG(ts[i].tid),
+				ATH_SAMP_DBG(ts[i].qid),
+				jiffies_to_msecs(jiffies -
+					ATH_SAMP_DBG(ts[i].jiffies)));
+		}
+	}
+
+	len += snprintf(buf + len, size - len, "Rx status Dump :\n");
+	len += snprintf(buf + len, size - len, "Sample rssi:- ctl0 ctl1 ctl2 "
+			"ext0 ext1 ext2 comb beacon ant rate rx_before(ms)\n");
+	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
+		for (i = 0; i < ATH_DBG_MAX_SAMPLES; i++) {
+			if (!ATH_SAMP_DBG(rs[i].jiffies))
+				continue;
+			len += snprintf(buf + len, size - len, "%4d \t"
+				"%8d %4d %4d %4d %4d %4d %4d %s %4d %02x %d\n",
+				sampidx,
+				ATH_SAMP_DBG(rs[i].rssi_ctl0),
+				ATH_SAMP_DBG(rs[i].rssi_ctl1),
+				ATH_SAMP_DBG(rs[i].rssi_ctl2),
+				ATH_SAMP_DBG(rs[i].rssi_ext0),
+				ATH_SAMP_DBG(rs[i].rssi_ext1),
+				ATH_SAMP_DBG(rs[i].rssi_ext2),
+				ATH_SAMP_DBG(rs[i].rssi),
+				ATH_SAMP_DBG(rs[i].is_mybeacon) ?
+				"True" : "False",
+				ATH_SAMP_DBG(rs[i].antenna),
+				ATH_SAMP_DBG(rs[i].rate),
+				jiffies_to_msecs(jiffies -
+					ATH_SAMP_DBG(rs[i].jiffies)));
+		}
+	}
+
+	vfree(bb_mac_samp);
+	file->private_data = buf;
+
+	return 0;
+#undef ATH_SAMP_DBG
+}
+
+static const struct file_operations fops_samps = {
+	.open = open_file_bb_mac_samps,
+	.read = ath9k_debugfs_read_buf,
+	.release = ath9k_debugfs_release_buf,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1321,6 +1625,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_base_eeprom);
 	debugfs_create_file("modal_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_modal_eeprom);
+	debugfs_create_file("samples", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_samps);
 
 	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
@@ -1329,5 +1635,9 @@ int ath9k_init_debug(struct ath_hw *ah)
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_val);
 
 	sc->debug.regidx = 0;
+	memset(&sc->debug.bb_mac_samp, 0, sizeof(sc->debug.bb_mac_samp));
+	sc->debug.sampidx = 0;
+	sc->debug.tsidx = 0;
+	sc->debug.rsidx = 0;
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 4a04510..95f85bd 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -177,14 +177,57 @@ struct ath_stats {
 	struct ath_rx_stats rxstats;
 };
 
+#define ATH_DBG_MAX_SAMPLES	10
+struct ath_dbg_bb_mac_samp {
+	u32 dma_dbg_reg_vals[ATH9K_NUM_DMA_DEBUG_REGS];
+	u32 pcu_obs, pcu_cr, noise;
+	struct {
+		u64 jiffies;
+		int8_t rssi_ctl0;
+		int8_t rssi_ctl1;
+		int8_t rssi_ctl2;
+		int8_t rssi_ext0;
+		int8_t rssi_ext1;
+		int8_t rssi_ext2;
+		int8_t rssi;
+		bool isok;
+		u8 rts_fail_cnt;
+		u8 data_fail_cnt;
+		u8 rateindex;
+		u8 qid;
+		u8 tid;
+	} ts[ATH_DBG_MAX_SAMPLES];
+	struct {
+		u64 jiffies;
+		int8_t rssi_ctl0;
+		int8_t rssi_ctl1;
+		int8_t rssi_ctl2;
+		int8_t rssi_ext0;
+		int8_t rssi_ext1;
+		int8_t rssi_ext2;
+		int8_t rssi;
+		bool is_mybeacon;
+		u8 antenna;
+		u8 rate;
+	} rs[ATH_DBG_MAX_SAMPLES];
+	struct ath_cycle_counters cc;
+	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
+};
+
 struct ath9k_debug {
 	struct dentry *debugfs_phy;
 	u32 regidx;
 	struct ath_stats stats;
+	spinlock_t samp_lock;
+	struct ath_dbg_bb_mac_samp bb_mac_samp[ATH_DBG_MAX_SAMPLES];
+	u8 sampidx;
+	u8 tsidx;
+	u8 rsidx;
 };
 
 int ath9k_init_debug(struct ath_hw *ah);
 
+void ath9k_debug_samp_bb_mac(struct ath_softc *sc);
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		       struct ath_tx_status *ts, struct ath_txq *txq);
@@ -197,6 +240,10 @@ static inline int ath9k_init_debug(struct ath_hw *ah)
 	return 0;
 }
 
+static inline void ath9k_debug_samp_bb_mac(struct ath_softc *sc)
+{
+}
+
 static inline void ath_debug_stat_interrupt(struct ath_softc *sc,
 					    enum ath9k_int status)
 {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index d7761d1..dd71a5f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -572,6 +572,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	mutex_init(&sc->mutex);
 #ifdef CONFIG_ATH9K_DEBUGFS
 	spin_lock_init(&sc->nodes_lock);
+	spin_lock_init(&sc->debug.samp_lock);
 	INIT_LIST_HEAD(&sc->nodes);
 #endif
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 153859c..2c43e13 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -146,6 +146,7 @@ struct ath_rx_status {
 	u8 rs_moreaggr;
 	u8 rs_num_delims;
 	u8 rs_flags;
+	bool is_mybeacon;
 	u32 evm0;
 	u32 evm1;
 	u32 evm2;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7ac1c21..df4108f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -546,6 +546,7 @@ set_timer:
 	* The interval must be the shortest necessary to satisfy ANI,
 	* short calibration and long calibration.
 	*/
+	ath9k_debug_samp_bb_mac(sc);
 	cal_interval = ATH_LONG_CALINTERVAL;
 	if (sc->sc_ah->config.enable_ani)
 		cal_interval = min(cal_interval,
@@ -978,6 +979,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	sc->hw_busy_count = 0;
 
+	ath9k_debug_samp_bb_mac(sc);
 	/* Stop ANI */
 
 	del_timer_sync(&common->ani.timer);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ad5f9bd..51b47f4 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -952,23 +952,12 @@ static void ath9k_process_rssi(struct ath_common *common,
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = common->ah;
 	int last_rssi;
-	__le16 fc;
 
-	if ((ah->opmode != NL80211_IFTYPE_STATION) &&
-	    (ah->opmode != NL80211_IFTYPE_ADHOC))
+	if (!rx_stats->is_mybeacon ||
+	    ((ah->opmode != NL80211_IFTYPE_STATION) &&
+	     (ah->opmode != NL80211_IFTYPE_ADHOC)))
 		return;
 
-	fc = hdr->frame_control;
-	if (!ieee80211_is_beacon(fc) ||
-	    compare_ether_addr(hdr->addr3, common->curbssid)) {
-		/* TODO:  This doesn't work well if you have stations
-		 * associated to two different APs because curbssid
-		 * is just the last AP that any of the stations associated
-		 * with.
-		 */
-		return;
-	}
-
 	if (rx_stats->rs_rssi != ATH9K_RSSI_BAD && !rx_stats->rs_moreaggr)
 		ATH_RSSI_LPF(sc->last_rssi, rx_stats->rs_rssi);
 
@@ -1838,6 +1827,11 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 
 		hdr = (struct ieee80211_hdr *) (hdr_skb->data + rx_status_len);
 		rxs = IEEE80211_SKB_RXCB(hdr_skb);
+		if (ieee80211_is_beacon(hdr->frame_control) &&
+		    !compare_ether_addr(hdr->addr3, common->curbssid))
+			rs.is_mybeacon = true;
+		else
+			rs.is_mybeacon = false;
 
 		ath_debug_stat_rx(sc, &rs);
 
-- 
1.7.6.1

