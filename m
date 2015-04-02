Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbbDBGll (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:41 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/31] iwlwifi: mvm: remove d0i3 ref correctly during AP start
Date: Thu,  2 Apr 2015 09:40:57 +0300
Message-Id: <1427956879-11725-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_084144_733864_8A71BB03)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The AP_START d0i3 reference was never removed if the AP started correctly.
This has the unpleasant side-effect of preventing D0i3 on Android if the
WiFi hotspot was ever started on the device.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index a3a84d1..b4e28ff 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2215,8 +2215,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	if (iwl_mvm_phy_ctx_count(mvm) > 1)
 		iwl_mvm_teardown_tdls_peers(mvm);
 
-	mutex_unlock(&mvm->mutex);
-	return 0;
+	goto out_unlock;
 
 out_quota_failed:
 	iwl_mvm_power_update_mac(mvm);
-- 
1.9.1

