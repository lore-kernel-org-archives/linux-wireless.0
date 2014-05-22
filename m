Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:64483 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaEVHYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:24:06 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so3093204wes.29
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 00:24:03 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/11] iwlwifi: mvm: update power after phy_ctxt is NULL when unassigning chanctx
Date: Thu, 22 May 2014 10:23:45 +0300
Message-Id: <1400743435-702-1-git-send-email-egrumbach@gmail.com> (sfid-20140522_092725_536928_296F8E97)
In-Reply-To: <537DA58C.5050003@gmail.com>
References: <537DA58C.5050003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

iwl_mvm_power_update_mac() (more specifically
iwl_mvm_power_iterator()) relies on the phy_ctxt setting to decide
whether the vif is active or not.  When unassigning a chanctx, we
should therefore call iwl_mvm_power_update_mac() after setting
phy_chanctx to NULL.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 22a445f..1c932e9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2299,10 +2299,10 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	}
 
 	iwl_mvm_binding_remove_vif(mvm, vif);
-	iwl_mvm_power_update_mac(mvm, vif);
 
 out_unlock:
 	mvmvif->phy_ctxt = NULL;
+	iwl_mvm_power_update_mac(mvm, vif);
 	mutex_unlock(&mvm->mutex);
 }
 
-- 
1.8.3.2

