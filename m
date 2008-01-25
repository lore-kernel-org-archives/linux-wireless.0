Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4243 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbYAYUDl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 15:03:41 -0500
Date: Fri, 25 Jan 2008 14:48:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>, Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080125194807.GD14687@tuxdriver.com> (sfid-20080125_200356_447491_362CD8E1)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org> <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org> <200801251930.27022.mb@bu3sch.de> <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2008 at 11:07:47AM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 25 Jan 2008, Michael Buesch wrote:
> > 
> > The problem is _not_ the wireless header access, but the alignment of the embedded
> > protocol stack, if the header does not have a size aligned to 4.
> > Do we want to clutter the whole networking stack below wireless with
> > get_unaligned() or attribute(packed) or something like that?
> 
> That's what all the other protocols do, isn't it?
> 
> For example, on PowerPC, NET_IP_ALIGN is 0 - explicitly so that the *dma* 
> from the card should be aligned, even if that in turn means that the IP 
> payload itself is then just two-byte aligned rather than word-aligned 
> (14-byte ethernet headers and all that).

http://kerneltrap.org/mailarchive/linux-netdev/2007/11/24/442496

Quoth Herbert Xu:

"OK.  Let me clarify this a bit more.  We require at least one
of the following rules to be met:

* the IPv4/IPv6 header is aligned by 8 bytes on reception;
* or the platform provides unaligned exception handlers.

So if your platform violates both rules then it won't work with
the IP stack, simple as that.  Fortunately I don't think such a
platform exists currently on Linux."

That puts mac80211 in an awkward position.  It is not architecture
code, so it can't make any assumptions about what is or isn't OK.
So, we need to present aligned data to the network stack.

We could put the alignment onus on mac80211, but this has proven to be
very solvable at (near?) zero cost by all the other drivers.  I suppose
we could put code in mac80211 to check/correct the alignment anyway
and hope that the cost of such checking is small enough not to matter
as long as drivers are passing aligned data anyway.  But that seems
a bit silly, when at least so far only this one driver has balked at
doing the right thing.

I'm working on some iwlwifi patches to check/correct alignment.

(Hmmm..."aligned by 8 bytes", so our warning and my iwlwifi patch
may still not be right...)

John
-- 
John W. Linville
linville@tuxdriver.com
