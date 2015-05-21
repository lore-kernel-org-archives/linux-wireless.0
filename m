Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5409 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422772AbbEUTxT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 15:53:19 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/10] iwlwifi: mvm: fix MLME trigger
Date: Thu, 21 May 2015 22:53:04 +0300
Message-Id: <1432237990-5890-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150521_215328_835791_5C1D1AA5)
In-Reply-To: <1432237819.26813.4.camel@intel.com>
References: <1432237819.26813.4.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few triggers have status = MLME_SUCCESS and they are still
interesting. E.g. if we want to collect data upon deauth,
the status will be MLME_SUCCESS. Fix that.

Fixes: d42f53503406 ("iwlwifi: mvm: add trigger for firmware dump upon MLME failures")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 40265b9..dda9f7b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3995,9 +3995,6 @@ static void iwl_mvm_mac_event_callback(struct ieee80211_hw *hw,
 	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_MLME))
 		return;
 
-	if (event->u.mlme.status == MLME_SUCCESS)
-		return;
-
 	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_MLME);
 	trig_mlme = (void *)trig->data;
 	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
-- 
2.1.4

