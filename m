Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbbAVUdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:46 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/38] iwlwifi: mvm: make sure state isn't in d0i3 when stopping fw monitor
Date: Thu, 22 Jan 2015 22:32:57 +0200
Message-Id: <1421958809-3371-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213401_034107_B3F80734)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In case platform is in d0i3 - make sure it is awake when
writing the registers to stop the monitor when collecting FW
debug data. Plus, remove unneeded mutex locking currently
done.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index f89b795..afd1986 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -988,9 +988,14 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 					      char *buf, size_t count,
 					      loff_t *ppos)
 {
-	mutex_lock(&mvm->mutex);
+	int ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PRPH_WRITE);
+
+	if (ret)
+		return ret;
+
 	iwl_mvm_fw_dbg_collect(mvm);
-	mutex_unlock(&mvm->mutex);
+
+	iwl_mvm_unref(mvm, IWL_MVM_REF_PRPH_WRITE);
 
 	return count;
 }
-- 
1.9.1

