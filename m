Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12413 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2BMGVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 01:21:20 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20280.43990.419490.460277@gargle.gargle.HOWL> (sfid-20120213_072122_530214_0E2DDD26)
Date: Mon, 13 Feb 2012 11:51:10 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 5/7] ath9k: Prettify recv debugfs file output
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dumping the RSSI information in the middle of error
statistics is a bit misleading. Move them to the end.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   97 +++++++++++++++-----------------
 1 files changed, 45 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index fe1f55f..5a838fc 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -880,12 +880,12 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
 #define PHY_ERR(s, p) \
-	len += snprintf(buf + len, size - len, "%18s : %10u\n", s, \
+	len += snprintf(buf + len, size - len, "%22s : %10u\n", s, \
 			sc->debug.stats.rxstats.phy_err_stats[p]);
 
 	struct ath_softc *sc = file->private_data;
 	char *buf;
-	unsigned int len = 0, size = 1400;
+	unsigned int len = 0, size = 1600;
 	ssize_t retval = 0;
 
 	buf = kzalloc(size, GFP_KERNEL);
@@ -893,87 +893,80 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 		return -ENOMEM;
 
 	len += snprintf(buf + len, size - len,
-			"%18s : %10u\n", "CRC ERR",
+			"%22s : %10u\n", "CRC ERR",
 			sc->debug.stats.rxstats.crc_err);
 	len += snprintf(buf + len, size - len,
-			"%18s : %10u\n", "DECRYPT CRC ERR",
+			"%22s : %10u\n", "DECRYPT CRC ERR",
 			sc->debug.stats.rxstats.decrypt_crc_err);
 	len += snprintf(buf + len, size - len,
-			"%18s : %10u\n", "PHY ERR",
+			"%22s : %10u\n", "PHY ERR",
 			sc->debug.stats.rxstats.phy_err);
 	len += snprintf(buf + len, size - len,
-			"%18s : %10u\n", "MIC ERR",
+			"%22s : %10u\n", "MIC ERR",
 			sc->debug.stats.rxstats.mic_err);
 	len += snprintf(buf + len, size - len,
-			"%18s : %10u\n", "PRE-DELIM CRC ERR",
+			"%22s : %10u\n", "PRE-DELIM CRC ERR",
 			sc->debug.stats.rxstats.pre_delim_crc_err);
 	len += snprintf(buf + len, size - len,
-			"%18s : %10u\n", "POST-DELIM CRC ERR",
+			"%22s : %10u\n", "POST-DELIM CRC ERR",
 			sc->debug.stats.rxstats.post_delim_crc_err);
 	len += snprintf(buf + len, size - len,
-			"%18s : %10u\n", "DECRYPT BUSY ERR",
+			"%22s : %10u\n", "DECRYPT BUSY ERR",
 			sc->debug.stats.rxstats.decrypt_busy_err);
 
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
 	len += snprintf(buf + len, size - len,
-			"%18s : %10d\n", "RSSI-CTL0",
+			"%22s : %10d\n", "RSSI-CTL0",
 			sc->debug.stats.rxstats.rs_rssi_ctl0);
-
 	len += snprintf(buf + len, size - len,
-			"%18s : %10d\n", "RSSI-CTL1",
+			"%22s : %10d\n", "RSSI-CTL1",
 			sc->debug.stats.rxstats.rs_rssi_ctl1);
-
 	len += snprintf(buf + len, size - len,
-			"%18s : %10d\n", "RSSI-CTL2",
+			"%22s : %10d\n", "RSSI-CTL2",
 			sc->debug.stats.rxstats.rs_rssi_ctl2);
-
 	len += snprintf(buf + len, size - len,
-			"%18s : %10d\n", "RSSI-EXT0",
+			"%22s : %10d\n", "RSSI-EXT0",
 			sc->debug.stats.rxstats.rs_rssi_ext0);
-
 	len += snprintf(buf + len, size - len,
-			"%18s : %10d\n", "RSSI-EXT1",
+			"%22s : %10d\n", "RSSI-EXT1",
 			sc->debug.stats.rxstats.rs_rssi_ext1);
-
 	len += snprintf(buf + len, size - len,
-			"%18s : %10d\n", "RSSI-EXT2",
+			"%22s : %10d\n", "RSSI-EXT2",
 			sc->debug.stats.rxstats.rs_rssi_ext2);
-
 	len += snprintf(buf + len, size - len,
-			"%18s : %10d\n", "Rx Antenna",
+			"%22s : %10d\n", "Rx Antenna",
 			sc->debug.stats.rxstats.rs_antenna);
-
-	PHY_ERR("UNDERRUN", ATH9K_PHYERR_UNDERRUN);
-	PHY_ERR("TIMING", ATH9K_PHYERR_TIMING);
-	PHY_ERR("PARITY", ATH9K_PHYERR_PARITY);
-	PHY_ERR("RATE", ATH9K_PHYERR_RATE);
-	PHY_ERR("LENGTH", ATH9K_PHYERR_LENGTH);
-	PHY_ERR("RADAR", ATH9K_PHYERR_RADAR);
-	PHY_ERR("SERVICE", ATH9K_PHYERR_SERVICE);
-	PHY_ERR("TOR", ATH9K_PHYERR_TOR);
-	PHY_ERR("OFDM-TIMING", ATH9K_PHYERR_OFDM_TIMING);
-	PHY_ERR("OFDM-SIGNAL-PARITY", ATH9K_PHYERR_OFDM_SIGNAL_PARITY);
-	PHY_ERR("OFDM-RATE", ATH9K_PHYERR_OFDM_RATE_ILLEGAL);
-	PHY_ERR("OFDM-LENGTH", ATH9K_PHYERR_OFDM_LENGTH_ILLEGAL);
-	PHY_ERR("OFDM-POWER-DROP", ATH9K_PHYERR_OFDM_POWER_DROP);
-	PHY_ERR("OFDM-SERVICE", ATH9K_PHYERR_OFDM_SERVICE);
-	PHY_ERR("OFDM-RESTART", ATH9K_PHYERR_OFDM_RESTART);
-	PHY_ERR("FALSE-RADAR-EXT", ATH9K_PHYERR_FALSE_RADAR_EXT);
-	PHY_ERR("CCK-TIMING", ATH9K_PHYERR_CCK_TIMING);
-	PHY_ERR("CCK-HEADER-CRC", ATH9K_PHYERR_CCK_HEADER_CRC);
-	PHY_ERR("CCK-RATE", ATH9K_PHYERR_CCK_RATE_ILLEGAL);
-	PHY_ERR("CCK-SERVICE", ATH9K_PHYERR_CCK_SERVICE);
-	PHY_ERR("CCK-RESTART", ATH9K_PHYERR_CCK_RESTART);
-	PHY_ERR("CCK-LENGTH", ATH9K_PHYERR_CCK_LENGTH_ILLEGAL);
-	PHY_ERR("CCK-POWER-DROP", ATH9K_PHYERR_CCK_POWER_DROP);
-	PHY_ERR("HT-CRC", ATH9K_PHYERR_HT_CRC_ERROR);
-	PHY_ERR("HT-LENGTH", ATH9K_PHYERR_HT_LENGTH_ILLEGAL);
-	PHY_ERR("HT-RATE", ATH9K_PHYERR_HT_RATE_ILLEGAL);
-
 	len += snprintf(buf + len, size - len,
-			"%18s : %10u\n", "RX-Pkts-All",
+			"%22s : %10u\n", "RX-Pkts-All",
 			sc->debug.stats.rxstats.rx_pkts_all);
 	len += snprintf(buf + len, size - len,
-			"%18s : %10u\n", "RX-Bytes-All",
+			"%22s : %10u\n", "RX-Bytes-All",
 			sc->debug.stats.rxstats.rx_bytes_all);
 
 	if (len > size)
-- 
1.7.9

