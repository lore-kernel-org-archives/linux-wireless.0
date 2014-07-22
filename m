Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:54206 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbaGVT1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:44 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so115764wes.22
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:43 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/20] iwlwifi: dump periphery registers to fw-error-dump
Date: Tue, 22 Jul 2014 22:26:47 +0300
Message-Id: <1406057211-31752-16-git-send-email-egrumbach@gmail.com> (sfid-20140722_212751_921705_3B4145FC)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Use the fw-error-dump infrastructure to dump the periphery
registers. Only certain ranges are readable, so dump only
these.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  13 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c        | 152 ++++++++++++++++++++++-
 2 files changed, 164 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index c39a0b8..5121479 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -77,6 +77,8 @@
  * @IWL_FW_ERROR_DUMP_DEV_FW_INFO:  struct %iwl_fw_error_dump_info
  *	info on the device / firmware.
  * @IWL_FW_ERROR_DUMP_FW_MONITOR: firmware monitor
+ * @IWL_FW_ERROR_DUMP_PRPH: range of periphery registers - there can be several
+ *	sections like this in a single file.
  */
 enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_SRAM = 0,
@@ -85,6 +87,7 @@ enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_TXCMD = 3,
 	IWL_FW_ERROR_DUMP_DEV_FW_INFO = 4,
 	IWL_FW_ERROR_DUMP_FW_MONITOR = 5,
+	IWL_FW_ERROR_DUMP_PRPH = 6,
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
@@ -163,6 +166,16 @@ struct iwl_fw_error_dump_fw_mon {
 } __packed;
 
 /**
+ * struct iwl_fw_error_dump_prph - periphery registers data
+ * @prph_start: address of the first register in this chunk
+ * @data: the content of the registers
+ */
+struct iwl_fw_error_dump_prph {
+	__le32 prph_start;
+	__le32 data[];
+};
+
+/**
  * iwl_fw_error_next_data - advance fw error dump data pointer
  * @data: previous data block
  * Returns: next data block
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index a90292c..153c3dd 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1774,6 +1774,144 @@ static u32 iwl_trans_pcie_get_cmdlen(struct iwl_tfd *tfd)
 	return cmdlen;
 }
 
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
+	{ .start = 0x00a01c84, .end = 0x00a01c84 },
+	{ .start = 0x00a01ce0, .end = 0x00a01d0c },
+	{ .start = 0x00a01d18, .end = 0x00a01d20 },
+	{ .start = 0x00a01d2c, .end = 0x00a01d30 },
+	{ .start = 0x00a01d40, .end = 0x00a01d5c },
+	{ .start = 0x00a01d80, .end = 0x00a01d80 },
+	{ .start = 0x00a01d98, .end = 0x00a01d98 },
+	{ .start = 0x00a01dc0, .end = 0x00a01dfc },
+	{ .start = 0x00a01e00, .end = 0x00a01e2c },
+	{ .start = 0x00a01e40, .end = 0x00a01e60 },
+	{ .start = 0x00a01e84, .end = 0x00a01e90 },
+	{ .start = 0x00a01e9c, .end = 0x00a01ec4 },
+	{ .start = 0x00a01ed0, .end = 0x00a01ed0 },
+	{ .start = 0x00a01f00, .end = 0x00a01f14 },
+	{ .start = 0x00a01f44, .end = 0x00a01f58 },
+	{ .start = 0x00a01f80, .end = 0x00a01fa8 },
+	{ .start = 0x00a01fb0, .end = 0x00a01fbc },
+	{ .start = 0x00a01ff8, .end = 0x00a01ffc },
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
+static u32 iwl_trans_pcie_dump_prph(struct iwl_trans *trans,
+				    struct iwl_fw_error_dump_data **data)
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
+		prph_len += sizeof(*data) + sizeof(*prph) +
+			num_bytes_in_chunk;
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
+			*val++ = cpu_to_le32(iwl_trans_pcie_read_prph(trans,
+								      reg));
+		*data = iwl_fw_error_next_data(*data);
+	}
+
+	iwl_trans_release_nic_access(trans, &flags);
+
+	return prph_len;
+}
+
 static
 struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 {
@@ -1788,6 +1926,15 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 	len = sizeof(*dump_data) + sizeof(*data) +
 		cmdq->q.n_window * (sizeof(*txcmd) + TFD_MAX_PAYLOAD_SIZE);
 
+	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
+		/* The range includes both boundaries */
+		int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
+			iwl_prph_dump_addr[i].start + 4;
+
+		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_prph) +
+			num_bytes_in_chunk;
+	}
+
 	if (trans_pcie->fw_mon_page)
 		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_fw_mon) +
 			trans_pcie->fw_mon_size;
@@ -1823,11 +1970,14 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 
 	data->len = cpu_to_le32(len);
 	len += sizeof(*data);
+	data = iwl_fw_error_next_data(data);
+
+	len += iwl_trans_pcie_dump_prph(trans, &data);
+	/* data is already pointing to the next section */
 
 	if (trans_pcie->fw_mon_page) {
 		struct iwl_fw_error_dump_fw_mon *fw_mon_data;
 
-		data = iwl_fw_error_next_data(data);
 		data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_FW_MONITOR);
 		data->len = cpu_to_le32(trans_pcie->fw_mon_size +
 					sizeof(*fw_mon_data));
-- 
1.8.3.2

