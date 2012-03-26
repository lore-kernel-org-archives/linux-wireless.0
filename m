Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab2CZKFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 06:05:40 -0400
Message-ID: <1332756333.7081.18.camel@jlt3.sipsolutions.net> (sfid-20120326_120548_172970_798D31A9)
Subject: Re: 3.4-merge: iwlwifi needs more than 1 minute to connect
From: Johannes Berg <johannes@sipsolutions.net>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	David Spinadel <david.spinadel@intel.com>,
	linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>
Date: Mon, 26 Mar 2012 12:05:33 +0200
In-Reply-To: <4F6CD1BC.4040703@hartkopp.net>
References: <20120316180428.GD2563@tuxdriver.com>
	 <4F6CD1BC.4040703@hartkopp.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oliver,

> i'm using the *very* latest 3.4-merge tree from Linus and my Wifi now needs
> more than one minute to connect to my access point.

> [   16.288562] wlan0: authenticate with bc:05:43:94:1a:da
> [   16.299644] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
> [   16.302060] wlan0: authenticated
> [   16.302492] wlan0: waiting for beacon from bc:05:43:94:1a:da
> [   16.432398] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr bc:05:43:94:1a:da

This is an odd message. I need to figure out how that can even happen.

What's the beacon interval on your AP? It seems more likely that this is
a problem with RX though.

> [   29.434897] wlan0: authenticate with bc:05:43:94:1a:da
> [   29.445634] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
> [   29.448168] wlan0: authenticated
> [   29.448229] wlan0: waiting for beacon from bc:05:43:94:1a:da
> [   29.473633] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr bc:05:43:94:1a:da

So this repeats, I suspect the 15 second retry timer is in
wpa_supplicant.

> [   55.773770] wlan0: authenticate with bc:05:43:94:1a:da
> [   55.784316] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
> [   55.786758] wlan0: authenticated
> [   55.787407] wlan0: associate with bc:05:43:94:1a:da (try 1/3)
> [   55.791114] wlan0: RX AssocResp from bc:05:43:94:1a:da (capab=0x431 status=0 aid=4)
> [   55.791121] wlan0: associated

So when it succeeds it basically doesn't do the beacon wait thing. I
guess that is the problem then.


Do you think you could collect some tracing info?

trace-cmd record -e mac80211 -e iwlwifi

would be useful.



> [   73.059911] netlink: 12 bytes leftover after parsing attributes.

This is interesting, I wonder where that came from, but I don't think
it's related.

johannes

