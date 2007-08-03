Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:56089 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758571AbXHCKPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 06:15:21 -0400
Message-ID: <46B30035.4080004@warmcat.com>
Date: Fri, 03 Aug 2007 11:15:17 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: No echo TX pkt to Monitor interfaces for injection
References: <20070802223857.19090.70108.stgit@localhost> <1186135029.4647.27.camel@johannes.berg>
In-Reply-To: <1186135029.4647.27.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> Ah. Now I see why this is happening. It's because any packet you send
> into the monitor interface from userspace is already redirected back to
> userspace by upper levels... Hmm. It *seems* this patch is correct, but
> it changes the semantics slightly: previously, you would see transmitted
> packets with their transmit indication (whether it was acked etc) and
> now you do not get that for injected packets. Could we instead somehow
> get the upper layers to not redirect that and fix the radiotap header?

With the patch, injected packets have the same Monitor mode footprint
with hard or soft monitoring (you see the injected radiotap stuff)
because the synthesized "tx report" packet doesn't exist in the real
world shown by hard monitoring.

Acutually I think where it might all be heading is Michael Buesch's
method of selecting between hard and soft Monitor mode based on
IFF_PROMISC.  Maybe stuff like the user MLE plan wants to hear about TX
reports, it's only interested in a context it is trying to associate to,
maybe it would be happy with the filtered soft Monitor (this would deal
with the objection about increased power consumption for unfiltered user
MLE hardware promisc too)... apps that truly want hard Monitor don't
want the TX reports...

If that is where we are headed then it deprecates this patch, you
actually want the TX report in soft monitor (only) which is the current
situation... we just need to get to the place that tcpdump (which sets
IFF_PROMISC for the duration) never ever sees soft Monitor...

-Andy

