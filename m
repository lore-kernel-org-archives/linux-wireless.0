Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38459 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYKEVG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 16:06:28 -0500
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, "Felix Fietkau" <nbd@openwrt.org>
Subject: Re: Thoughts about mac80211 client PS implementation
References: <87k5bhkjf1.fsf@nokia.com>
	<1225917235.3619.180.camel@johannes.berg>
	<43e72e890811051243y65f8b51cy2f80279ecbebc8e4@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 05 Nov 2008 23:06:11 +0200
In-Reply-To: <43e72e890811051243y65f8b51cy2f80279ecbebc8e4@mail.gmail.com> (ext Luis R. Rodriguez's message of "Wed\, 5 Nov 2008 12\:43\:06 -0800")
Message-ID: <87bpwtkhmk.fsf@nokia.com> (sfid-20081105_220630_753339_9808157A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@gmail.com> writes:

> On Wed, Nov 5, 2008 at 12:33 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Wed, 2008-11-05 at 22:27 +0200, Kalle Valo wrote:
>
> BTW who defines "Dynamic Power Save"?

No idea, we have been just using that name internally.

> Is there a standard approach or more an implementation approach to
> the concept of doing PS while active?

AFAIK the standard only talks about the part which I call "static PS",
that is PS-Polling frames from the AP. It doesn't mention anything
about when enabling and disabling it, unfortunately.

>>> PS should be disabled while associated and running software scan, and
>>> naturally re-enabled after the scan has finished. I assume hardware
>>> scanning implementations are clever enough to disable PS when scanning
>>> and we don't have to worry about that case.
>
> BTW we need to check if in ath5k/ath9k if the beacon miss interrupt
> will actually be triggered *if* the beacon filter is *off*. Not sure
> about this yet. Also I'm not sure if triggering scanning will enable
> beaconing filter in our hardware if its off and then disable it after
> scanning too.

Actually beacon filtering is a different subject from 802.11 Power
Save. Beacon filtering improves the host's (CPU) power consumption (by
reducing it's wakeups) and 802.11 PS improves the power consumption of
the wireless chip (by reducing the time transceiver is enabled). In
other words, we can enable Power Save but still the host can receive
all the beacons.

Beacon filtering is next on my agenda as soon as I can finish the
Power Save part.

-- 
Kalle Valo
