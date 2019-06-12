Return-Path: <SRS0=e4fn=UL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F7BC31E46
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jun 2019 10:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81A36207E0
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jun 2019 10:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407251AbfFLK0b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Jun 2019 06:26:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34516 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405983AbfFLK0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jun 2019 06:26:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3D4152F8BC3;
        Wed, 12 Jun 2019 10:26:26 +0000 (UTC)
Received: from localhost (unknown [10.43.2.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D530917B92;
        Wed, 12 Jun 2019 10:26:16 +0000 (UTC)
Date:   Wed, 12 Jun 2019 12:25:05 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mt76: usb: do not always copy the first part of
 received frames
Message-ID: <20190612102502.GB4431@redhat.com>
References: <cover.1559293385.git.lorenzo@kernel.org>
 <2ed0b595a12944a8cfea14e066bcc4fa24f0ba44.1559293385.git.lorenzo@kernel.org>
 <20190612091036.GB2965@redhat.com>
 <20190612095302.GD8107@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612095302.GD8107@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 12 Jun 2019 10:26:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jun 12, 2019 at 11:53:03AM +0200, Lorenzo Bianconi wrote:
> > On Fri, May 31, 2019 at 11:38:23AM +0200, Lorenzo Bianconi wrote:
> 
> [...]
> 
> > >  	}
> > >  
> > >  	urb->num_sgs = max_t(int, i, urb->num_sgs);
> > > -	urb->transfer_buffer_length = urb->num_sgs * q->buf_size,
> > > +	urb->transfer_buffer_length = urb->num_sgs * data_size;
> > >  	sg_init_marker(urb->sg, urb->num_sgs);
> > >  
> > >  	return i ? : -ENOMEM;
> > > @@ -611,8 +611,12 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
> > >  	if (!q->entry)
> > >  		return -ENOMEM;
> > >  
> > > -	q->buf_size = dev->usb.sg_en ? MT_RX_BUF_SIZE : PAGE_SIZE;
> > > +	if (dev->usb.sg_en)
> > > +		q->buf_size = MT_BUF_WITH_OVERHEAD(MT_RX_BUF_SIZE);
> > 
> > I strongly recommend to not doing this. While this should work
> > in theory creating buffer with size of 2k + some bytes might
> > trigger various bugs in dma mapping or other low level code.
> 
> even in practice actually :)

I wouldn't be sure about this. It's not common to have buffers of
such size and crossing pages boundaries. It really can trigger
nasty bugs on various IOMMU drivers.

> but we can be more cautious since probably copying
> the first 128B will not make any difference

Not sure if I understand what you mean.

> > And skb_shered_info is needed only in first buffer IIUC.
> > 
> > Also this patch seems to make first patch unnecessary except for
> > non sg_en case (in which I think rx AMSDU is broken anyway),
> > so I would prefer just to apply first patch.
> 
> I do not think rx AMSDU is broken for non sg_en case since the max rx value
> allowed should be 3839 IIRC and we alloc one page in this case

If that's the case we should be fine, but then I do not understand
why we allocate 8*2k buffers for sg_en case, isn't that AP can
sent AMSDU frame 16k big?

Stanislaw

