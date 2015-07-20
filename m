Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:32482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbbGTTnT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 15:43:19 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: sara.sharon@intel.com,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 04/10] iwlwifi: mvm: don't adverise SUPPORTS_CLONED_SKBS anymore
Date: Mon, 20 Jul 2015 22:42:58 +0300
Message-Id: <1437421384-19884-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150720_214335_135805_2A0B5FE4)
In-Reply-To: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the upcoming patches, iwlmvm will mangle the SKBs if
receives from mac80211, so we can't support
SUPPORTS_CLONED_SKBS anymore.
The next patches introduce support for LSO and the
segmentation will be done while re-using the original SKB
sent by mac80211.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index f5c508a..a5bebbb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -435,7 +435,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, CONNECTION_MONITOR);
 	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
-	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
 
 	hw->queues = mvm->first_agg_queue;
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
-- 
2.1.4

