Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54778 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab0F0TA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jun 2010 15:00:57 -0400
Received: by bwz10 with SMTP id 10so453267bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jun 2010 12:00:54 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
Date: Sun, 27 Jun 2010 21:00:22 +0200
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006241521.47623.helmut.schaa@googlemail.com> <201006251801.06209.helmut.schaa@googlemail.com> <1277626862.3684.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1277626862.3684.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006272100.22216.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Sonntag 27 Juni 2010 schrieb Johannes Berg:
> On Fri, 2010-06-25 at 18:01 +0200, Helmut Schaa wrote:
> > Am Donnerstag 24 Juni 2010 schrieb Johannes Berg:
> > >  b) You need to get a new beacon frame from mac80211 only when it
> > >     changes. You can do this from set_tim(). HOWEVER: since you're not
> > >     getting a new one from mac80211 all the time anyway, you NEED to
> > >     have the driver or firmware overwrite the DTIM count, like b43's
> > >     firmware for example will do.
> > 
> > And the broad- and multicast buffering also needs to be done in the driver
> > (when the fw/hw cannot handle it) as mac80211 uses its own DTIM count for
> > deciding when to "release" buffered frames to the driver.
> 
> Well, yes, but I don't get it. Are you trying to conjure a third way of
> doing things? How would you like it to work?
> 
> I don't understand why you expect to have a correct DTIM count field
> when you don't pull every beacon from mac80211.

rt2x00 pulls every beacon. But not directly _prior_ to transmission as the 
hw lacks an interrupt for that. Instead the next beacon gets pulled _after_
the beacondone interrupt (which is obviously triggered directly after the
beacon was sent). So, all TIM changes that happen during the next beacon
interval won't be included in the next beacon. Hence, rt2x00 also implements
the set_tim callback and updates the beacon through these as well.

This gives us a correct TIM but as I explained earlier breaks the DTIM
count (and thus bc/mc buffering which is done in mac80211 fot rt2x00).

One possible option to fix this in rt2x00 would be to delay the beacon
update (as it is already put on a workqueue we could simply replace it by
a delayed work) by beaconinterval - 10ms or something. But I'm not how
accurate that would be (and of course remove the set_tim callback).

Ivo, would that be an option you would agree on? On rt2800 we would simply
use the pretbtt interrupt and on older hardware trigger the beacon update
from a delayed work, and remove the set_tim callback?

> If you pull each beacon
> it's all correct. If you don't, you need to take care of everything DTIM
> related, there's simply no way to do it differently.

Yes, that's what I tried to understand when I wrote the first mail as I didn't
know enough about that part in mac80211.

> Does your device fill the DTIM count field or does it not? That's really
> the only thing you need to know, no?

The rt2x00 devices don't do any semantic changes to the beacon (only update
the timestamp). So basically the approach to update the beacon once during
each beacon interval would be the nicest solution. But due to the lack of a
suitable interrupt (on devices older then rt2800) rt2x00 does it as explained
above.

Helmut
