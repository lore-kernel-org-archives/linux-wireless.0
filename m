Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51884 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759595AbbKTLzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 06:55:41 -0500
Message-ID: <1448020533.3141.27.camel@sipsolutions.net> (sfid-20151120_125546_394051_3AB16D8C)
Subject: Re: [PATCH] wireless: change cfg80211 regulatory domain info as
 debug messages
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>,
	Dave Young <dyoung@redhat.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net
Date: Fri, 20 Nov 2015 12:55:33 +0100
In-Reply-To: <20151115192547.3fd1b3cc@mir>
References: <20151115073105.GA18846@dhcp-128-65.nay.redhat.com>
	 <20151115192547.3fd1b3cc@mir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-11-15 at 19:25 +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On 2015-11-15, Dave Young wrote:
> > cfg80211 module prints a lot of messages like below. Actually
> > printing once is acceptable but sometimes it will print again and
> > again, it looks very annoying. It is better to change these detail
> > messages to debugging only.
> 
> It is a lot of info, easily repeated 3 times on boot, but it's also
> the only real chance to determine why you ended up with the
> regulatory domain settings you got, rather than just the values
> itself. Given that a lot (most?) of officially shipping wireless
> devices are misconfigured (wrong EEPROM regdom settings for the
> region they're sold in) and considering that the limits can even
> change at runtime (IEEE 802.11d), it is imho quite important not just
> to be able what the current restrictions (iw reg get) are, but also
> why the kernel settled on those.
> 

Hm. I kinda sympathize with both points of view here, not sure what to
do.

Maybe we could skip this for the world regdomain only? It doesn't
really change, and we typically don't care that much for it? That'd
probably get rid of most of the lines already.

Alternatively, perhaps the internal computations should be more
transparently visible through some other mechanism?

johannes
