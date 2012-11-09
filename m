Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab2KIUHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:07:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/13] iwlwifi: check the SCD conf from ALIVE response
Date: Fri,  9 Nov 2012 21:08:06 +0100
Message-Id: <1352491692-28994-8-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210754_245203_E1279889)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The ALIVE response of new fw inclues the base address of
the SCD in SRAM. Until we read it from a prph register,
which was set by the fw. Since the fw might well stop
updating the prph register, add a WARN when there is an
inconsitency between the ALIVE response and the register
to catch any change in the behavior.

Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/ucode.c  |  2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h  |  9 +++++----
 drivers/net/wireless/iwlwifi/pcie/trans.c | 10 +++++++---
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index 2cb1efb..95e6d33 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -254,7 +254,7 @@ static int iwl_alive_notify(struct iwl_priv *priv)
 	int ret;
 	int i;
 
-	iwl_trans_fw_alive(priv->trans);
+	iwl_trans_fw_alive(priv->trans, 0);
 
 	if (priv->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN &&
 	    priv->eeprom_data->sku & EEPROM_SKU_CAP_IPAN_ENABLE) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index b065d48..e378ea6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -355,7 +355,8 @@ struct iwl_trans;
  * @start_fw: allocates and inits all the resources for the transport
  *	layer. Also kick a fw image.
  *	May sleep
- * @fw_alive: called when the fw sends alive notification
+ * @fw_alive: called when the fw sends alive notification. If the fw provides
+ *	the SCD base address in SRAM, then provide it here, or 0 otherwise.
  *	May sleep
  * @stop_device:stops the whole device (embedded CPU put to reset)
  *	May sleep
@@ -394,7 +395,7 @@ struct iwl_trans_ops {
 	int (*start_hw)(struct iwl_trans *iwl_trans);
 	void (*stop_hw)(struct iwl_trans *iwl_trans, bool op_mode_leaving);
 	int (*start_fw)(struct iwl_trans *trans, const struct fw_img *fw);
-	void (*fw_alive)(struct iwl_trans *trans);
+	void (*fw_alive)(struct iwl_trans *trans, u32 scd_addr);
 	void (*stop_device)(struct iwl_trans *trans);
 
 	void (*wowlan_suspend)(struct iwl_trans *trans);
@@ -514,13 +515,13 @@ static inline void iwl_trans_stop_hw(struct iwl_trans *trans,
 	trans->state = IWL_TRANS_NO_FW;
 }
 
-static inline void iwl_trans_fw_alive(struct iwl_trans *trans)
+static inline void iwl_trans_fw_alive(struct iwl_trans *trans, u32 scd_addr)
 {
 	might_sleep();
 
 	trans->state = IWL_TRANS_FW_ALIVE;
 
-	trans->ops->fw_alive(trans);
+	trans->ops->fw_alive(trans, scd_addr);
 }
 
 static inline int iwl_trans_start_fw(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 288d229..0703da8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1079,7 +1079,7 @@ static void iwl_trans_txq_set_sched(struct iwl_trans *trans, u32 mask)
 	iwl_write_prph(trans, SCD_TXFACT, mask);
 }
 
-static void iwl_tx_start(struct iwl_trans *trans)
+static void iwl_tx_start(struct iwl_trans *trans, u32 scd_base_addr)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 a;
@@ -1092,6 +1092,10 @@ static void iwl_tx_start(struct iwl_trans *trans)
 
 	trans_pcie->scd_base_addr =
 		iwl_read_prph(trans, SCD_SRAM_BASE_ADDR);
+
+	WARN_ON(scd_base_addr != 0 &&
+		scd_base_addr != trans_pcie->scd_base_addr);
+
 	a = trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_LOWER_BOUND;
 	/* reset conext data memory */
 	for (; a < trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_UPPER_BOUND;
@@ -1137,10 +1141,10 @@ static void iwl_tx_start(struct iwl_trans *trans)
 			    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 }
 
-static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans)
+static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans, u32 scd_addr)
 {
 	iwl_reset_ict(trans);
-	iwl_tx_start(trans);
+	iwl_tx_start(trans, scd_addr);
 }
 
 /**
-- 
1.8.0

