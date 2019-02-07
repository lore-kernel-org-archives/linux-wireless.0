Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C986AC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9709821872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:44:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z4SNLxN3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oQcwkYCs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfBGOok (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:44:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49078 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfBGOok (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:44:40 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CB3E6605FC; Thu,  7 Feb 2019 14:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549550679;
        bh=xAx3fAoSFvGPAflm/n/+uDeuXWypxIbdbHICFmGX8NQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Z4SNLxN38QOcOPsUe/1q/dHvfJVUhfv3ZDqOnJgEznVLy5kmmwDP8WJmjCZCZ83V4
         nSn6wtsDwROTh4JL/2403lq4AUQI2s3YsSvyXgQmY8KuIWYQChUPez+SP8Cuafhej3
         2m3i72VLr98q2acJ0WvhByIjLSmfprroJ+aTDH7I=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8F84F602CC;
        Thu,  7 Feb 2019 14:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549550679;
        bh=xAx3fAoSFvGPAflm/n/+uDeuXWypxIbdbHICFmGX8NQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=oQcwkYCsCK6KsmalIGxC4XJKPYH7dA/rIaV42OU0ZTDeiwk3aQJpnujbaC4zwU8xt
         goeEX9tKtiVMGOJ3mIZUh8++kU7DVax++WPQ4Anoq8kzFWoEGncNW1mFeVBECbtAxR
         Z6rydliddL7CY9nANNe4D4Rfa8lOrd2ARlYTW/2Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8F84F602CC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: fix dma unmap direction for management frames
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548390066-12305-1-git-send-email-pillair@codeaurora.org>
References: <1548390066-12305-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207144439.CB3E6605FC@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 14:44:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> The management frames transmitted are dma mapped with
> direction TO_DEVICE, but incorrectly mapped with
> direction FROM_DEVICE during tx complete and error cases.
> 
> Fix the direction of dma during dma unmap of the
> transmitted management frames.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Fixes: 38a1390e02b7 ("ath10k: dma unmap mgmt tx buffer if wmi cmd send fails")
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

6e8a8991e210 ath10k: fix dma unmap direction for management frames

-- 
https://patchwork.kernel.org/patch/10780549/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

