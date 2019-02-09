Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73CBC282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 20:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C6B7218D2
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 20:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfBIUdV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 15:33:21 -0500
Received: from mail-it1-f172.google.com ([209.85.166.172]:37227 "EHLO
        mail-it1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbfBIUdU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 15:33:20 -0500
Received: by mail-it1-f172.google.com with SMTP id b5so17513179iti.2
        for <linux-wireless@vger.kernel.org>; Sat, 09 Feb 2019 12:33:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iDIp6Ar7aLxYJ71m7HmA8SJM3W9gHlIYLB7A/BLM6aQ=;
        b=a1D2f77MN8hZcjNwubuMfJaZqbJfSHD+7mILyhprn1GDP5zxZwyHkI8xTV8IaoaIYR
         bVLQ9ZwiVnSXryhvMIi2pybmBwUGdTqLvZL4YNfZG5Li15JcornZJPg0rtUh5VyuaYQ1
         //YkhWTAG3cA5w2WM4qZdBE4R1VXSKHfhT8CK7FjPwCQw6G663y+1ljH1HTNBadD5V0u
         CjXZP2R+Cvd5t/eHrwxHpTqFNKUTQTZ4md8vIxXhOt67HTMzTLcf7roE0heaKifNgRdl
         Q/lEBp4QqDakJY/0AfYfK1T3VPHoet5rPAfLmsxADOxBiefWuhwfzpC/95bVsTM5WqSV
         2OTg==
X-Gm-Message-State: AHQUAuZPlrl2msCCmIsNAj2hVlO3vGwO9IxBD4iLZKx0ZZ5gDnTHTjxO
        8hG2XWcyLoJkXHVrg0x8QQ6oZmieDg1mvYmrCjiHxw==
X-Google-Smtp-Source: AHgI3IYnA7p5wiH+/q42s0hJFcMQamCZ9z1JUh51PwHjK2yG4M9TMvElnh44GrwI86Ba9T7omhBwwkWsBC4jMcjaD5g=
X-Received: by 2002:a5d:9949:: with SMTP id v9mr13461005ios.228.1549744399121;
 Sat, 09 Feb 2019 12:33:19 -0800 (PST)
MIME-Version: 1.0
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com> <165515185.283024.1549744145982@email.ionos.de>
In-Reply-To: <165515185.283024.1549744145982@email.ionos.de>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sat, 9 Feb 2019 21:33:08 +0100
Message-ID: <CAJ0CqmXhPRh8L3QkKDEJZffPOKV0TgMg27sdP7UX9PRvEy-eQg@mail.gmail.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Hi Lorenzo,
>
> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> hat am 9. Februar 2019 um 19:46 geschrieben:
> >
> >
> > >
> > > Hi,
> > >
> > > as already reported here [1], that there are probing issues of mt76 using TP-Link Archer T2UH (wifi USB dongle) on Raspberry Pi 3 B+.
> > >
> > > I retested it with recent linux-next 20190208 (aarch64 defconfig + enabling mt76 driver) and got the following output after plugin the wifi dongle:
> > >
> > > [   29.778524] usb 1-1.3: new high-speed USB device number 6 using dwc2
> > > [   31.794581] usb 1-1.3: reset high-speed USB device number 6 using dwc2
> > > [   31.919916] mt76x0u 1-1.3:1.0: ASIC revision: 76100002 MAC revision: 76502000
> > > [   32.304412] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> > > [   32.325724] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> > > [   32.346866] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> > > [   33.410559] mt76x0u 1-1.3:1.0: firmware upload timed out
> > > [   33.435458] mt76x0u: probe of 1-1.3:1.0 failed with error -110
> > > [   33.454829] usbcore: registered new interface driver mt76x0u
> > >
> > > I took the firmware files from here [2].
> > >
> > > Btw there is another issue, if i disconnect the wifi dongle during probe i'm getting a endless flood of the following output:
> > >
> > > mt76x0u 1.1.3:1.0: rx urb failed: -71
> > >
> > > Any chance to narrow down these issues?
> >
> > Hi Stefan,
> >
> > could you please test the following series:
> > https://patchwork.kernel.org/cover/10764453/
>
> yeah this fixed the probing timeout and the driver will probe successful. AFAIK the dwc2 host mode doesn't support scatter-gather yet.
>

Hi Stefan,

is the dongle working properly now? Are you able to connect to your AP?

> > Applying this series I am able to connect to my home AP using an Asus
> > USB-AC51 (mt76x0u) connected to a Raspberry Pi 3 B+.
> > I am running rpi-5.0.y branch of https://github.com/raspberrypi/linux.git
>
> The foundation kernel uses a different USB driver called dwc-otg which make use of FIQ.
>
> Okay, now we only need to find a solution for the "rx urb failed" flood ;-)

Does it happen just if you remove the dongle during probe?

Regards,
Lorenzo

>
> Thank you very much
> Stefan
>
> >
> > Regards,
> > Lorenzo
> >
> > >
> > > [1] - https://marc.info/?l=linux-wireless&m=154875316703367
> > > [2] - https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/mediatek
