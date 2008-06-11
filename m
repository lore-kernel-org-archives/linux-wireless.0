Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:39683 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYFKG6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 02:58:07 -0400
Date: Wed, 11 Jun 2008 09:57:19 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC] mac80211_hwsim
Message-ID: <20080611065719.GB7377@jm.kir.nu> (sfid-20080611_085813_151010_762AEAF4)
References: <20080610105058.GA6961@jm.kir.nu> <1213096575.3668.6.camel@johannes.berg> <20080610123007.GB1571@tuxdriver.com> <1213103469.3668.13.camel@johannes.berg> <20080610152418.GD13267@tuxdriver.com> <20080610183722.GA7377@jm.kir.nu> <1213124444.3668.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213124444.3668.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2008 at 09:00:44PM +0200, Johannes Berg wrote:

> Should we add it to Documentation/networking/ instead? Don't care much,
> but it might be easier to track version changes that way.

That's fine, too. I'll add a subdirectory there for the readme and
example configuration files.

> > +static const struct ieee80211_rate hwsim_rates[] = {
> > +	{ .bitrate = 60, .flags = IEEE80211_RATE_ERP_G },
> 
> You don't need to add the ERP flag manually, it'll be added based on the
> rate automatically.

That sounds better. net/wireless.h was bit confusing on this part since
it has the "filled by the core" notice only for
IEEE80211_RATE_MANDATORY_* flags, not for IEEE80211_RATE_ERP_G. Looks
like this should be added to the ERP flag, too.

> > +	if (is_multicast_ether_addr(hdr->addr1))
> > +		ack = 1;
> 
> That seems a bit weird to me. mac80211 shouldn't request an ACK for
> mcast, but why fake one?

That was leftover from the previous version that did not check whether
IEEE80211_TX_CTL_NO_ACK was used. I'll remove it.

> 
> > ... beacon ...
> > +	if (vif->type != IEEE80211_IF_TYPE_AP)
> > +		return;
> 
> That could support mesh as well, in mesh-beacon-like-AP mode rather than
> mesh-beacon-like-IBSS.

Yes. I'm not yet very familiar with the mesh implementation in mac80211
and did not want to enable things before having had chance to test them.

> > +                   data->channel->band != data2->channel->band ||
> > +                   data->channel->center_freq != data2->channel->center_freq)
> 
> The band check is useless since the frequency is in MHz, it's mostly to
> know which band table to look up things in if necessary.

OK, I'll remove it. With the current bands this seems to be fine, but
how would that work with 10 MHz and 5 MHz channels? I haven't verified,
but I would assume they could use same center frequency with 20 MHz
channels..

> > +	ieee80211_iterate_active_interfaces(hw, mac80211_hwsim_beacon_tx, hw);
> 
> Cool, another user of this API :)

I was first assuming that I have to implement some sort of data
structure to store all vifs in the driver code to do this, but this one
came in quite handy..

> > +	data->rx_filter = 0;
> > +	if (*total_flags & FIF_PROMISC_IN_BSS)
> > +		data->rx_filter |= FIF_PROMISC_IN_BSS;

> You don't actually seem to use these flags though. Should be added at
> some point, I think.

Yes, I left it there for future implementation of the actually
filtering logic.

> > +		memcpy(data->channels, hwsim_channels, sizeof(hwsim_channels));

> You shouldn't need to memcpy these, just point to the static
> allocations.

> > +		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &data->band;
> 
> You can even allocate the band struct statically.

Hmm.. Aren't the channel and rate structures being modified by
mac80211/wireless code? Sharing the same global data area for all radios
might not be desired if there will be different "hw" capabilities as far
as supported channels/rates/bands are concerned. In addition, the static
data structures were marked 'const' which would at least be somewhat
confusing if the data ends up changing.

-- 
Jouni Malinen                                            PGP id EFC895FA
