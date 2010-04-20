Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:35609 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0DTFA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 01:00:58 -0400
Subject: Re: [RFC PATCHv3 2/2] cfg80211: Remove default dynamic PS timeout
 value
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1271688229.23671.2.camel@jlt3.sipsolutions.net>
References: <1271409274-17162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271409274-17162-3-git-send-email-juuso.oikarinen@nokia.com>
	 <1271688229.23671.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 07:58:28 +0300
Message-ID: <1271739508.6205.5712.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-19 at 16:43 +0200, ext Johannes Berg wrote:
> On Fri, 2010-04-16 at 12:14 +0300, Juuso Oikarinen wrote:
> > Now that the mac80211 is choosing dynamic ps timeouts based on the ps-qos
> > network latency configuration, configure a default value of -1 as the dynamic
> > ps timeout in cfg80211. This value allows the mac80211 to determine the value
> > to be used.
> > 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> >  net/wireless/core.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/wireless/core.c b/net/wireless/core.c
> > index 6ac70c1..37d0e0a 100644
> > --- a/net/wireless/core.c
> > +++ b/net/wireless/core.c
> > @@ -705,7 +705,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
> >  			wdev->ps = true;
> >  		else
> >  			wdev->ps = false;
> > -		wdev->ps_timeout = 100;
> > +		/* allow mac80211 to determine the timeout */
> > +		wdev->ps_timeout = -1;
> >  		if (rdev->ops->set_power_mgmt)
> >  			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
> >  						      wdev->ps,
> 
> Does that need some API doc updates to indicate, as part of the cfg80211
> API, that -1 means some way of setting it by default?
> 
> Or actually, wouldn't it make sense to move the pm_qos logic here (into
> cfg80211)?

I thought about that but then I realised that would contradict with one
of the arguments presented against the dynamic ps API I proposed
earlier. The argument specifically stated we don't want the API as in
the future there will be some uber-cool psm implementations in some
(full-mac?) chipsets that don't even use a value like this.

Therefore I opted to leave the implementation in mac80211, thinking that
the entire configuration option will be removed from the cfg80211 once
the wext is gone.

-Juuso

> johannes
> 


