Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34225 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2LUSY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 13:24:56 -0500
Received: by mail-pa0-f41.google.com with SMTP id bj3so3005302pad.0
        for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2012 10:24:56 -0800 (PST)
Date: Fri, 21 Dec 2012 10:24:32 -0800
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com, j@wl.fi
Subject: Re: [PATCH v2 1/3] mac80211_hwsim: use hrtimer for beacon timers
Message-ID: <20121221182432.GA24585@cable.cozybit.com> (sfid-20121221_192510_244404_D83B0FC3)
References: <1356029871-17794-1-git-send-email-thomas@cozybit.com>
 <1356100396.9580.10.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1356100396.9580.10.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 21, 2012 at 03:33:16PM +0100, Johannes Berg wrote:
> On Thu, 2012-12-20 at 10:57 -0800, Thomas Pedersen wrote:
> 
> > @@ -896,7 +897,8 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
> >  {
> >  	struct mac80211_hwsim_data *data = hw->priv;
> >  	data->started = false;
> > -	del_timer(&data->beacon_timer);
> > +	hrtimer_cancel(&data->beacon_timer);
> > +	tasklet_kill(&data->bcn_tasklet);
> >  	wiphy_debug(hw->wiphy, "%s\n", __func__);
> 
> Hm this seems odd, why is it stopped here rather than when beaconing is
> stopped? Or does it do both?

It seems mac80211_hwsim doesn't even handle the case of
BSS_CHANGED_BEACON_ENABLED, I can add this.

> > @@ -1084,12 +1096,12 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
> >  
> >  	if (changed & BSS_CHANGED_BEACON_INT) {
> >  		wiphy_debug(hw->wiphy, "  BCNINT: %d\n", info->beacon_int);
> > -		data->beacon_int = 1024 * info->beacon_int / 1000 * HZ / 1000;
> > -		if (WARN_ON(!data->beacon_int))
> > -			data->beacon_int = 1;
> > -		if (data->started)
> > -			mod_timer(&data->beacon_timer,
> > -				  jiffies + data->beacon_int);
> > +		data->beacon_int = ns_to_ktime(info->beacon_int * 1024 * 1000);
> > +		if (WARN_ON(!ktime_to_ns(data->beacon_int)))
> > +			data->beacon_int = ns_to_ktime(1000 * 1000);
> 
> Can that warning really happen? It seems it should be checking
> info->beacon_int rather than data->beacon_int? Why convert back and
> forth?

No, it looks like nl80211 will filter out beacon intervals of 0 anyway
so let's kill that.

> Also the default here seems very very small, that's like less than 1ms
> beacon interval (not even in TU)?

Yes, I was just trying to mirror the existing code. How is 1000 (TU) for
a sane default?

Thomas
