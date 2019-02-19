Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE11C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 10:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40A6C206BB
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 10:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfBSK7u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 05:59:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55334 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfBSK7u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 05:59:50 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 76CCC87621;
        Tue, 19 Feb 2019 10:59:49 +0000 (UTC)
Received: from localhost (unknown [10.43.2.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2D4661B81;
        Tue, 19 Feb 2019 10:59:43 +0000 (UTC)
Date:   Tue, 19 Feb 2019 11:59:41 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190219105941.GB22999@redhat.com>
References: <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
 <20190215071226.GA2372@redhat.com>
 <1411983628.668277.1550315118443@email.ionos.de>
 <20190216140739.GA2236@redhat.com>
 <2009016263.528260.1550344627996@email.ionos.de>
 <20190218135247.GA9602@redhat.com>
 <1181760295.588129.1550528380134@email.ionos.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181760295.588129.1550528380134@email.ionos.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 19 Feb 2019 10:59:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 18, 2019 at 11:19:40PM +0100, Stefan Wahren wrote:
> Hi,
> 
> > Stanislaw Gruszka <sgruszka@redhat.com> hat am 18. Februar 2019 um 14:52 geschrieben:
> > 
> > 
> > On Sat, Feb 16, 2019 at 08:17:07PM +0100, Stefan Wahren wrote:
> > > this is a misunderstanding. The warning is about memory alignment to 32 bit addresses, not about page alignment. This is a typical ARM restriction. Maybe we need to make sure in mt76 that the DMA buffer needs to be aligned. But it's also possible that the warning isn't the root cause of our problem.
> > > 
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
> > 
> > > > Attached patch should fix this, plese test, thanks in advance.
> 
> i saw Felix decided to use Lorenzo's approach.
> 
> The patches 1,3,5 applied on today's next fixed only the warning and wifi is still broken (authentication timeout).
> 
> Here are the logs for multi_v7_defconfig:
> https://gist.github.com/lategoodbye/0a7c5cea7dbf25d0de7944c05d229d79

It would be interesting why urb->num_sgs = 0 & urb->sg cause
the troubles. This is how usb_sg_init() submit urbs for sg_tablesize = 0
controllers. So either are there are some requirement on urb->sg
mapped via dma_map_page() (which mt76usb does not meet) not needed
for urb->transfer_buffer mapped via dma_map_single() or there
is something wrong in dwc2 with sg and this driver will not
work with urb_sg_init() as well. I don't have hardware to investigate
this and don't want to bother you with more patches.

> > > Anyway i tested the following patch combinations against next with the same results as 1,2,3 (no wifi, alignment warning):
> > > 1,3
> > > 1,2,3,4
> > 
> > I noticed on my setup that patch 4 can cause troubles, but still
> > device is workable here on my PC machines.
> > 
> > > > > Btw i can confirm a regression was introduced after 4.19, because in 4.19 there was no firmware timeout but even no working wifi:
> > > > 
> > > > You ment 'no working wifi' or 'working wifi'?
> > > 
> > > Wifi is broken in 4.19, 4.20, 5.0 and next. It only worked with Lorenzo's SG avoid patches so far. Btw the regression (firmware timeout) started in 4.20. I also tested it today.
> > 
> > That somewhat strange because 4.19 mt76x0u does not use SG.
> > On 4.19 there is phy calibration bug fixed in 4.19.5:
> 
> Sorry for being inprecise. I was talking about the branches not the exact tags. I tested 4.19.23 without luck.

In github link you provided someone report mt76x0u working on 4.19 with
dwc_otg with disabled FIQ irq, so perhaps this is due to bug in dwc2
fixed in -next but not backported to 4.19.

> Many thanks anyway

Thanks for testing!

Stanislaw
