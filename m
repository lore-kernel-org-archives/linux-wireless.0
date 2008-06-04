Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2102 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581AbYFDR6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 13:58:32 -0400
Date: Wed, 4 Jun 2008 13:34:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, kirill@shutemov.name
Subject: Re: [PATCH] wireless.h: improve userland include-ability
Message-ID: <20080604173439.GB18119@tuxdriver.com> (sfid-20080604_195836_429811_50E53DB9)
References: <1212515497-21578-1-git-send-email-linville@tuxdriver.com> <20080603.120515.193703574.davem@davemloft.net> <1212587529.32207.82.camel@pmac.infradead.org> <1212593055.13964.15.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1212593055.13964.15.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 04, 2008 at 11:24:15AM -0400, Pavel Roskin wrote:
> On Wed, 2008-06-04 at 14:52 +0100, David Woodhouse wrote:

> > We've traditionally got away with saying 'caveat emptor' when userspace
> > includes kernel headers -- you _have_ to include the right
> > prerequisites, because the kernel doesn't do it for you.
> 
> That's true, and several programs do it already.  Changing the includes
> would require changes in those programs.  Besides, sys/types.h is still
> included, so it's a half-measure.  If we are going to break things,
> let's go all the way and disable sys/types.h for userspace, and possibly
> some structures that the userspace is not supposed to be using.  But I'm

...which is how it is in 2.6.25.  The change in 2.6.26 broke userland
apps that included both net/if.h and linux/wireless.h.  The intent
here was to correct that error while gaining the primary benefit of
not requiring separate inclusion of linux/types.h.

If commit 2218228392080f0ca2fc2974604e79f57b12c436 had never
occured, then this new patch would simply be similar to
commit c8942f1f0a7e2160ebf2e51ba89e50ee5895a1e7 and commit
a1a61a435b3cc157830b7d42b175151ae5eabdd3 (both of which are
Signed-off-by: David S. Miller <davem@davemloft.net>), and it is very
similar to commit 80a9492a33dd7d852465625022d56ff76d62174d as well.

> afraid there is still a lot of stuff the userspace should know,
> including IFNAMESIZ.  Alternatively, let's sanitize other headers so
> that they can be mixed with libc headers with no consequences.

Patches welcome.

John
-- 
John W. Linville
linville@tuxdriver.com
