Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40170 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab2CCORS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 09:17:18 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3/5] ath9k: remove rssi/antenna information from recv debug stats
Date: Sat,  3 Mar 2012 15:17:04 +0100
Message-Id: <1330784226-65563-3-git-send-email-nbd@openwrt.org> (sfid-20120303_151723_502125_398E2B4E)
In-Reply-To: <1330784226-65563-2-git-send-email-nbd@openwrt.org>
References: <1330784226-65563-1-git-send-email-nbd@openwrt.org>
 <1330784226-65563-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The way this is implemented (simply storing the last value) is absolutely
worthless for debugging anything, and the same information is also available
through the MAC sample feature, so there's no point in keeping this around.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c |   31 -------------------------------
 drivers/net/wireless/ath/ath9k/debug.h |    7 -------
 2 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 03a4740..c2edf68 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -944,27 +944,6 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	PHY_ERR("HT-RATE ERR", ATH9K_PHYERR_HT_RATE_ILLEGAL);
 
 	len += snprintf(buf + len, size - len,
-			"%22s : %10d\n", "RSSI-CTL0",
-			sc->debug.stats.rxstats.rs_rssi_ctl0);
-	len += snprintf(buf + len, size - len,
-			"%22s : %10d\n", "RSSI-CTL1",
-			sc->debug.stats.rxstats.rs_rssi_ctl1);
-	len += snprintf(buf + len, size - len,
-			"%22s : %10d\n", "RSSI-CTL2",
-			sc->debug.stats.rxstats.rs_rssi_ctl2);
-	len += snprintf(buf + len, size - len,
-			"%22s : %10d\n", "RSSI-EXT0",
-			sc->debug.stats.rxstats.rs_rssi_ext0);
-	len += snprintf(buf + len, size - len,
-			"%22s : %10d\n", "RSSI-EXT1",
-			sc->debug.stats.rxstats.rs_rssi_ext1);
-	len += snprintf(buf + len, size - len,
-			"%22s : %10d\n", "RSSI-EXT2",
-			sc->debug.stats.rxstats.rs_rssi_ext2);
-	len += snprintf(buf + len, size - len,
-			"%22s : %10d\n", "Rx Antenna",
-			sc->debug.stats.rxstats.rs_antenna);
-	len += snprintf(buf + len, size - len,
 			"%22s : %10u\n", "RX-Pkts-All",
 			sc->debug.stats.rxstats.rx_pkts_all);
 	len += snprintf(buf + len, size - len,
@@ -1011,16 +990,6 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 			RX_PHY_ERR_INC(rs->rs_phyerr);
 	}
 
-	sc->debug.stats.rxstats.rs_rssi_ctl0 = rs->rs_rssi_ctl0;
-	sc->debug.stats.rxstats.rs_rssi_ctl1 = rs->rs_rssi_ctl1;
-	sc->debug.stats.rxstats.rs_rssi_ctl2 = rs->rs_rssi_ctl2;
-
-	sc->debug.stats.rxstats.rs_rssi_ext0 = rs->rs_rssi_ext0;
-	sc->debug.stats.rxstats.rs_rssi_ext1 = rs->rs_rssi_ext1;
-	sc->debug.stats.rxstats.rs_rssi_ext2 = rs->rs_rssi_ext2;
-
-	sc->debug.stats.rxstats.rs_antenna = rs->rs_antenna;
-
 #ifdef CONFIG_ATH9K_MAC_DEBUG
 	spin_lock(&sc->debug.samp_lock);
 	RX_SAMP_DBG(jiffies) = jiffies;
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 7a51958..64fcfad 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -165,13 +165,6 @@ struct ath_rx_stats {
 	u32 post_delim_crc_err;
 	u32 decrypt_busy_err;
 	u32 phy_err_stats[ATH9K_PHYERR_MAX];
-	int8_t rs_rssi_ctl0;
-	int8_t rs_rssi_ctl1;
-	int8_t rs_rssi_ctl2;
-	int8_t rs_rssi_ext0;
-	int8_t rs_rssi_ext1;
-	int8_t rs_rssi_ext2;
-	u8 rs_antenna;
 };
 
 enum ath_reset_type {
-- 
1.7.3.2

