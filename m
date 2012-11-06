Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41806 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2KFQqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 11:46:49 -0500
Message-ID: <1352220444.9440.20.camel@jlt4.sipsolutions.net> (sfid-20121106_174702_465154_8243F9F3)
Subject: Re: Linux 3.6.5
From: Johannes Berg <johannes@sipsolutions.net>
To: Eddie Chapman <eddie@ehuk.net>
Cc: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi, mcgrof@gmail.com
Date: Tue, 06 Nov 2012 17:47:24 +0100
In-Reply-To: <1352219976.9440.18.camel@jlt4.sipsolutions.net> (sfid-20121106_173951_781497_2AE1DCC1)
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>
	 <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>
	 (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>
	 <509838F4.4010301@ehuk.net> <1352188621.9440.4.camel@jlt4.sipsolutions.net>
	 <50992E0E.3040606@ehuk.net>
	 <1352217244.9440.16.camel@jlt4.sipsolutions.net>
	 (sfid-20121106_165343_414402_7F00AE58) <1352219976.9440.18.camel@jlt4.sipsolutions.net>
	 (sfid-20121106_173951_781497_2AE1DCC1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-06 at 17:39 +0100, Johannes Berg wrote:
> On Tue, 2012-11-06 at 16:54 +0100, Johannes Berg wrote:
> 
> > > BSS 82:e1:fa:1a:65:00 (on wlan0) -- associated
> > [...]
> > > 	HT operation:
> > > 		 * primary channel: 9
> > > 		 * secondary channel offset: above
> > 
> > As you can see, it's using HT40+ on channel 9 (2452 MHz). Your HT40
> > allow (correctly) map showed:
> > 
> > 2452 HT40 -
> > 
> > This is because HT40+ isn't actually allowed on channel 9 by the
> > standard (cf. 802.11-2012 Table E-1 (US), E-2 (Europe), E-3 (Japan).
> 
> Oops, no, that is obviously wrong. This is permitted outside the US, and
> that is reflected in those tables as well (I was confused). However,
> your AP isn't transmitting any info on where it is, and your device is
> set up for world roaming (country is "00" rather than a real country).
> Thus, channel 13 isn't allowed and you can't do HT40+ on channel 9.

Here's another idea. I'm not sure if you're running CRDA, but you could
try this patch:

http://p.sipsolutions.net/8877cbe3440d94b1.txt

and see if "iw reg get" changes like this:


 country 00:
         (2402 - 2472 @ 40), (6, 20)
-        (2457 - 2482 @ 20), (6, 20), PASSIVE-SCAN, NO-IBSS
+        (2457 - 2482 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS
         (2474 - 2494 @ 20), (6, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
         (5170 - 5250 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS
         (5735 - 5835 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS
         (57240 - 63720 @ 2160), (N/A, 0)

If yes, then your problem will likely go away, if no you'd need an
updated regulatory database for CRDA. +Luis, what do you think?

johannes

