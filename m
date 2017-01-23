Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36320 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751757AbdAWWTM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:19:12 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com
Date: Tue, 24 Jan 2017 00:03:48 +0200
Message-Id: <20170123220350.25305-24-luca@coelho.fi> (sfid-20170123_233339_786784_23AB2972)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 23/25] iwlwifi: mvm: mark ret as maybe_unused in iwl_dbgfs_fw_restart_write()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The value returned from iwl_mvm_send_cmd_pdu() in this function is not
used and always returns an error (which is the whole point of the
call).  Tag the ret variable with __maybe_unused to avoid this compile
warning when W=1 is used:

/home/luca/iwlwifi/stack-dev/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c: In function ‘iwl_dbgfs_fw_restart_write’:
/home/luca/iwlwifi/stack-dev/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c:875:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
  int ret;
      ^

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 7b7d2a146e30..a260cd503200 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -798,7 +798,7 @@ static ssize_t iwl_dbgfs_drv_rx_stats_read(struct file *file,
 static ssize_t iwl_dbgfs_fw_restart_write(struct iwl_mvm *mvm, char *buf,
 					  size_t count, loff_t *ppos)
 {
-	int ret;
+	int __maybe_unused ret;
 
 	mutex_lock(&mvm->mutex);
 
-- 
2.11.0
