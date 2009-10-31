Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:65288 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbZJaJga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 05:36:30 -0400
Received: by fg-out-1718.google.com with SMTP id 16so1931224fgg.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 02:36:34 -0700 (PDT)
Subject: Re: [PATCH 2/2] nl80211: allow to authenticate to access point
 that we already authenticated
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
In-Reply-To: <1256967840.3555.70.camel@johannes.local>
References: <1256939391.31271.11.camel@maxim-laptop>
	 <1256939694.31271.16.camel@maxim-laptop>
	 <1256967840.3555.70.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Oct 2009 11:36:29 +0200
Message-ID: <1256981789.3089.0.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-10-31 at 06:44 +0100, Johannes Berg wrote: 
> On Fri, 2009-10-30 at 23:54 +0200, Maxim Levitsky wrote:
> > >From 02be2525b95ec3c57323dda1a9e0c6da3a9817e6 Mon Sep 17 00:00:00 2001
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date: Fri, 30 Oct 2009 23:50:27 +0200
> > Subject: [PATCH 2/2] nl80211: allow to authenticate to access point that we already authenticated
> > 
> > This is permitted by standards, and used by driver_nl80211 of wpa_supplicant
> > Just start new authentication as if we weren't authenticated before
> 
> NACK. This leaks the auth request here and in mac80211, so we cannot do
> it this simply. Again though, the case you're running into should be
> fixed by that wpa_supplicant patch.

I was afraid of that... oh well thanks.

Best regards,
Maxim Levitsky

> 
> johannes
> 
> > ---
> >  net/wireless/mlme.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> > index 83c2a28..3d91b4e 100644
> > --- a/net/wireless/mlme.c
> > +++ b/net/wireless/mlme.c
> > @@ -372,7 +372,7 @@ int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
> >  		if (wdev->auth_bsses[i] &&
> >  		    memcmp(bssid, wdev->auth_bsses[i]->pub.bssid,
> >  						ETH_ALEN) == 0)
> > -			return -EALREADY;
> > +			wdev->auth_bsses[i] = NULL;
> >  	}
> >  
> >  	memset(&req, 0, sizeof(req));
> 


