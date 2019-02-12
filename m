Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C99C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C6CB214DA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbfBLNPq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 08:15:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbfBLNPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 08:15:46 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7573980481;
        Tue, 12 Feb 2019 13:15:45 +0000 (UTC)
Received: from localhost (ovpn-204-125.brq.redhat.com [10.40.204.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67FB31992A;
        Tue, 12 Feb 2019 13:15:44 +0000 (UTC)
Date:   Tue, 12 Feb 2019 14:15:43 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190212131542.GC12906@redhat.com>
References: <20190211173315.GE6292@redhat.com>
 <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
 <20190212115842.GA24197@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190212115842.GA24197@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 12 Feb 2019 13:15:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 12, 2019 at 12:58:43PM +0100, Lorenzo Bianconi wrote:
> > +	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, buf->len, complete_fn,
> > +			  context);
> > +
> > +	if (udev->bus->sg_tablesize > 0) {
> > +		buf->urb->num_sgs = buf->num_sgs;
> > +	} else {
> > +		WARN_ON_ONCE(buf->num_sgs != 1);
> > +		/* See usb_sg_init() */
> > +		buf->urb->num_sgs = 0;
> > +		if (!PageHighMem(sg_page(buf->urb->sg)))
> > +			buf->urb->transfer_buffer = sg_virt(buf->urb->sg);
> 
> please correct me if I am wrong but doing so we will use transfer_buffer
> for 95% of the use cases, right? If so why not keep it simple and always
> use it when sg_tablesize is 0 (avoiding SG I/O)?
>
> Btw this is what I proposed with the RFC series actually :) (always use
> transfer_buffer in the usb 2.0 case)

Because this way we do not change allocation method (use SG allocation)
what is simpler IMHO than having two buffer allocation methods.

And this way we do not hide problems with SG allocation and test it.

Additionally this patch address actual bug: using wrong urb->num_sgs and
can be easier to backport to older releases than 4 patch series. 

Stanislaw
