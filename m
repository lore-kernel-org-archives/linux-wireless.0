Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52097
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752242AbXLFCg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 21:36:29 -0500
Date: Wed, 05 Dec 2007 18:36:28 -0800 (PST)
Message-Id: <20071205.183628.211180882.davem@davemloft.net> (sfid-20071206_023633_576569_820424F5)
To: jt@hpl.hp.com
Cc: shaddy_baddah@hotmail.com, linux-wireless@vger.kernel.org,
	dsd@gentoo.org, johannes@sipsolutions.net
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071205215600.GA28349@bougret.hpl.hp.com>
References: <20071204000138.GA1363@bougret.hpl.hp.com>
	<4756AABC.3000204@hotmail.com>
	<20071205215600.GA28349@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jean Tourrilhes <jt@hpl.hp.com>
Date: Wed, 5 Dec 2007 13:56:00 -0800

> 	Personally, I was under the impression that in userspace libc
> trap unaligned access and make them work. I mean, this code was tested
> on other 64/32 bit platforms (PPC, AMD-64, PS3) and was working there,
> so this seems to be specific to your platform.

None of those listed platforms trap on unaligned accesses like sparc
does.

> 	In any case, I've modified my code to use a memcpy() instead
> of direct memory access. I'm not 100% sure it will fix it because many
> time memcpy() is optimised away to a direct memory access.

This only works if you hide the underlying types from the compiler,
using something like:

static void copy_object(void *dst, void *src, int len)
{
	memcpy(dst, src, len);
}

And use the copy_object() thing to move unaligned things around.

Otherwise gcc can see the underlying types and assume alignment, and
thus generate the memcpy inline using word sized loads and stores, and
you'll just get the same unaligned access problems.

The fix is to eliminate the unaligned data in the first place.  This
compat fixup stuff really belongs in the kernel.
