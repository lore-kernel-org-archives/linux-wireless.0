Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89598C282CA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 435A32190B
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:43:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OXHx4db9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JWSb6eXF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731998AbfBLSnA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:43:00 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36256 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfBLSnA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 13:43:00 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8467460878; Tue, 12 Feb 2019 18:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549996979;
        bh=+l83vwo8MrEu03LvD9kCqaiHbm+0qgj5lWHvDhov3cU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OXHx4db9uybQ+8N+6c4hPxu7YsCOindkTQ9+5opgTc73EpxjFkjZkU8Aeqr3nOmiY
         23vc1Kw01CA9eulO3l+zZ09fE59vr41GdjzDi/nsuNr6QNpvaUid5B2mJc37Lzopkd
         sl9f95aLZeFU6nFn9wNshLk+ZEIzUv+hWk1PoK8c=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 796C460208;
        Tue, 12 Feb 2019 18:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549996979;
        bh=+l83vwo8MrEu03LvD9kCqaiHbm+0qgj5lWHvDhov3cU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=JWSb6eXF1eeuRNPotobx+BfMOIwQ48Ec6IKTNYCIzzHPAxKxAjM3tR9LRsniT8pYC
         E79+hq2drZOqtL/3ob44XvXAzG+JYdEdStmYYM4TGktOsZJfqSWuTpA+BmiQbBC2pl
         Mu9Vem5sQW3DEU3vN1z6G/LqZ5W8TppHxUdANwXg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 796C460208
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: fix line length warning in
 ath10k_ce_alloc_dest_ring()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1549636171-32628-1-git-send-email-kvalo@codeaurora.org>
References: <1549636171-32628-1-git-send-email-kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190212184259.8467460878@smtp.codeaurora.org>
Date:   Tue, 12 Feb 2019 18:42:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> wrote:

> Commit 750afb08ca71 ("cross-tree: phase out dma_zalloc_coherent()") introduced
> a new checkpatch warning:
> 
> drivers/net/wireless/ath/ath10k/ce.c:1602: line over 90 characters
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

acc65103c15c ath10k: fix line length warning in ath10k_ce_alloc_dest_ring()

-- 
https://patchwork.kernel.org/patch/10803205/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

