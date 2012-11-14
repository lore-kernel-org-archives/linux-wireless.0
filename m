Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44356 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab2KNJ3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 04:29:14 -0500
Message-ID: <1352885386.9510.15.camel@jlt4.sipsolutions.net> (sfid-20121114_102920_276047_BFEB6FD4)
Subject: Re: mesh powersave code layout
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: kvalo@adurom.com, "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 14 Nov 2012 10:29:46 +0100
In-Reply-To: <50A29A2C.9080606@cozybit.com> (sfid-20121113_200626_126301_1D6259DD)
References: <50A29A2C.9080606@cozybit.com>
	 (sfid-20121113_200626_126301_1D6259DD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marco,

> I had a presentation on mesh powersave during the Barcelona Wireless 
> summit. In the following discussion Kalle Valo pointed out to me, that 
> there was interest in generally moving powersave code out of mac80211.

Well, I think you should have some background there :-)

The point is that in particular the managed mode powersave is a huge
mess because it supports complete offloading and complete software
implementation (except for the wakeups obviously) and a kind of hybrid
inbetween mode where the device sends a null data frame whenever going
into or out of PS (I'm looking at you, wl1251!)

This, combined with the fact that the code is older than proper multi
interface support, makes it a huge mess.

The idea we were floating for a while thus was that we should instead
try to provide some sort of library, maybe within mac80211 but not tied
into the core flows, that can take the part of sending null data frames
etc. To mac80211 then, drivers would seem to all implement complete
managed mode powersaving.

> Now I am unsure where to place my mesh PS code before submission.
> Currently my code layout for the mesh mode powersave is like this:
> 
> mac80211:
> -mesh PS mode setting and state logic
> -mesh PS mode indication towards neighbors
> -neighbor PS mode tracking
> -frame buffering
> -frame release in Peer Service Periods
> -driver configuration
> 
> drivers (ath9k, ath9k_htc, ...):
> -configuration
> -tracking of neighbors' beacon TBTTs
> -determining next wakeup TBTT and hardware configuration for wakeup
> -awake window after own beacon (software timer)
> 
> 
> Javier Cardona recommended changing that and moving all the mesh PS code 
> to mac80211 for easy maintenance. So (if possible) the idea would be to 
> create new ieee80211_ops ála:
> -void (*radio_sleep) (struct ieee80211_hw *hw, u64 until_tbtt);
> -void (*radio_wakeup)(struct ieee80211_hw *hw);

I see value in having a shared implementation, but I'm afraid that if
mesh ever becomes more mainstream vendors will come up with different
implementations, and then this won't really be the correct API. Look at
it this way: this kind of API works perfectly for when the driver
handles everything, but it doesn't work at all if there's any firmware
involved that can help in any way.

I think the part that you have in mac80211 now is probably fine there,
even if in AP mode e.g. the TI device tries to do everything itself in
the firmware :-)

For the remainder, I would suggest to keep the code separate from the
core mesh code, but maybe make a shared component:

/* provided by driver */
struct ieee80211_mesh_ps_ops {
	radio_sleep, radio_wakeup, ...
};

/* embedded into driver private vif struct */
struct ieee80211_mesh_ps {
	...
};

/* embedded into driver private sta struct */
struct ieee80211_mesh_sta_ps {
	...
};

/* called by driver on interface add/remove */
int ieee80211_mesh_ps_init(struct ieee80211_mesh_ps *mesh_ps,
			   const struct ieee80211_mesh_ps_ops *ops);
void ieee80211_mesh_ps_exit(struct ieee80211_mesh_ps *mesh_ps);

/* called on station add/remove */
int ieee80211_mesh_ps_add_sta(struct ieee80211_mesh_ps *mesh_ps,
			      struct ieee80211_mesh_ps_sta *mesh_ps_sta);
void ieee80211_mesh_ps_del_sta(...);
/* some sort of notification about TBTT? frame RX maybe? */

etc.

This is more like I wish managed mode worked, and has the advantage that
if the device/driver wants to implement tracking they can do so, and if
they don't they can use this library -- which I would expect you'd want
to use for different QCA devices that you're working with.

Does that make sense?

johannes

