Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:38698 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaBXUbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 15:31:18 -0500
Message-ID: <1393273874.18879.46.camel@porter.coelho.fi> (sfid-20140224_213128_567510_4F724A50)
Subject: Re: [PATCH v3 6/7] cfg80211/mac80211: move interface counting for
 combination check to mac80211
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Mon, 24 Feb 2014 22:31:14 +0200
In-Reply-To: <1392972409.4346.34.camel@jlt4.sipsolutions.net>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
	 <1392906986-12275-7-git-send-email-luca@coelho.fi>
	 <1392972409.4346.34.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-21 at 09:46 +0100, Johannes Berg wrote:
> On Thu, 2014-02-20 at 16:36 +0200, Luciano Coelho wrote:
> 
> > @@ -2928,13 +2927,17 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
> >  	/* whatever, but channel contexts should not complain about that one */
> >  	sdata->smps_mode = IEEE80211_SMPS_OFF;
> >  	sdata->needed_rx_chains = local->rx_chains;
> > -	sdata->radar_required = true;
> >  
> >  	err = ieee80211_vif_use_channel(sdata, chandef,
> >  					IEEE80211_CHANCTX_SHARED);
> >  	if (err)
> >  		goto out_unlock;
> >  
> > +	/* Something is wrong if cfg80211 asked us to start radar
> > +	 * detection but we don't think we need to.
> > +	 */
> > +	WARN_ON(!sdata->radar_required);
> 
> Might that happen for regdomain changes? Or simply if userspace asks for
> radar detection without really needing it?

Good point.  I'll remove the warning.  This was a bit of a reminiscent
from when cfg80211 was passing the radar_detection flag, I was comparing
both here.


> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -3949,6 +3949,13 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
> >  	u16 auth_alg;
> >  	int err;
> >  
> > +	/* TODO: in cfg80211_mlme_auth() we used to check if the
> > +	 * channel can be used *before* this function was called.  Do
> > +	 * we still need to do it or can we rely on the combinations
> > +	 * check that will happen later, in
> > +	 * ieee80211_vif_use_channel()?
> > +	 */
> 
> We'll do it a few lines down in ieee80211_prep_connection(), so I don't
> see why we'd need to do it earlier?

Yes, you're right.  I just wondered whether we should avoid doing a
deauth before we checked the combinations when we are associated (just
before we call ieee80211_prep_connection()).

I will remove the TODO if you think we shouldn't worry about this.


> > @@ -4103,6 +4110,13 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
> >  	const u8 *ssidie, *ht_ie, *vht_ie;
> >  	int i, err;
> >  
> > +	/* TODO: in cfg80211_mlme_assoc() we used to check if the
> > +	 * channel can be used *before* this function was called.  Do
> > +	 * we still need to do it or can we rely on the combinations
> > +	 * check that will happen later, in
> > +	 * ieee80211_vif_use_channel()?
> > +	 */
> 
> ditto

Ditto. :)


> > +int ieee80211_check_combinations(struct wiphy *wiphy,
> > +				 struct wireless_dev *wdev,
> > +				 const struct cfg80211_chan_def *chandef,
> > +				 enum ieee80211_chanctx_mode chanmode,
> > +				 u8 radar_detect)
> 
> Why do you pass a wiphy here? In mac80211 we use local or hw except for
> API, and this isn't called from cfg80211? Same for 'wdev' vs. 'sdata'?

Okay, I'll change this to use local and sdata, it looks cleaner.  Though
I'll have to derive wiphy and wdev inside the function.  But I agree,
it's better to derive it inside the function than having to derive when
calling and go back to local/sdata inside the function.


> > +	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > +		wdev_iter = &sdata->wdev;
> > +		if (wdev_iter == wdev)
> > +			continue;
> > +		if (wdev_iter->iftype == NL80211_IFTYPE_P2P_DEVICE) {
> > +			if (!wdev_iter->p2p_started)
> > +				continue;
> > +		} else if (wdev_iter->netdev) {
> > +			if (!netif_running(wdev_iter->netdev))
> > +				continue;
> 
> That should probably be combined to sdata_running(), but shouldn't it
> also only be done if the interface is actually doing something (e.g. has
> joined an IBSS, ...), i.e. has a channel context assigned?

Right, actually, as we discussed offline I only need to check whether
there is a chanctx assigned to the vif.  No need to check if it is
running nor if it's P2P_DEVICE or whatever.  I'll do that.


> > +++ b/net/wireless/core.h
> > @@ -406,6 +406,9 @@ cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
> >  			      struct wireless_dev *wdev,
> >  			      enum nl80211_iftype iftype)
> >  {
> > +	/* TODO: For this function, we'll probably need to keep some
> > +	 * kind of interface combination check in cfg80211...
> > +	 */
> >  	return cfg80211_can_use_iftype_chan(rdev, wdev, iftype, NULL,
> >  					    CHAN_MODE_UNDEFINED, 0);
> >  }
> 
> We could always jsut request the change from the driver/mac80211.


This is also called by cfg80211_can_add_interface() which is called in
PRE_UP and start_p2p_device.

And in the cfg80211_change_interface() function, we do stuff like
stopping an AP or disconnecting a client.  I definitely think we should
check if the change is possible before taking these actions.

Do you mean to add an rdev_op to handle this?

Can we leave this for a separate patchset?


> > @@ -426,6 +429,10 @@ cfg80211_can_use_chan(struct cfg80211_registered_device *rdev,
> >  		      struct ieee80211_channel *chan,
> >  		      enum cfg80211_chan_mode chanmode)
> >  {
> > +	/* TODO: for libertas, we probably need to move the
> > +	 * combination check into that driver if we get rid of the
> > +	 * cfg80211_can_use_chan() function.
> > +	 */
> >  	return cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
> >  					    chan, chanmode, 0);
> >  }
> 
> That doesn't even have combinations, I believe?

You're right, it supports only a single vif, so I can completely remove
the cfg80211_can_use_chan() function. :D

--
Luca.

