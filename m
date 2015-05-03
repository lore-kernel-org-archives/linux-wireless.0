Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbbECTcj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:39 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/42] iwlwifi: mvm: iterate all interfaces during HW recovery cleanup
Date: Sun,  3 May 2015 22:31:30 +0300
Message-Id: <1430681513-7838-19-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213424_955961_77A751ED)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Usually during HW recovery the state of all active interfaces is cleaned
up during drv_start(). There's a special case where a HW restart is
requested when an interface is going down. In this case the iface-iterator
won't see this interface and we won't clean it. This has bad consequences
once the interface is legitimately brought up again.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 8d9e5da..eca1666 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1239,9 +1239,11 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	/* just in case one was running */
 	ieee80211_remain_on_channel_expired(mvm->hw);
 
-	ieee80211_iterate_active_interfaces_atomic(
-		mvm->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
-		iwl_mvm_cleanup_iterator, mvm);
+	/*
+	 * cleanup all interfaces, even inactive ones, as some might have
+	 * gone down during the HW restart
+	 */
+	ieee80211_iterate_interfaces(mvm->hw, 0, iwl_mvm_cleanup_iterator, mvm);
 
 	mvm->p2p_device_vif = NULL;
 	mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
-- 
2.1.0

