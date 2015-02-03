Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1162 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965181AbbBCHPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:15:11 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	<stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/19] iwlwifi: mvm: fix failure path when power_update fails in add_interface
Date: Tue,  3 Feb 2015 09:14:34 +0200
Message-Id: <1422947678-16917-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081517_235004_CA6429A2)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

When iwl_mvm_power_update_mac() is called, we have already added the
mac context, so if this call fails we should remove the mac.

CC: <stable@vger.kernel.org> [3.15+]
Fixes: commit e5e7aa8e2561 ('iwlwifi: mvm: refactor power code')
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 51e02e6..1ff7ec0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1355,7 +1355,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 
 	ret = iwl_mvm_power_update_mac(mvm);
 	if (ret)
-		goto out_release;
+		goto out_remove_mac;
 
 	/* beacon filtering */
 	ret = iwl_mvm_disable_beacon_filter(mvm, vif, 0);
-- 
1.9.1

