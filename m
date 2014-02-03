Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:53394 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaBCU7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:37 -0500
Received: by mail-ea0-f178.google.com with SMTP id a15so4064766eae.9
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:36 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 49/62] iwlwifi: mvm: support multiple firmware sections
Date: Mon,  3 Feb 2014 22:57:55 +0200
Message-Id: <1391461088-8082-49-git-send-email-egrumbach@gmail.com> (sfid-20140203_220010_708148_D0D3D0FF)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Newer devices have two embedded CPUs, and the firwmare for
both of them is include in the .ucode file requested upon
enumeration.
An empty section with address=0xFFFFCCCC separates between
the sections intended for cpu1 and the sections intended
for cpu2.
Update the driver to parse the .ucode file with this format
and act accordingly.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h     |    3 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c |   69 +++++++++++++++++++----------
 2 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index b0090e8..f80ba58 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -164,8 +164,7 @@ enum iwl_ucode_sec {
  * For 16.0 uCode and above, there is no differentiation between sections,
  * just an offset to the HW address.
  */
-#define IWL_UCODE_SECTION_MAX 6
-#define IWL_UCODE_FIRST_SECTION_OF_SECOND_CPU	(IWL_UCODE_SECTION_MAX/2)
+#define IWL_UCODE_SECTION_MAX 12
 
 struct iwl_ucode_capabilities {
 	u32 max_probe_length;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 61ae1af..84d4712 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -89,6 +89,7 @@ static void iwl_pcie_set_pwr(struct iwl_trans *trans, bool vaux)
 
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
+#define CPU1_CPU2_SEPARATOR_SECTION	0xFFFFCCCC
 
 static void iwl_pcie_apm_config(struct iwl_trans *trans)
 {
@@ -443,26 +444,33 @@ static int iwl_pcie_load_section(struct iwl_trans *trans, u8 section_num,
 
 static int iwl_pcie_load_cpu_secured_sections(struct iwl_trans *trans,
 					      const struct fw_img *image,
-					      int cpu)
+					      int cpu,
+					      int *first_ucode_section)
 {
 	int shift_param;
-	u32 first_idx, last_idx;
 	int i, ret = 0;
+	u32 last_read_idx = 0;
 
 	if (cpu == 1) {
 		shift_param = 0;
-		first_idx = 0;
-		last_idx = 2;
+		*first_ucode_section = 0;
 	} else {
 		shift_param = 16;
-		first_idx = 3;
-		last_idx = 5;
+		(*first_ucode_section)++;
 	}
 
-	for (i = first_idx; i <= last_idx; i++) {
-		if (!image->sec[i].data)
+	for (i = *first_ucode_section; i < IWL_UCODE_SECTION_MAX; i++) {
+		last_read_idx = i;
+
+		if (!image->sec[i].data ||
+		    image->sec[i].offset == CPU1_CPU2_SEPARATOR_SECTION) {
+			IWL_DEBUG_FW(trans,
+				     "Break since Data not valid or Empty section, sec = %d\n",
+				     i);
 			break;
-		if (i == first_idx + 1)
+		}
+
+		if (i == (*first_ucode_section) + 1)
 			/* set CPU to started */
 			iwl_set_bits_prph(trans,
 					  CSR_UCODE_LOAD_STATUS_ADDR,
@@ -478,30 +486,39 @@ static int iwl_pcie_load_cpu_secured_sections(struct iwl_trans *trans,
 			  CSR_UCODE_LOAD_STATUS_ADDR,
 			  LMPM_CPU_UCODE_LOADING_COMPLETED << shift_param);
 
+	*first_ucode_section = last_read_idx;
+
 	return 0;
 }
 
 static int iwl_pcie_load_cpu_sections(struct iwl_trans *trans,
 				      const struct fw_img *image,
-				      int cpu)
+				      int cpu,
+				      int *first_ucode_section)
 {
 	int shift_param;
-	u32 first_idx, last_idx;
 	int i, ret = 0;
+	u32 last_read_idx = 0;
 
 	if (cpu == 1) {
 		shift_param = 0;
-		first_idx = 0;
-		last_idx = 1;
+		*first_ucode_section = 0;
 	} else {
 		shift_param = 16;
-		first_idx = 2;
-		last_idx = 3;
+		(*first_ucode_section)++;
 	}
 
-	for (i = first_idx; i <= last_idx; i++) {
-		if (!image->sec[i].data)
+	for (i = *first_ucode_section; i < IWL_UCODE_SECTION_MAX; i++) {
+		last_read_idx = i;
+
+		if (!image->sec[i].data ||
+		    image->sec[i].offset == CPU1_CPU2_SEPARATOR_SECTION) {
+			IWL_DEBUG_FW(trans,
+				     "Break since Data not valid or Empty section, sec = %d\n",
+				     i);
 			break;
+		}
+
 		ret = iwl_pcie_load_section(trans, i, &image->sec[i]);
 		if (ret)
 			return ret;
@@ -515,6 +532,8 @@ static int iwl_pcie_load_cpu_sections(struct iwl_trans *trans,
 				   LMPM_CPU_UCODE_LOADING_STARTED) <<
 					shift_param);
 
+	*first_ucode_section = last_read_idx;
+
 	return 0;
 }
 
@@ -522,6 +541,7 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 				const struct fw_img *image)
 {
 	int ret = 0;
+	int first_ucode_section;
 
 	IWL_DEBUG_FW(trans,
 		     "working with %s image\n",
@@ -547,13 +567,15 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 			       LMPM_SECURE_CPU1_HDR_MEM_SPACE);
 
 		/* load to FW the binary Secured sections of CPU1 */
-		ret = iwl_pcie_load_cpu_secured_sections(trans, image, 1);
+		ret = iwl_pcie_load_cpu_secured_sections(trans, image, 1,
+							 &first_ucode_section);
 		if (ret)
 			return ret;
 
 	} else {
 		/* load to FW the binary Non secured sections of CPU1 */
-		ret = iwl_pcie_load_cpu_sections(trans, image, 1);
+		ret = iwl_pcie_load_cpu_sections(trans, image, 1,
+						 &first_ucode_section);
 		if (ret)
 			return ret;
 	}
@@ -566,11 +588,12 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 
 		/* load to FW the binary sections of CPU2 */
 		if (image->is_secure)
-			ret = iwl_pcie_load_cpu_secured_sections(trans,
-								 image,
-								 2);
+			ret = iwl_pcie_load_cpu_secured_sections(
+							trans, image, 2,
+							&first_ucode_section);
 		else
-			ret = iwl_pcie_load_cpu_sections(trans, image, 2);
+			ret = iwl_pcie_load_cpu_sections(trans, image, 2,
+							 &first_ucode_section);
 		if (ret)
 			return ret;
 	}
-- 
1.7.9.5

