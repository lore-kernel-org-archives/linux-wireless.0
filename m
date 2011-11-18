Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab1KRIWW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:22 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8MMd0015810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:22 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 42/77] iwlegacy: s/STATISTICS/STATS/
Date: Fri, 18 Nov 2011 09:22:04 +0100
Message-Id: <1321604559-10707-42-git-send-email-sgruszka@redhat.com> (sfid-20111118_092407_689373_E8D11CEF)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-debug.c   |    6 ++--
 drivers/net/wireless/iwlegacy/3945-mac.c     |    6 ++--
 drivers/net/wireless/iwlegacy/3945.c         |    2 +-
 drivers/net/wireless/iwlegacy/4965-calib.c   |    2 +-
 drivers/net/wireless/iwlegacy/4965-debug.c   |    6 ++--
 drivers/net/wireless/iwlegacy/4965-mac.c     |   18 ++++++------
 drivers/net/wireless/iwlegacy/4965.c         |    4 +-
 drivers/net/wireless/iwlegacy/4965.h         |    4 +-
 drivers/net/wireless/iwlegacy/iwl-commands.h |   38 +++++++++++++-------------
 drivers/net/wireless/iwlegacy/iwl-core.c     |    4 +-
 drivers/net/wireless/iwlegacy/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c  |    4 +-
 drivers/net/wireless/iwlegacy/iwl-hcmd.c     |    4 +-
 13 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-debug.c b/drivers/net/wireless/iwlegacy/3945-debug.c
index 9c837c3..fc2d651 100644
--- a/drivers/net/wireless/iwlegacy/3945-debug.c
+++ b/drivers/net/wireless/iwlegacy/3945-debug.c
@@ -37,16 +37,16 @@ static int il3945_stats_flag(struct il_priv *il, char *buf, int bufsz)
 	p += scnprintf(buf + p, bufsz - p, "Statistics Flag(0x%X):\n",
 		       le32_to_cpu(il->_3945.stats.flag));
 	if (le32_to_cpu(il->_3945.stats.flag) &
-			UCODE_STATISTICS_CLEAR_MSK)
+			UCODE_STATS_CLEAR_MSK)
 		p += scnprintf(buf + p, bufsz - p,
 			       "\tStatistics have been cleared\n");
 	p += scnprintf(buf + p, bufsz - p, "\tOperational Frequency: %s\n",
 		       (le32_to_cpu(il->_3945.stats.flag) &
-			UCODE_STATISTICS_FREQUENCY_MSK)
+			UCODE_STATS_FREQUENCY_MSK)
 			? "2.4 GHz" : "5.2 GHz");
 	p += scnprintf(buf + p, bufsz - p, "\tTGj Narrow Band: %s\n",
 		       (le32_to_cpu(il->_3945.stats.flag) &
-			UCODE_STATISTICS_NARROW_BAND_MSK)
+			UCODE_STATS_NARROW_BAND_MSK)
 			? "enabled" : "disabled");
 	return p;
 }
diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index f69211e..2ff8075 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -869,8 +869,8 @@ static void il3945_setup_rx_handlers(struct il_priv *il)
 	 * stats request from the host as well as for the periodic
 	 * stats notifications (after received beacons) from the uCode.
 	 */
-	il->rx_handlers[REPLY_STATISTICS_CMD] = il3945_reply_stats;
-	il->rx_handlers[STATISTICS_NOTIFICATION] = il3945_hw_rx_stats;
+	il->rx_handlers[REPLY_STATS_CMD] = il3945_reply_stats;
+	il->rx_handlers[STATS_NOTIFICATION] = il3945_hw_rx_stats;
 
 	il_setup_rx_scan_handlers(il);
 	il->rx_handlers[CARD_STATE_NOTIFICATION] = il3945_rx_card_state_notif;
@@ -1253,7 +1253,7 @@ static void il3945_rx_handle(struct il_priv *il)
 		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
 		 *   but apparently a few don't get set; catch them here. */
 		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
-			pkt->hdr.cmd != STATISTICS_NOTIFICATION &&
+			pkt->hdr.cmd != STATS_NOTIFICATION &&
 			pkt->hdr.cmd != REPLY_TX;
 
 		/* Based on type of command response or notification,
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 8ebd576..82534a2 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -432,7 +432,7 @@ void il3945_reply_stats(struct il_priv *il,
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	__le32 *flag = (__le32 *)&pkt->u.raw;
 
-	if (le32_to_cpu(*flag) & UCODE_STATISTICS_CLEAR_MSK) {
+	if (le32_to_cpu(*flag) & UCODE_STATS_CLEAR_MSK) {
 #ifdef CONFIG_IWLEGACY_DEBUGFS
 		memset(&il->_3945.accum_stats, 0,
 			sizeof(struct il3945_notif_stats));
diff --git a/drivers/net/wireless/iwlegacy/4965-calib.c b/drivers/net/wireless/iwlegacy/4965-calib.c
index 1d0502e..cd61050 100644
--- a/drivers/net/wireless/iwlegacy/4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/4965-calib.c
@@ -853,7 +853,7 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 
 	stat_band24 = !!(((struct il_notif_stats *)
 			 stat_resp)->flag &
-			 STATISTICS_REPLY_FLG_BAND_24G_MSK);
+			 STATS_REPLY_FLG_BAND_24G_MSK);
 	stat_chnum = le32_to_cpu(((struct il_notif_stats *)
 				 stat_resp)->flag) >> 16;
 
diff --git a/drivers/net/wireless/iwlegacy/4965-debug.c b/drivers/net/wireless/iwlegacy/4965-debug.c
index 825d0aa..ad9c6d0 100644
--- a/drivers/net/wireless/iwlegacy/4965-debug.c
+++ b/drivers/net/wireless/iwlegacy/4965-debug.c
@@ -42,14 +42,14 @@ static int il4965_stats_flag(struct il_priv *il, char *buf, int bufsz)
 	flag = le32_to_cpu(il->_4965.stats.flag);
 
 	p += scnprintf(buf + p, bufsz - p, "Statistics Flag(0x%X):\n", flag);
-	if (flag & UCODE_STATISTICS_CLEAR_MSK)
+	if (flag & UCODE_STATS_CLEAR_MSK)
 		p += scnprintf(buf + p, bufsz - p,
 		"\tStatistics have been cleared\n");
 	p += scnprintf(buf + p, bufsz - p, "\tOperational Frequency: %s\n",
-		(flag & UCODE_STATISTICS_FREQUENCY_MSK)
+		(flag & UCODE_STATS_FREQUENCY_MSK)
 		? "2.4 GHz" : "5.2 GHz");
 	p += scnprintf(buf + p, bufsz - p, "\tTGj Narrow Band: %s\n",
-		(flag & UCODE_STATISTICS_NARROW_BAND_MSK)
+		(flag & UCODE_STATS_NARROW_BAND_MSK)
 		 ? "enabled" : "disabled");
 
 	return p;
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index c4198bd..c3f8137 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1367,9 +1367,9 @@ void il4965_rx_stats(struct il_priv *il,
 	change = ((il->_4965.stats.general.common.temperature !=
 		   pkt->u.stats.general.common.temperature) ||
 		   ((il->_4965.stats.flag &
-		   STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
+		   STATS_REPLY_FLG_HT40_MODE_MSK) !=
 		   (pkt->u.stats.flag &
-		   STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
+		   STATS_REPLY_FLG_HT40_MODE_MSK)));
 #ifdef CONFIG_IWLEGACY_DEBUGFS
 	il4965_accumulative_stats(il, (__le32 *)&pkt->u.stats);
 #endif
@@ -1378,7 +1378,7 @@ void il4965_rx_stats(struct il_priv *il,
 	memcpy(&il->_4965.stats, &pkt->u.stats,
 		sizeof(il->_4965.stats));
 
-	set_bit(S_STATISTICS, &il->status);
+	set_bit(S_STATS, &il->status);
 
 	/* Reschedule the stats timer to occur in
 	 * REG_RECALIB_PERIOD seconds to ensure we get a
@@ -1388,7 +1388,7 @@ void il4965_rx_stats(struct il_priv *il,
 		  msecs_to_jiffies(REG_RECALIB_PERIOD * 1000));
 
 	if (unlikely(!test_bit(S_SCANNING, &il->status)) &&
-	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
+	    (pkt->hdr.cmd == STATS_NOTIFICATION)) {
 		il4965_rx_calc_noise(il);
 		queue_work(il->workqueue, &il->run_time_calib_work);
 	}
@@ -1401,7 +1401,7 @@ void il4965_reply_stats(struct il_priv *il,
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 
-	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATISTICS_CLEAR_MSK) {
+	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATS_CLEAR_MSK) {
 #ifdef CONFIG_IWLEGACY_DEBUGFS
 		memset(&il->_4965.accum_stats, 0,
 			sizeof(struct il_notif_stats));
@@ -3801,7 +3801,7 @@ static void il4965_rx_reply_alive(struct il_priv *il,
  * This callback is provided in order to send a stats request.
  *
  * This timer function is continually reset to execute within
- * REG_RECALIB_PERIOD seconds since the last STATISTICS_NOTIFICATION
+ * REG_RECALIB_PERIOD seconds since the last STATS_NOTIFICATION
  * was received.  We need to ensure we receive the stats in order
  * to update the temperature used for calibrating the TXPOWER.
  */
@@ -3936,8 +3936,8 @@ static void il4965_setup_rx_handlers(struct il_priv *il)
 	 * stats request from the host as well as for the periodic
 	 * stats notifications (after received beacons) from the uCode.
 	 */
-	il->rx_handlers[REPLY_STATISTICS_CMD] = il4965_reply_stats;
-	il->rx_handlers[STATISTICS_NOTIFICATION] = il4965_rx_stats;
+	il->rx_handlers[REPLY_STATS_CMD] = il4965_reply_stats;
+	il->rx_handlers[STATS_NOTIFICATION] = il4965_rx_stats;
 
 	il_setup_rx_scan_handlers(il);
 
@@ -4023,7 +4023,7 @@ void il4965_rx_handle(struct il_priv *il)
 			(pkt->hdr.cmd != REPLY_RX) &&
 			(pkt->hdr.cmd != REPLY_RX_MPDU_CMD) &&
 			(pkt->hdr.cmd != REPLY_COMPRESSED_BA) &&
-			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
+			(pkt->hdr.cmd != STATS_NOTIFICATION) &&
 			(pkt->hdr.cmd != REPLY_TX);
 
 		/* Based on type of command response or notification,
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 1efe824..361a1ca 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1675,7 +1675,7 @@ static int il4965_hw_get_temperature(struct il_priv *il)
 
 	if (test_bit(S_TEMPERATURE, &il->status) &&
 	    (il->_4965.stats.flag &
-			STATISTICS_REPLY_FLG_HT40_MODE_MSK)) {
+			STATS_REPLY_FLG_HT40_MODE_MSK)) {
 		D_TEMP("Running HT40 temperature calibration\n");
 		R1 = (s32)le32_to_cpu(il->card_alive_init.therm_r1[1]);
 		R2 = (s32)le32_to_cpu(il->card_alive_init.therm_r2[1]);
@@ -1737,7 +1737,7 @@ static int il4965_is_temp_calib_needed(struct il_priv *il)
 {
 	int temp_diff;
 
-	if (!test_bit(S_STATISTICS, &il->status)) {
+	if (!test_bit(S_STATS, &il->status)) {
 		D_TEMP("Temperature not updated -- no stats.\n");
 		return 0;
 	}
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index b1a01c9..85c3a49 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -278,8 +278,8 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  * uCode provides all 4 values to the driver via the "initialize alive"
  * notification (see struct il4965_init_alive_resp).  After the runtime uCode
  * image loads, uCode updates the R4 value via stats notifications
- * (see STATISTICS_NOTIFICATION), which occur after each received beacon
- * when associated, or can be requested via REPLY_STATISTICS_CMD.
+ * (see STATS_NOTIFICATION), which occur after each received beacon
+ * when associated, or can be requested via REPLY_STATS_CMD.
  *
  * NOTE:  uCode provides the R4 value as a 23-bit signed value.  Driver
  *        must sign-extend to 32 bits before applying formula below.
diff --git a/drivers/net/wireless/iwlegacy/iwl-commands.h b/drivers/net/wireless/iwlegacy/iwl-commands.h
index 55822da..1a6ca36 100644
--- a/drivers/net/wireless/iwlegacy/iwl-commands.h
+++ b/drivers/net/wireless/iwlegacy/iwl-commands.h
@@ -136,8 +136,8 @@ enum {
 	REPLY_BT_CONFIG = 0x9b,
 
 	/* Statistics */
-	REPLY_STATISTICS_CMD = 0x9c,
-	STATISTICS_NOTIFICATION = 0x9d,
+	REPLY_STATS_CMD = 0x9c,
+	STATS_NOTIFICATION = 0x9d,
 
 	/* RF-KILL commands and notifications */
 	CARD_STATE_NOTIFICATION = 0xa1,
@@ -2626,7 +2626,7 @@ struct il_scanstart_notification {
 #define IL_PROBE_STATUS_FAIL_TTL	BIT(1)
 #define IL_PROBE_STATUS_FAIL_BT	BIT(2)
 
-#define NUMBER_OF_STATISTICS 1	/* first __le32 is good CRC */
+#define NUMBER_OF_STATS 1	/* first __le32 is good CRC */
 /*
  * SCAN_RESULTS_NOTIFICATION = 0x83 (notification only, not a command)
  */
@@ -2637,7 +2637,7 @@ struct il_scanresults_notification {
 	u8 num_probe_not_sent; /* not enough time to send */
 	__le32 tsf_low;
 	__le32 tsf_high;
-	__le32 stats[NUMBER_OF_STATISTICS];
+	__le32 stats[NUMBER_OF_STATS];
 } __packed;
 
 /*
@@ -2958,24 +2958,24 @@ struct stats_general {
 	__le32 reserved3;
 } __packed;
 
-#define UCODE_STATISTICS_CLEAR_MSK		(0x1 << 0)
-#define UCODE_STATISTICS_FREQUENCY_MSK		(0x1 << 1)
-#define UCODE_STATISTICS_NARROW_BAND_MSK	(0x1 << 2)
+#define UCODE_STATS_CLEAR_MSK		(0x1 << 0)
+#define UCODE_STATS_FREQUENCY_MSK		(0x1 << 1)
+#define UCODE_STATS_NARROW_BAND_MSK	(0x1 << 2)
 
 /*
- * REPLY_STATISTICS_CMD = 0x9c,
+ * REPLY_STATS_CMD = 0x9c,
  * all devices identical.
  *
  * This command triggers an immediate response containing uCode stats.
- * The response is in the same format as STATISTICS_NOTIFICATION 0x9d, below.
+ * The response is in the same format as STATS_NOTIFICATION 0x9d, below.
  *
  * If the CLEAR_STATS configuration flag is set, uCode will clear its
  * internal copy of the stats (counters) after issuing the response.
- * This flag does not affect STATISTICS_NOTIFICATIONs after beacons (see below).
+ * This flag does not affect STATS_NOTIFICATIONs after beacons (see below).
  *
  * If the DISABLE_NOTIF configuration flag is set, uCode will not issue
- * STATISTICS_NOTIFICATIONs after received beacons (see below).  This flag
- * does not affect the response to the REPLY_STATISTICS_CMD 0x9c itself.
+ * STATS_NOTIFICATIONs after received beacons (see below).  This flag
+ * does not affect the response to the REPLY_STATS_CMD 0x9c itself.
  */
 #define IL_STATS_CONF_CLEAR_STATS cpu_to_le32(0x1)	/* see above */
 #define IL_STATS_CONF_DISABLE_NOTIF cpu_to_le32(0x2)/* see above */
@@ -2984,22 +2984,22 @@ struct il_stats_cmd {
 } __packed;
 
 /*
- * STATISTICS_NOTIFICATION = 0x9d (notification only, not a command)
+ * STATS_NOTIFICATION = 0x9d (notification only, not a command)
  *
  * By default, uCode issues this notification after receiving a beacon
  * while associated.  To disable this behavior, set DISABLE_NOTIF flag in the
- * REPLY_STATISTICS_CMD 0x9c, above.
+ * REPLY_STATS_CMD 0x9c, above.
  *
  * Statistics counters continue to increment beacon after beacon, but are
- * cleared when changing channels or when driver issues REPLY_STATISTICS_CMD
+ * cleared when changing channels or when driver issues REPLY_STATS_CMD
  * 0x9c with CLEAR_STATS bit set (see above).
  *
  * uCode also issues this notification during scans.  uCode clears stats
  * appropriately so that each notification contains stats for only the
  * one channel that has just been scanned.
  */
-#define STATISTICS_REPLY_FLG_BAND_24G_MSK         cpu_to_le32(0x2)
-#define STATISTICS_REPLY_FLG_HT40_MODE_MSK        cpu_to_le32(0x8)
+#define STATS_REPLY_FLG_BAND_24G_MSK         cpu_to_le32(0x2)
+#define STATS_REPLY_FLG_HT40_MODE_MSK        cpu_to_le32(0x8)
 
 struct il3945_notif_stats {
 	__le32 flag;
@@ -3076,7 +3076,7 @@ struct il_missed_beacon_notif {
  * time listening, not transmitting).  Driver must adjust sensitivity so that
  * the ratio of actual false alarms to actual Rx time falls within this range.
  *
- * While associated, uCode delivers STATISTICS_NOTIFICATIONs after each
+ * While associated, uCode delivers STATS_NOTIFICATIONs after each
  * received beacon.  These provide information to the driver to analyze the
  * sensitivity.  Don't analyze stats that come in from scanning, or any
  * other non-associated-network source.  Pertinent stats include:
@@ -3255,7 +3255,7 @@ struct il_sensitivity_cmd {
  * This command sets the relative gains of 4965 device's 3 radio receiver chains.
  *
  * After the first association, driver should accumulate signal and noise
- * stats from the STATISTICS_NOTIFICATIONs that follow the first 20
+ * stats from the STATS_NOTIFICATIONs that follow the first 20
  * beacons from the associated network (don't collect stats that come
  * in from scanning, or any other non-network source).
  *
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index ba7ee4b..e6c7d5f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -1179,11 +1179,11 @@ int il_send_stats_request(struct il_priv *il, u8 flags, bool clear)
 	};
 
 	if (flags & CMD_ASYNC)
-		return il_send_cmd_pdu_async(il, REPLY_STATISTICS_CMD,
+		return il_send_cmd_pdu_async(il, REPLY_STATS_CMD,
 					sizeof(struct il_stats_cmd),
 					&stats_cmd, NULL);
 	else
-		return il_send_cmd_pdu(il, REPLY_STATISTICS_CMD,
+		return il_send_cmd_pdu(il, REPLY_STATS_CMD,
 					sizeof(struct il_stats_cmd),
 					&stats_cmd);
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index 5b2883f..e275ffc 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -544,7 +544,7 @@ void il_free_geos(struct il_priv *il);
 #define S_TEMPERATURE	8
 #define S_GEO_CONFIGURED	9
 #define S_EXIT_PENDING	10
-#define S_STATISTICS	12
+#define S_STATS		12
 #define S_SCANNING		13
 #define S_SCAN_ABORTING	14
 #define S_SCAN_HW		15
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index 114922b..b9888ac 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -491,8 +491,8 @@ static ssize_t il_dbgfs_status_read(struct file *file,
 		test_bit(S_GEO_CONFIGURED, &il->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "S_EXIT_PENDING:\t %d\n",
 		test_bit(S_EXIT_PENDING, &il->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "S_STATISTICS:\t %d\n",
-		test_bit(S_STATISTICS, &il->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "S_STATS:\t %d\n",
+		test_bit(S_STATS, &il->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "S_SCANNING:\t %d\n",
 		test_bit(S_SCANNING, &il->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "S_SCAN_ABORTING:\t %d\n",
diff --git a/drivers/net/wireless/iwlegacy/iwl-hcmd.c b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
index 4762a0e..19a5955 100644
--- a/drivers/net/wireless/iwlegacy/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
@@ -70,8 +70,8 @@ const char *il_get_cmd_string(u8 cmd)
 		IL_CMD(REPLY_TX_BEACON);
 		IL_CMD(REPLY_TX_PWR_TBL_CMD);
 		IL_CMD(REPLY_BT_CONFIG);
-		IL_CMD(REPLY_STATISTICS_CMD);
-		IL_CMD(STATISTICS_NOTIFICATION);
+		IL_CMD(REPLY_STATS_CMD);
+		IL_CMD(STATS_NOTIFICATION);
 		IL_CMD(CARD_STATE_NOTIFICATION);
 		IL_CMD(MISSED_BEACONS_NOTIFICATION);
 		IL_CMD(REPLY_CT_KILL_CONFIG_CMD);
-- 
1.7.1

