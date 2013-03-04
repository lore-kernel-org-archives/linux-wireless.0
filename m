Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab3CDOA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:00:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/11] iwlwifi: mvm: restart the NIC of the cmd queue gets full
Date: Mon,  4 Mar 2013 15:00:45 +0100
Message-Id: <1362405651-26456-5-git-send-email-johannes@sipsolutions.net> (sfid-20130304_150102_122256_4BD2A834)
In-Reply-To: <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
References: <1362405609.21028.12.camel@jlt4.sipsolutions.net>
 <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This situation is clearly an error situation and the only
way to recover is to restart the driver / fw.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index aa59adf..d0f9c1e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -624,12 +624,8 @@ static void iwl_mvm_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 	ieee80211_free_txskb(mvm->hw, skb);
 }
 
-static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
+static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
 {
-	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
-
-	iwl_mvm_dump_nic_error_log(mvm);
-
 	iwl_abort_notification_waits(&mvm->notif_wait);
 
 	/*
@@ -663,9 +659,21 @@ static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
 	}
 }
 
+static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
+{
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+
+	iwl_mvm_dump_nic_error_log(mvm);
+
+	iwl_mvm_nic_restart(mvm);
+}
+
 static void iwl_mvm_cmd_queue_full(struct iwl_op_mode *op_mode)
 {
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+
 	WARN_ON(1);
+	iwl_mvm_nic_restart(mvm);
 }
 
 static const struct iwl_op_mode_ops iwl_mvm_ops = {
-- 
1.8.0

