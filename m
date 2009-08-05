Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:9442 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933475AbZHEFux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 01:50:53 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1334277fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 22:50:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249450416.4168.22.camel@johannes.local>
References: <1249056817.20593.1.camel@maxim-laptop> <1249056896.20593.3.camel@maxim-laptop>
	<1249438947.3094.30.camel@localhost.localdomain> <1249450153.6083.4.camel@maxim-laptop>
	<1249450416.4168.22.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 5 Aug 2009 07:50:30 +0200
Message-ID: <69e28c910908042250n1e0bf9c6v20b6301db9e3286b@mail.gmail.com>
Subject: Re: [PATCH 001/002] [MAC80211] Retry probe request few times
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 5, 2009 at 7:33 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Wed, 2009-08-05 at 08:29 +0300, Maxim Levitsky wrote:
>
>> > [54632.657912] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 1
>> > [54633.154560] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 2
>> > [54873.231210] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 1
>> > [55113.467840] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 1
>> > [55113.964510] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 2
>> > [55114.464516] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 3
>> > [55114.967868] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 4
>> > [55115.464511] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, disconnecting.
>> >
>> > Should we increase the value to 8 or something? Or just accept that
>> > sometimes we get a disconnect?
>> >
>> I think a disconnect or two aren't a problem, they are always handled
>> automatically, and can be caused by natural events.
>>
>> Even without these patches (I have WPA2, and disconnects were every 4
>> five seconds), and still it was possible to use network.
>>
>> One disconnect in a day is really nothing to worry about (I have seen
>> such here as well)
>>
>> You can increase try count, probably won't hurt much (each try is 0.5
>> seconds, so even 10 tries gives total of 5 seconds, before disconnect on
>> a really unaccessible AP, anyway)
>
> Mind you, each try will end up sending a LOT of probe request frames,
> iwlwifi sends like 12 frames for every try and never gets a response for
> some reason, so I wouldn't really increase it much further since you'd
> be spamming around a lot.
>
> johannes
>

My €0.02 (€ because I'm European :) ): Shouldn't probe requests be NO_ACK?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
