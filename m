Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35900 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750954AbdI2MDR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 08:03:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 15:03:01 +0300
Message-Id: <20170929120305.20551-2-luca@coelho.fi> (sfid-20170929_140321_808945_A3B3AE75)
In-Reply-To: <20170929120305.20551-1-luca@coelho.fi>
References: <20170929120305.20551-1-luca@coelho.fi>
Subject: [PATCH 1/5] iwlwifi: mvm: do not print security error in monitor mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

In monitor mode we are not expected to decrypt encrypted
packets (not having the keys).
Hence we are expected to get an unknown rx security status.
Keeping the print in monitor mode causes a print for each
captured packet flooding the dmesg.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 7 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c       | 4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 4 +++-
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 3bcaa82f59b2..a9ac872226fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1077,6 +1077,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	mvm->vif_count = 0;
 	mvm->rx_ba_sessions = 0;
 	mvm->fwrt.dump.conf = FW_DBG_INVALID;
+	mvm->monitor_on = false;
 
 	/* keep statistics ticking */
 	iwl_mvm_accu_radio_stats(mvm);
@@ -1437,6 +1438,9 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		mvm->p2p_device_vif = vif;
 	}
 
+	if (vif->type == NL80211_IFTYPE_MONITOR)
+		mvm->monitor_on = true;
+
 	iwl_mvm_vif_dbgfs_register(mvm, vif);
 	goto out_unlock;
 
@@ -1526,6 +1530,9 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 	iwl_mvm_power_update_mac(mvm);
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 
+	if (vif->type == NL80211_IFTYPE_MONITOR)
+		mvm->monitor_on = false;
+
 out_release:
 	mutex_unlock(&mvm->mutex);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 83303bac0e4b..d75da37a79f3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1015,6 +1015,9 @@ struct iwl_mvm {
 	bool drop_bcn_ap_mode;
 
 	struct delayed_work cs_tx_unblock_dwork;
+
+	/* does a monitor vif exist (only one can exist hence bool) */
+	bool monitor_on;
 #ifdef CONFIG_ACPI
 	struct iwl_mvm_sar_profile sar_profiles[IWL_MVM_SAR_PROFILE_NUM];
 	struct iwl_mvm_geo_profile geo_profiles[IWL_NUM_GEO_PROFILES];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 184c749766f2..2d14a58cbdd7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -244,7 +244,9 @@ static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm,
 		return 0;
 
 	default:
-		IWL_ERR(mvm, "Unhandled alg: 0x%x\n", rx_pkt_status);
+		/* Expected in monitor (not having the keys) */
+		if (!mvm->monitor_on)
+			IWL_ERR(mvm, "Unhandled alg: 0x%x\n", rx_pkt_status);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 77f77bc5d083..248699c2c4bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -277,7 +277,9 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 		stats->flag |= RX_FLAG_DECRYPTED;
 		return 0;
 	default:
-		IWL_ERR(mvm, "Unhandled alg: 0x%x\n", status);
+		/* Expected in monitor (not having the keys) */
+		if (!mvm->monitor_on)
+			IWL_ERR(mvm, "Unhandled alg: 0x%x\n", status);
 	}
 
 	return 0;
-- 
2.14.1
