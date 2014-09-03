Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42161 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932185AbaICMBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:01:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by gateway2.nyi.internal (Postfix) with ESMTP id 9B64220954
	for <linux-wireless@vger.kernel.org>; Wed,  3 Sep 2014 08:01:24 -0400 (EDT)
Message-ID: <1409745682.14224.10.camel@localhost> (sfid-20140903_140206_928331_0D90E001)
Subject: Re: [RFC] net: ipv4: drop unicast encapsulated in L2 multicast
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: David Miller <davem@davemloft.net>
Cc: hideaki.yoshifuji@miraclelinux.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	yoshfuji@linux-ipv6.org
Date: Wed, 03 Sep 2014 14:01:22 +0200
In-Reply-To: <20140902.150326.1420682815750767731.davem@davemloft.net>
References: <1409133238.26515.13.camel@localhost>
	 <1409650573.1808.11.camel@jlt4.sipsolutions.net>
	 <540675F2.1030308@miraclelinux.com>
	 <20140902.150326.1420682815750767731.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Di, 2014-09-02 at 15:03 -0700, David Miller wrote:
> From: YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>
> Date: Wed, 03 Sep 2014 10:59:14 +0900
> 
> > Upper-layer needs to cope eith situation of seeing packets with
> > "incorrect" L2 header anyway (e.g., in promiscous mode).
> > I do not see much advantage to drop them here.
> 
> It's required to prevent wireless nodes from using the shared wireless
> group keys (used for multicast transmission) to inject unicast frames.
> 
> The RFCs really do specify this at least on the ipv4 side.

I have to agree with YOSHIFUJI Hideaki here. I looked at a lot of RFCs
and haven't found anything were it states to use L2 address type for
checks in L3 ipv6 addresses. For IPv4 addresses the situation is clear
though...

There was an RFC update (6085) which specifically allows one to send
ipv6 multicast frames with unicast L2 addresses. In the dicussion that
lead to this RFC it was stated that checking L2 and L3 addresses seems
to be a layering violation, but I can just use this as a hint.

Bye,
Hannes


