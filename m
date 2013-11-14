Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:65395 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3KNPBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 10:01:25 -0500
Received: by mail-pa0-f48.google.com with SMTP id bj1so2163868pad.7
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 07:01:23 -0800 (PST)
Date: Thu, 14 Nov 2013 07:12:04 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/5] cfg80211: pass the wdev on the country IE regulatory
 hint
Message-ID: <20131114151159.GA29954@garbanzo.do-not-panic.com> (sfid-20131114_160134_415310_52EC2591)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-2-git-send-email-mcgrof@do-not-panic.com>
 <1384377637.28806.14.camel@jlt4.sipsolutions.net>
 <20131114140505.GA19070@garbanzo.do-not-panic.com>
 <1384437774.13941.25.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384437774.13941.25.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 14, 2013 at 03:02:54PM +0100, Johannes Berg wrote:
> On Thu, 2013-11-14 at 06:05 -0800, Luis R. Rodriguez wrote:
> 
> > > > -void regulatory_hint_country_ie(struct wiphy *wiphy, enum ieee80211_band band,
> > > > +void regulatory_hint_country_ie(struct wireless_dev *wdev,
> > > > +				enum ieee80211_band band,
> > > >  				const u8 *country_ie, u8 country_ie_len)
> > > ...
> > > > +       request->wdev = wdev;
> > > > 
> > > You have absolutely no validation of this pointer - the lifetime of the
> > > request object and the wdev aren't necessarily the same.
> > 
> > Agreed.
> > 
> > > At least you should very carefully document that this pointer is a
> > > cookie (if it really is) and must never be dereferenced.
> > 
> > OK, I could also validate it upon processing but we'd need to loop
> > over the rdev wdev list for the country IE hint, if that is acceptable
> > upon procesing it'd be valid and we'd avoid corner case issues.
> > Thoughts?
> 
> As far as I can tell you already don't use it in any other way but a
> cookie pointer, comparing while iterating the then-current list of
> wdevs.

I confirm.

> But that's kinda unsafe. Might also be worth just making it a
> void* to avoid people trying to use it.

OK. I can see the cookie in theory race against the allocator
releasing and creating a new wdev and it magically being
the same pointer, but chances are really low of that.

 Luis
