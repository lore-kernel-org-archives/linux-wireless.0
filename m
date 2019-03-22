Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 834BCC10F03
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 15:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5250F2183E
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 15:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xy1ZClP4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfCVPrN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 11:47:13 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:46510 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbfCVPrN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 11:47:13 -0400
Received: by mail-oi1-f196.google.com with SMTP id x188so2022678oia.13;
        Fri, 22 Mar 2019 08:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yw6foJsGwWELoKTF1wCnhUr8FwBtYg2gy4HXb/JJ/6g=;
        b=Xy1ZClP4cZ2LWIjWXgolJNUmDJlIL9pDmDwdkp8a1H1g4nrxE56mDUbHD2+TibYyOi
         xWXVzqRy7zMVsHIe/bdI7ojCwYoJv8yevuGwgal5g3YSJUaXn+IXQNl/X0O5MocAFeFJ
         MlCxf+0bd2MVjLhgJLVogm2U44IxUfNJZL6rOjydjBKDXHrbSQ5zV0PDlLL2K3IMaCeA
         wdfkTsbRQWMzGCDGNmtoAal8c35c9gjoR0ZPsqDJYv6IIrLhEIXxosCC6bWoqW4VSgKm
         cFxA21J495rLUwkpPx7YapSoc0Amnb+yBeZ/VfCBoHpMl8lhKJDXGD4iSE5iGgnvZsxk
         e6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yw6foJsGwWELoKTF1wCnhUr8FwBtYg2gy4HXb/JJ/6g=;
        b=ZRkfD/7FCYDm9IubmDlJoIEjSPaLf/APguMeV/j3llR3ZSEzmrQ8pLI5paNFbfT56m
         8IxTm+5QH8lFuYoPuELDXZxMqgBgKYjntb/1K5L5FvxoR/Jfsiyhcfiag6yfsL64Q+h8
         jiZi5f/Xx3dAWmbVBDsqdBO6+PPv98K3uzh4blpvS/R54iOvLQGd5xst4Omo1BjtpF4u
         fWq7fPHPmzoqusYGzD6vvBOBfkTBVcnXRr7B88IaT6Oeph3V1KvYDs9rXzgx1HhDvpaG
         9480XO6zRdCT6rOhlXQiRUTRJeXJPImQFa9yUhaD+crCAYUcADW37TNFGUCkllRBVg30
         SDJA==
X-Gm-Message-State: APjAAAXw1lcSffLo691CG1HWPjL0lUZrF0aYxEpjVskDJWWkUkZj/ZCC
        EwTwHZoaMz7UXezFC8CwJqfmzDQ/
X-Google-Smtp-Source: APXvYqyZSpPqajZbDwjkRpYELZz+3VkPHlaC5JG6XY+HYrSMXKdEBiJ6VQtsvpSh+Tp8vuKtKKkzfA==
X-Received: by 2002:aca:c782:: with SMTP id x124mr2357328oif.61.1553269631998;
        Fri, 22 Mar 2019 08:47:11 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id p187sm3144838oif.17.2019.03.22.08.47.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Mar 2019 08:47:11 -0700 (PDT)
Subject: Re: [PATCH] b43: shut up clang -Wuninitialized variable warning
To:     Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Priit Laes <plaes@plaes.org>
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190322143725.1332353-1-arnd@arndb.de>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <758d6087-bd8c-a60f-919a-40c170f7b23c@lwfinger.net>
Date:   Fri, 22 Mar 2019 10:47:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
In-Reply-To: <20190322143725.1332353-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/22/19 9:37 AM, Arnd Bergmann wrote:
> Clang warns about what is clearly a case of passing an uninitalized
> variable into a static function:
> 
> drivers/net/wireless/broadcom/b43/phy_lp.c:1852:23: error: variable 'gains' is uninitialized when used here
>        [-Werror,-Wuninitialized]
>                  lpphy_papd_cal(dev, gains, 0, 1, 30);
>                                      ^~~~~
> drivers/net/wireless/broadcom/b43/phy_lp.c:1838:2: note: variable 'gains' is declared here
>          struct lpphy_tx_gains gains, oldgains;
>          ^
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
> ---
>   drivers/net/wireless/broadcom/b43/phy_lp.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/phy_lp.c b/drivers/net/wireless/broadcom/b43/phy_lp.c
> index 46408a560814..aedee026c5e2 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_lp.c
> +++ b/drivers/net/wireless/broadcom/b43/phy_lp.c
> @@ -1835,7 +1835,7 @@ static void lpphy_papd_cal(struct b43_wldev *dev, struct lpphy_tx_gains gains,
>   static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
>   {
>   	struct b43_phy_lp *lpphy = dev->phy.lp;
> -	struct lpphy_tx_gains gains, oldgains;
> +	struct lpphy_tx_gains oldgains;
>   	int old_txpctl, old_afe_ovr, old_rf, old_bbmult;
>   
>   	lpphy_read_tx_pctl_mode_from_hardware(dev);
> @@ -1849,9 +1849,9 @@ static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
>   	lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
>   
>   	if (dev->dev->chip_id == 0x4325 && dev->dev->chip_rev == 0)
> -		lpphy_papd_cal(dev, gains, 0, 1, 30);
> +		lpphy_papd_cal(dev, oldgains, 0, 1, 30);
>   	else
> -		lpphy_papd_cal(dev, gains, 0, 1, 65);
> +		lpphy_papd_cal(dev, oldgains, 0, 1, 65);
>   
>   	if (old_afe_ovr)
>   		lpphy_set_tx_gains(dev, oldgains);
> 

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks. I will submit a patch that removes lpphy_papd_cal(). You are correct 
that it is unlikely ever to be implemented.

Larry

