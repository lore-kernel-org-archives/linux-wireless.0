Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761959AbZLJWhW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 17:37:22 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/7] iwlwifi: log CT_CARD_DISABLED flag
Date: Thu, 10 Dec 2009 14:37:24 -0800
Message-Id: <1260484647-5114-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
References: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Change name from RF_CARD_DISABLED to CT_CARD_DISABLED to match the
indication from uCode, also log the debug message when the condition
detected in iwl_rx_card_state_notif()

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   12 +++++++-----
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 715db21..36704b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -689,12 +689,14 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = priv->status;
 
-	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s\n",
+	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s CT:%s\n",
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
-			  (flags & SW_CARD_DISABLED) ? "Kill" : "On");
+			  (flags & SW_CARD_DISABLED) ? "Kill" : "On",
+			  (flags & CT_CARD_DISABLED) ?
+			  "Reached" : "Not reached");
 
 	if (flags & (SW_CARD_DISABLED | HW_CARD_DISABLED |
-		     RF_CARD_DISABLED)) {
+		     CT_CARD_DISABLED)) {
 
 		iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
@@ -708,10 +710,10 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 			iwl_write_direct32(priv, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 		}
-		if (flags & RF_CARD_DISABLED)
+		if (flags & CT_CARD_DISABLED)
 			iwl_tt_enter_ct_kill(priv);
 	}
-	if (!(flags & RF_CARD_DISABLED))
+	if (!(flags & CT_CARD_DISABLED))
 		iwl_tt_exit_ct_kill(priv);
 
 	if (flags & HW_CARD_DISABLED)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e915075..28f3800 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2510,7 +2510,7 @@ struct iwl_card_state_notif {
 
 #define HW_CARD_DISABLED   0x01
 #define SW_CARD_DISABLED   0x02
-#define RF_CARD_DISABLED   0x04
+#define CT_CARD_DISABLED   0x04
 #define RXON_CARD_DISABLED 0x10
 
 struct iwl_ct_kill_config {
-- 
1.5.6.3

