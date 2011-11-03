Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36071 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1KCKNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 06:13:16 -0400
Subject: Re: [PATCH] cfg80211: merge in beacon ies of hidden bss.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYjQWc2fXDM8eWpEi7OqS+tVfjh5onf_332R3pzq8ks0aQ@mail.gmail.com> (sfid-20111103_110403_472262_9290A6A0)
References: <CAMG6FYiV8F=MFBeUQCGSj__h=REVLMvTZCvLEvDPT7GP2KWsWw@mail.gmail.com>
	 <1320310524.3950.29.camel@jlt3.sipsolutions.net>
	 <CAMG6FYhgeNg3CbDZg7GkJkq1ArJ=5n+bD=zPx=6ZFe7-Kj4Jmw@mail.gmail.com>
	 <1320313141.3950.35.camel@jlt3.sipsolutions.net>
	 <CAMG6FYjQWc2fXDM8eWpEi7OqS+tVfjh5onf_332R3pzq8ks0aQ@mail.gmail.com>
	 (sfid-20111103_110403_472262_9290A6A0)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 11:13:05 +0100
Message-ID: <1320315185.3950.40.camel@jlt3.sipsolutions.net> (sfid-20111103_111319_072824_B23120C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> -1 means "lesser", which is not true if both of ies are absent.
> 0 means "equal", which is correct (but logically impossible with the
> current usage of the comparator). Now I think even WARN_ON is a bad
> idea, the comparator can be reused for other purposes when both
> SSID ies are missing.

Fair enough. Maybe a comment along the lines of
/* can't really happen, but they're the same then */

would be useful.

> > Eliad pointed out another thing: It is possible to have multiple SSIDs
> > hidden behind a single hidden SSID. Therefore, this should update all of
> > those BSS structs. Also, I'm a tad confused about the matching code
> > here, this code path executes for both received beacons and probe
> > responses, but probe responses would typically have found the BSS
> > already? But what if we only have a beacon and then receive a probe
> > response? Or vice versa? Some comments would be good outlining how that
> > works.
> >
> I will add some comments in the code. Is a word, the code searches for a beacon
> of the hidden BSS and copies beacon IEs (with nullified SSID) into the probe
> response bss entry (with real SSID). It works fine in case of multi-SSID hidden
> BSS too.

Right, that should work.

> > Or vice versa?
> It will not work. Update of beacon IEs of probe response is not implemented.
> The code is not trying to update existing probe response bss entries when beacon
> IEs are getting changed. Technically it's possible to update them, but
> I think it's a bit
> overkill, I'm addressing only PSM in this commit.

I think that would actually be useful too since userspace may obtain
this data from scan results at any point in time, and might expect
up-to-date information? Could be a separate patch though.

Anyway, comments indicating what happens and which case this handles
would be great.

Thanks!

johannes

