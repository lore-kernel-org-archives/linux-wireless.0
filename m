Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:57849 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252AbaCROqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:33 -0400
Received: by mail-ee0-f53.google.com with SMTP id b57so4832430eek.12
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:32 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/35] iwlwifi: mvm: configure protocol offloading on D0i3
Date: Tue, 18 Mar 2014 16:45:30 +0200
Message-Id: <1395153939-23897-26-git-send-email-egrumbach@gmail.com> (sfid-20140318_154658_926655_510692CF)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Enable protocol offloading (arp and NS) on D0i3.

The offloading allows the fw answer NS and arp requests
without waking up the host.

Since protocol offloading is saved between D0i3
entries, we have to explicitly disable it in
case we don't want it.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c         |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |  5 ++++-
 drivers/net/wireless/iwlwifi/mvm/offloading.c | 13 +++++++------
 drivers/net/wireless/iwlwifi/mvm/ops.c        |  1 +
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 02fb950..e56f5a0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1031,7 +1031,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	if (ret)
 		goto out;
 
-	ret = iwl_mvm_send_proto_offload(mvm, vif);
+	ret = iwl_mvm_send_proto_offload(mvm, vif, false, CMD_SYNC);
 	if (ret)
 		goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d4f3c95..46fe817 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -906,7 +906,10 @@ iwl_mvm_set_last_nonqos_seq(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 #endif
 void iwl_mvm_set_wowlan_qos_seq(struct iwl_mvm_sta *mvm_ap_sta,
 				struct iwl_wowlan_config_cmd_v2 *cmd);
-int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
+			       struct ieee80211_vif *vif,
+			       bool disable_offloading,
+			       u32 cmd_flags);
 
 /* D0i3 */
 void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
diff --git a/drivers/net/wireless/iwlwifi/mvm/offloading.c b/drivers/net/wireless/iwlwifi/mvm/offloading.c
index 9ec5a59..9bfb95e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/offloading.c
+++ b/drivers/net/wireless/iwlwifi/mvm/offloading.c
@@ -81,7 +81,10 @@ void iwl_mvm_set_wowlan_qos_seq(struct iwl_mvm_sta *mvm_ap_sta,
 	}
 }
 
-int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
+			       struct ieee80211_vif *vif,
+			       bool disable_offloading,
+			       u32 cmd_flags)
 {
 	union {
 		struct iwl_proto_offload_cmd_v1 v1;
@@ -91,7 +94,7 @@ int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	} cmd = {};
 	struct iwl_host_cmd hcmd = {
 		.id = PROT_OFFLOAD_CONFIG_CMD,
-		.flags = CMD_SYNC,
+		.flags = cmd_flags,
 		.data[0] = &cmd,
 		.dataflags[0] = IWL_HCMD_DFL_DUP,
 	};
@@ -204,10 +207,8 @@ int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		memcpy(common->arp_mac_addr, vif->addr, ETH_ALEN);
 	}
 
-	if (!enabled)
-		return 0;
-
-	common->enabled = cpu_to_le32(enabled);
+	if (!disable_offloading)
+		common->enabled = cpu_to_le32(enabled);
 
 	hcmd.len[0] = size;
 	return iwl_mvm_send_cmd(mvm, &hcmd);
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index a3e21f1..10846b6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -905,6 +905,7 @@ static void iwl_mvm_enter_d0i3_iterator(void *_data, u8 *mac,
 		data->disable_offloading = true;
 
 	iwl_mvm_update_d0i3_power_mode(mvm, vif, true, flags);
+	iwl_mvm_send_proto_offload(mvm, vif, data->disable_offloading, flags);
 
 	/*
 	 * on init/association, mvm already configures POWER_TABLE_CMD
-- 
1.8.3.2

