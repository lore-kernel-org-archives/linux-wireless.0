Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56129 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555AbaJ2LvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:19 -0400
Received: by mail-wi0-f171.google.com with SMTP id q5so1434539wiv.4
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:18 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/25] iwlwifi: mvm: BT Coex - move BT_ANTENNA_COUPLING_THRESHOLD to constants
Date: Wed, 29 Oct 2014 13:50:34 +0200
Message-Id: <1414583446-11032-13-git-send-email-egrumbach@gmail.com> (sfid-20141029_131321_821913_A41FEA90)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is were it really needs to be.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 4 +---
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 5 ++---
 drivers/net/wireless/iwlwifi/mvm/constants.h   | 1 +
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index da2ffb7..515f9cb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -72,8 +72,6 @@
 #include "mvm.h"
 #include "iwl-debug.h"
 
-#define BT_ANTENNA_COUPLING_THRESHOLD		(30)
-
 const u32 iwl_bt_ctl_kill_msk[BT_KILL_MSK_MAX] = {
 	[BT_KILL_MSK_DEFAULT] = 0xfffffc00,
 	[BT_KILL_MSK_NEVER] = 0xffffffff,
@@ -605,7 +603,7 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 
 	bt_cmd->max_kill = cpu_to_le32(5);
 	bt_cmd->bt4_antenna_isolation_thr =
-				cpu_to_le32(BT_ANTENNA_COUPLING_THRESHOLD);
+		cpu_to_le32(IWL_MVM_BT_COEX_ANTENNA_COUPLING_THRS);
 	bt_cmd->bt4_tx_tx_delta_freq_thr = cpu_to_le32(15);
 	bt_cmd->bt4_tx_rx_max_freq0 = cpu_to_le32(15);
 	bt_cmd->override_primary_lut = cpu_to_le32(BT_COEX_INVALID_LUT);
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index 8a1d2f3..3f3b8ee 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -102,8 +102,6 @@ static const u8 iwl_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
 
 #undef EVENT_PRIO_ANT
 
-#define BT_ANTENNA_COUPLING_THRESHOLD		(30)
-
 static int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm)
 {
 	if (unlikely(mvm->bt_force_ant_mode != BT_FORCE_ANT_DIS))
@@ -593,7 +591,8 @@ int iwl_send_bt_init_conf_old(struct iwl_mvm *mvm)
 	}
 
 	bt_cmd->max_kill = 5;
-	bt_cmd->bt4_antenna_isolation_thr = BT_ANTENNA_COUPLING_THRESHOLD;
+	bt_cmd->bt4_antenna_isolation_thr =
+		IWL_MVM_BT_COEX_ANTENNA_COUPLING_THRS;
 	bt_cmd->bt4_antenna_isolation = iwlwifi_mod_params.ant_coupling;
 	bt_cmd->bt4_tx_tx_delta_freq_thr = 15;
 	bt_cmd->bt4_tx_rx_max_freq0 = 15;
diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index dfec5b5..f288783 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -96,5 +96,6 @@
 #define IWL_MVM_QUOTA_THRESHOLD			8
 #define IWL_MVM_RS_RSSI_BASED_INIT_RATE         0
 #define IWL_MVM_RS_DISABLE_MIMO			0
+#define IWL_MVM_BT_COEX_ANTENNA_COUPLING_THRS	30
 
 #endif /* __MVM_CONSTANTS_H */
-- 
1.9.1

