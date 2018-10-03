Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27AE2C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E63602089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:22:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E63602089F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbeJCRKA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:10:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbeJCRKA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:10:00 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B41685F74B;
        Wed,  3 Oct 2018 10:22:15 +0000 (UTC)
Received: from localhost (ovpn-204-105.brq.redhat.com [10.40.204.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21FDA309136E;
        Wed,  3 Oct 2018 10:22:11 +0000 (UTC)
Date:   Wed, 3 Oct 2018 12:22:11 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mt76: make frag_cache global per cpu structure
Message-ID: <20181003102210.GD2229@redhat.com>
References: <1538558230-16576-1-git-send-email-sgruszka@redhat.com>
 <1538558230-16576-2-git-send-email-sgruszka@redhat.com>
 <20181003093853.GC27279@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003093853.GC27279@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.26
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 03 Oct 2018 10:22:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 03, 2018 at 11:38:54AM +0200, Lorenzo Bianconi wrote:
> > +static DEFINE_PER_CPU(struct page_frag_cache, mt76_frag_cache);
> > +
> > +void *mt76_alloc_frag(unsigned int fragsz)
> > +{
> > +	struct page_frag_cache *fc;
> > +	unsigned long flags;
> > +	void *data;
> > +
> > +	local_irq_save(flags);
> 
> I like this approach since we will avoid a cache miss for the spinlock :)
> Do we still need to disable local_irq here since (not considering fw upload)
> I guess there is no contention for mt76_frag_cache

I think is needed if we have more than one device, but I think we can
change to local_irq_disable() / local_irq_enable() . 

Thanks
Stanislaw 
