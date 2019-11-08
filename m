Return-Path: <SRS0=s5sB=ZA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB96BC5DF60
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 08:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D6992178F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 08:39:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lokxY86c";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mg9ayVtM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKHIja (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:39:30 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36692 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfKHIj3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Nov 2019 03:39:29 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CE4C860D46; Fri,  8 Nov 2019 08:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573202368;
        bh=NuFpCXUQ7186OnycQRWUnmVhq2YX8K0bNYDVwjZtxrA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lokxY86cjVEdqWdTcQpFTU8PaS/huVz6vuLarl2wL4EAbjFSZtNDbCsHPpJbLsezz
         EmUXKP5iR5aDQhCUl6/RqHvqKY6BMWEQzaa/5+wdYCL/RJsGKnojlCqlkI5Dvg6ZC8
         1E6DHDPKI/xCpeuM/urB7ZDtmzdxHRJslzvMcSEY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1749560B19;
        Fri,  8 Nov 2019 08:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573202368;
        bh=NuFpCXUQ7186OnycQRWUnmVhq2YX8K0bNYDVwjZtxrA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Mg9ayVtM7qtSIHdpn2plrtdkentiR9QkWV/GZl5P/w5/X9f1M87xB9Yytc/vul8Im
         dUCh+qYtTxlS7iBuLb42paDUdixW4UScoyBEH30NO30E2D3HT2FryTwmtQPrOK94iL
         yS0UrnlczMVNT1p8a6et4pDYY+BmK/xe8oYWYJ7E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1749560B19
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] dt: bindings: add dt entry flag to skip SCM call for
 msa region
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191023094014.28683-2-govinds@codeaurora.org>
References: <20191023094014.28683-2-govinds@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191108083928.CE4C860D46@smtp.codeaurora.org>
Date:   Fri,  8 Nov 2019 08:39:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> wrote:

> Add boolean context flag to disable SCM call for statically
> mapped msa region.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

I was wondering why there are no review comments from DT folks and then
noticed that you didn't CC the devicetree list. Please resend (as v2)
and CC devicetree list.

2 patches set to Changes Requested.

11206177 [1/2] dt: bindings: add dt entry flag to skip SCM call for msa region
11206179 [2/2] ath10k: Don't call SCM interface for statically mapped msa region

-- 
https://patchwork.kernel.org/patch/11206177/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

