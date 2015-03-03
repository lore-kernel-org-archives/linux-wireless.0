Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54666 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbbCCJAY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 04:00:24 -0500
Message-ID: <1425373219.2450.13.camel@sipsolutions.net> (sfid-20150303_100028_843335_0F2CED36)
Subject: Re: [PATCH net-next 13/14] wireless: Use eth_<foo>_addr instead of
 memset
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2015 10:00:19 +0100
In-Reply-To: <1425372748.17273.6.camel@perches.com>
References: <cover.1425354527.git.joe@perches.com>
	 <0c710456e4875ff00c1a9fcff9378ed15110dcd3.1425354528.git.joe@perches.com>
	 <1425370617.2450.3.camel@sipsolutions.net>
	 <1425371858.17273.3.camel@perches.com>
	 <1425372295.2450.9.camel@sipsolutions.net>
	 <1425372748.17273.6.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-03 at 00:52 -0800, Joe Perches wrote:

> > > My guess is the eth_zero_addr and eth_broadcast functions
> > > are always taking aligned(2) arguments, just like all the
> > > is_<foo>_ether_addr functions.
> > 
> > Err, are you serious???
> 
> Yes.
> 
> > That *clearly* isn't true, and if it was then
> > this patch wouldn't be safe at all.
> 
> And why is that?
> 
> Until patch 1 of this series, eth_zero_addr and
> eth_broadcast_addr was just an inline for a memset.
> 
> Even after patch 1, it's effectively still memset.

Exactly. It therefore *doesn't* require an aligned(2) argument, unlike
what you stated above, hence my question if you're serious (and perhaps
looking at some other code that I don't have).

My argument/complaint is that it isn't obvious from these which ones do
require aligned(2) argument. Therefore, it's not obvious without going
back to the definitions where the conversion is safe and where it isn't.
Clearly, for example, memcmp() cannot always be replaced with
ether_addr_equal().

johannes

