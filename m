Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab0KWTEa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:04:30 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/5] iwlwifi: power management checking for shadow register
Date: Tue, 23 Nov 2010 10:58:55 -0800
Message-Id: <1290538736-10816-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If shadow register is enable, modify the power management
command to inform uCode

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 306c852..21c5e6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -163,6 +163,11 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 	else
 		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
 
+	if (priv->cfg->base_params->shadow_reg_enable)
+		cmd->flags |= IWL_POWER_SHADOW_REG_ENA;
+	else
+		cmd->flags &= ~IWL_POWER_SHADOW_REG_ENA;
+
 	if (priv->cfg->bt_params &&
 	    priv->cfg->bt_params->advanced_bt_coexist) {
 		if (!priv->cfg->bt_params->bt_sco_disable)
@@ -245,6 +250,11 @@ static void iwl_power_fill_sleep_cmd(struct iwl_priv *priv,
 	if (priv->power_data.pci_pm)
 		cmd->flags |= IWL_POWER_PCI_PM_MSK;
 
+	if (priv->cfg->base_params->shadow_reg_enable)
+		cmd->flags |= IWL_POWER_SHADOW_REG_ENA;
+	else
+		cmd->flags &= ~IWL_POWER_SHADOW_REG_ENA;
+
 	if (priv->cfg->bt_params &&
 	    priv->cfg->bt_params->advanced_bt_coexist) {
 		if (!priv->cfg->bt_params->bt_sco_disable)
-- 
1.7.0.4

