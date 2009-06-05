Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38954 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZFETAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 15:00:34 -0400
Date: Fri, 5 Jun 2009 14:53:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: castet.matthieu@free.fr
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Fix possible unaligned u32 access
Message-ID: <20090605185307.GB7361@tuxdriver.com>
References: <200906042318.33895.mb@bu3sch.de> <20090605122503.GA2791@tuxdriver.com> <1244214237.4a2933dda6634@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244214237.4a2933dda6634@imp.free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 05, 2009 at 05:03:57PM +0200, castet.matthieu@free.fr wrote:
> Quoting "John W. Linville" <linville@tuxdriver.com>:
> 
> > On Thu, Jun 04, 2009 at 11:18:33PM +0200, Michael Buesch wrote:
> > > From: Matthieu CASTET <castet.matthieu@free.fr>
> > >
> > > Fix possible unaligned u32 access in b43_generate_plcp_hdr().
> > > Unaligned data is read/write with a u32 pointer instead of using the
> > > packed structure. Some versions of gcc ignore the "packed" attribute, if
> > the
> > > structure element is accessed through a local pointer.
> > >
> > > Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> > > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> >
> > That seems pretty brain-dead...can you cite a source for this
> > information?
> The test I did with the attached test case in the first post.

Link?

> I don't see why gcc should propagate packed structure info to assignment.
> That will be impossible to handle (think of passing it to function parameter).

Perhaps this is obvious to you, but it isn't to me.

> 
> > The patch seems like a no-op...
> At least the code produced on mips is different.

Then why aren't you trying to get the mips gcc guys to fix it?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
