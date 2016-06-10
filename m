Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56618 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020AbcFJMkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 08:40:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 10 Jun 2016 15:39:57 +0300
Message-Id: <1465562397-1402-5-git-send-email-luca@coelho.fi> (sfid-20160610_144051_833479_819255BE)
In-Reply-To: <1465562397-1402-1-git-send-email-luca@coelho.fi>
References: <1465562195.29614.5.camel@coelho.fi>
 <1465562397-1402-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 5/5] iwlwifi: mvm: fix a few firmware capability checks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My cleanup in "iwlwifi: prepare for higher API/CAPA bits" accidentally
inverted a few tests - fix them.

Fixes: 859d914c8f5c ("iwlwifi: prepare for higher API/CAPA bits")
Reported-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index e5f267b..18a8474 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3851,8 +3851,8 @@ static int iwl_mvm_mac_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	if (fw_has_capa(&mvm->fw->ucode_capa,
-			IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS))
+	if (!fw_has_capa(&mvm->fw->ucode_capa,
+			 IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS))
 		return -ENOENT;
 
 	mutex_lock(&mvm->mutex);
@@ -3898,8 +3898,8 @@ static void iwl_mvm_mac_sta_statistics(struct ieee80211_hw *hw,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
-	if (fw_has_capa(&mvm->fw->ucode_capa,
-			IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS))
+	if (!fw_has_capa(&mvm->fw->ucode_capa,
+			 IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS))
 		return;
 
 	/* if beacon filtering isn't on mac80211 does it anyway */
-- 
2.8.1

