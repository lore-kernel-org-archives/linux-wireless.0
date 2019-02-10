Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D0FC282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 16:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6195213F2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 16:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfBJQjJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 11:39:09 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:55733 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbfBJQjJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 11:39:09 -0500
Received: from oxbaltgw04.schlund.de ([172.19.246.10]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MmQUL-1hJiQE2sef-00iWSE; Sun, 10 Feb 2019 17:38:59 +0100
Date:   Sun, 10 Feb 2019 17:38:57 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Message-ID: <307601671.418864.1549816737996@email.ionos.de>
In-Reply-To: <20190210092943.GA2913@redhat.com>
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <20190210092943.GA2913@redhat.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev47
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:kFlerG/HTWJM1K/CySdvp61LZP09xwR0zUGOrMZAExw4Ve7qaUA
 b9Oh/u6HYbJ/hcGNq0Gu+TdO7lh0MrbWLnjG52zbTjwwYeOdBlHWvH6ZuPgdjh6mVxydxLh
 7x2T+y4r6NdiZu4SpJj6hMnlyLS97iqeySzJv/Dx+yglyl+l3V8L3qDo2K1rUIxk6TrIjEJ
 qP0y6UC/oYZypqv/ITETw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:oGMrXFF82h8=:NPMUKS/y3RC6lemxpFRi3+
 QeRM+nxWvz4h6jsCHGa4/QjukIdiM7ADRUXpci50D291b+GZiLclcJIrwzVwLjrt8KriALS85
 e6cVQ8CwtL7XhN27hwCrMZVE0vveLfec4Hm5/rNw5h5YeXkFoOJMuPpzzdFgGm+9hsoj8ldRq
 n2aODM9mk3YtYYzmQkCU5zmy0kBSbEkHq5fQTyjWbWgL1IzaoxICHSxxByRUz12UQIShiyQnX
 EFnMhlAqmB26iPY9Bfrsi5wcfNrHzP7cco60Jnd0G7zj2CYFvu0k/92U61Zb4ORssr1Ldwx2+
 Br/zdjPeN7WJATAVPzqvAvZYe5OzgQ99PjNdSUxPdhGrFRMFd8c1tocE2IJAzSByphFjUztWM
 Z64fcfqAvWWxQxT3VM7azn1XglvCDxzme5svMxbEjg1ZlhnqXzLsVcX/D8bdVzrhOpnP3P4S/
 hligWfBrE//rRxAGIZWbkKy+entS6zuF4+mYjThbiAwrR84432wv3ulwnOeNSCf6X8L0NMGqg
 Ou9IgcGUgt7bglgkchQQV0z6KUATKc5fkTldL67OSebMiuivd+XQG8mf3+dJSn3Z85qd76KtH
 J0odqhalwYynoNmT89UxhH4FLnJn9i5CjMsNpT6u1xRYFlWRlDIksZ6Llr1IeH7Oqf/gPfzLs
 i3YNgMx6bzs6+Lh1EZkD5OsmfuiN1GzPvuxQ3uBuP+tyymIfCV74oIoPFdXOsfH4gHEvqg/va
 i95HHg1wFHCbDidP6/NObSRw2ZFy7uxxNVLFw0WgCrKXIKDGammlwV47y8o=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> Stanislaw Gruszka <sgruszka@redhat.com> hat am 10. Februar 2019 um 10:29 geschrieben:
> 
> 
> On Sat, Feb 09, 2019 at 07:46:37PM +0100, Lorenzo Bianconi wrote:
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
> > Applying this series I am able to connect to my home AP using an Asus
> > USB-AC51 (mt76x0u) connected to a Raspberry Pi 3 B+.
> > I am running rpi-5.0.y branch of https://github.com/raspberrypi/linux.git
> 
> How the patch series fixed the issue since it was reported before that 
> it does not work on 4.19.x which do not use scatter gatter I/O ?
> 
> Or it is regression ? 4.19.x driver works with rasperrypi/linux but -next
> does not ?

sorry for all the confusion (i never tested the foundation kernel). I made my functional tests with arm/multi_v7_defconfig which doesn't need any patches to work.

Here the current results for next-2019-02-08:

arm/multi_v7_defconfig w/o any patches -> wlan0 online
arm64/defconfig w/o any patches -> timeout during firmware upload
arm64/defconfig w Lorenzo's series -> driver probe, but dhcp doesn't work (could be a problem in my arm64 rootfs)
arm/multi_v7_defconfig w Stanislaw's patch -> NULL pointer dereference

I will test linux-4.19 and linux-5.0-rc5 to get a better picture ...

> 
> Stanislaw
