Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F4DC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D42912146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbfBTKUz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:20:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbfBTKUz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 05:20:55 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9614EA0913;
        Wed, 20 Feb 2019 10:20:54 +0000 (UTC)
Received: from localhost (unknown [10.40.205.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC2A71001E8A;
        Wed, 20 Feb 2019 10:20:51 +0000 (UTC)
Date:   Wed, 20 Feb 2019 11:20:50 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190220102050.GA7195@redhat.com>
References: <20190219105941.GB22999@redhat.com>
 <Pine.LNX.4.44L0.1902191032480.1623-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1902191032480.1623-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 20 Feb 2019 10:20:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 19, 2019 at 10:40:47AM -0500, Alan Stern wrote:
> On Tue, 19 Feb 2019, Stanislaw Gruszka wrote:
> 
> > It would be interesting why urb->num_sgs = 0 & urb->sg cause
> > the troubles. This is how usb_sg_init() submit urbs for sg_tablesize = 0
> > controllers. So either are there are some requirement on urb->sg
> > mapped via dma_map_page() (which mt76usb does not meet) not needed
> > for urb->transfer_buffer mapped via dma_map_single() or there
> > is something wrong in dwc2 with sg and this driver will not
> > work with urb_sg_init() as well. I don't have hardware to investigate
> > this and don't want to bother you with more patches.
> 
> urb->sg != NULL and urb->num_sgs == 0 means that the transfer buffer 
> must fit into a single page, which is pointed to by the first element 
> of the scatterlist.

I asked about that in other thread 
https://lore.kernel.org/linux-wireless/2cc5674a-a3a0-d8fe-65f5-4357da9b85d3@arm.com/

the answer was it is weird but valid. However I think do dma_map_page()
on buffer not fit in the single page is asking for troubles. I just posted
patch that should fix this for mt76usb.

> But now that I look at the code in usb_sg_init(), it seems odd that the
> !use_sg case doesn't increment sg during each loop iteration.  I don't
> see how that could possibly work -- it looks like a bug!

Looks for me that this is done via for_each_sg(sg, sg, io->entries, i) loop.

Stanislaw
