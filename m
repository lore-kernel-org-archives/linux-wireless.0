Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15141 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbbFCHcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:32:08 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/15] iwlwifi: mvm: advertise only HW-supported ciphers
Date: Wed,  3 Jun 2015 10:31:36 +0300
Message-Id: <1433316696-4612-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093350_681352_CD723D4F)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

After the new ciphers CCMP-256 and GCMP-128/256 were implemented,
wpa_supplicant could start negotiating them and use the software
implementation. This, however, breaks D3 behaviour in the driver
since it means that WoWLAN will not be possible.

To avoid breaking that feature, advertise only ciphers that the
hardware supports.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 32 ++++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  2 ++
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index c46c69f..08367fb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -415,6 +415,12 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 {
 	struct ieee80211_hw *hw = mvm->hw;
 	int num_mac, ret, i;
+	static const u32 mvm_ciphers[] = {
+		WLAN_CIPHER_SUITE_WEP40,
+		WLAN_CIPHER_SUITE_WEP104,
+		WLAN_CIPHER_SUITE_TKIP,
+		WLAN_CIPHER_SUITE_CCMP,
+	};
 
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
@@ -441,14 +447,32 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->uapsd_queues = IWL_MVM_UAPSD_QUEUES;
 	hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 
+	BUILD_BUG_ON(ARRAY_SIZE(mvm->ciphers) < ARRAY_SIZE(mvm_ciphers) + 2);
+	memcpy(mvm->ciphers, mvm_ciphers, sizeof(mvm_ciphers));
+	hw->wiphy->n_cipher_suites = ARRAY_SIZE(mvm_ciphers);
+	hw->wiphy->cipher_suites = mvm->ciphers;
+
 	/*
 	 * Enable 11w if advertised by firmware and software crypto
 	 * is not enabled (as the firmware will interpret some mgmt
 	 * packets, so enabling it with software crypto isn't safe)
 	 */
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_MFP &&
-	    !iwlwifi_mod_params.sw_crypto)
+	    !iwlwifi_mod_params.sw_crypto) {
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
+		mvm->ciphers[hw->wiphy->n_cipher_suites] =
+			WLAN_CIPHER_SUITE_AES_CMAC;
+		hw->wiphy->n_cipher_suites++;
+	}
+
+	/* currently FW API supports only one optional cipher scheme */
+	if (mvm->fw->cs[0].cipher) {
+		mvm->hw->n_cipher_schemes = 1;
+		mvm->hw->cipher_schemes = &mvm->fw->cs[0];
+		mvm->ciphers[hw->wiphy->n_cipher_suites] =
+			mvm->fw->cs[0].cipher;
+		hw->wiphy->n_cipher_suites++;
+	}
 
 	hw->flags |= IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS;
 	hw->wiphy->features |=
@@ -574,12 +598,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 
-	/* currently FW API supports only one optional cipher scheme */
-	if (mvm->fw->cs[0].cipher) {
-		mvm->hw->n_cipher_schemes = 1;
-		mvm->hw->cipher_schemes = &mvm->fw->cs[0];
-	}
-
 #ifdef CONFIG_PM_SLEEP
 	if (iwl_mvm_is_d0i3_supported(mvm) &&
 	    device_can_wakeup(mvm->trans->dev)) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 255cde4..2d4bad5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -820,6 +820,8 @@ struct iwl_mvm {
 	} tdls_cs;
 
 	struct iwl_mvm_shared_mem_cfg shared_mem_cfg;
+
+	u32 ciphers[6];
 };
 
 /* Extract MVM priv from op_mode and _hw */
-- 
2.1.4

