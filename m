Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CADC04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 14:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B44842084C
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 14:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B44842084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbeLEON2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:13:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbeLEON1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 09:13:27 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF5EB307D85E;
        Wed,  5 Dec 2018 14:13:27 +0000 (UTC)
Received: from localhost (unknown [10.40.205.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2FB85C88D;
        Wed,  5 Dec 2018 14:13:23 +0000 (UTC)
Date:   Wed, 5 Dec 2018 15:13:22 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] mt76: dma: add rx buffer recycle support
Message-ID: <20181205141321.GB4159@redhat.com>
References: <cover.1543846816.git.lorenzo.bianconi@redhat.com>
 <8c05c03018ca9f98047ff961028f09da2e1565d0.1543846816.git.lorenzo.bianconi@redhat.com>
 <CAJ0CqmWJHo8a_ffVguONBfYg0w4rm8QK99wqWBHY8-146YZogA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0CqmWJHo8a_ffVguONBfYg0w4rm8QK99wqWBHY8-146YZogA@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 05 Dec 2018 14:13:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Dec 05, 2018 at 11:37:33AM +0100, Lorenzo Bianconi wrote:
> >
> > Add support for recycling rx buffers if they are not forwarded
> > to network stack instead of reallocate them from scratch
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > ---
> 
> Felix,
> 
> could you please drop this patch since it does not help to reduce pressure
> on page_frag_cache.

What is the problem ? Maybe using kmalloc() instead of page_frag_alloc()
could help (kmalloc has standard kmem_cache for 2048 bytes object) ?

Thanks
Stanislaw
