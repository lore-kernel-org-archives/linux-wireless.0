Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56855 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751340AbbJELkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 07:40:52 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>, <stable@vger.kernel.org>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 14:40:39 +0300
Message-Id: <1444045246-9946-1-git-send-email-luca@coelho.fi> (sfid-20151005_134056_074544_E542F2E0)
In-Reply-To: <1444044666.27220.5.camel@coelho.fi>
References: <1444044666.27220.5.camel@coelho.fi>
Subject: [PATCH 1/8] iwlwifi: mvm: fix D3 CCMP TX PN assignment
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When going into/coming out of D3, the TX PN must be programmed into
and restored from the firmware respectively. The restore was broken
due to my previous commit to move PN assignment into the driver.
Sending the PN to the firmware still worked since we now use the
counter that's shared with mac80211, but accessing it through the
mac80211 API makes no sense now.

Fix this by reading/writing the counter directly. This actually
simplifies the code since we don't need to round-trip through the
key_seq structure.

Fixes: ca8c0f4bede6 ("iwlwifi: mvm: move TX PN assignment for CCMP to the driver")
Cc: <stable@vger.kernel.org> [4.1+]
Reported-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 04264e4..9578b9d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -274,18 +274,13 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		if (sta) {
-			u8 *pn = seq.ccmp.pn;
+			u64 pn64;
 
 			aes_sc = data->rsc_tsc->all_tsc_rsc.aes.unicast_rsc;
 			aes_tx_sc = &data->rsc_tsc->all_tsc_rsc.aes.tsc;
 
-			ieee80211_get_key_tx_seq(key, &seq);
-			aes_tx_sc->pn = cpu_to_le64((u64)pn[5] |
-						    ((u64)pn[4] << 8) |
-						    ((u64)pn[3] << 16) |
-						    ((u64)pn[2] << 24) |
-						    ((u64)pn[1] << 32) |
-						    ((u64)pn[0] << 40));
+			pn64 = atomic64_read(&key->tx_pn);
+			aes_tx_sc->pn = cpu_to_le64(pn64);
 		} else {
 			aes_sc = data->rsc_tsc->all_tsc_rsc.aes.multicast_rsc;
 		}
@@ -1453,15 +1448,15 @@ static void iwl_mvm_d3_update_gtks(struct ieee80211_hw *hw,
 
 		switch (key->cipher) {
 		case WLAN_CIPHER_SUITE_CCMP:
-			iwl_mvm_aes_sc_to_seq(&sc->aes.tsc, &seq);
 			iwl_mvm_set_aes_rx_seq(sc->aes.unicast_rsc, key);
+			atomic64_set(&key->tx_pn, le64_to_cpu(sc->aes.tsc.pn));
 			break;
 		case WLAN_CIPHER_SUITE_TKIP:
 			iwl_mvm_tkip_sc_to_seq(&sc->tkip.tsc, &seq);
 			iwl_mvm_set_tkip_rx_seq(sc->tkip.unicast_rsc, key);
+			ieee80211_set_key_tx_seq(key, &seq);
 			break;
 		}
-		ieee80211_set_key_tx_seq(key, &seq);
 
 		/* that's it for this key */
 		return;
-- 
2.5.3

