Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:2033 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbXBJTWb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Feb 2007 14:22:31 -0500
Subject: Re: [PATCH] zd1211rw: Readd zd_addr_t cast
From: Joe Perches <joe@perches.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Daniel Drake <dsd@gentoo.org>, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	kune@deine-taler.de, rpjday@mindspring.com
In-Reply-To: <200702100702.15264.mb@bu3sch.de>
References: <20070210012718.3B6E87B409F@zog.reactivated.net>
	 <200702100702.15264.mb@bu3sch.de>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 10:51:37 -0800
Message-Id: <1171133498.20342.59.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-02-10 at 07:02 +0100, Michael Buesch wrote:
> On Saturday 10 February 2007 02:27, Daniel Drake wrote:
> > Robert P.J. Day's recent commit ("getting rid of all casts of k[cmz]alloc()
> > calls") introduced a sparse warning for zd1211rw, related to our type-checking
> > of addresses.
> > > 	zd_chip.c:116:15: warning: implicit cast to nocast type
> > This patch readds the type cast, it is correct.
> > Signed-off-by: Daniel Drake <dsd@gentoo.org>
> > Index: linux/drivers/net/wireless/zd1211rw/zd_chip.c
> > ===================================================================
> > --- linux.orig/drivers/net/wireless/zd1211rw/zd_chip.c
> > +++ linux/drivers/net/wireless/zd1211rw/zd_chip.c
> > @@ -113,7 +113,7 @@ int zd_ioread32v_locked(struct zd_chip *
> >  
> >  	/* Allocate a single memory block for values and addresses. */
> >  	count16 = 2*count;
> > -	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
> > +	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
> >  		                   GFP_NOFS);

I think it better to remove this __nocast instead.
This is the only use of __nocast outside of kmem in the kernel tree.

Why not just remove __nocast and use u16 instead of zd_addr_t?

If not the removal of the __nocast, would it be better to have a
void pointer there?

	tmp = kcalloc(count16, sizeof(zd_addr_t) + sizeof(u16), GFP_KERNEL);
	[]
	a16 = (zd_addr_t *)tmp;
	v16 = a16 + count16;
	[]
	kfree(tmp);

