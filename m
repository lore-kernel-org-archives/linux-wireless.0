Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60622 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751239AbdFBJfj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 05:35:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 12:35:13 +0300
Message-Id: <20170602093516.16369-8-luca@coelho.fi> (sfid-20170602_113545_738853_609F61B1)
In-Reply-To: <20170602093516.16369-1-luca@coelho.fi>
References: <20170602093516.16369-1-luca@coelho.fi>
Subject: [PATCH 07/10] iwlwifi: mvm: don't fail when removing a key from an inexisting sta
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The iwl_mvm_remove_sta_key() function handles removing a key when the
sta doesn't exist anymore.  Mistakenly, this was changed to return an
error while fixing another bug.

If the mvm_sta doesn't exist, we continue normally, but just don't try
to remove the igtk key.

Fixes: cd4d23c1ea9b ("iwlwifi: mvm: Fix removal of IGTK")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 9184ce09b89a..614d67810d05 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -3332,18 +3332,15 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 
 	/* Get the station from the mvm local station table */
 	mvm_sta = iwl_mvm_get_key_sta(mvm, vif, sta);
-	if (!mvm_sta) {
-		IWL_ERR(mvm, "Failed to find station\n");
-		return -EINVAL;
-	}
-	sta_id = mvm_sta->sta_id;
+	if (mvm_sta)
+		sta_id = mvm_sta->sta_id;
 
 	IWL_DEBUG_WEP(mvm, "mvm remove dynamic key: idx=%d sta=%d\n",
 		      keyconf->keyidx, sta_id);
 
-	if (keyconf->cipher == WLAN_CIPHER_SUITE_AES_CMAC ||
-	    keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_128 ||
-	    keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_256)
+	if (mvm_sta && (keyconf->cipher == WLAN_CIPHER_SUITE_AES_CMAC ||
+			keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_128 ||
+			keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_256))
 		return iwl_mvm_send_sta_igtk(mvm, keyconf, sta_id, true);
 
 	if (!__test_and_clear_bit(keyconf->hw_key_idx, mvm->fw_key_table)) {
-- 
2.11.0
