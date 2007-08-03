Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:60021 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759530AbXHCKeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 06:34:23 -0400
Message-ID: <46B304AB.8060805@warmcat.com>
Date: Fri, 03 Aug 2007 11:34:19 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: No echo TX pkt to Monitor interfaces for injection
References: <20070802223857.19090.70108.stgit@localhost>	 <1186135029.4647.27.camel@johannes.berg>  <46B30035.4080004@warmcat.com> <1186136638.4647.32.camel@johannes.berg>
In-Reply-To: <1186136638.4647.32.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Fri, 2007-08-03 at 11:15 +0100, Andy Green wrote:
> 
>> With the patch, injected packets have the same Monitor mode footprint
>> with hard or soft monitoring (you see the injected radiotap stuff)
>> because the synthesized "tx report" packet doesn't exist in the real
>> world shown by hard monitoring.
> 
> I don't see why there's a distinction between hard and soft monitor
> mode. To me, hard monitor mode is basically "show me everything you can"
> while soft is "best effort". Soft monitor mode also makes no sense while
> no other interface is operating.

I also think it makes no sense to have a dependency on what Monitor mode
provides based on the other virtual interfaces, unless the hardware
cannot live up to the various demands at the same time.  (What hardware
has this problem that it can't run a Managed interface with hardware
promisc Rx?)

> The synthesized 'tx report packet' isn't that; the only synthesized
> thing is the radiotap header, the rest of the packet is what we actually
> sent and were thus unable to capture ourselves.

Yes, that is true.

>> Acutually I think where it might all be heading is Michael Buesch's
>> method of selecting between hard and soft Monitor mode based on
>> IFF_PROMISC.
> 
> Ah. I see. You're thinking of hard/soft monitor as something totally
> different than it is. Soft monitor really is only a hack for
> pseudo-softmac hardware that doesn't allow you to capture control
> packets while another interface is operating.

Well it has leaked out of that raison d'etre and oozed into being what
you get on any secondary virtual interface in Monitor mode.

Still I was suggesting maybe it does have another reason for existing,
the application of the usermode MLME might fit well with the filtered
aspect of it and the existing "TX report echos".

-Andy
