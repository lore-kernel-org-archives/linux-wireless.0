Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48540
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752944AbXLGDtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 22:49:39 -0500
Date: Thu, 06 Dec 2007 19:49:38 -0800 (PST)
Message-Id: <20071206.194938.180887974.davem@davemloft.net> (sfid-20071207_034942_820757_6544C501)
To: jt@hpl.hp.com
Cc: shaddy_baddah@hotmail.com, linux-wireless@vger.kernel.org,
	dsd@gentoo.org, johannes@sipsolutions.net
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071206212525.GA6509@bougret.hpl.hp.com>
References: <20071205215600.GA28349@bougret.hpl.hp.com>
	<20071205.183628.211180882.davem@davemloft.net>
	<20071206212525.GA6509@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jean Tourrilhes <jt@hpl.hp.com>
Date: Thu, 6 Dec 2007 13:25:25 -0800

> On Wed, Dec 05, 2007 at 06:36:28PM -0800, David Miller wrote:
> > This only works if you hide the underlying types from the compiler,
> > using something like:
> > 
> > static void copy_object(void *dst, void *src, int len)
> > {
> > 	memcpy(dst, src, len);
> > }
> > 
> > And use the copy_object() thing to move unaligned things around.
> 
> 	Most likely, copy_object() will be inlined.

It doesn't matter, by passing the pointer through the arguments of a
function you've casted the type to "void *" before the builtin
memcpy() logic in the compiler can look at it, and thus the compiler
is no longer allowed to see past that cast back to the original type
and assume any kind of alignment.

I used this to fix similar bugs in libgtk+ and gthumb.

> 	Now, I'm wondering how to deal with unaligned access in
> userspace. If you get data from hardware or the network, you can not
> guarantee that everything will always be aligned, so we need a way to
> deal with it.
> 	In the kernel, we have get_unaligned(). I wonder what's the
> equivalent in userspace.

attribute((__packed__)) usually

Better to enforce the alignment in the kernel though.  We recently
found a case with link attributes in netlink where u64 attributes end
up unaligned in userspace because of how we size the netlink attribute
headers and the total attribute lengths.  So we have to use __packed__
for these things now.

And you _DONT_ want to do this, because the code generated is
completely awful.  It does byte at a time accesses for every access
and this is completely silly if the data is aligned most of the time.

So, again, better to put the onus on the kernel or whatever parses the
data to align things properly.

I totally disagree about your assertions about iwlib BTW, anybody
should be able to write code to parse these blobs coming out of the
kernel.  Saying that everyone who wants to do so has to go through
iwlib is unreasonable.

If the kernel was converting the data streams correctly, we wouldn't
even having this conversation.  And it really ticks me off that you
keep ignoring this point.  If it had been done correctly from the
start, we'd have none of this compat code in iwlib, and none of these
problems.

But it's OK that we didn't fix it correctly at first, what is not
OK is refusing to recognize that the kernel does need to do these
conversions so we can fix this properly.

I think I'm finally angry enough about this to do the implementation
so expect to see some code soon...
