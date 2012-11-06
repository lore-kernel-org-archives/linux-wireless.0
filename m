Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2KFH42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 02:56:28 -0500
Message-ID: <1352188621.9440.4.camel@jlt4.sipsolutions.net> (sfid-20121106_085641_801796_E0F54F8B)
Subject: Re: Linux 3.6.5
From: Johannes Berg <johannes@sipsolutions.net>
To: Eddie Chapman <eddie@ehuk.net>
Cc: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org
Date: Tue, 06 Nov 2012 08:57:01 +0100
In-Reply-To: <509838F4.4010301@ehuk.net>
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>
	  <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>
	  (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>
	 <509838F4.4010301@ehuk.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eddie,

> Here is the output of /sys/kernel/debug/ieee80211/phy0/ht40allow_map:

Ok, thanks.

> 2412 HT40  +
> 2417 HT40  +
> 2422 HT40  +
> 2427 HT40  +
> 2432 HT40 -+
> 2437 HT40 -+
> 2442 HT40 -+
> 2447 HT40 -
> 2452 HT40 -
> 2457 HT40 -
> 2462 HT40 -
> 2467 HT40
> 2472 HT40
> 2484 HT40

That looks correct.

> and "iw reg get" says:
> 
> country 00:
> 	(2402 - 2472 @ 40), (6, 20)
> 	(2457 - 2482 @ 20), (6, 20), PASSIVE-SCAN, NO-IBSS
> 	(2474 - 2494 @ 20), (6, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
> 	(5170 - 5250 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS
> 	(5735 - 5835 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS
> 	(57240 - 63720 @ 2160), (N/A, 0)

That also looks fine.

> I captured both of these with the HT20/HT40 patch applied.

Ok, that shouldn't change anything in this case, but good to know.

> let me know if you need anything else.

Yeah, I forgot to ask about the AP. Can you show the output of "iw wlan0
scan dump" for your AP while you're connected? It should show something
like this (note the "associated" indication):

BSS 02:00:00:00:00:00 (on wlan1) -- associated
	TSF: 1352188517669470 usec (15650d, 07:55:17)
	freq: 2432
	[...]

I'm particularly interested in the "freq" (as above) and the HT
capabilities/operation information.

johannes

