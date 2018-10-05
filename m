Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2399C65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6072220875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ivVga2PY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hw3+/Edb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6072220875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbeJEPgO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:36:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49988 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbeJEPgO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:36:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7D0B36076A; Fri,  5 Oct 2018 08:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728712;
        bh=cKlCaiYTt62xu1f9TPjzBaXoXOM/1mSjyvOs/Y9Af8k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ivVga2PYidNegVPE9KYarH/25arLI+rZdmQ9NE1hOHcfhNi2xIlLaQulnKT9VuC2c
         piRP9tCjPxHiu/TzmU335TnPkXOxHsT5tld9l1z3TFRLH6ID+8ZZNL1t8VKqXtLigw
         wGgy7kYuckURT8MugzPImPcnRZ+JwOYVyd1O8Ifw=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DE4586024C;
        Fri,  5 Oct 2018 08:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728712;
        bh=cKlCaiYTt62xu1f9TPjzBaXoXOM/1mSjyvOs/Y9Af8k=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=hw3+/Edbm73c9sxtxgZ+QuTy2ws3ZEBpN7pyOiG+1Z+WKoP3TCYb5HaZoZ0sy/G0W
         leNpoDAHWw0PugrcVCnJPM4c1UXbg+aDbAWukdzQ0P006aWVKKVvMxtj1qsXIpYlGS
         WJBg9UdRMhvKHFe0UBAJL2dx3ftm07J1Mp8pNgBU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DE4586024C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43: remove set but not used variable 'wl'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1538712945-141866-1-git-send-email-yuehaibing@huawei.com>
References: <1538712945-141866-1-git-send-email-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Colin Ian King <colin.king@canonical.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181005083832.7D0B36076A@smtp.codeaurora.org>
Date:   Fri,  5 Oct 2018 08:38:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/broadcom/b43/main.c: In function 'b43_one_core_detach':
> drivers/net/wireless/broadcom/b43/main.c:5496:17: warning:
>  variable 'wl' set but not used [-Wunused-but-set-variable]
>  
> After commit 644aa4d62096 ("b43: remove list of IEEE 802.11 devices")
> 'wl' is not used any more.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

a7dd5d7c2dd8 b43: remove set but not used variable 'wl'

-- 
https://patchwork.kernel.org/patch/10627361/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

