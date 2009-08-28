Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1885 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZH1PpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 11:45:19 -0400
Subject: Re: [PATCH 1/2] cfg80211: initialize rate control after station
 inserted
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1251445557.4189.14.camel@johannes.local>
References: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
	 <1251445557.4189.14.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 08:45:21 -0700
Message-Id: <1251474321.3805.73.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, 2009-08-28 at 00:45 -0700, Johannes Berg wrote:
> Thanks. I'll comment on both patches together. Can you please also tell
> us what the problem is this is solving? I'm a bit lost.

This work is motivated by an attempt to untangle the iwlwifi station
management to be able to use mac80211's sta notify callback. From 4965
and up the rate scaling in the device is done per station, so an entry
in the station table is required for the rate scaling initialization to
succeed. 

> I think both of these patches should just rolled into one since this is
> also a mac80211 patch -- even if it's for the bit that interacts with
> cfg80211.

ok - will do (if it is determined that they are needed).

> 
> However, I don't think I actually understand the changes.
> 
> >  	sta_apply_parameters(local, sta, params);
> >  
> > -	rate_control_rate_init(sta);
> > -
> >  	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
> >  		sdata->vif.type == NL80211_IFTYPE_AP;
> >  
> > @@ -742,13 +740,17 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
> >  		if (err == -EEXIST && layer2_update) {
> >  			/* Need to update layer 2 devices on reassociation */
> >  			sta = sta_info_get(local, mac);
> > -			if (sta)
> > +			if (sta) {
> > +				rate_control_rate_init(sta);
> >  				ieee80211_send_layer2_update(sta);
> > +			}
> >  		}
> 
> Why is this necessary? It should already have been called for this
> station earlier?

maybe - I just tried to have the code behave exactly as before, just
with the rate scale initialization called later. Even before this patch,
rate scaling initialization would be called if the station already
exists. 

If it is not necessary I can remove it.

> 
> >  		rcu_read_unlock();
> >  		return err;
> >  	}
> >  
> > +	rate_control_rate_init(sta);
> > +
> 
> Also, I don't see anything between the old place that it was called and
> the new place you're moving it to that could possibly change the station
> parameters?

Station parameters may not have changed, but at this point the driver
has been notified that this station exists and it is now able to do the
rate scaling initialization correctly.

Right now iwlwifi is adding stations inside the rate scaling code in
order to work around this issue. I'd like to clean this up and only use
the sta notify callback.

> 
> Same in ibss.c (not quoting it here) where you're only moving it to
> after sta_info_insert()

This was my goal actually.

>  -- all that seems to do is add race conditions,
> allowing other code to find not-yet-initialised stations.

I did not realize that this can happen. Can you please elaborate?

> So the only place I could see a change being necessary would be mlme.c,
> but then only moving rate_control_rate_init() to after the flags
> settings, not to after the insert.

Here too I moved it to after the insert for the same reason as above.


Reinette


