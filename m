Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:54805 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbbCEMuK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 07:50:10 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/7] iwlwifi: mvm: disable beamformer unless FW supports it
Date: Thu,  5 Mar 2015 14:49:51 +0200
Message-Id: <1425559793-25131-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150305_135014_992971_9C0A8AB7)
In-Reply-To: <1425558068.22928.3.camel@egrumbacBox>
References: <1425558068.22928.3.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Current FW is declaring support for BFER in ucode_capa.capa
but it doesn't really support it unless the new LQ_SS_PARAMS API
is supported as well. Avoid publishing BFER in our VHT caps
if FW doesn't support.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 35feebf..09654e7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -405,7 +405,10 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&mvm->nvm_data->bands[IEEE80211_BAND_5GHZ];
 
-		if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_BEAMFORMER)
+		if ((mvm->fw->ucode_capa.capa[0] &
+		     IWL_UCODE_TLV_CAPA_BEAMFORMER) &&
+		    (mvm->fw->ucode_capa.api[0] &
+		     IWL_UCODE_TLV_API_LQ_SS_PARAMS))
 			hw->wiphy->bands[IEEE80211_BAND_5GHZ]->vht_cap.cap |=
 				IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE;
 	}
-- 
1.9.1

