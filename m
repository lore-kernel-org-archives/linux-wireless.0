Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50055
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044AbZFFBDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 21:03:14 -0400
Date: Fri, 05 Jun 2009 18:03:15 -0700 (PDT)
Message-Id: <20090605.180315.214694902.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: mb@bu3sch.de, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, castet.matthieu@free.fr
Subject: Re: [PATCH] b43: Fix possible unaligned u32 access
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090605185047.GA7361@tuxdriver.com>
References: <20090605122503.GA2791@tuxdriver.com>
	<200906051929.07714.mb@bu3sch.de>
	<20090605185047.GA7361@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 5 Jun 2009 14:50:48 -0400

> On Fri, Jun 05, 2009 at 07:29:07PM +0200, Michael Buesch wrote:
>> On Friday 05 June 2009 14:25:03 John W. Linville wrote:
>> > On Thu, Jun 04, 2009 at 11:18:33PM +0200, Michael Buesch wrote:
>> > > From: Matthieu CASTET <castet.matthieu@free.fr>
>> > > 
>> > > Fix possible unaligned u32 access in b43_generate_plcp_hdr().
>> > > Unaligned data is read/write with a u32 pointer instead of using the
>> > > packed structure. Some versions of gcc ignore the "packed" attribute, if the
>> > > structure element is accessed through a local pointer.
>> > > 
>> > > Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
>> > > Signed-off-by: Michael Buesch <mb@bu3sch.de>
>> > 
>> > That seems pretty brain-dead...can you cite a source for this
>> > information?  The patch seems like a no-op...
>> > 
>> > John
>> 
>> struct foo {
>> 	int data;
>> } __attribute__((packed));
>> 
>> struct foo foo;
>> int *d = &foo->data;
>> foo->data = x;	/* Works for unaligned */
>> *d = y;		/* Does not work for unaligned */
> 
> Why not?

Because "int *" does not have the packed attribute.
