Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33240 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750767AbdIOFMA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 01:12:00 -0400
Received: by mail-pf0-f193.google.com with SMTP id h4so736031pfk.0
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 22:12:00 -0700 (PDT)
From: gavinli@thegavinli.com
To: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Cc: linux-wireless@vger.kernel.org, Gavin Li <git@thegavinli.com>
Subject: [PATCH v2] iwlwifi: mvm: allow monitor mode capture in STA mode
Date: Thu, 14 Sep 2017 22:11:48 -0700
Message-Id: <20170915051148.2566-1-gavinli@thegavinli.com> (sfid-20170915_071204_164251_2FFE12E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gavin Li <git@thegavinli.com>

Open up the filter if there is a monitor interface configured; this
allows all packets on the channel to be captured even if the device is
in STA mode and associated to a BSS.

Signed-off-by: Gavin Li <git@thegavinli.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 42 +++++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  3 ++
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index fd2fc46e2fe5..ea98fc040aa8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -752,7 +752,8 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 		cpu_to_le32(vif->bss_conf.use_short_slot ?
 			    MAC_FLG_SHORT_SLOT : 0);
 
-	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP);
+	cmd->filter_flags = cpu_to_le32(mvm->addl_filter_flags |
+					MAC_FILTER_ACCEPT_GRP);
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		u8 txf = iwl_mvm_ac_to_tx_fifo[i];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index db5ad222e5ea..7c6d30ea3cf1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1641,6 +1641,13 @@ static u64 iwl_mvm_prepare_multicast(struct ieee80211_hw *hw,
 	return (u64)(unsigned long)cmd;
 }
 
+static void iwl_mvm_addl_ff_iface_iterator(
+		void *_mvm, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm *mvm = _mvm;
+	iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
+}
+
 static void iwl_mvm_configure_filter(struct ieee80211_hw *hw,
 				     unsigned int changed_flags,
 				     unsigned int *total_flags,
@@ -1648,20 +1655,41 @@ static void iwl_mvm_configure_filter(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mcast_filter_cmd *cmd = (void *)(unsigned long)multicast;
+	const u32 supported_filters =
+		FIF_BCN_PRBRESP_PROMISC |
+		FIF_CONTROL |
+		FIF_OTHER_BSS |
+		FIF_PROBE_REQ;
+	u32 addl_filter_flags = 0;
+
+	*total_flags &= supported_filters;
+	if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
+		addl_filter_flags |= MAC_FILTER_IN_BEACON;
+	if (*total_flags & FIF_CONTROL)
+		addl_filter_flags |= MAC_FILTER_IN_CONTROL_AND_MGMT;
+	if (*total_flags & FIF_OTHER_BSS)
+		addl_filter_flags |= MAC_FILTER_IN_CONTROL_AND_MGMT |
+			MAC_FILTER_IN_PROMISC |
+			MAC_FILTER_IN_BEACON;
+	if (*total_flags & FIF_PROBE_REQ)
+		addl_filter_flags |= MAC_FILTER_IN_PROBE_REQUEST;
 
+	/* replace previous configuration */
 	mutex_lock(&mvm->mutex);
 
-	/* replace previous configuration */
+	if (mvm->addl_filter_flags != addl_filter_flags) {
+		mvm->addl_filter_flags = addl_filter_flags;
+		ieee80211_iterate_active_interfaces(
+				mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+				iwl_mvm_addl_ff_iface_iterator, mvm);
+	}
+
 	kfree(mvm->mcast_filter_cmd);
 	mvm->mcast_filter_cmd = cmd;
+	if (cmd)
+		iwl_mvm_recalc_multicast(mvm);
 
-	if (!cmd)
-		goto out;
-
-	iwl_mvm_recalc_multicast(mvm);
-out:
 	mutex_unlock(&mvm->mutex);
-	*total_flags = 0;
 }
 
 static void iwl_mvm_config_iface_filter(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 52f8d7a6a7dc..827c413157c7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -832,6 +832,9 @@ struct iwl_mvm {
 	/* configured by mac80211 */
 	u32 rts_threshold;
 
+	/* packets to pass as requested by mac80211 */
+	u32 addl_filter_flags;
+
 	/* Scan status, cmd (pre-allocated) and auxiliary station */
 	unsigned int scan_status;
 	void *scan_cmd;
-- 
2.14.1
