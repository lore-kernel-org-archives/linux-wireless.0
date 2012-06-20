Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab2FTHiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/12] iwlwifi: disable early power Off reset for all NICs
Date: Wed, 20 Jun 2012 09:38:10 +0200
Message-Id: <1340177894-12992-9-git-send-email-johannes@sipsolutions.net> (sfid-20120620_093828_621295_3A1E0280)
In-Reply-To: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
References: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This feature needs to be disabled for all NICs.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/devices.c |   13 -------------
 drivers/net/wireless/iwlwifi/dvm/main.c    |   13 ++++++++++++-
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
index 0521a6b..349c205d5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -250,17 +250,6 @@ struct iwl_lib_ops iwl2030_lib = {
  */
 
 /* NIC configuration for 5000 series */
-static void iwl5000_nic_config(struct iwl_priv *priv)
-{
-	/* W/A : NIC is stuck in a reset state after Early PCIe power off
-	 * (PCIe power is lost before PERST# is asserted),
-	 * causing ME FW to lose ownership and not being able to obtain it back.
-	 */
-	iwl_set_bits_mask_prph(priv->trans, APMG_PS_CTRL_REG,
-				APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
-				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
-}
-
 static const struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 	.min_nrg_cck = 100,
 	.auto_corr_min_ofdm = 90,
@@ -433,14 +422,12 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
 	.set_channel_switch = iwl5000_hw_channel_switch,
-	.nic_config = iwl5000_nic_config,
 	.temperature = iwlagn_temperature,
 };
 
 struct iwl_lib_ops iwl5150_lib = {
 	.set_hw_params = iwl5150_hw_set_hw_params,
 	.set_channel_switch = iwl5000_hw_channel_switch,
-	.nic_config = iwl5000_nic_config,
 	.temperature = iwl5150_temperature,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index bba3edf..c642c21 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -51,11 +51,13 @@
 #include "iwl-op-mode.h"
 #include "iwl-drv.h"
 #include "iwl-modparams.h"
+#include "iwl-prph.h"
 
 #include "dev.h"
 #include "calib.h"
 #include "agn.h"
 
+
 /******************************************************************************
  *
  * module boiler plate
@@ -2076,7 +2078,16 @@ static void iwl_nic_config(struct iwl_op_mode *op_mode)
 		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
-	priv->lib->nic_config(priv);
+	/* W/A : NIC is stuck in a reset state after Early PCIe power off
+	 * (PCIe power is lost before PERST# is asserted),
+	 * causing ME FW to lose ownership and not being able to obtain it back.
+	 */
+	iwl_set_bits_mask_prph(priv->trans, APMG_PS_CTRL_REG,
+			       APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
+			       ~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
+
+	if (priv->lib->nic_config)
+		priv->lib->nic_config(priv);
 }
 
 static void iwl_wimax_active(struct iwl_op_mode *op_mode)
-- 
1.7.10

