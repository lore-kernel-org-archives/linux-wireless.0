Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC83CC282DA
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B80F222B0
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404035AbfBKPLE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:11:04 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52750 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391502AbfBKPLC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 10:11:02 -0500
Received: by mail-wm1-f65.google.com with SMTP id m1so18097246wml.2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 07:11:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CTCVlB/ozOOzsnfd5Rz/lfSd8ugZtp3aH083Ab6zJPg=;
        b=DoYxOertSayAznKP0bZiDgpizBQg4hhUzk6W6OxtLm/U4cvNLQWZdIFrgo/iKllzzb
         NdeXfMcp02LEQx13wk37Tf/3E9wnh6TTOIoXNsBnb9b2NNxkfvteg+kfCRH/KK+uXSuG
         kCfVWmvyJcBdVKkU3e2FALg3rI8founVsla5cxEQMfL1zNdnPYfQLhqVutXpw3Lj7jxH
         g4Vg+1OTNenJMzCbQP4snyUWzPZUSGSx2M7M0fVrFeTg4CyzS51YxbikOo+LOLrFIrAU
         nXHMGfufb/x70S02nM3bE0u+oSY4acMoT9NBtukzW3UuQshhW8KI6hFMLj92mSM9ciZl
         SRag==
X-Gm-Message-State: AHQUAuYpv2ERIvVNBTdFhJ3LDwEGYrFgGMnVIKbMjoxhSug+ulojXd5v
        ojWICMawqNm/5tpBLAiluW0Wpw==
X-Google-Smtp-Source: AHgI3IabNCGn9B9ehjR7Bw6lfIGteCsxVzor2EOe4V/3Dtbtjx0zzN64GrNFpr1vlOgU8WsFoXMVJg==
X-Received: by 2002:a1c:a104:: with SMTP id k4mr9404938wme.54.1549897860369;
        Mon, 11 Feb 2019 07:11:00 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id c1sm10055614wmb.14.2019.02.11.07.10.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Feb 2019 07:10:59 -0800 (PST)
Date:   Mon, 11 Feb 2019 16:10:56 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190211151055.GC8128@localhost.localdomain>
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <165515185.283024.1549744145982@email.ionos.de>
 <20190210094123.GB2913@redhat.com>
 <CAJ0CqmXp2a-zwPMyMFu+UCqTHP7qNRiJFopDSdZWdms7dVef4Q@mail.gmail.com>
 <20190211074455.GA6292@redhat.com>
 <20190211100405.GD3467@localhost.localdomain>
 <f7c29b08-c7d5-4d10-4be1-958ee79678f1@i2se.com>
 <20190211110635.GD2293@localhost.localdomain>
 <8a996497-ed69-4087-2c37-7f73633cbb4e@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a996497-ed69-4087-2c37-7f73633cbb4e@i2se.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Hi Lorenzo,
> 
> Am 11.02.19 um 12:06 schrieb Lorenzo Bianconi:
> >> Hi,
> >>
> >> Am 11.02.19 um 11:04 schrieb Lorenzo Bianconi:
> >>>> On Sun, Feb 10, 2019 at 11:22:25AM +0100, Lorenzo Bianconi wrote:
> >>>>>> On Sat, Feb 09, 2019 at 09:29:05PM +0100, Stefan Wahren wrote:
> >>>>>>>> could you please test the following series:
> >>>>>>>> https://patchwork.kernel.org/cover/10764453/
> >>>>>>> yeah this fixed the probing timeout and the driver will probe successful. AFAIK the dwc2 host mode doesn't support scatter-gather yet.
> >>>>>> So this is either dwc2 scatter-gather problem which should be addressed in
> >>>>>> this driver or mt76x0u does something wrong when configuring SG.
> >>>>>>
> >>>>>> Disabling SG is just workaround, which do not address actual problem.
> >>>>>>
> >>>>>> I think I found mt76x0u issue that could cause this USB probe error
> >>>>>> (and possibly also address AMD IOMMU issue). We seems do not correctly
> >>>>>> set URB transfer length smaller than sg buffer length. Attached  patch
> >>>>>> should correct that.
> >>>>> Hi Stanislaw,
> >>>>>
> >>>>> I think 'sg[0].length' is already set in mt76u_fill_rx_sg().
> >>>> It is, buf->len and sg[0].length are initialized to the same value for 1
> >>>> segment. But then buf->len (assigned to urb->buffer_transfer_length) change
> >>>> to smaller value , but sg[0].length stay the same. What I think can be
> >>>> problem for usb host driver.
> >>>>
> >>>>> Moreover applying this patch I got the following crash (rpi-5.0.y):
> >>>> Ok, so with patch probe fail instantly and trigger yet another bug(s)
> >>>> on error path. You seems to address that already. 
> >>>>
> >>>>> Moreover for mt76x0u SG is 'already' disabled since we use just one
> >>>>> buffer so from performance point of view I do not see any difference
> >>>>> of using a standard usb buffer.
> >>>>> This patch has been tested in multiple scenarios and seems to fix
> >>>>> reported issues (for usb2.0).
> >>>> Ok, so passing buffer via urb->transfer_buffer works. But why urb->sg
> >>>> does not work for 1 segment ?
> >>> Here it is a different issue respect to the AMD IOMMU one, dwc2 host driver
> >>> does not implement SG I/O so probing fails. I guess it is still useful to
> >>> implement a 'legacy' mode that enable mt76 on host controllers that do not implement
> >>> SG I/O (rpi is a very common device so it will be cool to have mt76 working on
> >>> it). Moreover we are not removing functionalities, user experience will remain
> >>> the same
> >>>
> >> i'm not sure that you understand my mail [1] with the summary of my test
> >> results.
> >>
> > Yes right, I did not get it sorry :)
> > as indicated here https://www.raspberrypi.org/documentation/linux/kernel/building.md
> > I am using bcm2709_defconfig config (using it I spotted the mt76 crashes and
> > probe failure)
> 
> no problem, at the beginning this could be very confusing. I only want
> to clarify that this documentation refers to the vendor kernel (with a
> different USB host driver) of the Raspberry Pi Foundation.
> 
> All my results refers to the mainline kernel we all should talk about. I
> started a gist which try to describe the mainline variant:
> https://gist.github.com/lategoodbye/c7317a42bf7f9c07f5a91baed8c68f75

So to summarize:
- Raspberry Pi Foundation kernel works just with RFC series
- mainline kernel works out of the box

is my understanding correct? I am still considering adding a legacy mode since
there will not be any regression using it instead of SG I/O with just one SG
buffer

Regards,
Lorenzo

> 
> Maybe this could be helpful.
> 
> Stefan
> 
> > Regards,
> > Lorenzo
> >
> >> In case of using the arm/multi_v7_defconfig (32 bit) the mt76 works like
> >> a charm without your sg avoid patch series, but the arm64/defconfig (64
> >> bit) requires the series to probe at least. So i wouldn't conclude from
> >> the fact that dwc2 doesn't support SG any probing issues on arm64. So we
> >> need to investigate which config option triggers the problem.
> >>
> >> Stefan
> >>
> >> [1] - https://marc.info/?l=linux-usb&m=154981675724078
> >>
