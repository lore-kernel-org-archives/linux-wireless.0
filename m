Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37179 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbYJNTel (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 15:34:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwlwifi: expand error lookup and align output
Date: Tue, 14 Oct 2008 12:32:42 -0700
Message-Id: <1224012769-8920-3-git-send-email-reinette.chatre@intel.com> (sfid-20081014_213445_459212_42E3F2CE)
In-Reply-To: <1224012769-8920-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1224012769-8920-1-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

change desc_lookup from hard coded switch to a simple lookup table and expand
list to include all errors.  Also corrected output using this string so info
is aligned and easier to read when debugging issues.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   57 +++++++++++++++++++++---------
 1 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4c312c5..f0055b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1169,24 +1169,47 @@ int iwl_verify_ucode(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_verify_ucode);
 
+
+static const char *desc_lookup_text[] = {
+	"OK",
+	"FAIL",
+	"BAD_PARAM",
+	"BAD_CHECKSUM",
+	"NMI_INTERRUPT_WDG",
+	"SYSASSERT",
+	"FATAL_ERROR",
+	"BAD_COMMAND",
+	"HW_ERROR_TUNE_LOCK",
+	"HW_ERROR_TEMPERATURE",
+	"ILLEGAL_CHAN_FREQ",
+	"VCC_NOT_STABLE",
+	"FH_ERROR",
+	"NMI_INTERRUPT_HOST",
+	"NMI_INTERRUPT_ACTION_PT",
+	"NMI_INTERRUPT_UNKNOWN",
+	"UCODE_VERSION_MISMATCH",
+	"HW_ERROR_ABS_LOCK",
+	"HW_ERROR_CAL_LOCK_FAIL",
+	"NMI_INTERRUPT_INST_ACTION_PT",
+	"NMI_INTERRUPT_DATA_ACTION_PT",
+	"NMI_TRM_HW_ER",
+	"NMI_INTERRUPT_TRM",
+	"NMI_INTERRUPT_BREAK_POINT"
+	"DEBUG_0",
+	"DEBUG_1",
+	"DEBUG_2",
+	"DEBUG_3",
+	"UNKNOWN"
+};
+
 static const char *desc_lookup(int i)
 {
-	switch (i) {
-	case 1:
-		return "FAIL";
-	case 2:
-		return "BAD_PARAM";
-	case 3:
-		return "BAD_CHECKSUM";
-	case 4:
-		return "NMI_INTERRUPT";
-	case 5:
-		return "SYSASSERT";
-	case 6:
-		return "FATAL_ERROR";
-	}
+	int max = ARRAY_SIZE(desc_lookup_text) - 1;
+
+	if (i < 0 || i > max)
+		i = max;
 
-	return "UNKNOWN";
+	return desc_lookup_text[i];
 }
 
 #define ERROR_START_OFFSET  (1 * sizeof(u32))
@@ -1232,9 +1255,9 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	line = iwl_read_targ_mem(priv, base + 9 * sizeof(u32));
 	time = iwl_read_targ_mem(priv, base + 11 * sizeof(u32));
 
-	IWL_ERROR("Desc        Time       "
+	IWL_ERROR("Desc                               Time       "
 		"data1      data2      line\n");
-	IWL_ERROR("%-13s (#%d) %010u 0x%08X 0x%08X %u\n",
+	IWL_ERROR("%-28s (#%02d) %010u 0x%08X 0x%08X %u\n",
 		desc_lookup(desc), desc, time, data1, data2, line);
 	IWL_ERROR("blink1  blink2  ilink1  ilink2\n");
 	IWL_ERROR("0x%05X 0x%05X 0x%05X 0x%05X\n", blink1, blink2,
-- 
1.5.4.3

