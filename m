Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EB9C10F00
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 695DF2177E
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553710422;
	bh=3h8MLSLdYZNXZCpWImKpVeJl9X2MCtFsAQznmr2Nn/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bfrAhWU5CkjZbE4nvXZqDhnl26Z1pLNy+Jrv1UypSWwVwH+AwW7SGKm16cs2vy0Fa
	 MybPwN8T94leIiJOe8FSy4NYPDjck4L7gra3vTvErL2BZ4l9qHP7mRLvr9Ks8J0Khu
	 ac1mtY+vbHcZ9MwComLJPO7v0fIjwtVIa2qFBAtk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389466AbfC0SNl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388559AbfC0SNk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:13:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3962A21741;
        Wed, 27 Mar 2019 18:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710419;
        bh=3h8MLSLdYZNXZCpWImKpVeJl9X2MCtFsAQznmr2Nn/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLHKmdG06kisIpsOsQ49tY+Zuc+zzid2j7jhJ3jzu8zjlBK8tZxyadBkhnYs0u4fE
         koUYiX9Z7ExDMfE2s6hbI7rSQn76iDnU0h6n6HGDd/2NAZ3LJ6PPalfBm56fn09KWc
         GPLSJkovF0mmz/jMfNYBP4SxCEAF2GYbi2oZ1rHg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 110/192] ath10k: fix shadow register implementation for WCN3990
Date:   Wed, 27 Mar 2019 14:09:02 -0400
Message-Id: <20190327181025.13507-110-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181025.13507-1-sashal@kernel.org>
References: <20190327181025.13507-1-sashal@kernel.org>
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
index 18c709c484e7..f761d651c16e 100644
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
@@ -1394,12 +1394,12 @@ static int ath10k_ce_alloc_shadow_base(struct ath10k *ar,
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
@@ -1453,7 +1453,7 @@ ath10k_ce_alloc_src_ring(struct ath10k *ar, unsigned int ce_id,
 		ret = ath10k_ce_alloc_shadow_base(ar, src_ring, nentries);
 		if (ret) {
 			dma_free_coherent(ar->dev,
-					  (nentries * sizeof(struct ce_desc) +
+					  (nentries * sizeof(struct ce_desc_64) +
 					   CE_DESC_RING_ALIGN),
 					  src_ring->base_addr_owner_space_unaligned,
 					  base_addr);
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index b8fb5382dede..8088f7a66426 100644
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

