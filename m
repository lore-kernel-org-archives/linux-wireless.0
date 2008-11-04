Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:42038 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYKDHGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 02:06:50 -0500
To: "Bharat Bhushan" <bharat.b.bhushan@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Felix Fietkau" <nbd@openwrt.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: No ProbeResp - assume out of range
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
	<200811022303.54476.mb@bu3sch.de>
	<1ba2fa240811021442o178c98a1pa920b863b60d9293@mail.gmail.com>
	<43e72e890811021458h1444d350v33a5e5b984b76495@mail.gmail.com>
	<20081103002558.GA14153@tesla> <490F2B6C.9090002@openwrt.org>
	<1225734605.3619.39.camel@johannes.berg>
	<d9360e520811032132t6ca3f29djb8c9decc41335e7b@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 04 Nov 2008 09:05:57 +0200
In-Reply-To: <d9360e520811032132t6ca3f29djb8c9decc41335e7b@mail.gmail.com> (ext Bharat Bhushan's message of "Tue\, 4 Nov 2008 11\:02\:40 +0530")
Message-ID: <87prlcas2y.fsf@nokia.com> (sfid-20081104_080655_407306_B3AA3A23)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Bharat Bhushan" <bharat.b.bhushan@gmail.com> writes:

>>> Why not configure the beacon miss interrupt instead of passing beacons to
>>> mac80211 in STA mode? That should save some battery on Laptops because it
>>> won't cause 10 extra wakeups every second.
>>
>> We have no way to indicate to mac80211 that the hw is watching beacons,
>> so that'd be equivalent to just dropping them. We've discussed such API,
>> and I hope somebody will implement it :)
>
> if we start dealing with beacons in NIC, i think this will impact
> roaming scenarios, beacouse in most of  roaming algorithms signal
> strength of beacon received played a pivot rolef and  ignoring this at
> NIC  this will not allow client to take judicious decisions.

The NIC should send an event to the driverinforming about the low
signal strength situation and driver will forward this information to
mac80211. The firmware has knowledge of the beacon rssi so this should
be trivial to implement in firmware. But if the firmware really
doesn't support this, the driver can always disable beacon filtering
feature in mac80211.

-- 
Kalle Valo
