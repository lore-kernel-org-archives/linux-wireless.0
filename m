Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61849 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaBCU7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:41 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so3859115eei.7
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:40 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 53/62] iwlwifi: mvm: BT Coex - fix SYNC2SCO flags
Date: Mon,  3 Feb 2014 22:57:59 +0200
Message-Id: <1391461088-8082-53-git-send-email-egrumbach@gmail.com> (sfid-20140203_220006_154422_F77B24F5)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The Sync to SCO is a feature that allows to synchronize
between the WiFi traffic and the expectable BT traffic
when SCO profile is active.
We need to set the validity bit in the command in the init
flow, and set / clear the enablement bit if we want to
enabled / disable the feature.

While at it, clean up the flags that are not used in the
API.

This feature needs to be enabled / disabled easily, so
export its enablement to constants.h.

Reviewed-by: Eyal Zolotov <eyal.zolotov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c        |    4 +++-
 drivers/net/wireless/iwlwifi/mvm/constants.h      |    1 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h |   17 ++---------------
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index 9649a43..38a54a3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -378,7 +378,6 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 
 	flags = iwlwifi_mod_params.bt_coex_active ?
 			BT_COEX_NW : BT_COEX_DISABLE;
-	flags |= BT_CH_PRIMARY_EN | BT_CH_SECONDARY_EN | BT_SYNC_2_BT_DISABLE;
 	bt_cmd->flags = cpu_to_le32(flags);
 
 	bt_cmd->valid_bit_msk = cpu_to_le32(BT_VALID_ENABLE |
@@ -399,6 +398,9 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 					    BT_VALID_TXRX_MAX_FREQ_0 |
 					    BT_VALID_SYNC_TO_SCO);
 
+	if (IWL_MVM_BT_COEX_SYNC2SCO)
+		bt_cmd->flags |= cpu_to_le32(BT_COEX_SYNC2SCO);
+
 	if (mvm->cfg->bt_shared_single_ant)
 		memcpy(&bt_cmd->decision_lut, iwl_single_shared_ant,
 		       sizeof(iwl_single_shared_ant));
diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index f3b96e4..2d133b1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -81,5 +81,6 @@
 #define IWL_MVM_LOWLAT_QUOTA_MIN_PERCENT	64
 #define IWL_MVM_LOWLAT_SINGLE_BINDING_MAXDUR	24 /* TU */
 #define IWL_MVM_LOWLAT_DUAL_BINDING_MAXDUR	24 /* TU */
+#define IWL_MVM_BT_COEX_SYNC2SCO		1
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
index 1b4e54d..20b723d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
@@ -70,37 +70,24 @@
 
 /**
  * enum iwl_bt_coex_flags - flags for BT_COEX command
- * @BT_CH_PRIMARY_EN:
- * @BT_CH_SECONDARY_EN:
- * @BT_NOTIF_COEX_OFF:
  * @BT_COEX_MODE_POS:
  * @BT_COEX_MODE_MSK:
  * @BT_COEX_DISABLE:
  * @BT_COEX_2W:
  * @BT_COEX_3W:
  * @BT_COEX_NW:
- * @BT_USE_DEFAULTS:
- * @BT_SYNC_2_BT_DISABLE:
- * @BT_COEX_CORUNNING_TBL_EN:
+ * @BT_COEX_SYNC2SCO:
  *
  * The COEX_MODE must be set for each command. Even if it is not changed.
  */
 enum iwl_bt_coex_flags {
-	BT_CH_PRIMARY_EN		= BIT(0),
-	BT_CH_SECONDARY_EN		= BIT(1),
-	BT_NOTIF_COEX_OFF		= BIT(2),
 	BT_COEX_MODE_POS		= 3,
 	BT_COEX_MODE_MSK		= BITS(3) << BT_COEX_MODE_POS,
 	BT_COEX_DISABLE			= 0x0 << BT_COEX_MODE_POS,
 	BT_COEX_2W			= 0x1 << BT_COEX_MODE_POS,
 	BT_COEX_3W			= 0x2 << BT_COEX_MODE_POS,
 	BT_COEX_NW			= 0x3 << BT_COEX_MODE_POS,
-	BT_USE_DEFAULTS			= BIT(6),
-	BT_SYNC_2_BT_DISABLE		= BIT(7),
-	BT_COEX_CORUNNING_TBL_EN	= BIT(8),
-	BT_COEX_MPLUT_TBL_EN		= BIT(9),
-	/* Bit 10 is reserved */
-	BT_COEX_WF_PRIO_BOOST_CHECK_EN	= BIT(11),
+	BT_COEX_SYNC2SCO		= BIT(7),
 };
 
 /*
-- 
1.7.9.5

