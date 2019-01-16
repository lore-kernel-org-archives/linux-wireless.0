Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E6EC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 11:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C01C9206C2
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 11:29:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Jn0sZwGI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a90MDirv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389512AbfAPL3w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 06:29:52 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59460 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730420AbfAPL3v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 06:29:51 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6737B60854; Wed, 16 Jan 2019 11:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547638190;
        bh=LlxCFy0/VhM0tamIeLsidqm5LQd8g1hOO2KTzkW0kt8=;
        h=From:To:Cc:Subject:Date:From;
        b=Jn0sZwGI8EfguAVoyPRy89KW3JUvp9vOg50YUwikpqaWxOczHzEvXELPnIIMjxUYu
         oCPgAdzHuxx7Rr5yTdZe29X0zjrAoIayVRB1k4toslGLEyMd7oRs8AAL3ncmX4v2D0
         jLTNNOuNQOXki2JHdrdLbGR1EJena5IoET8VcANA=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2631B60A24;
        Wed, 16 Jan 2019 11:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547638189;
        bh=LlxCFy0/VhM0tamIeLsidqm5LQd8g1hOO2KTzkW0kt8=;
        h=From:To:Cc:Subject:Date:From;
        b=a90MDirvpPhvOjC7LDH0pxrA40G4E/TbVXYZwrU4hOB1psf/I059D5b9TI0tIHGag
         tJMANZCrzMglGsNu5XYoZZYol845Hcl5U3Iob3qbcfCh9H0gOpb9QishrB5hfEH3IT
         pEfJ/y/SECbi02cn5qaOBjeyHC/nXT0+jnu47QwU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2631B60A24
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH] ath10k: Add support for extended HTT aggr msg support
Date:   Wed, 16 Jan 2019 16:59:42 +0530
Message-Id: <20190116112942.11687-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

HTT aggr message parameter in HL2.0 fw are different in comparison
to legacy fw version. Fill correct HTT aggr msg parameter for
targets using HL2.0 firmware.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt.c    |  2 +-
 drivers/net/wireless/ath/ath10k/htt.h    | 11 ++++++
 drivers/net/wireless/ath/ath10k/htt_tx.c | 49 ++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 21a67f82f037..55c716499830 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -268,7 +268,7 @@ int ath10k_htt_setup(struct ath10k_htt *htt)
 		return status;
 	}
 
-	status = ath10k_htt_h2t_aggr_cfg_msg(htt,
+	status = htt->tx_ops->htt_h2t_aggr_cfg_msg(htt,
 					     htt->max_num_ampdu,
 					     htt->max_num_amsdu);
 	if (status) {
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index a76f7c9e2199..f5fa86f6efad 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -357,6 +357,13 @@ struct htt_aggr_conf {
 	u8 max_num_amsdu_subframes;
 } __packed;
 
+struct htt_aggr_conf_v2 {
+	u8 max_num_ampdu_subframes;
+	/* amsdu_subframes is limited by 0x1F mask */
+	u8 max_num_amsdu_subframes;
+	u8 reserved;
+} __packed;
+
 #define HTT_MGMT_FRM_HDR_DOWNLOAD_LEN 32
 struct htt_mgmt_tx_desc_qca99x0 {
 	__le32 rate;
@@ -1650,6 +1657,7 @@ struct htt_cmd {
 		struct htt_stats_req stats_req;
 		struct htt_oob_sync_req oob_sync_req;
 		struct htt_aggr_conf aggr_conf;
+		struct htt_aggr_conf_v2 aggr_conf_v2;
 		struct htt_frag_desc_bank_cfg32 frag_desc_bank_cfg32;
 		struct htt_frag_desc_bank_cfg64 frag_desc_bank_cfg64;
 		struct htt_tx_fetch_resp tx_fetch_resp;
@@ -1890,6 +1898,9 @@ struct ath10k_htt_tx_ops {
 		      struct sk_buff *msdu);
 	int (*htt_alloc_txbuff)(struct ath10k_htt *htt);
 	void (*htt_free_txbuff)(struct ath10k_htt *htt);
+	int (*htt_h2t_aggr_cfg_msg)(struct ath10k_htt *htt,
+				    u8 max_subfrms_ampdu,
+				    u8 max_subfrms_amsdu);
 };
 
 static inline int ath10k_htt_send_rx_ring_cfg(struct ath10k_htt *htt)
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index ad05ab714c9b..336170a4fea6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1035,6 +1035,53 @@ int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 	return 0;
 }
 
+static int ath10k_htt_h2t_aggr_cfg_msg_v2(struct ath10k_htt *htt,
+					  u8 max_subfrms_ampdu,
+					  u8 max_subfrms_amsdu)
+{
+	struct ath10k *ar = htt->ar;
+	struct htt_aggr_conf_v2 *aggr_conf;
+	struct sk_buff *skb;
+	struct htt_cmd *cmd;
+	int len;
+	int ret;
+
+	/* Firmware defaults are: amsdu = 3 and ampdu = 64 */
+
+	if (max_subfrms_ampdu == 0 || max_subfrms_ampdu > 64)
+		return -EINVAL;
+
+	if (max_subfrms_amsdu == 0 || max_subfrms_amsdu > 31)
+		return -EINVAL;
+
+	len = sizeof(cmd->hdr);
+	len += sizeof(cmd->aggr_conf_v2);
+
+	skb = ath10k_htc_alloc_skb(ar, len);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_put(skb, len);
+	cmd = (struct htt_cmd *)skb->data;
+	cmd->hdr.msg_type = HTT_H2T_MSG_TYPE_AGGR_CFG;
+
+	aggr_conf = &cmd->aggr_conf_v2;
+	aggr_conf->max_num_ampdu_subframes = max_subfrms_ampdu;
+	aggr_conf->max_num_amsdu_subframes = max_subfrms_amsdu;
+
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt h2t aggr cfg msg amsdu %d ampdu %d",
+		   aggr_conf->max_num_amsdu_subframes,
+		   aggr_conf->max_num_ampdu_subframes);
+
+	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
+	if (ret) {
+		dev_kfree_skb_any(skb);
+		return ret;
+	}
+
+	return 0;
+}
+
 int ath10k_htt_tx_fetch_resp(struct ath10k *ar,
 			     __le32 token,
 			     __le16 fetch_seq_num,
@@ -1692,6 +1739,7 @@ static const struct ath10k_htt_tx_ops htt_tx_ops_32 = {
 	.htt_tx = ath10k_htt_tx_32,
 	.htt_alloc_txbuff = ath10k_htt_tx_alloc_cont_txbuf_32,
 	.htt_free_txbuff = ath10k_htt_tx_free_cont_txbuf_32,
+	.htt_h2t_aggr_cfg_msg = ath10k_htt_h2t_aggr_cfg_msg,
 };
 
 static const struct ath10k_htt_tx_ops htt_tx_ops_64 = {
@@ -1702,6 +1750,7 @@ static const struct ath10k_htt_tx_ops htt_tx_ops_64 = {
 	.htt_tx = ath10k_htt_tx_64,
 	.htt_alloc_txbuff = ath10k_htt_tx_alloc_cont_txbuf_64,
 	.htt_free_txbuff = ath10k_htt_tx_free_cont_txbuf_64,
+	.htt_h2t_aggr_cfg_msg = ath10k_htt_h2t_aggr_cfg_msg_v2,
 };
 
 static const struct ath10k_htt_tx_ops htt_tx_ops_hl = {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

