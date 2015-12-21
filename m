Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbbLUUwg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:36 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 39/45] iwlwifi: mvm: dump more registers upon error
Date: Mon, 21 Dec 2015 22:50:40 +0200
Message-Id: <1450731046-2796-39-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220100_962801_BC0A7846)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These registers can help to debug PHY issues. Since this
adds a significant amount of work to the debug collection
phase, dump the periphery registers only if the firmware
is stopped.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 29 ++++++++++++++-----------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index a6985da..29d54ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -349,6 +349,7 @@ static const struct {
 	{ .start = 0x00a04560, .end = 0x00a0457c },
 	{ .start = 0x00a04590, .end = 0x00a04598 },
 	{ .start = 0x00a045c0, .end = 0x00a045f4 },
+	{ .start = 0x00a44000, .end = 0x00a7bf80 },
 };
 
 static u32 iwl_dump_prph(struct iwl_trans *trans,
@@ -400,7 +401,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	struct iwl_fw_error_dump_trigger_desc *dump_trig;
 	struct iwl_mvm_dump_ptrs *fw_error_dump;
 	u32 sram_len, sram_ofs;
-	u32 file_len, fifo_data_len = 0;
+	u32 file_len, fifo_data_len = 0, prph_len = 0;
 	u32 smem_len = mvm->cfg->smem_len;
 	u32 sram2_len = mvm->cfg->dccm2_len;
 	bool monitor_dump_only = false;
@@ -460,12 +461,24 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 					 sizeof(*dump_data) +
 					 sizeof(struct iwl_fw_error_dump_fifo);
 		}
+
+		/* Make room for PRPH registers */
+		for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
+			/* The range includes both boundaries */
+			int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
+				iwl_prph_dump_addr[i].start + 4;
+
+			prph_len += sizeof(*dump_data) +
+				sizeof(struct iwl_fw_error_dump_prph) +
+				num_bytes_in_chunk;
+		}
 	}
 
 	file_len = sizeof(*dump_file) +
 		   sizeof(*dump_data) * 2 +
 		   sram_len + sizeof(*dump_mem) +
 		   fifo_data_len +
+		   prph_len +
 		   sizeof(*dump_info);
 
 	/* Make room for the SMEM, if it exists */
@@ -489,17 +502,6 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 			   sizeof(*dump_info);
 	}
 
-	/* Make room for PRPH registers */
-	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
-		/* The range includes both boundaries */
-		int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
-			iwl_prph_dump_addr[i].start + 4;
-
-		file_len += sizeof(*dump_data) +
-			sizeof(struct iwl_fw_error_dump_prph) +
-			num_bytes_in_chunk;
-	}
-
 	/*
 	 * In 8000 HW family B-step include the ICCM (which resides separately)
 	 */
@@ -625,7 +627,8 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	}
 
 	dump_data = iwl_fw_error_next_data(dump_data);
-	iwl_dump_prph(mvm->trans, &dump_data);
+	if (prph_len)
+		iwl_dump_prph(mvm->trans, &dump_data);
 
 dump_trans_data:
 	fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans,
-- 
2.5.0

