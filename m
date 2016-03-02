Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22360 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbcCBH5m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:42 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/43] iwlwifi: mvm: forbid U-APSD for P2P Client if the firmware doesn't support it
Date: Wed,  2 Mar 2016 09:56:32 +0200
Message-Id: <1456905404-14435-31-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085950_643067_7666ACCB)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Older versions of the firmware don't support U-APSD for
P2P Client. Forbid U-APSD for P2P Client when an old
firmware is being used.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 4c2449b..86b4b9d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2334,6 +2334,11 @@ static void iwl_mvm_check_uapsd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT))
 		return;
 
+	if (vif->p2p && !iwl_mvm_is_p2p_standalone_uapsd_supported(mvm)) {
+		vif->driver_flags &= ~IEEE80211_VIF_SUPPORTS_UAPSD;
+		return;
+	}
+
 	if (iwlwifi_mod_params.uapsd_disable) {
 		vif->driver_flags &= ~IEEE80211_VIF_SUPPORTS_UAPSD;
 		return;
-- 
2.5.0

