Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXLISJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 13:09:51 -0500
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: Dan Williams <dcbw@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jt@hpl.hp.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
In-Reply-To: <1197221706.9149.36.camel@localhost.localdomain>
References: <20071206191150.GC5237@bougret.hpl.hp.com>
	 <1197022818.2603.20.camel@localhost.localdomain>
	 <20071207192756.GA15864@bougret.hpl.hp.com>
	 <20071207.180408.55119728.davem@davemloft.net>
	 <1197221706.9149.36.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 09 Dec 2007 12:59:34 -0500
Message-Id: <1197223174.9149.60.camel@localhost.localdomain> (sfid-20071209_180959_144382_2B68811A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-12-09 at 12:35 -0500, Dan Williams wrote:
> On Fri, 2007-12-07 at 18:04 -0800, David Miller wrote:
> > From: Jean Tourrilhes <jt@hpl.hp.com>
> > Date: Fri, 7 Dec 2007 11:27:56 -0800
> > 
> > > > Can you explain a bit more about this patch?
> > > 
> > > 	Those fields are defined and used in userspace, please check
> > > wireless.21.h in Wireless Tools.
> > 
> > If you need auxiliary data in the userspace application, define
> > an auxiliary structure which references the thing you get back
> > from the kernel.
> > 
> > I totally disagree with embedding things in kernel defined
> > interfaces that are purely userland internal data structures.
> > 
> > You really need to clean up the way you handle the wireless
> > kernel APIs, it is getting worse not better and you really
> > do not use good judgment or good interface design practices
> > when you makes these changes.
> > 
> > Everything is one big hack.
> > 
> > I will seriously NACK wireless API changes like this until
> > the situation starts to improve.
> 
> So how would _you_ add a scan capabilities bitfield (or a new generic
> capabilities bitfield) to the WEXT range call?
> 
> We need the scan capability flag functionality; I don't care how we get
> it as long as the patch is not too invasive.  But userspace needs to
> know what the driver can do, and the patch needs to be written so that
> drivers that don't have the capabilities don't need to be touched.

I'm happy to do the patch, just need to figure out how to do it within
the constraints in a way that will be acceptable.

- We could create another WEXT sub-ioctl (SIOCGIWCAPA ?) that would have
all the capabilities together in a nice structure or something, but that
was what GIWRANGE was supposed to be, and it would add yet another WEXT
sub-ioctl.  Still, if nobody is opposed to this, it would work nicely
and would be a fresh start.

(We can't have SIOCSIWSCAN return an error if you pass it options it
doesn't know about, because that requires modifying _all_ drivers to
return that error.  We need to ensure that drivers that don't support
the scan capabilities don't need changing, otherwise the field is
useless because you can't tell whether a driver from 2.6.23 has the
capability or not.  It needs to be a _positive_ flag saying "yes I do
support this" instead of drivers from, say, 2.6.23 silently accepting
the command and not honoring the option)

- Overload struct iw_range's enc_capa like I had originally proposed,
perhaps changing the field's name to "capabilities" or something.
However, there are only 32 bits available and we would already be using
11 bits in the field.  Not too many.  Jean was against this though.  But
if we changed the name/redefine it and maintain the current bit values
it would only break stuff that checks for enc_capa != 0, which nothing
should do because that check doesn't tell you anything at all.

Do either of those sound better to you than extending struct iw_range?

Dan


