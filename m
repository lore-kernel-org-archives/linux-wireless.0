Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:59288 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0H3Phb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 11:37:31 -0400
Received: by pxi10 with SMTP id 10so2118367pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 08:37:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283177949.3691.72.camel@jlt3.sipsolutions.net>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com> <1283177949.3691.72.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 30 Aug 2010 08:37:11 -0700
Message-ID: <AANLkTinOzTHn4okTdm=321sdAKy8z1ji_1K_SsDd_dH2@mail.gmail.com>
Subject: Re: [RFC 0/3] mac80211: new API for handling broadcast / multicast on
 sw scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 30, 2010 at 7:19 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2010-08-28 at 03:13 -0400, Luis R. Rodriguez wrote:
>> mac80211's sw scan doesn't play nice with buffered broadcast and
>> multicast frames. Since drivers are required to keep track of the DTIM
>> count
>
> I said they were required for powersave, not necessarily for scanning.

Its also the case for scanning. We currently don't even check for the
ACK for the scanning nullfunc. It something my patches will address as
well.

>> this series provides some new basic functionality to let drivers
>> help mac80211 make more prudent decisions for sw scan.
>
> I'm not convinced of this. Why does this need to be so complicated?

See below for more details. Apart from the DTIM synch wait constraints
for drivers which do sw scan will vary, you either need something like
a wait constraint callback or as I see it you move all the
synchronization to mac80211. The later requires quite a bit of work
and I see it as necessary for the long run.

> Also, some of your comments seem like you're confused about being an AP
> vs. being associated to one?

Like?

> What are you actually trying to achieve?

The current sw code simply follows the listen interval, it in no way
respect the DTIM. What this means is you loose the buffered multicast
and broadcast frames the AP saves up for you after the DTIM beacon.
Apart from ensuring you awake at the DTIM count you then also have to
ensure you stay awake for all the multicast / broadcast data after the
DTIM. It was my understanding you were postulating that all this is a
requirement for the drivers to do properly given that mac80211 is too
slow to do it properly. ath9k already has code to do exactly this.
What you then need is way for ath9k to communicate to mac80211 it
cannot go into a sw scan as it may be waiting for the DTIM beacon, and
other reasons like a beacon synch to synchronize the TSF.

> It seems mac80211 can, no
> matter what the driver is
>  - wait for DTIM beacons, and the end of mcast traffic, before going off
>   channel (should be relevant for p2p as well)

I do not deny this is not possible, I was following your statements
about mac80211 being too slow to handle this, so was relying more on
the driver to achieve this. I actually believe this should go into
mac80211 but its not there yet. ath9k also has its own nullfunc
requirements handled for the ath9k vritual wiphy stuff so either way
you still have some private uses for the nullfunc frames. I rather
take this up in steps in mac80211.

>  - attempt to do better wrt. scheduling between DTIM, by scheduling
>   closer (but if DTIM period is 1, this may fail)

To do this you still need to handle all the different sorts of code
paths for nullfuncs and ensure they are ACK'd. You have the private
ath9k virtual wiphy too.. which I rather see removed but we have no
alternative to replace it yet do we?

>  - subject to the driver advertising guaranteed TX status, it can also
>   wait for the nullfunc ACK -- you should also implement flush which
>   will probably improve things by itself for ath9k

Sure, I have some patches for that as well. The nullfunc ACK wait for
the offchannel operation *can* be handled indeed by mac80211, as my
latest comments indicate. But note we'd have to categorize the
different types of uses for the nullfuncs. We also have some private
driver uses of nullfuncs such as the ath9k virtual wiphy.

Then -- you also have other synch wait considerations to address which
are also currently only private to the driver. ath9k has these:

+       wait_for = PS_WAIT_FOR_BEACON |
+                  PS_BEACON_SYNC |
+                  PS_WAIT_FOR_CAB |
+                  PS_WAIT_FOR_PSPOLL_DATA |
+                  PS_WAIT_FOR_TX_ACK |
+                  PS_NULLFUNC_COMPLETED;

Of those I see an easy way to move to mac80211 the
PS_NULLFUNC_COMPLETED except for the private driver usage for
ath9k_send_nullfunc(). The others require either some new API or as I
put it, a driver callback for wait constraints. As I see it, I think
these all of these *should* be moved to mac80211, but I don't expect
to do this all in one shot and think its better to do address them one
at a time.

> The other things in your patch set I don't understand, but those I think
> should be done more generically?

That is the goal.

  Luis
