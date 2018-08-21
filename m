Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42740 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726253AbeHUI3Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 04:29:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 08:09:49 +0300
Message-Id: <20180821050952.31603-15-luca@coelho.fi> (sfid-20180821_071045_311960_EDA142DF)
In-Reply-To: <20180821050952.31603-1-luca@coelho.fi>
References: <20180821050952.31603-1-luca@coelho.fi>
Subject: [PATCH v2 14/17] iwlwifi: enable reading the value of delay in timestamp_marker cmd
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

The user can validate what was written to the file by reading it,
and check what is the default value before changing it.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index 2dd534b474b8..c1f087c50cc9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -251,7 +251,15 @@ static ssize_t iwl_dbgfs_timestamp_marker_write(struct iwl_fw_runtime *fwrt,
 	return count;
 }
 
-FWRT_DEBUGFS_WRITE_FILE_OPS(timestamp_marker, 10);
+static ssize_t iwl_dbgfs_timestamp_marker_read(struct iwl_fw_runtime *fwrt,
+					       size_t size, char *buf)
+{
+	u32 delay_secs = jiffies_to_msecs(fwrt->timestamp.delay) / 1000;
+
+	return scnprintf(buf, size, "%d\n", delay_secs);
+}
+
+FWRT_DEBUGFS_READ_WRITE_FILE_OPS(timestamp_marker, 16);
 
 int iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
 			    struct dentry *dbgfs_dir)
-- 
2.18.0
