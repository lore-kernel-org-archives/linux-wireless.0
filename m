Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50549 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbbHXUAl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 16:00:41 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/6] iwlwifi: mvm: catch underflow error earlier
Date: Mon, 24 Aug 2015 23:00:32 +0300
Message-Id: <1440446437-29188-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150824_220044_364770_7BF08B55)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E827CB7@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E827CB7@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

My static checker complains that we don't check for underflows in
iwl_dbgfs_fw_dbg_conf_write().  This is harmless because we have a
sanity check in iwl_mvm_start_fw_dbg_conf(), but we may as well make
this unsigned and silence the underflow warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index ca4a1f8..7d69a55 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -949,9 +949,10 @@ static ssize_t iwl_dbgfs_fw_dbg_conf_write(struct iwl_mvm *mvm,
 					   char *buf, size_t count,
 					   loff_t *ppos)
 {
-	int ret, conf_id;
+	unsigned int conf_id;
+	int ret;
 
-	ret = kstrtoint(buf, 0, &conf_id);
+	ret = kstrtouint(buf, 0, &conf_id);
 	if (ret)
 		return ret;
 
-- 
2.1.4

