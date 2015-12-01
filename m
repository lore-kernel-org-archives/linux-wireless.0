Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbbLAJ7j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:39 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Golan Ben-Ami <golan.ben.ami@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/41] iwlwifi: dump prph registers in a common place for all transports
Date: Tue,  1 Dec 2015 11:58:47 +0200
Message-Id: <1448963947-24302-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105948_908042_86F67C8C)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

Currently the prph registers dump is in the transport layer,
and each bus needs an additional dump implementation.

Move the prph dump outside transport, and allow a common
implementation for all of the buses.
This is possible because prph base addresses are similar for
all buses.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 155 +++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   | 149 ---------------------
 2 files changed, 154 insertions(+), 150 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index f570c71..b83334f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1121,6 +1121,145 @@ void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm)
 #define IWL8260_ICCM_OFFSET		0x44000 /* Only for B-step */
 #define IWL8260_ICCM_LEN		0xC000 /* Only for B-step */
 
+static const struct {
+	u32 start, end;
+} iwl_prph_dump_addr[] = {
+	{ .start = 0x00a00000, .end = 0x00a00000 },
+	{ .start = 0x00a0000c, .end = 0x00a00024 },
+	{ .start = 0x00a0002c, .end = 0x00a0003c },
+	{ .start = 0x00a00410, .end = 0x00a00418 },
+	{ .start = 0x00a00420, .end = 0x00a00420 },
+	{ .start = 0x00a00428, .end = 0x00a00428 },
+	{ .start = 0x00a00430, .end = 0x00a0043c },
+	{ .start = 0x00a00444, .end = 0x00a00444 },
+	{ .start = 0x00a004c0, .end = 0x00a004cc },
+	{ .start = 0x00a004d8, .end = 0x00a004d8 },
+	{ .start = 0x00a004e0, .end = 0x00a004f0 },
+	{ .start = 0x00a00840, .end = 0x00a00840 },
+	{ .start = 0x00a00850, .end = 0x00a00858 },
+	{ .start = 0x00a01004, .end = 0x00a01008 },
+	{ .start = 0x00a01010, .end = 0x00a01010 },
+	{ .start = 0x00a01018, .end = 0x00a01018 },
+	{ .start = 0x00a01024, .end = 0x00a01024 },
+	{ .start = 0x00a0102c, .end = 0x00a01034 },
+	{ .start = 0x00a0103c, .end = 0x00a01040 },
+	{ .start = 0x00a01048, .end = 0x00a01094 },
+	{ .start = 0x00a01c00, .end = 0x00a01c20 },
+	{ .start = 0x00a01c58, .end = 0x00a01c58 },
+	{ .start = 0x00a01c7c, .end = 0x00a01c7c },
+	{ .start = 0x00a01c28, .end = 0x00a01c54 },
+	{ .start = 0x00a01c5c, .end = 0x00a01c5c },
+	{ .start = 0x00a01c60, .end = 0x00a01cdc },
+	{ .start = 0x00a01ce0, .end = 0x00a01d0c },
+	{ .start = 0x00a01d18, .end = 0x00a01d20 },
+	{ .start = 0x00a01d2c, .end = 0x00a01d30 },
+	{ .start = 0x00a01d40, .end = 0x00a01d5c },
+	{ .start = 0x00a01d80, .end = 0x00a01d80 },
+	{ .start = 0x00a01d98, .end = 0x00a01d9c },
+	{ .start = 0x00a01da8, .end = 0x00a01da8 },
+	{ .start = 0x00a01db8, .end = 0x00a01df4 },
+	{ .start = 0x00a01dc0, .end = 0x00a01dfc },
+	{ .start = 0x00a01e00, .end = 0x00a01e2c },
+	{ .start = 0x00a01e40, .end = 0x00a01e60 },
+	{ .start = 0x00a01e68, .end = 0x00a01e6c },
+	{ .start = 0x00a01e74, .end = 0x00a01e74 },
+	{ .start = 0x00a01e84, .end = 0x00a01e90 },
+	{ .start = 0x00a01e9c, .end = 0x00a01ec4 },
+	{ .start = 0x00a01ed0, .end = 0x00a01ee0 },
+	{ .start = 0x00a01f00, .end = 0x00a01f1c },
+	{ .start = 0x00a01f44, .end = 0x00a01ffc },
+	{ .start = 0x00a02000, .end = 0x00a02048 },
+	{ .start = 0x00a02068, .end = 0x00a020f0 },
+	{ .start = 0x00a02100, .end = 0x00a02118 },
+	{ .start = 0x00a02140, .end = 0x00a0214c },
+	{ .start = 0x00a02168, .end = 0x00a0218c },
+	{ .start = 0x00a021c0, .end = 0x00a021c0 },
+	{ .start = 0x00a02400, .end = 0x00a02410 },
+	{ .start = 0x00a02418, .end = 0x00a02420 },
+	{ .start = 0x00a02428, .end = 0x00a0242c },
+	{ .start = 0x00a02434, .end = 0x00a02434 },
+	{ .start = 0x00a02440, .end = 0x00a02460 },
+	{ .start = 0x00a02468, .end = 0x00a024b0 },
+	{ .start = 0x00a024c8, .end = 0x00a024cc },
+	{ .start = 0x00a02500, .end = 0x00a02504 },
+	{ .start = 0x00a0250c, .end = 0x00a02510 },
+	{ .start = 0x00a02540, .end = 0x00a02554 },
+	{ .start = 0x00a02580, .end = 0x00a025f4 },
+	{ .start = 0x00a02600, .end = 0x00a0260c },
+	{ .start = 0x00a02648, .end = 0x00a02650 },
+	{ .start = 0x00a02680, .end = 0x00a02680 },
+	{ .start = 0x00a026c0, .end = 0x00a026d0 },
+	{ .start = 0x00a02700, .end = 0x00a0270c },
+	{ .start = 0x00a02804, .end = 0x00a02804 },
+	{ .start = 0x00a02818, .end = 0x00a0281c },
+	{ .start = 0x00a02c00, .end = 0x00a02db4 },
+	{ .start = 0x00a02df4, .end = 0x00a02fb0 },
+	{ .start = 0x00a03000, .end = 0x00a03014 },
+	{ .start = 0x00a0301c, .end = 0x00a0302c },
+	{ .start = 0x00a03034, .end = 0x00a03038 },
+	{ .start = 0x00a03040, .end = 0x00a03048 },
+	{ .start = 0x00a03060, .end = 0x00a03068 },
+	{ .start = 0x00a03070, .end = 0x00a03074 },
+	{ .start = 0x00a0307c, .end = 0x00a0307c },
+	{ .start = 0x00a03080, .end = 0x00a03084 },
+	{ .start = 0x00a0308c, .end = 0x00a03090 },
+	{ .start = 0x00a03098, .end = 0x00a03098 },
+	{ .start = 0x00a030a0, .end = 0x00a030a0 },
+	{ .start = 0x00a030a8, .end = 0x00a030b4 },
+	{ .start = 0x00a030bc, .end = 0x00a030bc },
+	{ .start = 0x00a030c0, .end = 0x00a0312c },
+	{ .start = 0x00a03c00, .end = 0x00a03c5c },
+	{ .start = 0x00a04400, .end = 0x00a04454 },
+	{ .start = 0x00a04460, .end = 0x00a04474 },
+	{ .start = 0x00a044c0, .end = 0x00a044ec },
+	{ .start = 0x00a04500, .end = 0x00a04504 },
+	{ .start = 0x00a04510, .end = 0x00a04538 },
+	{ .start = 0x00a04540, .end = 0x00a04548 },
+	{ .start = 0x00a04560, .end = 0x00a0457c },
+	{ .start = 0x00a04590, .end = 0x00a04598 },
+	{ .start = 0x00a045c0, .end = 0x00a045f4 },
+};
+
+static u32 iwl_dump_prph(struct iwl_trans *trans,
+			 struct iwl_fw_error_dump_data **data)
+{
+	struct iwl_fw_error_dump_prph *prph;
+	unsigned long flags;
+	u32 prph_len = 0, i;
+
+	if (!iwl_trans_grab_nic_access(trans, false, &flags))
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
+		/* The range includes both boundaries */
+		int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
+			 iwl_prph_dump_addr[i].start + 4;
+		int reg;
+		__le32 *val;
+
+		prph_len += sizeof(**data) + sizeof(*prph) + num_bytes_in_chunk;
+
+		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PRPH);
+		(*data)->len = cpu_to_le32(sizeof(*prph) +
+					num_bytes_in_chunk);
+		prph = (void *)(*data)->data;
+		prph->prph_start = cpu_to_le32(iwl_prph_dump_addr[i].start);
+		val = (void *)prph->data;
+
+		for (reg = iwl_prph_dump_addr[i].start;
+		     reg <= iwl_prph_dump_addr[i].end;
+		     reg += 4)
+			*val++ = cpu_to_le32(iwl_read_prph_no_grab(trans,
+								   reg));
+
+			*data = iwl_fw_error_next_data(*data);
+	}
+
+	iwl_trans_release_nic_access(trans, &flags);
+
+	return prph_len;
+}
+
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 {
 	struct iwl_fw_error_dump_file *dump_file;
@@ -1134,6 +1273,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	u32 smem_len = mvm->cfg->smem_len;
 	u32 sram2_len = mvm->cfg->dccm2_len;
 	bool monitor_dump_only = false;
+	int i;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1166,7 +1306,6 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	/* reading RXF/TXF sizes */
 	if (test_bit(STATUS_FW_ERROR, &mvm->trans->status)) {
 		struct iwl_mvm_shared_mem_cfg *mem_cfg = &mvm->shared_mem_cfg;
-		int i;
 
 		fifo_data_len = 0;
 
@@ -1219,6 +1358,17 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 			   sizeof(*dump_info);
 	}
 
+	/* Make room for PRPH registers */
+	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
+		/* The range includes both boundaries */
+		int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
+			iwl_prph_dump_addr[i].start + 4;
+
+		file_len += sizeof(*dump_data) +
+			sizeof(struct iwl_fw_error_dump_prph) +
+			num_bytes_in_chunk;
+	}
+
 	/*
 	 * In 8000 HW family B-step include the ICCM (which resides separately)
 	 */
@@ -1343,6 +1493,9 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		}
 	}
 
+	dump_data = iwl_fw_error_next_data(dump_data);
+	iwl_dump_prph(mvm->trans, &dump_data);
+
 dump_trans_data:
 	fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans,
 						       mvm->fw_dump_trig);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 3c9035d..50614e4d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2144,144 +2144,6 @@ static u32 iwl_trans_pcie_get_cmdlen(struct iwl_tfd *tfd)
 	return cmdlen;
 }
 
-static const struct {
-	u32 start, end;
-} iwl_prph_dump_addr[] = {
-	{ .start = 0x00a00000, .end = 0x00a00000 },
-	{ .start = 0x00a0000c, .end = 0x00a00024 },
-	{ .start = 0x00a0002c, .end = 0x00a0003c },
-	{ .start = 0x00a00410, .end = 0x00a00418 },
-	{ .start = 0x00a00420, .end = 0x00a00420 },
-	{ .start = 0x00a00428, .end = 0x00a00428 },
-	{ .start = 0x00a00430, .end = 0x00a0043c },
-	{ .start = 0x00a00444, .end = 0x00a00444 },
-	{ .start = 0x00a004c0, .end = 0x00a004cc },
-	{ .start = 0x00a004d8, .end = 0x00a004d8 },
-	{ .start = 0x00a004e0, .end = 0x00a004f0 },
-	{ .start = 0x00a00840, .end = 0x00a00840 },
-	{ .start = 0x00a00850, .end = 0x00a00858 },
-	{ .start = 0x00a01004, .end = 0x00a01008 },
-	{ .start = 0x00a01010, .end = 0x00a01010 },
-	{ .start = 0x00a01018, .end = 0x00a01018 },
-	{ .start = 0x00a01024, .end = 0x00a01024 },
-	{ .start = 0x00a0102c, .end = 0x00a01034 },
-	{ .start = 0x00a0103c, .end = 0x00a01040 },
-	{ .start = 0x00a01048, .end = 0x00a01094 },
-	{ .start = 0x00a01c00, .end = 0x00a01c20 },
-	{ .start = 0x00a01c58, .end = 0x00a01c58 },
-	{ .start = 0x00a01c7c, .end = 0x00a01c7c },
-	{ .start = 0x00a01c28, .end = 0x00a01c54 },
-	{ .start = 0x00a01c5c, .end = 0x00a01c5c },
-	{ .start = 0x00a01c60, .end = 0x00a01cdc },
-	{ .start = 0x00a01ce0, .end = 0x00a01d0c },
-	{ .start = 0x00a01d18, .end = 0x00a01d20 },
-	{ .start = 0x00a01d2c, .end = 0x00a01d30 },
-	{ .start = 0x00a01d40, .end = 0x00a01d5c },
-	{ .start = 0x00a01d80, .end = 0x00a01d80 },
-	{ .start = 0x00a01d98, .end = 0x00a01d9c },
-	{ .start = 0x00a01da8, .end = 0x00a01da8 },
-	{ .start = 0x00a01db8, .end = 0x00a01df4 },
-	{ .start = 0x00a01dc0, .end = 0x00a01dfc },
-	{ .start = 0x00a01e00, .end = 0x00a01e2c },
-	{ .start = 0x00a01e40, .end = 0x00a01e60 },
-	{ .start = 0x00a01e68, .end = 0x00a01e6c },
-	{ .start = 0x00a01e74, .end = 0x00a01e74 },
-	{ .start = 0x00a01e84, .end = 0x00a01e90 },
-	{ .start = 0x00a01e9c, .end = 0x00a01ec4 },
-	{ .start = 0x00a01ed0, .end = 0x00a01ee0 },
-	{ .start = 0x00a01f00, .end = 0x00a01f1c },
-	{ .start = 0x00a01f44, .end = 0x00a01ffc },
-	{ .start = 0x00a02000, .end = 0x00a02048 },
-	{ .start = 0x00a02068, .end = 0x00a020f0 },
-	{ .start = 0x00a02100, .end = 0x00a02118 },
-	{ .start = 0x00a02140, .end = 0x00a0214c },
-	{ .start = 0x00a02168, .end = 0x00a0218c },
-	{ .start = 0x00a021c0, .end = 0x00a021c0 },
-	{ .start = 0x00a02400, .end = 0x00a02410 },
-	{ .start = 0x00a02418, .end = 0x00a02420 },
-	{ .start = 0x00a02428, .end = 0x00a0242c },
-	{ .start = 0x00a02434, .end = 0x00a02434 },
-	{ .start = 0x00a02440, .end = 0x00a02460 },
-	{ .start = 0x00a02468, .end = 0x00a024b0 },
-	{ .start = 0x00a024c8, .end = 0x00a024cc },
-	{ .start = 0x00a02500, .end = 0x00a02504 },
-	{ .start = 0x00a0250c, .end = 0x00a02510 },
-	{ .start = 0x00a02540, .end = 0x00a02554 },
-	{ .start = 0x00a02580, .end = 0x00a025f4 },
-	{ .start = 0x00a02600, .end = 0x00a0260c },
-	{ .start = 0x00a02648, .end = 0x00a02650 },
-	{ .start = 0x00a02680, .end = 0x00a02680 },
-	{ .start = 0x00a026c0, .end = 0x00a026d0 },
-	{ .start = 0x00a02700, .end = 0x00a0270c },
-	{ .start = 0x00a02804, .end = 0x00a02804 },
-	{ .start = 0x00a02818, .end = 0x00a0281c },
-	{ .start = 0x00a02c00, .end = 0x00a02db4 },
-	{ .start = 0x00a02df4, .end = 0x00a02fb0 },
-	{ .start = 0x00a03000, .end = 0x00a03014 },
-	{ .start = 0x00a0301c, .end = 0x00a0302c },
-	{ .start = 0x00a03034, .end = 0x00a03038 },
-	{ .start = 0x00a03040, .end = 0x00a03048 },
-	{ .start = 0x00a03060, .end = 0x00a03068 },
-	{ .start = 0x00a03070, .end = 0x00a03074 },
-	{ .start = 0x00a0307c, .end = 0x00a0307c },
-	{ .start = 0x00a03080, .end = 0x00a03084 },
-	{ .start = 0x00a0308c, .end = 0x00a03090 },
-	{ .start = 0x00a03098, .end = 0x00a03098 },
-	{ .start = 0x00a030a0, .end = 0x00a030a0 },
-	{ .start = 0x00a030a8, .end = 0x00a030b4 },
-	{ .start = 0x00a030bc, .end = 0x00a030bc },
-	{ .start = 0x00a030c0, .end = 0x00a0312c },
-	{ .start = 0x00a03c00, .end = 0x00a03c5c },
-	{ .start = 0x00a04400, .end = 0x00a04454 },
-	{ .start = 0x00a04460, .end = 0x00a04474 },
-	{ .start = 0x00a044c0, .end = 0x00a044ec },
-	{ .start = 0x00a04500, .end = 0x00a04504 },
-	{ .start = 0x00a04510, .end = 0x00a04538 },
-	{ .start = 0x00a04540, .end = 0x00a04548 },
-	{ .start = 0x00a04560, .end = 0x00a0457c },
-	{ .start = 0x00a04590, .end = 0x00a04598 },
-	{ .start = 0x00a045c0, .end = 0x00a045f4 },
-};
-
-static u32 iwl_trans_pcie_dump_prph(struct iwl_trans *trans,
-				    struct iwl_fw_error_dump_data **data)
-{
-	struct iwl_fw_error_dump_prph *prph;
-	unsigned long flags;
-	u32 prph_len = 0, i;
-
-	if (!iwl_trans_grab_nic_access(trans, false, &flags))
-		return 0;
-
-	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
-		/* The range includes both boundaries */
-		int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
-			 iwl_prph_dump_addr[i].start + 4;
-		int reg;
-		__le32 *val;
-
-		prph_len += sizeof(**data) + sizeof(*prph) + num_bytes_in_chunk;
-
-		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PRPH);
-		(*data)->len = cpu_to_le32(sizeof(*prph) +
-					num_bytes_in_chunk);
-		prph = (void *)(*data)->data;
-		prph->prph_start = cpu_to_le32(iwl_prph_dump_addr[i].start);
-		val = (void *)prph->data;
-
-		for (reg = iwl_prph_dump_addr[i].start;
-		     reg <= iwl_prph_dump_addr[i].end;
-		     reg += 4)
-			*val++ = cpu_to_le32(iwl_trans_pcie_read_prph(trans,
-								      reg));
-		*data = iwl_fw_error_next_data(*data);
-	}
-
-	iwl_trans_release_nic_access(trans, &flags);
-
-	return prph_len;
-}
-
 static u32 iwl_trans_pcie_dump_rbs(struct iwl_trans *trans,
 				   struct iwl_fw_error_dump_data **data,
 				   int allocated_rb_nums)
@@ -2534,16 +2396,6 @@ static struct iwl_trans_dump_data
 	/* CSR registers */
 	len += sizeof(*data) + IWL_CSR_TO_DUMP;
 
-	/* PRPH registers */
-	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
-		/* The range includes both boundaries */
-		int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
-			iwl_prph_dump_addr[i].start + 4;
-
-		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_prph) +
-		       num_bytes_in_chunk;
-	}
-
 	/* FH registers */
 	len += sizeof(*data) + (FH_MEM_UPPER_BOUND - FH_MEM_LOWER_BOUND);
 
@@ -2591,7 +2443,6 @@ static struct iwl_trans_dump_data
 	len += sizeof(*data);
 	data = iwl_fw_error_next_data(data);
 
-	len += iwl_trans_pcie_dump_prph(trans, &data);
 	len += iwl_trans_pcie_dump_csr(trans, &data);
 	len += iwl_trans_pcie_fh_regs_dump(trans, &data);
 	if (dump_rbs)
-- 
2.5.0

