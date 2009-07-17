Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12884 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964888AbZGQQae (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:34 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/14] iwlwifi: inform user about rfkill state changes
Date: Fri, 17 Jul 2009 09:30:26 -0700
Message-Id: <1247848227-24031-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247848227-24031-13-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-3-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-4-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-5-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-6-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-7-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-8-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-9-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-10-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-11-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-12-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-13-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

rfkill state changes are mostly available through debug messages.
These are significant enough to always make user aware of so
we turn them into warnings.

Also insert a missing newline in some rfkill related debug message.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b7ac4ee..44c7f23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -964,7 +964,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 			hw_rf_kill = 1;
 
-		IWL_DEBUG_RF_KILL(priv, "RF_KILL bit toggled to %s.\n",
+		IWL_WARN(priv, "RF_KILL bit toggled to %s.\n",
 				hw_rf_kill ? "disable radio" : "enable radio");
 
 		priv->isr_stats.rfkill++;
@@ -1137,7 +1137,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 			hw_rf_kill = 1;
 
-		IWL_DEBUG_RF_KILL(priv, "RF_KILL bit toggled to %s.\n",
+		IWL_WARN(priv, "RF_KILL bit toggled to %s.\n",
 				hw_rf_kill ? "disable radio" : "enable radio");
 
 		priv->isr_stats.rfkill++;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index ef7e6bd..0912987 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -940,7 +940,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	       !(cmd->meta.flags & CMD_SIZE_HUGE));
 
 	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_INFO(priv, "Not sending command - RF KILL");
+		IWL_DEBUG_INFO(priv, "Not sending command - RF KILL\n");
 		return -EIO;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8891d6e..2cc7e30 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -926,7 +926,7 @@ static void iwl3945_rx_card_state_notif(struct iwl_priv *priv,
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = priv->status;
 
-	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s\n",
+	IWL_WARN(priv, "Card state received: HW:%s SW:%s\n",
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
 			  (flags & SW_CARD_DISABLED) ? "Kill" : "On");
 
-- 
1.5.6.3

