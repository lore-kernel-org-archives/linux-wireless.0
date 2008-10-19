Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:48604 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYJSSM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 14:12:29 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: Power saving on mac80211
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
	<87bpxh6t1n.fsf@nokia.com> <87y70l59p4.fsf@nokia.com>
	<1224412006.6324.45.camel@johannes.berg> <871vyc7st7.fsf@nokia.com>
	<1224434885.6324.49.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 19 Oct 2008 21:12:06 +0300
In-Reply-To: <1224434885.6324.49.camel@johannes.berg> (ext Johannes Berg's message of "Sun\, 19 Oct 2008 18\:48\:05 +0200")
Message-ID: <87myh0a1zd.fsf@nokia.com> (sfid-20081019_201240_775085_A6C8E1CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sun, 2008-10-19 at 14:00 +0300, Kalle Valo wrote:
>
>> > Then add a new flag to mac80211 hw description that says "driver will
>> > watch beacons". This means that the code above that rearms the timer for
>> > the future 'nothing from AP' check is skipped.
>> 
>> I will. I need to check that if the "firmware beacon watch" is enabled
>> only when PSM is enabled. If it is, we might have to make the flag
>> dynamic.
>
> IIRC it's a separate flag.

Very good, that would be the best way.

>>  There isn't any
>> timeout for delivering beacons to the host, if the data path is idle
>> for 24 hours, mac80211 will not receive any beacons for the 24 hours.
>> I don't see why we need a timeout here.
>
> Right. But we need to program the chip to tell the chip "hey please tell
> me if you haven't seen a beacon in X seconds".

Ah, you mean that timeout. Sorry, I forgot that one altogether. Yes,
we definitely need that timeout.

>> I believe that there's also a feature in stlc4560 that the driver can
>> provide a checksum of the beacon and the firmware will send the beacon
>> if checksum doesn't match. But I don't yet know how that works in
>> practise.
>
> It seems to be a firmware feature, first beacon from the BSS the
> firmware computes the checksum, and if it changes it lets the beacon go
> through and re-computes the checksum, so you see all beacon changes.

So the driver doesn't have to compute any checksums itself? That makes
things easy then.

> Maybe it excludes the TIM.

It should. Otherwise beacon filtering in a crowded network with
clients in PSM would be next to useless. And I didn't see any major
increase in power consumption at Maemo Summit :)

> I think we want this for when the QoS parameters or something else
> changes.

Yeah. Just out of curiosity, are there any other parameters which
mac80211 needs to follow? Short preamble? Short slot time? Anything
else?

-- 
Kalle Valo
