Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33508 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3KNNyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 08:54:31 -0500
Received: by mail-pa0-f45.google.com with SMTP id kx10so1336949pab.18
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 05:54:30 -0800 (PST)
Date: Thu, 14 Nov 2013 06:05:10 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/5] cfg80211: pass the wdev on the country IE regulatory
 hint
Message-ID: <20131114140505.GA19070@garbanzo.do-not-panic.com> (sfid-20131114_145434_112699_5057E336)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-2-git-send-email-mcgrof@do-not-panic.com>
 <1384377637.28806.14.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384377637.28806.14.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 13, 2013 at 10:20:37PM +0100, Johannes Berg wrote:
> On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
> > This also records the wdev on the last regulatory request,
> > this can be used later to help quiesce wdev's at appropriate
> > times by the regulatory core.
> 
> > +++ b/net/wireless/reg.c
> > @@ -1871,12 +1871,14 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
> >  }
> >  EXPORT_SYMBOL(regulatory_hint);
> >  
> > -void regulatory_hint_country_ie(struct wiphy *wiphy, enum ieee80211_band band,
> > +void regulatory_hint_country_ie(struct wireless_dev *wdev,
> > +				enum ieee80211_band band,
> >  				const u8 *country_ie, u8 country_ie_len)
> ...
> > +       request->wdev = wdev;
> > 
> You have absolutely no validation of this pointer - the lifetime of the
> request object and the wdev aren't necessarily the same.

Agreed.

> At least you should very carefully document that this pointer is a
> cookie (if it really is) and must never be dereferenced.

OK, I could also validate it upon processing but we'd need to loop
over the rdev wdev list for the country IE hint, if that is acceptable
upon procesing it'd be valid and we'd avoid corner case issues.
Thoughts?

  Luis
