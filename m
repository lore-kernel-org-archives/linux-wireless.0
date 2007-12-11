Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41540
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751972AbXLKAPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 19:15:05 -0500
Date: Mon, 10 Dec 2007 16:15:04 -0800 (PST)
Message-Id: <20071210.161504.159685695.davem@davemloft.net> (sfid-20071211_001509_849898_4FFBC4E0)
To: jt@hpl.hp.com
Cc: johannes@sipsolutions.net, dcbw@redhat.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071210180921.GB7168@bougret.hpl.hp.com>
References: <1197223174.9149.60.camel@localhost.localdomain>
	<1197288928.6035.59.camel@johannes.berg>
	<20071210180921.GB7168@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jean Tourrilhes <jt@hpl.hp.com>
Date: Mon, 10 Dec 2007 10:09:21 -0800

> On Mon, Dec 10, 2007 at 01:15:27PM +0100, Johannes Berg wrote:
> > 
> > > Do either of those sound better to you than extending struct iw_range?
> > 
> > Because wext is stupidly defined, you can never extend any structures it
> > uses. Wext never passes in the length that userspace expects to passing
> > in longer structures than the fixed one userspace expects will always
> > overwrite something in userspace, possibly on the stack.
> > 
> > johannes
> 
> 	Please check again...

I've personally already fixed a bug like this for 64-bit because the
WEXT request struct is smaller than an ifreq and the former is what
the applications declare on the stack yet an ifreq is what was used to
size to copy back into userspace.

There are therefore definitely past and potential future problems in
this area, and indeed it is a design issue.
