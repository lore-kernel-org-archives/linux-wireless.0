Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:39596 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbYFMO1q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 10:27:46 -0400
Date: Fri, 13 Jun 2008 17:26:58 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211_hwsim: 802.11 radio simulator for mac80211
Message-ID: <20080613142658.GI4919@jm.kir.nu> (sfid-20080613_162750_566211_0CA49C80)
References: <20080611074230.GA4919@jm.kir.nu> <1213356074.3860.26.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213356074.3860.26.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 13, 2008 at 01:21:14PM +0200, Johannes Berg wrote:

> > +mac80211_hwsim is a Linux kernel module that can be used to simulate
> > +arbitrary number of IEEE 802.11 radios for mac80211 on a single
> > +device.
> 
> To me, that makes it sound as though you needed an underlying wireless
> device. Maybe that "on a single device" should just be removed?

Agreed, removing that sounds reasonable.

> > +to select how many radios are simulates (default 2). This allows
>                                          ^ typo, simulated

Thanks, will fix.

> > +Please note that the current Linux kernel does not enable AP mode, so a
> > +simple patch is needed to enable AP mode selection:
> > +http://johannes.sipsolutions.net/patches/kernel/all/LATEST/006-allow-ap-vlan-modes.patch
> 
> Ok, once this code is in I'll add a hunk to my patch there that removes
> this note.

By the way, what's the current plan on applying this patch to allow AP
modes to be enabled? I would assume they are still disabled because AP
functionality is not yet complete, but is there a clear set of features
that need to be added/fixed before this change goes in?


> > +	hdr->hdr.it_present = __constant_cpu_to_le32(
> > +	skb->protocol = __constant_htons(ETH_P_802_2);
> 
> No need to use the __constant_ prefix, the regular macros are smart
> enough to optimise out in that case; the __constant versions are only
> needed when the compiler expression has to be constant, e.g. for

OK.

> > +		if (memcmp(hdr->addr1, hwsim_radios[i]->wiphy->perm_addr,
> > +			   ETH_ALEN) == 0)
> > +			ack = 1;
> 
> Since you never set "ack" anywhere else, you could just say
> 	ack = memcmp(...) == 0;

This is in a loop, so ack must not be cleared back to zero if it was
once set to 1 for an earlier radio..

> > +static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
> > +				     struct ieee80211_vif *vif)

> Maybe there should be a helper function for all this? It seems mostly
> duplicated.

Yes, I was hoping to do this first, but there were some differences that
I did not want to deal with at the time. I'll take a closer look at
moving that to a shared function. It will likely make this bit slower,
but then again, I'm not really concerned about how fast this sort of
simulation code will work; it'll be much faster than actually going over
the air to another host for sure ;-).

> > +	ieee80211_iterate_active_interfaces(hw, mac80211_hwsim_beacon_tx, hw);
> 
> Hmm. You could use the _atomic version to avoid taking the RTNL, it uses
> RCU instead.

Sounds reasonable. I did not even notice that version when I just
stopped at the first match on 'iterate' ;-).

> None of this is really all that important, so
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!

John: I have the changes mentioned here in another patch. Would you like
to get a new version of the previous patch with this merged in or a
separate cleanup patch that applies on top of the previous one?

-- 
Jouni Malinen                                            PGP id EFC895FA
