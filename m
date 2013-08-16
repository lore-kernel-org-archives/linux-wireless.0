Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3HPLHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:07:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH 01/20] iwlwifi: mvm: Fix beacon filtering enablement via debugfs
Date: Fri, 16 Aug 2013 13:06:51 +0200
Message-Id: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130721_151699_34109652)
In-Reply-To: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

The code was only enabling it when already enabled, which
obviously can't work.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 2ee256d..3cdc005 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -895,10 +895,7 @@ static ssize_t iwl_dbgfs_bf_params_write(struct file *file,
 	if (param == MVM_DEBUGFS_BF_ENABLE_BEACON_FILTER && !value) {
 		ret = iwl_mvm_disable_beacon_filter(mvm, vif);
 	} else {
-		if (mvmvif->bf_enabled)
-			ret = iwl_mvm_enable_beacon_filter(mvm, vif);
-		else
-			ret = iwl_mvm_disable_beacon_filter(mvm, vif);
+		ret = iwl_mvm_enable_beacon_filter(mvm, vif);
 	}
 	mutex_unlock(&mvm->mutex);
 
-- 
1.8.4.rc2

