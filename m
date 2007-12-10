Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbXLJRdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:33:23 -0500
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: Dan Williams <dcbw@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jt@hpl.hp.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
In-Reply-To: <20071209.221048.187424680.davem@davemloft.net>
References: <20071207.180408.55119728.davem@davemloft.net>
	 <1197221706.9149.36.camel@localhost.localdomain>
	 <1197223174.9149.60.camel@localhost.localdomain>
	 <20071209.221048.187424680.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 12:23:23 -0500
Message-Id: <1197307403.18585.10.camel@localhost.localdomain> (sfid-20071210_173325_395678_CAE249C5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-12-09 at 22:10 -0800, David Miller wrote:
> From: Dan Williams <dcbw@redhat.com>
> Date: Sun, 09 Dec 2007 12:59:34 -0500
> 
> > Do either of those sound better to you than extending struct
> > iw_range?
> 
> I find it interesting that we're willing to invest so much into
> new WEXT hacks, but zero effort in converting the same applications
> over the nl80211.
> 
> Even if you did it only for this new functionality, it would be
> 100 times better investment of your time than continuing this
> WEXT nightmare.

Not everyone is on unreleased 2.6.25 kernels.  We need to work in many
places, and we must use WEXT for quite a while yet.  It's gonna need
maintenance.  Therefore, we still have to fix bugs, and this is a fix
for a bug whereby hidden SSID handling is really, really crappy right
now.

Is this an unconditional NAK for any changes to WEXT?  Again, I'm happy
to do the patch, what would be an acceptable way to fix this bug _in_
_WEXT_ where drivers do not advertise what their scan capabilities are?

Dan


