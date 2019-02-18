Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA18C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 15:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1C582173C
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 15:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730942AbfBRPDJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 10:03:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729905AbfBRPDJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 10:03:09 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF8A98E6EF;
        Mon, 18 Feb 2019 15:03:08 +0000 (UTC)
Received: from localhost (unknown [10.40.205.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 742CF600C8;
        Mon, 18 Feb 2019 15:03:04 +0000 (UTC)
Date:   Mon, 18 Feb 2019 16:03:03 +0100
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
Message-ID: <20190218150303.GD9602@redhat.com>
References: <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
 <20190215071226.GA2372@redhat.com>
 <1411983628.668277.1550315118443@email.ionos.de>
 <20190216140739.GA2236@redhat.com>
 <2009016263.528260.1550344627996@email.ionos.de>
 <20190218135247.GA9602@redhat.com>
 <0e29e99a-6ed4-40fe-1f38-30f1b5530a16@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e29e99a-6ed4-40fe-1f38-30f1b5530a16@nbd.name>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 18 Feb 2019 15:03:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 18, 2019 at 03:43:26PM +0100, Felix Fietkau wrote:
> On 2019-02-18 14:52, Stanislaw Gruszka wrote:
> > On Sat, Feb 16, 2019 at 08:17:07PM +0100, Stefan Wahren wrote:
> >> this is a misunderstanding. The warning is about memory alignment to 32 bit addresses, not about page alignment. This is a typical ARM restriction. Maybe we need to make sure in mt76 that the DMA buffer needs to be aligned. But it's also possible that the warning isn't the root cause of our problem.
> >> 
> > 
> > I see, it needs 4 bytes alignment . There is already dwc2 code checks
> > that and allocate new buffer if the alignment is not right:
> > dwc2_alloc_dma_aligned_buffer(), but it does nothing if urb->sg
> > is not NULL. I thought mt76usb already provide aligned buffers, but
> > looks it does not for one TX special case, which are PROBE REQUEST
> > frames. Other frames are aligned by inserting L2 header pad. One
> > solution for this would be just submit urb with  NULL sg (same as
> > Lorenzo's patches do, but still allocating buffers via buf->sg),
> > but I think, you have right, we should provide 4 bytes aligned buffers
> > by default as other DMA hardware may require that. I'm attaching yet
> > another patch to test, which fix up alignment for PROBE REQUEST frames.
> This approach looks completely wrong to me. MMIO based hardware does not
> need 4-byte aligned buffers at all, other USB controllers do not need
> this either.
> As Lorenzo already pointed out, re-aligning the buffer is *very*
> expensive, so we should not do this in the driver just to work around
> quirks in a particular USB host driver.

I decided to this patch because I thought some other USB & MMIO DMA
platforms might also require this alignment. But it was never triggered
in MMIO because on those mt76 is used in AP mode, hence no PROBE
REQUEST frames (and scan can be passive on STA mode).

> The way I see it, we have two choices.
> 1. Fix dwc2 to do its alignment quirk for the urb->sg != NULL case
> 2. Rely on urb->transfer_buffer and keep urb->sg NULL

I agree, if this is only needed for dwc2. Though I would investigate
if this is not a bug on other platforms as well.

Stanislaw
