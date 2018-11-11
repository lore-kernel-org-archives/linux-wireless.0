Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F58C43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 565FB2080D
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:09:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 565FB2080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbeKLF67 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 00:58:59 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35914 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727204AbeKLF5J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 00:57:09 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLw1D-0000JG-1j; Sun, 11 Nov 2018 22:07:39 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 22:07:18 +0200
Message-Id: <20181111200732.8159-3-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111200732.8159-1-luca@coelho.fi>
References: <20181111200732.8159-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/16] iwlwifi: dbg: split fifos dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Split the dump of RXF and TXF. This is in order to
enable code reuse for INI, which may decide to dump
only RXF and not TXF, and vice versa.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 52 +++++++++++++++------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 67e6a35f14c4..6243b503d0b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -225,17 +225,13 @@ static void iwl_fwrt_dump_txf(struct iwl_fw_runtime *fwrt,
 	*dump_data = iwl_fw_error_next_data(*dump_data);
 }
 
-static void iwl_fw_dump_fifos(struct iwl_fw_runtime *fwrt,
-			      struct iwl_fw_error_dump_data **dump_data)
+static void iwl_fw_dump_rxf(struct iwl_fw_runtime *fwrt,
+			    struct iwl_fw_error_dump_data **dump_data)
 {
-	struct iwl_fw_error_dump_fifo *fifo_hdr;
 	struct iwl_fwrt_shared_mem_cfg *cfg = &fwrt->smem_cfg;
-	u32 *fifo_data;
-	u32 fifo_len;
 	unsigned long flags;
-	int i, j;
 
-	IWL_DEBUG_INFO(fwrt, "WRT FIFO dump\n");
+	IWL_DEBUG_INFO(fwrt, "WRT RX FIFO dump\n");
 
 	if (!iwl_trans_grab_nic_access(fwrt->trans, &flags))
 		return;
@@ -254,6 +250,24 @@ static void iwl_fw_dump_fifos(struct iwl_fw_runtime *fwrt,
 					  LMAC2_PRPH_OFFSET, 2);
 	}
 
+	iwl_trans_release_nic_access(fwrt->trans, &flags);
+}
+
+static void iwl_fw_dump_txf(struct iwl_fw_runtime *fwrt,
+			    struct iwl_fw_error_dump_data **dump_data)
+{
+	struct iwl_fw_error_dump_fifo *fifo_hdr;
+	struct iwl_fwrt_shared_mem_cfg *cfg = &fwrt->smem_cfg;
+	u32 *fifo_data;
+	u32 fifo_len;
+	unsigned long flags;
+	int i, j;
+
+	IWL_DEBUG_INFO(fwrt, "WRT TX FIFO dump\n");
+
+	if (!iwl_trans_grab_nic_access(fwrt->trans, &flags))
+		return;
+
 	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_TXF)) {
 		/* Pull TXF data from LMAC1 */
 		for (i = 0; i < fwrt->smem_cfg.num_txfifo_entries; i++) {
@@ -595,8 +609,8 @@ static void iwl_fw_dump_mem(struct iwl_fw_runtime *fwrt,
 	do {size_t item = item_len; len += (!!item) * const_len + item; } \
 	while (0)
 
-static int iwl_fw_fifo_len(struct iwl_fw_runtime *fwrt,
-			   struct iwl_fwrt_shared_mem_cfg *mem_cfg)
+static int iwl_fw_rxf_len(struct iwl_fw_runtime *fwrt,
+			  struct iwl_fwrt_shared_mem_cfg *mem_cfg)
 {
 	size_t hdr_len = sizeof(struct iwl_fw_error_dump_data) +
 			 sizeof(struct iwl_fw_error_dump_fifo);
@@ -604,7 +618,7 @@ static int iwl_fw_fifo_len(struct iwl_fw_runtime *fwrt,
 	int i;
 
 	if (!iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_RXF))
-		goto dump_txf;
+		return 0;
 
 	/* Count RXF2 size */
 	ADD_LEN(fifo_len, mem_cfg->rxfifo2_size, hdr_len);
@@ -613,7 +627,17 @@ static int iwl_fw_fifo_len(struct iwl_fw_runtime *fwrt,
 	for (i = 0; i < mem_cfg->num_lmacs; i++)
 		ADD_LEN(fifo_len, mem_cfg->lmac[i].rxfifo1_size, hdr_len);
 
-dump_txf:
+	return fifo_len;
+}
+
+static int iwl_fw_txf_len(struct iwl_fw_runtime *fwrt,
+			  struct iwl_fwrt_shared_mem_cfg *mem_cfg)
+{
+	size_t hdr_len = sizeof(struct iwl_fw_error_dump_data) +
+			 sizeof(struct iwl_fw_error_dump_fifo);
+	u32 fifo_len = 0;
+	int i;
+
 	if (!iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_TXF))
 		goto dump_internal_txf;
 
@@ -697,7 +721,8 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 
 	/* reading RXF/TXF sizes */
 	if (test_bit(STATUS_FW_ERROR, &fwrt->trans->status)) {
-		fifo_len = iwl_fw_fifo_len(fwrt, mem_cfg);
+		fifo_len = iwl_fw_rxf_len(fwrt, mem_cfg);
+		fifo_len += iwl_fw_txf_len(fwrt, mem_cfg);
 
 		/* Make room for PRPH registers */
 		if (!fwrt->trans->cfg->gen2 &&
@@ -817,7 +842,8 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 
 	/* We only dump the FIFOs if the FW is in error state */
 	if (fifo_len) {
-		iwl_fw_dump_fifos(fwrt, &dump_data);
+		iwl_fw_dump_rxf(fwrt, &dump_data);
+		iwl_fw_dump_txf(fwrt, &dump_data);
 		if (radio_len)
 			iwl_read_radio_regs(fwrt, &dump_data);
 	}
-- 
2.19.1

