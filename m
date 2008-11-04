Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:64821 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYKDFcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 00:32:42 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1491875qwe.37
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 21:32:40 -0800 (PST)
Message-ID: <d9360e520811032132t6ca3f29djb8c9decc41335e7b@mail.gmail.com> (sfid-20081104_063303_175036_B626F6CD)
Date: Tue, 4 Nov 2008 11:02:40 +0530
From: "Bharat Bhushan" <bharat.b.bhushan@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: No ProbeResp - assume out of range
Cc: "Felix Fietkau" <nbd@openwrt.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kalle Valo" <kalle.valo@nokia.com>
In-Reply-To: <1225734605.3619.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
	 <200811022303.54476.mb@bu3sch.de>
	 <1ba2fa240811021442o178c98a1pa920b863b60d9293@mail.gmail.com>
	 <43e72e890811021458h1444d350v33a5e5b984b76495@mail.gmail.com>
	 <20081103002558.GA14153@tesla> <490F2B6C.9090002@openwrt.org>
	 <1225734605.3619.39.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 3, 2008 at 11:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
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
>
> johannes
>

if we start dealing with beacons in NIC, i think this will impact
roaming scenarios, beacouse in most of  roaming algorithms signal
strength of beacon received played a pivot rolef and  ignoring this at
NIC  this will not allow client to take judicious decisions.

bharat
