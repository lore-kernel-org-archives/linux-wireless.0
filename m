Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39269 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbbDBGm1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:27 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/31] iwlwifi: mvm: remove unused arguments
Date: Thu,  2 Apr 2015 09:41:13 +0300
Message-Id: <1427956879-11725-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090419_457036_34B8AB5D)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The str/len arguments to iwl_fw_dbg_trigger_simple_stop() aren't used,
and for a simple trigger don't really need to be used as the trigger
code itself encodes the reason, so remove them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 +--
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 0bd3373..810b6d3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3711,8 +3711,7 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(mvm, "pre CSA to freq %d\n",
 			   chsw->chandef.center_freq1);
 
-	iwl_fw_dbg_trigger_simple_stop(mvm, vif, FW_DBG_TRIGGER_CHANNEL_SWITCH,
-				       NULL, 0);
+	iwl_fw_dbg_trigger_simple_stop(mvm, vif, FW_DBG_TRIGGER_CHANNEL_SWITCH);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index a3f2078..500064f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1516,8 +1516,7 @@ iwl_fw_dbg_trigger_check_stop(struct iwl_mvm *mvm,
 static inline void
 iwl_fw_dbg_trigger_simple_stop(struct iwl_mvm *mvm,
 			       struct ieee80211_vif *vif,
-			       enum iwl_fw_dbg_trigger trig,
-			       const char *str, size_t len)
+			       enum iwl_fw_dbg_trigger trig)
 {
 	struct iwl_fw_dbg_trigger_tlv *trigger;
 
@@ -1528,7 +1527,7 @@ iwl_fw_dbg_trigger_simple_stop(struct iwl_mvm *mvm,
 	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trigger))
 		return;
 
-	iwl_mvm_fw_dbg_collect_trig(mvm, trigger, str, len);
+	iwl_mvm_fw_dbg_collect_trig(mvm, trigger, NULL, 0);
 }
 
 #endif /* __IWL_MVM_H__ */
-- 
1.9.1

