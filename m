Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675E6C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35F7F20882
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:14:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YzFXdKbe";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bSH/uYWt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbfDDKOZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:14:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38396 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfDDKOZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:14:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7C6CF61C62; Thu,  4 Apr 2019 10:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372863;
        bh=QDEe9C84mKzr/8f+eseZNo6aGm6/nWFvW/JpXMBHZaY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YzFXdKbe9TnTD3PYbdKL/xIEVmIcr54Os6xt2lPbSrZ/XwNrfVpiwL5qZnSMAsPMX
         S/Bc5ixutpOwEp/hEu1KKtRbubbt+O4IIfHyvmhqwZrAStQC3bYEUJ1lzk9e8hQVMy
         gSbBuYmA9GjqlEoGN1R4jdyK9YAx0hJ1UVHdKpK8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E308761701;
        Thu,  4 Apr 2019 10:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372860;
        bh=QDEe9C84mKzr/8f+eseZNo6aGm6/nWFvW/JpXMBHZaY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=bSH/uYWtJ1hexBizuorT5QJXCE7nctHSbKA+7QIF5LBgatWTWlg6ZnejNmntpdgjF
         bcY1xoFFnoFBMi0OYHardCvkXMv7krn84wgCeVYJdfYMChBFysSexAaq24P0GBPl3n
         fPjKR42RcxkX0CqTZxsRQPoHtrNN/nEuocU8pp1U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E308761701
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43: shut up clang -Wuninitialized variable warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190322143725.1332353-1-arnd@arndb.de>
References: <20190322143725.1332353-1-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arnd Bergmann <arnd@arndb.de>, Priit Laes <plaes@plaes.org>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404101423.7C6CF61C62@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:14:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> Clang warns about what is clearly a case of passing an uninitalized
> variable into a static function:
> 
> drivers/net/wireless/broadcom/b43/phy_lp.c:1852:23: error: variable 'gains' is uninitialized when used here
>       [-Werror,-Wuninitialized]
>                 lpphy_papd_cal(dev, gains, 0, 1, 30);
>                                     ^~~~~
> drivers/net/wireless/broadcom/b43/phy_lp.c:1838:2: note: variable 'gains' is declared here
>         struct lpphy_tx_gains gains, oldgains;
>         ^
> 1 error generated.
> 
> However, this function is empty, and its arguments are never evaluated,
> so gcc in contrast does not warn here. Both compilers behave in a
> reasonable way as far as I can tell, so we should change the code
> to avoid the warning everywhere.
> 
> We could just eliminate the lpphy_papd_cal() function entirely,
> given that it has had the TODO comment in it for 10 years now
> and is rather unlikely to ever get done. I'm doing a simpler
> change here, and just pass the 'oldgains' variable in that has
> been initialized, based on the guess that this is what was
> originally meant.
> 
> Fixes: 2c0d6100da3e ("b43: LP-PHY: Begin implementing calibration & software RFKILL support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

d825db346270 b43: shut up clang -Wuninitialized variable warning

-- 
https://patchwork.kernel.org/patch/10865933/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

