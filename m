Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966117Ab2DLV6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/24] iwlwifi: more generic name for bluetooth command
Date: Thu, 12 Apr 2012 14:54:20 -0700
Message-Id: <1334267661-14654-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235826_169932_9448AAB2)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of hardcode 6000 and 2000, use more generic name

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   30 ++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 +-
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index b5ee99e..da023fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -307,24 +307,30 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 		.bt3_prio_sample_time = IWLAGN_BT3_PRIO_SAMPLE_DEFAULT,
 		.bt3_timer_t2_value = IWLAGN_BT3_T2_DEFAULT,
 	};
-	struct iwl6000_bt_cmd bt_cmd_6000;
-	struct iwl2000_bt_cmd bt_cmd_2000;
+	struct iwl_bt_cmd_v1 bt_cmd_v1;
+	struct iwl_bt_cmd_v2 bt_cmd_v2;
 	int ret;
 
 	BUILD_BUG_ON(sizeof(iwlagn_def_3w_lookup) !=
 			sizeof(basic.bt3_lookup_table));
 
 	if (cfg(priv)->bt_params) {
+		/*
+		 * newer generation of devices (2000 series and newer)
+		 * use the version 2 of the bt command
+		 * we need to make sure sending the host command
+		 * with correct data structure to avoid uCode assert
+		 */
 		if (cfg(priv)->bt_params->bt_session_2) {
-			bt_cmd_2000.prio_boost = cpu_to_le32(
+			bt_cmd_v2.prio_boost = cpu_to_le32(
 				cfg(priv)->bt_params->bt_prio_boost);
-			bt_cmd_2000.tx_prio_boost = 0;
-			bt_cmd_2000.rx_prio_boost = 0;
+			bt_cmd_v2.tx_prio_boost = 0;
+			bt_cmd_v2.rx_prio_boost = 0;
 		} else {
-			bt_cmd_6000.prio_boost =
+			bt_cmd_v1.prio_boost =
 				cfg(priv)->bt_params->bt_prio_boost;
-			bt_cmd_6000.tx_prio_boost = 0;
-			bt_cmd_6000.rx_prio_boost = 0;
+			bt_cmd_v1.tx_prio_boost = 0;
+			bt_cmd_v1.rx_prio_boost = 0;
 		}
 	} else {
 		IWL_ERR(priv, "failed to construct BT Coex Config\n");
@@ -371,15 +377,15 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 		       "full concurrency" : "3-wire");
 
 	if (cfg(priv)->bt_params->bt_session_2) {
-		memcpy(&bt_cmd_2000.basic, &basic,
+		memcpy(&bt_cmd_v2.basic, &basic,
 			sizeof(basic));
 		ret = iwl_dvm_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-			CMD_SYNC, sizeof(bt_cmd_2000), &bt_cmd_2000);
+			CMD_SYNC, sizeof(bt_cmd_v2), &bt_cmd_v2);
 	} else {
-		memcpy(&bt_cmd_6000.basic, &basic,
+		memcpy(&bt_cmd_v1.basic, &basic,
 			sizeof(basic));
 		ret = iwl_dvm_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-			CMD_SYNC, sizeof(bt_cmd_6000), &bt_cmd_6000);
+			CMD_SYNC, sizeof(bt_cmd_v1), &bt_cmd_v1);
 	}
 	if (ret)
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 9ed73e5..296347a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1918,7 +1918,7 @@ struct iwl_basic_bt_cmd {
 	__le16 valid;
 };
 
-struct iwl6000_bt_cmd {
+struct iwl_bt_cmd_v1 {
 	struct iwl_basic_bt_cmd basic;
 	u8 prio_boost;
 	/*
@@ -1929,7 +1929,7 @@ struct iwl6000_bt_cmd {
 	__le16 rx_prio_boost;	/* SW boost of WiFi rx priority */
 };
 
-struct iwl2000_bt_cmd {
+struct iwl_bt_cmd_v2 {
 	struct iwl_basic_bt_cmd basic;
 	__le32 prio_boost;
 	/*
-- 
1.7.0.4

