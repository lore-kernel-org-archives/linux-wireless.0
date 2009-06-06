Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42869
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749AbZFFBAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 21:00:10 -0400
Date: Fri, 05 Jun 2009 18:00:11 -0700 (PDT)
Message-Id: <20090605.180011.218685961.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: mb@bu3sch.de, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, castet.matthieu@free.fr
Subject: Re: [PATCH] b43: Fix possible unaligned u32 access
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090605122503.GA2791@tuxdriver.com>
References: <200906042318.33895.mb@bu3sch.de>
	<20090605122503.GA2791@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 5 Jun 2009 08:25:03 -0400

> On Thu, Jun 04, 2009 at 11:18:33PM +0200, Michael Buesch wrote:
>> From: Matthieu CASTET <castet.matthieu@free.fr>
>> 
>> Fix possible unaligned u32 access in b43_generate_plcp_hdr().
>> Unaligned data is read/write with a u32 pointer instead of using the
>> packed structure. Some versions of gcc ignore the "packed" attribute, if the
>> structure element is accessed through a local pointer.
>> 
>> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
>> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> That seems pretty brain-dead...can you cite a source for this
> information?  The patch seems like a no-op...

The "packed" attribute simply doesn't propagate.  It isn't
a GCC bug.  Look at this:

struct foo {
	u32 x;
} attribute((packed));

u32 bar(struct foo *p)
{
	u32 *p = &p->x;

	return *p;
}

That will (correctly) do a 32-bit aligned load, only doing
the "return p->x;" will proply respect the packed attribute.
