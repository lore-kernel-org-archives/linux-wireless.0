Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680A8C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 07:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42F49214AF
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 07:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfCLHIh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 03:08:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfCLHIg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 03:08:36 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B496185376;
        Tue, 12 Mar 2019 07:08:36 +0000 (UTC)
Received: from localhost (ovpn-204-138.brq.redhat.com [10.40.204.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5317D60C98;
        Tue, 12 Mar 2019 07:08:34 +0000 (UTC)
Date:   Tue, 12 Mar 2019 08:08:33 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     Rosen Penev <rosenp@gmail.com>, Joerg Roedel <joro@8bytes.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, jan.viktorin@gmail.com
Subject: Re: [PATCH] iommu/amd: fix sg->dma_address for sg->offset bigger
 than PAGE_SIZE
Message-ID: <20190312070832.GA2483@redhat.com>
References: <20190226112407.GB2989@redhat.com>
 <20190228090411.GA24938@redhat.com>
 <20190228104223.GA2749@redhat.com>
 <20190228121948.GD6072@redhat.com>
 <20190228134029.GC1594@8bytes.org>
 <20190304071037.GA2787@redhat.com>
 <CAKxU2N-k-9DCYBv6W3CohL963dr3AeY3VHyt8FrUuo=BfacDsw@mail.gmail.com>
 <20190311084319.GA3310@redhat.com>
 <20190311090314.GB3310@redhat.com>
 <e0630ae9d9bee73d8a1ce3499ea9f77900e9cdfa.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0630ae9d9bee73d8a1ce3499ea9f77900e9cdfa.camel@linux.intel.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 12 Mar 2019 07:08:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 11, 2019 at 08:47:44AM -0700, Alexander Duyck wrote:
> >  drivers/iommu/amd_iommu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> > index 6b0760dafb3e..949621f33624 100644
> > --- a/drivers/iommu/amd_iommu.c
> > +++ b/drivers/iommu/amd_iommu.c
> > @@ -2604,7 +2604,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
> >  
> >  	/* Everything is mapped - write the right values into s->dma_address */
> >  	for_each_sg(sglist, s, nelems, i) {
> > -		s->dma_address += address + s->offset;
> > +		s->dma_address += address + (s->offset & ~PAGE_MASK);
> >  		s->dma_length   = s->length;
> >  	}
> >  
> 
> You should add a comment calling out that this is needed because the
> sg_phys(s) call above this is masked with PAGE_MASK. Then this makes
> much more sense. Otherwise I would have assumed you needed either the
> full offset or none.

Would something like this 

/*
 * Everything is mapped - write the right values into s->dma_address. 
 * Take into account s->offset can be bigger than page size and sg_phys(s)
 * address has to be aligned to page granularity.
 */

be appropriate ?

Stanislaw

