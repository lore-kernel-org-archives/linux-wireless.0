Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D955DC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 10:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B37A32082F
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 10:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfCRKRG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 06:17:06 -0400
Received: from 8bytes.org ([81.169.241.247]:58202 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfCRKRG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 06:17:06 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id D489D327; Mon, 18 Mar 2019 11:17:04 +0100 (CET)
Date:   Mon, 18 Mar 2019 11:17:03 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Rosen Penev <rosenp@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, jan.viktorin@gmail.com
Subject: Re: [PATCH v2] iommu/amd: fix sg->dma_address for sg->offset bigger
 than PAGE_SIZE
Message-ID: <20190318101703.GA6100@8bytes.org>
References: <20190228121948.GD6072@redhat.com>
 <20190228134029.GC1594@8bytes.org>
 <20190304071037.GA2787@redhat.com>
 <CAKxU2N-k-9DCYBv6W3CohL963dr3AeY3VHyt8FrUuo=BfacDsw@mail.gmail.com>
 <20190311084319.GA3310@redhat.com>
 <20190311090314.GB3310@redhat.com>
 <e0630ae9d9bee73d8a1ce3499ea9f77900e9cdfa.camel@linux.intel.com>
 <20190312070832.GA2483@redhat.com>
 <67c062b183fbd5651a9aa990e677d31673ff7580.camel@linux.intel.com>
 <20190313090316.GA2663@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190313090316.GA2663@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Stanislaw,

thanks a lot for looking into this and tracking it down!

On Wed, Mar 13, 2019 at 10:03:17AM +0100, Stanislaw Gruszka wrote:
> -		s->dma_address += address + s->offset;
> +		/* Add in the remaining piece of the scatter-gather offset that
> +		 * was masked out when we were determining the physical address
> +		 * via (sg_phys(s) & PAGE_MASK) earlier.
> +		 */
> +		s->dma_address += address + (s->offset & ~PAGE_MASK);
>  		s->dma_length   = s->length;

Applied the patch for v5.1 (with an added Fixes-tag and a minor coding
style change) and will send it upstream soon.

Thanks again,

       Joerg
