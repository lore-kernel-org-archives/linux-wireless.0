Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61683 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692AbaLBSLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:33 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so17803510wgh.32
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:32 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/26] iwlwifi: mvm: remove IWL_UCODE_TLV_API_CSA_FLOW
Date: Tue,  2 Dec 2014 20:10:57 +0200
Message-Id: <1417543877-24193-6-git-send-email-egrumbach@gmail.com> (sfid-20141202_191137_221608_0EAFDDDE)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this TLV flag set.

Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 598fabf..31a5b3f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -369,8 +369,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_GO_UAPSD)
 		hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_CSA_FLOW)
-		hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
+	hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
 	hw->wiphy->iface_combinations = iwl_mvm_iface_combinations;
 	hw->wiphy->n_iface_combinations =
-- 
1.9.1

