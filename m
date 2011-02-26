Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49426 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab1BZTBQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 14:01:16 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/5] iwlagn: enable BT session 2 type UART for 2000 series
Date: Sat, 26 Feb 2011 10:46:06 -0800
Message-Id: <1298745966-25130-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1298745966-25130-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1298745966-25130-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 2000 series device, use session 2 type of BT UART message

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   68 ++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-commands.h |   22 ++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 4 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 30483e2..335aded 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -418,6 +418,7 @@ static struct iwl_bt_params iwl2030_bt_params = {
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
 	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 	.bt_sco_disable = true,
+	.bt_session_2 = true,
 };
 
 #define IWL_DEVICE_2000						\
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index dc7055e..8e19207 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1804,26 +1804,39 @@ static const __le32 iwlagn_concurrent_lookup[12] = {
 
 void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 {
-	struct iwl6000_bt_cmd bt_cmd = {
+	struct iwl_basic_bt_cmd basic = {
 		.max_kill = IWLAGN_BT_MAX_KILL_DEFAULT,
 		.bt3_timer_t7_value = IWLAGN_BT3_T7_DEFAULT,
 		.bt3_prio_sample_time = IWLAGN_BT3_PRIO_SAMPLE_DEFAULT,
 		.bt3_timer_t2_value = IWLAGN_BT3_T2_DEFAULT,
 	};
+	struct iwl6000_bt_cmd bt_cmd_6000;
+	struct iwl2000_bt_cmd bt_cmd_2000;
+	int ret;
 
 	BUILD_BUG_ON(sizeof(iwlagn_def_3w_lookup) !=
-			sizeof(bt_cmd.bt3_lookup_table));
-
-	if (priv->cfg->bt_params)
-		bt_cmd.prio_boost = priv->cfg->bt_params->bt_prio_boost;
-	else
-		bt_cmd.prio_boost = 0;
-	bt_cmd.kill_ack_mask = priv->kill_ack_mask;
-	bt_cmd.kill_cts_mask = priv->kill_cts_mask;
+			sizeof(basic.bt3_lookup_table));
+
+	if (priv->cfg->bt_params) {
+		if (priv->cfg->bt_params->bt_session_2) {
+			bt_cmd_2000.prio_boost = cpu_to_le32(
+				priv->cfg->bt_params->bt_prio_boost);
+			bt_cmd_2000.tx_prio_boost = 0;
+			bt_cmd_2000.rx_prio_boost = 0;
+		} else {
+			bt_cmd_6000.prio_boost =
+				priv->cfg->bt_params->bt_prio_boost;
+			bt_cmd_6000.tx_prio_boost = 0;
+			bt_cmd_6000.rx_prio_boost = 0;
+		}
+	} else {
+		IWL_ERR(priv, "failed to construct BT Coex Config\n");
+		return;
+	}
 
-	bt_cmd.valid = priv->bt_valid;
-	bt_cmd.tx_prio_boost = 0;
-	bt_cmd.rx_prio_boost = 0;
+	basic.kill_ack_mask = priv->kill_ack_mask;
+	basic.kill_cts_mask = priv->kill_cts_mask;
+	basic.valid = priv->bt_valid;
 
 	/*
 	 * Configure BT coex mode to "no coexistence" when the
@@ -1832,32 +1845,43 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	 * IBSS mode (no proper uCode support for coex then).
 	 */
 	if (!bt_coex_active || priv->iw_mode == NL80211_IFTYPE_ADHOC) {
-		bt_cmd.flags = IWLAGN_BT_FLAG_COEX_MODE_DISABLED;
+		basic.flags = IWLAGN_BT_FLAG_COEX_MODE_DISABLED;
 	} else {
-		bt_cmd.flags = IWLAGN_BT_FLAG_COEX_MODE_3W <<
+		basic.flags = IWLAGN_BT_FLAG_COEX_MODE_3W <<
 					IWLAGN_BT_FLAG_COEX_MODE_SHIFT;
 		if (priv->cfg->bt_params &&
 		    priv->cfg->bt_params->bt_sco_disable)
-			bt_cmd.flags |= IWLAGN_BT_FLAG_SYNC_2_BT_DISABLE;
+			basic.flags |= IWLAGN_BT_FLAG_SYNC_2_BT_DISABLE;
 
 		if (priv->bt_ch_announce)
-			bt_cmd.flags |= IWLAGN_BT_FLAG_CHANNEL_INHIBITION;
-		IWL_DEBUG_INFO(priv, "BT coex flag: 0X%x\n", bt_cmd.flags);
+			basic.flags |= IWLAGN_BT_FLAG_CHANNEL_INHIBITION;
+		IWL_DEBUG_INFO(priv, "BT coex flag: 0X%x\n", basic.flags);
 	}
-	priv->bt_enable_flag = bt_cmd.flags;
+	priv->bt_enable_flag = basic.flags;
 	if (priv->bt_full_concurrent)
-		memcpy(bt_cmd.bt3_lookup_table, iwlagn_concurrent_lookup,
+		memcpy(basic.bt3_lookup_table, iwlagn_concurrent_lookup,
 			sizeof(iwlagn_concurrent_lookup));
 	else
-		memcpy(bt_cmd.bt3_lookup_table, iwlagn_def_3w_lookup,
+		memcpy(basic.bt3_lookup_table, iwlagn_def_3w_lookup,
 			sizeof(iwlagn_def_3w_lookup));
 
 	IWL_DEBUG_INFO(priv, "BT coex %s in %s mode\n",
-		       bt_cmd.flags ? "active" : "disabled",
+		       basic.flags ? "active" : "disabled",
 		       priv->bt_full_concurrent ?
 		       "full concurrency" : "3-wire");
 
-	if (iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG, sizeof(bt_cmd), &bt_cmd))
+	if (priv->cfg->bt_params->bt_session_2) {
+		memcpy(&bt_cmd_2000.basic, &basic,
+			sizeof(basic));
+		ret = iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
+			sizeof(bt_cmd_2000), &bt_cmd_2000);
+	} else {
+		memcpy(&bt_cmd_6000.basic, &basic,
+			sizeof(basic));
+		ret = iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
+			sizeof(bt_cmd_6000), &bt_cmd_6000);
+	}
+	if (ret)
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
 
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 3629ee3..03cfb74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2477,7 +2477,7 @@ struct iwl_bt_cmd {
 					IWLAGN_BT_VALID_BT4_TIMES | \
 					IWLAGN_BT_VALID_3W_LUT)
 
-struct iwl6000_bt_cmd {
+struct iwl_basic_bt_cmd {
 	u8 flags;
 	u8 ledtime; /* unused */
 	u8 max_kill;
@@ -2490,6 +2490,10 @@ struct iwl6000_bt_cmd {
 	__le32 bt3_lookup_table[12];
 	__le16 bt4_decision_time; /* unused */
 	__le16 valid;
+};
+
+struct iwl6000_bt_cmd {
+	struct iwl_basic_bt_cmd basic;
 	u8 prio_boost;
 	/*
 	 * set IWLAGN_BT_VALID_BOOST to "1" in "valid" bitmask
@@ -2500,18 +2504,7 @@ struct iwl6000_bt_cmd {
 };
 
 struct iwl2000_bt_cmd {
-	u8 flags;
-	u8 ledtime; /* unused */
-	u8 max_kill;
-	u8 bt3_timer_t7_value;
-	__le32 kill_ack_mask;
-	__le32 kill_cts_mask;
-	u8 bt3_prio_sample_time;
-	u8 bt3_timer_t2_value;
-	__le16 bt4_reaction_time; /* unused */
-	__le32 bt3_lookup_table[12];
-	__le16 bt4_decision_time; /* unused */
-	__le16 valid;
+	struct iwl_basic_bt_cmd basic;
 	__le32 prio_boost;
 	/*
 	 * set IWLAGN_BT_VALID_BOOST to "1" in "valid" bitmask
@@ -4173,6 +4166,9 @@ enum iwl_bt_coex_profile_traffic_load {
  */
 };
 
+#define BT_SESSION_ACTIVITY_1_UART_MSG		0x1
+#define BT_SESSION_ACTIVITY_2_UART_MSG		0x2
+
 /* BT UART message - Share Part (BT -> WiFi) */
 #define BT_UART_MSG_FRAME1MSGTYPE_POS		(0)
 #define BT_UART_MSG_FRAME1MSGTYPE_MSK		\
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e0ec170..909b42d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -339,6 +339,7 @@ struct iwl_bt_params {
 	u8 ampdu_factor;
 	u8 ampdu_density;
 	bool bt_sco_disable;
+	bool bt_session_2;
 };
 /*
  * @use_rts_for_aggregation: use rts/cts protection for HT traffic
-- 
1.7.0.4

