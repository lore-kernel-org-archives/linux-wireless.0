Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57911 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab0AHEtN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 23:49:13 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 20:49:13 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19270.48451.389665.925636@gargle.gargle.HOWL>
Date: Fri, 8 Jan 2010 10:36:11 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/7] ath9k: Add debugfs file for RX errors
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This file can be used to track frame reception errors.
PHY error counts are also added.

Location: ath9k/phy#/recv

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |  118 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h |   32 +++++++++
 drivers/net/wireless/ath/ath9k/mac.h   |   34 +++++++++
 drivers/net/wireless/ath/ath9k/recv.c  |    2 +
 4 files changed, 186 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 592f1b7..9489b6b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -580,6 +580,116 @@ static const struct file_operations fops_xmit = {
 	.owner = THIS_MODULE
 };
 
+static ssize_t read_file_recv(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+#define PHY_ERR(s, p) \
+	len += snprintf(buf + len, size - len, "%18s : %10u\n", s, \
+			sc->debug.stats.rxstats.phy_err_stats[p]);
+
+	struct ath_softc *sc = file->private_data;
+	char *buf;
+	unsigned int len = 0, size = 1152;
+	ssize_t retval = 0;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return 0;
+
+	len += snprintf(buf + len, size - len,
+			"%18s : %10u\n", "CRC ERR",
+			sc->debug.stats.rxstats.crc_err);
+	len += snprintf(buf + len, size - len,
+			"%18s : %10u\n", "DECRYPT CRC ERR",
+			sc->debug.stats.rxstats.decrypt_crc_err);
+	len += snprintf(buf + len, size - len,
+			"%18s : %10u\n", "PHY ERR",
+			sc->debug.stats.rxstats.phy_err);
+	len += snprintf(buf + len, size - len,
+			"%18s : %10u\n", "MIC ERR",
+			sc->debug.stats.rxstats.mic_err);
+	len += snprintf(buf + len, size - len,
+			"%18s : %10u\n", "PRE-DELIM CRC ERR",
+			sc->debug.stats.rxstats.pre_delim_crc_err);
+	len += snprintf(buf + len, size - len,
+			"%18s : %10u\n", "POST-DELIM CRC ERR",
+			sc->debug.stats.rxstats.post_delim_crc_err);
+	len += snprintf(buf + len, size - len,
+			"%18s : %10u\n", "DECRYPT BUSY ERR",
+			sc->debug.stats.rxstats.decrypt_busy_err);
+
+	PHY_ERR("UNDERRUN", ATH9K_PHYERR_UNDERRUN);
+	PHY_ERR("TIMING", ATH9K_PHYERR_TIMING);
+	PHY_ERR("PARITY", ATH9K_PHYERR_PARITY);
+	PHY_ERR("RATE", ATH9K_PHYERR_RATE);
+	PHY_ERR("LENGTH", ATH9K_PHYERR_LENGTH);
+	PHY_ERR("RADAR", ATH9K_PHYERR_RADAR);
+	PHY_ERR("SERVICE", ATH9K_PHYERR_SERVICE);
+	PHY_ERR("TOR", ATH9K_PHYERR_TOR);
+	PHY_ERR("OFDM-TIMING", ATH9K_PHYERR_OFDM_TIMING);
+	PHY_ERR("OFDM-SIGNAL-PARITY", ATH9K_PHYERR_OFDM_SIGNAL_PARITY);
+	PHY_ERR("OFDM-RATE", ATH9K_PHYERR_OFDM_RATE_ILLEGAL);
+	PHY_ERR("OFDM-LENGTH", ATH9K_PHYERR_OFDM_LENGTH_ILLEGAL);
+	PHY_ERR("OFDM-POWER-DROP", ATH9K_PHYERR_OFDM_POWER_DROP);
+	PHY_ERR("OFDM-SERVICE", ATH9K_PHYERR_OFDM_SERVICE);
+	PHY_ERR("OFDM-RESTART", ATH9K_PHYERR_OFDM_RESTART);
+	PHY_ERR("FALSE-RADAR-EXT", ATH9K_PHYERR_FALSE_RADAR_EXT);
+	PHY_ERR("CCK-TIMING", ATH9K_PHYERR_CCK_TIMING);
+	PHY_ERR("CCK-HEADER-CRC", ATH9K_PHYERR_CCK_HEADER_CRC);
+	PHY_ERR("CCK-RATE", ATH9K_PHYERR_CCK_RATE_ILLEGAL);
+	PHY_ERR("CCK-SERVICE", ATH9K_PHYERR_CCK_SERVICE);
+	PHY_ERR("CCK-RESTART", ATH9K_PHYERR_CCK_RESTART);
+	PHY_ERR("CCK-LENGTH", ATH9K_PHYERR_CCK_LENGTH_ILLEGAL);
+	PHY_ERR("CCK-POWER-DROP", ATH9K_PHYERR_CCK_POWER_DROP);
+	PHY_ERR("HT-CRC", ATH9K_PHYERR_HT_CRC_ERROR);
+	PHY_ERR("HT-LENGTH", ATH9K_PHYERR_HT_LENGTH_ILLEGAL);
+	PHY_ERR("HT-RATE", ATH9K_PHYERR_HT_RATE_ILLEGAL);
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+
+#undef PHY_ERR
+}
+
+void ath_debug_stat_rx(struct ath_softc *sc, struct ath_buf *bf)
+{
+#define RX_STAT_INC(c) sc->debug.stats.rxstats.c++
+#define RX_PHY_ERR_INC(c) sc->debug.stats.rxstats.phy_err_stats[c]++
+
+	struct ath_desc *ds = bf->bf_desc;
+	u32 phyerr;
+
+	if (ds->ds_rxstat.rs_status & ATH9K_RXERR_CRC)
+		RX_STAT_INC(crc_err);
+	if (ds->ds_rxstat.rs_status & ATH9K_RXERR_DECRYPT)
+		RX_STAT_INC(decrypt_crc_err);
+	if (ds->ds_rxstat.rs_status & ATH9K_RXERR_MIC)
+		RX_STAT_INC(mic_err);
+	if (ds->ds_rxstat.rs_status & ATH9K_RX_DELIM_CRC_PRE)
+		RX_STAT_INC(pre_delim_crc_err);
+	if (ds->ds_rxstat.rs_status & ATH9K_RX_DELIM_CRC_POST)
+		RX_STAT_INC(post_delim_crc_err);
+	if (ds->ds_rxstat.rs_status & ATH9K_RX_DECRYPT_BUSY)
+		RX_STAT_INC(decrypt_busy_err);
+
+	if (ds->ds_rxstat.rs_status & ATH9K_RXERR_PHY) {
+		RX_STAT_INC(phy_err);
+		phyerr = ds->ds_rxstat.rs_phyerr & 0x24;
+		RX_PHY_ERR_INC(phyerr);
+	}
+
+#undef RX_STAT_INC
+#undef RX_PHY_ERR_INC
+}
+
+static const struct file_operations fops_recv = {
+	.read = read_file_recv,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE
+};
+
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -632,6 +742,13 @@ int ath9k_init_debug(struct ath_hw *ah)
 	if (!sc->debug.debugfs_xmit)
 		goto err;
 
+	sc->debug.debugfs_recv = debugfs_create_file("recv",
+						     S_IRUSR,
+						     sc->debug.debugfs_phy,
+						     sc, &fops_recv);
+	if (!sc->debug.debugfs_recv)
+		goto err;
+
 	return 0;
 err:
 	ath9k_exit_debug(ah);
@@ -643,6 +760,7 @@ void ath9k_exit_debug(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
 
+	debugfs_remove(sc->debug.debugfs_recv);
 	debugfs_remove(sc->debug.debugfs_xmit);
 	debugfs_remove(sc->debug.debugfs_wiphy);
 	debugfs_remove(sc->debug.debugfs_rcstat);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 536663e..86780e6 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -116,10 +116,35 @@ struct ath_tx_stats {
 	u32 delim_underrun;
 };
 
+/**
+ * struct ath_rx_stats - RX Statistics
+ * @crc_err: No. of frames with incorrect CRC value
+ * @decrypt_crc_err: No. of frames whose CRC check failed after
+	decryption process completed
+ * @phy_err: No. of frames whose reception failed because the PHY
+	encountered an error
+ * @mic_err: No. of frames with incorrect TKIP MIC verification failure
+ * @pre_delim_crc_err: Pre-Frame delimiter CRC error detections
+ * @post_delim_crc_err: Post-Frame delimiter CRC error detections
+ * @decrypt_busy_err: Decryption interruptions counter
+ * @phy_err_stats: Individual PHY error statistics
+ */
+struct ath_rx_stats {
+	u32 crc_err;
+	u32 decrypt_crc_err;
+	u32 phy_err;
+	u32 mic_err;
+	u32 pre_delim_crc_err;
+	u32 post_delim_crc_err;
+	u32 decrypt_busy_err;
+	u32 phy_err_stats[ATH9K_PHYERR_MAX];
+};
+
 struct ath_stats {
 	struct ath_interrupt_stats istats;
 	struct ath_rc_stats rcstats[RATE_TABLE_SIZE];
 	struct ath_tx_stats txstats[ATH9K_NUM_TX_QUEUES];
+	struct ath_rx_stats rxstats;
 };
 
 struct ath9k_debug {
@@ -130,6 +155,7 @@ struct ath9k_debug {
 	struct dentry *debugfs_rcstat;
 	struct dentry *debugfs_wiphy;
 	struct dentry *debugfs_xmit;
+	struct dentry *debugfs_recv;
 	struct ath_stats stats;
 };
 
@@ -142,6 +168,7 @@ void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
 void ath_debug_stat_rc(struct ath_softc *sc, int final_rate);
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_txq *txq,
 		       struct ath_buf *bf);
+void ath_debug_stat_rx(struct ath_softc *sc, struct ath_buf *bf);
 void ath_debug_stat_retries(struct ath_softc *sc, int rix,
 			    int xretries, int retries, u8 per);
 
@@ -181,6 +208,11 @@ static inline void ath_debug_stat_tx(struct ath_softc *sc,
 {
 }
 
+static inline void ath_debug_stat_rx(struct ath_softc *sc,
+				     struct ath_buf *bf)
+{
+}
+
 static inline void ath_debug_stat_retries(struct ath_softc *sc, int rix,
 					  int xretries, int retries, u8 per)
 {
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index e185479..29851e6 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -167,6 +167,40 @@ struct ath_rx_status {
 #define ATH9K_RXKEYIX_INVALID	((u8)-1)
 #define ATH9K_TXKEYIX_INVALID	((u32)-1)
 
+enum ath9k_phyerr {
+	ATH9K_PHYERR_UNDERRUN             = 0,  /* Transmit underrun */
+	ATH9K_PHYERR_TIMING               = 1,  /* Timing error */
+	ATH9K_PHYERR_PARITY               = 2,  /* Illegal parity */
+	ATH9K_PHYERR_RATE                 = 3,  /* Illegal rate */
+	ATH9K_PHYERR_LENGTH               = 4,  /* Illegal length */
+	ATH9K_PHYERR_RADAR                = 5,  /* Radar detect */
+	ATH9K_PHYERR_SERVICE              = 6,  /* Illegal service */
+	ATH9K_PHYERR_TOR                  = 7,  /* Transmit override receive */
+
+	ATH9K_PHYERR_OFDM_TIMING          = 17,
+	ATH9K_PHYERR_OFDM_SIGNAL_PARITY   = 18,
+	ATH9K_PHYERR_OFDM_RATE_ILLEGAL    = 19,
+	ATH9K_PHYERR_OFDM_LENGTH_ILLEGAL  = 20,
+	ATH9K_PHYERR_OFDM_POWER_DROP      = 21,
+	ATH9K_PHYERR_OFDM_SERVICE         = 22,
+	ATH9K_PHYERR_OFDM_RESTART         = 23,
+	ATH9K_PHYERR_FALSE_RADAR_EXT      = 24,
+
+	ATH9K_PHYERR_CCK_TIMING           = 25,
+	ATH9K_PHYERR_CCK_HEADER_CRC       = 26,
+	ATH9K_PHYERR_CCK_RATE_ILLEGAL     = 27,
+	ATH9K_PHYERR_CCK_SERVICE          = 30,
+	ATH9K_PHYERR_CCK_RESTART          = 31,
+	ATH9K_PHYERR_CCK_LENGTH_ILLEGAL   = 32,
+	ATH9K_PHYERR_CCK_POWER_DROP       = 33,
+
+	ATH9K_PHYERR_HT_CRC_ERROR         = 34,
+	ATH9K_PHYERR_HT_LENGTH_ILLEGAL    = 35,
+	ATH9K_PHYERR_HT_RATE_ILLEGAL      = 36,
+
+	ATH9K_PHYERR_MAX                  = 37,
+};
+
 struct ath_desc {
 	u32 ds_link;
 	u32 ds_data;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 17b0a6d..40b5d05 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -571,6 +571,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		hw = ath_get_virt_hw(sc, hdr);
 		rx_stats = &ds->ds_rxstat;
 
+		ath_debug_stat_rx(sc, bf);
+
 		/*
 		 * If we're asked to flush receive queue, directly
 		 * chain it back at the queue without processing it.
-- 
1.6.6

