Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37810 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212Ab1EFS2n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 14:28:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/7] iwlagn: remove get_hcmd_size indirection
Date: Fri,  6 May 2011 11:04:35 -0700
Message-Id: <1304705080-29349-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110506_202851_869042_9180DE74)
In-Reply-To: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need for this, all commands are the right size.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    7 -------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    1 -
 3 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 49dd03f..b12c72d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -54,12 +54,6 @@ int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 	}
 }
 
-/* Currently this is the superset of everything */
-static u16 iwlagn_get_hcmd_size(u8 cmd_id, u16 len)
-{
-	return len;
-}
-
 static u16 iwlagn_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 {
 	u16 size = (u16)sizeof(struct iwl_addsta_cmd);
@@ -332,7 +326,6 @@ struct iwl_hcmd_ops iwlagn_bt_hcmd = {
 };
 
 struct iwl_hcmd_utils_ops iwlagn_hcmd_utils = {
-	.get_hcmd_size = iwlagn_get_hcmd_size,
 	.build_addsta_hcmd = iwlagn_build_addsta_hcmd,
 	.gain_computation = iwlagn_gain_computation,
 	.chain_noise_reset = iwlagn_chain_noise_reset,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index dec9820..9d7e36d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -99,7 +99,6 @@ struct iwl_hcmd_ops {
 };
 
 struct iwl_hcmd_utils_ops {
-	u16 (*get_hcmd_size)(u8 cmd_id, u16 len);
 	u16 (*build_addsta_hcmd)(const struct iwl_addsta_cmd *cmd, u8 *data);
 	void (*gain_computation)(struct iwl_priv *priv,
 			u32 *average_noise,
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 52b1b66..608d7a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -447,7 +447,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	u16 fix_size;
 	bool is_ct_kill = false;
 
-	cmd->len = priv->cfg->ops->utils->get_hcmd_size(cmd->id, cmd->len);
 	fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
 
 	/*
-- 
1.7.0.4

