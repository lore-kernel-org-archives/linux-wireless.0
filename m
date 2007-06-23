Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:55345 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbXFWMXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2007 08:23:55 -0400
Message-ID: <467D10BA.80104@warmcat.com>
Date: Sat, 23 Jun 2007 13:23:22 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
References: <1182418939.10821.8.camel@johannes.berg>	<20070621143558.68fc8e4a@griffin.suse.cz>	<1182429920.21939.1.camel@johannes.berg>	<20070621151441.500d62d5@griffin.suse.cz>	<20070622154545.29eeebdb@griffin.suse.cz>	<467BDCB1.1010604@warmcat.com>	<1182526221.21939.94.camel@johannes.berg>	<20070622174953.500817e0@griffin.suse.cz>	<1182543620.21939.98.camel@johannes.berg>	<467CB691.2090806@warmcat.com>	<1182581630.21939.105.camel@johannes.berg> <20070623134451.643dd40c@logostar.upir.cz>
In-Reply-To: <20070623134451.643dd40c@logostar.upir.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Sat, 23 Jun 2007 08:53:50 +0200, Johannes Berg wrote:
>> Who started this anti-nl80211 thing anyway? I still don't see what's so
>> wrong with sending frames down a PF_NETLINK socket rather than a
>> PF_PACKET socket.
> 
> Perhaps it was just my misunderstanding about the monitor interface tx
> injection patches; I though this mechanism should be used for hostapd and
> user space MLME, which I consider wrong. Johannes' comment about different
> needs (and thus having both injection through monitor iface and through
> netlink) makes perfectly sense, though.
> 
> Andy, is using a monitor interface (for both injecting and receiving of
> frames) acceptable for you? If yes, let's drop my proposal (I said it might
> turn up to be useless :-)), apply patches for monitor iface injection and
> implement a netlink soultion as a replacement of the current management
> interface.

Yes the existing Monitor Mode Try #13 is fine for me and the userland
projects I know about, but actually I quite liked your encapsulation
thing -- in itself is compatible with working in any mode.  The only
problem with it right now is that it seems when mananged mode interfaces
 are not associated, they are in a netif_carrier_off() state or similar.
 If in the future it becomes possible to via netlink to target types of
packets to come down any interface in encapsulated bubbles, then
possibly it makes sense to use the encapsulated version.  But of course
either way will be great compared to nothing.

-Andy
