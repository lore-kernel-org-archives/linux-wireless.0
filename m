Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:53342 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0CRFJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 01:09:36 -0400
Subject: Re: [RFC PATCHv3 1/1] mac80211: Add support connection monitor in
 hardware
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1268842503.5989.14.camel@jlt3.sipsolutions.net>
References: <1268830377-3450-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268830377-3450-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1268842503.5989.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 07:06:40 +0200
Message-ID: <1268888800.10120.646.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-17 at 17:15 +0100, ext Johannes Berg wrote:
> > + *
> > + * When hardware connection monitoring is enabled with
> > + * IEEE80211_HW_CONNECTION_MONITOR, this function will cause immediate change
> > + * to disassociated state, without connection recovery attempts.
> 
> Tiny detail: putting a % in front of constants formats them nicer in the
> html output.
> 
> > +static void ieee80211_beacon_loss_disassoc(struct ieee80211_sub_if_data *sdata)
> > +{
> 
> I can see where you're coming from, but maybe this should be more like
> ieee80211_driver_notify_disconnect() or something like that?
> 
> 
> > +	printk(KERN_DEBUG "Beacon loss from AP %pM, "
> > +	       "disconnected.\n", bssid);
> 
> printk lines are allowed to pass 80 chars to make grep easier. Also I
> really think this should be more like "Connection to AP %pM lost." or
> something like that?
> 
> >  void ieee80211_beacon_loss_work(struct work_struct *work)
> >  {
> >  	struct ieee80211_sub_if_data *sdata =
> >  		container_of(work, struct ieee80211_sub_if_data,
> >  			     u.mgd.beacon_loss_work);
> >  
> > -	ieee80211_mgd_probe_ap(sdata, true);
> > +	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
> > +		ieee80211_beacon_loss_disassoc(sdata);
> > +	else
> > +		ieee80211_mgd_probe_ap(sdata, true);
> >  }
> 
> And I'm actually wondering now if using the same API is a good idea.
> Yes, it makes some sense, but it's quite different yet? Maybe we should
> have something like this:
> 
> static inline void ieee80211_beacon_loss(hw, vif)
> {
> 	WARN_ON(hw->flags & IEEE80211_HW_CONNECTION_MONITOR);
> 	__ieee80211_beacon_connection_loss(vif);
> }
> 
> static inline void ieee80211_connection_loss(hw, vif)
> {
> 	WARN_ON(!(hw->flags & IEEE80211_HW_CONNECTION_MONITOR));
> 	__ieee80211_beacon_connection_loss(vif);
> }
> 
> to make at least the external API easier to understand?

We actually had a debate about this with Luciano Coelho, and I opted for
a separate API, and Luca opted for just adding a flag to the existing
beacon loss function. To be noted: Luca, two against one now! ;)

So I'll be sending v4 soon, with a separate API. Worrisomely, the amount
of comments seems to increase on every round :D

-Juuso

> johannes
> 


