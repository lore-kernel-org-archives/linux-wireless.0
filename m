Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42048 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab0GBRMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 13:12:52 -0400
Subject: Re: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
In-Reply-To: <201006272100.22216.helmut.schaa@googlemail.com>
References: <201006241521.47623.helmut.schaa@googlemail.com>
	 <201006251801.06209.helmut.schaa@googlemail.com>
	 <1277626862.3684.3.camel@jlt3.sipsolutions.net>
	 <201006272100.22216.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Jul 2010 19:12:50 +0200
Message-ID: <1278090770.15412.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-06-27 at 21:00 +0200, Helmut Schaa wrote:

> rt2x00 pulls every beacon. But not directly _prior_ to transmission as the 
> hw lacks an interrupt for that. Instead the next beacon gets pulled _after_
> the beacondone interrupt (which is obviously triggered directly after the
> beacon was sent). So, all TIM changes that happen during the next beacon
> interval won't be included in the next beacon. Hence, rt2x00 also implements
> the set_tim callback and updates the beacon through these as well.
> 
> This gives us a correct TIM but as I explained earlier breaks the DTIM
> count (and thus bc/mc buffering which is done in mac80211 fot rt2x00).
> 
> One possible option to fix this in rt2x00 would be to delay the beacon
> update (as it is already put on a workqueue we could simply replace it by
> a delayed work) by beaconinterval - 10ms or something. But I'm not how
> accurate that would be (and of course remove the set_tim callback).

Well, after a beacon is before a beacon. I think iwlwifi also pulls the
next beacon after the previous one was sent. That just means you get a
potential higher delay, but otherwise it doesn't really matter that
much. You'll never be able to close the race fully anyway, unless your
device itself is capable of generating the TIM IE _right before_ the
beacon gets transmitted.

Therefore, with standard beacon intervals of 100 TU, I don't think it
matters all that much whether it's before or after?

johannes

