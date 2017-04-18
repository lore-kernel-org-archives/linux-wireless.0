Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52880 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755752AbdDRWWW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:22:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:15 +0300
Message-Id: <20170418221729.28372-12-luca@coelho.fi> (sfid-20170419_002226_961737_EEBD7CE9)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 11/25] iwlwifi: mvm: provide the actual number of frames for the SP len
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In the end, the firmware doesn't want the SP len as present
in the WMM IE, but rather the actual number of frames.

Fixes: bd3c6cf901a8 ("iwlwifi: mvm: tell the firmware about the U-APSD parameters")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 65706ddb979b..839596c7a562 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -223,7 +223,7 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		if (sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
 			add_sta_cmd.uapsd_acs |= BIT(AC_VO);
 		add_sta_cmd.uapsd_acs |= add_sta_cmd.uapsd_acs << 4;
-		add_sta_cmd.sp_length = sta->max_sp;
+		add_sta_cmd.sp_length = sta->max_sp ? sta->max_sp * 2 : 128;
 	}
 
 	status = ADD_STA_SUCCESS;
-- 
2.11.0
