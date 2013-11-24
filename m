Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46927 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab3KXUHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:19 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so1193103wgh.17
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:17 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/29] iwlwifi: mvm: don't restart HW if suspending fails before D3 image is loaded
Date: Sun, 24 Nov 2013 22:06:39 +0200
Message-Id: <1385323606-3603-22-git-send-email-egrumbach@gmail.com> (sfid-20131124_210808_833039_52074912)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If we haven't loaded the D3 image yet and a failure in the suspend
process occurs, we shouldn't restart the HW, because we're still
running the D0 image.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 6964b84..16d9103 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1227,10 +1227,11 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	mvm->aux_sta.sta_id = old_aux_sta_id;
 	mvm_ap_sta->sta_id = old_ap_sta_id;
 	mvmvif->ap_sta_id = old_ap_sta_id;
- out_noreset:
-	kfree(key_data.rsc_tsc);
+
 	if (ret < 0)
 		ieee80211_restart_hw(mvm->hw);
+ out_noreset:
+	kfree(key_data.rsc_tsc);
 
 	mutex_unlock(&mvm->mutex);
 
-- 
1.7.9.5

