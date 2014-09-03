Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:32781 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaICT4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:43 -0400
Received: by mail-we0-f181.google.com with SMTP id x48so9039534wes.26
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:41 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/36] iwlwifi: mvm: fix the dump_umac_error_log
Date: Wed,  3 Sep 2014 22:55:57 +0300
Message-Id: <1409774184-24665-9-git-send-email-egrumbach@gmail.com> (sfid-20140903_215647_578441_DC9508B2)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

1. the base_address limitation was wrong, address can be bigger than
0x80C000
2. the ucode data_struct changed.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/utils.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index ac249da..20fdca4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -387,15 +387,19 @@ struct iwl_error_event_table {
 struct iwl_umac_error_event_table {
 	u32 valid;		/* (nonzero) valid, (0) log is empty */
 	u32 error_id;		/* type of error */
-	u32 pc;			/* program counter */
 	u32 blink1;		/* branch link */
 	u32 blink2;		/* branch link */
 	u32 ilink1;		/* interrupt link */
 	u32 ilink2;		/* interrupt link */
 	u32 data1;		/* error-specific data */
 	u32 data2;		/* error-specific data */
-	u32 line;		/* source code line of error */
-	u32 umac_ver;		/* umac version */
+	u32 data3;		/* error-specific data */
+	u32 umac_fw_ver;	/* UMAC version */
+	u32 umac_fw_api_ver;	/* UMAC FW API ver */
+	u32 frame_pointer;	/* core register 27*/
+	u32 stack_pointer;	/* core register 28 */
+	u32 cmd_header;	/* latest host cmd sent to UMAC */
+	u32 nic_isr_pref;	/* ISR status register */
 } __packed;
 
 #define ERROR_START_OFFSET  (1 * sizeof(u32))
@@ -409,7 +413,7 @@ static void iwl_mvm_dump_umac_error_log(struct iwl_mvm *mvm)
 
 	base = mvm->umac_error_event_table;
 
-	if (base < 0x800000 || base >= 0x80C000) {
+	if (base < 0x800000) {
 		IWL_ERR(mvm,
 			"Not valid error log pointer 0x%08X for %s uCode\n",
 			base,
@@ -428,14 +432,19 @@ static void iwl_mvm_dump_umac_error_log(struct iwl_mvm *mvm)
 
 	IWL_ERR(mvm, "0x%08X | %-28s\n", table.error_id,
 		desc_lookup(table.error_id));
-	IWL_ERR(mvm, "0x%08X | umac uPc\n", table.pc);
 	IWL_ERR(mvm, "0x%08X | umac branchlink1\n", table.blink1);
 	IWL_ERR(mvm, "0x%08X | umac branchlink2\n", table.blink2);
 	IWL_ERR(mvm, "0x%08X | umac interruptlink1\n", table.ilink1);
 	IWL_ERR(mvm, "0x%08X | umac interruptlink2\n", table.ilink2);
 	IWL_ERR(mvm, "0x%08X | umac data1\n", table.data1);
 	IWL_ERR(mvm, "0x%08X | umac data2\n", table.data2);
-	IWL_ERR(mvm, "0x%08X | umac version\n", table.umac_ver);
+	IWL_ERR(mvm, "0x%08X | umac data3\n", table.data3);
+	IWL_ERR(mvm, "0x%08X | umac version\n", table.umac_fw_ver);
+	IWL_ERR(mvm, "0x%08X | umac api version\n", table.umac_fw_api_ver);
+	IWL_ERR(mvm, "0x%08X | frame pointer\n", table.frame_pointer);
+	IWL_ERR(mvm, "0x%08X | stack pointer\n", table.stack_pointer);
+	IWL_ERR(mvm, "0x%08X | last host cmd\n", table.cmd_header);
+	IWL_ERR(mvm, "0x%08X | isr status reg\n", table.nic_isr_pref);
 }
 
 void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
-- 
1.9.1

