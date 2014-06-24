Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:48223 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaFXTxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:53:08 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so901077wes.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:53:06 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/27] iwlwifi: mvm: handle device start failures during restart
Date: Tue, 24 Jun 2014 22:52:21 +0300
Message-Id: <1403639541-4621-27-git-send-email-egrumbach@gmail.com> (sfid-20140624_220201_353101_54A5E985)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the device fails during a restart, mac80211 now handles the
situation better but we still have a little bit of cleanup to
do in the driver - add the required code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: ArikX Nemtsov <arik@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index f2fde36..3c2c9b9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -689,6 +689,16 @@ static int iwl_mvm_mac_start(struct ieee80211_hw *hw)
 		iwl_mvm_restart_cleanup(mvm);
 
 	ret = iwl_mvm_up(mvm);
+
+	if (ret && test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+		/* Something went wrong - we need to finish some cleanup
+		 * that normally iwl_mvm_mac_restart_complete() below
+		 * would do.
+		 */
+		clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
+		iwl_mvm_d0i3_enable_tx(mvm, NULL);
+	}
+
 	mutex_unlock(&mvm->mutex);
 
 	return ret;
-- 
1.8.3.2

