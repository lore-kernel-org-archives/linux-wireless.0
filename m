Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F88C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99DEE206C0
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714484;
	bh=hYwPbMhv4w8FEs0HKB1wEqsF+gEKZRKNcFtSFt6VcJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=j/zRxvb+iFRv8FUExd2ZzBX7vqVd8shHg3iV2uk6gvvpoRBT7rz0jKVPXqw2W19ZC
	 dr0hIjJkiR3iKNc8cFPiwKSpPpyQ9zs52zUZOdhA5RDbYgOC+m0DbMe+bTUr6Fvv92
	 4OYhEZ87KV8c+rVFec63S93ny6tJ+LkT99NRa7oU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388061AbfC0SG6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388048AbfC0SG4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:06:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAFA021850;
        Wed, 27 Mar 2019 18:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710015;
        bh=hYwPbMhv4w8FEs0HKB1wEqsF+gEKZRKNcFtSFt6VcJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtGAljHkQkOO94mp41tB+P+kI7wm05gp8iE8q28fH2GFB5CLQSxJEHW0A2jx6Dw3Z
         KBaifmcvLl1jFkTNzUvOF67KwtSneIHf6ZXHgH562XazWkZOXUqU6VIS1BfSyNj7Q6
         zqBza3OanwPyoYj72PB7OuX7yTZOyKzDsDe0u8FI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 157/262] ath10k: fix shadow register implementation for WCN3990
Date:   Wed, 27 Mar 2019 14:00:12 -0400
Message-Id: <20190327180158.10245-157-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit 1863008369ae0407508033b4b00f98b985adeb15 ]

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/ce.c | 26 +++++++++++++-------------
 drivers/net/wireless/ath/ath10k/ce.h |  2 +-
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 2a5668b4f6bc..1a1ea4bbf8a0 100644
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
index ead9987c3259..463e2fc8b501 100644
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
2.19.1

