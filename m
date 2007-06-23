Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:37914 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbXFWJBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2007 05:01:03 -0400
Message-ID: <467CE130.2080306@warmcat.com>
Date: Sat, 23 Jun 2007 10:00:32 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
References: <1182418939.10821.8.camel@johannes.berg>	 <20070621143558.68fc8e4a@griffin.suse.cz>	 <1182429920.21939.1.camel@johannes.berg>	 <20070621151441.500d62d5@griffin.suse.cz>	 <20070622154545.29eeebdb@griffin.suse.cz> <467BDCB1.1010604@warmcat.com>	 <1182526221.21939.94.camel@johannes.berg>	 <20070622174953.500817e0@griffin.suse.cz>	 <1182543620.21939.98.camel@johannes.berg>  <467CB691.2090806@warmcat.com> <1182581630.21939.105.camel@johannes.berg>
In-Reply-To: <1182581630.21939.105.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> On the other hand, I do consider userspace MLME needs slightly
> different; it needs to be able to have frames encrypted, needs to see
> frames that have been decrypted even though they would otherwise be
> dropped [and this is very different to what you want], and probably
> more.

Fair enough, but injection is a separate issue from RX, despite one
usually needs both.  That there is no standard way to inject on
mac80211, regardless of the RX situation is a major lack.  If injection
is not treated as a separate valid action then it will constantly be
delayed as part of some larger effort, when it is valuable in itself.

But Jiri's encapsulation method is an improvement if it can be
implemented okay for unassociated interfaces and so on.

> I haven't seen a good proposal to unify this. To me, Jiri's proposal of
> packing what is essentially out-of-band data into some sort of special
> frames is no use, and your proposal to use monitor mode interfaces is
> perfect for the first use case, but still leaves us with more
> out-of-band data that the userspace MLME needs and hence doesn't gain us
> much.

Understood, it doesn't affect injection though.  Also the kernel packet
filter stuff can easily filter on the ethertype part of the encapsulated
packets.

> Who started this anti-nl80211 thing anyway? I still don't see what's so
> wrong with sending frames down a PF_NETLINK socket rather than a
> PF_PACKET socket.

I don't have anything against it, but for me the packets I am injecting
are normal network traffic and sending them like that seems the most
natural way.  For RX down in userspace it is marginally simpler to use
libpcap monitoring and the same handle for injection and rx.  I
definitely think having two paths to injection is not necessary, but for
splitting out normally invisible management packets to go down a
separate netlink socket instead of encapsulating them I don't mind
either way.

-Andy
