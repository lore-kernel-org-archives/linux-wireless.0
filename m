Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50148 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S943508AbcJSOzL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 10:55:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 10:27:21 +0300
Message-Id: <20161019072726.22018-3-luca@coelho.fi> (sfid-20161019_165529_856153_3B701361)
In-Reply-To: <20161019072726.22018-1-luca@coelho.fi>
References: <20161019072726.22018-1-luca@coelho.fi>
Subject: [PATCH 2/7] iwlwifi: mvm: use ssize_t for len in iwl_debugfs_mem_read()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

In iwl_dbgfs_mem_read(), the len variable may become negative and is
compared to < 0 (an error case).  Comparing size_t (which is unsigned)
to < 0 causes a warning on certain platforms (like i386):

drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c:1561:5-8: WARNING: Unsigned expression compared with zero: len < 0

To prevent that, use ssize_t for len instead.

Fixes: commit 2b55f43f8e47 ("iwlwifi: mvm: Add mem debugfs entry")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 539d718..06805a6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1529,8 +1529,8 @@ static ssize_t iwl_dbgfs_mem_read(struct file *file, char __user *user_buf,
 		.data = { &cmd, },
 		.len = { sizeof(cmd) },
 	};
-	size_t delta, len;
-	ssize_t ret;
+	size_t delta;
+	ssize_t ret, len;
 
 	hcmd.id = iwl_cmd_id(*ppos >> 24 ? UMAC_RD_WR : LMAC_RD_WR,
 			     DEBUG_GROUP, 0);
-- 
2.9.3
