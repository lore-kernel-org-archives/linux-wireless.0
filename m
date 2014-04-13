Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49865 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbaDMTVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:04 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so7403214wgh.10
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:03 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/47] iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag
Date: Sun, 13 Apr 2014 22:19:51 +0300
Message-Id: <1397416802-32403-36-git-send-email-egrumbach@gmail.com> (sfid-20140413_213518_186402_78E22181)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this flag set.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h       |  1 -
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 11 ++++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 90d69a2..ad65f68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -111,7 +111,6 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_P2P_PM		= BIT(21),
 	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM	= BIT(22),
 	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_SCM	= BIT(23),
-	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
 	IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD	= BIT(26),
 	IWL_UCODE_TLV_FLAGS_BCAST_FILTERING	= BIT(29),
 	IWL_UCODE_TLV_FLAGS_GO_UAPSD		= BIT(30),
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 8312c03..dc9069b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -276,6 +276,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_TIMING_BEACON_ONLY |
 		    IEEE80211_HW_CONNECTION_MONITOR |
+		    IEEE80211_HW_SUPPORTS_UAPSD |
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 		    IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
@@ -285,6 +286,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 				    IEEE80211_RADIOTAP_MCS_HAVE_STBC;
 	hw->radiotap_vht_details |= IEEE80211_RADIOTAP_VHT_KNOWN_STBC;
 	hw->rate_control_algorithm = "iwl-mvm-rs";
+	hw->uapsd_queues = IWL_UAPSD_AC_INFO;
+	hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 
 	/*
 	 * Enable 11w if advertised by firmware and software crypto
@@ -295,11 +298,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	    !iwlwifi_mod_params.sw_crypto)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
-	if (0 && mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT) {
-		hw->flags |= IEEE80211_HW_SUPPORTS_UAPSD;
-		hw->uapsd_queues = IWL_UAPSD_AC_INFO;
-		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
-	}
+	/* Disable uAPSD due to firmware issues */
+	if (true)
+		hw->flags &= ~IEEE80211_HW_SUPPORTS_UAPSD;
 
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
-- 
1.8.3.2

