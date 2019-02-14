Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60830C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 03:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CB2820811
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 03:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Smk4Ws/P";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Smk4Ws/P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388285AbfBNDKz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 22:10:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36898 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732430AbfBNDKy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 22:10:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D0183608CB; Thu, 14 Feb 2019 03:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550113853;
        bh=AlorVu/NA75b5bDTDkGK6cE9q3wc6Xqy5BN6BO+66uw=;
        h=From:To:Cc:Subject:Date:From;
        b=Smk4Ws/PRd9T9VNi0yTBtqiAj+RVZ7UQWAuYw+ZnkcvmG3mId7pwLbpJg2jtMakeQ
         aW0glqDO2otKgBWdA/KZ8Fx29Qh9vOJglOw/Ke56MqLkIw6d2oULoCslW0h+UKcvyE
         GpOMxepwOeDcbL2padf9D4Xun583kZ+JHnxR3veo=
Received: from rex.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: yyuwang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 00DFA60854;
        Thu, 14 Feb 2019 03:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550113853;
        bh=AlorVu/NA75b5bDTDkGK6cE9q3wc6Xqy5BN6BO+66uw=;
        h=From:To:Cc:Subject:Date:From;
        b=Smk4Ws/PRd9T9VNi0yTBtqiAj+RVZ7UQWAuYw+ZnkcvmG3mId7pwLbpJg2jtMakeQ
         aW0glqDO2otKgBWdA/KZ8Fx29Qh9vOJglOw/Ke56MqLkIw6d2oULoCslW0h+UKcvyE
         GpOMxepwOeDcbL2padf9D4Xun583kZ+JHnxR3veo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 00DFA60854
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=yyuwang@codeaurora.org
From:   Yu Wang <yyuwang@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Yu Wang <yyuwang@codeaurora.org>
Subject: [PATCH] ath10k: correct the format of host memory chunks in wmi init command
Date:   Thu, 14 Feb 2019 11:10:34 +0800
Message-Id: <20190214031034.26969-1-yyuwang@codeaurora.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a theoretical fix, the issue is found in code review.
When adding the host memory chunks into wmi-tlv init command,
there is no separate tlv header for each host memory chunk
in the struct array, which breaches the convention between
host and firmware, will result in mismatch between the two.

To fix this issue, add separate tlv headers for the host
memory chunks in wmi-tlv init command.

Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 39 +++++++++++++++++++++--
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 5d05bff2c5da..a81c6faa2fd7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1580,17 +1580,50 @@ ath10k_wmi_tlv_op_gen_pdev_set_param(struct ath10k *ar, u32 param_id,
 	return skb;
 }
 
+static void
+ath10k_wmi_tlv_put_host_mem_chunks(struct ath10k *ar, void *host_mem_chunks)
+{
+	struct host_memory_chunk *chunk;
+	struct wmi_tlv *tlv;
+	int i;
+	__le16 tlv_len, tlv_tag;
+
+	tlv_tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_WLAN_HOST_MEMORY_CHUNK);
+	tlv_len = __cpu_to_le16(sizeof(*chunk));
+	for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
+		tlv = host_mem_chunks;
+		tlv->tag = tlv_tag;
+		tlv->len = tlv_len;
+		chunk = (void *)tlv->value;
+
+		chunk->ptr = __cpu_to_le32(ar->wmi.mem_chunks[i].paddr);
+		chunk->size = __cpu_to_le32(ar->wmi.mem_chunks[i].len);
+		chunk->req_id = __cpu_to_le32(ar->wmi.mem_chunks[i].req_id);
+
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
+			   "wmi-tlv chunk %d len %d, addr 0x%llx, id 0x%x\n",
+			   i,
+			   ar->wmi.mem_chunks[i].len,
+			   (unsigned long long)ar->wmi.mem_chunks[i].paddr,
+			   ar->wmi.mem_chunks[i].req_id);
+
+		host_mem_chunks += sizeof(*tlv);
+		host_mem_chunks += sizeof(*chunk);
+	}
+}
+
 static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 {
 	struct sk_buff *skb;
 	struct wmi_tlv *tlv;
 	struct wmi_tlv_init_cmd *cmd;
 	struct wmi_tlv_resource_config *cfg;
-	struct wmi_host_mem_chunks *chunks;
+	void *chunks;
 	size_t len, chunks_len;
 	void *ptr;
 
-	chunks_len = ar->wmi.num_mem_chunks * sizeof(struct host_memory_chunk);
+	chunks_len = ar->wmi.num_mem_chunks *
+		     (sizeof(struct host_memory_chunk) + sizeof(*tlv));
 	len = (sizeof(*tlv) + sizeof(*cmd)) +
 	      (sizeof(*tlv) + sizeof(*cfg)) +
 	      (sizeof(*tlv) + chunks_len);
@@ -1690,7 +1723,7 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->num_ocb_schedules = __cpu_to_le32(0);
 	cfg->host_capab = __cpu_to_le32(WMI_TLV_FLAG_MGMT_BUNDLE_TX_COMPL);
 
-	ath10k_wmi_put_host_mem_chunks(ar, chunks);
+	ath10k_wmi_tlv_put_host_mem_chunks(ar, chunks);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv init\n");
 	return skb;
-- 
2.20.1

