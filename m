Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D2CC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 16:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35BAB20880
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 16:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbfBTQWY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 11:22:24 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43812 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbfBTQWY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 11:22:24 -0500
Received: by mail-wr1-f66.google.com with SMTP id d17so12310715wre.10
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2019 08:22:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QBi4C8IXa+iPmrxHpCuzTRZlMEX14lEXIriTy/12RHM=;
        b=E4wYfRmKAZrrtcedtMSMQhkVIsB+E0CcP43aZCXh9512eAJWl2AkTOXhz+DiKY0NVc
         lICyPA6fWP6ZqoOP0Hh7uCUnlsUwKwysBnjTzIf/g9y6C+7n1eHWX+AIKm4qLoRp86Ug
         BBVO9hDnr9SIB/w1nyt+d40H3QKBpHTUcKaJlmw14yCyR3IZawQyUjEs8heSqyskSqkH
         t09bWzjrPsWj9xhh15J+cHzPZAKJAGHVCM5cTw+JxXWKIF9m8PnVGRBguo643eaJN1cQ
         RyIKkCskE0S4XZ+QtXJFz1Ve1eGk0bCTmX59M3gpofj2SsgJhXx6L5FBCB5W7YDpm1Q4
         BYDw==
X-Gm-Message-State: AHQUAubSsMbLyI9DgAZxRqeZh44xYIfpBfhUEDychWZmnjod/h40OBWj
        ANouxZKr2IofT8CwBAHV6g2j3w==
X-Google-Smtp-Source: AHgI3IbARgpUfOhe3nQ4PQ90YJDmT2HjKUAc4NqL1Ym0+IOy2bDHPOpcOu9omt4iHbrjRl/os56KSg==
X-Received: by 2002:adf:9e0c:: with SMTP id u12mr24688524wre.216.1550679741998;
        Wed, 20 Feb 2019 08:22:21 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id u8sm10819276wrp.55.2019.02.20.08.22.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Feb 2019 08:22:21 -0800 (PST)
Date:   Wed, 20 Feb 2019 17:22:18 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190220162217.GH2626@localhost.localdomain>
References: <2009016263.528260.1550344627996@email.ionos.de>
 <20190218135247.GA9602@redhat.com>
 <0e29e99a-6ed4-40fe-1f38-30f1b5530a16@nbd.name>
 <20190218150303.GD9602@redhat.com>
 <a035966b-99f8-1109-d96f-0c3862d26518@nbd.name>
 <20190219104208.GA22999@redhat.com>
 <58097bb1-d726-c48e-2a40-2e12098dfb15@nbd.name>
 <20190220130009.GA2377@redhat.com>
 <20190220132206.GF2626@localhost.localdomain>
 <20190220161415.GA14165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220161415.GA14165@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Wed, Feb 20, 2019 at 02:22:08PM +0100, Lorenzo Bianconi wrote:
> > > On Tue, Feb 19, 2019 at 01:19:26PM +0100, Felix Fietkau wrote:
> > > > >> >> The way I see it, we have two choices.
> > > > >> >> 1. Fix dwc2 to do its alignment quirk for the urb->sg != NULL case
> > > > >> >> 2. Rely on urb->transfer_buffer and keep urb->sg NULL
> > > > >> > 
> > > > >> > I agree, if this is only needed for dwc2. Though I would investigate
> > > > >> > if this is not a bug on other platforms as well.
> > > > >> >From what I can see, using Lorenzo's patches seems to be the better
> > > > >> solution, since they avoid these corner cases in dwc2 (and maybe other
> > > > >> drivers as well). I will apply them and then we'll see if we need to do
> > > > >> any further improvements later on.
> > > > > 
> > > > > They work on rpi dwc2, but they do not address root of the problem.
> > > > > There is clearly something wrong how mt76usb handle SG, what is not
> > > > > fixed. And adding disable_usb_sg module parameter for hcd's supporting
> > > > > SG should be red flag.
> > > > I think we're simply dealing with multiple issues here, only some of
> > > > which are fixed by Lorenzo's patches.
> > > > I'm pretty sure it's still wrong for mt76 to try to align its buffers,
> > > > since the Linux USB API supports non-aligned transfer buffers and it
> > > > should be up to the controller driver to deal with that.
> > > 
> > > Agree.
> > > 
> > > > dwc2 tries to do that, but that has limitations which I already pointed
> > > > out and which are properly dealt with by Lorenzo's patches.
> > > 
> > > I planed to just accept current solution, but I started to work on patch
> > > that remove len, sglen arguments from mt76u_buf_alloc() and use
> > > q->buf_size and SKB_WITH_OVERHEAD(q->buf_size) directly and realized how
> > > related code is now tangled.
> > > 
> > > Would be ok to send this patch with proper changelog as fix for RPI
> > > against wireless-drivers and cc:stable (assuming it works and really
> > > fix things on RPI) and revert Lorenzo's patches in -next ?
> > 
> > Hi Stanislaw,
> > 
> > what is the advantage of doing so?
> To have small fix proper for -stable to fix the problem in 4.20 and 4.19,
> and have simpler code.

merging the series I sent we will have a pretty simple approach, just a
single routine that allocates the rx buffers in the control path according to
the operating mode.

> 
> > You have duplicated most of the fields that are
> > already in the urb data structure and you use transfer_buffer (no SG I/O).
> URB has plenty of fields, I duplicated 2. If size of mt76u_buf is a concern
> this can be optimized by packing num_sgs, len, done into fields variable.
> 
> > Moreover I have ready a series that removes 99% of the dual allocation code and
> > maintain it in the control path (instead of the datapath one).
> > I need just to rebase it ontop of your series. I will post it soon.
> So I would ask what is the point to adding bunch of code and remove it in very
> next patch?

In the first series I fixed the issue, in this one I improved the code, I have
no added any new feature

Regards,
Lorenzo

> 
> Stanislaw 
