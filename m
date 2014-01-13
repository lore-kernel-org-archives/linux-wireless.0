Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:52242 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaAMCEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 21:04:51 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 3/5] ath9k: Use a separate debugfs file for PHY errors
Date: Mon, 13 Jan 2014 07:29:29 +0530
Message-Id: <1389578371-23943-3-git-send-email-sujith@msujith.org> (sfid-20140113_030456_485345_C654B480)
In-Reply-To: <1389578371-23943-1-git-send-email-sujith@msujith.org>
References: <1389578371-23943-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 117 +++++++++++++++++++++------------
 1 file changed, 74 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 5bdc938..ab7264c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -943,14 +943,10 @@ static const struct file_operations fops_reset = {
 static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
-#define PHY_ERR(s, p) \
-	len += scnprintf(buf + len, size - len, "%22s : %10u\n", s, \
-			 sc->debug.stats.rxstats.phy_err_stats[p]);
-
 #define RXS_ERR(s, e)					    \
 	do {						    \
 		len += scnprintf(buf + len, size - len,	    \
-				 "%22s : %10u\n", s,	    \
+				 "%18s : %10u\n", s,	    \
 				 sc->debug.stats.rxstats.e);\
 	} while (0)
 
@@ -963,6 +959,12 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	if (buf == NULL)
 		return -ENOMEM;
 
+	RXS_ERR("PKTS-ALL", rx_pkts_all);
+	RXS_ERR("BYTES-ALL", rx_bytes_all);
+	RXS_ERR("BEACONS", rx_beacons);
+	RXS_ERR("FRAGS", rx_frags);
+	RXS_ERR("SPECTRAL", rx_spectral);
+
 	RXS_ERR("CRC ERR", crc_err);
 	RXS_ERR("DECRYPT CRC ERR", decrypt_crc_err);
 	RXS_ERR("PHY ERR", phy_err);
@@ -970,43 +972,10 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	RXS_ERR("PRE-DELIM CRC ERR", pre_delim_crc_err);
 	RXS_ERR("POST-DELIM CRC ERR", post_delim_crc_err);
 	RXS_ERR("DECRYPT BUSY ERR", decrypt_busy_err);
-	RXS_ERR("RX-LENGTH-ERR", rx_len_err);
-	RXS_ERR("RX-OOM-ERR", rx_oom_err);
-	RXS_ERR("RX-RATE-ERR", rx_rate_err);
-	RXS_ERR("RX-TOO-MANY-FRAGS", rx_too_many_frags_err);
-
-	PHY_ERR("UNDERRUN ERR", ATH9K_PHYERR_UNDERRUN);
-	PHY_ERR("TIMING ERR", ATH9K_PHYERR_TIMING);
-	PHY_ERR("PARITY ERR", ATH9K_PHYERR_PARITY);
-	PHY_ERR("RATE ERR", ATH9K_PHYERR_RATE);
-	PHY_ERR("LENGTH ERR", ATH9K_PHYERR_LENGTH);
-	PHY_ERR("RADAR ERR", ATH9K_PHYERR_RADAR);
-	PHY_ERR("SERVICE ERR", ATH9K_PHYERR_SERVICE);
-	PHY_ERR("TOR ERR", ATH9K_PHYERR_TOR);
-	PHY_ERR("OFDM-TIMING ERR", ATH9K_PHYERR_OFDM_TIMING);
-	PHY_ERR("OFDM-SIGNAL-PARITY ERR", ATH9K_PHYERR_OFDM_SIGNAL_PARITY);
-	PHY_ERR("OFDM-RATE ERR", ATH9K_PHYERR_OFDM_RATE_ILLEGAL);
-	PHY_ERR("OFDM-LENGTH ERR", ATH9K_PHYERR_OFDM_LENGTH_ILLEGAL);
-	PHY_ERR("OFDM-POWER-DROP ERR", ATH9K_PHYERR_OFDM_POWER_DROP);
-	PHY_ERR("OFDM-SERVICE ERR", ATH9K_PHYERR_OFDM_SERVICE);
-	PHY_ERR("OFDM-RESTART ERR", ATH9K_PHYERR_OFDM_RESTART);
-	PHY_ERR("FALSE-RADAR-EXT ERR", ATH9K_PHYERR_FALSE_RADAR_EXT);
-	PHY_ERR("CCK-TIMING ERR", ATH9K_PHYERR_CCK_TIMING);
-	PHY_ERR("CCK-HEADER-CRC ERR", ATH9K_PHYERR_CCK_HEADER_CRC);
-	PHY_ERR("CCK-RATE ERR", ATH9K_PHYERR_CCK_RATE_ILLEGAL);
-	PHY_ERR("CCK-SERVICE ERR", ATH9K_PHYERR_CCK_SERVICE);
-	PHY_ERR("CCK-RESTART ERR", ATH9K_PHYERR_CCK_RESTART);
-	PHY_ERR("CCK-LENGTH ERR", ATH9K_PHYERR_CCK_LENGTH_ILLEGAL);
-	PHY_ERR("CCK-POWER-DROP ERR", ATH9K_PHYERR_CCK_POWER_DROP);
-	PHY_ERR("HT-CRC ERR", ATH9K_PHYERR_HT_CRC_ERROR);
-	PHY_ERR("HT-LENGTH ERR", ATH9K_PHYERR_HT_LENGTH_ILLEGAL);
-	PHY_ERR("HT-RATE ERR", ATH9K_PHYERR_HT_RATE_ILLEGAL);
-
-	RXS_ERR("RX-Pkts-All", rx_pkts_all);
-	RXS_ERR("RX-Bytes-All", rx_bytes_all);
-	RXS_ERR("RX-Beacons", rx_beacons);
-	RXS_ERR("RX-Frags", rx_frags);
-	RXS_ERR("RX-Spectral", rx_spectral);
+	RXS_ERR("LENGTH-ERR", rx_len_err);
+	RXS_ERR("OOM-ERR", rx_oom_err);
+	RXS_ERR("RATE-ERR", rx_rate_err);
+	RXS_ERR("TOO-MANY-FRAGS", rx_too_many_frags_err);
 
 	if (len > size)
 		len = size;
@@ -1017,7 +986,6 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	return retval;
 
 #undef RXS_ERR
-#undef PHY_ERR
 }
 
 void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
@@ -1056,6 +1024,67 @@ static const struct file_operations fops_recv = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_phy_err(struct file *file, char __user *user_buf,
+				 size_t count, loff_t *ppos)
+{
+#define PHY_ERR(s, p) \
+	len += scnprintf(buf + len, size - len, "%22s : %10u\n", s, \
+			 sc->debug.stats.rxstats.phy_err_stats[p]);
+
+	struct ath_softc *sc = file->private_data;
+	char *buf;
+	unsigned int len = 0, size = 1600;
+	ssize_t retval = 0;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	PHY_ERR("UNDERRUN ERR", ATH9K_PHYERR_UNDERRUN);
+	PHY_ERR("TIMING ERR", ATH9K_PHYERR_TIMING);
+	PHY_ERR("PARITY ERR", ATH9K_PHYERR_PARITY);
+	PHY_ERR("RATE ERR", ATH9K_PHYERR_RATE);
+	PHY_ERR("LENGTH ERR", ATH9K_PHYERR_LENGTH);
+	PHY_ERR("RADAR ERR", ATH9K_PHYERR_RADAR);
+	PHY_ERR("SERVICE ERR", ATH9K_PHYERR_SERVICE);
+	PHY_ERR("TOR ERR", ATH9K_PHYERR_TOR);
+	PHY_ERR("OFDM-TIMING ERR", ATH9K_PHYERR_OFDM_TIMING);
+	PHY_ERR("OFDM-SIGNAL-PARITY ERR", ATH9K_PHYERR_OFDM_SIGNAL_PARITY);
+	PHY_ERR("OFDM-RATE ERR", ATH9K_PHYERR_OFDM_RATE_ILLEGAL);
+	PHY_ERR("OFDM-LENGTH ERR", ATH9K_PHYERR_OFDM_LENGTH_ILLEGAL);
+	PHY_ERR("OFDM-POWER-DROP ERR", ATH9K_PHYERR_OFDM_POWER_DROP);
+	PHY_ERR("OFDM-SERVICE ERR", ATH9K_PHYERR_OFDM_SERVICE);
+	PHY_ERR("OFDM-RESTART ERR", ATH9K_PHYERR_OFDM_RESTART);
+	PHY_ERR("FALSE-RADAR-EXT ERR", ATH9K_PHYERR_FALSE_RADAR_EXT);
+	PHY_ERR("CCK-TIMING ERR", ATH9K_PHYERR_CCK_TIMING);
+	PHY_ERR("CCK-HEADER-CRC ERR", ATH9K_PHYERR_CCK_HEADER_CRC);
+	PHY_ERR("CCK-RATE ERR", ATH9K_PHYERR_CCK_RATE_ILLEGAL);
+	PHY_ERR("CCK-SERVICE ERR", ATH9K_PHYERR_CCK_SERVICE);
+	PHY_ERR("CCK-RESTART ERR", ATH9K_PHYERR_CCK_RESTART);
+	PHY_ERR("CCK-LENGTH ERR", ATH9K_PHYERR_CCK_LENGTH_ILLEGAL);
+	PHY_ERR("CCK-POWER-DROP ERR", ATH9K_PHYERR_CCK_POWER_DROP);
+	PHY_ERR("HT-CRC ERR", ATH9K_PHYERR_HT_CRC_ERROR);
+	PHY_ERR("HT-LENGTH ERR", ATH9K_PHYERR_HT_LENGTH_ILLEGAL);
+	PHY_ERR("HT-RATE ERR", ATH9K_PHYERR_HT_RATE_ILLEGAL);
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
+}
+
+static const struct file_operations fops_phy_err = {
+	.read = read_file_phy_err,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t read_file_regidx(struct file *file, char __user *user_buf,
                                 size_t count, loff_t *ppos)
 {
@@ -1489,6 +1518,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_reset);
 	debugfs_create_file("recv", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_recv);
+	debugfs_create_file("phy_err", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_phy_err);
 	debugfs_create_u8("rx_chainmask", S_IRUSR, sc->debug.debugfs_phy,
 			  &ah->rxchainmask);
 	debugfs_create_u8("tx_chainmask", S_IRUSR, sc->debug.debugfs_phy,
-- 
1.8.5.2

