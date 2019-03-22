Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A196C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 16:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A35021900
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 16:06:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P5uBFY21"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfCVQGT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 12:06:19 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36192 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbfCVQGT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 12:06:19 -0400
Received: by mail-ed1-f66.google.com with SMTP id e4so2130443edi.3;
        Fri, 22 Mar 2019 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Yqr048Vn5eeLffA+DI+RO2WyyaqgT7iEICWrTrJZlkM=;
        b=P5uBFY212XyWizZTdLRlR+7W4Wjqk4xpy5TdhySjmzpwuNVuzCYtLo0aItEs5/Dk5a
         /r2j7umJ1grqenbNJrdXKPC4ss4/zgsrTXJkGKmVh607i+Noatw0nRmUVcQCxx4aSOl3
         TNHbqDMDeci4jT68qabGBD5ekM+Wlt1qtDh70dHnddEesCinQ5GhOToWdD33RtYcjnC6
         lLhnRQW0Khe/kS8mZLz5ANtsrknDphYjN6wQNx2VnUA+ahcnwcGX7+79GeJxIo4p3j53
         ihT5A5zTlCIJaHOrnm5kmt7gMZoiuau3BHm2ULiOYl6UEQMDoCihmWN6IetYbjcf5JGr
         6zow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yqr048Vn5eeLffA+DI+RO2WyyaqgT7iEICWrTrJZlkM=;
        b=XhYs86KOsMfBiLmS+Z66buWerC/XfgWwc1kjEeeWTU6/IGf06SpeH5KQaU35AnjqlC
         1o0mj1R7Bgl8d6Ap5f8zwHgVrGjIIrfcZnustHBXzeWZHtHnIEiWigsw9KN7xf2lnJH8
         rIyniuFPAMA5T+HnkeT2o6pYb34JT+UgpcJGQd1ZP84nhoLXhEENGex50S/wfX4spVd1
         cGWFKFSApaFKpB+izdKOz7QtjNB0YV/REZulENlXwMEERXnblXNfcE6D2yHTZhGND2LJ
         JU7KST1UWViJttVckaHSwbl252fZ0imKagOwUw5ft0rvRoOnxTjH1WOGpn3xzdNo574d
         T04A==
X-Gm-Message-State: APjAAAU4BdvZiGVXtpsvI8TmDdibHK6qjsnPmBH4AOukGXe6RragC2Kf
        52qbvONNAnm/seeDU8eFisk=
X-Google-Smtp-Source: APXvYqwgXmLut7voRGM8MXDXlgSfIZz7Um6YPNl3UbKycrC0Gh2ZWO6Sej7lEjOiibIRhLnEiEwyrQ==
X-Received: by 2002:a50:92b2:: with SMTP id k47mr6608911eda.148.1553270776816;
        Fri, 22 Mar 2019 09:06:16 -0700 (PDT)
Received: from archlinux-ryzen ([2a01:4f9:2a:1fae::2])
        by smtp.gmail.com with ESMTPSA id d10sm2869910edk.14.2019.03.22.09.06.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 22 Mar 2019 09:06:16 -0700 (PDT)
Date:   Fri, 22 Mar 2019 09:06:14 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Priit Laes <plaes@plaes.org>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b43: shut up clang -Wuninitialized variable warning
Message-ID: <20190322160614.GF21978@archlinux-ryzen>
References: <20190322143725.1332353-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322143725.1332353-1-arnd@arndb.de>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 22, 2019 at 03:37:02PM +0100, Arnd Bergmann wrote:
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

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  drivers/net/wireless/broadcom/b43/phy_lp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/phy_lp.c b/drivers/net/wireless/broadcom/b43/phy_lp.c
> index 46408a560814..aedee026c5e2 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_lp.c
> +++ b/drivers/net/wireless/broadcom/b43/phy_lp.c
> @@ -1835,7 +1835,7 @@ static void lpphy_papd_cal(struct b43_wldev *dev, struct lpphy_tx_gains gains,
>  static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
>  {
>  	struct b43_phy_lp *lpphy = dev->phy.lp;
> -	struct lpphy_tx_gains gains, oldgains;
> +	struct lpphy_tx_gains oldgains;
>  	int old_txpctl, old_afe_ovr, old_rf, old_bbmult;
>  
>  	lpphy_read_tx_pctl_mode_from_hardware(dev);
> @@ -1849,9 +1849,9 @@ static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
>  	lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
>  
>  	if (dev->dev->chip_id == 0x4325 && dev->dev->chip_rev == 0)
> -		lpphy_papd_cal(dev, gains, 0, 1, 30);
> +		lpphy_papd_cal(dev, oldgains, 0, 1, 30);
>  	else
> -		lpphy_papd_cal(dev, gains, 0, 1, 65);
> +		lpphy_papd_cal(dev, oldgains, 0, 1, 65);
>  
>  	if (old_afe_ovr)
>  		lpphy_set_tx_gains(dev, oldgains);
> -- 
> 2.20.0
> 
