Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34428 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753513AbdFVVWe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:22:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:21:00 +0300
Message-Id: <20170622212101.16422-25-luca@coelho.fi> (sfid-20170622_232240_770950_46676928)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 24/25] iwlwifi: pcie: use kstrtou32_from_user()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use kstrtou32_from_user() in debugfs instead of open-coding it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 280b14ace175..67343b10b0da 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2428,17 +2428,12 @@ static ssize_t iwl_dbgfs_interrupt_write(struct file *file,
 	struct iwl_trans *trans = file->private_data;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
-
-	char buf[8];
-	int buf_size;
 	u32 reset_flag;
+	int ret;
 
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%x", &reset_flag) != 1)
-		return -EFAULT;
+	ret = kstrtou32_from_user(user_buf, count, 16, &reset_flag);
+	if (ret)
+		return ret;
 	if (reset_flag == 0)
 		memset(isr_stats, 0, sizeof(*isr_stats));
 
-- 
2.11.0
