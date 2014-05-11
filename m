Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62207 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757662AbaEKIFP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:05:15 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 06/10] ath9k & ath9k_htc: move ath_rx_stats to cmn
Date: Sun, 11 May 2014 10:04:36 +0200
Message-Id: <1399795480-7459-7-git-send-email-linux@rempel-privat.de> (sfid-20140511_100532_197790_D61CE517)
In-Reply-To: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
References: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and use it. This move need changes in both drivers.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/common-debug.c  | 33 ++++++++++
 drivers/net/wireless/ath/ath9k/common-debug.h  | 48 ++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.c         | 26 +-------
 drivers/net/wireless/ath/ath9k/debug.h         | 44 -------------
 drivers/net/wireless/ath/ath9k/htc.h           | 17 ++---
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c | 88 +++++++-------------------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c  |  3 +-
 7 files changed, 111 insertions(+), 148 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-debug.c b/drivers/net/wireless/ath/ath9k/common-debug.c
index f2234e0..ef538d2 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.c
+++ b/drivers/net/wireless/ath/ath9k/common-debug.c
@@ -86,3 +86,36 @@ void ath9k_cmn_debug_base_eeprom(struct dentry *debugfs_phy,
 			    &fops_base_eeprom);
 }
 EXPORT_SYMBOL(ath9k_cmn_debug_base_eeprom);
+
+void ath9k_cmn_debug_stat_rx(struct ath_rx_stats *rxstats,
+			     struct ath_rx_status *rs)
+{
+#define RX_PHY_ERR_INC(c) rxstats->phy_err_stats[c]++
+#define RX_CMN_STAT_INC(c) (rxstats->c++)
+
+	RX_CMN_STAT_INC(rx_pkts_all);
+	rxstats->rx_bytes_all += rs->rs_datalen;
+
+	if (rs->rs_status & ATH9K_RXERR_CRC)
+		RX_CMN_STAT_INC(crc_err);
+	if (rs->rs_status & ATH9K_RXERR_DECRYPT)
+		RX_CMN_STAT_INC(decrypt_crc_err);
+	if (rs->rs_status & ATH9K_RXERR_MIC)
+		RX_CMN_STAT_INC(mic_err);
+	if (rs->rs_status & ATH9K_RX_DELIM_CRC_PRE)
+		RX_CMN_STAT_INC(pre_delim_crc_err);
+	if (rs->rs_status & ATH9K_RX_DELIM_CRC_POST)
+		RX_CMN_STAT_INC(post_delim_crc_err);
+	if (rs->rs_status & ATH9K_RX_DECRYPT_BUSY)
+		RX_CMN_STAT_INC(decrypt_busy_err);
+
+	if (rs->rs_status & ATH9K_RXERR_PHY) {
+		RX_CMN_STAT_INC(phy_err);
+		if (rs->rs_phyerr < ATH9K_PHYERR_MAX)
+			RX_PHY_ERR_INC(rs->rs_phyerr);
+	}
+
+#undef RX_CMN_STAT_INC
+#undef RX_PHY_ERR_INC
+}
+EXPORT_SYMBOL(ath9k_cmn_debug_stat_rx);
diff --git a/drivers/net/wireless/ath/ath9k/common-debug.h b/drivers/net/wireless/ath/ath9k/common-debug.h
index 78eaf90..2fcd307 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.h
+++ b/drivers/net/wireless/ath/ath9k/common-debug.h
@@ -14,7 +14,55 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+
+
+/**
+ * struct ath_rx_stats - RX Statistics
+ * @rx_pkts_all:  No. of total frames received, including ones that
+	may have had errors.
+ * @rx_bytes_all:  No. of total bytes received, including ones that
+	may have had errors.
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
+ * @rx_len_err:  No. of frames discarded due to bad length.
+ * @rx_oom_err:  No. of frames dropped due to OOM issues.
+ * @rx_rate_err:  No. of frames dropped due to rate errors.
+ * @rx_too_many_frags_err:  Frames dropped due to too-many-frags received.
+ * @rx_beacons:  No. of beacons received.
+ * @rx_frags:  No. of rx-fragements received.
+ * @rx_spectral: No of spectral packets received.
+ */
+struct ath_rx_stats {
+	u32 rx_pkts_all;
+	u32 rx_bytes_all;
+	u32 crc_err;
+	u32 decrypt_crc_err;
+	u32 phy_err;
+	u32 mic_err;
+	u32 pre_delim_crc_err;
+	u32 post_delim_crc_err;
+	u32 decrypt_busy_err;
+	u32 phy_err_stats[ATH9K_PHYERR_MAX];
+	u32 rx_len_err;
+	u32 rx_oom_err;
+	u32 rx_rate_err;
+	u32 rx_too_many_frags_err;
+	u32 rx_beacons;
+	u32 rx_frags;
+	u32 rx_spectral;
+};
+
 void ath9k_cmn_debug_modal_eeprom(struct dentry *debugfs_phy,
 				  struct ath_hw *ah);
 void ath9k_cmn_debug_base_eeprom(struct dentry *debugfs_phy,
 				 struct ath_hw *ah);
+void ath9k_cmn_debug_stat_rx(struct ath_rx_stats *rxstats,
+			     struct ath_rx_status *rs);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 361f0793..be29e71 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -998,31 +998,7 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 
 void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 {
-#define RX_PHY_ERR_INC(c) sc->debug.stats.rxstats.phy_err_stats[c]++
-
-	RX_STAT_INC(rx_pkts_all);
-	sc->debug.stats.rxstats.rx_bytes_all += rs->rs_datalen;
-
-	if (rs->rs_status & ATH9K_RXERR_CRC)
-		RX_STAT_INC(crc_err);
-	if (rs->rs_status & ATH9K_RXERR_DECRYPT)
-		RX_STAT_INC(decrypt_crc_err);
-	if (rs->rs_status & ATH9K_RXERR_MIC)
-		RX_STAT_INC(mic_err);
-	if (rs->rs_status & ATH9K_RX_DELIM_CRC_PRE)
-		RX_STAT_INC(pre_delim_crc_err);
-	if (rs->rs_status & ATH9K_RX_DELIM_CRC_POST)
-		RX_STAT_INC(post_delim_crc_err);
-	if (rs->rs_status & ATH9K_RX_DECRYPT_BUSY)
-		RX_STAT_INC(decrypt_busy_err);
-
-	if (rs->rs_status & ATH9K_RXERR_PHY) {
-		RX_STAT_INC(phy_err);
-		if (rs->rs_phyerr < ATH9K_PHYERR_MAX)
-			RX_PHY_ERR_INC(rs->rs_phyerr);
-	}
-
-#undef RX_PHY_ERR_INC
+	ath9k_cmn_debug_stat_rx(&sc->debug.stats.rxstats, rs);
 }
 
 static const struct file_operations fops_recv = {
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 559a68c..53ae15b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -221,50 +221,6 @@ struct ath_rx_rate_stats {
 	} cck_stats[4];
 };
 
-/**
- * struct ath_rx_stats - RX Statistics
- * @rx_pkts_all:  No. of total frames received, including ones that
-	may have had errors.
- * @rx_bytes_all:  No. of total bytes received, including ones that
-	may have had errors.
- * @crc_err: No. of frames with incorrect CRC value
- * @decrypt_crc_err: No. of frames whose CRC check failed after
-	decryption process completed
- * @phy_err: No. of frames whose reception failed because the PHY
-	encountered an error
- * @mic_err: No. of frames with incorrect TKIP MIC verification failure
- * @pre_delim_crc_err: Pre-Frame delimiter CRC error detections
- * @post_delim_crc_err: Post-Frame delimiter CRC error detections
- * @decrypt_busy_err: Decryption interruptions counter
- * @phy_err_stats: Individual PHY error statistics
- * @rx_len_err:  No. of frames discarded due to bad length.
- * @rx_oom_err:  No. of frames dropped due to OOM issues.
- * @rx_rate_err:  No. of frames dropped due to rate errors.
- * @rx_too_many_frags_err:  Frames dropped due to too-many-frags received.
- * @rx_beacons:  No. of beacons received.
- * @rx_frags:  No. of rx-fragements received.
- * @rx_spectral: No of spectral packets received.
- */
-struct ath_rx_stats {
-	u32 rx_pkts_all;
-	u32 rx_bytes_all;
-	u32 crc_err;
-	u32 decrypt_crc_err;
-	u32 phy_err;
-	u32 mic_err;
-	u32 pre_delim_crc_err;
-	u32 post_delim_crc_err;
-	u32 decrypt_busy_err;
-	u32 phy_err_stats[ATH9K_PHYERR_MAX];
-	u32 rx_len_err;
-	u32 rx_oom_err;
-	u32 rx_rate_err;
-	u32 rx_too_many_frags_err;
-	u32 rx_beacons;
-	u32 rx_frags;
-	u32 rx_spectral;
-};
-
 #define ANT_MAIN 0
 #define ANT_ALT  1
 
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index dab1f0c..04d2f4f 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -325,14 +325,14 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 
 #define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
 #define TX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
-#define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.rx_stats.c++)
-#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.rx_stats.c += a)
+#define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
+#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
 #define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
 
 #define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
 
 void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
-			   struct ath_htc_rx_status *rxs);
+			   struct ath_rx_status *rs);
 
 struct ath_tx_stats {
 	u32 buf_queued;
@@ -345,25 +345,18 @@ struct ath_tx_stats {
 	u32 queue_stats[IEEE80211_NUM_ACS];
 };
 
-struct ath_rx_stats {
+struct ath_skbrx_stats {
 	u32 skb_allocated;
 	u32 skb_completed;
 	u32 skb_completed_bytes;
 	u32 skb_dropped;
-	u32 err_crc;
-	u32 err_decrypt_crc;
-	u32 err_mic;
-	u32 err_pre_delim;
-	u32 err_post_delim;
-	u32 err_decrypt_busy;
-	u32 err_phy;
-	u32 err_phy_stats[ATH9K_PHYERR_MAX];
 };
 
 struct ath9k_debug {
 	struct dentry *debugfs_phy;
 	struct ath_tx_stats tx_stats;
 	struct ath_rx_stats rx_stats;
+	struct ath_skbrx_stats skbrx_stats;
 };
 
 void ath9k_htc_get_et_strings(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index c5071bb..a71f5f4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -243,30 +243,9 @@ static const struct file_operations fops_xmit = {
 };
 
 void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
-			   struct ath_htc_rx_status *rxs)
+			     struct ath_rx_status *rs)
 {
-#define RX_PHY_ERR_INC(c) priv->debug.rx_stats.err_phy_stats[c]++
-
-	if (rxs->rs_status & ATH9K_RXERR_CRC)
-		priv->debug.rx_stats.err_crc++;
-	if (rxs->rs_status & ATH9K_RXERR_DECRYPT)
-		priv->debug.rx_stats.err_decrypt_crc++;
-	if (rxs->rs_status & ATH9K_RXERR_MIC)
-		priv->debug.rx_stats.err_mic++;
-	if (rxs->rs_status & ATH9K_RX_DELIM_CRC_PRE)
-		priv->debug.rx_stats.err_pre_delim++;
-	if (rxs->rs_status & ATH9K_RX_DELIM_CRC_POST)
-		priv->debug.rx_stats.err_post_delim++;
-	if (rxs->rs_status & ATH9K_RX_DECRYPT_BUSY)
-		priv->debug.rx_stats.err_decrypt_busy++;
-
-	if (rxs->rs_status & ATH9K_RXERR_PHY) {
-		priv->debug.rx_stats.err_phy++;
-		if (rxs->rs_phyerr < ATH9K_PHYERR_MAX)
-			RX_PHY_ERR_INC(rxs->rs_phyerr);
-	}
-
-#undef RX_PHY_ERR_INC
+	ath9k_cmn_debug_stat_rx(&priv->debug.rx_stats, rs);
 }
 
 static ssize_t read_file_recv(struct file *file, char __user *user_buf,
@@ -274,7 +253,7 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 {
 #define PHY_ERR(s, p)							\
 	len += scnprintf(buf + len, size - len, "%20s : %10u\n", s,	\
-			 priv->debug.rx_stats.err_phy_stats[p]);
+			 priv->debug.rx_stats.phy_err_stats[p]);
 
 	struct ath9k_htc_priv *priv = file->private_data;
 	char *buf;
@@ -287,36 +266,13 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 
 	len += scnprintf(buf + len, size - len,
 			 "%20s : %10u\n", "SKBs allocated",
-			 priv->debug.rx_stats.skb_allocated);
+			 priv->debug.skbrx_stats.skb_allocated);
 	len += scnprintf(buf + len, size - len,
 			 "%20s : %10u\n", "SKBs completed",
-			 priv->debug.rx_stats.skb_completed);
+			 priv->debug.skbrx_stats.skb_completed);
 	len += scnprintf(buf + len, size - len,
 			 "%20s : %10u\n", "SKBs Dropped",
-			 priv->debug.rx_stats.skb_dropped);
-
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10u\n", "CRC ERR",
-			 priv->debug.rx_stats.err_crc);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10u\n", "DECRYPT CRC ERR",
-			 priv->debug.rx_stats.err_decrypt_crc);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10u\n", "MIC ERR",
-			 priv->debug.rx_stats.err_mic);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10u\n", "PRE-DELIM CRC ERR",
-			 priv->debug.rx_stats.err_pre_delim);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10u\n", "POST-DELIM CRC ERR",
-			 priv->debug.rx_stats.err_post_delim);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10u\n", "DECRYPT BUSY ERR",
-			 priv->debug.rx_stats.err_decrypt_busy);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10u\n", "TOTAL PHY ERR",
-			 priv->debug.rx_stats.err_phy);
-
+			 priv->debug.skbrx_stats.skb_dropped);
 
 	PHY_ERR("UNDERRUN", ATH9K_PHYERR_UNDERRUN);
 	PHY_ERR("TIMING", ATH9K_PHYERR_TIMING);
@@ -530,6 +486,8 @@ int ath9k_htc_get_et_sset_count(struct ieee80211_hw *hw,
 
 #define STXBASE priv->debug.tx_stats
 #define SRXBASE priv->debug.rx_stats
+#define SKBTXBASE priv->debug.tx_stats
+#define SKBRXBASE priv->debug.skbrx_stats
 #define ASTXQ(a)					\
 	data[i++] = STXBASE.a[IEEE80211_AC_BE];		\
 	data[i++] = STXBASE.a[IEEE80211_AC_BK];		\
@@ -543,24 +501,24 @@ void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
 	struct ath9k_htc_priv *priv = hw->priv;
 	int i = 0;
 
-	data[i++] = STXBASE.skb_success;
-	data[i++] = STXBASE.skb_success_bytes;
-	data[i++] = SRXBASE.skb_completed;
-	data[i++] = SRXBASE.skb_completed_bytes;
+	data[i++] = SKBTXBASE.skb_success;
+	data[i++] = SKBTXBASE.skb_success_bytes;
+	data[i++] = SKBRXBASE.skb_completed;
+	data[i++] = SKBRXBASE.skb_completed_bytes;
 
 	ASTXQ(queue_stats);
 
-	data[i++] = SRXBASE.err_crc;
-	data[i++] = SRXBASE.err_decrypt_crc;
-	data[i++] = SRXBASE.err_phy;
-	data[i++] = SRXBASE.err_mic;
-	data[i++] = SRXBASE.err_pre_delim;
-	data[i++] = SRXBASE.err_post_delim;
-	data[i++] = SRXBASE.err_decrypt_busy;
-
-	data[i++] = SRXBASE.err_phy_stats[ATH9K_PHYERR_RADAR];
-	data[i++] = SRXBASE.err_phy_stats[ATH9K_PHYERR_OFDM_TIMING];
-	data[i++] = SRXBASE.err_phy_stats[ATH9K_PHYERR_CCK_TIMING];
+	data[i++] = SRXBASE.crc_err;
+	data[i++] = SRXBASE.decrypt_crc_err;
+	data[i++] = SRXBASE.phy_err;
+	data[i++] = SRXBASE.mic_err;
+	data[i++] = SRXBASE.pre_delim_crc_err;
+	data[i++] = SRXBASE.post_delim_crc_err;
+	data[i++] = SRXBASE.decrypt_busy_err;
+
+	data[i++] = SRXBASE.phy_err_stats[ATH9K_PHYERR_RADAR];
+	data[i++] = SRXBASE.phy_err_stats[ATH9K_PHYERR_OFDM_TIMING];
+	data[i++] = SRXBASE.phy_err_stats[ATH9K_PHYERR_CCK_TIMING];
 
 	WARN_ON(i != ATH9K_HTC_SSTATS_LEN);
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 289f3d8..bb86eb2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -996,8 +996,6 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		goto rx_next;
 	}
 
-	ath9k_htc_err_stat_rx(priv, rxstatus);
-
 	/* Get the RX status information */
 
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
@@ -1005,6 +1003,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	/* Copy everything from ath_htc_rx_status (HTC_RX_FRAME_HEADER).
 	 * After this, we can drop this part of skb. */
 	rx_status_htc_to_ath(&rx_stats, rxstatus);
+	ath9k_htc_err_stat_rx(priv, &rx_stats);
 	rx_status->mactime = be64_to_cpu(rxstatus->rs_tstamp);
 	skb_pull(skb, HTC_RX_FRAME_HEADER_SIZE);
 
-- 
1.9.1

