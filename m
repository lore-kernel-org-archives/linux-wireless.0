Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36861 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0JAT0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 15:26:35 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Report total tx/rx bytes and packets in debugfs.
Date: Fri,  1 Oct 2010 12:26:30 -0700
Message-Id: <1285961190-7065-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Includes pkts/bytes that may have had errors, and includes
wireless headers when counting bytes.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 d65a896... 62b2e97... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 5d21704... 822b6f3... M	drivers/net/wireless/ath/ath9k/debug.h
 drivers/net/wireless/ath/ath9k/debug.c |   15 +++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h |   12 ++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index d65a896..62b2e97 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -696,6 +696,8 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("DESC CFG Error:  ", desc_cfg_err);
 	PR("DATA Underrun:   ", data_underrun);
 	PR("DELIM Underrun:  ", delim_underrun);
+	PR("TX-Pkts-All:     ", tx_pkts_all);
+	PR("TX-Bytes-All:    ", tx_bytes_all);
 
 	if (len > size)
 		len = size;
@@ -709,6 +711,9 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_txq *txq,
 		       struct ath_buf *bf, struct ath_tx_status *ts)
 {
+	TX_STAT_INC(txq->axq_qnum, tx_pkts_all);
+	sc->debug.stats.txstats[txq->axq_qnum].tx_bytes_all += bf->bf_mpdu->len;
+
 	if (bf_isampdu(bf)) {
 		if (bf_isxretried(bf))
 			TX_STAT_INC(txq->axq_qnum, a_xretries);
@@ -803,6 +808,13 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	PHY_ERR("HT-LENGTH", ATH9K_PHYERR_HT_LENGTH_ILLEGAL);
 	PHY_ERR("HT-RATE", ATH9K_PHYERR_HT_RATE_ILLEGAL);
 
+	len += snprintf(buf + len, size - len,
+			"%18s : %10u\n", "RX-Pkts-All",
+			sc->debug.stats.rxstats.rx_pkts_all);
+	len += snprintf(buf + len, size - len,
+			"%18s : %10u\n", "RX-Bytes-All",
+			sc->debug.stats.rxstats.rx_bytes_all);
+
 	if (len > size)
 		len = size;
 
@@ -821,6 +833,9 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 
 	u32 phyerr;
 
+	RX_STAT_INC(rx_pkts_all);
+	sc->debug.stats.rxstats.rx_bytes_all += rs->rs_datalen;
+
 	if (rs->rs_status & ATH9K_RXERR_CRC)
 		RX_STAT_INC(crc_err);
 	if (rs->rs_status & ATH9K_RXERR_DECRYPT)
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 5d21704..822b6f3 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -89,6 +89,10 @@ struct ath_rc_stats {
 
 /**
  * struct ath_tx_stats - Statistics about TX
+ * @tx_pkts_all:  No. of total frames transmitted, including ones that
+	may have had errors.
+ * @tx_bytes_all:  No. of total bytes transmitted, including ones that
+	may have had errors.
  * @queued: Total MPDUs (non-aggr) queued
  * @completed: Total MPDUs (non-aggr) completed
  * @a_aggr: Total no. of aggregates queued
@@ -107,6 +111,8 @@ struct ath_rc_stats {
  * @delim_urn: TX delimiter underrun errors
  */
 struct ath_tx_stats {
+	u32 tx_pkts_all;
+	u32 tx_bytes_all;
 	u32 queued;
 	u32 completed;
 	u32 a_aggr;
@@ -124,6 +130,10 @@ struct ath_tx_stats {
 
 /**
  * struct ath_rx_stats - RX Statistics
+ * @rx_pkts_all:  No. of total frames received, including ones that
+	may have had errors.
+ * @rx_bytes_all:  No. of total bytes received, including ones that
+	may have had errors.
  * @crc_err: No. of frames with incorrect CRC value
  * @decrypt_crc_err: No. of frames whose CRC check failed after
 	decryption process completed
@@ -136,6 +146,8 @@ struct ath_tx_stats {
  * @phy_err_stats: Individual PHY error statistics
  */
 struct ath_rx_stats {
+	u32 rx_pkts_all;
+	u32 rx_bytes_all;
 	u32 crc_err;
 	u32 decrypt_crc_err;
 	u32 phy_err;
-- 
1.7.2.2

