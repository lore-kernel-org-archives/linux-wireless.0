Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40056 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535AbaGVT1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:21 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so6416346wiv.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:20 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/20] iwlwifi: mvm: add some missing iwl_mvm_ref_sync() calls
Date: Tue, 22 Jul 2014 22:26:37 +0300
Message-Id: <1406057211-31752-6-git-send-email-egrumbach@gmail.com> (sfid-20140722_212733_948163_693955CA)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Add iwl_mvm_ref_sync() calls (with new ref types) to
flows that might access the device directly.

These calls make sure the device is out of d0i3,
and the bus is available for direct access.

Since some of these functions are reentrant, convert
the refs_bitmap to a ref counter, so multiple refs
of the same type could be taken concurrently.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  | 43 +++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 66 ++++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 15 ++++++-
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  3 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c       |  6 +++
 5 files changed, 110 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index f131ef0..ac9787c0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -830,8 +830,14 @@ static ssize_t iwl_dbgfs_fw_restart_write(struct iwl_mvm *mvm, char *buf,
 static ssize_t iwl_dbgfs_fw_nmi_write(struct iwl_mvm *mvm, char *buf,
 				      size_t count, loff_t *ppos)
 {
+	int ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_NMI);
+	if (ret)
+		return ret;
+
 	iwl_force_nmi(mvm->trans);
 
+	iwl_mvm_unref(mvm, IWL_MVM_REF_NMI);
+
 	return count;
 }
 
@@ -1115,11 +1121,11 @@ static ssize_t iwl_dbgfs_d3_sram_read(struct file *file, char __user *user_buf,
 }
 #endif
 
-#define PRINT_MVM_REF(ref) do {					\
-	if (test_bit(ref, mvm->ref_bitmap))			\
-		pos += scnprintf(buf + pos, bufsz - pos,	\
-				 "\t(0x%lx) %s\n",		\
-				 BIT(ref), #ref);		\
+#define PRINT_MVM_REF(ref) do {						\
+	if (mvm->refs[ref])						\
+		pos += scnprintf(buf + pos, bufsz - pos,		\
+				 "\t(0x%lx): %d %s\n",			\
+				 BIT(ref), mvm->refs[ref], #ref);	\
 } while (0)
 
 static ssize_t iwl_dbgfs_d0i3_refs_read(struct file *file,
@@ -1127,12 +1133,17 @@ static ssize_t iwl_dbgfs_d0i3_refs_read(struct file *file,
 					size_t count, loff_t *ppos)
 {
 	struct iwl_mvm *mvm = file->private_data;
-	int pos = 0;
+	int i, pos = 0;
 	char buf[256];
 	const size_t bufsz = sizeof(buf);
+	u32 refs = 0;
+
+	for (i = 0; i < IWL_MVM_REF_COUNT; i++)
+		if (mvm->refs[i])
+			refs |= BIT(i);
 
-	pos += scnprintf(buf + pos, bufsz - pos, "taken mvm refs: 0x%lx\n",
-			 mvm->ref_bitmap[0]);
+	pos += scnprintf(buf + pos, bufsz - pos, "taken mvm refs: 0x%x\n",
+			 refs);
 
 	PRINT_MVM_REF(IWL_MVM_REF_UCODE_DOWN);
 	PRINT_MVM_REF(IWL_MVM_REF_SCAN);
@@ -1158,7 +1169,7 @@ static ssize_t iwl_dbgfs_d0i3_refs_write(struct iwl_mvm *mvm, char *buf,
 
 	mutex_lock(&mvm->mutex);
 
-	taken = test_bit(IWL_MVM_REF_USER, mvm->ref_bitmap);
+	taken = mvm->refs[IWL_MVM_REF_USER];
 	if (value == 1 && !taken)
 		iwl_mvm_ref(mvm, IWL_MVM_REF_USER);
 	else if (value == 0 && taken)
@@ -1194,14 +1205,21 @@ iwl_dbgfs_prph_reg_read(struct file *file,
 	int pos = 0;
 	char buf[32];
 	const size_t bufsz = sizeof(buf);
+	int ret;
 
 	if (!mvm->dbgfs_prph_reg_addr)
 		return -EINVAL;
 
+	ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PRPH_READ);
+	if (ret)
+		return ret;
+
 	pos += scnprintf(buf + pos, bufsz - pos, "Reg 0x%x: (0x%x)\n",
 		mvm->dbgfs_prph_reg_addr,
 		iwl_read_prph(mvm->trans, mvm->dbgfs_prph_reg_addr));
 
+	iwl_mvm_unref(mvm, IWL_MVM_REF_PRPH_READ);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
@@ -1211,6 +1229,7 @@ iwl_dbgfs_prph_reg_write(struct iwl_mvm *mvm, char *buf,
 {
 	u8 args;
 	u32 value;
+	int ret;
 
 	args = sscanf(buf, "%i %i", &mvm->dbgfs_prph_reg_addr, &value);
 	/* if we only want to set the reg address - nothing more to do */
@@ -1221,7 +1240,13 @@ iwl_dbgfs_prph_reg_write(struct iwl_mvm *mvm, char *buf,
 	if (args != 2)
 		return -EINVAL;
 
+	ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PRPH_WRITE);
+	if (ret)
+		return ret;
+
 	iwl_write_prph(mvm->trans, mvm->dbgfs_prph_reg_addr, value);
+
+	iwl_mvm_unref(mvm, IWL_MVM_REF_PRPH_WRITE);
 out:
 	return count;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 2eb6ebe..12a9aed 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -211,7 +211,9 @@ void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
 		return;
 
 	IWL_DEBUG_RPM(mvm, "Take mvm reference - type %d\n", ref_type);
-	WARN_ON(test_and_set_bit(ref_type, mvm->ref_bitmap));
+	spin_lock_bh(&mvm->refs_lock);
+	mvm->refs[ref_type]++;
+	spin_unlock_bh(&mvm->refs_lock);
 	iwl_trans_ref(mvm->trans);
 }
 
@@ -221,29 +223,35 @@ void iwl_mvm_unref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
 		return;
 
 	IWL_DEBUG_RPM(mvm, "Leave mvm reference - type %d\n", ref_type);
-	WARN_ON(!test_and_clear_bit(ref_type, mvm->ref_bitmap));
+	spin_lock_bh(&mvm->refs_lock);
+	WARN_ON(!mvm->refs[ref_type]--);
+	spin_unlock_bh(&mvm->refs_lock);
 	iwl_trans_unref(mvm->trans);
 }
 
-static void
-iwl_mvm_unref_all_except(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref)
+static void iwl_mvm_unref_all_except(struct iwl_mvm *mvm,
+				     enum iwl_mvm_ref_type except_ref)
 {
-	int i;
+	int i, j;
 
 	if (!iwl_mvm_is_d0i3_supported(mvm))
 		return;
 
-	for_each_set_bit(i, mvm->ref_bitmap, IWL_MVM_REF_COUNT) {
-		if (ref == i)
+	spin_lock_bh(&mvm->refs_lock);
+	for (i = 0; i < IWL_MVM_REF_COUNT; i++) {
+		if (except_ref == i || !mvm->refs[i])
 			continue;
 
-		IWL_DEBUG_RPM(mvm, "Cleanup: remove mvm ref type %d\n", i);
-		clear_bit(i, mvm->ref_bitmap);
-		iwl_trans_unref(mvm->trans);
+		IWL_DEBUG_RPM(mvm, "Cleanup: remove mvm ref type %d (%d)\n",
+			      i, mvm->refs[i]);
+		for (j = 0; j < mvm->refs[i]; j++)
+			iwl_trans_unref(mvm->trans);
+		mvm->refs[i] = 0;
 	}
+	spin_unlock_bh(&mvm->refs_lock);
 }
 
-static int iwl_mvm_ref_sync(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
+int iwl_mvm_ref_sync(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
 {
 	iwl_mvm_ref(mvm, ref_type);
 
@@ -1533,6 +1541,14 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
+	/*
+	 * iwl_mvm_mac_ctxt_add() might read directly from the device
+	 * (the system time), so make sure it is available.
+	 */
+	ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_START_AP);
+	if (ret)
+		return ret;
+
 	mutex_lock(&mvm->mutex);
 
 	/* Send the beacon template */
@@ -1594,6 +1610,7 @@ out_remove:
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 out_unlock:
 	mutex_unlock(&mvm->mutex);
+	iwl_mvm_unref(mvm, IWL_MVM_REF_START_AP);
 	return ret;
 }
 
@@ -1671,6 +1688,14 @@ static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
+	/*
+	 * iwl_mvm_bss_info_changed_station() might call
+	 * iwl_mvm_protect_session(), which reads directly from
+	 * the device (the system time), so make sure it is available.
+	 */
+	if (iwl_mvm_ref_sync(mvm, IWL_MVM_REF_BSS_CHANGED))
+		return;
+
 	mutex_lock(&mvm->mutex);
 
 	if (changes & BSS_CHANGED_IDLE && !bss_conf->idle)
@@ -1690,6 +1715,7 @@ static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	mutex_unlock(&mvm->mutex);
+	iwl_mvm_unref(mvm, IWL_MVM_REF_BSS_CHANGED);
 }
 
 static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
@@ -2065,10 +2091,19 @@ static void iwl_mvm_mac_mgd_prepare_tx(struct ieee80211_hw *hw,
 	if (WARN_ON_ONCE(vif->bss_conf.assoc))
 		return;
 
+	/*
+	 * iwl_mvm_protect_session() reads directly from the device
+	 * (the system time), so make sure it is available.
+	 */
+	if (iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PREPARE_TX))
+		return;
+
 	mutex_lock(&mvm->mutex);
 	/* Try really hard to protect the session and hear a beacon */
 	iwl_mvm_protect_session(mvm, vif, duration, min_duration, 500);
 	mutex_unlock(&mvm->mutex);
+
+	iwl_mvm_unref(mvm, IWL_MVM_REF_PREPARE_TX);
 }
 
 static void iwl_mvm_mac_mgd_protect_tdls_discover(struct ieee80211_hw *hw,
@@ -2077,10 +2112,19 @@ static void iwl_mvm_mac_mgd_protect_tdls_discover(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	u32 duration = 2 * vif->bss_conf.dtim_period * vif->bss_conf.beacon_int;
 
+	/*
+	 * iwl_mvm_protect_session() reads directly from the device
+	 * (the system time), so make sure it is available.
+	 */
+	if (iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PROTECT_TDLS))
+		return;
+
 	mutex_lock(&mvm->mutex);
 	/* Protect the session to hear the TDLS setup response on the channel */
 	iwl_mvm_protect_session(mvm, vif, duration, duration, 100);
 	mutex_unlock(&mvm->mutex);
+
+	iwl_mvm_unref(mvm, IWL_MVM_REF_PROTECT_TDLS);
 }
 
 static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 785e523..24c12c7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -249,6 +249,15 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_TX,
 	IWL_MVM_REF_TX_AGG,
 	IWL_MVM_REF_ADD_IF,
+	IWL_MVM_REF_START_AP,
+	IWL_MVM_REF_BSS_CHANGED,
+	IWL_MVM_REF_PREPARE_TX,
+	IWL_MVM_REF_PROTECT_TDLS,
+	IWL_MVM_REF_CHECK_CTKILL,
+	IWL_MVM_REF_PRPH_READ,
+	IWL_MVM_REF_PRPH_WRITE,
+	IWL_MVM_REF_NMI,
+	IWL_MVM_REF_TM_CMD,
 	IWL_MVM_REF_EXIT_WORK,
 
 	IWL_MVM_REF_COUNT,
@@ -606,8 +615,9 @@ struct iwl_mvm {
 	 */
 	unsigned long fw_key_table[BITS_TO_LONGS(STA_KEY_MAX_NUM)];
 
-	/* A bitmap of reference types taken by the driver. */
-	unsigned long ref_bitmap[BITS_TO_LONGS(IWL_MVM_REF_COUNT)];
+	/* references taken by the driver and spinlock protecting them */
+	spinlock_t refs_lock;
+	u8 refs[IWL_MVM_REF_COUNT];
 
 	u8 vif_count;
 
@@ -988,6 +998,7 @@ int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 /* D0i3 */
 void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 void iwl_mvm_unref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
+int iwl_mvm_ref_sync(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
 void iwl_mvm_d0i3_enable_tx(struct iwl_mvm *mvm, __le16 *qos_seq);
 int _iwl_mvm_exit_d0i3(struct iwl_mvm *mvm);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 7f0e9af..19a66b5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -428,6 +428,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_WORK(&mvm->d0i3_exit_work, iwl_mvm_d0i3_exit_work);
 
 	spin_lock_init(&mvm->d0i3_tx_lock);
+	spin_lock_init(&mvm->refs_lock);
 	skb_queue_head_init(&mvm->d0i3_tx);
 	init_waitqueue_head(&mvm->d0i3_exit_waitq);
 
@@ -542,7 +543,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	memset(&mvm->rx_stats, 0, sizeof(struct mvm_statistics_rx));
 
 	/* rpm starts with a taken ref. only set the appropriate bit here. */
-	set_bit(IWL_MVM_REF_UCODE_DOWN, mvm->ref_bitmap);
+	mvm->refs[IWL_MVM_REF_UCODE_DOWN] = 1;
 
 	return op_mode;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 0c4ff3a..0464599 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -338,10 +338,16 @@ static void check_exit_ctkill(struct work_struct *work)
 
 	duration = tt->params->ct_kill_duration;
 
+	/* make sure the device is available for direct read/writes */
+	if (iwl_mvm_ref_sync(mvm, IWL_MVM_REF_CHECK_CTKILL))
+		goto reschedule;
+
 	iwl_trans_start_hw(mvm->trans);
 	temp = check_nic_temperature(mvm);
 	iwl_trans_stop_device(mvm->trans);
 
+	iwl_mvm_unref(mvm, IWL_MVM_REF_CHECK_CTKILL);
+
 	if (temp < MIN_TEMPERATURE || temp > MAX_TEMPERATURE) {
 		IWL_DEBUG_TEMP(mvm, "Failed to measure NIC temperature\n");
 		goto reschedule;
-- 
1.8.3.2

