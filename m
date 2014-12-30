Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaL3OUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:07 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/33] iwlwifi: mvm: wait for d0i3 exit on hw restart
Date: Tue, 30 Dec 2014 16:18:55 +0200
Message-Id: <1419949148-24046-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154347_258875_7A74EA15)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

On hw restart, make sure to wait for d0i3 exit
(by checking the IN_D0I3 status bit).

This is needed in order to avoid the stale
d0i3_exit_work from doing harm (e.g. unref
cleared reference).

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 29f0feb..9ccecbc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -972,6 +972,19 @@ static int iwl_mvm_mac_start(struct ieee80211_hw *hw)
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
 
+	/* Some hw restart cleanups must not hold the mutex */
+	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+		/*
+		 * Make sure we are out of d0i3. This is needed
+		 * to make sure the reference accounting is correct
+		 * (and there is no stale d0i3_exit_work).
+		 */
+		wait_event_timeout(mvm->d0i3_exit_waitq,
+				   !test_bit(IWL_MVM_STATUS_IN_D0I3,
+					     &mvm->status),
+				   HZ);
+	}
+
 	mutex_lock(&mvm->mutex);
 	ret = __iwl_mvm_mac_start(mvm);
 	mutex_unlock(&mvm->mutex);
-- 
1.9.1

