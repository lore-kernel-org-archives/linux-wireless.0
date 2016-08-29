Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40804 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755756AbcH2TkH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 15:40:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sharon Dvir <sharon.dvir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 29 Aug 2016 22:39:52 +0300
Message-Id: <1472499594-3369-2-git-send-email-luca@coelho.fi> (sfid-20160829_214011_417833_90AE06E6)
In-Reply-To: <1472499594-3369-1-git-send-email-luca@coelho.fi>
References: <1472499451.27868.31.camel@coelho.fi>
 <1472499594-3369-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 2/4] iwlwifi: mvm: check if vif is NULL before using it
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sharon Dvir <sharon.dvir@intel.com>

wdev_to_ieee80211_vif() might return NULL.
Check that vif != NULL before dereferencing it.

Signed-off-by: Sharon Dvir <sharon.dvir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b4fc86d..6a615bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -467,6 +467,8 @@ struct iwl_mvm_vif {
 static inline struct iwl_mvm_vif *
 iwl_mvm_vif_from_mac80211(struct ieee80211_vif *vif)
 {
+	if (!vif)
+		return NULL;
 	return (void *)vif->drv_priv;
 }
 
-- 
2.8.1
