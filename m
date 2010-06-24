Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33594 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0FXPvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 11:51:54 -0400
Subject: Re: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
In-Reply-To: <201006241521.47623.helmut.schaa@googlemail.com>
References: <201006241521.47623.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 17:51:54 +0200
Message-ID: <1277394714.3870.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-24 at 15:21 +0200, Helmut Schaa wrote:

> I've just reviewed the beacon handling in rt2x00 in AP mode and experienced
> some inconsistencies. The DTIM count is not correctly updated: sometimes
> multiple beacons are sent out using the same DTIM count.

Er, so there's your problem already.

> rt2x00 calls ieee80211_beacon_get_tim right after the current beacon was
> sent out to fetch the next one. However, rt2x00 also implements the set_tim
> callback and updates the beacon in each call to set_tim. As far as I
> understood the code in mac80211 the set_tim callback is called when the
> first frame for a powersaving station gets queued.
> 
> Since every call to ieee80211_beacon_get_tim updates the DTIM count the
> following can happen (assuming a DTIM period of 2):
> 
> - the hw sends out the current beacon (DTIM count == 0)
> - call to ieee80211_beacon_get_tim fetches the next beacon (DTIM count == 1)
> - the first frame for a PS STA gets queued -> set_tim
> - again call ieee80211_beacon_get_tim (DTIM count == 0)
> - hw sends out the beacon with incorrect DTIM count
> 
> A proper way of fixing this issue would be not to use the set_tim callback but
> just fetch the next beacon right before it gets send out (like ath* does).
> However, that's not easily possible with rt2x00 devices older then rt2800 as
> they only generate beacon_done interrupts (which is obviously too late for
> fetching the current beacon ;) ).
> 
> So, is the current implementation in rt2x00 supposed to work and mac80211
> needs fixing?
> 
> Could we add a parameter to ieee80211_beacon_get_tim that indicates if a _new_
> beacon should be generated or if the _current_ beacon should be updated in
> response to the set_tim callback?
> 
> Any other ideas?

No, your entire description makes no sense. There are two possibilities:

 a) You get a new beacon from mac80211 each time you send it. Then you
    don't have to worry about the set_tim() callback at all -- don't
    assign it!

 b) You need to get a new beacon frame from mac80211 only when it
    changes. You can do this from set_tim(). HOWEVER: since you're not
    getting a new one from mac80211 all the time anyway, you NEED to
    have the driver or firmware overwrite the DTIM count, like b43's
    firmware for example will do.

Ok so maybe there are more possibilities like the firmware filling the
TIM IE differently and you would use set_tim() differently then.

However, *fundamentally*, any time you don't get a new skb from mac80211
for each transmitted beacon you NEED to overwrite the DTIM count in it.

johannes

