Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:49564 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbXKSATt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2007 19:19:49 -0500
Date: Sun, 18 Nov 2007 16:19:33 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Winkler, Tomas" <tomas.winkler@intel.com>, flamingice@sourmilk.net
Subject: Re: [PATCH 06/14] mac80211: adding 802.11n essential A-MSDU
	Rxcapability
Message-ID: <20071119001933.GD8672@jm.kir.nu> (sfid-20071119_002016_067322_1A4BF7DA)
References: <1879838866982C46A9CB3D56BA49ADEB04008798@hasmsx411.ger.corp.intel.com> <1194885942.5229.62.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1194885942.5229.62.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2007 at 05:45:42PM +0100, Johannes Berg wrote:

> > Would appreciate your opinion for next possible solution:
> > I'll Move ieee80211_rx_h_data_agg before ieee80211_rx_h_802_1x_pae, and
> > assuming I identify A-MSDU, I'll loop for each internal MSDU on:
> >   ieee80211_rx_h_802_1x_pae 
> >   ieee80211_rx_h_drop_unencrypted
> >   ieee80211_rx_h_data
> > return value of ieee80211_rx_h_data_agg to
> > __ieee80211_invoke_rx_handlers will be this small loop's return value 
> 
> I'm not sure I'd like to see such a thing. One thing I'm generally
> unhappy with here is how the handlers are in a list but there isn't a
> point in adding/removing any. Also, I'm not convinced that what you're
> saying will actually work because the handlers expect 802.11 frames so
> you'd have to make 802.11 frames out of the 802.3 frames you get...

When working with a proprietary (pre-802.11n) frame aggregation, we
ended up doing more or less this, i.e., converting the frames to a list
of skb's that had generated 802.11 headers and then passing them one by
one to ieee80211_rx_h_data. I don't know whether I would say that I
likeed the end result, but at least it seemed to work without major
problems.

This was assuming that there were never frames that would need special
handling in the aggregate (i.e., need for special PAE or
unencrypted/encrypted processing). Since the aggregate was encrypted as
a single unit, the drop_unencrypted was not an issue. Same was, in
practice, true for most of PAE processing. I don't think the initial
EAPOL handshake is an issue, but at least in theory, there could be an
EAPOL re-authentication happening at some point and if EAPOL frames
require special processing, this would need to be taken into account.

> What I originally wanted to do for this was to add a new
> "handle_data_frame" function that operates on 802.3 frames but has all
> the info available, is called from the rx_h_data handler and
> incorporates all the three callbacks you list above.That'd be similar to
> what I did with the crypto code (where we now only have a single handler
> doing it all rather than a bunch doing different pieces of the
> functionality)

Please note that data frame handling requires support for four addresses
and plain 802.3 header would not be sufficient without some additional
meta data. I would assume this to be doable, but some of the
functionality will need to moved around to handle the 802.11 specific
things first (like WDS interface selection) and then pass some meta data
in addition to the frame. This would get relatively close to the
MA-UNITDATA service primitives from the MAC (which do indeed only pass
two addresses; 802.3 header would just be one example of how this
information can be passed).

> You should be able to do this in the code right now because I removed
> the management interface and hence EAPOL frames aren't handled
> specially. Hostapd wants to have eapol frames on the management
> interface and 802.11 framed, but I don't understand that and would
> rather have it be done differently.

As long as the issues with encrypted vs. unencrypted frames can be
resolved for both TX and RX in a way that handles the 802.1X and WPA
cases, it should be fine passing EAPOL frames as normal data frames. In
addition, bridging code should be told not to bridge this ethertype if
that has not been done yet.

-- 
Jouni Malinen                                            PGP id EFC895FA
