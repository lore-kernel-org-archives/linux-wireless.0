Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:40024 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYKDG7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 01:59:12 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: No ProbeResp - assume out of range
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
	<200811022303.54476.mb@bu3sch.de>
	<1ba2fa240811021442o178c98a1pa920b863b60d9293@mail.gmail.com>
	<43e72e890811021458h1444d350v33a5e5b984b76495@mail.gmail.com>
	<20081103002558.GA14153@tesla> <490F2B6C.9090002@openwrt.org>
	<1225734605.3619.39.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 04 Nov 2008 08:58:25 +0200
In-Reply-To: <1225734605.3619.39.camel@johannes.berg> (ext Johannes Berg's message of "Mon\, 03 Nov 2008 18\:50\:05 +0100")
Message-ID: <87tzaoasfi.fsf@nokia.com> (sfid-20081104_075920_958161_9115E997)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2008-11-03 at 17:48 +0100, Felix Fietkau wrote:
>> Luis R. Rodriguez wrote:
>> > OK I found the issue with ath5k, no beacons were being passed at all, I'll post
>> > a patch.
>> Why not configure the beacon miss interrupt instead of passing beacons to
>> mac80211 in STA mode? That should save some battery on Laptops because it 
>> won't cause 10 extra wakeups every second.
>
> We have no way to indicate to mac80211 that the hw is watching beacons,
> so that'd be equivalent to just dropping them. We've discussed such API,
> and I hope somebody will implement it :)

I need it for power saving so I definitely have to implement it,
unless someone else is faster :) I have few other things on my backlog
(eg. roaming and PSM timeout), but after I have finished those I'll
start working on beacon filtering.

-- 
Kalle Valo
