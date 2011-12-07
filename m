Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46025 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab1LGPb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 10:31:27 -0500
Date: Wed, 7 Dec 2011 21:00:53 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Fix race in bss timeout
Message-ID: <20111207153052.GB12498@chvasanth-lnx> (sfid-20111207_163134_387992_E9FF4469)
References: <1323270687-5989-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1323271070.3404.40.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1323271070.3404.40.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2011 at 04:17:50PM +0100, Johannes Berg wrote:
> On Wed, 2011-12-07 at 20:41 +0530, Vasanthakumar Thiagarajan wrote:
> 
> > +	spin_lock_bh(&dev->bss_lock);
> > +	memcpy(bssid, bss->bssid, ETH_ALEN);
> > +	spin_unlock_bh(&dev->bss_lock);
> 
> I don't think this is necessary.

Right, i don't see any race either.

> 
> >  	nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), wdev->netdev, bssid,
> >  			    req_ie, req_ie_len, resp_ie, resp_ie_len,
> >  			    GFP_KERNEL);
> > @@ -615,40 +612,65 @@ void __cfg80211_roamed(struct wireless_dev *wdev,
> >  	wdev->wext.prev_bssid_valid = true;
> >  	wireless_send_event(wdev->netdev, SIOCGIWAP, &wrqu, NULL);
> >  #endif
> > +
> > +	return;
> > +out:
> > +	if (bss)
> > +		cfg80211_put_bss(bss);
> >  }
> 
> Doesn't that leak the reference if you return? It'll also give you an
> smatch warning since the function assumes the "bss" pointer that was
> passed in is not NULL, no?

Oops, sorry, i'll fix it. I may need to run smatch as well.

> 
> > +static void cfg80211_roamed_bss(struct net_device *dev,
> > +				struct cfg80211_bss *bss, const u8 *req_ie,
> > +				size_t req_ie_len, const u8 *resp_ie,
> > +				size_t resp_ie_len, gfp_t gfp)
> >  {
> >  	struct wireless_dev *wdev = dev->ieee80211_ptr;
> >  	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
> >  	struct cfg80211_event *ev;
> >  	unsigned long flags;
> >  
> > -	CFG80211_DEV_WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTED);
> >  
> >  	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
> 
> Why remove that warning? Also maybe do something like
> 
> 	if (WARN_ON(!bss))
> 		return;
> 
> (before allocating memory)

These warnings are added in cfg80211_roamed().

Thanks!

Vasanth
