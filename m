Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36328 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751757AbdAWWTR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:19:17 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com
Date: Tue, 24 Jan 2017 00:03:47 +0200
Message-Id: <20170123220350.25305-23-luca@coelho.fi> (sfid-20170123_233339_332504_936E54D3)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 22/25] iwlwifi: dvm: remove unused variable compiler warning in debugfs.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

When compiling with W=1, we get the following warning in debugfs.c:

/home/luca/iwlwifi/stack-dev/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c: In function ‘iwl_dbgfs_fw_restart_write’:
/home/luca/iwlwifi/stack-dev/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c:2313:6: warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
  int ret;
      ^

Fix it by ignoring the return value in this case.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index affe760c8c22..376c79337a0e 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -2310,7 +2310,7 @@ static ssize_t iwl_dbgfs_fw_restart_write(struct file *file,
 {
 	struct iwl_priv *priv = file->private_data;
 	bool restart_fw = iwlwifi_mod_params.restart_fw;
-	int ret;
+	int __maybe_unused ret;
 
 	iwlwifi_mod_params.restart_fw = true;
 
-- 
2.11.0
