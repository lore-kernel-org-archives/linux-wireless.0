Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab1KRIVp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:45 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LjIq022642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:45 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 26/77] iwlegacy: s/TABLE/TBL/
Date: Fri, 18 Nov 2011 09:21:48 +0100
Message-Id: <1321604559-10707-26-git-send-email-sgruszka@redhat.com> (sfid-20111118_092152_664281_27A0751F)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-fh.h    |   32 +++++++-------
 drivers/net/wireless/iwlegacy/iwl-3945.c       |   52 ++++++++++++------------
 drivers/net/wireless/iwlegacy/iwl-4965-calib.c |    6 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c    |    8 ++--
 drivers/net/wireless/iwlegacy/iwl-4965.c       |    6 +-
 drivers/net/wireless/iwlegacy/iwl-commands.h   |   44 ++++++++++----------
 drivers/net/wireless/iwlegacy/iwl-csr.h        |    2 +-
 drivers/net/wireless/iwlegacy/iwl-dev.h        |    2 +-
 drivers/net/wireless/iwlegacy/iwl-hcmd.c       |    4 +-
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h  |   30 +++++++-------
 drivers/net/wireless/iwlegacy/iwl-power.c      |    2 +-
 drivers/net/wireless/iwlegacy/iwl-prph.h       |    4 +-
 drivers/net/wireless/iwlegacy/iwl-sta.c        |    2 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c   |    2 +-
 drivers/net/wireless/iwlegacy/iwl4965-base.c   |    2 +-
 15 files changed, 99 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-fh.h b/drivers/net/wireless/iwlegacy/iwl-3945-fh.h
index b98cabb..aa44a90 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-fh.h
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-fh.h
@@ -74,25 +74,25 @@
 #define FH39_MEM_LOWER_BOUND                   (0x0800)
 #define FH39_MEM_UPPER_BOUND                   (0x1000)
 
-#define FH39_CBCC_TABLE		(FH39_MEM_LOWER_BOUND + 0x140)
-#define FH39_TFDB_TABLE		(FH39_MEM_LOWER_BOUND + 0x180)
-#define FH39_RCSR_TABLE		(FH39_MEM_LOWER_BOUND + 0x400)
-#define FH39_RSSR_TABLE		(FH39_MEM_LOWER_BOUND + 0x4c0)
-#define FH39_TCSR_TABLE		(FH39_MEM_LOWER_BOUND + 0x500)
-#define FH39_TSSR_TABLE		(FH39_MEM_LOWER_BOUND + 0x680)
+#define FH39_CBCC_TBL		(FH39_MEM_LOWER_BOUND + 0x140)
+#define FH39_TFDB_TBL		(FH39_MEM_LOWER_BOUND + 0x180)
+#define FH39_RCSR_TBL		(FH39_MEM_LOWER_BOUND + 0x400)
+#define FH39_RSSR_TBL		(FH39_MEM_LOWER_BOUND + 0x4c0)
+#define FH39_TCSR_TBL		(FH39_MEM_LOWER_BOUND + 0x500)
+#define FH39_TSSR_TBL		(FH39_MEM_LOWER_BOUND + 0x680)
 
 /* TFDB (Transmit Frame Buffer Descriptor) */
-#define FH39_TFDB(_ch, buf)			(FH39_TFDB_TABLE + \
+#define FH39_TFDB(_ch, buf)			(FH39_TFDB_TBL + \
 						 ((_ch) * 2 + (buf)) * 0x28)
-#define FH39_TFDB_CHNL_BUF_CTRL_REG(_ch)	(FH39_TFDB_TABLE + 0x50 * (_ch))
+#define FH39_TFDB_CHNL_BUF_CTRL_REG(_ch)	(FH39_TFDB_TBL + 0x50 * (_ch))
 
 /* CBCC channel is [0,2] */
-#define FH39_CBCC(_ch)		(FH39_CBCC_TABLE + (_ch) * 0x8)
+#define FH39_CBCC(_ch)		(FH39_CBCC_TBL + (_ch) * 0x8)
 #define FH39_CBCC_CTRL(_ch)	(FH39_CBCC(_ch) + 0x00)
 #define FH39_CBCC_BASE(_ch)	(FH39_CBCC(_ch) + 0x04)
 
 /* RCSR channel is [0,2] */
-#define FH39_RCSR(_ch)			(FH39_RCSR_TABLE + (_ch) * 0x40)
+#define FH39_RCSR(_ch)			(FH39_RCSR_TBL + (_ch) * 0x40)
 #define FH39_RCSR_CONFIG(_ch)		(FH39_RCSR(_ch) + 0x00)
 #define FH39_RCSR_RBD_BASE(_ch)		(FH39_RCSR(_ch) + 0x04)
 #define FH39_RCSR_WPTR(_ch)		(FH39_RCSR(_ch) + 0x20)
@@ -101,19 +101,19 @@
 #define FH39_RSCSR_CHNL0_WPTR		(FH39_RCSR_WPTR(0))
 
 /* RSSR */
-#define FH39_RSSR_CTRL			(FH39_RSSR_TABLE + 0x000)
-#define FH39_RSSR_STATUS		(FH39_RSSR_TABLE + 0x004)
+#define FH39_RSSR_CTRL			(FH39_RSSR_TBL + 0x000)
+#define FH39_RSSR_STATUS		(FH39_RSSR_TBL + 0x004)
 
 /* TCSR */
-#define FH39_TCSR(_ch)			(FH39_TCSR_TABLE + (_ch) * 0x20)
+#define FH39_TCSR(_ch)			(FH39_TCSR_TBL + (_ch) * 0x20)
 #define FH39_TCSR_CONFIG(_ch)		(FH39_TCSR(_ch) + 0x00)
 #define FH39_TCSR_CREDIT(_ch)		(FH39_TCSR(_ch) + 0x04)
 #define FH39_TCSR_BUFF_STTS(_ch)	(FH39_TCSR(_ch) + 0x08)
 
 /* TSSR */
-#define FH39_TSSR_CBB_BASE        (FH39_TSSR_TABLE + 0x000)
-#define FH39_TSSR_MSG_CONFIG      (FH39_TSSR_TABLE + 0x008)
-#define FH39_TSSR_TX_STATUS       (FH39_TSSR_TABLE + 0x010)
+#define FH39_TSSR_CBB_BASE        (FH39_TSSR_TBL + 0x000)
+#define FH39_TSSR_MSG_CONFIG      (FH39_TSSR_TBL + 0x008)
+#define FH39_TSSR_TX_STATUS       (FH39_TSSR_TBL + 0x010)
 
 
 /* DBM */
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index 96a7628..b6abf34 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -60,8 +60,8 @@
 				    RATE_##rn##M_IDX, \
 				    RATE_##pp##M_IDX, \
 				    RATE_##np##M_IDX, \
-				    RATE_##r##M_IDX_TABLE, \
-				    RATE_##ip##M_IDX_TABLE }
+				    RATE_##r##M_IDX_TBL, \
+				    RATE_##ip##M_IDX_TBL }
 
 /*
  * Parameter order:
@@ -1330,7 +1330,7 @@ static void il3945_hw_reg_set_scan_power(struct il_priv *il, u32 scan_tbl_idx,
 	/* use this channel group's 6Mbit clipping/saturation pwr,
 	 *   but cap at regulatory scan power restriction (set during init
 	 *   based on eeprom channel data) for this channel.  */
-	power = min(ch_info->scan_power, clip_pwrs[RATE_6M_IDX_TABLE]);
+	power = min(ch_info->scan_power, clip_pwrs[RATE_6M_IDX_TBL]);
 
 	power = min(power, il->tx_power_user_lmt);
 	scan_power_info->requested_power = power;
@@ -1342,7 +1342,7 @@ static void il3945_hw_reg_set_scan_power(struct il_priv *il, u32 scan_tbl_idx,
 	 *   *idx*. */
 	power_idx = ch_info->power_info[rate_idx].power_table_idx
 	    - (power - ch_info->power_info
-	       [RATE_6M_IDX_TABLE].requested_power) * 2;
+	       [RATE_6M_IDX_TBL].requested_power) * 2;
 
 	/* store reference idx that we use when adjusting *all* scan
 	 *   powers.  So we can accommodate user (all channel) or spectrum
@@ -1394,7 +1394,7 @@ static int il3945_send_tx_power(struct il_priv *il)
 	}
 
 	if (!il_is_channel_valid(ch_info)) {
-		D_POWER("Not calling TX_PWR_TABLE_CMD on "
+		D_POWER("Not calling TX_PWR_TBL_CMD on "
 				"non-Tx channel.\n");
 		return 0;
 	}
@@ -1428,7 +1428,7 @@ static int il3945_send_tx_power(struct il_priv *il)
 				txpower.power[i].rate);
 	}
 
-	return il_send_cmd_pdu(il, REPLY_TX_PWR_TABLE_CMD,
+	return il_send_cmd_pdu(il, REPLY_TX_PWR_TBL_CMD,
 				sizeof(struct il3945_txpowertable_cmd),
 				&txpower);
 
@@ -1466,7 +1466,7 @@ static int il3945_hw_reg_set_new_power(struct il_priv *il,
 	power_info = ch_info->power_info;
 
 	/* update OFDM Txpower settings */
-	for (i = RATE_6M_IDX_TABLE; i <= RATE_54M_IDX_TABLE;
+	for (i = RATE_6M_IDX_TBL; i <= RATE_54M_IDX_TBL;
 	     i++, ++power_info) {
 		int delta_idx;
 
@@ -1490,14 +1490,14 @@ static int il3945_hw_reg_set_new_power(struct il_priv *il,
 	 *    ... all CCK power settings for a given channel are the *same*. */
 	if (power_changed) {
 		power =
-		    ch_info->power_info[RATE_12M_IDX_TABLE].
+		    ch_info->power_info[RATE_12M_IDX_TBL].
 		    requested_power + IL_CCK_FROM_OFDM_POWER_DIFF;
 
 		/* do all CCK rates' il3945_channel_power_info structures */
-		for (i = RATE_1M_IDX_TABLE; i <= RATE_11M_IDX_TABLE; i++) {
+		for (i = RATE_1M_IDX_TBL; i <= RATE_11M_IDX_TBL; i++) {
 			power_info->requested_power = power;
 			power_info->base_power_idx =
-			    ch_info->power_info[RATE_12M_IDX_TABLE].
+			    ch_info->power_info[RATE_12M_IDX_TBL].
 			    base_power_idx + IL_CCK_FROM_OFDM_IDX_DIFF;
 			++power_info;
 		}
@@ -1597,7 +1597,7 @@ static int il3945_hw_reg_comp_txpower_temp(struct il_priv *il)
 		for (scan_tbl_idx = 0;
 		     scan_tbl_idx < IL_NUM_SCAN_RATES; scan_tbl_idx++) {
 			s32 actual_idx = (scan_tbl_idx == 0) ?
-			    RATE_1M_IDX_TABLE : RATE_6M_IDX_TABLE;
+			    RATE_1M_IDX_TBL : RATE_6M_IDX_TBL;
 			il3945_hw_reg_set_scan_power(il, scan_tbl_idx,
 					   actual_idx, clip_pwrs,
 					   ch_info, a_band);
@@ -2012,19 +2012,19 @@ static void il3945_hw_reg_init_channel_groups(struct il_priv *il)
 		for (rate_idx = 0;
 		     rate_idx < RATE_COUNT_3945; rate_idx++, clip_pwrs++) {
 			switch (rate_idx) {
-			case RATE_36M_IDX_TABLE:
+			case RATE_36M_IDX_TBL:
 				if (i == 0)	/* B/G */
 					*clip_pwrs = satur_pwr;
 				else	/* A */
 					*clip_pwrs = satur_pwr - 5;
 				break;
-			case RATE_48M_IDX_TABLE:
+			case RATE_48M_IDX_TBL:
 				if (i == 0)
 					*clip_pwrs = satur_pwr - 7;
 				else
 					*clip_pwrs = satur_pwr - 10;
 				break;
-			case RATE_54M_IDX_TABLE:
+			case RATE_54M_IDX_TBL:
 				if (i == 0)
 					*clip_pwrs = satur_pwr - 9;
 				else
@@ -2139,7 +2139,7 @@ int il3945_txpower_set_from_eeprom(struct il_priv *il)
 		}
 
 		/* set tx power for CCK rates, based on OFDM 12 Mbit settings*/
-		pwr_info = &ch_info->power_info[RATE_12M_IDX_TABLE];
+		pwr_info = &ch_info->power_info[RATE_12M_IDX_TBL];
 		power = pwr_info->requested_power +
 			IL_CCK_FROM_OFDM_POWER_DIFF;
 		pwr_idx = pwr_info->power_table_idx +
@@ -2169,7 +2169,7 @@ int il3945_txpower_set_from_eeprom(struct il_priv *il)
 		for (scan_tbl_idx = 0;
 		     scan_tbl_idx < IL_NUM_SCAN_RATES; scan_tbl_idx++) {
 			s32 actual_idx = (scan_tbl_idx == 0) ?
-				RATE_1M_IDX_TABLE : RATE_6M_IDX_TABLE;
+				RATE_1M_IDX_TBL : RATE_6M_IDX_TBL;
 			il3945_hw_reg_set_scan_power(il, scan_tbl_idx,
 				actual_idx, clip_pwrs, ch_info, a_band);
 		}
@@ -2223,7 +2223,7 @@ static u16 il3945_get_hcmd_size(u8 cmd_id, u16 len)
 	switch (cmd_id) {
 	case REPLY_RXON:
 		return sizeof(struct il3945_rxon_cmd);
-	case POWER_TABLE_CMD:
+	case POWER_TBL_CMD:
 		return sizeof(struct il3945_powertable_cmd);
 	default:
 		return len;
@@ -2326,17 +2326,17 @@ int il3945_init_hw_rate_table(struct il_priv *il)
 		D_RATE("Select A mode rate scale\n");
 		/* If one of the following CCK rates is used,
 		 * have it fall back to the 6M OFDM rate */
-		for (i = RATE_1M_IDX_TABLE;
-			i <= RATE_11M_IDX_TABLE; i++)
+		for (i = RATE_1M_IDX_TBL;
+			i <= RATE_11M_IDX_TBL; i++)
 			table[i].next_rate_idx =
 			  il3945_rates[IL_FIRST_OFDM_RATE].table_rs_idx;
 
 		/* Don't fall back to CCK rates */
-		table[RATE_12M_IDX_TABLE].next_rate_idx =
-						RATE_9M_IDX_TABLE;
+		table[RATE_12M_IDX_TBL].next_rate_idx =
+						RATE_9M_IDX_TBL;
 
 		/* Don't drop out of OFDM rates */
-		table[RATE_6M_IDX_TABLE].next_rate_idx =
+		table[RATE_6M_IDX_TBL].next_rate_idx =
 		    il3945_rates[IL_FIRST_OFDM_RATE].table_rs_idx;
 		break;
 
@@ -2349,14 +2349,14 @@ int il3945_init_hw_rate_table(struct il_priv *il)
 		    il_is_associated(il)) {
 
 			idx = IL_FIRST_CCK_RATE;
-			for (i = RATE_6M_IDX_TABLE;
-			     i <= RATE_54M_IDX_TABLE; i++)
+			for (i = RATE_6M_IDX_TBL;
+			     i <= RATE_54M_IDX_TBL; i++)
 				table[i].next_rate_idx =
 					il3945_rates[idx].table_rs_idx;
 
-			idx = RATE_11M_IDX_TABLE;
+			idx = RATE_11M_IDX_TBL;
 			/* CCK shouldn't fall back to OFDM... */
-			table[idx].next_rate_idx = RATE_5M_IDX_TABLE;
+			table[idx].next_rate_idx = RATE_5M_IDX_TBL;
 		}
 		break;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
index d622b27..1d873a6 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
@@ -429,18 +429,18 @@ static int il4965_sensitivity_write(struct il_priv *il)
 	il4965_prepare_legacy_sensitivity_tbl(il, data, &cmd.table[0]);
 
 	/* Update uCode's "work" table, and copy it to DSP */
-	cmd.control = SENSITIVITY_CMD_CONTROL_WORK_TABLE;
+	cmd.control = SENSITIVITY_CMD_CONTROL_WORK_TBL;
 
 	/* Don't send command to uCode if nothing has changed */
 	if (!memcmp(&cmd.table[0], &(il->sensitivity_tbl[0]),
-		    sizeof(u16)*HD_TABLE_SIZE)) {
+		    sizeof(u16)*HD_TBL_SIZE)) {
 		D_CALIB("No change in SENSITIVITY_CMD\n");
 		return 0;
 	}
 
 	/* Copy table for comparison next time */
 	memcpy(&(il->sensitivity_tbl[0]), &(cmd.table[0]),
-	       sizeof(u16)*HD_TABLE_SIZE);
+	       sizeof(u16)*HD_TBL_SIZE);
 
 	return il_send_cmd(il, &cmd_out);
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index b8f8064..4a54311 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -1001,11 +1001,11 @@ static void il4965_rs_set_stay_in_table(struct il_priv *il, u8 is_legacy,
 	D_RATE("we are staying in the same table\n");
 	lq_sta->stay_in_tbl = 1;	/* only place this gets set */
 	if (is_legacy) {
-		lq_sta->table_count_limit = IL_LEGACY_TABLE_COUNT;
+		lq_sta->table_count_limit = IL_LEGACY_TBL_COUNT;
 		lq_sta->max_failure_limit = IL_LEGACY_FAILURE_LIMIT;
 		lq_sta->max_success_limit = IL_LEGACY_SUCCESS_LIMIT;
 	} else {
-		lq_sta->table_count_limit = IL_NONE_LEGACY_TABLE_COUNT;
+		lq_sta->table_count_limit = IL_NONE_LEGACY_TBL_COUNT;
 		lq_sta->max_failure_limit = IL_NONE_LEGACY_FAILURE_LIMIT;
 		lq_sta->max_success_limit = IL_NONE_LEGACY_SUCCESS_LIMIT;
 	}
@@ -1916,7 +1916,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		 * continuing to use the setup that we've been trying. */
 		if (win->average_tpt > lq_sta->last_tpt) {
 
-			D_RATE("LQ: SWITCHING TO NEW TABLE "
+			D_RATE("LQ: SWITCHING TO NEW TBL "
 					"suc=%d cur-tpt=%d old-tpt=%d\n",
 					win->success_ratio,
 					win->average_tpt,
@@ -1932,7 +1932,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		/* Else poor success; go back to mode in "active" table */
 		} else {
 
-			D_RATE("LQ: GOING BACK TO THE OLD TABLE "
+			D_RATE("LQ: GOING BACK TO THE OLD TBL "
 					"suc=%d cur-tpt=%d old-tpt=%d\n",
 					win->success_ratio,
 					win->average_tpt,
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 8fd383e..bdfb3a6 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1010,7 +1010,7 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 	}
 
 	/* for each of 33 bit-rates (including 1 for CCK) */
-	for (i = 0; i < POWER_TABLE_NUM_ENTRIES; i++) {
+	for (i = 0; i < POWER_TBL_NUM_ENTRIES; i++) {
 		u8 is_mimo_rate;
 		union il4965_tx_power_dual_stream tx_power;
 
@@ -1072,7 +1072,7 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 				power_idx += 9;
 
 			/* CCK, rate 32, reduce txpower for CCK */
-			if (i == POWER_TABLE_CCK_ENTRY)
+			if (i == POWER_TBL_CCK_ENTRY)
 				power_idx +=
 				    IL_TX_POWER_CCK_COMPENSATION_C_STEP;
 
@@ -1144,7 +1144,7 @@ static int il4965_send_tx_power(struct il_priv *il)
 		goto out;
 
 	ret = il_send_cmd_pdu(il,
-			 REPLY_TX_PWR_TABLE_CMD, sizeof(cmd), &cmd);
+			 REPLY_TX_PWR_TBL_CMD, sizeof(cmd), &cmd);
 
 out:
 	return ret;
diff --git a/drivers/net/wireless/iwlegacy/iwl-commands.h b/drivers/net/wireless/iwlegacy/iwl-commands.h
index 4083912..e6688b1 100644
--- a/drivers/net/wireless/iwlegacy/iwl-commands.h
+++ b/drivers/net/wireless/iwlegacy/iwl-commands.h
@@ -114,7 +114,7 @@ enum {
 	SPECTRUM_MEASURE_NOTIFICATION = 0x75,
 
 	/* Power Management */
-	POWER_TABLE_CMD = 0x77,
+	POWER_TBL_CMD = 0x77,
 	PM_SLEEP_NOTIFICATION = 0x7A,
 	PM_DEBUG_STATISTIC_NOTIFIC = 0x7B,
 
@@ -130,7 +130,7 @@ enum {
 	REPLY_TX_BEACON = 0x91,
 
 	/* Miscellaneous commands */
-	REPLY_TX_PWR_TABLE_CMD = 0x97,
+	REPLY_TX_PWR_TBL_CMD = 0x97,
 
 	/* Bluetooth device coexistence config command */
 	REPLY_BT_CONFIG = 0x9b,
@@ -214,7 +214,7 @@ struct il_cmd_header {
 /**
  * struct il3945_tx_power
  *
- * Used in REPLY_TX_PWR_TABLE_CMD, REPLY_SCAN_CMD, REPLY_CHANNEL_SWITCH
+ * Used in REPLY_TX_PWR_TBL_CMD, REPLY_SCAN_CMD, REPLY_CHANNEL_SWITCH
  *
  * Each entry contains two values:
  * 1)  DSP gain (or sometimes called DSP attenuation).  This is a fine-grained
@@ -233,7 +233,7 @@ struct il3945_tx_power {
 /**
  * struct il3945_power_per_rate
  *
- * Used in REPLY_TX_PWR_TABLE_CMD, REPLY_CHANNEL_SWITCH
+ * Used in REPLY_TX_PWR_TBL_CMD, REPLY_CHANNEL_SWITCH
  */
 struct il3945_power_per_rate {
 	u8 rate;		/* plcp */
@@ -326,9 +326,9 @@ struct il3945_power_per_rate {
 #define RATE_MCS_ANT_ABC_MSK	(RATE_MCS_ANT_AB_MSK | RATE_MCS_ANT_C_MSK)
 #define RATE_ANT_NUM 3
 
-#define POWER_TABLE_NUM_ENTRIES			33
-#define POWER_TABLE_NUM_HT_OFDM_ENTRIES		32
-#define POWER_TABLE_CCK_ENTRY			32
+#define POWER_TBL_NUM_ENTRIES			33
+#define POWER_TBL_NUM_HT_OFDM_ENTRIES		32
+#define POWER_TBL_CCK_ENTRY			32
 
 #define IL_PWR_NUM_HT_OFDM_ENTRIES		24
 #define IL_PWR_CCK_ENTRIES			2
@@ -336,7 +336,7 @@ struct il3945_power_per_rate {
 /**
  * union il4965_tx_power_dual_stream
  *
- * Host format used for REPLY_TX_PWR_TABLE_CMD, REPLY_CHANNEL_SWITCH
+ * Host format used for REPLY_TX_PWR_TBL_CMD, REPLY_CHANNEL_SWITCH
  * Use __le32 version (struct tx_power_dual_stream) when building command.
  *
  * Driver provides radio gain and DSP attenuation settings to device in pairs,
@@ -360,7 +360,7 @@ union il4965_tx_power_dual_stream {
 /**
  * struct tx_power_dual_stream
  *
- * Table entries in REPLY_TX_PWR_TABLE_CMD, REPLY_CHANNEL_SWITCH
+ * Table entries in REPLY_TX_PWR_TBL_CMD, REPLY_CHANNEL_SWITCH
  *
  * Same format as il_tx_power_dual_stream, but __le32
  */
@@ -371,10 +371,10 @@ struct tx_power_dual_stream {
 /**
  * struct il4965_tx_power_db
  *
- * Entire table within REPLY_TX_PWR_TABLE_CMD, REPLY_CHANNEL_SWITCH
+ * Entire table within REPLY_TX_PWR_TBL_CMD, REPLY_CHANNEL_SWITCH
  */
 struct il4965_tx_power_db {
-	struct tx_power_dual_stream power_tbl[POWER_TABLE_NUM_ENTRIES];
+	struct tx_power_dual_stream power_tbl[POWER_TBL_NUM_ENTRIES];
 } __packed;
 
 /******************************************************************************
@@ -653,7 +653,7 @@ enum {
  *        channel.
  *
  * NOTE:  All RXONs wipe clean the internal txpower table.  Driver must
- *        issue a new REPLY_TX_PWR_TABLE_CMD after each REPLY_RXON (0x10),
+ *        issue a new REPLY_TX_PWR_TBL_CMD after each REPLY_RXON (0x10),
  *        regardless of whether RXON_FILTER_ASSOC_MSK is set.
  */
 
@@ -1067,7 +1067,7 @@ struct il_addsta_cmd {
 
 
 #define ADD_STA_SUCCESS_MSK		0x1
-#define ADD_STA_NO_ROOM_IN_TABLE	0x2
+#define ADD_STA_NO_ROOM_IN_TBL	0x2
 #define ADD_STA_NO_BLOCK_ACK_RESOURCE	0x4
 #define ADD_STA_MODIFY_NON_EXIST_STA	0x8
 /*
@@ -1271,7 +1271,7 @@ struct il_rx_mpdu_res_start {
  * command, as set up by the REPLY_RATE_SCALE (for 3945) or
  * REPLY_TX_LINK_QUALITY_CMD (4965).
  *
- * Driver sets up transmit power for various rates via REPLY_TX_PWR_TABLE_CMD.
+ * Driver sets up transmit power for various rates via REPLY_TX_PWR_TBL_CMD.
  * This command must be executed after every RXON command, before Tx can occur.
  *****************************************************************************/
 
@@ -1754,7 +1754,7 @@ struct il_compressed_ba_resp {
 } __packed;
 
 /*
- * REPLY_TX_PWR_TABLE_CMD = 0x97 (command, has simple generic response)
+ * REPLY_TX_PWR_TBL_CMD = 0x97 (command, has simple generic response)
  *
  * See details under "TXPOWER" in iwl-4965-hw.h.
  */
@@ -1909,7 +1909,7 @@ struct il_link_qual_agg_params {
  * procedures are possible, and may work better for particular environments.
  *
  *
- * FILLING THE RATE TABLE
+ * FILLING THE RATE TBL
  *
  * Given a particular initial rate and mode, as determined by the rate
  * scaling algorithm described below, the Linux driver uses the following
@@ -2263,7 +2263,7 @@ struct il_spectrum_notification {
  * struct il_powertable_cmd - Power Table Command
  * @flags: See below:
  *
- * POWER_TABLE_CMD = 0x77 (command, has simple generic response)
+ * POWER_TBL_CMD = 0x77 (command, has simple generic response)
  *
  * PM allow:
  *   bit 0 - '0' Driver not allow power management
@@ -2290,7 +2290,7 @@ struct il_spectrum_notification {
  *              '10' force xtal sleep
  *              '11' Illegal set
  *
- * NOTE: if sleep_interval[SLEEP_INTRVL_TABLE_SIZE-1] > DTIM period then
+ * NOTE: if sleep_interval[SLEEP_INTRVL_TBL_SIZE-1] > DTIM period then
  * ucode assume sleep over DTIM is allowed and we don't need to wake up
  * for every DTIM.
  */
@@ -3219,7 +3219,7 @@ struct il_missed_beacon_notif {
 /*
  * Table entries in SENSITIVITY_CMD (struct il_sensitivity_cmd)
  */
-#define HD_TABLE_SIZE  (11)	/* number of entries */
+#define HD_TBL_SIZE  (11)	/* number of entries */
 #define HD_MIN_ENERGY_CCK_DET_IDX                 (0)	/* table idxes */
 #define HD_MIN_ENERGY_OFDM_DET_IDX                (1)
 #define HD_AUTO_CORR32_X1_TH_ADD_MIN_IDX          (2)
@@ -3233,8 +3233,8 @@ struct il_missed_beacon_notif {
 #define HD_OFDM_ENERGY_TH_IN_IDX                  (10)
 
 /* Control field in struct il_sensitivity_cmd */
-#define SENSITIVITY_CMD_CONTROL_DEFAULT_TABLE	cpu_to_le16(0)
-#define SENSITIVITY_CMD_CONTROL_WORK_TABLE	cpu_to_le16(1)
+#define SENSITIVITY_CMD_CONTROL_DEFAULT_TBL	cpu_to_le16(0)
+#define SENSITIVITY_CMD_CONTROL_WORK_TBL	cpu_to_le16(1)
 
 /**
  * struct il_sensitivity_cmd
@@ -3245,7 +3245,7 @@ struct il_missed_beacon_notif {
  */
 struct il_sensitivity_cmd {
 	__le16 control;			/* always use "1" */
-	__le16 table[HD_TABLE_SIZE];	/* use HD_* as idx */
+	__le16 table[HD_TBL_SIZE];	/* use HD_* as idx */
 } __packed;
 
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-csr.h b/drivers/net/wireless/iwlegacy/iwl-csr.h
index 34edec3..4db0429 100644
--- a/drivers/net/wireless/iwlegacy/iwl-csr.h
+++ b/drivers/net/wireless/iwlegacy/iwl-csr.h
@@ -357,7 +357,7 @@
 /* HPET MEM debug */
 #define CSR_DBG_HPET_MEM_REG_VAL	(0xFFFF0000)
 
-/* DRAM INT TABLE */
+/* DRAM INT TBL */
 #define CSR_DRAM_INT_TBL_ENABLE		(1 << 31)
 #define CSR_DRAM_INIT_TBL_WRAP_CHECK	(1 << 27)
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index 2555f9f..7c86d19 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -1060,7 +1060,7 @@ struct il_priv {
 	u8 start_calib;
 	struct il_sensitivity_data sensitivity_data;
 	struct il_chain_noise_data chain_noise_data;
-	__le16 sensitivity_tbl[HD_TABLE_SIZE];
+	__le16 sensitivity_tbl[HD_TBL_SIZE];
 
 	struct il_ht_config current_ht_config;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-hcmd.c b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
index e63777b..0b11f2f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
@@ -58,7 +58,7 @@ const char *il_get_cmd_string(u8 cmd)
 		IL_CMD(CHANNEL_SWITCH_NOTIFICATION);
 		IL_CMD(REPLY_SPECTRUM_MEASUREMENT_CMD);
 		IL_CMD(SPECTRUM_MEASURE_NOTIFICATION);
-		IL_CMD(POWER_TABLE_CMD);
+		IL_CMD(POWER_TBL_CMD);
 		IL_CMD(PM_SLEEP_NOTIFICATION);
 		IL_CMD(PM_DEBUG_STATISTIC_NOTIFIC);
 		IL_CMD(REPLY_SCAN_CMD);
@@ -68,7 +68,7 @@ const char *il_get_cmd_string(u8 cmd)
 		IL_CMD(SCAN_COMPLETE_NOTIFICATION);
 		IL_CMD(BEACON_NOTIFICATION);
 		IL_CMD(REPLY_TX_BEACON);
-		IL_CMD(REPLY_TX_PWR_TABLE_CMD);
+		IL_CMD(REPLY_TX_PWR_TBL_CMD);
 		IL_CMD(REPLY_BT_CONFIG);
 		IL_CMD(REPLY_STATISTICS_CMD);
 		IL_CMD(STATISTICS_NOTIFICATION);
diff --git a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
index bc09a5d..58e04cb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
+++ b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
@@ -80,19 +80,19 @@ enum {
 };
 
 enum {
-	RATE_6M_IDX_TABLE = 0,
-	RATE_9M_IDX_TABLE,
-	RATE_12M_IDX_TABLE,
-	RATE_18M_IDX_TABLE,
-	RATE_24M_IDX_TABLE,
-	RATE_36M_IDX_TABLE,
-	RATE_48M_IDX_TABLE,
-	RATE_54M_IDX_TABLE,
-	RATE_1M_IDX_TABLE,
-	RATE_2M_IDX_TABLE,
-	RATE_5M_IDX_TABLE,
-	RATE_11M_IDX_TABLE,
-	RATE_INVM_IDX_TABLE = RATE_INVM_IDX - 1,
+	RATE_6M_IDX_TBL = 0,
+	RATE_9M_IDX_TBL,
+	RATE_12M_IDX_TBL,
+	RATE_18M_IDX_TBL,
+	RATE_24M_IDX_TBL,
+	RATE_36M_IDX_TBL,
+	RATE_48M_IDX_TBL,
+	RATE_54M_IDX_TBL,
+	RATE_1M_IDX_TBL,
+	RATE_2M_IDX_TBL,
+	RATE_5M_IDX_TBL,
+	RATE_11M_IDX_TBL,
+	RATE_INVM_IDX_TBL = RATE_INVM_IDX - 1,
 };
 
 enum {
@@ -213,11 +213,11 @@ enum {
  * searching for a new modulation mode */
 #define IL_LEGACY_FAILURE_LIMIT	160
 #define IL_LEGACY_SUCCESS_LIMIT	480
-#define IL_LEGACY_TABLE_COUNT		160
+#define IL_LEGACY_TBL_COUNT		160
 
 #define IL_NONE_LEGACY_FAILURE_LIMIT	400
 #define IL_NONE_LEGACY_SUCCESS_LIMIT	4500
-#define IL_NONE_LEGACY_TABLE_COUNT	1500
+#define IL_NONE_LEGACY_TBL_COUNT	1500
 
 /* Success ratio (ACKed / attempted tx frames) values (perfect is 128 * 100) */
 #define IL_RS_GOOD_RATIO		12800	/* 100% */
diff --git a/drivers/net/wireless/iwlegacy/iwl-power.c b/drivers/net/wireless/iwlegacy/iwl-power.c
index 6c6e5e7..051623a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-power.c
+++ b/drivers/net/wireless/iwlegacy/iwl-power.c
@@ -88,7 +88,7 @@ il_set_power(struct il_priv *il, struct il_powertable_cmd *cmd)
 			le32_to_cpu(cmd->sleep_interval[3]),
 			le32_to_cpu(cmd->sleep_interval[4]));
 
-	return il_send_cmd_pdu(il, POWER_TABLE_CMD,
+	return il_send_cmd_pdu(il, POWER_TBL_CMD,
 				sizeof(struct il_powertable_cmd), cmd);
 }
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-prph.h b/drivers/net/wireless/iwlegacy/iwl-prph.h
index 8128c87..e34d907 100644
--- a/drivers/net/wireless/iwlegacy/iwl-prph.h
+++ b/drivers/net/wireless/iwlegacy/iwl-prph.h
@@ -189,7 +189,7 @@
  *        procedure.
  *
  * This save/restore method is mostly for autonomous power management during
- * normal operation (result of POWER_TABLE_CMD).  Platform suspend/resume and
+ * normal operation (result of POWER_TBL_CMD).  Platform suspend/resume and
  * RFKILL should use complete restarts (with total re-initialization) of uCode,
  * allowing total shutdown (including BSM memory).
  *
@@ -494,7 +494,7 @@
  * When queue is in Scheduler-ACK mode, frames placed in a that queue must be
  * for only one combination of receiver address (RA) and traffic ID (TID), i.e.
  * one QOS priority level destined for one station (for this wireless link,
- * not final destination).  The SCD_TRANSLATE_TABLE area provides 16 16-bit
+ * not final destination).  The SCD_TRANSLATE_TBL area provides 16 16-bit
  * mappings, one for each of the 16 queues.  If queue is not in Scheduler-ACK
  * mode, the device ignores the mapping value.
  *
diff --git a/drivers/net/wireless/iwlegacy/iwl-sta.c b/drivers/net/wireless/iwlegacy/iwl-sta.c
index a7fe9ea..ffb966b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-sta.c
@@ -83,7 +83,7 @@ static int il_process_add_sta_resp(struct il_priv *il,
 		il_sta_ucode_activate(il, sta_id);
 		ret = 0;
 		break;
-	case ADD_STA_NO_ROOM_IN_TABLE:
+	case ADD_STA_NO_ROOM_IN_TBL:
 		IL_ERR("Adding station %d failed, no room in table.\n",
 			sta_id);
 		break;
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 9244208..41104e7 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -885,7 +885,7 @@ static void il3945_setup_rx_handlers(struct il_priv *il)
  * Rx theory of operation
  *
  * The host allocates 32 DMA target addresses and passes the host address
- * to the firmware at register IL_RFDS_TABLE_LOWER + N * RFD_SIZE where N is
+ * to the firmware at register IL_RFDS_TBL_LOWER + N * RFD_SIZE where N is
  * 0 to 31
  *
  * Rx Queue Indexes
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index afdec78..043d51e 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -1470,7 +1470,7 @@ static const char * const desc_lookup_text[] = {
 	"HW_ERROR_TUNE_LOCK",
 	"HW_ERROR_TEMPERATURE",
 	"ILLEGAL_CHAN_FREQ",
-	"VCC_NOT_STABLE",
+	"VCC_NOT_STBL",
 	"FH_ERROR",
 	"NMI_INTERRUPT_HOST",
 	"NMI_INTERRUPT_ACTION_PT",
-- 
1.7.1

