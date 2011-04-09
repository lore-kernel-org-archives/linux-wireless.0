Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57716 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab1DIUX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2011 16:23:59 -0400
Received: by eyx24 with SMTP id 24so1389845eyx.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Apr 2011 13:23:58 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [RFT] p54: implement multicast + arp req PS filter
Date: Sun, 10 Apr 2011 00:23:51 +0400
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <201104020058.17232.chunkeey@googlemail.com> <201104080328.53801.jcmvbkbc@gmail.com> <201104081508.27822.chunkeey@googlemail.com>
In-Reply-To: <201104081508.27822.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104100023.52526.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

> > So, I associated with that AP and obtained an IP address.
> Just a question, that popped into my head: "Have you enabled PS?
> either with "iw dev wlanX set power_save on" or
> ?iwconfig wlanX power on?, because the filters may be restricted
> to PSM.

I hadn't. LMAC API doc doesn't say that they're related.
This time I ran tests both with "iwconfig wlan0 power on" and without it.
Looks like PSM only makes kernel print "wlan0: detected beacon loss from AP - sending probe request".
I see no other effect.

> > I see that although ARP filter was set (I added printfs to both
> > branches above), all ARP requests pass through:
>  
> > (none):~# ./tcpdump -i wlan0 -nn -s0 arp
> hmm, what about "-p"? I think that the interface should not be in
> promisc mode since it might change the result.

My bad ):
So, I re-tested both cases with tcpdump -p.

In the ARP case, when there's no other traffic on p54spi, all ARP requests are dropped.
But if there's some egress traffic from p54spi, filter seems to work correctly: only ARP requests that match filter pass through.

In the multicast case filter seems to work correctly, but it treats broadcast as subject to that filtering too.
By default only 01:00:5e:00:00:01 gets into priv->mc_maclist, so we miss all broadcasts.

These two filters seem to interfere:
- if we set ARP filter and multicast filter without broadcast, we miss all ARPs if there's no egress traffic;
- if we set ARP filter and multicast filter with broadcast, or don't set multicast filter at all we get all ARPs.

This effect does not depend on filter setup order.

> on a second thought, maybe we should take tcpdump out of
> the equation all together and dump the raw data coming
> from the device when PSM is enabled.

Ok, I'm probably going to printk those raw packets to see what's going on with ARPs with and without traffic, if it makes sense. 

> > By the way, I see that ARP filter does not apply to the station
> > in IBSS or mesh mode. Is that intended?
> Really? No that's not intended, is this a shortcoming of the driver or
> of the stack?

I've found a comment in ieee80211_ifa_changed saying that ARP filtering is only supported in managed mode.

Thanks.
-- Max
