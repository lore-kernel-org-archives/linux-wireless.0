Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:54821 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2CZOSY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 10:18:24 -0400
Message-ID: <4F707AA7.5050401@hartkopp.net> (sfid-20120326_161828_800301_C4C8B3FE)
Date: Mon, 26 Mar 2012 16:18:15 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	David Spinadel <david.spinadel@intel.com>,
	linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: 3.4-merge: iwlwifi needs more than 1 minute to connect
References: <20120316180428.GD2563@tuxdriver.com>  <4F6CD1BC.4040703@hartkopp.net> <1332756333.7081.18.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332756333.7081.18.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26.03.2012 12:05, Johannes Berg wrote:

> Hi Oliver,
> 
>> i'm using the *very* latest 3.4-merge tree from Linus and my Wifi now needs
>> more than one minute to connect to my access point.
> 
>> [   16.288562] wlan0: authenticate with bc:05:43:94:1a:da
>> [   16.299644] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
>> [   16.302060] wlan0: authenticated
>> [   16.302492] wlan0: waiting for beacon from bc:05:43:94:1a:da
>> [   16.432398] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr bc:05:43:94:1a:da
> 
> This is an odd message. I need to figure out how that can even happen.
> 
> What's the beacon interval on your AP? It seems more likely that this is
> a problem with RX though.


Hm - but i definitely didn't change my setup or AP.

It's only a difference in the kernel.

> 
>> [   29.434897] wlan0: authenticate with bc:05:43:94:1a:da
>> [   29.445634] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
>> [   29.448168] wlan0: authenticated
>> [   29.448229] wlan0: waiting for beacon from bc:05:43:94:1a:da
>> [   29.473633] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr bc:05:43:94:1a:da
> 
> So this repeats, I suspect the 15 second retry timer is in
> wpa_supplicant.


ok.

> 
>> [   55.773770] wlan0: authenticate with bc:05:43:94:1a:da
>> [   55.784316] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
>> [   55.786758] wlan0: authenticated
>> [   55.787407] wlan0: associate with bc:05:43:94:1a:da (try 1/3)
>> [   55.791114] wlan0: RX AssocResp from bc:05:43:94:1a:da (capab=0x431 status=0 aid=4)
>> [   55.791121] wlan0: associated
> 
> So when it succeeds it basically doesn't do the beacon wait thing. I
> guess that is the problem then.
> 
> 
> Do you think you could collect some tracing info?
> 
> trace-cmd record -e mac80211 -e iwlwifi
> 
> would be useful.


No, i can't %-)

But step by step:

1. I downloaded trace-cmd with git
2. trace-cmd told me to enable debugfs

With debugfs enabled the problem is gone :-]

[   15.821526] wlan0: authenticate with bc:05:43:94:1a:da
[   15.825722] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
[   16.028772] wlan0: send auth to bc:05:43:94:1a:da (try 2/3)
[   16.030738] wlan0: authenticated
[   16.032812] wlan0: associate with bc:05:43:94:1a:da (try 1/3)
[   16.036512] wlan0: RX AssocResp from bc:05:43:94:1a:da (capab=0x431
status=0 aid=3)
[   16.036519] wlan0: associated
[   16.046018] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   26.610520] wlan0: no IPv6 routers present

Oh, well.

Maybe some other information might help:

I always run Daves net-next tree on my machine.
Until the release of 3.3 on march 18th i had no problem with net-next.
But this problem appeared first, when i used Linus' merge tree.
Not the first day when the net-next was pulled into Linus' tree but some time
later.

Regards,
Oliver
