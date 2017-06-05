Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59478 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751238AbdFEUoZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:44:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:06 +0300
Message-Id: <20170605204218.30151-14-luca@coelho.fi> (sfid-20170605_224445_352591_4DF45912)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 13/25] iwlwifi: mvm: use schedule_delayed_work()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to refer to system_wq directly, use the provided
wrapper schedule_delayed_work().

Made with the following spatch:
    @@
    expression E,F;
    @@
    -queue_delayed_work(system_wq, E, F);
    +schedule_delayed_work(E, F);

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c   | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c     | 3 +--
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index aac0426112c7..a8353ea1df58 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -927,7 +927,7 @@ int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
 	mvm->fw_dump_desc = desc;
 	mvm->fw_dump_trig = trigger;
 
-	queue_delayed_work(system_wq, &mvm->fw_dump_wk, delay);
+	schedule_delayed_work(&mvm->fw_dump_wk, delay);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 0f1831b41915..d0806d27df58 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1632,9 +1632,9 @@ void iwl_mvm_channel_switch_noa_notif(struct iwl_mvm *mvm,
 
 	IWL_DEBUG_INFO(mvm, "Channel Switch Started Notification\n");
 
-	queue_delayed_work(system_wq, &mvm->cs_tx_unblock_dwork,
-			   msecs_to_jiffies(IWL_MVM_CS_UNBLOCK_TX_TIMEOUT *
-					    csa_vif->bss_conf.beacon_int));
+	schedule_delayed_work(&mvm->cs_tx_unblock_dwork,
+			      msecs_to_jiffies(IWL_MVM_CS_UNBLOCK_TX_TIMEOUT *
+					       csa_vif->bss_conf.beacon_int));
 
 	ieee80211_csa_finish(csa_vif);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 8d1b994ae79f..d48c2ecc0893 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1421,8 +1421,8 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	mvm->scan_vif = iwl_mvm_vif_from_mac80211(vif);
 	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
 
-	queue_delayed_work(system_wq, &mvm->scan_timeout_dwork,
-			   msecs_to_jiffies(SCAN_TIMEOUT));
+	schedule_delayed_work(&mvm->scan_timeout_dwork,
+			      msecs_to_jiffies(SCAN_TIMEOUT));
 
 	return 0;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
index df7cd87199ea..3d97436bbdf5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
@@ -551,8 +551,7 @@ void iwl_mvm_tdls_ch_switch_work(struct work_struct *work)
 
 	/* retry after a DTIM if we failed sending now */
 	delay = TU_TO_MS(vif->bss_conf.dtim_period * vif->bss_conf.beacon_int);
-	queue_delayed_work(system_wq, &mvm->tdls_cs.dwork,
-			   msecs_to_jiffies(delay));
+	schedule_delayed_work(&mvm->tdls_cs.dwork, msecs_to_jiffies(delay));
 out:
 	mutex_unlock(&mvm->mutex);
 }
-- 
2.11.0
