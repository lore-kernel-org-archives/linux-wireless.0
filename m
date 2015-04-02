Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40007 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbbDBGm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:29 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/31] iwlwifi: mvm: don't return uninitialized value in get_survey()
Date: Thu,  2 Apr 2015 09:41:15 +0300
Message-Id: <1427956879-11725-27-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090418_657527_F3815DAA)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If ucode_loaded isn't true the function returns the 'ret' variable
without having assigned a value properly. Fix that.

Reported-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index fc73cc1..74912e7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3911,6 +3911,7 @@ static int iwl_mvm_mac_get_survey(struct ieee80211_hw *hw, int idx,
 			    mvm->radio_stats.on_time_scan;
 	do_div(survey->time_scan, USEC_PER_MSEC);
 
+	ret = 0;
  out:
 	mutex_unlock(&mvm->mutex);
 	return ret;
-- 
1.9.1

