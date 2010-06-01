Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:22019 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab0FAJE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 05:04:56 -0400
Subject: Re: [RFC PATCHv2 1/1] mac80211: Add interface for driver to
 temporarily disable dynamic ps
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1275379233.3621.2.camel@jlt3.sipsolutions.net>
References: <1275289547-7104-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1275289547-7104-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1275379233.3621.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 12:07:57 +0300
Message-ID: <1275383277.5277.21357.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-01 at 10:00 +0200, ext Johannes Berg wrote:
> On Mon, 2010-05-31 at 10:05 +0300, Juuso Oikarinen wrote:
> 
> >  /**
> > + * ieee80211_disable_dyn_ps - force mac80211 to temporarily disable dynamic psm
> > + *
> > + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> 
> * @disable: ...
> 
> The name is also a bit odd since you can re-enable it, but I can't think
> of a better name either.

I'll try to come up with a better name. If I cannot, I'll leave it as it
is.

> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -478,6 +478,24 @@ static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
> >  	}
> >  }
> >  
> > +void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif, bool disable)
> > +{
> > +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> > +	struct ieee80211_local *local = sdata->local;
> > +
> > +	WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION);
> > +
> > +	sdata->disable_dyn_ps = disable;
> > +
> > +	/* immediately go to psm */
> > +	if (disable && timer_pending(&local->dynamic_ps_timer)) {
> > +		ieee80211_queue_work(&local->hw,
> > +				     &local->dynamic_ps_enable_work);
> > +		del_timer_sync(&local->dynamic_ps_timer);
> > +	}
> > +}
> 
> The timer trickery seems weird, why not just queue the work and ignore
> the timer?

It's there for the obvious reason - it just saves an extra execution of
the dynamic_ps_enable_work. That said, maybe the saving is not worth the
added complexity.

> > -	if (conf->dynamic_ps_timeout > 0 &&
> > +	if (conf->dynamic_ps_timeout > 0 && !sdata->disable_dyn_ps &&
> 
> As we just discussed on IRC, it might be worthwhile to adjust
> dynamic_ps_timeout to 0 instead in this case, so this and the RX and TX
> paths need not be touched.

Yes, as we discussed I'll change this to adjusting the
dynamic_ps_timeout to zero, and using a separate variable to track the
actual value of the timer.

-Juuso

> johannes
> 


