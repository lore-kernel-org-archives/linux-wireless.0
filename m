Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59254 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751049AbeBQIeD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Feb 2018 03:34:03 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 17 Feb 2018 10:33:47 +0200
Message-Id: <20180217083354.31160-3-luca@coelho.fi> (sfid-20180217_093418_636127_08D6B8B0)
In-Reply-To: <20180217083354.31160-1-luca@coelho.fi>
References: <20180217083354.31160-1-luca@coelho.fi>
Subject: [PATCH 2/9] iwlwifi: mvm: fix TX of CCMP 256
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We don't have enough room in the TX command for a CCMP 256
key, and need to use key from table.

Fixes: 3264bf032bd9 ("[BUGFIX] iwlwifi: mvm: Fix CCMP IV setting")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index dda77b327c98..57ad6019ffad 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -419,11 +419,11 @@ static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
 {
 	struct ieee80211_key_conf *keyconf = info->control.hw_key;
 	u8 *crypto_hdr = skb_frag->data + hdrlen;
+	enum iwl_tx_cmd_sec_ctrl type = TX_CMD_SEC_CCM;
 	u64 pn;
 
 	switch (keyconf->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
-	case WLAN_CIPHER_SUITE_CCMP_256:
 		iwl_mvm_set_tx_cmd_ccmp(info, tx_cmd);
 		iwl_mvm_set_tx_cmd_pn(info, crypto_hdr);
 		break;
@@ -447,13 +447,16 @@ static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
 		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
+		type = TX_CMD_SEC_GCMP;
+		/* Fall through */
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		/* TODO: Taking the key from the table might introduce a race
 		 * when PTK rekeying is done, having an old packets with a PN
 		 * based on the old key but the message encrypted with a new
 		 * one.
 		 * Need to handle this.
 		 */
-		tx_cmd->sec_ctl |= TX_CMD_SEC_GCMP | TX_CMD_SEC_KEY_FROM_TABLE;
+		tx_cmd->sec_ctl |= type | TX_CMD_SEC_KEY_FROM_TABLE;
 		tx_cmd->key[0] = keyconf->hw_key_idx;
 		iwl_mvm_set_tx_cmd_pn(info, crypto_hdr);
 		break;
-- 
2.15.1
