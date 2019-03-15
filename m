Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F50C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E94602077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbfCOQgx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:36:53 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44296 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729541AbfCOQgv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:36:51 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ppA-0004qp-6q; Fri, 15 Mar 2019 18:36:48 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:27 +0200
Message-Id: <20190315163634.17315-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/16] iwlwifi: pcie: switch to correct RBD/CD layout for 22560
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The layout of the RBD (receive buffer descriptor) isn't quite right,
the hardware ended up being implemented differently. Switch to the
correct RBD layout. While at it, remove the now useless extra defines.

Also, switch the CD (completion descriptor) to the right format, which
is basically just a code cleanup because the only field we really used
(rbid) is still in the same place. We may need fragmentation later if
we ever want to use it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    | 67 +------------------
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  1 -
 .../wireless/intel/iwlwifi/pcie/internal.h    | 30 ++-------
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 13 ++--
 4 files changed, 13 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index 6e8224ce8906..d55312ef58c9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -688,13 +688,6 @@ struct iwl_rx_mpdu_desc {
 
 #define IWL_RX_DESC_SIZE_V1 offsetofend(struct iwl_rx_mpdu_desc, v1)
 
-#define IWL_CD_STTS_OPTIMIZED_POS	0
-#define IWL_CD_STTS_OPTIMIZED_MSK	0x01
-#define IWL_CD_STTS_TRANSFER_STATUS_POS	1
-#define IWL_CD_STTS_TRANSFER_STATUS_MSK	0x0E
-#define IWL_CD_STTS_WIFI_STATUS_POS	4
-#define IWL_CD_STTS_WIFI_STATUS_MSK	0xF0
-
 #define RX_NO_DATA_CHAIN_A_POS		0
 #define RX_NO_DATA_CHAIN_A_MSK		(0xff << RX_NO_DATA_CHAIN_A_POS)
 #define RX_NO_DATA_CHAIN_B_POS		8
@@ -747,62 +740,6 @@ struct iwl_rx_no_data {
 	__le32 rx_vec[2];
 } __packed; /* RX_NO_DATA_NTFY_API_S_VER_1 */
 
-/**
- * enum iwl_completion_desc_transfer_status -  transfer status (bits 1-3)
- * @IWL_CD_STTS_UNUSED: unused
- * @IWL_CD_STTS_UNUSED_2: unused
- * @IWL_CD_STTS_END_TRANSFER: successful transfer complete.
- *	In sniffer mode, when split is used, set in last CD completion. (RX)
- * @IWL_CD_STTS_OVERFLOW: In sniffer mode, when using split - used for
- *	all CD completion. (RX)
- * @IWL_CD_STTS_ABORTED: CR abort / close flow. (RX)
- * @IWL_CD_STTS_ERROR: general error (RX)
- */
-enum iwl_completion_desc_transfer_status {
-	IWL_CD_STTS_UNUSED,
-	IWL_CD_STTS_UNUSED_2,
-	IWL_CD_STTS_END_TRANSFER,
-	IWL_CD_STTS_OVERFLOW,
-	IWL_CD_STTS_ABORTED,
-	IWL_CD_STTS_ERROR,
-};
-
-/**
- * enum iwl_completion_desc_wifi_status - wifi status (bits 4-7)
- * @IWL_CD_STTS_VALID: the packet is valid (RX)
- * @IWL_CD_STTS_FCS_ERR: frame check sequence error (RX)
- * @IWL_CD_STTS_SEC_KEY_ERR: error handling the security key of rx (RX)
- * @IWL_CD_STTS_DECRYPTION_ERR: error decrypting the frame (RX)
- * @IWL_CD_STTS_DUP: duplicate packet (RX)
- * @IWL_CD_STTS_ICV_MIC_ERR: MIC error (RX)
- * @IWL_CD_STTS_INTERNAL_SNAP_ERR: problems removing the snap (RX)
- * @IWL_CD_STTS_SEC_PORT_FAIL: security port fail (RX)
- * @IWL_CD_STTS_BA_OLD_SN: block ack received old SN (RX)
- * @IWL_CD_STTS_QOS_NULL: QoS null packet (RX)
- * @IWL_CD_STTS_MAC_HDR_ERR: MAC header conversion error (RX)
- * @IWL_CD_STTS_MAX_RETRANS: reached max number of retransmissions (TX)
- * @IWL_CD_STTS_EX_LIFETIME: exceeded lifetime (TX)
- * @IWL_CD_STTS_NOT_USED: completed but not used (RX)
- * @IWL_CD_STTS_REPLAY_ERR: pn check failed, replay error (RX)
- */
-enum iwl_completion_desc_wifi_status {
-	IWL_CD_STTS_VALID,
-	IWL_CD_STTS_FCS_ERR,
-	IWL_CD_STTS_SEC_KEY_ERR,
-	IWL_CD_STTS_DECRYPTION_ERR,
-	IWL_CD_STTS_DUP,
-	IWL_CD_STTS_ICV_MIC_ERR,
-	IWL_CD_STTS_INTERNAL_SNAP_ERR,
-	IWL_CD_STTS_SEC_PORT_FAIL,
-	IWL_CD_STTS_BA_OLD_SN,
-	IWL_CD_STTS_QOS_NULL,
-	IWL_CD_STTS_MAC_HDR_ERR,
-	IWL_CD_STTS_MAX_RETRANS,
-	IWL_CD_STTS_EX_LIFETIME,
-	IWL_CD_STTS_NOT_USED,
-	IWL_CD_STTS_REPLAY_ERR,
-};
-
 struct iwl_frame_release {
 	u8 baid;
 	u8 reserved;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index bbebbf3efd57..cef045d3f1bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -274,7 +274,6 @@ struct iwl_rx_cmd_buffer {
 	bool _page_stolen;
 	u32 _rx_page_order;
 	unsigned int truesize;
-	u8 status;
 };
 
 static inline void *rxb_addr(struct iwl_rx_cmd_buffer *r)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index bf8b61a476c5..5b5a77a66921 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -106,7 +106,6 @@ struct iwl_host_cmd;
  * @page: driver's pointer to the rxb page
  * @invalid: rxb is in driver ownership - not owned by HW
  * @vid: index of this rxb in the global table
- * @size: size used from the buffer
  */
 struct iwl_rx_mem_buffer {
 	dma_addr_t page_dma;
@@ -114,7 +113,6 @@ struct iwl_rx_mem_buffer {
 	u16 vid;
 	bool invalid;
 	struct list_head list;
-	u32 size;
 };
 
 /**
@@ -135,46 +133,32 @@ struct isr_statistics {
 	u32 unhandled;
 };
 
-#define IWL_RX_TD_TYPE_MSK	0xff000000
-#define IWL_RX_TD_SIZE_MSK	0x00ffffff
-#define IWL_RX_TD_SIZE_2K	BIT(11)
-#define IWL_RX_TD_TYPE		0
-
 /**
  * struct iwl_rx_transfer_desc - transfer descriptor
- * @type_n_size: buffer type (bit 0: external buff valid,
- *	bit 1: optional footer valid, bit 2-7: reserved)
- *	and buffer size
  * @addr: ptr to free buffer start address
  * @rbid: unique tag of the buffer
  * @reserved: reserved
  */
 struct iwl_rx_transfer_desc {
-	__le32 type_n_size;
-	__le64 addr;
 	__le16 rbid;
-	__le16 reserved;
+	__le16 reserved[3];
+	__le64 addr;
 } __packed;
 
-#define IWL_RX_CD_SIZE		0xffffff00
+#define IWL_RX_CD_FLAGS_FRAGMENTED	BIT(0)
 
 /**
  * struct iwl_rx_completion_desc - completion descriptor
- * @type: buffer type (bit 0: external buff valid,
- *	bit 1: optional footer valid, bit 2-7: reserved)
- * @status: status of the completion
  * @reserved1: reserved
  * @rbid: unique tag of the received buffer
- * @size: buffer size, masked by IWL_RX_CD_SIZE
+ * @flags: flags (0: fragmented, all others: reserved)
  * @reserved2: reserved
  */
 struct iwl_rx_completion_desc {
-	u8 type;
-	u8 status;
-	__le16 reserved1;
+	__le32 reserved1;
 	__le16 rbid;
-	__le32 size;
-	u8 reserved2[22];
+	u8 flags;
+	u8 reserved2[25];
 } __packed;
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 8d4f0628622b..abe40196266b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -282,9 +282,8 @@ static void iwl_pcie_restock_bd(struct iwl_trans *trans,
 	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
 		struct iwl_rx_transfer_desc *bd = rxq->bd;
 
-		bd[rxq->write].type_n_size =
-			cpu_to_le32((IWL_RX_TD_TYPE & IWL_RX_TD_TYPE_MSK) |
-			((IWL_RX_TD_SIZE_2K >> 8) & IWL_RX_TD_SIZE_MSK));
+		BUILD_BUG_ON(sizeof(*bd) != 2 * sizeof(u64));
+
 		bd[rxq->write].addr = cpu_to_le64(rxb->page_dma);
 		bd[rxq->write].rbid = cpu_to_le16(rxb->vid);
 	} else {
@@ -1265,9 +1264,6 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 			.truesize = max_len,
 		};
 
-		if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
-			rxcb.status = rxq->cd[i].status;
-
 		pkt = rxb_addr(&rxcb);
 
 		if (pkt->len_n_flags == cpu_to_le32(FH_RSCSR_FRAME_INVALID)) {
@@ -1394,6 +1390,8 @@ static struct iwl_rx_mem_buffer *iwl_pcie_get_rxb(struct iwl_trans *trans,
 	struct iwl_rx_mem_buffer *rxb;
 	u16 vid;
 
+	BUILD_BUG_ON(sizeof(struct iwl_rx_completion_desc) != 32);
+
 	if (!trans->cfg->mq_rx_supported) {
 		rxb = rxq->queue[i];
 		rxq->queue[i] = NULL;
@@ -1415,9 +1413,6 @@ static struct iwl_rx_mem_buffer *iwl_pcie_get_rxb(struct iwl_trans *trans,
 
 	IWL_DEBUG_RX(trans, "Got virtual RB ID %u\n", (u32)rxb->vid);
 
-	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
-		rxb->size = le32_to_cpu(rxq->cd[i].size) & IWL_RX_CD_SIZE;
-
 	rxb->invalid = true;
 
 	return rxb;
-- 
2.20.1

