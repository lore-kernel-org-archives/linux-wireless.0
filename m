Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47767 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab3J3UcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 16:32:17 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6/9] iwlwifi: mvm: add missing break in debugfs
Date: Wed, 30 Oct 2013 22:31:34 +0200
Message-Id: <1383165097-4445-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131030_213221_082039_E4BD51FD)
In-Reply-To: <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
References: <527143AA.5070900@gmail.com>
 <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When writing the disable_power_off value, the LPRX
enable value also gets written unintentionally, so
fix that by adding the missing break statement.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 0675f0c..9864d71 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -342,6 +342,7 @@ static void iwl_dbgfs_update_pm(struct iwl_mvm *mvm,
 	case MVM_DEBUGFS_PM_DISABLE_POWER_OFF:
 		IWL_DEBUG_POWER(mvm, "disable_power_off=%d\n", val);
 		dbgfs_pm->disable_power_off = val;
+		break;
 	case MVM_DEBUGFS_PM_LPRX_ENA:
 		IWL_DEBUG_POWER(mvm, "lprx %s\n", val ? "enabled" : "disabled");
 		dbgfs_pm->lprx_ena = val;
-- 
1.8.3.2

