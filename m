Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbbHRH61 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:27 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/26] iwlwifi: mvm: fix a range check in debugfs code
Date: Tue, 18 Aug 2015 10:57:29 +0300
Message-Id: <1439884656-18146-19-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100108_341035_91690293)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

The &mvm->tof_data.range_req.ap[] array has IWL_MVM_TOF_MAX_APS elements
so the check should be >= instead of >.  Also the test can underflow so
I have changed "i" to unsigned.

Fixes: ce7929186a39 ('wlwifi: mvm: add basic Time of Flight (802.11mc FTM) support')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index ddb1c84..383a316 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -911,9 +911,9 @@ static ssize_t iwl_dbgfs_tof_range_request_write(struct ieee80211_vif *vif,
 		int size = sizeof(struct iwl_tof_range_req_ap_entry);
 		u16 burst_period;
 		u8 *mac = ap.bssid;
-		int i;
+		unsigned int i;
 
-		if (sscanf(data, "%d %hhd %hhx %hhx"
+		if (sscanf(data, "%u %hhd %hhx %hhx"
 			   "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx"
 			   "%hhx %hhx %hx"
 			   "%hhx %hhx %x"
@@ -929,7 +929,7 @@ static ssize_t iwl_dbgfs_tof_range_request_write(struct ieee80211_vif *vif,
 			ret = -EINVAL;
 			goto out;
 		}
-		if (i > IWL_MVM_TOF_MAX_APS) {
+		if (i >= IWL_MVM_TOF_MAX_APS) {
 			IWL_ERR(mvm, "Invalid AP index %d\n", i);
 			ret = -EINVAL;
 			goto out;
-- 
2.1.4

