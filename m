Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42226 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZFER3R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 13:29:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] b43: Fix possible unaligned u32 access
Date: Fri, 5 Jun 2009 19:29:07 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Matthieu CASTET <castet.matthieu@free.fr>
References: <200906042318.33895.mb@bu3sch.de> <20090605122503.GA2791@tuxdriver.com>
In-Reply-To: <20090605122503.GA2791@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200906051929.07714.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 05 June 2009 14:25:03 John W. Linville wrote:
> On Thu, Jun 04, 2009 at 11:18:33PM +0200, Michael Buesch wrote:
> > From: Matthieu CASTET <castet.matthieu@free.fr>
> > 
> > Fix possible unaligned u32 access in b43_generate_plcp_hdr().
> > Unaligned data is read/write with a u32 pointer instead of using the
> > packed structure. Some versions of gcc ignore the "packed" attribute, if the
> > structure element is accessed through a local pointer.
> > 
> > Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> That seems pretty brain-dead...can you cite a source for this
> information?  The patch seems like a no-op...
> 
> John

struct foo {
	int data;
} __attribute__((packed));

struct foo foo;
int *d = &foo->data;
foo->data = x;	/* Works for unaligned */
*d = y;		/* Does not work for unaligned */

-- 
Greetings, Michael.
