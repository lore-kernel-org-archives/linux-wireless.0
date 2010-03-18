Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:62344 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab0CRHTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 03:19:11 -0400
Subject: Re: [RFC PATCHv3 1/1] mac80211: Add support connection monitor in
 hardware
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "Oikarinen Juuso (Nokia-D/Tampere)" <juuso.oikarinen@nokia.com>
Cc: ext Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1268888800.10120.646.camel@wimaxnb.nmp.nokia.com>
References: <1268830377-3450-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268830377-3450-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1268842503.5989.14.camel@jlt3.sipsolutions.net>
	 <1268888800.10120.646.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 09:18:52 +0200
Message-ID: <1268896732.13113.7.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-18 at 06:06 +0100, Oikarinen Juuso (Nokia-D/Tampere)
wrote:
> On Wed, 2010-03-17 at 17:15 +0100, ext Johannes Berg wrote:
> > >  void ieee80211_beacon_loss_work(struct work_struct *work)
> > >  {
> > >  	struct ieee80211_sub_if_data *sdata =
> > >  		container_of(work, struct ieee80211_sub_if_data,
> > >  			     u.mgd.beacon_loss_work);
> > >  
> > > -	ieee80211_mgd_probe_ap(sdata, true);
> > > +	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
> > > +		ieee80211_beacon_loss_disassoc(sdata);
> > > +	else
> > > +		ieee80211_mgd_probe_ap(sdata, true);
> > >  }
> > 
> > And I'm actually wondering now if using the same API is a good idea.
> > Yes, it makes some sense, but it's quite different yet? Maybe we should
> > have something like this:
> > 
> > static inline void ieee80211_beacon_loss(hw, vif)
> > {
> > 	WARN_ON(hw->flags & IEEE80211_HW_CONNECTION_MONITOR);
> > 	__ieee80211_beacon_connection_loss(vif);
> > }
> > 
> > static inline void ieee80211_connection_loss(hw, vif)
> > {
> > 	WARN_ON(!(hw->flags & IEEE80211_HW_CONNECTION_MONITOR));
> > 	__ieee80211_beacon_connection_loss(vif);
> > }
> > 
> > to make at least the external API easier to understand?
> 
> We actually had a debate about this with Luciano Coelho, and I opted for
> a separate API, and Luca opted for just adding a flag to the existing
> beacon loss function. To be noted: Luca, two against one now! ;)

Heh, damn you guys! Lots of things have changed since Juuso and I
discussed this, so I'm not 100% sure that my previous comment about the
flag really still applies. :P

My point at the time was that the driver should inform mac80211 that it
has tried to send probe_reqs automatically but they were not answered,
and let mac80211 itself decide whether that meant a connection loss or
not.


-- 
Luca, the one who won't admit losing the discussion. :)

