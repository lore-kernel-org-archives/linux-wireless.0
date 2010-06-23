Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:35227 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab0FWRHt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 13:07:49 -0400
Message-ID: <4C223F58.3060509@openwrt.org>
Date: Wed, 23 Jun 2010 19:07:36 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [RFC/RFT] minstrel_ht: new rate control module for 802.11n
References: <4B8C3A21.2050105@openwrt.org>	<133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>	<4B8D25DC.8070502@openwrt.org>	<133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com>	<4B8D396B.5040007@openwrt.org> <AANLkTilWfp6LzCYhxFweqAP_GceRz5PQBIBl5AksLKUf@mail.gmail.com>
In-Reply-To: <AANLkTilWfp6LzCYhxFweqAP_GceRz5PQBIBl5AksLKUf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-23 6:36 PM, Björn Smedman wrote:
> 2010/3/2 Felix Fietkau <nbd@openwrt.org>:
>> On 2010-03-02 4:47 PM, Björn Smedman wrote:
>>> 2010/3/2 Felix Fietkau <nbd@openwrt.org>:
> [snip]
>>> You mean the hardware interprets the block-ack and keeps retrying the
>>> un-acked frames? I thought it stopped as soon as it got a block-ack to
>>> let software sort out the acked and un-acked frames and handle the
>>> "partial" A-MPDU retry.
>> Not sure, actually. I just looked at the ath9k tx path again, and it
>> seems that you're right. However it looks like it's not sending rate
>> control updates until it's done with the software retry, so that's
>> probably the reason why I wasn't able to make it more precise yet.
> 
> I had another look at the code now and if I read it correctly this
> delay in the rate control feedback is really scary. In the extreme
> case where all the rates in the MRR stop working you have to make 10
> (ATH_MAX_SW_RETRIES) aggregate software retries (of about 20 frames
> each) with approx 10 hardware retries each before you give the rate
> control algorithm any feedback whatsoever. That is a worst case of
> several thousand (pointless) subframe retransmissions before the rate
> control algorithm has a chance to adjust...
Yes, the extreme case is currently not handled properly. However the
extreme case is also extremely unlikely to trigger. With minstrel_ht,
the max_prob_rate is always in the MRR series. If the conditions jump
from all rates working down to even max_prob_rate failing, then
something must be so wrong with the radio, that there's probably no
possibility of a graceful fallback at all. I do agree that this should
be fixed, though.

> If I'm not wrong above then the rate control feedback must also be
> incorrect: a disaster of that magnitude simply cannot be conveyed to
> the rate control algorithm through the thin tx status interface. As
> far as I can tell, whenever the first subframe of an aggregate fails
> and is software retried, the rate control feedback for that aggregate
> is lost (ath_tx_rc_status() is never called with update_rc = true in
> xmit.c).
I think you misread that part. The loop iterates over all subframes in
the aggregate, and the first successful or swretry-expired frame will
trigger an AMPDU status report, which will update the RC. The first
subframe of the A-MPDU is not getting any special treatment here.

> Any ideas on how to fix this? To me the aggregation and rate control
> code seems to need a major overhaul, something which would require
> changes to the interface between mac80211 and drivers, e.g. ath9k.
> That's out of my league unfortunately...
I've already made a lot of progress rewriting the entire aggregation
logic (it'll be in mac80211 instead of ath9k).
As soon as I'm done fixing the current batch of bugs that I'm debugging
at the moment, I will post my changes as RFC on the linux-wireless list.

- Felix


