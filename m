Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B35A7C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FDAA20869
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BTCC+N5O";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BTCC+N5O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfBHO3g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:29:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38462 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfBHO3g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 09:29:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AE7EF60351; Fri,  8 Feb 2019 14:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549636175;
        bh=mrkDF5WjMirddKQt4tuBCGn2JPtwL04BwQ2FT1Sxjgc=;
        h=From:To:Cc:Subject:Date:From;
        b=BTCC+N5OCtBbbOdWiC+puzICTmsH96EFYyh0umPhekwgz9BTVW5iktO6CAwYLCDw9
         1HJDerBJQ/kjZLRpcqjxcZsNVcxFWCHtgHG5NPStOTcNC6qVmnK3S7QGZFaL2FubgX
         Dx2pOG8U1JKBVJjSDPwQ5xql2S1LhDSbtv+f/PwY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8B6A5602CB;
        Fri,  8 Feb 2019 14:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549636175;
        bh=mrkDF5WjMirddKQt4tuBCGn2JPtwL04BwQ2FT1Sxjgc=;
        h=From:To:Cc:Subject:Date:From;
        b=BTCC+N5OCtBbbOdWiC+puzICTmsH96EFYyh0umPhekwgz9BTVW5iktO6CAwYLCDw9
         1HJDerBJQ/kjZLRpcqjxcZsNVcxFWCHtgHG5NPStOTcNC6qVmnK3S7QGZFaL2FubgX
         Dx2pOG8U1JKBVJjSDPwQ5xql2S1LhDSbtv+f/PwY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8B6A5602CB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: fix line length warning in ath10k_ce_alloc_dest_ring()
Date:   Fri,  8 Feb 2019 16:29:31 +0200
Message-Id: <1549636171-32628-1-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Commit 750afb08ca71 ("cross-tree: phase out dma_zalloc_coherent()") introduced
a new checkpatch warning:

drivers/net/wireless/ath/ath10k/ce.c:1602: line over 90 characters

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/ce.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 8b4a9102d7eb..17ff65937136 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1599,7 +1599,8 @@ ath10k_ce_alloc_dest_ring(struct ath10k *ar, unsigned int ce_id,
 	 */
 	dest_ring->base_addr_owner_space_unaligned =
 		dma_alloc_coherent(ar->dev,
-				   (nentries * sizeof(struct ce_desc) + CE_DESC_RING_ALIGN),
+				   (nentries * sizeof(struct ce_desc) +
+				    CE_DESC_RING_ALIGN),
 				   &base_addr, GFP_KERNEL);
 	if (!dest_ring->base_addr_owner_space_unaligned) {
 		kfree(dest_ring);
-- 
2.7.4

