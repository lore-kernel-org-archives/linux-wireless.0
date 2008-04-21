Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22816 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbYDUWmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 18:42:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 08/11] iwlwifi: CT-Kill configuration fix
Date: Mon, 21 Apr 2008 15:41:58 -0700
Message-Id: <1208817721-11333-9-git-send-email-reinette.chatre@intel.com> (sfid-20080422_004343_432727_D4C0B144)
In-Reply-To: <1208817721-11333-8-git-send-email-reinette.chatre@intel.com>
References: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-2-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-3-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-4-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-5-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-6-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-7-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes the configuration of CT-Kill.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   26 +++++---------------------
 1 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9b3a745..91cc03f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -969,15 +969,9 @@ static void iwl4965_bg_statistics_periodic(unsigned long data)
 	iwl_send_statistics_request(priv, CMD_ASYNC);
 }
 
-#define CT_LIMIT_CONST		259
-#define TM_CT_KILL_THRESHOLD	110
-
 void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl4965_ct_kill_config cmd;
-	u32 R1, R2, R3;
-	u32 temp_th;
-	u32 crit_temperature;
 	unsigned long flags;
 	int ret = 0;
 
@@ -986,27 +980,17 @@ void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (priv->statistics.flag & STATISTICS_REPLY_FLG_FAT_MODE_MSK) {
-		R1 = (s32)le32_to_cpu(priv->card_alive_init.therm_r1[1]);
-		R2 = (s32)le32_to_cpu(priv->card_alive_init.therm_r2[1]);
-		R3 = (s32)le32_to_cpu(priv->card_alive_init.therm_r3[1]);
-	} else {
-		R1 = (s32)le32_to_cpu(priv->card_alive_init.therm_r1[0]);
-		R2 = (s32)le32_to_cpu(priv->card_alive_init.therm_r2[0]);
-		R3 = (s32)le32_to_cpu(priv->card_alive_init.therm_r3[0]);
-	}
-
-	temp_th = CELSIUS_TO_KELVIN(TM_CT_KILL_THRESHOLD);
-
-	crit_temperature = ((temp_th * (R3-R1))/CT_LIMIT_CONST) + R2;
 	cmd.critical_temperature_R =
-			cpu_to_le32(priv->hw_params.ct_kill_threshold);
+		cpu_to_le32(priv->hw_params.ct_kill_threshold);
+
 	ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
 			       sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERROR("REPLY_CT_KILL_CONFIG_CMD failed\n");
 	else
-		IWL_DEBUG_INFO("REPLY_CT_KILL_CONFIG_CMD succeeded\n");
+		IWL_DEBUG_INFO("REPLY_CT_KILL_CONFIG_CMD succeeded, "
+			"critical temperature is %d\n",
+			cmd.critical_temperature_R);
 }
 
 #ifdef CONFIG_IWL4965_RUN_TIME_CALIB
-- 
1.5.3.4

