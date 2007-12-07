Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48548
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbXLGDuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 22:50:25 -0500
Date: Thu, 06 Dec 2007 19:50:24 -0800 (PST)
Message-Id: <20071206.195024.42638255.davem@davemloft.net> (sfid-20071207_035027_488000_AB5C8A51)
To: mb@bu3sch.de
Cc: jt@hpl.hp.com, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org,
	johannes@sipsolutions.net
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200712062233.18634.mb@bu3sch.de>
References: <20071205.183628.211180882.davem@davemloft.net>
	<20071206212525.GA6509@bougret.hpl.hp.com>
	<200712062233.18634.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Buesch <mb@bu3sch.de>
Date: Thu, 6 Dec 2007 22:33:18 +0100

> On Thursday 06 December 2007 22:25:25 Jean Tourrilhes wrote:
> > On Wed, Dec 05, 2007 at 06:36:28PM -0800, David Miller wrote:
> > 	Now, I'm wondering how to deal with unaligned access in
> > userspace. If you get data from hardware or the network, you can not
> > guarantee that everything will always be aligned, so we need a way to
> > deal with it.
> > 	In the kernel, we have get_unaligned(). I wonder what's the
> > equivalent in userspace.
> 
> Userspace handles this transparently through fault traps.

It does not, the process gets a SIGBUS.
