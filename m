Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40798 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752993AbcH2TkG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 15:40:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 29 Aug 2016 22:39:51 +0300
Message-Id: <1472499594-3369-1-git-send-email-luca@coelho.fi> (sfid-20160829_214010_631239_1E7AEB5C)
In-Reply-To: <1472499451.27868.31.camel@coelho.fi>
References: <1472499451.27868.31.camel@coelho.fi>
Subject: [PATCH 1/4] iwlwifi: mvm: consider P2p device type for firmware dump triggers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When the user really wanted a dump on P2P Client, he
coudln't get it because we checked vif->type but didn't
take vif->p2p into account. Fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
index f7dff76..e9f1be9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
@@ -105,7 +105,8 @@ iwl_fw_dbg_trigger_vif_match(struct iwl_fw_dbg_trigger_tlv *trig,
 {
 	u32 trig_vif = le32_to_cpu(trig->vif_type);
 
-	return trig_vif == IWL_FW_DBG_CONF_VIF_ANY || vif->type == trig_vif;
+	return trig_vif == IWL_FW_DBG_CONF_VIF_ANY ||
+	       ieee80211_vif_type_p2p(vif) == trig_vif;
 }
 
 static inline bool
-- 
2.8.1
