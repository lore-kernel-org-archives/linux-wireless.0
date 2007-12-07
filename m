Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:58621 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbXLGLgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 06:36:53 -0500
From: Michael Buesch <mb@bu3sch.de>
To: David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Date: Fri, 7 Dec 2007 12:35:11 +0100
Cc: jt@hpl.hp.com, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org,
	johannes@sipsolutions.net
References: <20071206212525.GA6509@bougret.hpl.hp.com> <20071206214341.GA6821@bougret.hpl.hp.com> <20071206.195214.09557695.davem@davemloft.net>
In-Reply-To: <20071206.195214.09557695.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712071235.11969.mb@bu3sch.de> (sfid-20071207_113706_910393_C8A904DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 December 2007 04:52:14 David Miller wrote:
> From: Jean Tourrilhes <jt@hpl.hp.com>
> Date: Thu, 6 Dec 2007 13:43:41 -0800
> 
> > On Thu, Dec 06, 2007 at 10:33:18PM +0100, Michael Buesch wrote:
> > > Userspace handles this transparently through fault traps.
> > 
> > 	This is exactly what I was assuming. On the SPARC, in this
> > instance, it did not (check back earlier in this discussion).
> 
> Right, you get a SIGBUS, and this is what will happen on
> MIPS as well.
> 
> It is even defined in the application ABIs for these platforms that
> all objects must be aligned to their type's natural size.
> 
> 

So, how do we handle unaligned data in userspace then?
A _lot_ of applications are broken if that's right what you say.

-- 
Greetings Michael.
