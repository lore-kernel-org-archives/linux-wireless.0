Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6299DC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 12:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31B842087C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 12:59:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="D+1XrRPO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IC5MENSZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfBZM7q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:59:46 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34898 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfBZM7p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 07:59:45 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E995161340; Tue, 26 Feb 2019 12:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551185985;
        bh=4GpR06qlW7htMJUDQbiXKejOvHN4TFt8U/QyvyLB554=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=D+1XrRPOL948LeL6x5LxlBbTVdQuKpp4PBbMYplAbhPZQon6iMS99WPQJsKUBlErQ
         AYThXL1tQUhB2N+9hnWckXwJnrvmgRQ2PuCpQQF9NtiSOCbhDUu/LQsqKsDaKknbhh
         hY4mPRWI7VxHcNUgQF0y/RzhcSdbemRf7NMDn1B4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3271860909;
        Tue, 26 Feb 2019 12:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551185983;
        bh=4GpR06qlW7htMJUDQbiXKejOvHN4TFt8U/QyvyLB554=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=IC5MENSZjfm7cfcQfjz+jUb5ugaS7RYHpo4/DtO+CsvhgX9BdPwrQjcu43EOz5qUx
         RnxOizWcHxAltVchz0n1nkxeM7Q38JaJfIfoGui3PAMSpgiZBYqMfxsvTii36BW2EA
         0OhHT9JzAt3D9X6O/8gPBkSQlU7jkQNhxrpUJIjo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3271860909
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Enhance logging for vdev pdev & peer set param
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550216886-23045-1-git-send-email-pillair@codeaurora.org>
References: <1550216886-23045-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190226125944.E995161340@smtp.codeaurora.org>
Date:   Tue, 26 Feb 2019 12:59:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> Currently after enabling the WMI debug logging,
> there is no detail printed about the param id
> and the param value for the pdev, vdev and
> peer params which are set.
> 
> Enhance the WMI logging to print the param id
> and the param value for pdev, vdev and peer set
> param wmi commands.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01387-QCAHLSWMTPLZ-1
> 		WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

1c136e41fb77 ath10k: enhance logging for vdev pdev & peer set param

-- 
https://patchwork.kernel.org/patch/10814285/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

