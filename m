Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:40785 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaLBSLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:35 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so17765758wgg.35
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:33 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/26] iwlwifi: mvm: add missing mvm ref debug print
Date: Tue,  2 Dec 2014 20:10:59 +0200
Message-Id: <1417543877-24193-8-git-send-email-egrumbach@gmail.com> (sfid-20141202_191143_371316_73A21553)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

IWL_MVM_REF_PROTECT_CSA is missing from the ref strings
used by debugfs.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 5a0f104..33bf915 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1339,6 +1339,7 @@ static ssize_t iwl_dbgfs_d0i3_refs_read(struct file *file,
 	PRINT_MVM_REF(IWL_MVM_REF_NMI);
 	PRINT_MVM_REF(IWL_MVM_REF_TM_CMD);
 	PRINT_MVM_REF(IWL_MVM_REF_EXIT_WORK);
+	PRINT_MVM_REF(IWL_MVM_REF_PROTECT_CSA);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
-- 
1.9.1

