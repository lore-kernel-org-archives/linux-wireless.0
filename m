Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbXLIRq2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 12:46:28 -0500
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: Dan Williams <dcbw@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jt@hpl.hp.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
In-Reply-To: <20071207.180408.55119728.davem@davemloft.net>
References: <20071206191150.GC5237@bougret.hpl.hp.com>
	 <1197022818.2603.20.camel@localhost.localdomain>
	 <20071207192756.GA15864@bougret.hpl.hp.com>
	 <20071207.180408.55119728.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 09 Dec 2007 12:35:06 -0500
Message-Id: <1197221706.9149.36.camel@localhost.localdomain> (sfid-20071209_174644_194580_2325F348)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-12-07 at 18:04 -0800, David Miller wrote:
> From: Jean Tourrilhes <jt@hpl.hp.com>
> Date: Fri, 7 Dec 2007 11:27:56 -0800
> 
> > > Can you explain a bit more about this patch?
> > 
> > 	Those fields are defined and used in userspace, please check
> > wireless.21.h in Wireless Tools.
> 
> If you need auxiliary data in the userspace application, define
> an auxiliary structure which references the thing you get back
> from the kernel.
> 
> I totally disagree with embedding things in kernel defined
> interfaces that are purely userland internal data structures.
> 
> You really need to clean up the way you handle the wireless
> kernel APIs, it is getting worse not better and you really
> do not use good judgment or good interface design practices
> when you makes these changes.
> 
> Everything is one big hack.
> 
> I will seriously NACK wireless API changes like this until
> the situation starts to improve.

So how would _you_ add a scan capabilities bitfield (or a new generic
capabilities bitfield) to the WEXT range call?

We need the scan capability flag functionality; I don't care how we get
it as long as the patch is not too invasive.  But userspace needs to
know what the driver can do, and the patch needs to be written so that
drivers that don't have the capabilities don't need to be touched.

Dan


