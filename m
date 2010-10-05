Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:3552 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932564Ab0JEJzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 05:55:16 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0690132514
	for <linux-wireless@vger.kernel.org>; Tue,  5 Oct 2010 18:55:15 +0900 (JST)
Subject: [PATCH 2/5] ath5k: Use common cycle counters for ANI
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, adrian@freebsd.org,
	vasanth@atheros.com
Date: Tue, 05 Oct 2010 18:55:15 +0900
Message-ID: <20101005095515.3083.93927.stgit@tt-desk>
In-Reply-To: <20101005095510.3083.46174.stgit@tt-desk>
References: <20101005095510.3083.46174.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update ath5k to use the common cycle counters in it's ANI implementation.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ani.c   |   34 ++++++++++++--------------------
 drivers/net/wireless/ath/ath5k/ani.h   |    5 +----
 drivers/net/wireless/ath/ath5k/debug.c |   21 ++++++++++----------
 3 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index e4a5f04..67b41d9 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -360,36 +360,28 @@ ath5k_ani_lower_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as)
  * Return an approximation of the time spent "listening" in milliseconds (ms)
  * since the last call of this function by deducting the cycles spent
  * transmitting and receiving from the total cycle count.
- * Save profile count values for debugging/statistics and because we might want
- * to use them later.
- *
- * We assume no one else clears these registers!
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
+	ath_hw_cycle_counters_lock(common);
+	ath_hw_cycle_counters_update(common);
 
 	/* TODO: where does 44000 come from? (11g clock rate?) */
-	listen = (as->pfc_cycles - as->pfc_rx - as->pfc_tx) / 44000;
+	listen = (common->cc_ani.cycles - common->cc_ani.rx_frame -
+			common->cc_ani.tx_frame) / 44000;
+
+	if (common->cc_ani.cycles == 0 || listen < 0)
+		listen = 0;
+
+	memcpy(&as->last_cc, &common->cc_ani, sizeof(struct ath_cycle_counters));
+	memset(&common->cc_ani, 0, sizeof(struct ath_cycle_counters));
+
+	ath_hw_cycle_counters_unlock(common);
 
-	if (as->pfc_cycles == 0 || listen < 0)
-		return 0;
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
index 0f06e84..f0f8e43 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -711,20 +711,21 @@ static ssize_t read_file_ani(struct file *file, char __user *user_buf,
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

