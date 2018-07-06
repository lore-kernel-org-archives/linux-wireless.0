Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35322 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753648AbeGFLqS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 07:46:18 -0400
Message-ID: <1530877576.3197.11.camel@sipsolutions.net> (sfid-20180706_134622_401630_85B122D4)
Subject: Re: [PATCH 1/7] wireless: Change single cqm_config to rssi config
 list
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 06 Jul 2018 13:46:16 +0200
In-Reply-To: <32a52d2ea57526cfe8c6311e6e34aaac@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
         <1528886747-26342-2-git-send-email-tamizhr@codeaurora.org>
         <1530264405.3481.31.camel@sipsolutions.net>
         <32a52d2ea57526cfe8c6311e6e34aaac@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-07-04 at 23:46 +0530, Tamizh chelvam wrote:

> > > -	struct cfg80211_cqm_config *cqm_config;
> > > +	struct cfg80211_rssi_config *rssi_config;
> > > +	struct list_head rssi_config_list;
> > 
> > Why do you need both now? Perhaps instead you should allow a NULL/all-
> > ones MAC address for where you have the direct pointer now, and remove
> > that? You anyway need to pass something to the peer argument in
> > 
> 
> In the current cqm/sta_mon implementation the range_config will be 
> updated before notify event posted to userspace.
> To update the range config for a specific station we need to have this 
> peer addr based configuration list which holds the thresholds info
> to choose the next rssi range.
> Or do you want me to handle and store the rssi_config structure in 
> mac80211 and update it in mac80211 itself ? And simply pass the 
> notification event to userspace application ?

I don't have any issues with storing it in mac80211 - could attach it to
the station entry there?

Come to think of it, that might also clarify the lifetime rules. As it
is now, what if the station is removed? What are the lifetime rules for
a per-station configuration?

It would almost look like it stays here (or maybe I missed when you
remove it from the list when a station is removed), but that doesn't
seem like a good idea.

Please document the lifetime rules also in the API, and make sure you
implement them properly.

> > What's the locking scheme for this? It's way more complex now so 
> > perhaps stick ASSERT_RTNL() in there or so?
> > 
> 
> Isn't wdev_lock enough ?

I guess it should be :-) Maybe assert on that, also to document the
locking rules.

> > >  	/* RSSI reporting disabled? */
> > > -	if (!wdev->cqm_config)
> > > +	if (!wdev->rssi_config)
> > >  		return rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
> > 
> > 
> > So I guess the wdev->rssi_config is used for the case of "always use
> > this config for any AP you're connected to" or so - but maybe it'd be
> > better to track the AP as a station? Then again, I guess we can't force
> > userspace to change that.

> Sorry I didn't get your point:( I didn't change anything in the station 
> mode. Functionality remains same for the station mode.

Right, that sort of goes back to my thoughts about lifetime rules too.
The rule for stations would be to have it deleted when the station is
deleted, but I guess the rule for client-mode is to keep the config
active even when roaming?

I was just thinking that you don't need to *store* it like that, you
could still - in client mode - store the configuration treating the AP
as a (peer) station, perhaps with an ff:ff:ff:ff:ff:ff MAC address or
something (instead of using the BSSID, to get lifetime rules adjusted
right).

But now that I'm thinking about how the lifetime rules differ ... that's
probably not worth it.

> > >  	wdev_lock(wdev);
> > >  	if (n_thresholds) {
> > > -		struct cfg80211_cqm_config *cqm_config;
> > > -
> > > -		cqm_config = kzalloc(sizeof(struct cfg80211_cqm_config) +
> > > -				     n_thresholds * sizeof(s32), GFP_KERNEL);
> > > -		if (!cqm_config) {
> > > +		wdev->rssi_config = cfg80211_get_rssi_config(
> > > +						wdev, thresholds,
> > > +						n_thresholds, hysteresis,
> > > +						wdev->current_bss->pub.bssid);
> > 
> > Here you link it to the BSSID anyway, but do we always have a
> > current_bss at this point?
> > 
> 
> Oops! I didn't think about that condition. I'll fix that in the next 
> version.

Again though - see above. I'm not sure it's even correct to link it to
the BSSID since until now, I think the configuration would remain across
roaming?

johannes
