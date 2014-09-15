Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:61906 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaIOFNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:31 -0400
Received: by mail-we0-f177.google.com with SMTP id u57so3338900wes.22
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:30 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/28] iwlwifi: mvm: update d0i3 debugfs
Date: Mon, 15 Sep 2014 08:12:50 +0300
Message-Id: <1410757980-2138-18-git-send-email-egrumbach@gmail.com> (sfid-20140915_073114_776624_8E71F953)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A lot of the newer d0i3 ref additions weren't added to the
debugfs file, fix that and add a comment to remember to do
it in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 12 ++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 85eb847..95eb9a5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1259,6 +1259,18 @@ static ssize_t iwl_dbgfs_d0i3_refs_read(struct file *file,
 	PRINT_MVM_REF(IWL_MVM_REF_P2P_CLIENT);
 	PRINT_MVM_REF(IWL_MVM_REF_AP_IBSS);
 	PRINT_MVM_REF(IWL_MVM_REF_USER);
+	PRINT_MVM_REF(IWL_MVM_REF_TX);
+	PRINT_MVM_REF(IWL_MVM_REF_TX_AGG);
+	PRINT_MVM_REF(IWL_MVM_REF_ADD_IF);
+	PRINT_MVM_REF(IWL_MVM_REF_START_AP);
+	PRINT_MVM_REF(IWL_MVM_REF_BSS_CHANGED);
+	PRINT_MVM_REF(IWL_MVM_REF_PREPARE_TX);
+	PRINT_MVM_REF(IWL_MVM_REF_PROTECT_TDLS);
+	PRINT_MVM_REF(IWL_MVM_REF_CHECK_CTKILL);
+	PRINT_MVM_REF(IWL_MVM_REF_PRPH_READ);
+	PRINT_MVM_REF(IWL_MVM_REF_PRPH_WRITE);
+	PRINT_MVM_REF(IWL_MVM_REF_NMI);
+	PRINT_MVM_REF(IWL_MVM_REF_TM_CMD);
 	PRINT_MVM_REF(IWL_MVM_REF_EXIT_WORK);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index f05b7d7..4b1db9a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -274,6 +274,8 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_TM_CMD,
 	IWL_MVM_REF_EXIT_WORK,
 
+	/* update debugfs.c when changing this */
+
 	IWL_MVM_REF_COUNT,
 };
 
-- 
1.9.1

