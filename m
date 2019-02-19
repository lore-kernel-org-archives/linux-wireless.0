Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40C2C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 10:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4A2E21773
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 10:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfBSKmW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 05:42:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbfBSKmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 05:42:22 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 14F1DC051684;
        Tue, 19 Feb 2019 10:42:21 +0000 (UTC)
Received: from localhost (unknown [10.43.2.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04B0B61B6E;
        Tue, 19 Feb 2019 10:42:17 +0000 (UTC)
Date:   Tue, 19 Feb 2019 11:42:15 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190219104208.GA22999@redhat.com>
References: <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
 <20190215071226.GA2372@redhat.com>
 <1411983628.668277.1550315118443@email.ionos.de>
 <20190216140739.GA2236@redhat.com>
 <2009016263.528260.1550344627996@email.ionos.de>
 <20190218135247.GA9602@redhat.com>
 <0e29e99a-6ed4-40fe-1f38-30f1b5530a16@nbd.name>
 <20190218150303.GD9602@redhat.com>
 <a035966b-99f8-1109-d96f-0c3862d26518@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a035966b-99f8-1109-d96f-0c3862d26518@nbd.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 19 Feb 2019 10:42:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 18, 2019 at 07:52:27PM +0100, Felix Fietkau wrote:
> On 2019-02-18 16:03, Stanislaw Gruszka wrote:
> > On Mon, Feb 18, 2019 at 03:43:26PM +0100, Felix Fietkau wrote:
> >> On 2019-02-18 14:52, Stanislaw Gruszka wrote:
> >> > On Sat, Feb 16, 2019 at 08:17:07PM +0100, Stefan Wahren wrote:
> >> >> this is a misunderstanding. The warning is about memory alignment to 32 bit addresses, not about page alignment. This is a typical ARM restriction. Maybe we need to make sure in mt76 that the DMA buffer needs to be aligned. But it's also possible that the warning isn't the root cause of our problem.
> >> >> 
> >> > 
> >> > I see, it needs 4 bytes alignment . There is already dwc2 code checks
> >> > that and allocate new buffer if the alignment is not right:
> >> > dwc2_alloc_dma_aligned_buffer(), but it does nothing if urb->sg
> >> > is not NULL. I thought mt76usb already provide aligned buffers, but
> >> > looks it does not for one TX special case, which are PROBE REQUEST
> >> > frames. Other frames are aligned by inserting L2 header pad. One
> >> > solution for this would be just submit urb with  NULL sg (same as
> >> > Lorenzo's patches do, but still allocating buffers via buf->sg),
> >> > but I think, you have right, we should provide 4 bytes aligned buffers
> >> > by default as other DMA hardware may require that. I'm attaching yet
> >> > another patch to test, which fix up alignment for PROBE REQUEST frames.
> >> This approach looks completely wrong to me. MMIO based hardware does not
> >> need 4-byte aligned buffers at all, other USB controllers do not need
> >> this either.
> >> As Lorenzo already pointed out, re-aligning the buffer is *very*
> >> expensive, so we should not do this in the driver just to work around
> >> quirks in a particular USB host driver.
> > 
> > I decided to this patch because I thought some other USB & MMIO DMA
> > platforms might also require this alignment. But it was never triggered
> > in MMIO because on those mt76 is used in AP mode, hence no PROBE
> > REQUEST frames (and scan can be passive on STA mode).
> mt76 is regularly used and tested in STA and Mesh mode as well.
> No DMA alignment related issues there.

The question is why we need to do 2 bytes header pad ? Is this because
ieee802.11 header length for mt76 hardware has to be multiple of 4 or
it has to be aligned to 4 bytes? It would be strange if length has
to be fixed to 4 bytes and alignment not. However this could be
needed on some platforms and not on others. 
 
> >> The way I see it, we have two choices.
> >> 1. Fix dwc2 to do its alignment quirk for the urb->sg != NULL case
> >> 2. Rely on urb->transfer_buffer and keep urb->sg NULL
> > 
> > I agree, if this is only needed for dwc2. Though I would investigate
> > if this is not a bug on other platforms as well.
> >From what I can see, using Lorenzo's patches seems to be the better
> solution, since they avoid these corner cases in dwc2 (and maybe other
> drivers as well). I will apply them and then we'll see if we need to do
> any further improvements later on.

They work on rpi dwc2, but they do not address root of the problem.
There is clearly something wrong how mt76usb handle SG, what is not
fixed. And adding disable_usb_sg module parameter for hcd's supporting
SG should be red flag.

Stanislaw
