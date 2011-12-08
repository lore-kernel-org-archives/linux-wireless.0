Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41071 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1LHIiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 03:38:25 -0500
Subject: Re: [PATCH] cfg80211: Fix race in bss timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20111208083258.GA15103@chvasanth-lnx>
References: <1323270687-5989-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1323271070.3404.40.camel@jlt3.sipsolutions.net>
	 <20111207153052.GB12498@chvasanth-lnx>
	 <20111208083258.GA15103@chvasanth-lnx>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 09:38:18 +0100
Message-ID: <1323333498.3332.5.camel@jlt3.sipsolutions.net> (sfid-20111208_093828_503165_E23814AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-08 at 14:03 +0530, Vasanthakumar Thiagarajan wrote:
> On Wed, Dec 07, 2011 at 09:00:53PM +0530, Vasanthakumar Thiagarajan wrote:
> > > >  	nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), wdev->netdev, bssid,
> > > >  			    req_ie, req_ie_len, resp_ie, resp_ie_len,
> > > >  			    GFP_KERNEL);
> > > > @@ -615,40 +612,65 @@ void __cfg80211_roamed(struct wireless_dev *wdev,
> > > >  	wdev->wext.prev_bssid_valid = true;
> > > >  	wireless_send_event(wdev->netdev, SIOCGIWAP, &wrqu, NULL);
> > > >  #endif
> > > > +
> > > > +	return;
> > > > +out:
> > > > +	if (bss)
> > > > +		cfg80211_put_bss(bss);
> > > >  }
> > > 
> > > Doesn't that leak the reference if you return? It'll also give you an
> > > smatch warning since the function assumes the "bss" pointer that was
> > > passed in is not NULL, no?
> > 
> > Oops, sorry, i'll fix it. I may need to run smatch as well.
> 
> Wait, actually we are not leaking the bss reference if we return
> after a successful roam notification. The reference to the current
> bss is released whenever we disconnect from it.

Oh, sorry! Yes, you're right, we should keep the reference unless we
failed the function for some reason.

johannes

