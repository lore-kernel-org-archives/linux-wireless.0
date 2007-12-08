Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40481
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754755AbXLHCEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 21:04:08 -0500
Date: Fri, 07 Dec 2007 18:04:08 -0800 (PST)
Message-Id: <20071207.180408.55119728.davem@davemloft.net> (sfid-20071208_020415_440999_2BB8746C)
To: jt@hpl.hp.com
Cc: dcbw@redhat.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071207192756.GA15864@bougret.hpl.hp.com>
References: <20071206191150.GC5237@bougret.hpl.hp.com>
	<1197022818.2603.20.camel@localhost.localdomain>
	<20071207192756.GA15864@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jean Tourrilhes <jt@hpl.hp.com>
Date: Fri, 7 Dec 2007 11:27:56 -0800

> > Can you explain a bit more about this patch?
> 
> 	Those fields are defined and used in userspace, please check
> wireless.21.h in Wireless Tools.

If you need auxiliary data in the userspace application, define
an auxiliary structure which references the thing you get back
from the kernel.

I totally disagree with embedding things in kernel defined
interfaces that are purely userland internal data structures.

You really need to clean up the way you handle the wireless
kernel APIs, it is getting worse not better and you really
do not use good judgment or good interface design practices
when you makes these changes.

Everything is one big hack.

I will seriously NACK wireless API changes like this until
the situation starts to improve.
