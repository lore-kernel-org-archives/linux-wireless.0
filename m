Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2BFVEL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 16:04:11 -0500
Subject: Re: [RFC 6/9] mac80211: add ap channel switch command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
In-Reply-To: <CAK80WHZw9PRr_wjazJiPUo1vrCpjgyrSx9ydHwLGoJEp3qNwDA@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	 <1327581484-22047-7-git-send-email-victorg@ti.com>
	 <4F27814A.9060906@sipsolutions.net>
	 <CAK80WHZw9PRr_wjazJiPUo1vrCpjgyrSx9ydHwLGoJEp3qNwDA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 22:03:35 +0100
Message-ID: <1328562215.3466.3.camel@jlt3.sipsolutions.net> (sfid-20120206_220415_165509_B83B23EA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-02 at 18:07 +0200, Goldenshtein, Victor wrote:
> On Tue, Jan 31, 2012 at 7:51 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On 1/26/2012 4:38 AM, Victor Goldenshtein wrote:
> >>
> >> New ieee80211_ap_process_chanswitch(), to handle a channel switch
> >> request for AP/GO.
> >>
> >> New 'post_switch_block_tx' parameter in 'ieee80211_channel_switch'
> >> structure, which indicates whether transmission must be blocked after
> >> the scheduled channel switch, it should be set if the target channel
> >> is DFS channel.
> >>
> >> New ieee80211_ap_ch_switch_complete_notify() which notifies upper
> >> layers about channel switch complete event.
> >
> >
> > Shouldn't mac80211 have some non-offload implementation for this?

> What do you mean by "non-offload"?

When the driver doesn't explicitly implement channel switch for this and
other things, mac80211 could (should?) manage it.

> The mechanism is different from the client-side channel switch, but
> the "ieee80211_channel_switch" struct is almost the same (new
> post_switch_block_tx). Do you prefer to create a new
> "ieee80211_ap_channel_switch" struct + new driver callback ? something
> like drv_ap_channel_switch ?

I think that would be cleaner in terms of API, since not all drivers
will support both.

> >> +static int ieee80211_ap_process_chanswitch(struct wiphy *wiphy,
> >> +                                          struct net_device *dev,
> >> +                                          u32 count, bool block_tx,
> >> +                                          bool post_switch_block_tx,
> >> +                                          u32 new_freq)
> >> +{
> >> +       struct ieee80211_sub_if_data *sdata =
> >> IEEE80211_DEV_TO_SUB_IF(dev);
> >> +       struct ieee80211_local *local = sdata->local;
> >> +       struct ieee80211_channel *new_ch;
> >> +       struct ieee80211_channel_switch ch_switch;
> >> +
> >> +       new_ch = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
> >> +       if (!new_ch || new_ch->flags&  IEEE80211_CHAN_DISABLED) {
> >>
> >> +               wiphy_debug(local->hw.wiphy,
> >> +                           "failed channel switch on freq: %d\n",
> >> new_freq);
> >> +               return -EINVAL;
> >> +       }
> >
> >
> > That code should obviously be in cfg80211.
> >
> 
> Why ? and where exactly ?

Why? because all drivers will need to make this check. Wherever cfg80211
calls into this, of course, and then you'd cal in with a channel pointer
rather than the new freq.

johannes

