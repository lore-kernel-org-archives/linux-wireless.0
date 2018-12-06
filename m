Return-Path: <SRS0=7mY+=OP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CF1C04EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 10:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2992B2082B
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 10:51:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2992B2082B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbeLFKvV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 05:51:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbeLFKvV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 05:51:21 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 263DB83F3E;
        Thu,  6 Dec 2018 10:51:21 +0000 (UTC)
Received: from localhost (unknown [10.40.205.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BD765D9CD;
        Thu,  6 Dec 2018 10:51:17 +0000 (UTC)
Date:   Thu, 6 Dec 2018 11:51:16 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] mt76: dma: add rx buffer recycle support
Message-ID: <20181206105115.GA6137@redhat.com>
References: <cover.1543846816.git.lorenzo.bianconi@redhat.com>
 <8c05c03018ca9f98047ff961028f09da2e1565d0.1543846816.git.lorenzo.bianconi@redhat.com>
 <CAJ0CqmWJHo8a_ffVguONBfYg0w4rm8QK99wqWBHY8-146YZogA@mail.gmail.com>
 <20181205141321.GB4159@redhat.com>
 <20181205151725.GA24423@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205151725.GA24423@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 06 Dec 2018 10:51:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Dec 05, 2018 at 04:17:31PM +0100, Lorenzo Bianconi wrote:
> > On Wed, Dec 05, 2018 at 11:37:33AM +0100, Lorenzo Bianconi wrote:
> > > >
> > > > Add support for recycling rx buffers if they are not forwarded
> > > > to network stack instead of reallocate them from scratch
> > > >
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > > > ---
> > > 
> > > Felix,
> > > 
> > > could you please drop this patch since it does not help to reduce pressure
> > > on page_frag_cache.
> > 
> > What is the problem ? Maybe using kmalloc() instead of page_frag_alloc()
> > could help (kmalloc has standard kmem_cache for 2048 bytes object) ?
> 
> Hi Stanislaw,
> 
> I think the only difference in using a recycle buffer with page_frag_cache is
> we are a little bit less greedy in consuming the compound page since in case of
> error we will reuse the previously allocated fragment. However we will need to
> reallocate a new compound page if we have a leftover fragment that 'locks'
> the previous compound (we have the same issue if we do not use the recycle
> buffer). Does this 'little' improvement worth a more complex code?
> Do you agree or is there something I am missing here?

I was not asking about the patch. I agree it should be droped. 

I was asking what is the problem with "pressure on page_frag_cache" and if
using kmalloc() instead of page_frag_alloc() whould be potential solution.

Regards
Stanislaw

