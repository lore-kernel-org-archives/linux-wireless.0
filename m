Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18162 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbXHHHi3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:38:29 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 24/28] iwlwifi: Endianity fix for ct kill configuration
Date: Wed,  8 Aug 2007 15:33:41 +0800
Message-Id: <11865584823402-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1186558479530-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
 <11865584631842-git-send-email-yi.zhu@intel.com>
 <11865584661209-git-send-email-yi.zhu@intel.com>
 <11865584683474-git-send-email-yi.zhu@intel.com>
 <1186558470949-git-send-email-yi.zhu@intel.com>
 <11865584733882-git-send-email-yi.zhu@intel.com>
 <11865584754153-git-send-email-yi.zhu@intel.com>
 <11865584771950-git-send-email-yi.zhu@intel.com>
 <1186558479530-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endinianity and style issuse in ct kill host command.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c     |   12 ++++++------
 drivers/net/wireless/iwl-commands.h |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index eca9eed..6b6ab52 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -713,8 +713,9 @@ static void iwl4965_bg_statistics_work(struct work_struct *work)
 void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl_ct_kill_config cmd;
-	u32 R1 = 0, R2 = 0, R3 = 0;
-	u32 temp_th = 0;
+	u32 R1, R2, R3;
+	u32 temp_th;
+	u32 crit_temperature;
 	unsigned long flags;
 	int rc = 0;
 
@@ -735,15 +736,14 @@ void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 
 	temp_th = CELSIUS_TO_KELVIN(TM_CT_KILL_THRESHOLD);
 
-	cmd.critical_temperature_R = ((temp_th * (R3-R1))/CT_LIMIT_CONST) + R2;
+	crit_temperature = ((temp_th * (R3-R1))/CT_LIMIT_CONST) + R2;
+	cmd.critical_temperature_R =  cpu_to_le32(crit_temperature);
 	rc = iwl_send_cmd_pdu(priv,
 			      REPLY_CT_KILL_CONFIG_CMD, sizeof(cmd), &cmd);
 	if (rc)
 		IWL_ERROR("REPLY_CT_KILL_CONFIG_CMD failed\n");
 	else
-		IWL_WARNING("REPLY_CT_KILL_CONFIG_CMD succeeded\n");
-
-	return;
+		IWL_DEBUG_INFO("REPLY_CT_KILL_CONFIG_CMD succeeded\n");
 }
 
 #ifdef CONFIG_IWLWIFI_SENSITIVITY
diff --git a/drivers/net/wireless/iwl-commands.h b/drivers/net/wireless/iwl-commands.h
index 2327ec3..1d2c091 100644
--- a/drivers/net/wireless/iwl-commands.h
+++ b/drivers/net/wireless/iwl-commands.h
@@ -560,9 +560,9 @@ struct iwl_missed_beacon_notif {
 } __attribute__ ((packed));
 
 struct iwl_ct_kill_config {
-	u32   reserved;
-	u32   critical_temperature_M;
-	u32   critical_temperature_R;
+	__le32   reserved;
+	__le32   critical_temperature_M;
+	__le32   critical_temperature_R;
 }  __attribute__ ((packed));
 /*
  * Add/Modify Station Command & Response
-- 
1.5.2
