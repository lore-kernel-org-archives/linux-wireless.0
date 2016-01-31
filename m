Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:9395 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272AbcAaLGm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:42 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/31] iwlwifi: mvm: fix debugfs signedness warning
Date: Sun, 31 Jan 2016 13:06:09 +0200
Message-Id: <1454238386-27032-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_120654_108025_C69E99A6)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using kstrtouint() with a signed int isn't really right,
use kstrotoint() instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 90500e2..8059efa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -983,7 +983,7 @@ static ssize_t iwl_dbgfs_cont_recording_write(struct iwl_mvm *mvm,
 	    trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		return -EOPNOTSUPP;
 
-	ret = kstrtouint(buf, 0, &rec_mode);
+	ret = kstrtoint(buf, 0, &rec_mode);
 	if (ret)
 		return ret;
 
-- 
2.5.0

