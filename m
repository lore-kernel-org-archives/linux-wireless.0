Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab2BMKYF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:05 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 08/24] iwlegacy: remove temp_ops
Date: Mon, 13 Feb 2012 11:23:15 +0100
Message-Id: <1329128611-6815-9-git-send-email-sgruszka@redhat.com> (sfid-20120213_112422_201665_9BED03B6)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unneeded structure and cleanup temperature calibration routines
a bit.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   26 +++++++++++++-------------
 drivers/net/wireless/iwlegacy/4965.c     |    5 +----
 drivers/net/wireless/iwlegacy/4965.h     |    1 +
 drivers/net/wireless/iwlegacy/common.h   |    8 --------
 4 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 36f85f2..e113dc5 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1343,12 +1343,11 @@ il4965_accumulative_stats(struct il_priv *il, __le32 * stats)
 }
 #endif
 
-#define REG_RECALIB_PERIOD (60)
-
 void
 il4965_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb)
 {
-	int change;
+	const int recalib_seconds = 60;
+	bool change;
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 
 	D_RX("Statistics notification received (%d vs %d).\n",
@@ -1369,20 +1368,21 @@ il4965_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb)
 
 	set_bit(S_STATS, &il->status);
 
-	/* Reschedule the stats timer to occur in
-	 * REG_RECALIB_PERIOD seconds to ensure we get a
-	 * thermal update even if the uCode doesn't give
-	 * us one */
+	/*
+	 * Reschedule the stats timer to occur in recalib_seconds to ensure
+	 * we get a thermal update even if the uCode doesn't give us one
+	 */
 	mod_timer(&il->stats_periodic,
-		  jiffies + msecs_to_jiffies(REG_RECALIB_PERIOD * 1000));
+		  jiffies + msecs_to_jiffies(recalib_seconds * 1000));
 
 	if (unlikely(!test_bit(S_SCANNING, &il->status)) &&
 	    (pkt->hdr.cmd == N_STATS)) {
 		il4965_rx_calc_noise(il);
 		queue_work(il->workqueue, &il->run_time_calib_work);
 	}
-	if (il->ops->lib->temp_ops.temperature && change)
-		il->ops->lib->temp_ops.temperature(il);
+
+	if (change)
+		il4965_temperature_calib(il);
 }
 
 void
@@ -4028,9 +4028,9 @@ il4965_hdl_alive(struct il_priv *il, struct il_rx_buf *rxb)
  * This callback is provided in order to send a stats request.
  *
  * This timer function is continually reset to execute within
- * REG_RECALIB_PERIOD seconds since the last N_STATS
- * was received.  We need to ensure we receive the stats in order
- * to update the temperature used for calibrating the TXPOWER.
+ * 60 seconds since the last N_STATS was received.  We need to
+ * ensure we receive the stats in order to update the temperature
+ * used for calibrating the TXPOWER.
  */
 static void
 il4965_bg_stats_periodic(unsigned long data)
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 34fa3db..3a30aac 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1678,7 +1678,7 @@ il4965_is_temp_calib_needed(struct il_priv *il)
 	return 1;
 }
 
-static void
+void
 il4965_temperature_calib(struct il_priv *il)
 {
 	s32 temp;
@@ -1910,9 +1910,6 @@ static struct il_lib_ops il4965_lib = {
 		       },
 	.send_tx_power = il4965_send_tx_power,
 	.update_chain_flags = il4965_update_chain_flags,
-	.temp_ops = {
-		     .temperature = il4965_temperature_calib,
-		     },
 };
 
 static const struct il_legacy_ops il4965_legacy_ops = {
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index b3fcb8f..7c6b9b9 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -266,6 +266,7 @@ il4965_hw_valid_rtc_data_addr(u32 addr)
 	((t) < IL_TX_POWER_TEMPERATURE_MIN || \
 	 (t) > IL_TX_POWER_TEMPERATURE_MAX)
 
+extern void il4965_temperature_calib(struct il_priv *il);
 /********************* END TEMPERATURE ***************************************/
 
 /********************* START TXPOWER *****************************************/
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index cd8f27d..6f42f56 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1588,10 +1588,6 @@ struct il_debugfs_ops {
 };
 #endif
 
-struct il_temp_ops {
-	void (*temperature) (struct il_priv *il);
-};
-
 struct il_lib_ops {
 	/* Handling TX */
 	void (*txq_update_byte_cnt_tbl) (struct il_priv *il,
@@ -1622,10 +1618,6 @@ struct il_lib_ops {
 
 	/* eeprom operations */
 	struct il_eeprom_ops eeprom_ops;
-
-	/* temperature */
-	struct il_temp_ops temp_ops;
-
 };
 
 struct il_led_ops {
-- 
1.7.1

