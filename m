Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:51882 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbXHDHqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2007 03:46:18 -0400
Date: Sat, 4 Aug 2007 09:46:16 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Daniel Drake <dsd@gentoo.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: further plan wrt. monitor interfaces
Message-ID: <20070804074616.GA17144@deine-taler.de>
References: <1186178959.13315.30.camel@johannes.berg> <46B3B2AD.1040509@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46B3B2AD.1040509@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Drake wrote:

> Johannes Berg wrote:
> >1)
> >Define new filter flags
> > * FIF_PROMISC_IN_BSS	(BSS filters still on, but otherwise promisc)
> > * FIF_ALLMULTI		(all multicast frames are allowed through)
> > * FIF_BROADCAST	(broadcast frames are allowed through)
> > * FIF_FCSFAIL		(frames with bad FCS are allowed through)
> > * FIF_PLCPFAIL		(frames with bad PLCP checksum are allowed 
> > through)
> > * FIF_CONTROL		(control frames are shown)
> > * FIF_OTHER_BSS	(frames from other BSSes are shown, subject to the
> >			 other filters)
> >[missing anything?]
> 
> Incase this wasn't clear to anyone else, the proposal is that we add a 
> bitfield to the set_multicast_list parameters for the above flags. The 
> stack would then 'fabricate' some calls to set_multicast_list.
> 
> I like the filter flags concept here, but I think this may be better as 
> its own callback, or perhaps we should just rename set_multicast_list to 
> configure_filter or something like that.

ACK. 

> This also sounds nice to implement from a driver standpoint. After 
> documenting how I feel the soft/hard monitor interfaces should behave 
> should we have such a system, I'm not keen on the idea of actually 
> implementing that.
> 
> 
> As for the other problems mentioned in followup mails, how about 
> something like the following:
> 
> A new configure_device callback with these parameters:
>  - ieee80211_hw *hw
>  - int state: possible values NOCHANGE, ON, OFF
>  - int filter_flags: FIF_ flags from above
>  - u8 *mac_addr
> 
> This would combine the ideas of add_interface, remove_interface and 
> open/stop into one.
> 
> state: this would become ON when the first interface is brought up, and 
> would become OFF when the last interface is brought down. For all other 
> calls into this function, state is NOCHANGE

Just my 2 cents: I wonder, how you would handle the situation,
that a device can support two MACs in parallel? 

I would suggest two things: Clearly distinguish between PHY layer
and MAC layer functions in the interface and don't do
set_config-like functions at all, because they mix things in an
unclear way. The drivers will have to set all parameters in the
config structures or there must be a flag structure to mark those
values, which need to be updated. Which looks awfully like an
IOCTL-like interface then.

I would suggest something like this:

int (*enable_phy)(struct ieee80211_hw *hw, int flags);
int (*disable_phy)(struct ieee80211_hw *hw, int flags);
int (*set_phy_freq)(struct ieee80211_hw *hw, int /* ? */ freq, int flags);
...

int (*enable_mac)(struct ieee80211_hw *hw, u8 *mac_addr,
               int filter_flags, int flags);
int (*disable_mac)(struct ieee80211_hw *hw, u8 *mac_addr);
int (*set_mac_bssid)(struct ieee80211_hw *hw, u8 *mac_addr, u8 *bssid);
int (*enable_mac_beacon)(struct ieee80211_hw *hw, u8 *mac_addr,
                      struct ieee80211_beacon_config *config);
int (*disable_mac_beacon)(struct ieee80211_hw *hw, u8 *mac_addr);
...

The call sequence could be:

enable_phy
set_phy_freq
set_phy_rate
enable_mac
set_mac_bssid     // For AP this will be the own mac address.
enable_mac_beacon // first mac address will be master
enable_mac        // for second mac address if needed
set_mac_bssid     // set bssid for second mac
disable_mac
disable_mac
disable_phy

I would make it to a rule that the setter functions could only be
called if the corresponding layer (phy, mac) has been enabled. All
the interface semantics for the upper layer should be handled by
the mac80211 stack including the persistent storage of a frequency
value before the the device has been brought up.

This interface would be fitting ZD1211 quite nicely, if all the
functions beside tx would be non-atomic. But I don't know about
the other drivers.

-- 
Uli Kunitz
