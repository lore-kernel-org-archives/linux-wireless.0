Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48137 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3EGXf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 19:35:56 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] ath9k: Remove MAC_DEBUG
Date: Wed,  8 May 2013 05:03:30 +0530
Message-Id: <1367969613-1867-1-git-send-email-sujith@msujith.org> (sfid-20130508_013602_429422_96A0977B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This option has not been enabled by default in any
distribution, has never been enabled in OpenWrt and no developer
has asked for this information in a bug report.

Dumping pages of random values doesn't help debugging,
remove this option (along with the vmalloc() abuse).

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |   8 -
 drivers/net/wireless/ath/ath9k/debug.c | 337 ---------------------------------
 drivers/net/wireless/ath/ath9k/debug.h |  20 --
 drivers/net/wireless/ath/ath9k/init.c  |   3 -
 drivers/net/wireless/ath/ath9k/link.c  |   1 -
 drivers/net/wireless/ath/ath9k/main.c  |   1 -
 6 files changed, 370 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 17507dc..ec33c80 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -84,14 +84,6 @@ config ATH9K_DFS_CERTIFIED
 	  developed. At this point enabling this option won't do anything
 	  except increase code size.
 
-config ATH9K_MAC_DEBUG
-	bool "Atheros MAC statistics"
-	depends on ATH9K_DEBUGFS
-	default y
-	---help---
-	  This option enables collection of statistics for Rx/Tx status
-	  data and some other MAC related statistics
-
 config ATH9K_RATE_CONTROL
 	bool "Atheros ath9k rate control"
 	depends on ATH9K
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index e6307b8..fc96ad3 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -738,8 +738,6 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		       struct ath_tx_status *ts, struct ath_txq *txq,
 		       unsigned int flags)
 {
-#define TX_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].ts\
-			[sc->debug.tsidx].c)
 	int qnum = txq->axq_qnum;
 
 	TX_STAT_INC(qnum, tx_pkts_all);
@@ -771,37 +769,6 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		TX_STAT_INC(qnum, data_underrun);
 	if (ts->ts_flags & ATH9K_TX_DELIM_UNDERRUN)
 		TX_STAT_INC(qnum, delim_underrun);
-
-#ifdef CONFIG_ATH9K_MAC_DEBUG
-	spin_lock(&sc->debug.samp_lock);
-	TX_SAMP_DBG(jiffies) = jiffies;
-	TX_SAMP_DBG(rssi_ctl0) = ts->ts_rssi_ctl0;
-	TX_SAMP_DBG(rssi_ctl1) = ts->ts_rssi_ctl1;
-	TX_SAMP_DBG(rssi_ctl2) = ts->ts_rssi_ctl2;
-	TX_SAMP_DBG(rssi_ext0) = ts->ts_rssi_ext0;
-	TX_SAMP_DBG(rssi_ext1) = ts->ts_rssi_ext1;
-	TX_SAMP_DBG(rssi_ext2) = ts->ts_rssi_ext2;
-	TX_SAMP_DBG(rateindex) = ts->ts_rateindex;
-	TX_SAMP_DBG(isok) = !!(ts->ts_status & ATH9K_TXERR_MASK);
-	TX_SAMP_DBG(rts_fail_cnt) = ts->ts_shortretry;
-	TX_SAMP_DBG(data_fail_cnt) = ts->ts_longretry;
-	TX_SAMP_DBG(rssi) = ts->ts_rssi;
-	TX_SAMP_DBG(tid) = ts->tid;
-	TX_SAMP_DBG(qid) = ts->qid;
-
-	if (ts->ts_flags & ATH9K_TX_BA) {
-		TX_SAMP_DBG(ba_low) = ts->ba_low;
-		TX_SAMP_DBG(ba_high) = ts->ba_high;
-	} else {
-		TX_SAMP_DBG(ba_low) = 0;
-		TX_SAMP_DBG(ba_high) = 0;
-	}
-
-	sc->debug.tsidx = (sc->debug.tsidx + 1) % ATH_DBG_MAX_SAMPLES;
-	spin_unlock(&sc->debug.samp_lock);
-#endif
-
-#undef TX_SAMP_DBG
 }
 
 static const struct file_operations fops_xmit = {
@@ -915,8 +882,6 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 {
 #define RX_PHY_ERR_INC(c) sc->debug.stats.rxstats.phy_err_stats[c]++
-#define RX_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].rs\
-			[sc->debug.rsidx].c)
 
 	RX_STAT_INC(rx_pkts_all);
 	sc->debug.stats.rxstats.rx_bytes_all += rs->rs_datalen;
@@ -940,27 +905,7 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 			RX_PHY_ERR_INC(rs->rs_phyerr);
 	}
 
-#ifdef CONFIG_ATH9K_MAC_DEBUG
-	spin_lock(&sc->debug.samp_lock);
-	RX_SAMP_DBG(jiffies) = jiffies;
-	RX_SAMP_DBG(rssi_ctl0) = rs->rs_rssi_ctl0;
-	RX_SAMP_DBG(rssi_ctl1) = rs->rs_rssi_ctl1;
-	RX_SAMP_DBG(rssi_ctl2) = rs->rs_rssi_ctl2;
-	RX_SAMP_DBG(rssi_ext0) = rs->rs_rssi_ext0;
-	RX_SAMP_DBG(rssi_ext1) = rs->rs_rssi_ext1;
-	RX_SAMP_DBG(rssi_ext2) = rs->rs_rssi_ext2;
-	RX_SAMP_DBG(antenna) = rs->rs_antenna;
-	RX_SAMP_DBG(rssi) = rs->rs_rssi;
-	RX_SAMP_DBG(rate) = rs->rs_rate;
-	RX_SAMP_DBG(is_mybeacon) = rs->is_mybeacon;
-
-	sc->debug.rsidx = (sc->debug.rsidx + 1) % ATH_DBG_MAX_SAMPLES;
-	spin_unlock(&sc->debug.samp_lock);
-
-#endif
-
 #undef RX_PHY_ERR_INC
-#undef RX_SAMP_DBG
 }
 
 static const struct file_operations fops_recv = {
@@ -1485,283 +1430,6 @@ static const struct file_operations fops_modal_eeprom = {
 	.llseek = default_llseek,
 };
 
-#ifdef CONFIG_ATH9K_MAC_DEBUG
-
-void ath9k_debug_samp_bb_mac(struct ath_softc *sc)
-{
-#define ATH_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].c)
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	unsigned long flags;
-	int i;
-
-	ath9k_ps_wakeup(sc);
-
-	spin_lock_bh(&sc->debug.samp_lock);
-
-	spin_lock_irqsave(&common->cc_lock, flags);
-	ath_hw_cycle_counters_update(common);
-
-	ATH_SAMP_DBG(cc.cycles) = common->cc_ani.cycles;
-	ATH_SAMP_DBG(cc.rx_busy) = common->cc_ani.rx_busy;
-	ATH_SAMP_DBG(cc.rx_frame) = common->cc_ani.rx_frame;
-	ATH_SAMP_DBG(cc.tx_frame) = common->cc_ani.tx_frame;
-	spin_unlock_irqrestore(&common->cc_lock, flags);
-
-	ATH_SAMP_DBG(noise) = ah->noise;
-
-	REG_WRITE_D(ah, AR_MACMISC,
-		  ((AR_MACMISC_DMA_OBS_LINE_8 << AR_MACMISC_DMA_OBS_S) |
-		   (AR_MACMISC_MISC_OBS_BUS_1 <<
-		    AR_MACMISC_MISC_OBS_BUS_MSB_S)));
-
-	for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++)
-		ATH_SAMP_DBG(dma_dbg_reg_vals[i]) = REG_READ_D(ah,
-				AR_DMADBG_0 + (i * sizeof(u32)));
-
-	ATH_SAMP_DBG(pcu_obs) = REG_READ_D(ah, AR_OBS_BUS_1);
-	ATH_SAMP_DBG(pcu_cr) = REG_READ_D(ah, AR_CR);
-
-	memcpy(ATH_SAMP_DBG(nfCalHist), sc->caldata.nfCalHist,
-			sizeof(ATH_SAMP_DBG(nfCalHist)));
-
-	sc->debug.sampidx = (sc->debug.sampidx + 1) % ATH_DBG_MAX_SAMPLES;
-	spin_unlock_bh(&sc->debug.samp_lock);
-	ath9k_ps_restore(sc);
-
-#undef ATH_SAMP_DBG
-}
-
-static int open_file_bb_mac_samps(struct inode *inode, struct file *file)
-{
-#define ATH_SAMP_DBG(c) bb_mac_samp[sampidx].c
-	struct ath_softc *sc = inode->i_private;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_conf *conf = &common->hw->conf;
-	struct ath_dbg_bb_mac_samp *bb_mac_samp;
-	struct ath9k_nfcal_hist *h;
-	int i, j, qcuOffset = 0, dcuOffset = 0;
-	u32 *qcuBase, *dcuBase, size = 30000, len = 0;
-	u32 sampidx = 0;
-	u8 *buf;
-	u8 chainmask = (ah->rxchainmask << 3) | ah->rxchainmask;
-	u8 nread;
-
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags))
-		return -EAGAIN;
-
-	buf = vmalloc(size);
-	if (!buf)
-		return -ENOMEM;
-	bb_mac_samp = vmalloc(sizeof(*bb_mac_samp) * ATH_DBG_MAX_SAMPLES);
-	if (!bb_mac_samp) {
-		vfree(buf);
-		return -ENOMEM;
-	}
-	/* Account the current state too */
-	ath9k_debug_samp_bb_mac(sc);
-
-	spin_lock_bh(&sc->debug.samp_lock);
-	memcpy(bb_mac_samp, sc->debug.bb_mac_samp,
-			sizeof(*bb_mac_samp) * ATH_DBG_MAX_SAMPLES);
-	len += snprintf(buf + len, size - len,
-			"Current Sample Index: %d\n", sc->debug.sampidx);
-	spin_unlock_bh(&sc->debug.samp_lock);
-
-	len += snprintf(buf + len, size - len,
-			"Raw DMA Debug Dump:\n");
-	len += snprintf(buf + len, size - len, "Sample |\t");
-	for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++)
-		len += snprintf(buf + len, size - len, " DMA Reg%d |\t", i);
-	len += snprintf(buf + len, size - len, "\n");
-
-	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
-		len += snprintf(buf + len, size - len, "%d\t", sampidx);
-
-		for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++)
-			len += snprintf(buf + len, size - len, " %08x\t",
-					ATH_SAMP_DBG(dma_dbg_reg_vals[i]));
-		len += snprintf(buf + len, size - len, "\n");
-	}
-	len += snprintf(buf + len, size - len, "\n");
-
-	len += snprintf(buf + len, size - len,
-			"Sample Num QCU: chain_st fsp_ok fsp_st DCU: chain_st\n");
-	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
-		qcuBase = &ATH_SAMP_DBG(dma_dbg_reg_vals[0]);
-		dcuBase = &ATH_SAMP_DBG(dma_dbg_reg_vals[4]);
-
-		for (i = 0; i < ATH9K_NUM_QUEUES; i++,
-				qcuOffset += 4, dcuOffset += 5) {
-			if (i == 8) {
-				qcuOffset = 0;
-				qcuBase++;
-			}
-
-			if (i == 6) {
-				dcuOffset = 0;
-				dcuBase++;
-			}
-			if (!sc->debug.stats.txstats[i].queued)
-				continue;
-
-			len += snprintf(buf + len, size - len,
-				"%4d %7d    %2x      %1x     %2x         %2x\n",
-				sampidx, i,
-				(*qcuBase & (0x7 << qcuOffset)) >> qcuOffset,
-				(*qcuBase & (0x8 << qcuOffset)) >>
-				(qcuOffset + 3),
-				ATH_SAMP_DBG(dma_dbg_reg_vals[2]) &
-				(0x7 << (i * 3)) >> (i * 3),
-				(*dcuBase & (0x1f << dcuOffset)) >> dcuOffset);
-		}
-		len += snprintf(buf + len, size - len, "\n");
-	}
-	len += snprintf(buf + len, size - len,
-			"samp qcu_sh qcu_fh qcu_comp dcu_comp dcu_arb dcu_fp "
-			"ch_idle_dur ch_idle_dur_val txfifo_val0 txfifo_val1 "
-			"txfifo_dcu0 txfifo_dcu1 pcu_obs AR_CR\n");
-
-	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
-		qcuBase = &ATH_SAMP_DBG(dma_dbg_reg_vals[0]);
-		dcuBase = &ATH_SAMP_DBG(dma_dbg_reg_vals[4]);
-
-		len += snprintf(buf + len, size - len, "%4d %5x %5x ", sampidx,
-			(ATH_SAMP_DBG(dma_dbg_reg_vals[3]) & 0x003c0000) >> 18,
-			(ATH_SAMP_DBG(dma_dbg_reg_vals[3]) & 0x03c00000) >> 22);
-		len += snprintf(buf + len, size - len, "%7x %8x ",
-			(ATH_SAMP_DBG(dma_dbg_reg_vals[3]) & 0x1c000000) >> 26,
-			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x3));
-		len += snprintf(buf + len, size - len, "%7x %7x ",
-			(ATH_SAMP_DBG(dma_dbg_reg_vals[5]) & 0x06000000) >> 25,
-			(ATH_SAMP_DBG(dma_dbg_reg_vals[5]) & 0x38000000) >> 27);
-		len += snprintf(buf + len, size - len, "%7d %12d ",
-			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x000003fc) >> 2,
-			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x00000400) >> 10);
-		len += snprintf(buf + len, size - len, "%12d %12d ",
-			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x00000800) >> 11,
-			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x00001000) >> 12);
-		len += snprintf(buf + len, size - len, "%12d %12d ",
-			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x0001e000) >> 13,
-			(ATH_SAMP_DBG(dma_dbg_reg_vals[6]) & 0x001e0000) >> 17);
-		len += snprintf(buf + len, size - len, "0x%07x 0x%07x\n",
-				ATH_SAMP_DBG(pcu_obs), ATH_SAMP_DBG(pcu_cr));
-	}
-
-	len += snprintf(buf + len, size - len,
-			"Sample ChNoise Chain privNF #Reading Readings\n");
-	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
-		h = ATH_SAMP_DBG(nfCalHist);
-		if (!ATH_SAMP_DBG(noise))
-			continue;
-
-		for (i = 0; i < NUM_NF_READINGS; i++) {
-			if (!(chainmask & (1 << i)) ||
-			    ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf)))
-				continue;
-
-			nread = AR_PHY_CCA_FILTERWINDOW_LENGTH -
-				h[i].invalidNFcount;
-			len += snprintf(buf + len, size - len,
-					"%4d %5d %4d\t   %d\t %d\t",
-					sampidx, ATH_SAMP_DBG(noise),
-					i, h[i].privNF, nread);
-			for (j = 0; j < nread; j++)
-				len += snprintf(buf + len, size - len,
-					" %d", h[i].nfCalBuffer[j]);
-			len += snprintf(buf + len, size - len, "\n");
-		}
-	}
-	len += snprintf(buf + len, size - len, "\nCycle counters:\n"
-			"Sample Total    Rxbusy   Rxframes Txframes\n");
-	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
-		if (!ATH_SAMP_DBG(cc.cycles))
-			continue;
-		len += snprintf(buf + len, size - len,
-				"%4d %08x %08x %08x %08x\n",
-				sampidx, ATH_SAMP_DBG(cc.cycles),
-				ATH_SAMP_DBG(cc.rx_busy),
-				ATH_SAMP_DBG(cc.rx_frame),
-				ATH_SAMP_DBG(cc.tx_frame));
-	}
-
-	len += snprintf(buf + len, size - len, "Tx status Dump :\n");
-	len += snprintf(buf + len, size - len,
-			"Sample rssi:- ctl0 ctl1 ctl2 ext0 ext1 ext2 comb "
-			"isok rts_fail data_fail rate tid qid "
-					"ba_low  ba_high tx_before(ms)\n");
-	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
-		for (i = 0; i < ATH_DBG_MAX_SAMPLES; i++) {
-			if (!ATH_SAMP_DBG(ts[i].jiffies))
-				continue;
-			len += snprintf(buf + len, size - len, "%-14d"
-				"%-4d %-4d %-4d %-4d %-4d %-4d %-4d %-4d %-8d "
-				"%-9d %-4d %-3d %-3d %08x %08x %-11d\n",
-				sampidx,
-				ATH_SAMP_DBG(ts[i].rssi_ctl0),
-				ATH_SAMP_DBG(ts[i].rssi_ctl1),
-				ATH_SAMP_DBG(ts[i].rssi_ctl2),
-				ATH_SAMP_DBG(ts[i].rssi_ext0),
-				ATH_SAMP_DBG(ts[i].rssi_ext1),
-				ATH_SAMP_DBG(ts[i].rssi_ext2),
-				ATH_SAMP_DBG(ts[i].rssi),
-				ATH_SAMP_DBG(ts[i].isok),
-				ATH_SAMP_DBG(ts[i].rts_fail_cnt),
-				ATH_SAMP_DBG(ts[i].data_fail_cnt),
-				ATH_SAMP_DBG(ts[i].rateindex),
-				ATH_SAMP_DBG(ts[i].tid),
-				ATH_SAMP_DBG(ts[i].qid),
-				ATH_SAMP_DBG(ts[i].ba_low),
-				ATH_SAMP_DBG(ts[i].ba_high),
-				jiffies_to_msecs(jiffies -
-					ATH_SAMP_DBG(ts[i].jiffies)));
-		}
-	}
-
-	len += snprintf(buf + len, size - len, "Rx status Dump :\n");
-	len += snprintf(buf + len, size - len, "Sample rssi:- ctl0 ctl1 ctl2 "
-			"ext0 ext1 ext2 comb beacon ant rate rx_before(ms)\n");
-	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
-		for (i = 0; i < ATH_DBG_MAX_SAMPLES; i++) {
-			if (!ATH_SAMP_DBG(rs[i].jiffies))
-				continue;
-			len += snprintf(buf + len, size - len, "%-14d"
-				"%-4d %-4d %-4d %-4d %-4d %-4d %-4d %-9s %-2d %02x %-13d\n",
-				sampidx,
-				ATH_SAMP_DBG(rs[i].rssi_ctl0),
-				ATH_SAMP_DBG(rs[i].rssi_ctl1),
-				ATH_SAMP_DBG(rs[i].rssi_ctl2),
-				ATH_SAMP_DBG(rs[i].rssi_ext0),
-				ATH_SAMP_DBG(rs[i].rssi_ext1),
-				ATH_SAMP_DBG(rs[i].rssi_ext2),
-				ATH_SAMP_DBG(rs[i].rssi),
-				ATH_SAMP_DBG(rs[i].is_mybeacon) ?
-				"True" : "False",
-				ATH_SAMP_DBG(rs[i].antenna),
-				ATH_SAMP_DBG(rs[i].rate),
-				jiffies_to_msecs(jiffies -
-					ATH_SAMP_DBG(rs[i].jiffies)));
-		}
-	}
-
-	vfree(bb_mac_samp);
-	file->private_data = buf;
-
-	return 0;
-#undef ATH_SAMP_DBG
-}
-
-static const struct file_operations fops_samps = {
-	.open = open_file_bb_mac_samps,
-	.read = ath9k_debugfs_read_buf,
-	.release = ath9k_debugfs_release_buf,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-#endif
-
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 static ssize_t read_file_btcoex(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
@@ -2087,11 +1755,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_file("spectral_fft_period", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc,
 			    &fops_spectral_fft_period);
-
-#ifdef CONFIG_ATH9K_MAC_DEBUG
-	debugfs_create_file("samples", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_samps);
-#endif
 	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
 	debugfs_create_u32("gpio_val", S_IRUSR | S_IWUSR,
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 794a7ec..62da19c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -294,13 +294,6 @@ struct ath9k_debug {
 	struct dentry *debugfs_phy;
 	u32 regidx;
 	struct ath_stats stats;
-#ifdef CONFIG_ATH9K_MAC_DEBUG
-	spinlock_t samp_lock;
-	struct ath_dbg_bb_mac_samp bb_mac_samp[ATH_DBG_MAX_SAMPLES];
-	u8 sampidx;
-	u8 tsidx;
-	u8 rsidx;
-#endif
 };
 
 int ath9k_init_debug(struct ath_hw *ah);
@@ -359,17 +352,4 @@ static inline void ath_debug_stat_rx(struct ath_softc *sc,
 
 #endif /* CONFIG_ATH9K_DEBUGFS */
 
-#ifdef CONFIG_ATH9K_MAC_DEBUG
-
-void ath9k_debug_samp_bb_mac(struct ath_softc *sc);
-
-#else
-
-static inline void ath9k_debug_samp_bb_mac(struct ath_softc *sc)
-{
-}
-
-#endif
-
-
 #endif /* DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 0237b28..c7b888f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -613,9 +613,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->sc_pm_lock);
 	mutex_init(&sc->mutex);
-#ifdef CONFIG_ATH9K_MAC_DEBUG
-	spin_lock_init(&sc->debug.samp_lock);
-#endif
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
 	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
 		     (unsigned long)sc);
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 849259b..cc422a4 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -418,7 +418,6 @@ void ath_ani_calibrate(unsigned long data)
 		longcal ? "long" : "", shortcal ? "short" : "",
 		aniflag ? "ani" : "", common->ani.caldone ? "true" : "false");
 
-	ath9k_debug_samp_bb_mac(sc);
 	ath9k_ps_restore(sc);
 
 set_timer:
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a18414b..04bf88a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -193,7 +193,6 @@ static bool ath_prepare_reset(struct ath_softc *sc)
 	ath_stop_ani(sc);
 	del_timer_sync(&sc->rx_poll_timer);
 
-	ath9k_debug_samp_bb_mac(sc);
 	ath9k_hw_disable_interrupts(ah);
 
 	if (!ath_drain_all_txq(sc))
-- 
1.8.2.2

