Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80514C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44ECE2086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:48:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wr5mLA54"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44ECE2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbeJLST6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 14:19:58 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37639 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbeJLST6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 14:19:58 -0400
Received: by mail-oi1-f194.google.com with SMTP id e17-v6so9525905oib.4
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=rHVkaii2t00+azONKtFg2Qtc8wBCCts3ChSPLdTLo68=;
        b=Wr5mLA54BonIeF4L6a5qHjeZMnVVVN+hAqnFA0QRZPcwQZyBtyofKj6AAQ823iHtZp
         OORFQQ5iPZ89QG0x9OhwZMRLTw+7sqXltIBvvBM85ofAhIAkL/wM25AjbbwqYYbDbXk7
         yba9vtos7TLI1Gp4Y6tJ1iDMDwRHbmrsamc8NZULhqrx4Olf3JJwQ7z7uez5nppD8Nfs
         3YNF0ogtU1EADRQtSndEFERYQ2e4uoBBzt/DHtj3/A4EhdbW7vg6rziT7Eq9n8XDQdMt
         7Wdss2g9hlv11kPSd0dfD3WKHvkVaEbpN1G1M6Vd0xlSWJhoLPJhr0+t5yRUcm4EkaID
         58/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=rHVkaii2t00+azONKtFg2Qtc8wBCCts3ChSPLdTLo68=;
        b=DpIVD7+quzfszk0M+76ssYtLhNOxtRgnzP6UFZEWTX9/XuhJHa11Fuyf2mm0X76nNg
         39Y3Ml5Ac0cGqJ5jqX4bziRl4I0BYudsdHmpwUvi1cscueHPmdjv/2yxqKIuyygcwXCH
         c9dRT+tClSNWHLg7TMa+bCmfJ+MkUrjUo3QYl3y/5JdfTcphI6SbovwIGIwZTBYsoz8D
         vDOrHRpSvooVTK7SHnxjUPivGeUbXyElJyhBiUeigAi9ZgmdNwAhbwmJvC3mEwC4ZbLr
         K1WKBdyN5qKmAR8AEZbCS2lwEMCHM2B2OJ2Y11bu9+0xqbv5UmNRrWdrzU8ycfrJ/fH1
         KTLw==
X-Gm-Message-State: ABuFfojdQp9c8B4PD0V9sO7X84Sfmfkul7ySwvo1WLpv47BhbdBrATH7
        poiu34uwiRElX5EaYIBsZO7n+FLhQ5ljuoi23Ks=
X-Google-Smtp-Source: ACcGV609CoAbeWjMtFd69irbGHRJsouI4jdY/6XCRXMGkBktyuVKGx6p4y23Pl61b6YU03EG4LQPRDZ5+B4lVsniK3s=
X-Received: by 2002:aca:538b:: with SMTP id h133-v6mr3093723oib.355.1539341288215;
 Fri, 12 Oct 2018 03:48:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Fri, 12 Oct 2018 03:48:07
 -0700 (PDT)
In-Reply-To: <1539334591-9965-5-git-send-email-sgruszka@redhat.com>
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com> <1539334591-9965-5-git-send-email-sgruszka@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 12 Oct 2018 12:48:07 +0200
Message-ID: <CAKR_QVJ60VTDjyC59BEDsRKrKR495xjGwob0QqvX333L+L+=Zg@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

chip version support exist in daniel's tree since a long time ago. so
don't disable registers initialization but try to upstream his
changes.

changing TX_SW_CFG* entries did not make any noticeable difference in
my tests either, besides small RX improvement with configured
TX_SW_CFG2.

waiting for more of your test results

On 12/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> There is duplicated 'if (rt2x00_rt(rt2x00dev, RT6352))' entry that
> causes we do not perform register initialization for RT6352 (MT7620
> SOCs) in correct branch. Fix this and disable registers initialization
> that is specific to particular MT7620 revision.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index daf20d7424ac..16d6d99b1d44 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -5451,8 +5451,7 @@ static int rt2800_init_registers(struct rt2x00_dev
> *rt2x00dev)
>  					      0x00000000);
>  		}
>  	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
> -		   rt2x00_rt(rt2x00dev, RT5392) ||
> -		   rt2x00_rt(rt2x00dev, RT6352)) {
> +		   rt2x00_rt(rt2x00dev, RT5392)) {
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
> @@ -5466,6 +5465,10 @@ static int rt2800_init_registers(struct rt2x00_dev
> *rt2x00dev)
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000401);
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0000);
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x000C0408);
> +		/* TODO add chip version support and init registers
> +		 * according to the version.
> +		 */
> +#if 0
>  		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
>  		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
>  		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x06060606);
> @@ -5480,6 +5483,7 @@ static int rt2800_init_registers(struct rt2x00_dev
> *rt2x00dev)
>  		reg = rt2800_register_read(rt2x00dev, TX_ALC_CFG_1);
>  		rt2x00_set_field32(&reg, TX_ALC_CFG_1_ROS_BUSY_EN, 0);
>  		rt2800_register_write(rt2x00dev, TX_ALC_CFG_1, reg);
> +#endif
>  	} else {
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
> --
> 2.7.5
>
>
