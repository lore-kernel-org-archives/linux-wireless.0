Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54612 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbbCCIo7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 03:44:59 -0500
Message-ID: <1425372295.2450.9.camel@sipsolutions.net> (sfid-20150303_094559_604376_B1B7D1D4)
Subject: Re: [PATCH net-next 13/14] wireless: Use eth_<foo>_addr instead of
 memset
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2015 09:44:55 +0100
In-Reply-To: <1425371858.17273.3.camel@perches.com>
References: <cover.1425354527.git.joe@perches.com>
	 <0c710456e4875ff00c1a9fcff9378ed15110dcd3.1425354528.git.joe@perches.com>
	 <1425370617.2450.3.camel@sipsolutions.net>
	 <1425371858.17273.3.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Other than that, I guess I'll apply this, but I really wish there was a
> > way to distinguish more easily which of these require alignment and
> > which don't.
> 
> My guess is the eth_zero_addr and eth_broadcast functions
> are always taking aligned(2) arguments, just like all the
> is_<foo>_ether_addr functions.

Err, are you serious??? That *clearly* isn't true, and if it was then
this patch wouldn't be safe at all.

> > eth_zero_addr() doesn,t but is_zero_ether_addr() does. So does
> > ether_addr_copy(). Frankly, it's getting a bit confusing, so I can't
> > really fault anyone for using memset()/memcpy().
> 
> I suspect more than anything else all these are historic.

I'd expect a mix here, certainly. Not all of them are really old though.

johannes

