Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC15C10F00
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 379F820859
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:08:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nlk+acRl";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="T1QjMO2k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfBSPIE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:08:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34432 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfBSPIC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:08:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 012256071A; Tue, 19 Feb 2019 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588882;
        bh=rkZtxgK4BjsYK1JLhEEDUxNLOUpUFBA+hGyHZSHgAko=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nlk+acRl3ac4hLSbEDVXIPgy/izp0Eh5OJxsA7zOzY+2389gmu6iDSL4N/emLLjor
         2bFSHzVOeBnItKEtqFNYHIypytmYl8CPxaLywCgqdefiSWL9jQsOjpNkR4MecgHOtl
         t9zIg7ezg9dNr0ItHtodeuy04TAR36vYz9GkLPLE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E846D6071A;
        Tue, 19 Feb 2019 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550588881;
        bh=rkZtxgK4BjsYK1JLhEEDUxNLOUpUFBA+hGyHZSHgAko=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=T1QjMO2kuCOK3+g2HzC5rMf/pzY4MgSmVxOlBy582XparVeUrExte3cVcNG2CUhdh
         +MHPP0aazelUNH0iCdAOi76PeAKXQW8DEb88VjJiq1EcLJnKQH1zTd2+ITiL2SPrIR
         NVj+74JaU4rAw23z82t4M4X4VRjGzMfB1cJHwfMA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E846D6071A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: remove set but not used variable 'old_state'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190218080846.187942-1-yuehaibing@huawei.com>
References: <20190218080846.187942-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219150802.012256071A@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:08:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c: In function 'brcmf_usb_state_change':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:578:6: warning:
>  variable 'old_state' set but not used [-Wunused-but-set-variable]
> 
> It's never used and can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

e4d1b2716b88 brcmfmac: remove set but not used variable 'old_state'

-- 
https://patchwork.kernel.org/patch/10817429/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

