Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F527C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 16:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AC7A2147C
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 16:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfBTQgQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 11:36:16 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38348 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfBTQgP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 11:36:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id v26so7053076wmh.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2019 08:36:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5zUrReAbPC5w2ll0Bc1Mc4+Sr9vzmUkeHZRHO89+xB4=;
        b=Z0BBa4TeVxqPIgK+csJ4etlJGF9Vd5ZL7LevpMdQr0FYd5FOpRMxjfD3ZKLdTYe8+L
         AQ1oFs8dtpWURHundqEe1+AbmIE5Eemvz2vGzA8RRRsZwypgd2MUILTfY7I8pY9r0ZDz
         4YD8mHx+QS0X5/rxa3xmf9xEEA1+/Wu9iyrBIBMUU+CUmHcnl0V8cPOD6U9Or6r3cBjg
         d3taIfJJA5t12lzqvnaRioWfVHGkZWIoJqUnSvyAp+n641lOp0KmOP+SpUa19oo6rnWs
         KSjzIy+4Un0WYGlLCtsIq3z+Uve/0qLBOuJpmp6Qgrixq17kSDK+1XHy5/vuHzE2D71v
         WO8Q==
X-Gm-Message-State: AHQUAub6eaRMn09QTYwRf/KUa3yWkuDkbLvnW67wS5lx0hiz1QPyYsHx
        bk4edLLtSBMDRYSqIOpaOKaO7w==
X-Google-Smtp-Source: AHgI3IZg9fwz9EKCBvsUr/r4OeGBiADL2mrqYyy9wOxocbqLU+BGpYPlR959PJWmrs7TFFh6lSm46g==
X-Received: by 2002:a1c:7610:: with SMTP id r16mr7186730wmc.139.1550680573004;
        Wed, 20 Feb 2019 08:36:13 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id z6sm7164568wml.40.2019.02.20.08.36.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Feb 2019 08:36:12 -0800 (PST)
Date:   Wed, 20 Feb 2019 17:36:10 +0100
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
Message-ID: <20190220163609.GI2626@localhost.localdomain>
References: <0e29e99a-6ed4-40fe-1f38-30f1b5530a16@nbd.name>
 <20190218150303.GD9602@redhat.com>
 <a035966b-99f8-1109-d96f-0c3862d26518@nbd.name>
 <20190219104208.GA22999@redhat.com>
 <58097bb1-d726-c48e-2a40-2e12098dfb15@nbd.name>
 <20190220130009.GA2377@redhat.com>
 <20190220132206.GF2626@localhost.localdomain>
 <20190220161415.GA14165@redhat.com>
 <20190220162217.GH2626@localhost.localdomain>
 <20190220163229.GB14165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220163229.GB14165@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Wed, Feb 20, 2019 at 05:22:18PM +0100, Lorenzo Bianconi wrote:
> > > On Wed, Feb 20, 2019 at 02:22:08PM +0100, Lorenzo Bianconi wrote:
> > > > > On Tue, Feb 19, 2019 at 01:19:26PM +0100, Felix Fietkau wrote:
> > > > > > >> >> The way I see it, we have two choices.
> > > > > > >> >> 1. Fix dwc2 to do its alignment quirk for the urb->sg != NULL case
> > > > > > >> >> 2. Rely on urb->transfer_buffer and keep urb->sg NULL
> > > > > > >> > 
> > > > > > >> > I agree, if this is only needed for dwc2. Though I would investigate
> > > > > > >> > if this is not a bug on other platforms as well.
> > > > > > >> >From what I can see, using Lorenzo's patches seems to be the better
> > > > > > >> solution, since they avoid these corner cases in dwc2 (and maybe other
> > > > > > >> drivers as well). I will apply them and then we'll see if we need to do
> > > > > > >> any further improvements later on.
> > > > > > > 
> > > > > > > They work on rpi dwc2, but they do not address root of the problem.
> > > > > > > There is clearly something wrong how mt76usb handle SG, what is not
> > > > > > > fixed. And adding disable_usb_sg module parameter for hcd's supporting
> > > > > > > SG should be red flag.
> > > > > > I think we're simply dealing with multiple issues here, only some of
> > > > > > which are fixed by Lorenzo's patches.
> > > > > > I'm pretty sure it's still wrong for mt76 to try to align its buffers,
> > > > > > since the Linux USB API supports non-aligned transfer buffers and it
> > > > > > should be up to the controller driver to deal with that.
> > > > > 
> > > > > Agree.
> > > > > 
> > > > > > dwc2 tries to do that, but that has limitations which I already pointed
> > > > > > out and which are properly dealt with by Lorenzo's patches.
> > > > > 
> > > > > I planed to just accept current solution, but I started to work on patch
> > > > > that remove len, sglen arguments from mt76u_buf_alloc() and use
> > > > > q->buf_size and SKB_WITH_OVERHEAD(q->buf_size) directly and realized how
> > > > > related code is now tangled.
> > > > > 
> > > > > Would be ok to send this patch with proper changelog as fix for RPI
> > > > > against wireless-drivers and cc:stable (assuming it works and really
> > > > > fix things on RPI) and revert Lorenzo's patches in -next ?
> > > > 
> > > > Hi Stanislaw,
> > > > 
> > > > what is the advantage of doing so?
> > > To have small fix proper for -stable to fix the problem in 4.20 and 4.19,
> > > and have simpler code.
> > 
> > merging the series I sent we will have a pretty simple approach, just a
> > single routine that allocates the rx buffers in the control path according to
> > the operating mode.
> 
> So will you do the backport of your patches and post them to -stable ?
> Do you think greg-kh will accept those ?

I will take care of it

Regards,
Lorenzo

> 
> Stanislaw 
