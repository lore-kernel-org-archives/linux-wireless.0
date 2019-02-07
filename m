Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA24C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15AFA21872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="akvbrlok";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Zz4AgPtD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfBGOyu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:54:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58318 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBGOyu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:54:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9A3586087B; Thu,  7 Feb 2019 14:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551289;
        bh=Lz7Z40n7NqPwkFyza//GAsnAYwkTB4hWx3P42HitWok=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=akvbrlokXaFz4yvpKDUaSItgCOWHPn8NGF2yr4c1h2264T9sX8El45fD0YUFdkhhY
         TslpNi4VM4dVJD9PV/7AWaFKxlH25qXTKaXWAhbKdZ7rYvVJvr5VDKls2Nhm5xfgqg
         L78/jcY1fHt85dBqRZz1yytxpxNUTehBFMzET2u0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 789A060247;
        Thu,  7 Feb 2019 14:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549551289;
        bh=Lz7Z40n7NqPwkFyza//GAsnAYwkTB4hWx3P42HitWok=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Zz4AgPtDv8Q8YoUL9n/b7YHK0zy6stBgyEVywhcjbKJOzYGLUWVNYxtb+k+Sp8Imm
         Vp5+I5P5+ME6qYE43D3ya74wnUznGF4T/Eq3nXmN+aS5oVQkWawSWCZXNTJPcHzxAX
         575rC6zK4y5KiSXKVJwygqp4RHIXIlg47UdmvmcU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 789A060247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][RESEND] ath10k: snoc: remove set but not used variable
 'ar_snoc'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190130030900.18764-1-yuehaibing@huawei.com>
References: <20190130030900.18764-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <ath10k@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190207145449.9A3586087B@smtp.codeaurora.org>
Date:   Thu,  7 Feb 2019 14:54:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/ath/ath10k/snoc.c: In function 'ath10k_snoc_tx_pipe_cleanup':
> drivers/net/wireless/ath/ath10k/snoc.c:681:22: warning:
>  variable 'ar_snoc' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

f9a4b7f45ff5 ath10k: snoc: remove set but not used variable 'ar_snoc'

-- 
https://patchwork.kernel.org/patch/10787609/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

