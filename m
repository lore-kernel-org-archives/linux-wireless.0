Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A12C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3362620663
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:54:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PG8p0W2F";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZXb8LFjn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfA2JyQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:54:16 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfA2JyQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 04:54:16 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F32C960712; Tue, 29 Jan 2019 09:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548755655;
        bh=sTZA/5WN/ib3zZC8/+PByx2zj+Ns2TsHtmiSpC1T5Yg=;
        h=From:To:Cc:Subject:Date:From;
        b=PG8p0W2FdhfYWbpXCZDPxiUfh60qjGyEGoIgT/u6JGxdHjKbw9gxFW5i+EJH+dUd0
         btuqRXSyW7Gex2wERLJ1TUWQf5/9zevI/x9DRQrmbOEz/gqialmuwf54gQDi5F6AqB
         2UFeYCgQzEbpXCU711v1Snh6AVHk/rsocVKY1Lw8=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0B77560314;
        Tue, 29 Jan 2019 09:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548755654;
        bh=sTZA/5WN/ib3zZC8/+PByx2zj+Ns2TsHtmiSpC1T5Yg=;
        h=From:To:Cc:Subject:Date:From;
        b=ZXb8LFjnuNSM1ORldQ/bRpZQ/xT5xDQI7GNnGKkbs463Dc/rcRjvzVc6uQ01oqJze
         ZikQN3s/CUrHNAOACMjXsk6LGpEk5u+o5x0jBK/VnNRQ/DXlzq1wWkbt2eWpzCtMkz
         vZwSsyT73QtBx7r8RmBQ2x3LPMI0l+8yF1DtQ8fU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0B77560314
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Fix shadow register implementation for WCN3990
Date:   Tue, 29 Jan 2019 15:24:07 +0530
Message-Id: <1548755647-23356-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 supports shadow registers write operation support
for copy engine for regular operation in powersave mode.

Since WCN3990 is a 64-bit target, the shadow register
implementation needs to be done in the copy engine handlers
for 64-bit target. Currently the shadow register implementation
is present in the 32-bit target handlers of copy engine.

Fix the shadow register copy engine write operation
implementation for 64-bit target(WCN3990).

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Fixes: b7ba83f7c414 ("ath10k: add support for shadow register for WNC3990")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/ce.c | 26 +++++++++++++-------------
 drivers/net/wireless/ath/ath10k/ce.h |  2 +-
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index f6d3ecb..31b9e46 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -500,14 +500,8 @@ static int _ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 	write_index = CE_RING_IDX_INCR(nentries_mask, write_index);
 
 	/* WORKAROUND */
-	if (!(flags & CE_SEND_FLAG_GATHER)) {
-		if (ar->hw_params.shadow_reg_support)
-			ath10k_ce_shadow_src_ring_write_index_set(ar, ce_state,
-								  write_index);
-		else
-			ath10k_ce_src_ring_write_index_set(ar, ctrl_addr,
-							   write_index);
-	}
+	if (!(flags & CE_SEND_FLAG_GATHER))
+		ath10k_ce_src_ring_write_index_set(ar, ctrl_addr, write_index);
 
 	src_ring->write_index = write_index;
 exit:
@@ -581,8 +575,14 @@ static int _ath10k_ce_send_nolock_64(struct ath10k_ce_pipe *ce_state,
 	/* Update Source Ring Write Index */
 	write_index = CE_RING_IDX_INCR(nentries_mask, write_index);
 
-	if (!(flags & CE_SEND_FLAG_GATHER))
-		ath10k_ce_src_ring_write_index_set(ar, ctrl_addr, write_index);
+	if (!(flags & CE_SEND_FLAG_GATHER)) {
+		if (ar->hw_params.shadow_reg_support)
+			ath10k_ce_shadow_src_ring_write_index_set(ar, ce_state,
+								  write_index);
+		else
+			ath10k_ce_src_ring_write_index_set(ar, ctrl_addr,
+							   write_index);
+	}
 
 	src_ring->write_index = write_index;
 exit:
@@ -1404,12 +1404,12 @@ static int ath10k_ce_alloc_shadow_base(struct ath10k *ar,
 				       u32 nentries)
 {
 	src_ring->shadow_base_unaligned = kcalloc(nentries,
-						  sizeof(struct ce_desc),
+						  sizeof(struct ce_desc_64),
 						  GFP_KERNEL);
 	if (!src_ring->shadow_base_unaligned)
 		return -ENOMEM;
 
-	src_ring->shadow_base = (struct ce_desc *)
+	src_ring->shadow_base = (struct ce_desc_64 *)
 			PTR_ALIGN(src_ring->shadow_base_unaligned,
 				  CE_DESC_RING_ALIGN);
 	return 0;
@@ -1461,7 +1461,7 @@ ath10k_ce_alloc_src_ring(struct ath10k *ar, unsigned int ce_id,
 		ret = ath10k_ce_alloc_shadow_base(ar, src_ring, nentries);
 		if (ret) {
 			dma_free_coherent(ar->dev,
-					  (nentries * sizeof(struct ce_desc) +
+					  (nentries * sizeof(struct ce_desc_64) +
 					   CE_DESC_RING_ALIGN),
 					  src_ring->base_addr_owner_space_unaligned,
 					  base_addr);
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index ead9987..463e2fc 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -118,7 +118,7 @@ struct ath10k_ce_ring {
 	u32 base_addr_ce_space;
 
 	char *shadow_base_unaligned;
-	struct ce_desc *shadow_base;
+	struct ce_desc_64 *shadow_base;
 
 	/* keep last */
 	void *per_transfer_context[0];
-- 
2.7.4

