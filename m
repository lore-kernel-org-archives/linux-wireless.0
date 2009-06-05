Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wmproxy1-g27.free.fr ([212.27.42.91]:18652 "EHLO
	wmproxy1-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbZFEPEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 11:04:00 -0400
Message-ID: <1244214237.4a2933dda6634@imp.free.fr>
Date: Fri, 05 Jun 2009 17:03:57 +0200
From: castet.matthieu@free.fr
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de,
	Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: [PATCH] b43: Fix possible unaligned u32 access
References: <200906042318.33895.mb@bu3sch.de> <20090605122503.GA2791@tuxdriver.com>
In-Reply-To: <20090605122503.GA2791@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "John W. Linville" <linville@tuxdriver.com>:

> On Thu, Jun 04, 2009 at 11:18:33PM +0200, Michael Buesch wrote:
> > From: Matthieu CASTET <castet.matthieu@free.fr>
> >
> > Fix possible unaligned u32 access in b43_generate_plcp_hdr().
> > Unaligned data is read/write with a u32 pointer instead of using the
> > packed structure. Some versions of gcc ignore the "packed" attribute, if
> the
> > structure element is accessed through a local pointer.
> >
> > Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
>
> That seems pretty brain-dead...can you cite a source for this
> information?
The test I did with the attached test case in the first post.

I don't see why gcc should propagate packed structure info to assignment.
That will be impossible to handle (think of passing it to function parameter).

> The patch seems like a no-op...
At least the code produced on mips is different.


Matthieu
