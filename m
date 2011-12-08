Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5391 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1LHIft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 03:35:49 -0500
Date: Thu, 8 Dec 2011 14:03:00 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Fix race in bss timeout
Message-ID: <20111208083258.GA15103@chvasanth-lnx> (sfid-20111208_093552_818761_E7EA07D4)
References: <1323270687-5989-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1323271070.3404.40.camel@jlt3.sipsolutions.net>
 <20111207153052.GB12498@chvasanth-lnx>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20111207153052.GB12498@chvasanth-lnx>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2011 at 09:00:53PM +0530, Vasanthakumar Thiagarajan wrote:
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

Wait, actually we are not leaking the bss reference if we return
after a successful roam notification. The reference to the current
bss is released whenever we disconnect from it.

Vasanth
> 
