Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B26C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 16:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00BC220880
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 16:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfBTQOb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 11:14:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43588 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfBTQOa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 11:14:30 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 33C68765C6;
        Wed, 20 Feb 2019 16:14:30 +0000 (UTC)
Received: from localhost (ovpn-204-136.brq.redhat.com [10.40.204.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DDEB6016F;
        Wed, 20 Feb 2019 16:14:17 +0000 (UTC)
Date:   Wed, 20 Feb 2019 17:14:16 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190220161415.GA14165@redhat.com>
References: <20190216140739.GA2236@redhat.com>
 <2009016263.528260.1550344627996@email.ionos.de>
 <20190218135247.GA9602@redhat.com>
 <0e29e99a-6ed4-40fe-1f38-30f1b5530a16@nbd.name>
 <20190218150303.GD9602@redhat.com>
 <a035966b-99f8-1109-d96f-0c3862d26518@nbd.name>
 <20190219104208.GA22999@redhat.com>
 <58097bb1-d726-c48e-2a40-2e12098dfb15@nbd.name>
 <20190220130009.GA2377@redhat.com>
 <20190220132206.GF2626@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220132206.GF2626@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 20 Feb 2019 16:14:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 20, 2019 at 02:22:08PM +0100, Lorenzo Bianconi wrote:
> > On Tue, Feb 19, 2019 at 01:19:26PM +0100, Felix Fietkau wrote:
> > > >> >> The way I see it, we have two choices.
> > > >> >> 1. Fix dwc2 to do its alignment quirk for the urb->sg != NULL case
> > > >> >> 2. Rely on urb->transfer_buffer and keep urb->sg NULL
> > > >> > 
> > > >> > I agree, if this is only needed for dwc2. Though I would investigate
> > > >> > if this is not a bug on other platforms as well.
> > > >> >From what I can see, using Lorenzo's patches seems to be the better
> > > >> solution, since they avoid these corner cases in dwc2 (and maybe other
> > > >> drivers as well). I will apply them and then we'll see if we need to do
> > > >> any further improvements later on.
> > > > 
> > > > They work on rpi dwc2, but they do not address root of the problem.
> > > > There is clearly something wrong how mt76usb handle SG, what is not
> > > > fixed. And adding disable_usb_sg module parameter for hcd's supporting
> > > > SG should be red flag.
> > > I think we're simply dealing with multiple issues here, only some of
> > > which are fixed by Lorenzo's patches.
> > > I'm pretty sure it's still wrong for mt76 to try to align its buffers,
> > > since the Linux USB API supports non-aligned transfer buffers and it
> > > should be up to the controller driver to deal with that.
> > 
> > Agree.
> > 
> > > dwc2 tries to do that, but that has limitations which I already pointed
> > > out and which are properly dealt with by Lorenzo's patches.
> > 
> > I planed to just accept current solution, but I started to work on patch
> > that remove len, sglen arguments from mt76u_buf_alloc() and use
> > q->buf_size and SKB_WITH_OVERHEAD(q->buf_size) directly and realized how
> > related code is now tangled.
> > 
> > Would be ok to send this patch with proper changelog as fix for RPI
> > against wireless-drivers and cc:stable (assuming it works and really
> > fix things on RPI) and revert Lorenzo's patches in -next ?
> 
> Hi Stanislaw,
> 
> what is the advantage of doing so?
To have small fix proper for -stable to fix the problem in 4.20 and 4.19,
and have simpler code.

> You have duplicated most of the fields that are
> already in the urb data structure and you use transfer_buffer (no SG I/O).
URB has plenty of fields, I duplicated 2. If size of mt76u_buf is a concern
this can be optimized by packing num_sgs, len, done into fields variable.

> Moreover I have ready a series that removes 99% of the dual allocation code and
> maintain it in the control path (instead of the datapath one).
> I need just to rebase it ontop of your series. I will post it soon.
So I would ask what is the point to adding bunch of code and remove it in very
next patch?

Stanislaw 
