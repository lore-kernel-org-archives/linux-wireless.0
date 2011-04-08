Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12160 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab1DHKBY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 06:01:24 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 03:00:58 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 1/2] ath9k: Add RSSI information from control and extension chains
Date: Fri, 8 Apr 2011 15:30:34 +0530
Message-ID: <1302256836-4647-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Export RSSI information from all the control and extension
channel chains to debugfs. Also add rx antenna information
to debugfs. This will be useful for debugging purpose.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   40 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/debug.h |    7 +++++
 2 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index a762cad..34f191e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -845,7 +845,7 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 
 	struct ath_softc *sc = file->private_data;
 	char *buf;
-	unsigned int len = 0, size = 1152;
+	unsigned int len = 0, size = 1400;
 	ssize_t retval = 0;
 
 	buf = kzalloc(size, GFP_KERNEL);
@@ -874,6 +874,34 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 			"%18s : %10u\n", "DECRYPT BUSY ERR",
 			sc->debug.stats.rxstats.decrypt_busy_err);
 
+	len += snprintf(buf + len, size - len,
+			"%18s : %10d\n", "RSSI-CTL0",
+			sc->debug.stats.rxstats.rs_rssi_ctl0);
+
+	len += snprintf(buf + len, size - len,
+			"%18s : %10d\n", "RSSI-CTL1",
+			sc->debug.stats.rxstats.rs_rssi_ctl1);
+
+	len += snprintf(buf + len, size - len,
+			"%18s : %10d\n", "RSSI-CTL2",
+			sc->debug.stats.rxstats.rs_rssi_ctl2);
+
+	len += snprintf(buf + len, size - len,
+			"%18s : %10d\n", "RSSI-EXT0",
+			sc->debug.stats.rxstats.rs_rssi_ext0);
+
+	len += snprintf(buf + len, size - len,
+			"%18s : %10d\n", "RSSI-EXT1",
+			sc->debug.stats.rxstats.rs_rssi_ext1);
+
+	len += snprintf(buf + len, size - len,
+			"%18s : %10d\n", "RSSI-EXT2",
+			sc->debug.stats.rxstats.rs_rssi_ext2);
+
+	len += snprintf(buf + len, size - len,
+			"%18s : %10d\n", "Rx Antenna",
+			sc->debug.stats.rxstats.rs_antenna);
+
 	PHY_ERR("UNDERRUN", ATH9K_PHYERR_UNDERRUN);
 	PHY_ERR("TIMING", ATH9K_PHYERR_TIMING);
 	PHY_ERR("PARITY", ATH9K_PHYERR_PARITY);
@@ -948,6 +976,16 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 		RX_PHY_ERR_INC(phyerr);
 	}
 
+	sc->debug.stats.rxstats.rs_rssi_ctl0 = rs->rs_rssi_ctl0;
+	sc->debug.stats.rxstats.rs_rssi_ctl1 = rs->rs_rssi_ctl1;
+	sc->debug.stats.rxstats.rs_rssi_ctl2 = rs->rs_rssi_ctl2;
+
+	sc->debug.stats.rxstats.rs_rssi_ext0 = rs->rs_rssi_ext0;
+	sc->debug.stats.rxstats.rs_rssi_ext1 = rs->rs_rssi_ext1;
+	sc->debug.stats.rxstats.rs_rssi_ext2 = rs->rs_rssi_ext2;
+
+	sc->debug.stats.rxstats.rs_antenna = rs->rs_antenna;
+
 #undef RX_STAT_INC
 #undef RX_PHY_ERR_INC
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 59338de..1f9f8ea 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -157,6 +157,13 @@ struct ath_rx_stats {
 	u32 post_delim_crc_err;
 	u32 decrypt_busy_err;
 	u32 phy_err_stats[ATH9K_PHYERR_MAX];
+	int8_t rs_rssi_ctl0;
+	int8_t rs_rssi_ctl1;
+	int8_t rs_rssi_ctl2;
+	int8_t rs_rssi_ext0;
+	int8_t rs_rssi_ext1;
+	int8_t rs_rssi_ext2;
+	u8 rs_antenna;
 };
 
 struct ath_stats {
-- 
1.7.0.4

