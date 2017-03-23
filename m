Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50650 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932813AbdCWKkY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Mar 2017 06:40:24 -0400
Date: Thu, 23 Mar 2017 13:40:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes.berg@intel.com>,
        Golan Ben-Ami <golan.ben.ami@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sara Sharon <sara.sharon@intel.com>,
        Ido Yariv <ido@wizery.com>, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] iwlwifi: mvm: writing zero bytes to debugfs causes a crash
Message-ID: <20170323104000.GB20154@mwanda> (sfid-20170323_114032_193280_6FB7E507)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a static analysis fix.  The warning is:

	drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c:912 iwl_mvm_fw_dbg_collect()
	warn: integer overflows 'sizeof(*desc) + len'

I guess this code is supposed to take a NUL character, but if we write
zero bytes then it tries to write -1 characters and crashes.

Fixes: c91b865cb14d ("iwlwifi: mvm: support description for user triggered fw dbg collection")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index a260cd503200..077bfd8f4c0c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1056,6 +1056,8 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 
 	if (ret)
 		return ret;
+	if (count == 0)
+		return 0;
 
 	iwl_mvm_fw_dbg_collect(mvm, FW_DBG_TRIGGER_USER, buf,
 			       (count - 1), NULL);
