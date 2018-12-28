Return-Path: <SRS0=+yu+=PF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F0EC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 09:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA2E72084A
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 09:49:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="hQRSsDjH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbeL1JtC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Dec 2018 04:49:02 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:44496 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727607AbeL1JtB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Dec 2018 04:49:01 -0500
Received: by mail-ua1-f66.google.com with SMTP id d19so6694550uaq.11
        for <linux-wireless@vger.kernel.org>; Fri, 28 Dec 2018 01:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=81wdRnxOgYBd++lnQvoz0ypEX3n59IMfF4GJ2l+N1EQ=;
        b=hQRSsDjHonYeNf6wTfMDKZLyLJzvVjbgQ9+WJqsAPVyiY8uPBoBDYdd9Yx4KVpKIpb
         GJtxCX2Ls/vSDjGy1DYrIVfwpZTbcCHJM9sEyo1vDU8Nh7iNTRYZnpmL6RI1fkHKgIhn
         ONRoo+g4Hi/LgTgH5CxiwLuOSLxQraP3r75og=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=81wdRnxOgYBd++lnQvoz0ypEX3n59IMfF4GJ2l+N1EQ=;
        b=tJJZ9wRJeuOCaalyGX1eRx8yTWcX6zHTjx5YehCtfWp7KGyK/ylXalp4w3j8K33fHz
         tC7A1IknIGg1G8l4imXBBZLTtuMy3PMA5ndZemeDsftXArQfJSNpVdA45bcXuYlhjO84
         RxTuanxNUqmlbBwQfXCzdmcmR5MiIkDt46Kdxy/LUivgf6tsS+1RbAc6RMdYDQv5Jt0F
         EnHOXXzAkf+v6UTIK3CklthYzTD+dgljXmJ2Ux0mquSIno/moJ+KGvcEETqPJMlZXyeo
         XzJ8IofGBImVv+dBzcOtlhDmbBCzvL6Z2jtfYvWaqK2vpqwKotjPAvlqNCC7uTxvWjbE
         o8Mg==
X-Gm-Message-State: AJcUukc9XmN2X/5BkvkdhuDeIsyPi4tGZLReKej99HqHXHdH6wgx+Jvs
        7H1eVyFPig30PVkZb9UUr6APh4GQOEzeBiq9EQMxxw==
X-Google-Smtp-Source: ALg8bN7RYFrRynftqktHbKr9Vwa7u/HY3c/e/8sxzsAQVW8I3b30hvWhWoOfLchNl9wpoT1/7S5OvkbLtVHS1AeU6AQ=
X-Received: by 2002:ab0:b83:: with SMTP id c3mr4094289uak.77.1545990540289;
 Fri, 28 Dec 2018 01:49:00 -0800 (PST)
MIME-Version: 1.0
References: <20181217164207.20081-1-tony@atomide.com> <CAPDyKFoLnNWsBfaUwqwL31J=zb0UOQjXUKi7Sj0AUsnNoC6bYg@mail.gmail.com>
 <20181218155439.GB6707@atomide.com> <CAPDyKFr2xx6fmdgjd10C1jekWg-yZPk32fGWEPO2PyexjofJ1A@mail.gmail.com>
 <20181220231401.GG6707@atomide.com> <c22e2ab61b494ea0852c0f4654fef92d@ti.com>
In-Reply-To: <c22e2ab61b494ea0852c0f4654fef92d@ti.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 28 Dec 2018 10:48:23 +0100
Message-ID: <CAPDyKFrk8Fx_XywPjhW3CTV9ri0LDovUuhE8=15Zew0_gMgebg@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: [PATCH] wlcore: Fix bringing up wlan0 again if
 powered down briefly
To:     "Reizer, Eyal" <eyalr@ti.com>
Cc:     Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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

On Sun, 23 Dec 2018 at 08:38, Reizer, Eyal <eyalr@ti.com> wrote:
>
> > > > > Instead, it looks like what you need, is a way to keep track of
> > > > > whether the SDIO card, became power cycled or if it stayed powered
> > on,
> > > > > when "ifconfig wlan0 up" is done. In case of a power cycle, you need
> > > > > to re-program the firmware, right?
> > > >
> > > > Yeah mostly. But we also need to ensure things do get powered down
> > > > properly after ifconfig wlan0 down :) IMO after ifconfig wlan0 down
> > > > returns, there should be no waiting needed.
> > > >
> > > > > Would it be possible to re-program the firmware, even if the SDIO card
> > > > > stayed powered-on?
> > > >
> > > > That might help for some cases, but the problem of how to ensure the
> > > > card is powered down after ifconfig wlan0 down returns still exists.
> > >
> > > Well, does the SDIO card really have to be powered down before
> > > "ifconfig wlan0 down" returns? If so, why?
> >
> > Good question. Eyal, any comments what should happen here from
> > the wlcore hardware point of view?
> >
>
> You are ok as long as the wlan_enable pin Does go down for a sufficient amount of time
> turning the wl18xx device off.
> The firmware can only be downloaded once after power on.
> In between down/up you have to make sure the wlan_enable is fully going through on->off->on
> and the wl18xx device is fully reset.
> On power on the firmware is loaded by the driver and this will fail in case the reset didn't happen

This clearly answers one of my question, in regards to re-programming
the FW, thanks!

However, I am still lacking an answer to if there is hard requirement
to actually power off the SDIO card at "down". So far, the indications
I have got, gives that answer "yes". Can you or anybody else confirm
that?

> .
> > > An option would be to call pm_runtime_get_sync() at "ifconfig wlan0
> > > up" (I assume you already do that) and then re-program the firmware,
> > > even if the card hasn't been power cycled. Wouldn't that work?
> >
> No, this wouldn't work in case the wlan_enable pin didn't reset the chip as part of the
> "ifconfig wlan0 down" Command.
>
> > Ricardo, care to test and see if the problem comes back if you
> > keep PM runtime enabled?
> >
> > > Or perhaps this is the problem you are encountering, that the FW can't
> > > be reprogrammed, unless the card has been power cycled? You can easily
> > > test that, by simply bumping the runtime usage count for the card
> > > device via sysfs, before doing the "ifconfig wlan0 up/down" thingy.
> >
>
> Correct. The firmware can't be reprogrammed , unless the card has been power cycled.

Again, thanks for clarifying this.

[...]

Kind regards
Uffe
