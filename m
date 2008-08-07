Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:50897 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbYHGO2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 10:28:17 -0400
Date: Thu, 7 Aug 2008 17:27:32 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: Re: [RFC] mac80211/cfg80211: Add BSS configuration options for AP
	mode
Message-ID: <20080807142732.GC5138@jm.kir.nu> (sfid-20080807_162819_978026_0C630742)
References: <20080807134043.GA5138@jm.kir.nu> <1218116906.23048.179.camel@johannes.berg> <20080807141508.GB5138@jm.kir.nu> <1218118732.23048.183.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1218118732.23048.183.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 07, 2008 at 04:18:52PM +0200, Johannes Berg wrote:
> On Thu, 2008-08-07 at 17:15 +0300, Jouni Malinen wrote:
> > On Thu, Aug 07, 2008 at 03:48:26PM +0200, Johannes Berg wrote:
> > > I used to have a patch to move the short-slot stuff in mac80211 to the
> > > BSS info struct so that drivers that support different slot timing for
> > > each frame can use it for different virtual BSSes.

> Yeah, that was a sticky point... But if you want per-BSS information you
> really have to because right now it's per-hw.

Well, I don't actually need it per-BSS for hardware that I'm most likely
to work with ;-), but yeah, this is a per-BSS parameter, so in that
sense your patch is doing the correct thing.

> Ok, they can't be per VLAN then, true, but then I think we should limit
> it to _AP just so nobody tries setting them without effect on other
> devices or overrides, for _STA, what the AP said. For mesh I don't know
> (adding Luis) and for IBSS I'm not sure either. I suspect you could use
> it for IBSS too?

I think I'll just make it _AP only for now and if someone ever really
needs it for something else, they can enable it later.. It is possible
that new attributes that would be more reasonable for other modes will
be added in the future for _SET_BSS.

As far as IBSS is concerned, short slot time is disabled (802.11-2007,
19.4.4). Similarly, it is somewhat difficult to require the STAs in an
IBSS to control this type of disable-if-anyone-does-not-support
features. It is more likely to end up being
first-STA-to-create-IBSS-wins situation. Anyway, we do not have user
space IBSS control daemon anyway, so this is something that is not
needed yet.

-- 
Jouni Malinen                                            PGP id EFC895FA
