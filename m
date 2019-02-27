Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5517BC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 07:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15D45218D0
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 07:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Q3UtaUv1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Q3UtaUv1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbfB0HN6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 02:13:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46670 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfB0HN6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 02:13:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EB60060E7A; Wed, 27 Feb 2019 07:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551251636;
        bh=B7k7Q3hEHa3z40Pnv/U6OSqNCHOZU29S1i2SuAh24WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3UtaUv1gCLprtYq18qn6OTvyVemH6Z1KEm6XvYbytdShX38tLRLbWMxY94+cCVCr
         Wa/DpVIvOm0PwF1Vssja7+6Up8SsIhgmD1KXndf2AkQW6kSkyIdRjVi6qbSNmBDOoQ
         G1ydX1HihAX3RR4FI/vQuaqx9j0cNe2fB8N1qZE0=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3593D60AA3;
        Wed, 27 Feb 2019 07:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551251636;
        bh=B7k7Q3hEHa3z40Pnv/U6OSqNCHOZU29S1i2SuAh24WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3UtaUv1gCLprtYq18qn6OTvyVemH6Z1KEm6XvYbytdShX38tLRLbWMxY94+cCVCr
         Wa/DpVIvOm0PwF1Vssja7+6Up8SsIhgmD1KXndf2AkQW6kSkyIdRjVi6qbSNmBDOoQ
         G1ydX1HihAX3RR4FI/vQuaqx9j0cNe2fB8N1qZE0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3593D60AA3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH 1/2] ath10k: Add support for adding htt_rx_ops based on htt_version
Date:   Wed, 27 Feb 2019 12:43:47 +0530
Message-Id: <1551251628-22518-2-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551251628-22518-1-git-send-email-svishnoi@codeaurora.org>
References: <1551251628-22518-1-git-send-email-svishnoi@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Refactor the code to add the support to attach htt_rx_ops
based on HTT version.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt.h    |  3 ++-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 29 ++++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index fef716a..0ab29bd 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1894,7 +1894,7 @@ struct ath10k_htt {
 
 	bool tx_mem_allocated;
 	const struct ath10k_htt_tx_ops *tx_ops;
-	const struct ath10k_htt_rx_ops *rx_ops;
+	struct ath10k_htt_rx_ops *rx_ops;
 };
 
 struct ath10k_htt_tx_ops {
@@ -1969,6 +1969,7 @@ struct ath10k_htt_rx_ops {
 				    int idx);
 	void* (*htt_get_vaddr_ring)(struct ath10k_htt *htt);
 	void (*htt_reset_paddrs_ring)(struct ath10k_htt *htt, int idx);
+	void (*htt_fetch_peer_stats)(struct ath10k *ar, struct sk_buff *skb);
 };
 
 static inline size_t ath10k_htt_get_rx_ring_size(struct ath10k_htt *htt)
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 4fc8856..c7a2411 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -3143,6 +3143,11 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 						    rate_idx);
 }
 
+static void ath10k_htt_fetch_peer_stats_tlv(struct ath10k *ar,
+					    struct sk_buff *skb)
+{
+}
+
 static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
 					struct sk_buff *skb)
 {
@@ -3556,7 +3561,7 @@ int ath10k_htt_txrx_compl_task(struct ath10k *ar, int budget)
 }
 EXPORT_SYMBOL(ath10k_htt_txrx_compl_task);
 
-static const struct ath10k_htt_rx_ops htt_rx_ops_32 = {
+static struct ath10k_htt_rx_ops htt_rx_ops_32 = {
 	.htt_get_rx_ring_size = ath10k_htt_get_rx_ring_size_32,
 	.htt_config_paddrs_ring = ath10k_htt_config_paddrs_ring_32,
 	.htt_set_paddrs_ring = ath10k_htt_set_paddrs_ring_32,
@@ -3564,7 +3569,10 @@ int ath10k_htt_txrx_compl_task(struct ath10k *ar, int budget)
 	.htt_reset_paddrs_ring = ath10k_htt_reset_paddrs_ring_32,
 };
 
-static const struct ath10k_htt_rx_ops htt_rx_ops_64 = {
+/* FIXME: Some other way to attach ops to static const htt rx_ops
+ * without removing const??
+ */
+static struct ath10k_htt_rx_ops htt_rx_ops_64 = {
 	.htt_get_rx_ring_size = ath10k_htt_get_rx_ring_size_64,
 	.htt_config_paddrs_ring = ath10k_htt_config_paddrs_ring_64,
 	.htt_set_paddrs_ring = ath10k_htt_set_paddrs_ring_64,
@@ -3572,7 +3580,7 @@ int ath10k_htt_txrx_compl_task(struct ath10k *ar, int budget)
 	.htt_reset_paddrs_ring = ath10k_htt_reset_paddrs_ring_64,
 };
 
-static const struct ath10k_htt_rx_ops htt_rx_ops_hl = {
+static struct ath10k_htt_rx_ops htt_rx_ops_hl = {
 };
 
 void ath10k_htt_set_rx_ops(struct ath10k_htt *htt)
@@ -3585,4 +3593,19 @@ void ath10k_htt_set_rx_ops(struct ath10k_htt *htt)
 		htt->rx_ops = &htt_rx_ops_64;
 	else
 		htt->rx_ops = &htt_rx_ops_32;
+
+	switch (ar->running_fw->fw_file.htt_op_version) {
+	case ATH10K_FW_HTT_OP_VERSION_MAIN:
+	case ATH10K_FW_HTT_OP_VERSION_10_1:
+	case ATH10K_FW_HTT_OP_VERSION_10_4:
+		htt->rx_ops->htt_fetch_peer_stats = ath10k_htt_fetch_peer_stats;
+	break;
+	case ATH10K_FW_HTT_OP_VERSION_TLV:
+		htt->rx_ops->htt_fetch_peer_stats = ath10k_htt_fetch_peer_stats_tlv;
+	break;
+	case ATH10K_FW_HTT_OP_VERSION_MAX:
+	case ATH10K_FW_HTT_OP_VERSION_UNSET:
+		WARN_ON(1);
+	return;
+	}
 }
-- 
1.9.1

