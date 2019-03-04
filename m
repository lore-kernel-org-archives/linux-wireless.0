Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917CDC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 14:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54D6420815
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 14:47:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=jrdltd-co-uk.20150623.gappssmtp.com header.i=@jrdltd-co-uk.20150623.gappssmtp.com header.b="mxNahLWp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfCDOrb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 09:47:31 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41401 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbfCDOrb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 09:47:31 -0500
Received: by mail-ot1-f65.google.com with SMTP id t7so4391864otk.8
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2019 06:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrdltd-co-uk.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8VEj3a+Jn92HlNTa2/Yj/sHDn9NmGVViZx5M0l34fXc=;
        b=mxNahLWpSrX0nuGeScqD20ROoZAnNothesaqH3gcamLFeVpnv44xj+Uz3ZJt/8ONUW
         OzN7CsQ+VojG6Lk6poZGeFXRW2nQkOAZqCPHkBx025+5oeu7xJYU3ufE7PTAvFYponW9
         anmTmtEmWnRBeBRf80iqEsNSPoYtd8kmLD3M3caltYPkJeiftgiyDoddG3JxCotfrKdT
         AAJssyBQtnbLGmquR0p94Wfa7Wc/pWVsrsZBFv4GxALmCjs82KOHQnW60B+JvBdezyDX
         NkK1o62LpgVFBkJ8m1dVoJ7QL5kJvrdpp1I24MvOjEdj+Y0APqUJ53lPxX+7KJjn18O1
         P7mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8VEj3a+Jn92HlNTa2/Yj/sHDn9NmGVViZx5M0l34fXc=;
        b=omNDXEM0mmPsQPUPWFCfunLYJyz0hTw741I9/5YQa4kTD9hlr/lBpyI2kJIchgI6k5
         Aek6+z290m0DIAC6TJVLjZ8pZJ3lrhDrByoQ6Jt+jFRfPLa1esA9PZXIn3dgkb6mA91m
         Pq7NQvVzblWbtqcCfT2+OwVUVro5JTEC6iKwvGptmBuqoAirVitm6YoFIN9ICJ0bGY0t
         vV/Qe4rIIMwqJeEJlrf6zCkZmqvLbdU9ayLwEz60I2mwmCqypJBA7FPD/PhIrKKBqzsF
         IslyQcBhfsPT/vZvk2Rv/2CoUNgFe5Z/4cyGZXGTb+UMZ2FQPql/7L+lVLKz75Q/8LFs
         e1KQ==
X-Gm-Message-State: APjAAAXsfEiNmBG1azNgyUpt0dANNVYW02iM3UPIehYyWgl9XPh3Xf8f
        j6ODHKTUI/TYUtXa0891s7dLeLDlo46eHF+vCZ7j2A==
X-Google-Smtp-Source: APXvYqxzcD97ZTpbyoCY7Rlf+fcG7gyNOOR3O4ZpoVe10RghU/8GEYGFr7d6oF5S3Zo3yWTReugiwgssSCxG8wUxXZM=
X-Received: by 2002:a9d:6f97:: with SMTP id h23mr13237440otq.26.1551710849899;
 Mon, 04 Mar 2019 06:47:29 -0800 (PST)
MIME-Version: 1.0
References: <CAAUgxQLVXy4X-h+dLK0WrU5_cvbx0+mxvyFRFuNkYkybP4f_1g@mail.gmail.com>
 <CAAUgxQ+PU4Z5Nhj8K5r3ijKm87-GvTg9QffSjOenHWDRDauZSg@mail.gmail.com> <CACna6rx6GFWMDmcTN5CvOta3QDe8UT8gKFNCEf_gjuXBRoWyHg@mail.gmail.com>
In-Reply-To: <CACna6rx6GFWMDmcTN5CvOta3QDe8UT8gKFNCEf_gjuXBRoWyHg@mail.gmail.com>
From:   Krzysiek Rosinski <krzysiek@jrdltd.co.uk>
Date:   Mon, 4 Mar 2019 15:47:18 +0100
Message-ID: <CAAUgxQJX2UWzHaxm=6119qVxmCfdBAYzFkvjDJHkGQXK8wx03Q@mail.gmail.com>
Subject: Re: brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Sun, Mar 3, 2019 at 10:03 PM Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> =
wrote:
>
> On Sun, 3 Mar 2019 at 20:06, Krzysiek Rosinski <krzysiek@jrdltd.co.uk> wr=
ote:
> > On Sun, Mar 3, 2019 at 10:22 AM Krzysiek Rosinski <krzysiek@jrdltd.co.u=
k> wrote:
> > > I'm working on a custom board with cyw4343 connected to osd3358-sm (T=
I
> > > am3358), when I load the brcmfmac driver I get 'HT Avail timeout'
> > > error. The same combination of driver+firmware works fine on Raspberr=
y
> > > Pi Zero W.
> > >
> > > I've tried to gather as much information I can from both; the custom
> > > board and pi. This is available here:
> > >
> > > https://www.dropbox.com/s/vqejyrixbxx1z8d/logs.tar.gz?dl=3D0
> > >
> > > I have a custom board with cyw4343 chip fitted and also flyleded
> > > Murata 1DX to the PocketBeagle, both give the same error code.
> > >
> > > My setup is as follows:
> > >
> > > osd335x-sm (TI am3348), cyw4343, 37.4 MHz xtal.
> > > Linux beaglebone 4.14.93-bone17.1 #1 PREEMPT Mon Feb 25 16:27:58 UTC
> > > 2019 armv7l GNU/Linux
> > > brcmfmac: cypress v4.14.52-backports
> > > brcm43430-sdio.bin: Version: 7.45.98.38
> > >
> > > Is there something obvious which I'm doing wrong? Can you give me a
> > > hint on how to move with this further, please?
>
> You have to find new enough bcmdevs.h.
>
> Try Googling BFL3_FEMCTRL_SUB and you should find many BFL3_* defines eas=
ily.

Thanks, it seems that "0xc000000" isn't described there or I can't
find this. LPO is described here:

https://developer.electricimp.com/hardware/nvramimageguide

Cypress released recently a lot of documentation regarding these
chips. Hopefully, this part will be available soon too :-)

Kind regards,
Krzysztof
