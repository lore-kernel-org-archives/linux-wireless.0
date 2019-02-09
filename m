Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E1BC282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 20:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 631D7218D2
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 20:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfBIU3T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 15:29:19 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:47383 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfBIU3T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 15:29:19 -0500
Received: from oxbaltgw60.schlund.de ([172.19.246.147]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1Macf4-1hP9B31Ikc-00cAPm; Sat, 09 Feb 2019 21:29:07 +0100
Date:   Sat, 9 Feb 2019 21:29:05 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Message-ID: <165515185.283024.1549744145982@email.ionos.de>
In-Reply-To: <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev47
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:Zwk+TUsC/N6N/kDmVA5Ue2jjEIGrpAMOnskcokaGT0AhTVDoTCj
 zIXUcwiw5n6/jldYMyYKvsv4CsS4+UHgClzKJHsR0qlZIOQHClGCPxa/BeO3nv+XJQiX5bh
 04Mkh/euk88VEeE6Wu8vOwfGEukNBbbAdmFo7SE/6pol4LCdT5Go9hV8kIoYYkQVqxn0CR7
 ueHl0/UWefE2MUuVEVdvQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:5UZX1p6cp/k=:KVx7JYF3m1pyinptbQ9s12
 2SXL1j8FDFHIFVntZM4rTjcTOsBTmBQzANh+fx1/YZkxga0fE3TBxWEkVofMZHTAWd51Q/YjC
 WYEgOTLYWwegM+dFuQB5a+uaZeCbqQcfwtx1hCkylnSOOGKKZO1zIZgFKaO7rSibA/bwYhvR9
 Ou/0xfk/ht53rzX+MWN4tlwK0qmIXnGob/rHW8BderY0bGX9G8QSnCJP+t3ThWXnXcZZ4Qkmw
 TMo5kt6/uhmZjOYeIueXzHdws5TJIym4UdkrAMel5kL3sdqAf9ust5qGo2s5bqck8lz3mfxxc
 iQt/IORW0HiZkS/K+vr9W7+eGOKSfNZmXIRBvyBshn4tMc/h8s6RmEDdFky7mS9sxOznOOaA7
 1qWwJxXQL1SzcdHIEEBCUwaEKnmAmm4BjADM7Tbxd5JvXWAa9sD1phArsb4x0prtV+imKslwd
 ApwiDRoKb1A4C1xwvpxEz/BsdKoZwmd4iFVB7Zi6nB94Qyp73IhXY67tb6PtlFNfoBrUypeXB
 bC9AduCFXZnDLm6EIyPnenAtMNH8O4Vlekdo+Imx7sd82Q8OizN+cAo5hmbAPskRNFbsJisN/
 tz4/57YRQCe178HiJkjTFt+FiJtFl5bcXZXEumzx1r9BjV+1oun10Q89muVvsFuqzoyDLn1/D
 IOQKkP6JK+MH9r56yY6eTCrlpkIDYIWvbGxxQlEPHgyHP5UhMZiakiiA4R0FmoNrf0XYNQpOb
 VLfAGYMpvZamAZf/23ZTUcFsF9/YOPo1Xez8pK8MJM4w8z9RxRh3VpkcwDQ=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Lorenzo,

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> hat am 9. Februar 2019 um 19:46 geschrieben:
> 
> 
> >
> > Hi,
> >
> > as already reported here [1], that there are probing issues of mt76 using TP-Link Archer T2UH (wifi USB dongle) on Raspberry Pi 3 B+.
> >
> > I retested it with recent linux-next 20190208 (aarch64 defconfig + enabling mt76 driver) and got the following output after plugin the wifi dongle:
> >
> > [   29.778524] usb 1-1.3: new high-speed USB device number 6 using dwc2
> > [   31.794581] usb 1-1.3: reset high-speed USB device number 6 using dwc2
> > [   31.919916] mt76x0u 1-1.3:1.0: ASIC revision: 76100002 MAC revision: 76502000
> > [   32.304412] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> > [   32.325724] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> > [   32.346866] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> > [   33.410559] mt76x0u 1-1.3:1.0: firmware upload timed out
> > [   33.435458] mt76x0u: probe of 1-1.3:1.0 failed with error -110
> > [   33.454829] usbcore: registered new interface driver mt76x0u
> >
> > I took the firmware files from here [2].
> >
> > Btw there is another issue, if i disconnect the wifi dongle during probe i'm getting a endless flood of the following output:
> >
> > mt76x0u 1.1.3:1.0: rx urb failed: -71
> >
> > Any chance to narrow down these issues?
> 
> Hi Stefan,
> 
> could you please test the following series:
> https://patchwork.kernel.org/cover/10764453/

yeah this fixed the probing timeout and the driver will probe successful. AFAIK the dwc2 host mode doesn't support scatter-gather yet.

> Applying this series I am able to connect to my home AP using an Asus
> USB-AC51 (mt76x0u) connected to a Raspberry Pi 3 B+.
> I am running rpi-5.0.y branch of https://github.com/raspberrypi/linux.git

The foundation kernel uses a different USB driver called dwc-otg which make use of FIQ.

Okay, now we only need to find a solution for the "rx urb failed" flood ;-)

Thank you very much
Stefan

> 
> Regards,
> Lorenzo
> 
> >
> > [1] - https://marc.info/?l=linux-wireless&m=154875316703367
> > [2] - https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/mediatek
