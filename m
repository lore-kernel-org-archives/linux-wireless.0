Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4385 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbbFCHb5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:31:57 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/15] iwlwifi: mvm: enable IEEE80211_HW_SUPPORT_FAST_XMIT
Date: Wed,  3 Jun 2015 10:31:29 +0300
Message-Id: <1433316696-4612-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093205_191521_715CCBA6)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the firmware is responsible for duration calculation, the
driver can easily support fast-xmit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 9e517e2..57d75d1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -428,6 +428,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		    IEEE80211_HW_TIMING_BEACON_ONLY |
 		    IEEE80211_HW_CONNECTION_MONITOR |
 		    IEEE80211_HW_CHANCTX_STA_CSA |
+		    IEEE80211_HW_SUPPORT_FAST_XMIT |
 		    IEEE80211_HW_SUPPORTS_CLONED_SKBS;
 
 	hw->queues = mvm->first_agg_queue;
-- 
2.1.4

