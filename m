Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031476Ab2CFWnc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:32 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 11/33] iwlwifi: remove shadow_reg_enable from hw_params
Date: Tue,  6 Mar 2012 13:30:46 -0800
Message-Id: <1331069468-11074-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234438_094124_662AB129)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to copy shadow_reg_enable into
hw_params since it is a pure hardware parameter
that will never change, we can access it from
the config directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    2 --
 drivers/net/wireless/iwlwifi/iwl-power.c         |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    2 +-
 6 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 863c27e..f816371 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1127,8 +1127,6 @@ static void iwl_set_hw_params(struct iwl_priv *priv)
 
 	hw_params(priv).num_ampdu_queues =
 		cfg(priv)->base_params->num_of_ampdu_queues;
-	hw_params(priv).shadow_reg_enable =
-		cfg(priv)->base_params->shadow_reg_enable;
 	hw_params(priv).wd_timeout = cfg(priv)->base_params->wd_timeout;
 
 	/* Device-specific setup */
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index d76ff23..f79ff16 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -215,7 +215,7 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 	else
 		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
 
-	if (hw_params(priv).shadow_reg_enable)
+	if (cfg(priv)->base_params->shadow_reg_enable)
 		cmd->flags |= IWL_POWER_SHADOW_REG_ENA;
 	else
 		cmd->flags &= ~IWL_POWER_SHADOW_REG_ENA;
@@ -301,7 +301,7 @@ static void iwl_power_fill_sleep_cmd(struct iwl_priv *priv,
 	if (priv->power_data.bus_pm)
 		cmd->flags |= IWL_POWER_PCI_PM_MSK;
 
-	if (hw_params(priv).shadow_reg_enable)
+	if (cfg(priv)->base_params->shadow_reg_enable)
 		cmd->flags |= IWL_POWER_SHADOW_REG_ENA;
 	else
 		cmd->flags &= ~IWL_POWER_SHADOW_REG_ENA;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 30b942f..a5ab58c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -185,7 +185,6 @@ struct iwl_hw_params {
 	u8  valid_tx_ant;
 	u8  valid_rx_ant;
 	u8  ht40_channel;
-	bool shadow_reg_enable;
 	u16 sku;
 	u32 rx_page_order;
 	u32 ct_kill_threshold;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index e8d3129..911a9f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -141,7 +141,7 @@ void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 	if (q->need_update == 0)
 		goto exit_unlock;
 
-	if (hw_params(trans).shadow_reg_enable) {
+	if (cfg(trans)->base_params->shadow_reg_enable) {
 		/* shadow register enabled */
 		/* Device expects a multiple of 8 */
 		q->write_actual = (q->write & ~0x7);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index ca4ceea..2573f71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -136,7 +136,7 @@ void iwl_txq_update_write_ptr(struct iwl_trans *trans, struct iwl_tx_queue *txq)
 	if (txq->need_update == 0)
 		return;
 
-	if (hw_params(trans).shadow_reg_enable) {
+	if (cfg(trans)->base_params->shadow_reg_enable) {
 		/* shadow register enabled */
 		iwl_write32(trans, HBUS_TARG_WRPTR,
 			    txq->q.write_ptr | (txq_id << 8));
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 4a2d4b5..44050fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -828,7 +828,7 @@ static int iwl_nic_init(struct iwl_trans *trans)
 	if (iwl_tx_init(trans))
 		return -ENOMEM;
 
-	if (hw_params(trans).shadow_reg_enable) {
+	if (cfg(trans)->base_params->shadow_reg_enable) {
 		/* enable shadow regs in HW */
 		iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL,
 			0x800FFFFF);
-- 
1.7.0.4

