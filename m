Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:33822 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYJSLBV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 07:01:21 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: Power saving on mac80211
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
	<87bpxh6t1n.fsf@nokia.com> <87y70l59p4.fsf@nokia.com>
	<1224412006.6324.45.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 19 Oct 2008 14:00:52 +0300
In-Reply-To: <1224412006.6324.45.camel@johannes.berg> (ext Johannes Berg's message of "Sun\, 19 Oct 2008 12\:26\:46 +0200")
Message-ID: <871vyc7st7.fsf@nokia.com> (sfid-20081019_130126_463874_4E4FAC5A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sun, 2008-10-19 at 10:24 +0300, Kalle Valo wrote:
>
>> Oh, I forgot about beacon filtering. stlc45xx firmware (but no support
>> in driver yet) supports beacon filtering in PSM mode, meaning that the
>> beacons are not delivered to the host (not even DTIM beacons). This
>> improves power consumption because the host CPU is not woken up all
>> the time.
>> 
>> I'm sure that stlc4560 isn't the only chip supporting this feature
>> because it's quite essential in low power devices. I have been
>> planning to implement support to mac80211 in the near future. Though
>> don't know yet what is needed, I haven't investigated this at all.
>
> I thought about it recently, it's fairly easy.

Marvellous :)

> As a preliminary step, I'd change mac80211 to not trigger the timer
> continuously, but rather reset it ever time we get a beacon from the AP,
> so that the timer only fires when we haven't seen a beacon for too long.
> This helps with powersave already because then we only wake up for
> beacons, not for the timer too.

This makes sense, all extra timers are bad. I'll try come up with a
patch next week.

> Then add a new flag to mac80211 hw description that says "driver will
> watch beacons". This means that the code above that rearms the timer for
> the future 'nothing from AP' check is skipped.

I will. I need to check that if the "firmware beacon watch" is enabled
only when PSM is enabled. If it is, we might have to make the flag
dynamic.

> Also add a way for mac80211 to tell the driver after how many beacons
> (or calculate the timeout in ms, it's convertible) it should tell
> mac80211 about the situation. Finally, to make it possible to have the
> driver tell mac80211, extend the MLME callback (ieee80211_notify_mac)

The beacon filtering in stlc4560 works so that a beacon is passed to
the host only when the TIM bit for the AID is set. There isn't any
timeout for delivering beacons to the host, if the data path is idle
for 24 hours, mac80211 will not receive any beacons for the 24 hours.
I don't see why we need a timeout here.

I believe that there's also a feature in stlc4560 that the driver can
provide a checksum of the beacon and the firmware will send the beacon
if checksum doesn't match. But I don't yet know how that works in
practise.

-- 
Kalle Valo
