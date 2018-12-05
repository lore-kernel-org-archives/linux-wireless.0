Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19387C04EBF
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 15:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD5AC2082D
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 15:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD5AC2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbeLEPRh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 10:17:37 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42835 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbeLEPRg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 10:17:36 -0500
Received: by mail-wr1-f68.google.com with SMTP id q18so20063642wrx.9
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2018 07:17:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ttISENY37qqkNdeby6ttQ7Ae131RO7/ClqyRO9ON/e4=;
        b=cHHP/wtd7dkjLEuRQYtT4BmsYtYdnv3QRDFjBFNpI1vlaUm17vqzJvaTQyhpvtZHjU
         8mrWqhtX2RNzgRO9LVyh/J8cBOG680kNVkK6P2I2LSWx0d7zPTjvMxG15MWz8U7HepsV
         5tCr1aNkDfSdq+l1KSQIoGYLwNjf4HYpGQ+4sTGVq6CDUs40PlXZYHkHB4BcfJeBw/fG
         CcCUsfPmn6GUamF9wxqmcOdMEosnN1gwRABXXE0CxKneO4dixHcakRpqfPLFQx6xElAX
         thFO9ie/uvvadg5ihBTdw3aI2nOk4ZBheApGf4OBmrWRcnwgvscMcn4d81ZXV/5OGk6X
         YR8Q==
X-Gm-Message-State: AA+aEWa9UPGwJA3gPFQTX9O0ERe2qety/z/bkr0p9ZMNy2OfdlAefUvK
        XJwuDBaxgNZHuIFxaGuEwvfgXCMiK+s=
X-Google-Smtp-Source: AFSGD/V3PnpKwkTiUPpzMszanPXPmPRq4BvWJBdHEI6EaR2T2w2iV/3UJ8C3Kzie5WpCf70+6dzqXQ==
X-Received: by 2002:adf:9b11:: with SMTP id b17mr22464402wrc.168.1544023054414;
        Wed, 05 Dec 2018 07:17:34 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e130sm31783968wmf.25.2018.12.05.07.17.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Dec 2018 07:17:33 -0800 (PST)
Date:   Wed, 5 Dec 2018 16:17:31 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] mt76: dma: add rx buffer recycle support
Message-ID: <20181205151725.GA24423@localhost.localdomain>
References: <cover.1543846816.git.lorenzo.bianconi@redhat.com>
 <8c05c03018ca9f98047ff961028f09da2e1565d0.1543846816.git.lorenzo.bianconi@redhat.com>
 <CAJ0CqmWJHo8a_ffVguONBfYg0w4rm8QK99wqWBHY8-146YZogA@mail.gmail.com>
 <20181205141321.GB4159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205141321.GB4159@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Wed, Dec 05, 2018 at 11:37:33AM +0100, Lorenzo Bianconi wrote:
> > >
> > > Add support for recycling rx buffers if they are not forwarded
> > > to network stack instead of reallocate them from scratch
> > >
> > > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > > ---
> > 
> > Felix,
> > 
> > could you please drop this patch since it does not help to reduce pressure
> > on page_frag_cache.
> 
> What is the problem ? Maybe using kmalloc() instead of page_frag_alloc()
> could help (kmalloc has standard kmem_cache for 2048 bytes object) ?

Hi Stanislaw,

I think the only difference in using a recycle buffer with page_frag_cache is
we are a little bit less greedy in consuming the compound page since in case of
error we will reuse the previously allocated fragment. However we will need to
reallocate a new compound page if we have a leftover fragment that 'locks'
the previous compound (we have the same issue if we do not use the recycle
buffer). Does this 'little' improvement worth a more complex code?
Do you agree or is there something I am missing here?

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
