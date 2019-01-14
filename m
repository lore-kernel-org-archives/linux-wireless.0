Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A424C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 13:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BD4B20657
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 13:48:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="a4sk12Ik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfANNsI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:48:08 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:45774 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfANNsI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 08:48:08 -0500
Received: by mail-vs1-f65.google.com with SMTP id x28so13599040vsh.12
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 05:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xtseGzY6dyhua4iaXU3qFXtDrR9A5o0qNTZ67B5cSYs=;
        b=a4sk12Ik+h2HSXsaotTlz3c8Xau+NsH8/E10pim5ePpOux+c/ecCpnN02oYJoBdLa4
         qDeeucbXRSzTtjZPYREux7NSXNyTBHNmoExPNW2R07xx7lt//cMA/rsh0jML8rmD0mOh
         /wlydWcj6dpABZ8QhIEgABgp8/q4S5uPZQlRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xtseGzY6dyhua4iaXU3qFXtDrR9A5o0qNTZ67B5cSYs=;
        b=LPzZOq3uE0Le4sqj1HwBFczISaDn3azXyLEK7loJ4d6iRplLlvOnk38q6TekjQkvP/
         w/giEkGLODkqaP1ACJcNfuJ2jhoHNb+hl62a/1ZgFV+cCKZmNHxvJr2QQr250a5o9iF9
         gxqu6no18yoUzMyV/FETtwO5JPWw4WMWghL5jeBvlO8rXunvl1xdqX16e/rGmZ2zwB3Y
         GFIvwWDuN3UMYhv9sbIYaN+ajknGXCiN5moJkFYsFiuvp/XLbrD/kqgJAvZ8SWNpXhG+
         t0ON0zIyteAzdjfv6yNdNvi5gKC7X/c5AFJp+jo2xq4S0RALKilc+oIN+3inG21qM82v
         b5gw==
X-Gm-Message-State: AJcUukdVcqSkxscUG1CYeIjIQEhceGJ2UXhCfiio21uwwHB3M15CzdAI
        Irjcz6ZGIKbcX/V+4bH17D2ZLzskn9P02asws05+YW7Y
X-Google-Smtp-Source: ALg8bN5OlYQR+P/Zpg4fNuf3xfyBOJ2HDUJxtUMZq/T1XV1UDTHwaGOSnElfKSHsefP8jLH6aUS5Y9dGwEAATEL0G4I=
X-Received: by 2002:a67:1a84:: with SMTP id a126mr10267262vsa.165.1547473686851;
 Mon, 14 Jan 2019 05:48:06 -0800 (PST)
MIME-Version: 1.0
References: <20181217164207.20081-1-tony@atomide.com> <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
 <20181218155439.GB6707@atomide.com> <CAPDyKFr2xx6fmdgjd10C1jekWg-yZPk32fGWEPO2PyexjofJ1A@mail.gmail.com>
 <20181220231401.GG6707@atomide.com> <c22e2ab61b494ea0852c0f4654fef92d@ti.com>
 <20181223160226.GK6707@atomide.com> <CAPDyKFoEOGACs4Wnm7UgKab2b1-7+v8+31DpC+p=8XxcQhSpcQ@mail.gmail.com>
 <20181228195903.GX6707@atomide.com> <CAPDyKFq9XmRueJEFKVb03hqLuoB84TGjrdvEjre46ezYbk_wgw@mail.gmail.com>
 <20190107151849.GC5544@atomide.com> <87k1jgsaze.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87k1jgsaze.fsf@kamboji.qca.qualcomm.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 14 Jan 2019 14:47:31 +0100
Message-ID: <CAPDyKFrYk87AwpHd5B06quGQAtfPYRHMD-9-2WzR=7Y=5Oog2A@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: [PATCH] wlcore: Fix bringing up wlan0 again if
 powered down briefly
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Tony Lindgren <tony@atomide.com>, "Reizer, Eyal" <eyalr@ti.com>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Ricardo Salveti <rsalveti@rsalveti.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 7 Jan 2019 at 17:12, Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Tony Lindgren <tony@atomide.com> writes:
>
> > * Ulf Hansson <ulf.hansson@linaro.org> [190102 12:02]:
> >>
> >> However, if this is about an out-of-band IRQ line, instead of using
> >> the SDIO IRQs on DAT1, I think management of that, belongs in the wlan
> >> (or gpiochip) layers.
> >
> > Yes this can be handled at the gpiochip layer.
> >
> >> We have to distinguish if "down" has a strict requirement to power off
> >> the wlan-chip.
> >>
> >> For example, in "flight mode", is it okay to leave the wlan chip
> >> powered on and thus potentially also having its radio part active?
> >
> > I don't know. If unsure, we should at least have that possibility
> > available for future versions if needed. It might also help a bit
> > with PM measurements :)
>
> I don't know if there are any written rules but I have preferred that in
> wireless drivers "ifconfig down" means that all power is turned off on
> the device, at least this way user space can achive maximum power
> savings. And there's also a simple way to start the firmware from clean
> state, we all know how buggy firmwares are so I think that's important
> as well.

Alright, I buy this! I am going to have a look to see how we can
accomplish this in the best way, but I need some more time before I
can post something.

In the meantime, let's go with Tony's suggestion to fix the
regression. I am about to post a patch.

Kind regards
Uffe
