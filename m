Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB180C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 13:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A68FF20849
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 13:53:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="0Vb/g8oY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A68FF20849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rsalveti.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbeLMNxQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:53:16 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40048 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729359AbeLMNxQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 08:53:16 -0500
Received: by mail-lj1-f195.google.com with SMTP id n18-v6so1838596lji.7
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2018 05:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y1XtOqb1SKthETcsvGHysa7wNh0u8lPL8kOm/exnX3U=;
        b=0Vb/g8oYUTinZlSmeoeKZ2iV7PpdVEzDxY9/Pa0y7B5vMzQdmku4LwpDGxfE8SjGpk
         PAVierH5q1+n+cNf6iP/fEWHyCff1TnuJ7c0Aa3oSkfgMwPDwksZRdkzE/cJyVWirXHy
         nUUsnReYwNRZK9vfch7nOMASz/GNyUNqwFTk3a8xVKJDoAz1kBrb0I0PnbhU51gsosk6
         paJlHgZu4VUCb/0Qk7wYn6BZNcX0W2vTZJ2PlJigK5SM7C89EKb/i7N1ODyNf5X8CgFJ
         rgO2ZwfM1pN15FHJmw92FF9HXfNkhbnDmy3dhG0aqijGZQjdkj0CS6qrVAegJXfqX+59
         hmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y1XtOqb1SKthETcsvGHysa7wNh0u8lPL8kOm/exnX3U=;
        b=bH8RehFkug5CqlZ5Qg+AzlNYUMW9yne6+fm8RaQaif5tdiaN3vkJHUhYYH7trkZAyw
         1Q07vmosO/FLrE0pIEW7jHWfChLQ5JCTdcrWdyhOz1ZdL7eMhaGNXcLRHcvnJt/50uju
         94tj5SC4RkWh2CdsLKBJLYOVkBStV4X3XwBNHUTD+HqvivKWDSRJa/muTZGDixDpYLYQ
         aCxhZ/tusqrBVhcZxhZ/6tSIJJCyohQvaM+d/2eLq7jpCtPp51+RrbPWq9TLbQmbBQly
         0U+ovBngJVIJ/Y76sn21wWq3OYTH3hBamYdbulePIacY+rVNoP9V65ewsW64CgakVoNH
         hlNw==
X-Gm-Message-State: AA+aEWbD+c+d4NJRHMjP7j790QtHB9nZa1wDHPHqknQbj//4/mk5GiAU
        YrNQQPRR+NMk5zl/W4d03PYAtuFQH5eaMnPk1OClFw==
X-Google-Smtp-Source: AFSGD/V4LDrAl3+5abN8UDtvzFUjnp5FeIwPiko9k8yjfXAvXpTHKOLTOUUF5AfE8brg9DPx7EQ1zlZWXPsfFA+GSqE=
X-Received: by 2002:a2e:85d3:: with SMTP id h19-v6mr14271755ljj.82.1544709193887;
 Thu, 13 Dec 2018 05:53:13 -0800 (PST)
MIME-Version: 1.0
References: <20181211181944.GW39861@atomide.com> <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com> <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com> <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
 <20181212014556.GC39861@atomide.com> <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
 <20181212183116.GH39861@atomide.com> <CAHYQr0ojkf3CvFb_zuEK4Vuz1w-rm9Sb=+dk5BkqYkWoxy8+aQ@mail.gmail.com>
 <9060b4655e064665a1812d9fae00f1ec@ti.com>
In-Reply-To: <9060b4655e064665a1812d9fae00f1ec@ti.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Thu, 13 Dec 2018 11:52:36 -0200
Message-ID: <CAHYQr0r4eQNSqZEr-vbCiVN6G_O1CXxX9cxemANSRY-jqDMZ=A@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: wlcore getting stuck on hikey after the runtime PM
 autosuspend support change
To:     eyalr@ti.com
Cc:     Tony Lindgren <tony@atomide.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, anders.roxell@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Dec 13, 2018 at 5:49 AM Reizer, Eyal <eyalr@ti.com> wrote:
> > > > I Just tried on an available am335x-evm using 4.20.0-rc1 which I believe
> > has all the patches merged already.
> > > > I am using the same script  and not seeing any failure yet.
> > > > See below:
> > > >
> > > > root@am335x-evm:/usr/share/wl18xx# uname -r
> > > > 4.20.0-rc1-11287-gf487c00
> > > > root@am335x-evm:/usr/share/wl18xx#
> > > > root@am335x-evm:/usr/share/wl18xx#
> > > > root@am335x-evm:/usr/share/wl18xx#
> > > > root@am335x-evm:/usr/share/wl18xx#
> > > > root@am335x-evm:/usr/share/wl18xx# while true; do ifconfig wlan0
> > down; ifconfig wlan0 up; done;
> > > > [1378786.491101] wlcore: down
> > > > [1378787.093006] wlcore: PHY firmware version: Rev 8.2.0.0.242
> > > > [1378787.168523] wlcore: firmware booted (Rev 8.9.0.1.79)
> > > > [1378787.215897] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not
> > ready
> > > ...
> > >
> > > Yeah I was seeing the same yesterday when I tried it.
> > >
> > > Could it be that there needs to be a little msleep() after
> > > loading the firmware on some platforms and before enabling
> > > PM runtime?
> >
> > The issue I'm having seems to happen when trying to load the firmware,
> > getting stuck in mmc_wait_for_req_done -> wait_for_completion, so the
> > firmware is never really fully loaded when the hang happens.
> >
> When the interface is brought up the wlan_renable gpio comes up (enabled) and turning the wl18xx device on.
> It might be that what happens here is that the chip is not yet enabled when the first sdio command is started causing a timeout.
> There is normally a delay associated with the fixed voltage regulator that is tied to this gpio and used for disable/enable (startup-delay-us).

Right, what is not yet clear to me is why we need a longer delay in
the enable path when using the autosuspend patch. I would guess that
the suspend/resume logic in the mmc driver is what causes the extra
delay (in the case of hikey).

> Similar to this:
> / {
>         model = "TI AM335x BeagleBone Black Wireless";
>         compatible = "ti,am335x-bone-black-wireless", "ti,am335x-bone-black", "ti,am335x-bone", "ti,am33xx";
>
>         wlan_en_reg: fixedregulator@2 {
> ...
> ...
>                 startup-delay-us= <70000>;
>
>                 /* WL_EN */
>                 gpio = <&gpio3 9 0>;
>                 enable-active-high;
>         };
> };
>
> Perhaps, as a debug step, try to add a delay in "wl12xx_sdio_power_on":
> https://github.com/torvalds/linux/blob/master/drivers/net/wireless/ti/wlcore/sdio.c
>
> and see if it makes a change?

I tried just increasing WL1271_PRE_POWER_ON_SLEEP from 20ms to 50ms
(which gets used before calling wl12xx_sdio_power_on), and that was
already enough to fix my issues on both hikey and beaglebone black
wireless.

Should we define another pre power on sleep specifically for the sdio
case (and use directly in wl12xx_sdio_power_on)?

Thanks,
-- 
Ricardo Salveti de Araujo
