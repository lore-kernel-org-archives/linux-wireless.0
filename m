Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:64003 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab2ECV2n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 17:28:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/6] iwlwifi: add documentation for bt reduced tx power
Date: Thu,  3 May 2012 14:22:02 -0700
Message-Id: <1336080126-22606-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120503_232854_628176_947DDBE8)
In-Reply-To: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change-Id: Ia6294d651dcffdcaf8b62e67bcef52bd8c158dea
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Reviewed-on: http://git-mwg.jer.intel.com/gerrit/1947
Tested-by: Jenkins
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   22 +++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    6 ++++++
 2 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 9d88565..cb4b31f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -274,9 +274,20 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 		return;
 	}
 
+	/*
+	 * Possible situations when BT needs to take over for receive,
+	 * at the same time where STA needs to response to AP's frame(s),
+	 * reduce the tx power of the required response frames, by that,
+	 * allow the concurrent BT receive & WiFi transmit
+	 * (BT - ANT A, WiFi -ANT B), without interference to one another
+	 *
+	 * Reduced tx power apply to control frames only (ACK/Back/CTS)
+	 * when indicated by the BT config command
+	 */
 	basic.kill_ack_mask = priv->kill_ack_mask;
 	basic.kill_cts_mask = priv->kill_cts_mask;
-	basic.reduce_txpower = priv->reduced_txpower;
+	if (priv->reduced_txpower)
+		basic.reduce_txpower = IWLAGN_BT_REDUCED_TX_PWR;
 	basic.valid = priv->bt_valid;
 
 	/*
@@ -590,6 +601,15 @@ static bool iwlagn_set_kill_msk(struct iwl_priv *priv,
 	return need_update;
 }
 
+/*
+ * Upon RSSI changes, sends a bt config command with following changes
+ *  1. enable/disable "reduced control frames tx power
+ *  2. update the "kill)ack_mask" and "kill_cts_mask"
+ *
+ * If "reduced tx power" is enabled, uCode shall
+ *  1. ACK/Back/CTS rate shall reduced to 6Mbps
+ *  2. not use duplciate 20/40MHz mode
+ */
 static bool iwlagn_fill_txpower_mode(struct iwl_priv *priv,
 				struct iwl_bt_uart_msg *uart_msg)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 83a6930..2813a0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1910,6 +1910,8 @@ enum iwl_bt_kill_idx {
 					IWLAGN_BT_VALID_REDUCED_TX_PWR | \
 					IWLAGN_BT_VALID_3W_LUT)
 
+#define IWLAGN_BT_REDUCED_TX_PWR	BIT(0)
+
 #define IWLAGN_BT_DECISION_LUT_SIZE	12
 
 struct iwl_basic_bt_cmd {
@@ -1923,6 +1925,10 @@ struct iwl_basic_bt_cmd {
 	u8 bt3_timer_t2_value;
 	__le16 bt4_reaction_time; /* unused */
 	__le32 bt3_lookup_table[IWLAGN_BT_DECISION_LUT_SIZE];
+	/*
+	 * bit 0: use reduced tx power for control frame
+	 * bit 1 - 7: reserved
+	 */
 	u8 reduce_txpower;
 	u8 reserved;
 	__le16 valid;
-- 
1.7.0.4

