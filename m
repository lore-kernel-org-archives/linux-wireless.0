Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:50299 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbXLFV0z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 16:26:55 -0500
Date: Thu, 6 Dec 2007 13:25:25 -0800
To: David Miller <davem@davemloft.net>
Cc: shaddy_baddah@hotmail.com, linux-wireless@vger.kernel.org,
	dsd@gentoo.org, johannes@sipsolutions.net
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071206212525.GA6509@bougret.hpl.hp.com> (sfid-20071206_212703_868416_C5707324)
Reply-To: jt@hpl.hp.com
References: <20071204000138.GA1363@bougret.hpl.hp.com> <4756AABC.3000204@hotmail.com> <20071205215600.GA28349@bougret.hpl.hp.com> <20071205.183628.211180882.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071205.183628.211180882.davem@davemloft.net>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 05, 2007 at 06:36:28PM -0800, David Miller wrote:
> From: Jean Tourrilhes <jt@hpl.hp.com>
> Date: Wed, 5 Dec 2007 13:56:00 -0800
> 
> > 	Personally, I was under the impression that in userspace libc
> > trap unaligned access and make them work. I mean, this code was tested
> > on other 64/32 bit platforms (PPC, AMD-64, PS3) and was working there,
> > so this seems to be specific to your platform.
> 
> None of those listed platforms trap on unaligned accesses like sparc
> does.

	I knew it was a problem in kernel space, and this is why we
have nice macros to perform unaligned access. My assumption that
userspace was behaving differently, and that all this stuff was hidden
from the end user through some trap handler.

> > 	In any case, I've modified my code to use a memcpy() instead
> > of direct memory access. I'm not 100% sure it will fix it because many
> > time memcpy() is optimised away to a direct memory access.
> 
> This only works if you hide the underlying types from the compiler,
> using something like:
> 
> static void copy_object(void *dst, void *src, int len)
> {
> 	memcpy(dst, src, len);
> }
> 
> And use the copy_object() thing to move unaligned things around.

	Most likely, copy_object() will be inlined.

> Otherwise gcc can see the underlying types and assume alignment, and
> thus generate the memcpy inline using word sized loads and stores, and
> you'll just get the same unaligned access problems.

	Well, it seems that the memcpy() did the trick. I guess that
the gcc optimiser is smart enough to recognise the fact that the
pointers may be unaligned.
	I don't like being at the mercy of gcc, so I'll fix that
better.

> The fix is to eliminate the unaligned data in the first place.  This
> compat fixup stuff really belongs in the kernel.

	If people were using the kernel API directly and not using
iwlib, I would agree 100% with you.
	My long term plan is to fix the problem at the source,
i.e. always generate the data with the proper alignement regardless of
32 or 64 bits, so that you don't need any "fix" in the compat layer or
in userspace. Unfortunately, it's too early for that.


	Now, I'm wondering how to deal with unaligned access in
userspace. If you get data from hardware or the network, you can not
guarantee that everything will always be aligned, so we need a way to
deal with it.
	In the kernel, we have get_unaligned(). I wonder what's the
equivalent in userspace.

	Have fun...

	Jean
