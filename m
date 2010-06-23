Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41925 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0FWQg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 12:36:29 -0400
Received: by gwaa18 with SMTP id a18so88747gwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jun 2010 09:36:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4B8D396B.5040007@openwrt.org>
References: <4B8C3A21.2050105@openwrt.org>
	<133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>
	<4B8D25DC.8070502@openwrt.org>
	<133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com>
	<4B8D396B.5040007@openwrt.org>
Date: Wed, 23 Jun 2010 18:36:28 +0200
Message-ID: <AANLkTilWfp6LzCYhxFweqAP_GceRz5PQBIBl5AksLKUf@mail.gmail.com>
Subject: Re: [RFC/RFT] minstrel_ht: new rate control module for 802.11n
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/2 Felix Fietkau <nbd@openwrt.org>:
> On 2010-03-02 4:47 PM, Björn Smedman wrote:
>> 2010/3/2 Felix Fietkau <nbd@openwrt.org>:
[snip]
>> You mean the hardware interprets the block-ack and keeps retrying the
>> un-acked frames? I thought it stopped as soon as it got a block-ack to
>> let software sort out the acked and un-acked frames and handle the
>> "partial" A-MPDU retry.
> Not sure, actually. I just looked at the ath9k tx path again, and it
> seems that you're right. However it looks like it's not sending rate
> control updates until it's done with the software retry, so that's
> probably the reason why I wasn't able to make it more precise yet.

I had another look at the code now and if I read it correctly this
delay in the rate control feedback is really scary. In the extreme
case where all the rates in the MRR stop working you have to make 10
(ATH_MAX_SW_RETRIES) aggregate software retries (of about 20 frames
each) with approx 10 hardware retries each before you give the rate
control algorithm any feedback whatsoever. That is a worst case of
several thousand (pointless) subframe retransmissions before the rate
control algorithm has a chance to adjust...

If I'm not wrong above then the rate control feedback must also be
incorrect: a disaster of that magnitude simply cannot be conveyed to
the rate control algorithm through the thin tx status interface. As
far as I can tell, whenever the first subframe of an aggregate fails
and is software retried, the rate control feedback for that aggregate
is lost (ath_tx_rc_status() is never called with update_rc = true in
xmit.c).

Any ideas on how to fix this? To me the aggregation and rate control
code seems to need a major overhaul, something which would require
changes to the interface between mac80211 and drivers, e.g. ath9k.
That's out of my league unfortunately...
