Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:35792 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0JZKTx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 06:19:53 -0400
Date: Tue, 26 Oct 2010 12:19:48 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Lee <lee-in-berlin@web.de>, linux-wireless@vger.kernel.org
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
Message-ID: <20101026101948.GA3531@sig21.net>
References: <4CC0D0F6.4080507@web.de>
 <4CC33E83.4020505@web.de>
 <201010260740.47692.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201010260740.47692.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 26, 2010 at 07:40:47AM +0200, Helmut Schaa wrote:
> Am Samstag 23 Oktober 2010 schrieb Lee:
> > On 22/10/10 01:47, Lee wrote:
> > > The test case is as follows: I have eth0 and wlan0 (the interface to an
> > > rt37usb device) in a bridge lan0. I have a properly configured hostapd. When I
> > > try to connect with a client to my hostapd AP, I can successfully
> > > authenticate, but all further packets don't reach the interface of the AP.
> > >
> > > However, I can see broadcast packets *from* the AP on my client, but not the
> > > other way round (DHCP requests from client to AP). To make sure the bug was
> > > not specific to broadcast packets, I manually set an IP on my client and tried
> > > to ping the AP, but those packets didn't come through, either.
> 
> [...] 
> 
> > I checked vanilla 2.6.36, the bug is still there. Is this a known bug? Does 
> > anyone care to give me some hints? Are any details needed?
> 
> Please try to create a monitor interface on the rt73usb AP after setting it up:
> 
> # iw dev wlan0 interface add mon0 type monitor
> 
> and run a tcpdump on that (with XX:...:XX replaced by the MAC address of
> your client):
> 
> # tcpdump -i mon0 "ether src XX:XX:XX:XX:XX:XX"
> 
> Do you see any frames from your specific client?

This could be the same issue I reported in
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2010-October/002152.html
with compat-wireless-2.6.36-rc3-1.

I had to do other work and couldn't follow up on this issue, but I'll
try to reproduce it later today.

BTW, if I want to test the current rt2x00 git version with a 2.6.32 kernel,
like outlined in "Testing with compat-rt2x00"
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2010-October/002175.html
can I base it on stable compat-wireless or do I need to use a
compat-wireless based on linux-next (aka bleeding edge)?
What do rt2x00 developers use?


Thanks
Johannes
