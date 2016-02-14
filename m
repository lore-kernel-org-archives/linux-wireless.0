Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:52433 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbcBNL4t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2016 06:56:49 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/3] iwlwifi: mvm: move TX PN assignment for TKIP to the driver
Date: Sun, 14 Feb 2016 13:56:36 +0200
Message-Id: <1455450997-15409-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160214_125656_304228_9C4BF1EB)
In-Reply-To: <1455450997-15409-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1455450997-15409-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

If protocol offloading is configured, the fw might generate some
frames (e.g. arp response) on its own during d3/d0i3.

On d3/d0i3 exit the driver queries the updated PN (if relevant),
and updates its keys (for the d0i3 case, this is done by
iwl_mvm_d0i3_exit_work(), which is scheduled on d0i3 exit)

While in d0i3, iwlmvm defers tx frames until d0i3 exit, and
then continues their processing.

This is problematic with TKIP, since the frame's PN has already
been set at this stage (in contrast to CCMP, where the PN is
being set only later on), so both the frame's PN and the upcoming
PN update (from d0i3 exit work) might be wrong.

Fix it by moving the TX PN assignment (for TKIP) to the driver,
similarly to CCMP.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
Johannes, please route this one through your tree - thanks
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       | 15 ++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |  2 ++
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index d3e21d9..93e4958 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -249,16 +249,19 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 		return;
 	case WLAN_CIPHER_SUITE_TKIP:
 		if (sta) {
+			u64 pn64;
+
 			tkip_sc = data->rsc_tsc->all_tsc_rsc.tkip.unicast_rsc;
 			tkip_tx_sc = &data->rsc_tsc->all_tsc_rsc.tkip.tsc;
 
 			rx_p1ks = data->tkip->rx_uni;
 
-			ieee80211_get_key_tx_seq(key, &seq);
-			tkip_tx_sc->iv16 = cpu_to_le16(seq.tkip.iv16);
-			tkip_tx_sc->iv32 = cpu_to_le32(seq.tkip.iv32);
+			pn64 = atomic64_read(&key->tx_pn);
+			tkip_tx_sc->iv16 = cpu_to_le16(TKIP_PN_TO_IV16(pn64));
+			tkip_tx_sc->iv32 = cpu_to_le32(TKIP_PN_TO_IV32(pn64));
 
-			ieee80211_get_tkip_p1k_iv(key, seq.tkip.iv32, p1k);
+			ieee80211_get_tkip_p1k_iv(key, TKIP_PN_TO_IV32(pn64),
+						  p1k);
 			iwl_mvm_convert_p1k(p1k, data->tkip->tx.p1k);
 
 			memcpy(data->tkip->mic_keys.tx,
@@ -1601,7 +1604,9 @@ static void iwl_mvm_d3_update_keys(struct ieee80211_hw *hw,
 		case WLAN_CIPHER_SUITE_TKIP:
 			iwl_mvm_tkip_sc_to_seq(&sc->tkip.tsc, &seq);
 			iwl_mvm_set_tkip_rx_seq(sc->tkip.unicast_rsc, key);
-			ieee80211_set_key_tx_seq(key, &seq);
+			atomic64_set(&key->tx_pn,
+				     (u64)seq.tkip.iv16 |
+				     ((u64)seq.tkip.iv32 << 16));
 			break;
 		}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 1bd3f0b..2b53292 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2585,7 +2585,7 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 8bf48a7..ca1e485 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -299,6 +299,8 @@ static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
 
 	case WLAN_CIPHER_SUITE_TKIP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_TKIP;
+		pn = atomic64_inc_return(&keyconf->tx_pn);
+		ieee80211_tkip_add_iv(crypto_hdr, keyconf, pn);
 		ieee80211_get_tkip_p2k(keyconf, skb_frag, tx_cmd->key);
 		break;
 
-- 
2.5.0

