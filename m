Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:50964 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXLFVfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 16:35:13 -0500
From: Michael Buesch <mb@bu3sch.de>
To: jt@hpl.hp.com
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Date: Thu, 6 Dec 2007 22:33:18 +0100
Cc: David Miller <davem@davemloft.net>, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org,
	johannes@sipsolutions.net
References: <20071204000138.GA1363@bougret.hpl.hp.com> <20071205.183628.211180882.davem@davemloft.net> <20071206212525.GA6509@bougret.hpl.hp.com>
In-Reply-To: <20071206212525.GA6509@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712062233.18634.mb@bu3sch.de> (sfid-20071206_213518_097567_2000A724)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 December 2007 22:25:25 Jean Tourrilhes wrote:
> On Wed, Dec 05, 2007 at 06:36:28PM -0800, David Miller wrote:
> > From: Jean Tourrilhes <jt@hpl.hp.com>
> > Date: Wed, 5 Dec 2007 13:56:00 -0800
> > 
> > > 	Personally, I was under the impression that in userspace libc
> > > trap unaligned access and make them work. I mean, this code was tested
> > > on other 64/32 bit platforms (PPC, AMD-64, PS3) and was working there,
> > > so this seems to be specific to your platform.
> > 
> > None of those listed platforms trap on unaligned accesses like sparc
> > does.
> 

> 	Now, I'm wondering how to deal with unaligned access in
> userspace. If you get data from hardware or the network, you can not
> guarantee that everything will always be aligned, so we need a way to
> deal with it.
> 	In the kernel, we have get_unaligned(). I wonder what's the
> equivalent in userspace.

Userspace handles this transparently through fault traps.

-- 
Greetings Michael.
