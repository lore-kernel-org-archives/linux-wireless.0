Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94622C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EA082054F
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfCLPSS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:18:18 -0400
Received: from mga05.intel.com ([192.55.52.43]:41020 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfCLPSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 11:18:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 08:18:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,471,1544515200"; 
   d="scan'208";a="133430143"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga003.jf.intel.com with ESMTP; 12 Mar 2019 08:18:16 -0700
Message-ID: <67c062b183fbd5651a9aa990e677d31673ff7580.camel@linux.intel.com>
Subject: Re: [PATCH] iommu/amd: fix sg->dma_address for sg->offset bigger
 than PAGE_SIZE
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Rosen Penev <rosenp@gmail.com>, Joerg Roedel <joro@8bytes.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, jan.viktorin@gmail.com
Date:   Tue, 12 Mar 2019 08:18:16 -0700
In-Reply-To: <20190312070832.GA2483@redhat.com>
References: <20190226112407.GB2989@redhat.com>
         <20190228090411.GA24938@redhat.com> <20190228104223.GA2749@redhat.com>
         <20190228121948.GD6072@redhat.com> <20190228134029.GC1594@8bytes.org>
         <20190304071037.GA2787@redhat.com>
         <CAKxU2N-k-9DCYBv6W3CohL963dr3AeY3VHyt8FrUuo=BfacDsw@mail.gmail.com>
         <20190311084319.GA3310@redhat.com> <20190311090314.GB3310@redhat.com>
         <e0630ae9d9bee73d8a1ce3499ea9f77900e9cdfa.camel@linux.intel.com>
         <20190312070832.GA2483@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-03-12 at 08:08 +0100, Stanislaw Gruszka wrote:
> On Mon, Mar 11, 2019 at 08:47:44AM -0700, Alexander Duyck wrote:
> > >  drivers/iommu/amd_iommu.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> > > index 6b0760dafb3e..949621f33624 100644
> > > --- a/drivers/iommu/amd_iommu.c
> > > +++ b/drivers/iommu/amd_iommu.c
> > > @@ -2604,7 +2604,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
> > >  
> > >  	/* Everything is mapped - write the right values into s->dma_address */
> > >  	for_each_sg(sglist, s, nelems, i) {
> > > -		s->dma_address += address + s->offset;
> > > +		s->dma_address += address + (s->offset & ~PAGE_MASK);
> > >  		s->dma_length   = s->length;
> > >  	}
> > >  
> > 
> > You should add a comment calling out that this is needed because the
> > sg_phys(s) call above this is masked with PAGE_MASK. Then this makes
> > much more sense. Otherwise I would have assumed you needed either the
> > full offset or none.
> 
> Would something like this 
> 
> /*
>  * Everything is mapped - write the right values into s->dma_address. 
>  * Take into account s->offset can be bigger than page size and sg_phys(s)
>  * address has to be aligned to page granularity.
>  */
> 
> be appropriate ?
> 
> Stanislaw
> 

No, that isn't a good description. If you take a look at the code a few
lines up you find:
	phys_addr = (sg_phys(s) & PAGE_MASK) + (j << PAGE_SHIFT);

Now if I am not mistaken the whole reason why you are having to make
the change here is because the application of PAGE_MASK in this line.
Basically what sg_phys() will do is take the address of the page,
convert it to a physical address and add the offset. However what the
mask is doing is limiting how much of that offset can be added. As a
result you have to add the remainder that was masked out. So maybe a
better comment would be something like:

/*
 * Add in the remaining piece of the scatter-gather offset that was 
 * masked out when we were determining the physical address via
 * (sg_phys(s) & PAGE_MASK) earlier.
 */



