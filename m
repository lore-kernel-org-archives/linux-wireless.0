Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57204 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752502AbbJEPBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Assaf Krauss <assaf.krauss@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:42 +0300
Message-Id: <1444055820-27506-11-git-send-email-luca@coelho.fi> (sfid-20151005_170152_659607_7B31B61E)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 11/29] iwlwifi: mvm: Improve debugfs tof robustness
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

Return a proper error when wrong parameters are passed to debugfs
tof_range_request.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 15ab543..5dc1686 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -892,6 +892,7 @@ static ssize_t iwl_dbgfs_tof_range_request_write(struct ieee80211_vif *vif,
 			goto out;
 		}
 		memcpy(mvm->tof_data.range_req.macaddr_template, mac, ETH_ALEN);
+		goto out;
 	}
 
 	data = iwl_dbgfs_is_match("macaddr_mask=", buf);
@@ -903,11 +904,12 @@ static ssize_t iwl_dbgfs_tof_range_request_write(struct ieee80211_vif *vif,
 			goto out;
 		}
 		memcpy(mvm->tof_data.range_req.macaddr_mask, mac, ETH_ALEN);
+		goto out;
 	}
 
 	data = iwl_dbgfs_is_match("ap=", buf);
 	if (data) {
-		struct iwl_tof_range_req_ap_entry ap;
+		struct iwl_tof_range_req_ap_entry ap = {};
 		int size = sizeof(struct iwl_tof_range_req_ap_entry);
 		u16 burst_period;
 		u8 *mac = ap.bssid;
@@ -944,12 +946,12 @@ static ssize_t iwl_dbgfs_tof_range_request_write(struct ieee80211_vif *vif,
 	data = iwl_dbgfs_is_match("send_range_request=", buf);
 	if (data) {
 		ret = kstrtou32(data, 10, &value);
-		if (ret == 0 && value) {
+		if (ret == 0 && value)
 			ret = iwl_mvm_tof_range_request_cmd(mvm, vif);
-			goto out;
-		}
+		goto out;
 	}
 
+	ret = -EINVAL;
 out:
 	mutex_unlock(&mvm->mutex);
 	return ret ?: count;
@@ -1073,12 +1075,12 @@ static ssize_t iwl_dbgfs_tof_range_req_ext_write(struct ieee80211_vif *vif,
 	data = iwl_dbgfs_is_match("send_range_req_ext=", buf);
 	if (data) {
 		ret = kstrtou32(data, 10, &value);
-		if (ret == 0 && value) {
+		if (ret == 0 && value)
 			ret = iwl_mvm_tof_range_request_ext_cmd(mvm, vif);
-			goto out;
-		}
+		goto out;
 	}
 
+	ret = -EINVAL;
 out:
 	mutex_unlock(&mvm->mutex);
 	return ret ?: count;
-- 
2.5.3

