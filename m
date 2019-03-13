Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EB7C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 12:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D30C214AE
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 12:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfCMM7V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 08:59:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfCMM7V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 08:59:21 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A04E23168594;
        Wed, 13 Mar 2019 12:59:21 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A7995D75D;
        Wed, 13 Mar 2019 12:59:18 +0000 (UTC)
Date:   Wed, 13 Mar 2019 13:59:16 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC 11/12] mt76usb: allocate urb and sg as linear data
Message-ID: <20190313125916.GC2003@redhat.com>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
 <1552403166-3821-12-git-send-email-sgruszka@redhat.com>
 <20190312163431.GF2611@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190312163431.GF2611@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 13 Mar 2019 12:59:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 12, 2019 at 05:34:32PM +0100, Lorenzo Bianconi wrote:
> > Alloc sg table at the end of urb structure. This will increase
> > cache usage.
> > 
> 
> I am curious, have you observed any performance improvement doing so?

It's hard to measure that. Stressing net transfer with about 175 Mbit/s
by netperf (what is max I can get) only took about 15% of CPU for me
and net performance fluctuate so CPU pref stats vary too.

> > -	if (dev->usb.sg_en) {
> > -		urb->sg = devm_kcalloc(dev->dev, MT_SG_MAX_SIZE,
> > -				       sizeof(urb->sg), GFP_KERNEL);
FTR: Here is bug it should be sizeof(*urb->sg).

> > -		if (!urb->sg)
> > -			return -ENOMEM;
> > -	}
> > +	usb_init_urb(e->urb);
> > +
> > +	if (dev->usb.sg_en)
> > +		e->urb->sg = (struct scatterlist *)((u8 *)e->urb + sizeof(struct urb));
> 
> You can avoid u8 cast doing:
> (struct scatterlist *)(e->urb + 1)
Cool trick!

Stanislaw

