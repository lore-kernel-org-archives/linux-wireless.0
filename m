Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbbAVUeq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:46 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/38] iwlwifi: mvm: rs: refactor ht/vht init
Date: Thu, 22 Jan 2015 22:33:25 +0200
Message-Id: <1421958809-3371-34-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214448_055217_40D8CF47)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Prepare to add some more code there so refactor to
separate functions.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 42 ++++-------------------------------
 1 file changed, 4 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 997a383..554b3a5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2714,44 +2714,10 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		lq_sta->active_legacy_rate |= BIT(sband->bitrates[i].hw_value);
 
 	/* TODO: should probably account for rx_highest for both HT/VHT */
-	if (!vht_cap || !vht_cap->vht_supported) {
-		/* active_siso_rate mask includes 9 MBits (bit 5),
-		 * and CCK (bits 0-3), supp_rates[] does not;
-		 * shift to convert format, force 9 MBits off.
-		 */
-		lq_sta->active_siso_rate = ht_cap->mcs.rx_mask[0] << 1;
-		lq_sta->active_siso_rate |= ht_cap->mcs.rx_mask[0] & 0x1;
-		lq_sta->active_siso_rate &= ~((u16)0x2);
-		lq_sta->active_siso_rate <<= IWL_FIRST_OFDM_RATE;
-
-		/* Same here */
-		lq_sta->active_mimo2_rate = ht_cap->mcs.rx_mask[1] << 1;
-		lq_sta->active_mimo2_rate |= ht_cap->mcs.rx_mask[1] & 0x1;
-		lq_sta->active_mimo2_rate &= ~((u16)0x2);
-		lq_sta->active_mimo2_rate <<= IWL_FIRST_OFDM_RATE;
-
-		lq_sta->is_vht = false;
-		if (mvm->cfg->ht_params->ldpc &&
-		    (ht_cap->cap & IEEE80211_HT_CAP_LDPC_CODING))
-			lq_sta->ldpc = true;
-
-		if (mvm->cfg->ht_params->stbc &&
-		    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1) &&
-		    (ht_cap->cap & IEEE80211_HT_CAP_RX_STBC))
-			lq_sta->stbc = true;
-	} else {
-		rs_vht_set_enabled_rates(sta, vht_cap, lq_sta);
-		lq_sta->is_vht = true;
-
-		if (mvm->cfg->ht_params->ldpc &&
-		    (vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC))
-			lq_sta->ldpc = true;
-
-		if (mvm->cfg->ht_params->stbc &&
-		    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1) &&
-		    (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK))
-			lq_sta->stbc = true;
-	}
+	if (!vht_cap || !vht_cap->vht_supported)
+		rs_ht_init(mvm, sta, lq_sta, ht_cap);
+	else
+		rs_vht_init(mvm, sta, lq_sta, vht_cap);
 
 	if (IWL_MVM_RS_DISABLE_P2P_MIMO && sta_priv->vif->p2p)
 		lq_sta->active_mimo2_rate = 0;
-- 
1.9.1

