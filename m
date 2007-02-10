Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45235
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbXBJGCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Feb 2007 01:02:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] zd1211rw: Readd zd_addr_t cast
Date: Sat, 10 Feb 2007 07:02:14 +0100
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, kune@deine-taler.de,
	rpjday@mindspring.com
References: <20070210012718.3B6E87B409F@zog.reactivated.net>
In-Reply-To: <20070210012718.3B6E87B409F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200702100702.15264.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 10 February 2007 02:27, Daniel Drake wrote:
> Robert P.J. Day's recent commit ("getting rid of all casts of k[cmz]alloc()
> calls") introduced a sparse warning for zd1211rw, related to our type-checking
> of addresses.
> 
> 	zd_chip.c:116:15: warning: implicit cast to nocast type
> 
> This patch readds the type cast, it is correct.
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>
> 
> Index: linux/drivers/net/wireless/zd1211rw/zd_chip.c
> ===================================================================
> --- linux.orig/drivers/net/wireless/zd1211rw/zd_chip.c
> +++ linux/drivers/net/wireless/zd1211rw/zd_chip.c
> @@ -113,7 +113,7 @@ int zd_ioread32v_locked(struct zd_chip *
>  
>  	/* Allocate a single memory block for values and addresses. */
>  	count16 = 2*count;
> -	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
> +	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
>  		                   GFP_NOFS);

Unrelated, but I am wondering since quite some time why you pass GFP_NOFS here.
Any special reason? I think in general there is no good reason for code outside
of the VFS to use this flag.
IMHO you should pass either GFP_ATOMIC or GFP_KERNEL.
