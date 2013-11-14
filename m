Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab3KNODC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 09:03:02 -0500
Message-ID: <1384437774.13941.25.camel@jlt4.sipsolutions.net> (sfid-20131114_150307_611218_2962FD19)
Subject: Re: [RFC 1/5] cfg80211: pass the wdev on the country IE regulatory
 hint
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 14 Nov 2013 15:02:54 +0100
In-Reply-To: <20131114140505.GA19070@garbanzo.do-not-panic.com> (sfid-20131114_145433_171662_3597550D)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384366379-25301-2-git-send-email-mcgrof@do-not-panic.com>
	 <1384377637.28806.14.camel@jlt4.sipsolutions.net>
	 <20131114140505.GA19070@garbanzo.do-not-panic.com>
	 (sfid-20131114_145433_171662_3597550D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-14 at 06:05 -0800, Luis R. Rodriguez wrote:

> > > -void regulatory_hint_country_ie(struct wiphy *wiphy, enum ieee80211_band band,
> > > +void regulatory_hint_country_ie(struct wireless_dev *wdev,
> > > +				enum ieee80211_band band,
> > >  				const u8 *country_ie, u8 country_ie_len)
> > ...
> > > +       request->wdev = wdev;
> > > 
> > You have absolutely no validation of this pointer - the lifetime of the
> > request object and the wdev aren't necessarily the same.
> 
> Agreed.
> 
> > At least you should very carefully document that this pointer is a
> > cookie (if it really is) and must never be dereferenced.
> 
> OK, I could also validate it upon processing but we'd need to loop
> over the rdev wdev list for the country IE hint, if that is acceptable
> upon procesing it'd be valid and we'd avoid corner case issues.
> Thoughts?

As far as I can tell you already don't use it in any other way but a
cookie pointer, comparing while iterating the then-current list of
wdevs. But that's kinda unsafe. Might also be worth just making it a
void* to avoid people trying to use it.

johannes

