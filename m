Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54655 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaBYP0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 10:26:13 -0500
Message-ID: <1393341960.4170.15.camel@jlt4.sipsolutions.net> (sfid-20140225_162617_223551_5E6A0420)
Subject: Re: [PATCH v3 6/7] cfg80211/mac80211: move interface counting for
 combination check to mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Tue, 25 Feb 2014 16:26:00 +0100
In-Reply-To: <1393273874.18879.46.camel@porter.coelho.fi>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
	 <1392906986-12275-7-git-send-email-luca@coelho.fi>
	 <1392972409.4346.34.camel@jlt4.sipsolutions.net>
	 <1393273874.18879.46.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-24 at 22:31 +0200, Luca Coelho wrote:

> > > +	/* TODO: in cfg80211_mlme_auth() we used to check if the
> > > +	 * channel can be used *before* this function was called.  Do
> > > +	 * we still need to do it or can we rely on the combinations
> > > +	 * check that will happen later, in
> > > +	 * ieee80211_vif_use_channel()?
> > > +	 */
> > 
> > We'll do it a few lines down in ieee80211_prep_connection(), so I don't
> > see why we'd need to do it earlier?
> 
> Yes, you're right.  I just wondered whether we should avoid doing a
> deauth before we checked the combinations when we are associated (just
> before we call ieee80211_prep_connection()).
> 
> I will remove the TODO if you think we shouldn't worry about this.

I wouldn't really be worried about this. If it turns out to be a problem
we can always fix it later, but I doubt it.

> > > @@ -406,6 +406,9 @@ cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
> > >  			      struct wireless_dev *wdev,
> > >  			      enum nl80211_iftype iftype)
> > >  {
> > > +	/* TODO: For this function, we'll probably need to keep some
> > > +	 * kind of interface combination check in cfg80211...
> > > +	 */
> > >  	return cfg80211_can_use_iftype_chan(rdev, wdev, iftype, NULL,
> > >  					    CHAN_MODE_UNDEFINED, 0);
> > >  }
> > 
> > We could always jsut request the change from the driver/mac80211.
> 
> 
> This is also called by cfg80211_can_add_interface() which is called in
> PRE_UP and start_p2p_device.
> 
> And in the cfg80211_change_interface() function, we do stuff like
> stopping an AP or disconnecting a client.  I definitely think we should
> check if the change is possible before taking these actions.

Ok.

> Do you mean to add an rdev_op to handle this?

No I was thinking of just (re)moving it.

johannes

