Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:49403 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543AbXHFVXB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 17:23:01 -0400
Date: Mon, 6 Aug 2007 23:23:00 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Drake <dsd@gentoo.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: further plan wrt. monitor interfaces
Message-ID: <20070806212300.GA14347@deine-taler.de>
References: <1186178959.13315.30.camel@johannes.berg> <46B3B2AD.1040509@gentoo.org> <20070804074616.GA17144@deine-taler.de> <1186395427.28655.56.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1186395427.28655.56.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> > I would suggest something like this:
> > 
> > int (*enable_phy)(struct ieee80211_hw *hw, int flags);
> > int (*disable_phy)(struct ieee80211_hw *hw, int flags);
> > int (*set_phy_freq)(struct ieee80211_hw *hw, int /* ? */ freq, int flags);
> > ...
> > 
> > int (*enable_mac)(struct ieee80211_hw *hw, u8 *mac_addr,
> >                int filter_flags, int flags);
> > int (*disable_mac)(struct ieee80211_hw *hw, u8 *mac_addr);
> > int (*set_mac_bssid)(struct ieee80211_hw *hw, u8 *mac_addr, u8 *bssid);
> > int (*enable_mac_beacon)(struct ieee80211_hw *hw, u8 *mac_addr,
> >                       struct ieee80211_beacon_config *config);
> > int (*disable_mac_beacon)(struct ieee80211_hw *hw, u8 *mac_addr);
> > ...
> > 
> > The call sequence could be:
> > 
> > enable_phy
> > set_phy_freq
> > set_phy_rate
> > enable_mac
> > set_mac_bssid     // For AP this will be the own mac address.
> > enable_mac_beacon // first mac address will be master
> > enable_mac        // for second mac address if needed
> > set_mac_bssid     // set bssid for second mac
> > disable_mac
> > disable_mac
> > disable_phy
> > 
> > I would make it to a rule that the setter functions could only be
> > called if the corresponding layer (phy, mac) has been enabled. All
> > the interface semantics for the upper layer should be handled by
> > the mac80211 stack including the persistent storage of a frequency
> > value before the the device has been brought up.
> 
> I don't think I like this. First of all, it's quite a large step away
> from how mac80211 operates and thus a lot of work.

I don't think so enable_phy/disable_phy is open and stop. A bunch
of parameters are already set with a single function, only config
and config_interface need to be replaced by parameter-specific
functions. Reset should be removed. add_interface() and
remove_interface() are comparable to my enable_mac() and
disable_mac() as you discovered. 

There are two main things I'm asking for:

Tell the driver on the real interface, which packets it should
report to the mac80211 stack. Don't bother the driver with virtual
interfaces. The stack should handle it completely transparently.

Don't call the driver before open() or after stop() is called.
This means of course that the stack would have to maintain all
parameters for the device. The advantage would be that suspend and
resume support would become very easy. The stack would close the
device in suspend() and would open and configure the device in
resume(). These operations would not differ a lot from normal
open and normal stop.

-- 
Uli Kunitz
