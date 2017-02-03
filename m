Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37994 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753381AbdBCOkI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:40:08 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:59 +0200
Message-Id: <20170203143812.7525-13-luca@coelho.fi> (sfid-20170203_154010_527980_A9A86517)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 12/25] iwlwifi: mvm: fix D3 replay counter value
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This fixes a long-standing bug that was introduced when this code
was introduced: cfg80211 passes a pointer, but we treat it as if
it was passing a value. The result is that we pass the pointer to
the firmware, instead of the value. It's not clear how this could
ever have worked, unless the firmware is ignoring this value.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index b02d7fc5116f..c7eb1983c4f9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -91,7 +91,7 @@ void iwl_mvm_set_rekey_data(struct ieee80211_hw *hw,
 	memcpy(mvmvif->rekey_data.kek, data->kek, NL80211_KEK_LEN);
 	memcpy(mvmvif->rekey_data.kck, data->kck, NL80211_KCK_LEN);
 	mvmvif->rekey_data.replay_ctr =
-		cpu_to_le64(be64_to_cpup((__be64 *)&data->replay_ctr));
+		cpu_to_le64(be64_to_cpup((__be64 *)data->replay_ctr));
 	mvmvif->rekey_data.valid = true;
 
 	mutex_unlock(&mvm->mutex);
-- 
2.11.0
