Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53190 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934455AbdDTFEy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 01:04:54 -0400
Message-ID: <1492664686.31741.93.camel@coelho.fi> (sfid-20170420_070457_899375_89D1A196)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Thu, 20 Apr 2017 08:04:46 +0300
In-Reply-To: <1492664371.31741.91.camel@coelho.fi>
References: <1492664371.31741.91.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi-next 2017-04-19-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-20 at 07:59 +0300, Luca Coelho wrote:
> Here's v2 of my second pull-request intended for v4.12.  It includes the
> last three patch series I sent out, namely 2017-04-13, 2017-04-19 and
> the 2 fixes by Johannes that I sent a few minutes ago.
> 
> I also removed the "bump API to 31" patch.  I'll send a diff between
> this tag and the HEAD of the patches I sent in the 2017-04-19 series.

This is the diffenrece between my pending branch (which contains all the
patches up to 2017-04-19) and this pull-request.  For the record of what
I had to change.


diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index 904e17956e2c..b9718c0cf174 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -70,8 +70,8 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX  31
-#define IWL8265_UCODE_API_MAX  31
+#define IWL8000_UCODE_API_MAX  30
+#define IWL8265_UCODE_API_MAX  30
 
 /* Lowest firmware API version supported */
 #define IWL8000_UCODE_API_MIN  17
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index 42a6e723191e..110ceefccc15 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL9000_UCODE_API_MAX  31
+#define IWL9000_UCODE_API_MAX  30
 
 /* Lowest firmware API version supported */
 #define IWL9000_UCODE_API_MIN  30
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index 6d745c36f1d8..097cb45c8ad9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL_A000_UCODE_API_MAX 31
+#define IWL_A000_UCODE_API_MAX 30
 
 /* Lowest firmware API version supported */
 #define IWL_A000_UCODE_API_MIN 24
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 7b33ff398332..402846650cbe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1056,6 +1056,8 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 
        if (ret)
                return ret;
+       if (count == 0)
+               return 0;
 
        iwl_mvm_fw_dbg_collect(mvm, FW_DBG_TRIGGER_USER, buf,
                               (count - 1), NULL);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index edaaa3bcf0b2..9e69b9d2012c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -216,7 +216,8 @@ u32 iwl_mvm_mac_get_queues_mask(struct ieee80211_vif *vif)
                        qmask |= BIT(vif->hw_queue[ac]);
        }
 
-       if (vif->type == NL80211_IFTYPE_AP)
+       if (vif->type == NL80211_IFTYPE_AP ||
+           vif->type == NL80211_IFTYPE_ADHOC)
                qmask |= BIT(vif->cab_queue);
 
        return qmask;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 839596c7a562..a2a1fa06b781 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1908,7 +1908,8 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
        lockdep_assert_held(&mvm->mutex);
 
        if (iwl_mvm_is_dqa_supported(mvm) && !iwl_mvm_has_new_tx_api(mvm)) {
-               if (vif->type == NL80211_IFTYPE_AP)
+               if (vif->type == NL80211_IFTYPE_AP ||
+                   vif->type == NL80211_IFTYPE_ADHOC)
                        queue = mvm->probe_queue;
                else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
                        queue = mvm->p2p_dev_queue;
@@ -1959,6 +1960,11 @@ static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
 
        lockdep_assert_held(&mvm->mutex);
 
+       if (vif->type == NL80211_IFTYPE_AP ||
+           vif->type == NL80211_IFTYPE_ADHOC)
+               iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
+                                   IWL_MAX_TID_COUNT, 0);
+
        if (mvmvif->bcast_sta.tfd_queue_msk & BIT(mvm->probe_queue)) {
                iwl_mvm_disable_txq(mvm, mvm->probe_queue,
                                    vif->hw_queue[0], IWL_MAX_TID_COUNT,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index a3de91e5e543..8f737f6cdd80 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -543,6 +543,7 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 
        switch (info->control.vif->type) {
        case NL80211_IFTYPE_AP:
+       case NL80211_IFTYPE_ADHOC:
                /*
                 * Handle legacy hostapd as well, where station may be added
                 * only after assoc. Take care of the case where we send a
@@ -554,7 +555,8 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
                if (info->hw_queue == info->control.vif->cab_queue)
                        return info->hw_queue;
 
-               WARN_ONCE(1, "fc=0x%02x", le16_to_cpu(fc));
+               WARN_ONCE(info->control.vif->type != NL80211_IFTYPE_ADHOC,
+                         "fc=0x%02x", le16_to_cpu(fc));
                return mvm->probe_queue;
        case NL80211_IFTYPE_P2P_DEVICE:
                if (ieee80211_is_mgmt(fc))
@@ -620,7 +622,8 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
                        iwl_mvm_vif_from_mac80211(info.control.vif);
 
                if (info.control.vif->type == NL80211_IFTYPE_P2P_DEVICE ||
-                   info.control.vif->type == NL80211_IFTYPE_AP) {
+                   info.control.vif->type == NL80211_IFTYPE_AP ||
+                   info.control.vif->type == NL80211_IFTYPE_ADHOC) {
                        sta_id = mvmvif->bcast_sta.sta_id;
                        queue = iwl_mvm_get_ctrl_vif_queue(mvm, &info,
                                                           hdr->frame_control);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index 854d61888f4d..1d95512361b2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -241,8 +241,11 @@ int iwl_pcie_ctxt_info_init(struct iwl_trans *trans,
 
        /* allocate ucode sections in dram and set addresses */
        ret = iwl_pcie_ctxt_info_init_fw_sec(trans, fw, ctxt_info);
-       if (ret)
+       if (ret) {
+               dma_free_coherent(trans->dev, sizeof(*trans_pcie->ctxt_info),
+                                 ctxt_info, trans_pcie->ctxt_info_dma_addr);
                return ret;
+       }
 
        trans_pcie->ctxt_info = ctxt_info;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index ef8f563a48d9..ac60a282d6de 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -359,8 +359,9 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
                goto out;
        }
 
-       if (iwl_pcie_ctxt_info_init(trans, fw))
-               return -ENOMEM;
+       ret = iwl_pcie_ctxt_info_init(trans, fw);
+       if (ret)
+               goto out;
 
        /* re-check RF-Kill state since we may have missed the interrupt */
        hw_rfkill = iwl_trans_check_hw_rf_kill(trans);

--
Cheers,
Luca.
