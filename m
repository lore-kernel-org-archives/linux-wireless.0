Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964928AbbBCHOu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:14:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	<stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/19] iwlwifi: mvm: always use mac color zero
Date: Tue,  3 Feb 2015 09:14:23 +0200
Message-Id: <1422947678-16917-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081454_099163_183C3782)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We don't really need to use different mac colors when adding mac
contexts, because they're not used anywhere.  In fact, the firmware
doesn't accept 255 as a valid color, so we get into a SYSASSERT 0x3401
when we reach that.

Remove the color increment to use always zero and avoid reaching 255.

CC: <stable@vger.kernel.org> [3.10+]
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index cef6f33..cfd7bfc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -707,9 +707,6 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 	mvmvif->uploaded = false;
 	mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
 
-	/* does this make sense at all? */
-	mvmvif->color++;
-
 	spin_lock_bh(&mvm->time_event_lock);
 	iwl_mvm_te_clear_data(mvm, &mvmvif->time_event_data);
 	spin_unlock_bh(&mvm->time_event_lock);
-- 
1.9.1

