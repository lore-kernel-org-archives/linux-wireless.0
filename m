Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56998 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1KCJjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 05:39:07 -0400
Subject: Re: [PATCH] cfg80211: merge in beacon ies of hidden bss.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYhgeNg3CbDZg7GkJkq1ArJ=5n+bD=zPx=6ZFe7-Kj4Jmw@mail.gmail.com> (sfid-20111103_101806_675539_162704BA)
References: <CAMG6FYiV8F=MFBeUQCGSj__h=REVLMvTZCvLEvDPT7GP2KWsWw@mail.gmail.com>
	 <1320310524.3950.29.camel@jlt3.sipsolutions.net>
	 <CAMG6FYhgeNg3CbDZg7GkJkq1ArJ=5n+bD=zPx=6ZFe7-Kj4Jmw@mail.gmail.com>
	 (sfid-20111103_101806_675539_162704BA)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 10:39:01 +0100
Message-ID: <1320313141.3950.35.camel@jlt3.sipsolutions.net> (sfid-20111103_103921_040397_A763AD6A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

> >> +     if (!ie1 && !ie2)
> >> +             return 0;
> > I don't think it's valid to leave out the SSID IE, so I'd rather not
> > have that test here. It might interact badly with other uses (mesh?)
> >
> ie1 and ie2 could not NULL at the same time, otherwise the bss
> would be found in the first search attempt. However, I would prefer
> to have some water-proof check here. WARN_ON? BUG_ON?

Maybe a warning? But I don't see why it'll just fall through to the next
line and return -1 if one of them is missing.

> >> +             if (ie2[i + 2])
> >> +                     return -1;
> > I don't understand this loop. Why check that ie2 is zeroed, but check
> > only to the minlen of ie1, ie2?
> >
> Check that ie2 is zeroed is a check for hidden SSID.
> Check only to minlent to be in-line with cmp_ies().
> 
> >> +     return ie2[1] - ie1[1];
> > I'd error out much earlier if the length is different instead of
> > comparing to the minlen first.
> >
> Key comparator must use same algorithm in any rb-tree search function
> (order is important), otherwise ordering of items in the tree is broken
> and search gives incorrect results.
> This code uses same order as cmp_ies() does.

Oh. Good point. Add a comment?

> >> @@ -494,6 +578,13 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
> >>       spin_lock_bh(&dev->bss_lock);
> >>
> >>       found = rb_find_bss(dev, res);
> >> +     if (!found) {
> >> +             struct cfg80211_internal_bss *hidden;
> >> +
> >> +             hidden = rb_find_hidden_bss(dev, res);
> >> +             if (hidden)
> >> +                     merge_hidden_ies(res, hidden);
> >> +     }
> > I was going to complain that I don't understand why this works -- but
> > then I think now I do. If you move the code down into the else branch
> > it'll be much easier to follow.
> >
> Ok.
> 
> Thank you for review!

Eliad pointed out another thing: It is possible to have multiple SSIDs
hidden behind a single hidden SSID. Therefore, this should update all of
those BSS structs. Also, I'm a tad confused about the matching code
here, this code path executes for both received beacons and probe
responses, but probe responses would typically have found the BSS
already? But what if we only have a beacon and then receive a probe
response? Or vice versa? Some comments would be good outlining how that
works.

johannes

