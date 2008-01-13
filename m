Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:43633 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYAMNNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 08:13:43 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1857356fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 05:13:41 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Initialize vif pointer
Date: Sun, 13 Jan 2008 14:13:33 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200801131402.26165.IvDoorn@gmail.com> <1200229679.5887.3.camel@johannes.berg>
In-Reply-To: <1200229679.5887.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801131413.33372.IvDoorn@gmail.com> (sfid-20080113_131347_167284_52C9B2C0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 13 January 2008, Johannes Berg wrote:
> 
> On Sun, 2008-01-13 at 14:02 +0100, Ivo van Doorn wrote:
> > Before calling update_beacon() mac80211 must
> > initialize the control.vif pointer so it can
> > be used by the driver to determine which
> > interface is trying to send the beacon.
> 
> Good catch, thanks Ivo. I'd prefer if it was set a few lines lower
> though where all the other control members are initialised. Mind
> respinning? Feel free to add

Not a problem, I just discovered a second location where the
vif is uninitialized for beaconing so I was preparing a second patch already. :)

> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> 
> 
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> 
> > ---
> > 
> > diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> > index 4f5d5c6..8a35fed 100644
> > --- a/net/mac80211/ieee80211_sta.c
> > +++ b/net/mac80211/ieee80211_sta.c
> > @@ -2536,6 +2536,7 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
> >  		}
> >  
> >  		memset(&control, 0, sizeof(control));
> > +		control.vif = &sdata->vif;
> >  		rate_control_get_rate(dev, local->oper_hw_mode, skb, &ratesel);
> >  		if (!ratesel.rate) {
> >  			printk(KERN_DEBUG "%s: Failed to determine TX rate "
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 


