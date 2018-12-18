Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B2DC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 01:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2D56214C6
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 01:07:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="1+F/FVfW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbeLRBHc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 20:07:32 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35442 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbeLRBHc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 20:07:32 -0500
Received: by mail-lj1-f195.google.com with SMTP id x85-v6so12727039ljb.2
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2018 17:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P/rQBm/rAShZe1MxcSU8xZcE3I3+2vstlrB5Q1e5s/I=;
        b=1+F/FVfWDcX2aPQQ929d4yp37oLVJD2xBC/0bdSwsknc+h+VvsrBXh33QycQRcr2T/
         jkesfw1+pK5SIQUTs8t2/KxLKKLZ5H7inSps1O1tqAICxP2t1jSfgbIin9nzPzLLqGKU
         Sfw15HGtn2dmTfSUVrxJgw2QDxz9AyhT3jdWyS53WIG28FxDRcs502zpmvnpFk528QIa
         YGYicS3zYHoVPr6kLKwCt+Sl1w5yjPnG/A8wzfQ7JLC/z4i1ozq+0uHRA8fl5LnBQd2G
         XoeRCxlye+bCPGL9q1X5gWbRTwGCV9xtjPDY2Fuoq764JO9Dfk7ibMs+oVwKoymFbE0e
         0fyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P/rQBm/rAShZe1MxcSU8xZcE3I3+2vstlrB5Q1e5s/I=;
        b=e6WCedJQT7qB/5lPAWvjbTmUQ50C3AxkoAdbSp1YbDLd+5rs6Lywanxhp65wYcOAMB
         +GklGFvfwRhjbVhk5JuVuVBMBm0RsHO45c2k49Eh26xZrG04qMrg4c0qSu429O0cxhtY
         HZQX1woZUq7Gh3nPdqqJjjbW/0eQSoW9n3Dnw4G6hUyQLj73I850wMZWV8dWN6B8Ht+8
         HjB7Ou3dCPsvKyvQW6wb5NRTBuOcX/lROjYyPQEDk7uP5nf2U0qiSkQZWRRZppyf8ymq
         Fh/yvQGpgdaAYjgksNDBYpJYNevHoP/GNiNnkgXSigS1zEzEXcgPZ9suzGUN2Wyi4eUy
         pd8g==
X-Gm-Message-State: AA+aEWa/rtagu+K2uXCsgDIIigX9cfjBqqFERBdgqqndo1qvpItJChtF
        nRPDwRKDOOju8NfhHkhej4FGSr4z0+iFq5r+Q9QWlw==
X-Google-Smtp-Source: AFSGD/Vjk66BGSyBlauWlsIZaxsZ9Zb/ZfqBZtrtNYBIKqKW4LI16Zxz9T7i+IL56dQrKZHFnHgXMbX6m1mUdb09Lis=
X-Received: by 2002:a2e:9e03:: with SMTP id e3-v6mr3345271ljk.4.1545095249943;
 Mon, 17 Dec 2018 17:07:29 -0800 (PST)
MIME-Version: 1.0
References: <20181217164207.20081-1-tony@atomide.com>
In-Reply-To: <20181217164207.20081-1-tony@atomide.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Mon, 17 Dec 2018 23:06:53 -0200
Message-ID: <CAHYQr0oXExQeyo1z52hsNeQY78TMH3rt7egMJQ+uDHKS1_pBfw@mail.gmail.com>
Subject: Re: [PATCH] wlcore: Fix bringing up wlan0 again if powered down briefly
To:     Tony Lindgren <tony@atomide.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Mon, Dec 17, 2018 at 2:42 PM Tony Lindgren <tony@atomide.com> wrote:
>
> At least HiKey board can fail to bring up wireless interface again
> if the interface is brought down and up with no delay inbetween.
>
> This can be done tested with:
>
> # while true; do ifconfig wlan0 down; ifconfig wlan0 up; done
>
> According to Ricardo Salveti <rsalveti@rsalveti.net>, we need to
> wait between 30 - 40 ms on HiKey. This seems to happen when we
> get -EBUSY returned by pm_runtime_put() basedon the check in
> rpm_check_suspend_allowed(). But as it still unclear if part of
> the delay needed is because of capacitance, let's always do a
> at least 50 ms msleep even if no -EBUSY is returned.
>
> Cc: Anders Roxell <anders.roxell@linaro.org>
> Cc: Eyal Reizer <eyalr@ti.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Ricardo Salveti <rsalveti@rsalveti.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Reported-by: Ricardo Salveti <rsalveti@rsalveti.net>
> Fixes: 60f36637bbbd ("wlcore: sdio: allow pm to handle sdio power")
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>
> Uffe, do you have some better ideas on how to fix this issue?
>
> ---
>  drivers/net/wireless/ti/wlcore/sdio.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
> @@ -174,7 +174,7 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
>  {
>         struct sdio_func *func = dev_to_sdio_func(glue->dev);
>         struct mmc_card *card = func->card;
> -       int error;
> +       int error, retries = 5;
>
>         sdio_claim_host(func);
>         sdio_disable_func(func);
> @@ -188,6 +188,17 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
>                 return error;
>         }
>
> +       /* Wait a bit to ensure the card gets power off. Otherwise
> +        * bringing interface down and up again may not power off the
> +        * card inbetween. And then firmware load will fail on trying
> +        * to bring the card up again. We need to wait between 30 - 40
> +        * ms for this based on measurements on HiKey board.
> +        */
> +       do {
> +               msleep(50);
> +       } while (error == -EBUSY && !pm_runtime_suspended(&card->dev) &&
> +                retries--);
> +
>         return 0;
>  }
>
> --
> 2.19.2

Tested with 'while true; do ifconfig wlan0 down; ifconfig wlan0 up;
done' for 3 hours on HiKey, HiKey960 and BeagleBone Black Wireless, no
issues.

Tested-by: Ricardo Salveti <rsalveti@rsalveti.net>

Thanks,
-- 
Ricardo Salveti de Araujo
