Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE65C4338F
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Aug 2021 06:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 559666127B
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Aug 2021 06:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhHWGd6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Aug 2021 02:33:58 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:44430
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229778AbhHWGd5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Aug 2021 02:33:57 -0400
Received: from localhost.localdomain (unknown [222.129.32.23])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 3D0F13F047;
        Mon, 23 Aug 2021 06:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629700394;
        bh=h+Lqrx8H7LFmJq35FTa1ano+uoUiw14tzRykgsn21aY=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=Pf3gWNoLWK9ZMYRbMud+Fp0XQcZFJf6Bg/N6xYN8pNVgXMQb/9YZtpYel5QJbdFrN
         3LdFDkzXx6CZ722tsWyYyjb8uF02uusjuvKMmAuZOHsHfl9rGb3s1PGKSRtT3Xp+BF
         DkVO5uwMbY81nvY8N4QhjZFb8DoTeAGZ1/3XtgZvYPqxy8kjrB7cpVnJtGz+D2aIuY
         mdISgHsA9dqWO3avZM602szwpTscLYa6fs0ETxE0BYHNjJcR84GYHlERUgd+wF49/7
         DJ+QMVmVAOkxQE0bhCkNhPkmgT1wqKBBEL37huCmrTIYB8UGO3lSZB8N6+z308GBL2
         SYPSrJKEbryCQ==
From:   Aaron Ma <aaron.ma@canonical.com>
To:     aaron.ma@canonical.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath11k: qmi: avoid error messages when dma allocation fails
Date:   Mon, 23 Aug 2021 14:32:58 +0800
Message-Id: <20210823063258.37747-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

qmi tries to allocate a large contiguous dma memory at first,
on the AMD Ryzen platform it fails, then retries with small slices.
So set flag GFP_NOWARN to avoid flooding dmesg.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index b5e34d670715..d6270e96d46c 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1770,7 +1770,7 @@ static int ath11k_qmi_alloc_target_mem_chunk(struct ath11k_base *ab)
 		chunk->vaddr = dma_alloc_coherent(ab->dev,
 						  chunk->size,
 						  &chunk->paddr,
-						  GFP_KERNEL);
+						  GFP_KERNEL | __GFP_NOWARN);
 		if (!chunk->vaddr) {
 			if (ab->qmi.mem_seg_count <= ATH11K_QMI_FW_MEM_REQ_SEGMENT_CNT) {
 				ath11k_dbg(ab, ATH11K_DBG_QMI,
-- 
2.30.2

