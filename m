Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbbHRH6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:09 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Assaf Krauss <assaf.krauss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/26] iwlwifi: mvm: ToF - Set correct range request cmd id
Date: Tue, 18 Aug 2015 10:57:21 +0300
Message-Id: <1439884656-18146-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_095814_787554_9B6437ED)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

Command ID of ToF range request command adapted to new FW commands grouping
scheme.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tof.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tof.c b/drivers/net/wireless/iwlwifi/mvm/tof.c
index d060e12..380972f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tof.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tof.c
@@ -194,7 +194,7 @@ int iwl_mvm_tof_range_request_cmd(struct iwl_mvm *mvm,
 				  struct ieee80211_vif *vif)
 {
 	struct iwl_host_cmd cmd = {
-		.id = TOF_CMD,
+		.id = iwl_cmd_id(TOF_CMD, IWL_ALWAYS_LONG_GROUP, 0),
 		.len = { sizeof(mvm->tof_data.range_req), },
 		/* no copy because of the command size */
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-- 
2.1.4

