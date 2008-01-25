Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:19942 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1764196AbYAYIB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 03:01:58 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Fri, 25 Jan 2008 17:01:59 +0900
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ivo van Doorn <ivdoorn@gmail.com>
References: <20080118125252.6455.41047.stgit@one> <200801241226.28394.bruno@thinktube.com> <1201193704.3454.137.camel@johannes.berg>
In-Reply-To: <1201193704.3454.137.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801251701.59629.bruno@thinktube.com> (sfid-20080125_080217_687973_05861230)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008 01:55:04 Johannes Berg wrote:
> > i can see now how you could interpret this as only applying to timers,
> > but i think that does just not make sense - why would you want to sync
> > timers and adapt beacon intervals if you don't share the same BSSID?
>
> Hmm. Well I thought that was pretty much just for optimising performance
> but now that I think about it again...
>
> > i agree that the standard is quite ambigious when it comes to IBSS, but
> > practically speaking, it is necessary to merge IBSS cells most of the
> > time if you want to have IBSS working as expected. therefore i tend to
> > interpret the ambigious parts of the standard in a way that will improve
> > functionality.
>
> I think "working as expected" is stretching it a bit ;) How do you
> expect IBSS to work? 

i think it's a reasonable expectation from a users point of view that two or 
more IBSS nodes using the same ESSID on the same channel can communicate with 
each other, regardless of when and where they were configured.

> I'd expect only the simplest use case from it: 
> start IBSS on one station and have another one in the vicinity find it
> while scanning and join it. That works regardless of merging or not.

this is probably a valid, but a most conservative interpretation of the 
standard, which makes IBSS practically unusable in many (or most) occasions.

i guess you have never actually used IBSS much. otherwise you would know from 
experience that your simplest use case practically rarely happens. usually 
you have situations where you miss the others BSS while scanning and end up 
with 2 different BSSIDs. or what happens if there is a third station within 
station 2's reach but out of range for station 1? sta2 will adopt the BSSID 
of sta3, but sta1 will not and start a new BSSID. so not even your simplest 
use case of two newly started stations will just work (without ibss merge).
examples and scenarios are endless, do you want me to continue? ;)

also i am not inventing this "non-standard merge". it is *not* non-standard, 
it's just not directly obvious from reading the standard.

IBSS merges are done like this by various cards and drivers: prism54 does the 
same (in firmware), hostap driver did it like this (probably does but i 
haven't used it in quite a while), the broadcom driver in openwrt acts like 
this, madwifi merges like this (ups, maybe i shouldn't have said that ;)) and 
so on...

aren't there any other serious IBSS users out there who can support this case 
and confirm that we need IBSS merge functionality?

> > please see my last post where i suggest to use:
> >
> > +               if (rx_status->flag & RX_FLAG_TSFT)
> > +                       /* in order for correct IBSS merging we need
> > mactime*/ +                       mactime = rx_status->mactime;
> > +               else if (local && local->ops && local->ops->get_tsf)
> > +                       /* second best option: get current TSF */
> > +                       mactime =
> > local->ops->get_tsf(local_to_hw(local)); +               else
> > +                       /* can't merge without knowing the TSF */
> > +                       mactime = -1LLU;
> >
> > instead.
>
> Not sure. That's a bit on a fine line, if you have a slow device
> get_tsf() might be well off and this could trigger a BSSID change in
> both stations.

i don't see that problem: if get_tsf() is called very late on a slow device, 
it would be higher than the beacons TSF, and nothing would happen.
also usually the beacons TSF is quite old, maybe from an IBSS running for 
several hours or even days or weeks and therefore we would catch most 
situations where IBSS merge is necessary even if get_tsf() is a bit off the 
beacon reception time. but in order to be able to merge more correctly it 
would be better if these devices could get the TSF as early as possible.

regards,
bruno
