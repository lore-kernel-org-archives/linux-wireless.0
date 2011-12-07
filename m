Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53311 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab1LGPhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 10:37:35 -0500
Subject: Re: [PATCH] cfg80211: Fix race in bss timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20111207153052.GB12498@chvasanth-lnx>
References: <1323270687-5989-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1323271070.3404.40.camel@jlt3.sipsolutions.net>
	 <20111207153052.GB12498@chvasanth-lnx>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 16:37:28 +0100
Message-ID: <1323272248.3404.43.camel@jlt3.sipsolutions.net> (sfid-20111207_163739_053267_DC795E90)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-07 at 21:00 +0530, Vasanthakumar Thiagarajan wrote:

> > >  	nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), wdev->netdev, bssid,
> > >  			    req_ie, req_ie_len, resp_ie, resp_ie_len,
> > >  			    GFP_KERNEL);
> > > @@ -615,40 +612,65 @@ void __cfg80211_roamed(struct wireless_dev *wdev,
> > >  	wdev->wext.prev_bssid_valid = true;
> > >  	wireless_send_event(wdev->netdev, SIOCGIWAP, &wrqu, NULL);
> > >  #endif
> > > +
> > > +	return;
> > > +out:
> > > +	if (bss)
> > > +		cfg80211_put_bss(bss);
> > >  }
> > 
> > Doesn't that leak the reference if you return? It'll also give you an
> > smatch warning since the function assumes the "bss" pointer that was
> > passed in is not NULL, no?
> 
> Oops, sorry, i'll fix it. I may need to run smatch as well.

No need to run smatch -- but the function does assume that the bss
pointer passed in is not NULL, so it should never need to check if it's
NULL (never mind the fact that you can pass NULL to put_bss too)

> > > +static void cfg80211_roamed_bss(struct net_device *dev,
> > > +				struct cfg80211_bss *bss, const u8 *req_ie,
> > > +				size_t req_ie_len, const u8 *resp_ie,
> > > +				size_t resp_ie_len, gfp_t gfp)
> > >  {
> > >  	struct wireless_dev *wdev = dev->ieee80211_ptr;
> > >  	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
> > >  	struct cfg80211_event *ev;
> > >  	unsigned long flags;
> > >  
> > > -	CFG80211_DEV_WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTED);
> > >  
> > >  	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
> > 
> > Why remove that warning? Also maybe do something like
> > 
> > 	if (WARN_ON(!bss))
> > 		return;
> > 
> > (before allocating memory)
> 
> These warnings are added in cfg80211_roamed().

But this can be called directly by the driver with a NULL BSS.

Ohh. I see what you did, you didn't allow drivers calling this now. I
think you should export this function still since otherwise the race
windows might get tiny, but isn't actually completely closed (the first
get_bss() might find it, the next a millisecond later not)

johannes

