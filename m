Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30285 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab2B0XTH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:07 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/24] iwlwifi: remove a few dereferences to iwl_priv from the tansport
Date: Mon, 27 Feb 2012 14:07:38 -0800
Message-Id: <1330380468-17674-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001934_287850_6512C47A)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The transport should not dereference the iwl_priv pointer. Remove a
few of those.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 2072bc2..60e70b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -671,9 +671,8 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
  */
 static void iwl_irq_handle_error(struct iwl_trans *trans)
 {
-	struct iwl_priv *priv = priv(trans);
 	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
-	if (cfg(priv)->internal_wimax_coex &&
+	if (cfg(trans)->internal_wimax_coex &&
 	    (!(iwl_read_prph(trans, APMG_CLK_CTRL_REG) &
 			APMS_CLK_VAL_MRB_FUNC_MODE) ||
 	     (iwl_read_prph(trans, APMG_PS_CTRL_REG) &
@@ -684,13 +683,13 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 		 */
 		clear_bit(STATUS_READY, &trans->shrd->status);
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
-		wake_up(&priv->shrd->wait_command_queue);
+		wake_up(&trans->shrd->wait_command_queue);
 		IWL_ERR(trans, "RF is used by WiMAX\n");
 		return;
 	}
 
 	IWL_ERR(trans, "Loaded firmware version: %s\n",
-		priv->hw->wiphy->fw_version);
+		nic(trans)->fw.fw_version);
 
 	iwl_dump_nic_error_log(trans);
 	iwl_dump_csr(trans);
-- 
1.7.0.4

