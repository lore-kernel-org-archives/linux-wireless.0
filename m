Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB42FC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 06:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABD8C20863
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 06:20:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NPG5NzLF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RLZw0NH/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfBLGUd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 01:20:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58006 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfBLGUd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 01:20:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1600D609FD; Tue, 12 Feb 2019 06:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549952432;
        bh=ZjtCz59BA7CsxZ2PDtzweVJXhYKUyWK4WSMUV/WvGYE=;
        h=From:To:Cc:Subject:Date:From;
        b=NPG5NzLFLOnkhHkvvO1LVGH1N3JmPnalDB1KRWWwwydTg+nr/4BPW2qbLByyfKooD
         4YXB4M5OnI865OY58bdDHjb5p9MtZDtkqHZOqYIUGsfrNT/47LKJWnfJT5KpTigr4J
         OhcpFchJ9iCCEA0DPOaFg3u4ws+vhHytU/UUqpAc=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 396F5609A8;
        Tue, 12 Feb 2019 06:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549952431;
        bh=ZjtCz59BA7CsxZ2PDtzweVJXhYKUyWK4WSMUV/WvGYE=;
        h=From:To:Cc:Subject:Date:From;
        b=RLZw0NH/voZQN1mqryrnqKMFbTRjsmNPEg7x10EcM2zr+/8nSx+CPc9s7ZwBVQ39O
         ND9nUy5Qszwvxz+tjW8sBP67Jo+Qyegzcq/KHj474Cx/GNh/JA++Bs4uB0Hb8lYaHz
         tkERUN1YJeDqHzH5bDs6ySY8ajH7444j65hWFAqA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 396F5609A8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Fix descriptor size in ce tx completion for WCN3990
Date:   Tue, 12 Feb 2019 11:50:23 +0530
Message-Id: <1549952423-25096-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When the driver receives the tx completion of the
descriptor over ce, it clears the nbytes configured
for that particular descriptor. WCN3990 uses ce
descriptors with 64-bit address.

Currently during handling the tx completion of the
descriptors, the nbytes are accessed from the descriptors
using ce_desc for 32-bit targets. This will lead to clearing
of memory at incorrect offset if DMA MASK is set to greater
than 32 bits.

Attach different ce tx copy completed handler for targets
using address above 32-bit address.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01387-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/ce.c | 64 +++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/ce.h |  2 ++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 8b4a910..0c6d0ae 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1077,7 +1077,7 @@ EXPORT_SYMBOL(ath10k_ce_revoke_recv_next);
  * Guts of ath10k_ce_completed_send_next.
  * The caller takes responsibility for any necessary locking.
  */
-int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
+static int _ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 					 void **per_transfer_contextp)
 {
 	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
@@ -1129,6 +1129,66 @@ int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 
 	return 0;
 }
+
+static int _ath10k_ce_completed_send_next_nolock_64(struct ath10k_ce_pipe *ce_state,
+					 void **per_transfer_contextp)
+{
+	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
+	u32 ctrl_addr = ce_state->ctrl_addr;
+	struct ath10k *ar = ce_state->ar;
+	unsigned int nentries_mask = src_ring->nentries_mask;
+	unsigned int sw_index = src_ring->sw_index;
+	unsigned int read_index;
+	struct ce_desc_64 *desc;
+
+	if (src_ring->hw_index == sw_index) {
+		/*
+		 * The SW completion index has caught up with the cached
+		 * version of the HW completion index.
+		 * Update the cached HW completion index to see whether
+		 * the SW has really caught up to the HW, or if the cached
+		 * value of the HW index has become stale.
+		 */
+
+		read_index = ath10k_ce_src_ring_read_index_get(ar, ctrl_addr);
+		if (read_index == 0xffffffff)
+			return -ENODEV;
+
+		read_index &= nentries_mask;
+		src_ring->hw_index = read_index;
+	}
+
+	if (ar->hw_params.rri_on_ddr)
+		read_index = ath10k_ce_src_ring_read_index_get(ar, ctrl_addr);
+	else
+		read_index = src_ring->hw_index;
+
+	if (read_index == sw_index)
+		return -EIO;
+
+	if (per_transfer_contextp)
+		*per_transfer_contextp =
+			src_ring->per_transfer_context[sw_index];
+
+	/* sanity */
+	src_ring->per_transfer_context[sw_index] = NULL;
+	desc = CE_SRC_RING_TO_DESC_64(src_ring->base_addr_owner_space,
+				   sw_index);
+	desc->nbytes = 0;
+
+	/* Update sw_index */
+	sw_index = CE_RING_IDX_INCR(nentries_mask, sw_index);
+	src_ring->sw_index = sw_index;
+
+	return 0;
+}
+
+int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
+					 void **per_transfer_contextp)
+{
+	return ce_state->ops->ce_completed_send_next_nolock(ce_state,
+							    per_transfer_contextp);
+}
 EXPORT_SYMBOL(ath10k_ce_completed_send_next_nolock);
 
 static void ath10k_ce_extract_desc_data(struct ath10k *ar,
@@ -1849,6 +1909,7 @@ static const struct ath10k_ce_ops ce_ops = {
 	.ce_send_nolock = _ath10k_ce_send_nolock,
 	.ce_set_src_ring_base_addr_hi = NULL,
 	.ce_set_dest_ring_base_addr_hi = NULL,
+	.ce_completed_send_next_nolock = _ath10k_ce_completed_send_next_nolock,
 };
 
 static const struct ath10k_ce_ops ce_64_ops = {
@@ -1863,6 +1924,7 @@ static const struct ath10k_ce_ops ce_64_ops = {
 	.ce_send_nolock = _ath10k_ce_send_nolock_64,
 	.ce_set_src_ring_base_addr_hi = ath10k_ce_set_src_ring_base_addr_hi,
 	.ce_set_dest_ring_base_addr_hi = ath10k_ce_set_dest_ring_base_addr_hi,
+	.ce_completed_send_next_nolock = _ath10k_ce_completed_send_next_nolock_64,
 };
 
 static void ath10k_ce_set_ops(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index c44a52e..dffb8a0 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -340,6 +340,8 @@ struct ath10k_ce_ops {
 	void (*ce_set_dest_ring_base_addr_hi)(struct ath10k *ar,
 					      u32 ce_ctrl_addr,
 					      u64 addr);
+	int (*ce_completed_send_next_nolock)(struct ath10k_ce_pipe *ce_state,
+					     void **per_transfer_contextp);
 };
 
 static inline u32 ath10k_ce_base_address(struct ath10k *ar, unsigned int ce_id)
-- 
2.7.4

