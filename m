Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab2EKGj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 02:39:58 -0400
Message-ID: <1336718395.4310.3.camel@jlt3.sipsolutions.net> (sfid-20120511_084002_500462_209E8438)
Subject: Re: [RFC 1/2] mac80211: move ieee80211_set_channel function
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 11 May 2012 08:39:55 +0200
In-Reply-To: <4FACB379.2000001@tieto.com>
References: <20120510203021.240931880@sipsolutions.net>
	 <20120510203304.679354639@sipsolutions.net> <4FACB379.2000001@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-11 at 08:36 +0200, Michal Kazior wrote:
> Johannes Berg wrote:
> > +static int ieee80211_set_channel(struct wiphy *wiphy,
> > +				 struct net_device *netdev,
> > +				 struct ieee80211_channel *chan,
> > +				 enum nl80211_channel_type channel_type)
> > +{
> > +	struct ieee80211_local *local = wiphy_priv(wiphy);
> > +	struct ieee80211_sub_if_data *sdata = NULL;
> > +
> > +	if (netdev)
> > +		sdata = IEEE80211_DEV_TO_SUB_IF(netdev);
> > +
> > +	switch (ieee80211_get_channel_mode(local, NULL)) {
> > +	case CHAN_MODE_HOPPING:
> > +		return -EBUSY;
> > +	case CHAN_MODE_FIXED:
> > +		if (local->oper_channel != chan)
> > +			return -EBUSY;
> 
> 
> > +		if (!sdata&&  local->_oper_channel_type == channel_type)
> > +			return 0;
> 
> Do we need to keep this part? If not we could remove it in your:
>    [RFC] mac80211: clean up ieee80211_set_channel

I think we do need to keep it.

> I think we could even remove the whole `ieee80211_get_channel_mode` 
> thing now since we enforce interface combinations, right? We just need 
> to adjust the interface combinations verification to refuse mixing ibss 
> with anything else for the moment. That shouldn't be bad, or is it?

Somebody is going to complain if we never allow IBSS+anything any more
because IBSS has a fixed-channel mode in mac80211 which can cooperate
better.

johannes

