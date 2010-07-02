Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37878 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884Ab0GBSAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:00:24 -0400
Received: by bwz1 with SMTP id 1so1734976bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jul 2010 11:00:23 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
Date: Fri, 2 Jul 2010 19:59:45 +0200
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006241521.47623.helmut.schaa@googlemail.com> <201006272100.22216.helmut.schaa@googlemail.com> <1278090770.15412.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1278090770.15412.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201007021959.45704.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag 02 Juli 2010 schrieb Johannes Berg:
> On Sun, 2010-06-27 at 21:00 +0200, Helmut Schaa wrote:
> 
> > rt2x00 pulls every beacon. But not directly _prior_ to transmission as the 
> > hw lacks an interrupt for that. Instead the next beacon gets pulled _after_
> > the beacondone interrupt (which is obviously triggered directly after the
> > beacon was sent). So, all TIM changes that happen during the next beacon
> > interval won't be included in the next beacon. Hence, rt2x00 also implements
> > the set_tim callback and updates the beacon through these as well.
> > 
> > This gives us a correct TIM but as I explained earlier breaks the DTIM
> > count (and thus bc/mc buffering which is done in mac80211 fot rt2x00).
> > 
> > One possible option to fix this in rt2x00 would be to delay the beacon
> > update (as it is already put on a workqueue we could simply replace it by
> > a delayed work) by beaconinterval - 10ms or something. But I'm not how
> > accurate that would be (and of course remove the set_tim callback).
> 
> Well, after a beacon is before a beacon.

Yes ;)

> I think iwlwifi also pulls the
> next beacon after the previous one was sent. That just means you get a
> potential higher delay, 

Agreed.

> but otherwise it doesn't really matter that
> much. You'll never be able to close the race fully anyway,

No, but I'd like to get as close as possible. The idea with the delayed
work was intended to reduce the latency as good as we can.

> unless your
> device itself is capable of generating the TIM IE _right before_ the
> beacon gets transmitted.

Agreed. At least on rt2800 we can use the pre tbtt interrupt to update the
beacon just before it is sent out.

> Therefore, with standard beacon intervals of 100 TU, I don't think it
> matters all that much whether it's before or after?

Yeah, maybe that's just fine. I guess I'll just drop the set_tim callback
from all rt2x00 pci variants and implement the pre tbtt interrupt on rt2800.

Thanks,
Helmut
