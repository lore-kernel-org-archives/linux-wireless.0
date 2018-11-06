Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECECC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 008B92081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:58:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z+vtVTRN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aNUJmymZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 008B92081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389516AbeKGCYe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:24:34 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57160 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389338AbeKGCYe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:24:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 768EA6049C; Tue,  6 Nov 2018 16:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523507;
        bh=5uksm1THWbgJ28N6s0rybTbmLM7c7fJVUdhoq2l6ZtA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Z+vtVTRN8jjxevP7JjSX5vbgMabZ1Dyj2PTpvWaq12/siiDYgieBJ90d794yBQsUb
         o2iX+gtDPsfNzmecR7wpuJLi4i8r3BbPOvk1mHJq6R0swjMjGtxfPQEnQAIeEkahRd
         BMK2HXgb6LTMHecSBOjw6RsUJlfuHgRbyF/7qVck=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9EC80602F4;
        Tue,  6 Nov 2018 16:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523505;
        bh=5uksm1THWbgJ28N6s0rybTbmLM7c7fJVUdhoq2l6ZtA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=aNUJmymZ3TmtlXtzdwoeGwU3A4Xy3/RwQhu/J3Cwpoz4UJMdsy6nZ9dAio+phvTbE
         2JlDcuzzsRmyrp1QYpjRHDmTzZLnjzk7+RA/0GyS8Kgr4ZNcaDA0Pg9v7FXpSLcASa
         VcjbAgRyGpbyuQ8ssHyKqa29aCkN4kwKHrqCbwi8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9EC80602F4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: btcoex: remove set but not used variable 'ppsc'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1540194675-65562-1-git-send-email-yuehaibing@huawei.com>
References: <1540194675-65562-1-git-send-email-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Colin Ian King <colin.king@canonical.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106165827.768EA6049C@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:58:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c: In function 'halbtc_leave_lps':
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:295:21: warning:
>  variable 'ppsc' set but not used [-Wunused-but-set-variable]
> 
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c: In function 'halbtc_enter_lps':
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:318:21: warning:
>  variable 'ppsc' set but not used [-Wunused-but-set-variable]
> 
> It never used since introduction in
> commit aa45a673b291 ("rtlwifi: btcoexist: Add new mini driver")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

9198f460ec9d rtlwifi: btcoex: remove set but not used variable 'ppsc'

-- 
https://patchwork.kernel.org/patch/10651825/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

