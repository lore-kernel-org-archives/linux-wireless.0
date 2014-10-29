Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47039 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555AbaJ2LvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:24 -0400
Received: by mail-wg0-f46.google.com with SMTP id x13so1680872wgg.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:23 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/25] iwlwifi: mvm: BT Coex - make the multiprio lut a constant
Date: Wed, 29 Oct 2014 13:50:37 +0200
Message-Id: <1414583446-11032-16-git-send-email-egrumbach@gmail.com> (sfid-20141029_131320_565451_52336D23)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This makes it easier to tune the values during the testing.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 9 ++-------
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 9 ++-------
 drivers/net/wireless/iwlwifi/mvm/constants.h   | 2 ++
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 515f9cb..508c813 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -300,11 +300,6 @@ static const __le64 iwl_ci_mask[][3] = {
 	},
 };
 
-static const __le32 iwl_bt_mprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE] = {
-	cpu_to_le32(0x2e402280),
-	cpu_to_le32(0x7711a751),
-};
-
 struct corunning_block_luts {
 	u8 range;
 	__le32 lut20[BT_COEX_CORUN_LUT_SIZE];
@@ -636,8 +631,8 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 
 	memcpy(&bt_cmd->mplut_prio_boost, iwl_bt_prio_boost,
 	       sizeof(iwl_bt_prio_boost));
-	memcpy(&bt_cmd->multiprio_lut, iwl_bt_mprio_lut,
-	       sizeof(iwl_bt_mprio_lut));
+	bt_cmd->multiprio_lut[0] = cpu_to_le32(IWL_MVM_BT_COEX_MPLUT_REG0);
+	bt_cmd->multiprio_lut[1] = cpu_to_le32(IWL_MVM_BT_COEX_MPLUT_REG1);
 
 send_cmd:
 	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index 3f3b8ee..b571e1b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -288,11 +288,6 @@ static const __le64 iwl_ci_mask[][3] = {
 	},
 };
 
-static const __le32 iwl_bt_mprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE] = {
-	cpu_to_le32(0x2e402280),
-	cpu_to_le32(0x7711a751),
-};
-
 struct corunning_block_luts {
 	u8 range;
 	__le32 lut20[BT_COEX_CORUN_LUT_SIZE];
@@ -648,8 +643,8 @@ int iwl_send_bt_init_conf_old(struct iwl_mvm *mvm)
 
 	memcpy(&bt_cmd->bt_prio_boost, iwl_bt_prio_boost,
 	       sizeof(iwl_bt_prio_boost));
-	memcpy(&bt_cmd->bt4_multiprio_lut, iwl_bt_mprio_lut,
-	       sizeof(iwl_bt_mprio_lut));
+	bt_cmd->bt4_multiprio_lut[0] = cpu_to_le32(IWL_MVM_BT_COEX_MPLUT_REG0);
+	bt_cmd->bt4_multiprio_lut[1] = cpu_to_le32(IWL_MVM_BT_COEX_MPLUT_REG1);
 
 send_cmd:
 	memset(&mvm->last_bt_notif_old, 0, sizeof(mvm->last_bt_notif_old));
diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index a2b473d..5c1ea80 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -92,6 +92,8 @@
 #define IWL_MVM_BT_COEX_SYNC2SCO		1
 #define IWL_MVM_BT_COEX_CORUNNING		0
 #define IWL_MVM_BT_COEX_MPLUT			1
+#define IWL_MVM_BT_COEX_MPLUT_REG0		0x2e402280
+#define IWL_MVM_BT_COEX_MPLUT_REG1		0x7711a751
 #define IWL_MVM_BT_COEX_ANTENNA_COUPLING_THRS	30
 #define IWL_MVM_FW_MCAST_FILTER_PASS_ALL	0
 #define IWL_MVM_FW_BCAST_FILTER_PASS_ALL	0
-- 
1.9.1

