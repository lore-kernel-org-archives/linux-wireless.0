Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:60345 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaIUTW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:27 -0400
Received: by mail-we0-f179.google.com with SMTP id u56so1908392wes.38
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:26 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>, Ido Yariv <idox.yariv@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/17] iwlwifi: mvm: support cloned tx skbs
Date: Sun, 21 Sep 2014 22:22:02 +0300
Message-Id: <1411327338-23099-1-git-send-email-egrumbach@gmail.com> (sfid-20140921_212230_462213_D60F05CC)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Since tx skbs are not modified by the driver, let mac80211 know the
driver can handle cloned skbs.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 4c21210..5f5a893 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -303,7 +303,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_TIMING_BEACON_ONLY |
 		    IEEE80211_HW_CONNECTION_MONITOR |
-		    IEEE80211_HW_CHANCTX_STA_CSA;
+		    IEEE80211_HW_CHANCTX_STA_CSA |
+		    IEEE80211_HW_SUPPORTS_CLONED_SKBS;
 
 	hw->queues = mvm->first_agg_queue;
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
-- 
1.9.1

