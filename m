Return-Path: <SRS0=Z1rL=YC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92C3C47404
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 08:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B467620B7C
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 08:18:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HqPhkw3u";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Aln+mezi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfJIISl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Oct 2019 04:18:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51338 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJIISk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Oct 2019 04:18:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EF60261B08; Wed,  9 Oct 2019 08:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609120;
        bh=fkegv0laAJ4hlSt28jWVa0qekMb+Sxt77qJ84+gMelE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqPhkw3uBEJz8M4m+Lj1jqbniDmIHHFmSupmF5tbmv0cPJkgCVUv3/hhUt40HuDUB
         5xhQz0mm33MsG0m8puSAxzo+/4wz2CRP7YChRQvzwcdFYA+idsRWIYqeb2hWPXcA8G
         wJlbtNzMfdSFMY36bAnTrpTJ+ipr+OY5crr/umCg=
Received: from smtp.codeaurora.org (unknown [180.166.53.21])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: miaoqing@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 97BF161A1B;
        Wed,  9 Oct 2019 08:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609118;
        bh=fkegv0laAJ4hlSt28jWVa0qekMb+Sxt77qJ84+gMelE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aln+meziXaFPjbhKBqCILzpi+ZD34pOOzxhrv3tA4zSLMVwPtp5R54uVm6OghtV8h
         nCyYXGRhCzq+2uG3/lnawZxORkyVLymUN0xgZebjON6UEC2vbsYVWqwdWHv2I7exHM
         IIWwdAxl3hsNTghwhZyeT46fBmcj6o/bp/sgsxQc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 97BF161A1B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=miaoqing@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Wed, 09 Oct 2019 16:18:31 +0800
From:   Miaoqing Pan <miaoqing@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 2/2] ath10k: fix memory leak for tpc_stats_final
Date:   Wed,  9 Oct 2019 16:18:09 +0800
Message-Id: <1570609089-22071-2-git-send-email-miaoqing@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1570609089-22071-1-git-send-email-miaoqing@codeaurora.org>
References: <1570609089-22071-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The memory of ar->debug.tpc_stats_final is reallocated every debugfs
reading, it should be freed in ath10k_debug_destroy() for the last
allocation.

Tested HW: QCA9984
Tested FW: 10.4-3.9.0.2-00035

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 40baf25..04c50a2 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2532,6 +2532,7 @@ void ath10k_debug_destroy(struct ath10k *ar)
 	ath10k_debug_fw_stats_reset(ar);
 
 	kfree(ar->debug.tpc_stats);
+	kfree(ar->debug.tpc_stats_final);
 }
 
 int ath10k_debug_register(struct ath10k *ar)
-- 
1.9.1

