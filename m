Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33582 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753933AbcGFKqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:46:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:40 +0300
Message-Id: <1467801651-1816-45-git-send-email-luca@coelho.fi> (sfid-20160706_125025_710529_0051A179)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 45/56] iwlwifi: store cipher scheme independent of mac80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to reduce reliance on mac80211 structs in the core
iwlwifi code, store the cipher schemes in the format given
by the firmware and convert it later, rather than storing it
in the mac80211 format.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c      | 16 ++--------------
 drivers/net/wireless/intel/iwlwifi/iwl-fw.h       |  3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 19 ++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  1 +
 4 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index e2df544..d675bf0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -326,8 +326,6 @@ static int iwl_store_cscheme(struct iwl_fw *fw, const u8 *data, const u32 len)
 	int i, j;
 	struct iwl_fw_cscheme_list *l = (struct iwl_fw_cscheme_list *)data;
 	struct iwl_fw_cipher_scheme *fwcs;
-	struct ieee80211_cipher_scheme *cs;
-	u32 cipher;
 
 	if (len < sizeof(*l) ||
 	    len < sizeof(l->size) + l->size * sizeof(l->cs[0]))
@@ -335,22 +333,12 @@ static int iwl_store_cscheme(struct iwl_fw *fw, const u8 *data, const u32 len)
 
 	for (i = 0, j = 0; i < IWL_UCODE_MAX_CS && i < l->size; i++) {
 		fwcs = &l->cs[j];
-		cipher = le32_to_cpu(fwcs->cipher);
 
 		/* we skip schemes with zero cipher suite selector */
-		if (!cipher)
+		if (!fwcs->cipher)
 			continue;
 
-		cs = &fw->cs[j++];
-		cs->cipher = cipher;
-		cs->iftype = BIT(NL80211_IFTYPE_STATION);
-		cs->hdr_len = fwcs->hdr_len;
-		cs->pn_len = fwcs->pn_len;
-		cs->pn_off = fwcs->pn_off;
-		cs->key_idx_off = fwcs->key_idx_off;
-		cs->key_idx_mask = fwcs->key_idx_mask;
-		cs->key_idx_shift = fwcs->key_idx_shift;
-		cs->mic_len = fwcs->mic_len;
+		fw->cs[j++] = *fwcs;
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
index 655ec52..74ea68d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
@@ -67,7 +67,6 @@
 #ifndef __iwl_fw_h__
 #define __iwl_fw_h__
 #include <linux/types.h>
-#include <net/mac80211.h>
 
 #include "iwl-fw-file.h"
 #include "iwl-fw-error-dump.h"
@@ -287,7 +286,7 @@ struct iwl_fw {
 
 	enum iwl_fw_type type;
 
-	struct ieee80211_cipher_scheme cs[IWL_UCODE_MAX_CS];
+	struct iwl_fw_cipher_scheme cs[IWL_UCODE_MAX_CS];
 	u8 human_readable[FW_VER_HUMAN_READABLE_SZ];
 
 	u32 sdio_adma_addr;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index e44c337..73e49d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -494,10 +494,23 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	/* currently FW API supports only one optional cipher scheme */
 	if (mvm->fw->cs[0].cipher) {
+		const struct iwl_fw_cipher_scheme *fwcs = &mvm->fw->cs[0];
+		struct ieee80211_cipher_scheme *cs = &mvm->cs[0];
+
 		mvm->hw->n_cipher_schemes = 1;
-		mvm->hw->cipher_schemes = &mvm->fw->cs[0];
-		mvm->ciphers[hw->wiphy->n_cipher_suites] =
-			mvm->fw->cs[0].cipher;
+
+		cs->cipher = le32_to_cpu(fwcs->cipher);
+		cs->iftype = BIT(NL80211_IFTYPE_STATION);
+		cs->hdr_len = fwcs->hdr_len;
+		cs->pn_len = fwcs->pn_len;
+		cs->pn_off = fwcs->pn_off;
+		cs->key_idx_off = fwcs->key_idx_off;
+		cs->key_idx_mask = fwcs->key_idx_mask;
+		cs->key_idx_shift = fwcs->key_idx_shift;
+		cs->mic_len = fwcs->mic_len;
+
+		mvm->hw->cipher_schemes = mvm->cs;
+		mvm->ciphers[hw->wiphy->n_cipher_suites] = cs->cipher;
 		hw->wiphy->n_cipher_suites++;
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index c440b10..b4fc86d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1012,6 +1012,7 @@ struct iwl_mvm {
 	struct iwl_mvm_shared_mem_cfg shared_mem_cfg;
 
 	u32 ciphers[IWL_MVM_NUM_CIPHERS];
+	struct ieee80211_cipher_scheme cs[IWL_UCODE_MAX_CS];
 	struct iwl_mvm_tof_data tof_data;
 
 	struct ieee80211_vif *nan_vif;
-- 
2.8.1

