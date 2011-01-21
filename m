Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43581 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1AUDEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:04:09 -0500
Received: by mail-pv0-f174.google.com with SMTP id 4so217568pva.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:04:09 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63355.956390.886388@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:33:23 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 28/33] ath9k_htc: Add RX error statistics
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h           |   16 ++++
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |  107 ++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c  |    2 +
 3 files changed, 117 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 742777e..ed82bba 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -295,6 +295,9 @@ struct ath9k_htc_tx_ctl {
 
 #define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
 
+void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
+			   struct ath_htc_rx_status *rxs);
+
 struct ath_tx_stats {
 	u32 buf_queued;
 	u32 buf_completed;
@@ -309,6 +312,14 @@ struct ath_rx_stats {
 	u32 skb_allocated;
 	u32 skb_completed;
 	u32 skb_dropped;
+	u32 err_crc;
+	u32 err_decrypt_crc;
+	u32 err_mic;
+	u32 err_pre_delim;
+	u32 err_post_delim;
+	u32 err_decrypt_busy;
+	u32 err_phy;
+	u32 err_phy_stats[ATH9K_PHYERR_MAX];
 };
 
 struct ath9k_debug {
@@ -329,6 +340,11 @@ struct ath9k_debug {
 
 #define TX_QSTAT_INC(c) do { } while (0)
 
+static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
+					 struct ath_htc_rx_status *rxs)
+{
+}
+
 #endif /* CONFIG_ATH9K_HTC_DEBUGFS */
 
 #define ATH_LED_PIN_DEF             1
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 8b679aa..6fc6cb7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -123,27 +123,118 @@ static const struct file_operations fops_xmit = {
 	.llseek = default_llseek,
 };
 
+void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
+			   struct ath_htc_rx_status *rxs)
+{
+#define RX_PHY_ERR_INC(c) priv->debug.rx_stats.err_phy_stats[c]++
+
+	if (rxs->rs_status & ATH9K_RXERR_CRC)
+		priv->debug.rx_stats.err_crc++;
+	if (rxs->rs_status & ATH9K_RXERR_DECRYPT)
+		priv->debug.rx_stats.err_decrypt_crc++;
+	if (rxs->rs_status & ATH9K_RXERR_MIC)
+		priv->debug.rx_stats.err_mic++;
+	if (rxs->rs_status & ATH9K_RX_DELIM_CRC_PRE)
+		priv->debug.rx_stats.err_pre_delim++;
+	if (rxs->rs_status & ATH9K_RX_DELIM_CRC_POST)
+		priv->debug.rx_stats.err_post_delim++;
+	if (rxs->rs_status & ATH9K_RX_DECRYPT_BUSY)
+		priv->debug.rx_stats.err_decrypt_busy++;
+
+	if (rxs->rs_status & ATH9K_RXERR_PHY) {
+		priv->debug.rx_stats.err_phy++;
+		if (rxs->rs_phyerr < ATH9K_PHYERR_MAX)
+			RX_PHY_ERR_INC(rxs->rs_phyerr);
+	}
+
+#undef RX_PHY_ERR_INC
+}
+
 static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
+#define PHY_ERR(s, p)							\
+	len += snprintf(buf + len, size - len, "%20s : %10u\n", s,	\
+			priv->debug.rx_stats.err_phy_stats[p]);
+
 	struct ath9k_htc_priv *priv = file->private_data;
-	char buf[512];
-	unsigned int len = 0;
+	char *buf;
+	unsigned int len = 0, size = 1500;
+	ssize_t retval = 0;
 
-	len += snprintf(buf + len, sizeof(buf) - len,
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	len += snprintf(buf + len, size - len,
 			"%20s : %10u\n", "SKBs allocated",
 			priv->debug.rx_stats.skb_allocated);
-	len += snprintf(buf + len, sizeof(buf) - len,
+	len += snprintf(buf + len, size - len,
 			"%20s : %10u\n", "SKBs completed",
 			priv->debug.rx_stats.skb_completed);
-	len += snprintf(buf + len, sizeof(buf) - len,
+	len += snprintf(buf + len, size - len,
 			"%20s : %10u\n", "SKBs Dropped",
 			priv->debug.rx_stats.skb_dropped);
 
-	if (len > sizeof(buf))
-		len = sizeof(buf);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10u\n", "CRC ERR",
+			priv->debug.rx_stats.err_crc);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10u\n", "DECRYPT CRC ERR",
+			priv->debug.rx_stats.err_decrypt_crc);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10u\n", "MIC ERR",
+			priv->debug.rx_stats.err_mic);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10u\n", "PRE-DELIM CRC ERR",
+			priv->debug.rx_stats.err_pre_delim);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10u\n", "POST-DELIM CRC ERR",
+			priv->debug.rx_stats.err_post_delim);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10u\n", "DECRYPT BUSY ERR",
+			priv->debug.rx_stats.err_decrypt_busy);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10u\n", "TOTAL PHY ERR",
+			priv->debug.rx_stats.err_phy);
+
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
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+
+#undef PHY_ERR
 }
 
 static const struct file_operations fops_recv = {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 3dd87a5..1b629fd 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -543,6 +543,8 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		goto rx_next;
 	}
 
+	ath9k_htc_err_stat_rx(priv, rxstatus);
+
 	/* Get the RX status information */
 	memcpy(&rxbuf->rxstatus, rxstatus, HTC_RX_FRAME_HEADER_SIZE);
 	skb_pull(skb, HTC_RX_FRAME_HEADER_SIZE);
-- 
1.7.3.5

