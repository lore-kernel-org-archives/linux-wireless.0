Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:56227 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759555Ab0JHUOJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 16:14:09 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com, br1@einfach.org
Subject: [PATCH 4/4] ath5k: use the common cycle counter / listen time implementation
Date: Fri,  8 Oct 2010 22:13:54 +0200
Message-Id: <1286568834-18821-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286568834-18821-3-git-send-email-nbd@openwrt.org>
References: <1286568834-18821-1-git-send-email-nbd@openwrt.org>
 <1286568834-18821-2-git-send-email-nbd@openwrt.org>
 <1286568834-18821-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ani.c   |   41 +++++++++++---------------------
 drivers/net/wireless/ath/ath5k/ani.h   |    5 +---
 drivers/net/wireless/ath/ath5k/debug.c |   21 ++++++++-------
 3 files changed, 26 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index e4a5f04..f141919 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -355,41 +355,28 @@ ath5k_ani_lower_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as)
 
 
 /**
- * ath5k_hw_ani_get_listen_time() - Calculate time spent listening
+ * ath5k_hw_ani_get_listen_time() - Update counters and return listening time
  *
  * Return an approximation of the time spent "listening" in milliseconds (ms)
- * since the last call of this function by deducting the cycles spent
- * transmitting and receiving from the total cycle count.
- * Save profile count values for debugging/statistics and because we might want
- * to use them later.
- *
- * We assume no one else clears these registers!
+ * since the last call of this function.
+ * Save a snapshot of the counter values for debugging/statistics.
  */
 static int
 ath5k_hw_ani_get_listen_time(struct ath5k_hw *ah, struct ath5k_ani_state *as)
 {
+	struct ath_common *common = ath5k_hw_common(ah);
 	int listen;
 
-	/* freeze */
-	ath5k_hw_reg_write(ah, AR5K_MIBC_FMC, AR5K_MIBC);
-	/* read */
-	as->pfc_cycles = ath5k_hw_reg_read(ah, AR5K_PROFCNT_CYCLE);
-	as->pfc_busy = ath5k_hw_reg_read(ah, AR5K_PROFCNT_RXCLR);
-	as->pfc_tx = ath5k_hw_reg_read(ah, AR5K_PROFCNT_TX);
-	as->pfc_rx = ath5k_hw_reg_read(ah, AR5K_PROFCNT_RX);
-	/* clear */
-	ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_TX);
-	ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RX);
-	ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RXCLR);
-	ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_CYCLE);
-	/* un-freeze */
-	ath5k_hw_reg_write(ah, 0, AR5K_MIBC);
-
-	/* TODO: where does 44000 come from? (11g clock rate?) */
-	listen = (as->pfc_cycles - as->pfc_rx - as->pfc_tx) / 44000;
-
-	if (as->pfc_cycles == 0 || listen < 0)
-		return 0;
+	spin_lock_bh(&common->cc_lock);
+
+	ath_hw_cycle_counters_update(common);
+	memcpy(&as->last_cc, &common->cc_ani, sizeof(as->last_cc));
+
+	/* clears common->cc_ani */
+	listen = ath_hw_get_listen_time(common);
+
+	spin_unlock_bh(&common->cc_lock);
+
 	return listen;
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/ani.h b/drivers/net/wireless/ath/ath5k/ani.h
index 55cf26d..d0a6640 100644
--- a/drivers/net/wireless/ath/ath5k/ani.h
+++ b/drivers/net/wireless/ath/ath5k/ani.h
@@ -75,10 +75,7 @@ struct ath5k_ani_state {
 	unsigned int		cck_errors;
 
 	/* debug/statistics only: numbers from last ANI calibration */
-	unsigned int		pfc_tx;
-	unsigned int		pfc_rx;
-	unsigned int		pfc_busy;
-	unsigned int		pfc_cycles;
+	struct ath_cycle_counters last_cc;
 	unsigned int		last_listen;
 	unsigned int		last_ofdm_errors;
 	unsigned int		last_cck_errors;
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index c2d549f..1506d1d 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -715,20 +715,21 @@ static ssize_t read_file_ani(struct file *file, char __user *user_buf,
 	len += snprintf(buf+len, sizeof(buf)-len,
 			"beacon RSSI average:\t%d\n",
 			sc->ah->ah_beacon_rssi_avg.avg);
+
+#define CC_PRINT(_struct, _field) \
+	_struct._field, \
+	_struct.cycles > 0 ? \
+	_struct._field*100/_struct.cycles : 0
+
 	len += snprintf(buf+len, sizeof(buf)-len, "profcnt tx\t\t%u\t(%d%%)\n",
-			as->pfc_tx,
-			as->pfc_cycles > 0 ?
-			as->pfc_tx*100/as->pfc_cycles : 0);
+			CC_PRINT(as->last_cc, tx_frame));
 	len += snprintf(buf+len, sizeof(buf)-len, "profcnt rx\t\t%u\t(%d%%)\n",
-			as->pfc_rx,
-			as->pfc_cycles > 0 ?
-			as->pfc_rx*100/as->pfc_cycles : 0);
+			CC_PRINT(as->last_cc, rx_frame));
 	len += snprintf(buf+len, sizeof(buf)-len, "profcnt busy\t\t%u\t(%d%%)\n",
-			as->pfc_busy,
-			as->pfc_cycles > 0 ?
-			as->pfc_busy*100/as->pfc_cycles : 0);
+			CC_PRINT(as->last_cc, rx_busy));
+#undef CC_PRINT
 	len += snprintf(buf+len, sizeof(buf)-len, "profcnt cycles\t\t%u\n",
-			as->pfc_cycles);
+			as->last_cc.cycles);
 	len += snprintf(buf+len, sizeof(buf)-len,
 			"listen time\t\t%d\tlast: %d\n",
 			as->listen_time, as->last_listen);
-- 
1.7.2.2

