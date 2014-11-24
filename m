Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53806 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbaKXOfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:09 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so6015678wiv.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:08 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/75] iwlwifi: mvm/trans: abort d0i3_enter in case of held ref
Date: Mon, 24 Nov 2014 16:33:44 +0200
Message-Id: <1416839691-28533-8-git-send-email-egrumbach@gmail.com> (sfid-20141124_154439_371923_AF7046F6)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Other contexts might call iwl_mvm_ref_sync() right before
we set IWL_MVM_STATUS_IN_D0I3, and then assume the fw/bus
is not in d0i3 state.

However, since we currently don't check for held references
in the d0i3_enter flow, we might enter d0i3 although there
is an active reference.

Solve it by aborting the d0i3 enter flow if there is an
active reference. Since users are assumed to use
iwl_mvm_ref_sync, which takes a ref before checking the
flag, we don't need further locking.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-op-mode.h  |  3 ++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 20 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c      | 12 ++++++++++++
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index b6d666e..17de6d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -138,7 +138,8 @@ struct iwl_cfg;
  * @nic_config: configure NIC, called before firmware is started.
  *	May sleep
  * @wimax_active: invoked when WiMax becomes active. May sleep
- * @enter_d0i3: configure the fw to enter d0i3. May sleep.
+ * @enter_d0i3: configure the fw to enter d0i3. return 1 to indicate d0i3
+ *	entrance is aborted (e.g. due to held reference). May sleep.
  * @exit_d0i3: configure the fw to exit d0i3. May sleep.
  */
 struct iwl_op_mode_ops {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 3276b31..4f9f77f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -254,6 +254,26 @@ static void iwl_mvm_unref_all_except(struct iwl_mvm *mvm,
 	spin_unlock_bh(&mvm->refs_lock);
 }
 
+bool iwl_mvm_ref_taken(struct iwl_mvm *mvm)
+{
+	int i;
+	bool taken = false;
+
+	if (!iwl_mvm_is_d0i3_supported(mvm))
+		return true;
+
+	spin_lock_bh(&mvm->refs_lock);
+	for (i = 0; i < IWL_MVM_REF_COUNT; i++) {
+		if (mvm->refs[i]) {
+			taken = true;
+			break;
+		}
+	}
+	spin_unlock_bh(&mvm->refs_lock);
+
+	return taken;
+}
+
 int iwl_mvm_ref_sync(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
 {
 	iwl_mvm_ref(mvm, ref_type);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 1fc94e1..c89ac95 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1070,6 +1070,7 @@ int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 void iwl_mvm_unref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 int iwl_mvm_ref_sync(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
+bool iwl_mvm_ref_taken(struct iwl_mvm *mvm);
 void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq);
 int _iwl_mvm_exit_d0i3(struct iwl_mvm *mvm);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 8c5bdf9..be3dd4f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1041,6 +1041,18 @@ static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 	set_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status);
 	synchronize_net();
 
+	/*
+	 * iwl_mvm_ref_sync takes a reference before checking the flag.
+	 * so by checking there is no held reference we prevent a state
+	 * in which iwl_mvm_ref_sync continues successfully while we
+	 * configure the firmware to enter d0i3
+	 */
+	if (iwl_mvm_ref_taken(mvm)) {
+		IWL_DEBUG_RPM(mvm->trans, "abort d0i3 due to taken ref\n");
+		clear_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status);
+		return 1;
+	}
+
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
 						   IEEE80211_IFACE_ITER_NORMAL,
 						   iwl_mvm_enter_d0i3_iterator,
-- 
1.9.1

