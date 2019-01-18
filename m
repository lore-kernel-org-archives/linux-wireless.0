Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78760C07EBF
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49FB92086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbfARTBG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:01:06 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48446 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729191AbfARTBG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:01:06 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNQ-0004cj-Bc; Fri, 18 Jan 2019 21:00:24 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 21:00:02 +0200
Message-Id: <20190118190004.22270-15-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/16] iwlwifi: wrt: add 22000 device familiy prph dump support
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add prph dump addresses to support prph dump in 22000 HW.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 168 +++++++++++++++-----
 1 file changed, 131 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index d4d6544f8833..5f16879ab26a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -469,6 +469,93 @@ static const struct iwl_prph_range iwl_prph_dump_addr_9000[] = {
 	{ .start = 0x00a02400, .end = 0x00a02758 },
 };
 
+static const struct iwl_prph_range iwl_prph_dump_addr_22000[] = {
+	{ .start = 0x00a00000, .end = 0x00a00000 },
+	{ .start = 0x00a0000c, .end = 0x00a00024 },
+	{ .start = 0x00a0002c, .end = 0x00a00034 },
+	{ .start = 0x00a0003c, .end = 0x00a0003c },
+	{ .start = 0x00a00410, .end = 0x00a00418 },
+	{ .start = 0x00a00420, .end = 0x00a00420 },
+	{ .start = 0x00a00428, .end = 0x00a00428 },
+	{ .start = 0x00a00430, .end = 0x00a0043c },
+	{ .start = 0x00a00444, .end = 0x00a00444 },
+	{ .start = 0x00a00840, .end = 0x00a00840 },
+	{ .start = 0x00a00850, .end = 0x00a00858 },
+	{ .start = 0x00a01004, .end = 0x00a01008 },
+	{ .start = 0x00a01010, .end = 0x00a01010 },
+	{ .start = 0x00a01018, .end = 0x00a01018 },
+	{ .start = 0x00a01024, .end = 0x00a01024 },
+	{ .start = 0x00a0102c, .end = 0x00a01034 },
+	{ .start = 0x00a0103c, .end = 0x00a01040 },
+	{ .start = 0x00a01048, .end = 0x00a01050 },
+	{ .start = 0x00a01058, .end = 0x00a01058 },
+	{ .start = 0x00a01060, .end = 0x00a01070 },
+	{ .start = 0x00a0108c, .end = 0x00a0108c },
+	{ .start = 0x00a01c20, .end = 0x00a01c28 },
+	{ .start = 0x00a01d10, .end = 0x00a01d10 },
+	{ .start = 0x00a01e28, .end = 0x00a01e2c },
+	{ .start = 0x00a01e60, .end = 0x00a01e60 },
+	{ .start = 0x00a01e80, .end = 0x00a01e80 },
+	{ .start = 0x00a01ea0, .end = 0x00a01ea0 },
+	{ .start = 0x00a02000, .end = 0x00a0201c },
+	{ .start = 0x00a02024, .end = 0x00a02024 },
+	{ .start = 0x00a02040, .end = 0x00a02048 },
+	{ .start = 0x00a020c0, .end = 0x00a020e0 },
+	{ .start = 0x00a02400, .end = 0x00a02404 },
+	{ .start = 0x00a0240c, .end = 0x00a02414 },
+	{ .start = 0x00a0241c, .end = 0x00a0243c },
+	{ .start = 0x00a02448, .end = 0x00a024bc },
+	{ .start = 0x00a024c4, .end = 0x00a024cc },
+	{ .start = 0x00a02508, .end = 0x00a02508 },
+	{ .start = 0x00a02510, .end = 0x00a02514 },
+	{ .start = 0x00a0251c, .end = 0x00a0251c },
+	{ .start = 0x00a0252c, .end = 0x00a0255c },
+	{ .start = 0x00a02564, .end = 0x00a025a0 },
+	{ .start = 0x00a025a8, .end = 0x00a025b4 },
+	{ .start = 0x00a025c0, .end = 0x00a025c0 },
+	{ .start = 0x00a025e8, .end = 0x00a025f4 },
+	{ .start = 0x00a02c08, .end = 0x00a02c18 },
+	{ .start = 0x00a02c2c, .end = 0x00a02c38 },
+	{ .start = 0x00a02c68, .end = 0x00a02c78 },
+	{ .start = 0x00a03000, .end = 0x00a03000 },
+	{ .start = 0x00a03010, .end = 0x00a03014 },
+	{ .start = 0x00a0301c, .end = 0x00a0302c },
+	{ .start = 0x00a03034, .end = 0x00a03038 },
+	{ .start = 0x00a03040, .end = 0x00a03044 },
+	{ .start = 0x00a03060, .end = 0x00a03068 },
+	{ .start = 0x00a03070, .end = 0x00a03070 },
+	{ .start = 0x00a0307c, .end = 0x00a03084 },
+	{ .start = 0x00a0308c, .end = 0x00a03090 },
+	{ .start = 0x00a03098, .end = 0x00a03098 },
+	{ .start = 0x00a030a0, .end = 0x00a030a0 },
+	{ .start = 0x00a030a8, .end = 0x00a030b4 },
+	{ .start = 0x00a030bc, .end = 0x00a030c0 },
+	{ .start = 0x00a030c8, .end = 0x00a030f4 },
+	{ .start = 0x00a03100, .end = 0x00a0312c },
+	{ .start = 0x00a03c00, .end = 0x00a03c5c },
+	{ .start = 0x00a04400, .end = 0x00a04454 },
+	{ .start = 0x00a04460, .end = 0x00a04474 },
+	{ .start = 0x00a044c0, .end = 0x00a044ec },
+	{ .start = 0x00a04500, .end = 0x00a04504 },
+	{ .start = 0x00a04510, .end = 0x00a04538 },
+	{ .start = 0x00a04540, .end = 0x00a04548 },
+	{ .start = 0x00a04560, .end = 0x00a04560 },
+	{ .start = 0x00a04570, .end = 0x00a0457c },
+	{ .start = 0x00a04590, .end = 0x00a04590 },
+	{ .start = 0x00a04598, .end = 0x00a04598 },
+	{ .start = 0x00a045c0, .end = 0x00a045f4 },
+	{ .start = 0x00a0c000, .end = 0x00a0c018 },
+	{ .start = 0x00a0c020, .end = 0x00a0c028 },
+	{ .start = 0x00a0c038, .end = 0x00a0c094 },
+	{ .start = 0x00a0c0c0, .end = 0x00a0c104 },
+	{ .start = 0x00a0c10c, .end = 0x00a0c118 },
+	{ .start = 0x00a0c150, .end = 0x00a0c174 },
+	{ .start = 0x00a0c17c, .end = 0x00a0c188 },
+	{ .start = 0x00a0c190, .end = 0x00a0c198 },
+	{ .start = 0x00a0c1a0, .end = 0x00a0c1a8 },
+	{ .start = 0x00a0c1b0, .end = 0x00a0c1b8 },
+};
+
 static void iwl_read_prph_block(struct iwl_trans *trans, u32 start,
 				u32 len_bytes, __le32 *data)
 {
@@ -478,15 +565,20 @@ static void iwl_read_prph_block(struct iwl_trans *trans, u32 start,
 		*data++ = cpu_to_le32(iwl_read_prph_no_grab(trans, start + i));
 }
 
-static void iwl_dump_prph(struct iwl_trans *trans,
-			  struct iwl_fw_error_dump_data **data,
+static void iwl_dump_prph(struct iwl_fw_runtime *fwrt,
 			  const struct iwl_prph_range *iwl_prph_dump_addr,
-			  u32 range_len)
+			  u32 range_len, void *ptr)
 {
 	struct iwl_fw_error_dump_prph *prph;
+	struct iwl_trans *trans = fwrt->trans;
+	struct iwl_fw_error_dump_data **data =
+		(struct iwl_fw_error_dump_data **)ptr;
 	unsigned long flags;
 	u32 i;
 
+	if (!data)
+		return;
+
 	IWL_DEBUG_INFO(trans, "WRT PRPH dump\n");
 
 	if (!iwl_trans_grab_nic_access(trans, &flags))
@@ -552,37 +644,47 @@ static struct scatterlist *alloc_sgtable(int size)
 	return table;
 }
 
-static int iwl_fw_get_prph_len(struct iwl_fw_runtime *fwrt)
+static void iwl_fw_get_prph_len(struct iwl_fw_runtime *fwrt,
+				const struct iwl_prph_range *iwl_prph_dump_addr,
+				u32 range_len, void *ptr)
 {
-	u32 prph_len = 0;
-	int i;
+	u32 *prph_len = (u32 *)ptr;
+	int i, num_bytes_in_chunk;
+
+	if (!prph_len)
+		return;
 
-	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr_comm);
-	     i++) {
+	for (i = 0; i < range_len; i++) {
 		/* The range includes both boundaries */
-		int num_bytes_in_chunk =
-			iwl_prph_dump_addr_comm[i].end -
-			iwl_prph_dump_addr_comm[i].start + 4;
+		num_bytes_in_chunk =
+			iwl_prph_dump_addr[i].end -
+			iwl_prph_dump_addr[i].start + 4;
 
-		prph_len += sizeof(struct iwl_fw_error_dump_data) +
+		*prph_len += sizeof(struct iwl_fw_error_dump_data) +
 			sizeof(struct iwl_fw_error_dump_prph) +
 			num_bytes_in_chunk;
 	}
+}
 
-	if (fwrt->trans->cfg->mq_rx_supported) {
-		for (i = 0; i <
-			ARRAY_SIZE(iwl_prph_dump_addr_9000); i++) {
-			/* The range includes both boundaries */
-			int num_bytes_in_chunk =
-				iwl_prph_dump_addr_9000[i].end -
-				iwl_prph_dump_addr_9000[i].start + 4;
-
-			prph_len += sizeof(struct iwl_fw_error_dump_data) +
-				sizeof(struct iwl_fw_error_dump_prph) +
-				num_bytes_in_chunk;
+static void iwl_fw_prph_handler(struct iwl_fw_runtime *fwrt, void *ptr,
+				void (*handler)(struct iwl_fw_runtime *,
+						const struct iwl_prph_range *,
+						u32, void *))
+{
+	u32 range_len;
+
+	if (fwrt->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22000) {
+		range_len = ARRAY_SIZE(iwl_prph_dump_addr_22000);
+		handler(fwrt, iwl_prph_dump_addr_22000, range_len, ptr);
+	} else {
+		range_len = ARRAY_SIZE(iwl_prph_dump_addr_comm);
+		handler(fwrt, iwl_prph_dump_addr_comm, range_len, ptr);
+
+		if (fwrt->trans->cfg->mq_rx_supported) {
+			range_len = ARRAY_SIZE(iwl_prph_dump_addr_9000);
+			handler(fwrt, iwl_prph_dump_addr_9000, range_len, ptr);
 		}
 	}
-	return prph_len;
 }
 
 static void iwl_fw_dump_mem(struct iwl_fw_runtime *fwrt,
@@ -747,9 +849,9 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 		fifo_len += iwl_fw_txf_len(fwrt, mem_cfg);
 
 		/* Make room for PRPH registers */
-		if (!fwrt->trans->cfg->gen2 &&
-		   iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_PRPH))
-			prph_len += iwl_fw_get_prph_len(fwrt);
+		if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_PRPH))
+			iwl_fw_prph_handler(fwrt, &prph_len,
+					    iwl_fw_get_prph_len);
 
 		if (fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000 &&
 		    iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_RADIO_REG))
@@ -941,16 +1043,8 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	if (iwl_fw_dbg_is_paging_enabled(fwrt))
 		iwl_dump_paging(fwrt, &dump_data);
 
-	if (prph_len) {
-		iwl_dump_prph(fwrt->trans, &dump_data,
-			      iwl_prph_dump_addr_comm,
-			      ARRAY_SIZE(iwl_prph_dump_addr_comm));
-
-		if (fwrt->trans->cfg->mq_rx_supported)
-			iwl_dump_prph(fwrt->trans, &dump_data,
-				      iwl_prph_dump_addr_9000,
-				      ARRAY_SIZE(iwl_prph_dump_addr_9000));
-	}
+	if (prph_len)
+		iwl_fw_prph_handler(fwrt, &dump_data, iwl_dump_prph);
 
 out:
 	dump_file->file_len = cpu_to_le32(file_len);
-- 
2.20.1

