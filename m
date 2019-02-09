Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2246BC282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 22:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E580C218D2
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 22:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfBIWrt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 17:47:49 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:53847 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbfBIWrs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 17:47:48 -0500
Received: from oxbaltgw58.schlund.de ([172.19.246.145]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1N0Fh1-1h3w462My7-00xKlK; Sat, 09 Feb 2019 23:47:37 +0100
Date:   Sat, 9 Feb 2019 23:47:36 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Message-ID: <1967648755.294991.1549752456082@email.ionos.de>
In-Reply-To: <CAJ0CqmXhPRh8L3QkKDEJZffPOKV0TgMg27sdP7UX9PRvEy-eQg@mail.gmail.com>
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <165515185.283024.1549744145982@email.ionos.de>
 <CAJ0CqmXhPRh8L3QkKDEJZffPOKV0TgMg27sdP7UX9PRvEy-eQg@mail.gmail.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev47
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:+kHTRArE/+FcEDtF8tDd7s7rrs2uf4irO0/SFrBId4dzIOi1Oif
 OxR7nZ/a610GyHDDjLLt48JKCavCczJ6B/SRTIuQJkOzgEOL2Fj5pPKmtZO7AjJo2KTyoLu
 KKXaeiQc7F17MwUn1W1uYhll4zO2dUnT6TktVc5gkXoBCBBYb3ieJx/BkJaaRtanL+W2/zk
 Ys+oxjaqcfeRFGK1wiCTw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:TtWm5eyboOU=:hS/ypMXX0hA3G18ItF2fCa
 zoBHGCfIPMRA4AOlsm7nzc7A4x4MDO1wEDHeQysaJQpw3FcJWhI1XQMKLdFD5vjhfZoH/5cOu
 DabZ8INkL2AAJaDX4bWSBzhhB/Da2MZBgTd8VPddqT0BIhDem7KOiGJhB6H0a29TLJDEdBmPk
 HGEF3j2imkWbC+1uxIKThOjie/QwRTb/apTxghUMocY2dwZaChlj46Y6WW+Y+N4MhzYpLfRuY
 YR3c2ByOn/Q+QxANzBjtRQ7YgYfbec7rO072E14DEolaNt4gukz8qui4OgmR0UuOVhkOUfnBh
 YUwkw2HJ/n37326V5t2K2Zlacq9SBIJIagiaJE/7vOs/gmhzdKF5yVLrD4VAag0fPmN8sANmM
 MLy7jXzL3OPvEnaJhN/RJJ50VBgE+zYeTQvMoKvPoGC7cu865jdWtZNzRlLYUSx1HhJRvUPy1
 /4N894Zz5hGWv8r/Hc8IOHAZIMCvWfcOYp1455rpfOy1ZCry0Dof+1EzU46tHghhFebkFdnEt
 k0USfcFCm9mQWIKrAK1PXjpCJk5hcHwRXOvSM6tVMuw1LZaamK6oAyqFBApiwK8W4wjrA08CU
 gLJ0YqK7SYrUrtpJ30qj9MU1XPunB/Jr9l3xcyH5kqrKFlC8V8S6JoT4o7AwuH3AX3CtxBDVX
 JRpTcg2TF8K99LP8xYCuxOjTPz1nHD2P8Sj+S7HzWz2gf0jzvioZO9uTM0iV+qOCL3LiySV/c
 4HBHA/j3XSth8lZFrMr6CcK64q8LvDMEhl63j7bLrWl2YdJtCiWb3APBEg0=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Lorenzo,

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> hat am 9. Februar 2019 um 21:33 geschrieben:
> 
> 
> >
> > Hi Lorenzo,
> >
> > > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> hat am 9. Februar 2019 um 19:46 geschrieben:
> > >
> > >
> > > >
> > > > Hi,
> > > >
> > > > as already reported here [1], that there are probing issues of mt76 using TP-Link Archer T2UH (wifi USB dongle) on Raspberry Pi 3 B+.
> > > >
> > > > I retested it with recent linux-next 20190208 (aarch64 defconfig + enabling mt76 driver) and got the following output after plugin the wifi dongle:
> > > >
> > > > [   29.778524] usb 1-1.3: new high-speed USB device number 6 using dwc2
> > > > [   31.794581] usb 1-1.3: reset high-speed USB device number 6 using dwc2
> > > > [   31.919916] mt76x0u 1-1.3:1.0: ASIC revision: 76100002 MAC revision: 76502000
> > > > [   32.304412] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> > > > [   32.325724] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> > > > [   32.346866] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> > > > [   33.410559] mt76x0u 1-1.3:1.0: firmware upload timed out
> > > > [   33.435458] mt76x0u: probe of 1-1.3:1.0 failed with error -110
> > > > [   33.454829] usbcore: registered new interface driver mt76x0u
> > > >
> > > > I took the firmware files from here [2].
> > > >
> > > > Btw there is another issue, if i disconnect the wifi dongle during probe i'm getting a endless flood of the following output:
> > > >
> > > > mt76x0u 1.1.3:1.0: rx urb failed: -71
> > > >
> > > > Any chance to narrow down these issues?
> > >
> > > Hi Stefan,
> > >
> > > could you please test the following series:
> > > https://patchwork.kernel.org/cover/10764453/
> >
> > yeah this fixed the probing timeout and the driver will probe successful. AFAIK the dwc2 host mode doesn't support scatter-gather yet.
> >
> 
> Hi Stefan,
> 
> is the dongle working properly now? Are you able to connect to your AP?

i successful tested STA mode with 2.4 GHz and 5 GHz.

> 
> > > Applying this series I am able to connect to my home AP using an Asus
> > > USB-AC51 (mt76x0u) connected to a Raspberry Pi 3 B+.
> > > I am running rpi-5.0.y branch of https://github.com/raspberrypi/linux.git
> >
> > The foundation kernel uses a different USB driver called dwc-otg which make use of FIQ.
> >
> > Okay, now we only need to find a solution for the "rx urb failed" flood ;-)
> 
> Does it happen just if you remove the dongle during probe?

I also see those messages while disconnecting after a successful probe but in this case the messages stopps after a few seconds. In case of a disconnect while probing the flood never ends. It looks like the rx tasklet is triggered forever.

Stefan

> 
> Regards,
> Lorenzo
>
