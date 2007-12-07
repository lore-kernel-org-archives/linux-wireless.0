Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40672
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753180AbXLGDwP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 22:52:15 -0500
Date: Thu, 06 Dec 2007 19:52:14 -0800 (PST)
Message-Id: <20071206.195214.09557695.davem@davemloft.net> (sfid-20071207_035218_258052_49A6DA3A)
To: jt@hpl.hp.com
Cc: mb@bu3sch.de, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org,
	johannes@sipsolutions.net
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071206214341.GA6821@bougret.hpl.hp.com>
References: <20071206212525.GA6509@bougret.hpl.hp.com>
	<200712062233.18634.mb@bu3sch.de>
	<20071206214341.GA6821@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jean Tourrilhes <jt@hpl.hp.com>
Date: Thu, 6 Dec 2007 13:43:41 -0800

> On Thu, Dec 06, 2007 at 10:33:18PM +0100, Michael Buesch wrote:
> > Userspace handles this transparently through fault traps.
> 
> 	This is exactly what I was assuming. On the SPARC, in this
> instance, it did not (check back earlier in this discussion).

Right, you get a SIGBUS, and this is what will happen on
MIPS as well.

It is even defined in the application ABIs for these platforms that
all objects must be aligned to their type's natural size.
