Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA11C282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 16:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 123E72176F
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 16:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfBJQwn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 11:52:43 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:53267 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbfBJQwm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 11:52:42 -0500
Received: by mail-it1-f194.google.com with SMTP id g85so20658355ita.3
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 08:52:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yq3MV50lsJtYeeVTNOIm1M2YeBHrJ7x+8u8P6QC6fpY=;
        b=jGT3eRWKUYkD8CCYovU1ZCvjJHnUVelRT/VuKRINYCMjseEdxiLShGDArCIrh4mhTt
         p2jN8ad2BGdr1RLIHVWHwntDi6IO3qe1xrfVwKwfWAtyRn9EfC9OlOo0dQ5Oq8HfQ8s4
         pG78ucncUD6GU/NGA/wQCTtNov+978mvMDMCahL8Bak/WVdylBpAcz2rrRVdqiM27b6x
         GTzNV2GYGP0w/A8xvRT23STu70He/rKs2Ic/9LwZwtunghFXK91PaCqnV1DWzUApeEI7
         gM/eCumda++yz9eDUCKRUqjQ7OvDi2OQJYwYvzEteeCdtqc68KAiFkTl10k4yPZwn/V8
         q5aw==
X-Gm-Message-State: AHQUAuZ1ORkwe2odScGNx4ckrm7W5D7oNd1g19uaWkpgugK9TPSe1He8
        IUObsavNSwut5W8bx3dGdNzh2MNi54t1gJBvNCmPAg==
X-Google-Smtp-Source: AHgI3IaCAZrgnJIPoXYvDfoYqTOlmXrJYQv/ZUIGJBWoEsBSZlzzf3/t/opOGGMAqHwMLbl5PyuljHR/pbsK5QsKcD0=
X-Received: by 2002:a05:660c:80a:: with SMTP id j10mr1005040itk.68.1549817561687;
 Sun, 10 Feb 2019 08:52:41 -0800 (PST)
MIME-Version: 1.0
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <20190210092943.GA2913@redhat.com> <307601671.418864.1549816737996@email.ionos.de>
In-Reply-To: <307601671.418864.1549816737996@email.ionos.de>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 10 Feb 2019 17:52:30 +0100
Message-ID: <CAJ0CqmXL_PXf0LuFOnshbYZb=j_KEHyfmV5wpHHW5HXcexhDJA@mail.gmail.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
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
> Hi,
>
> > Stanislaw Gruszka <sgruszka@redhat.com> hat am 10. Februar 2019 um 10:29 geschrieben:
> >
> >
> > On Sat, Feb 09, 2019 at 07:46:37PM +0100, Lorenzo Bianconi wrote:
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
> > > Applying this series I am able to connect to my home AP using an Asus
> > > USB-AC51 (mt76x0u) connected to a Raspberry Pi 3 B+.
> > > I am running rpi-5.0.y branch of https://github.com/raspberrypi/linux.git
> >
> > How the patch series fixed the issue since it was reported before that
> > it does not work on 4.19.x which do not use scatter gatter I/O ?
> >
> > Or it is regression ? 4.19.x driver works with rasperrypi/linux but -next
> > does not ?
>
> sorry for all the confusion (i never tested the foundation kernel). I made my functional tests with arm/multi_v7_defconfig which doesn't need any patches to work.
>
> Here the current results for next-2019-02-08:
>
> arm/multi_v7_defconfig w/o any patches -> wlan0 online
> arm64/defconfig w/o any patches -> timeout during firmware upload
> arm64/defconfig w Lorenzo's series -> driver probe, but dhcp doesn't work (could be a problem in my arm64 rootfs)
> arm/multi_v7_defconfig w Stanislaw's patch -> NULL pointer dereference
>

I am looking at this issue, it is not related to Stanislaw's patch,
there is a bug in the error code path.
Anyway we will need to avoid SG since dwc_otg controller does not support it

Regards,
Lorenzo

> I will test linux-4.19 and linux-5.0-rc5 to get a better picture ...
>
> >
> > Stanislaw
