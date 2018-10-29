Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21E2C46475
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 06:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F8632054F
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 06:21:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CN0ugUdv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="e1IJ0i05"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F8632054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbeJ2PJG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 11:09:06 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42152 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729058AbeJ2PJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 11:09:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 246FB6021A; Mon, 29 Oct 2018 06:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540794111;
        bh=52YSq01AaFTYT+bP302Ky9M8zX0eTVPVK3Kia5ZuA2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CN0ugUdvBUpslnUM32ptjQOEXC0OfAr7MU0IIfK2kq+2iZbyb9zOHmrHmObQqZLG8
         C9+VXy3miVrNCp9fIHspTHEcp2R4t7mOlFTuUDmg6x85xTMrd/WXPdvtFlN6I62Wbh
         dmOiLIpYxQqTn7fVFoQycgZVxKSuhyEYEKZEOQGA=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: yyuwang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B62AF6030F;
        Mon, 29 Oct 2018 06:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540794110;
        bh=52YSq01AaFTYT+bP302Ky9M8zX0eTVPVK3Kia5ZuA2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1IJ0i05kc22ZFLVJ7FiX+uY0c1rFoyGLsxkFhiMtqgsaCC4PqVOsGFVivhBKP2KW
         m1vwaZRgWwlpUJ87RCACBZjTNrWQm8xnqmd9DwsnxCkXXgEU+8FO4qdUzYFmeUUQPa
         Y+TBDKLvlCthQP4zSGPah1yZfJB9uBSE2Fq67g7s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B62AF6030F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=yyuwang@codeaurora.org
From:   Yu Wang <yyuwang@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: add amsdu support for monitor mode
Date:   Mon, 29 Oct 2018 14:21:44 +0800
Message-Id: <1540794104-30957-2-git-send-email-yyuwang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540794104-30957-1-git-send-email-yyuwang@codeaurora.org>
References: <1540794104-30957-1-git-send-email-yyuwang@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When processing HTT_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND,
if the length of a msdu is larger than the tailroom
of the rx skb, skb_over_panic issue will happen when
calling skb_put.
In monitor mode, amsdu will be handled in this path,
and msdu_len of the first msdu_desc is the length of
the entire amsdu, which might be larger than the
maximum length of a skb, in such case, it will hit
the issue upon.
To fix this issue, processing msdu list separately
for monitor mode.

Successfully tested with:
QCA6174 (FW version: RM.4.4.1.c2-00057-QCARMSWP-1).

Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 187 +++++++++++++++++++++++++++++++
 1 file changed, 187 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index ffec98f..8f88229 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -469,6 +469,167 @@ static struct sk_buff *ath10k_htt_rx_pop_paddr(struct ath10k_htt *htt,
 	return msdu;
 }
 
+static inline void
+ath10k_htt_append_frag_list(struct sk_buff *skb_head,
+			    struct sk_buff *frag_list,
+			    unsigned int frag_len)
+{
+	skb_shinfo(skb_head)->frag_list = frag_list;
+	skb_head->data_len = frag_len;
+	skb_head->len += skb_head->data_len;
+}
+
+static int
+ath10k_htt_rx_handle_amsdu_mon_32(struct ath10k_htt *htt, struct sk_buff *msdu,
+				  struct htt_rx_in_ord_msdu_desc **msdu_desc)
+{
+	struct ath10k *ar = htt->ar;
+	u32 paddr;
+	struct sk_buff *frag_buf;
+	struct sk_buff *prev_frag_buf;
+	u8 last_frag;
+	struct htt_rx_in_ord_msdu_desc *ind_desc = *msdu_desc;
+	struct htt_rx_desc *rxd;
+	int amsdu_len = __le16_to_cpu(ind_desc->msdu_len);
+
+	rxd = (void *)msdu->data;
+	trace_ath10k_htt_rx_desc(ar, rxd, sizeof(*rxd));
+
+	skb_put(msdu, sizeof(struct htt_rx_desc));
+	skb_pull(msdu, sizeof(struct htt_rx_desc));
+	skb_put(msdu, min(amsdu_len, HTT_RX_MSDU_SIZE));
+	amsdu_len -= msdu->len;
+
+	last_frag = ind_desc->reserved;
+	if (last_frag) {
+		if (amsdu_len) {
+			ath10k_warn(ar, "invalid amsdu len %u, left %d",
+				    __le16_to_cpu(ind_desc->msdu_len),
+				    amsdu_len);
+		}
+		return 0;
+	}
+
+	ind_desc++;
+	paddr = __le32_to_cpu(ind_desc->msdu_paddr);
+	frag_buf = ath10k_htt_rx_pop_paddr(htt, paddr);
+	if (!frag_buf) {
+		ath10k_warn(ar, "failed to pop frag-1 paddr: 0x%x", paddr);
+		return -ENOENT;
+	}
+
+	skb_put(frag_buf, min(amsdu_len, HTT_RX_BUF_SIZE));
+	ath10k_htt_append_frag_list(msdu, frag_buf, amsdu_len);
+
+	amsdu_len -= frag_buf->len;
+	prev_frag_buf = frag_buf;
+	last_frag = ind_desc->reserved;
+	while (!last_frag) {
+		ind_desc++;
+		paddr = __le32_to_cpu(ind_desc->msdu_paddr);
+		frag_buf = ath10k_htt_rx_pop_paddr(htt, paddr);
+		if (!frag_buf) {
+			ath10k_warn(ar, "failed to pop frag-n paddr: 0x%x",
+				    paddr);
+			prev_frag_buf->next = NULL;
+			return -ENOENT;
+		}
+
+		skb_put(frag_buf, min(amsdu_len, HTT_RX_BUF_SIZE));
+		last_frag = ind_desc->reserved;
+		amsdu_len -= frag_buf->len;
+
+		prev_frag_buf->next = frag_buf;
+		prev_frag_buf = frag_buf;
+	}
+
+	if (amsdu_len) {
+		ath10k_warn(ar, "invalid amsdu len %u, left %d",
+			    __le16_to_cpu(ind_desc->msdu_len), amsdu_len);
+	}
+
+	*msdu_desc = ind_desc;
+
+	prev_frag_buf->next = NULL;
+	return 0;
+}
+
+static int
+ath10k_htt_rx_handle_amsdu_mon_64(struct ath10k_htt *htt, struct sk_buff *msdu,
+				  struct htt_rx_in_ord_msdu_desc_ext
+				  **msdu_desc)
+{
+	struct ath10k *ar = htt->ar;
+	u64 paddr;
+	struct sk_buff *frag_buf;
+	struct sk_buff *prev_frag_buf;
+	u8 last_frag;
+	struct htt_rx_in_ord_msdu_desc_ext *ind_desc = *msdu_desc;
+	struct htt_rx_desc *rxd;
+	int amsdu_len = __le16_to_cpu(ind_desc->msdu_len);
+
+	rxd = (void *)msdu->data;
+	trace_ath10k_htt_rx_desc(ar, rxd, sizeof(*rxd));
+
+	skb_put(msdu, sizeof(struct htt_rx_desc));
+	skb_pull(msdu, sizeof(struct htt_rx_desc));
+	skb_put(msdu, min(amsdu_len, HTT_RX_MSDU_SIZE));
+	amsdu_len -= msdu->len;
+
+	last_frag = ind_desc->reserved;
+	if (last_frag) {
+		if (amsdu_len) {
+			ath10k_warn(ar, "invalid amsdu len %u, left %d",
+				    __le16_to_cpu(ind_desc->msdu_len),
+				    amsdu_len);
+		}
+		return 0;
+	}
+
+	ind_desc++;
+	paddr = __le64_to_cpu(ind_desc->msdu_paddr);
+	frag_buf = ath10k_htt_rx_pop_paddr(htt, paddr);
+	if (!frag_buf) {
+		ath10k_warn(ar, "failed to pop frag-1 paddr: 0x%llx", paddr);
+		return -ENOENT;
+	}
+
+	skb_put(frag_buf, min(amsdu_len, HTT_RX_BUF_SIZE));
+	ath10k_htt_append_frag_list(msdu, frag_buf, amsdu_len);
+
+	amsdu_len -= frag_buf->len;
+	prev_frag_buf = frag_buf;
+	last_frag = ind_desc->reserved;
+	while (!last_frag) {
+		ind_desc++;
+		paddr = __le64_to_cpu(ind_desc->msdu_paddr);
+		frag_buf = ath10k_htt_rx_pop_paddr(htt, paddr);
+		if (!frag_buf) {
+			ath10k_warn(ar, "failed to pop frag-n paddr: 0x%llx",
+				    paddr);
+			prev_frag_buf->next = NULL;
+			return -ENOENT;
+		}
+
+		skb_put(frag_buf, min(amsdu_len, HTT_RX_BUF_SIZE));
+		last_frag = ind_desc->reserved;
+		amsdu_len -= frag_buf->len;
+
+		prev_frag_buf->next = frag_buf;
+		prev_frag_buf = frag_buf;
+	}
+
+	if (amsdu_len) {
+		ath10k_warn(ar, "invalid amsdu len %u, left %d",
+			    __le16_to_cpu(ind_desc->msdu_len), amsdu_len);
+	}
+
+	*msdu_desc = ind_desc;
+
+	prev_frag_buf->next = NULL;
+	return 0;
+}
+
 static int ath10k_htt_rx_pop_paddr32_list(struct ath10k_htt *htt,
 					  struct htt_rx_in_ord_ind *ev,
 					  struct sk_buff_head *list)
@@ -495,6 +656,19 @@ static int ath10k_htt_rx_pop_paddr32_list(struct ath10k_htt *htt,
 			return -ENOENT;
 		}
 
+		if (!is_offload && ar->monitor_arvif) {
+			int ret =
+				ath10k_htt_rx_handle_amsdu_mon_32(htt, msdu,
+								  &msdu_desc);
+			if (ret) {
+				__skb_queue_purge(list);
+				return ret;
+			}
+			__skb_queue_tail(list, msdu);
+			msdu_desc++;
+			continue;
+		}
+
 		__skb_queue_tail(list, msdu);
 
 		if (!is_offload) {
@@ -544,6 +718,19 @@ static int ath10k_htt_rx_pop_paddr64_list(struct ath10k_htt *htt,
 			return -ENOENT;
 		}
 
+		if (!is_offload && ar->monitor_arvif) {
+			int ret =
+				ath10k_htt_rx_handle_amsdu_mon_64(htt, msdu,
+								  &msdu_desc);
+			if (ret) {
+				__skb_queue_purge(list);
+				return ret;
+			}
+			__skb_queue_tail(list, msdu);
+			msdu_desc++;
+			continue;
+		}
+
 		__skb_queue_tail(list, msdu);
 
 		if (!is_offload) {
-- 
1.9.1

