Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22045 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809Ab0JFPXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 11:23:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/6] iwlagn: rename iwl5000_tx_power_dbm_cmd
Date: Wed,  6 Oct 2010 08:23:10 -0700
Message-Id: <1286378593-7509-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl5000_tx_power_dbm_cmd really should be iwlagn_tx_power_dbm_cmd,
so rename it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 29ed604..48c48f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -491,7 +491,7 @@ int iwlagn_hw_valid_rtc_data_addr(u32 addr)
 
 int iwlagn_send_tx_power(struct iwl_priv *priv)
 {
-	struct iwl5000_tx_power_dbm_cmd tx_power_cmd;
+	struct iwlagn_tx_power_dbm_cmd tx_power_cmd;
 	u8 tx_ant_cfg_cmd;
 
 	/* half dBm need to multiply */
@@ -512,8 +512,8 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 		 */
 		tx_power_cmd.global_lmt = priv->tx_power_lmt_in_half_dbm;
 	}
-	tx_power_cmd.flags = IWL50_TX_POWER_NO_CLOSED;
-	tx_power_cmd.srv_chan_lmt = IWL50_TX_POWER_AUTO;
+	tx_power_cmd.flags = IWLAGN_TX_POWER_NO_CLOSED;
+	tx_power_cmd.srv_chan_lmt = IWLAGN_TX_POWER_AUTO;
 
 	if (IWL_UCODE_API(priv->ucode_ver) == 1)
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD_V1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 27350ee..16dda2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -420,12 +420,12 @@ struct iwl4965_tx_power_db {
 
 /**
  * Command REPLY_TX_POWER_DBM_CMD = 0x98
- * struct iwl5000_tx_power_dbm_cmd
+ * struct iwlagn_tx_power_dbm_cmd
  */
-#define IWL50_TX_POWER_AUTO 0x7f
-#define IWL50_TX_POWER_NO_CLOSED (0x1 << 6)
+#define IWLAGN_TX_POWER_AUTO 0x7f
+#define IWLAGN_TX_POWER_NO_CLOSED (0x1 << 6)
 
-struct iwl5000_tx_power_dbm_cmd {
+struct iwlagn_tx_power_dbm_cmd {
 	s8 global_lmt; /*in half-dBm (e.g. 30 = 15 dBm) */
 	u8 flags;
 	s8 srv_chan_lmt; /*in half-dBm (e.g. 30 = 15 dBm) */
-- 
1.7.0.4

