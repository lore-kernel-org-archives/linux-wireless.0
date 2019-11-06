Return-Path: <SRS0=PzJh=Y6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1677DC5DF63
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Nov 2019 17:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC601217D7
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Nov 2019 17:56:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JQ+22H2m";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="f/yfTO60"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732420AbfKFR41 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Nov 2019 12:56:27 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35564 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfKFR40 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Nov 2019 12:56:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 02CE66021C; Wed,  6 Nov 2019 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573062985;
        bh=OWp/Ep5laIfxpLZ/jbqh2BVdcBHVyI+joJJufx17uo4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JQ+22H2mxrVwbIDMKO7OzuaFDkk9+rEk4alrpGA95zIuH/wOoCJeGnv2qybIVXGR2
         WFfTXVpy6oSYoQe0+WAS7xrXr+74pKizUs3fJvNwAvrcykfh4pUFX+CJ3F6KaktnZC
         8VgiYXuPajlgkCxBN9V0FqBWq871fGiMsfAaXZB0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4353E6021C;
        Wed,  6 Nov 2019 17:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573062984;
        bh=OWp/Ep5laIfxpLZ/jbqh2BVdcBHVyI+joJJufx17uo4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=f/yfTO604seJdDkSkdnBSCsKcjba3QPxzjuaPolkgJwTdLsWBiYp436fP3UoCaQGc
         sefSstGVnfebMn2+Y+ibJiVQvC0p9N117j2PXB1/LmgRUvOJ1zAQNcH7dcuNlYE9rq
         66CTO0SC+aCkRQ1FB3yisTeVUyaZHUpiLKYQ8v+8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4353E6021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: remove set but not used variables
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191101135035.11612-1-yuehaibing@huawei.com>
References: <20191101135035.11612-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <davem@davemloft.net>,
        <yuehaibing@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191106175625.02CE66021C@smtp.codeaurora.org>
Date:   Wed,  6 Nov 2019 17:56:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:841:7: warning: variable free_pdu set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:842:30: warning: variable tx_rts_count set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:842:6: warning: variable tx_rts set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:843:7: warning: variable totlen set but not used [-Wunused-but-set-variable]
> 
> They are never used, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

5565331152ee brcmsmac: remove set but not used variables

-- 
https://patchwork.kernel.org/patch/11223159/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

