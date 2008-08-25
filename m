Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3351 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbYHYTUi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 15:20:38 -0400
Date: Mon, 25 Aug 2008 15:08:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: ath5k: bad udelay call, build failure on ARM
Message-ID: <20080825190811.GC17297@tuxdriver.com> (sfid-20080825_212042_043277_EB123033)
References: <20080825115715.GA13506@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080825115715.GA13506@deprecation.cyrius.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 25, 2008 at 02:57:15PM +0300, Martin Michlmayr wrote:
> ath5k fails to build on ARM with:
> 
> __bad_udelay is specifically designed on ARM to fail when udelay is
> called in a bad way.  arch/arm/include/asm/delay.h has this to say
> about __bad_udelay:
> 
> /*
>  * This function intentionally does not exist; if you see references to
>  * it, it means that you're calling udelay() with an out of range value.
>  *
>  * With currently imposed limits, this means that we support a max delay
>  * of 2000us. Further limits: HZ<=1000 and bogomips<=3355
>  */
> extern void __bad_udelay(void);
> 
> Can you check why your driver is calling udelay() with a value > 2000?

There are "udelay(2300)" calls in phy.c and hw.c.  How important is
that exact number?  Could those be replaced by mdelay(3) instead?

Of course, looking in include/linux/delay.h, mdelay(3) may still
translate to __bad_udelay on arm.  It would be nice if the ARM guys
and delay.h could at least agree on the maximum value allowed to be
passed to udelay...

John
-- 
John W. Linville
linville@tuxdriver.com
