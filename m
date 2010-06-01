Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:52898 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab0FATxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 15:53:14 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1934929fga.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 12:53:13 -0700 (PDT)
Subject: Re: Path for fixed channel issue in aircrack-ng suite [V2]
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Farina <sidhayn@gmail.com>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Joker Joker <jokesareonyou@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1275419973.3634.7.camel@jlt3.sipsolutions.net>
References: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>
	 <1274775071.3635.4.camel@jlt3.sipsolutions.net>
	 <AANLkTilPIt59FhAuVlhisUR7QDabCtnZwahjxWbUysiG@mail.gmail.com>
	 <1274860275.3658.0.camel@jlt3.sipsolutions.net>
	 <4C000B68.9000305@gmail.com>  <1275416907.3778.11.camel@maxim-laptop>
	 <1275419973.3634.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 22:53:09 +0300
Message-ID: <1275421989.2574.12.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-01 at 21:19 +0200, Johannes Berg wrote: 
> On Tue, 2010-06-01 at 21:28 +0300, Maxim Levitsky wrote:
> 
> >     wireless: allow to retrieve the channel set on monitor interface
> >     
> >     This will allow to preserve compatibility with userspace
> >     
> >     Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > 
> > diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> > index b01a6f6..09d979b 100644
> > --- a/net/wireless/chan.c
> > +++ b/net/wireless/chan.c
> > @@ -49,9 +49,12 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
> >  {
> >  	struct ieee80211_channel *chan;
> >  	int result;
> > +	struct wireless_dev *mon_dev = NULL;
> >  
> > -	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
> > +	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR) {
> > +		mon_dev = wdev;
> >  		wdev = NULL;
> > +	}
> >  
> >  	if (wdev) {
> >  		ASSERT_WDEV_LOCK(wdev);
> > @@ -76,5 +79,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
> >  	if (wdev)
> >  		wdev->channel = chan;
> >  
> > +	if (mon_dev)
> > +		mon_dev->channel = chan;
> > +
> 
> This won't quite work. monitor interfaces are always slaves in the sense
> that their channel setting never takes precedence over anything, so if
> you add another interface and do something there, the hardware will
> happily channel switch away from the monitor channel, but it will still
> report the old channel here that you set.
> 
> I have no idea how to _properly_ fix this though, since eventually we'll
> have a situation where you can have multiple interfaces active on
> different channels, so that monitors don't have a fixed channel anyway.
> 
> Maybe this patch is sufficient since it works in the case people care
> about when they _only_ have a monitor interface, but I think it'd be
> nicer if it wouldn't report anything in the other cases.

Why?

We don't have any wireless devices that actually support using 2
channels independently.
Therefore user should be aware that if he sets channel on one interface,
and then on other, the last setting matters.
Of course the right fix would to make channel a global property of card
rather that of interface.

Best regards,
Maxim Levitsky

