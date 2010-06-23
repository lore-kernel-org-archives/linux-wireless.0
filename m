Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54669 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab0FWSrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 14:47:01 -0400
Received: by iwn1 with SMTP id 1so23409iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jun 2010 11:47:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C223F58.3060509@openwrt.org>
References: <4B8C3A21.2050105@openwrt.org>
	<133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>
	<4B8D25DC.8070502@openwrt.org>
	<133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com>
	<4B8D396B.5040007@openwrt.org>
	<AANLkTilWfp6LzCYhxFweqAP_GceRz5PQBIBl5AksLKUf@mail.gmail.com>
	<4C223F58.3060509@openwrt.org>
Date: Wed, 23 Jun 2010 20:47:00 +0200
Message-ID: <AANLkTilDTZRUk_3iI5NPX0JhqG7N8LtKcE3VSSnqFGk9@mail.gmail.com>
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

2010/6/23 Felix Fietkau <nbd@openwrt.org>:
> On 2010-06-23 6:36 PM, Björn Smedman wrote:
[snip]
>> If I'm not wrong above then the rate control feedback must also be
>> incorrect: a disaster of that magnitude simply cannot be conveyed to
>> the rate control algorithm through the thin tx status interface. As
>> far as I can tell, whenever the first subframe of an aggregate fails
>> and is software retried, the rate control feedback for that aggregate
>> is lost (ath_tx_rc_status() is never called with update_rc = true in
>> xmit.c).
> I think you misread that part. The loop iterates over all subframes in
> the aggregate, and the first successful or swretry-expired frame will
> trigger an AMPDU status report, which will update the RC. The first
> subframe of the A-MPDU is not getting any special treatment here.

You're right, I missed that part. And I guess that's also why the
worst case is so rare.

But on the other hand doesn't that also mean that MRR rates and counts
in the tx status will be incorrect? I.e. one set of rates/counts used
to transmit the aggregate (first subframe) and (possibly) another set
reported back in tx status (first acked/expired subframe)?

Also, bf->bf_retries is used in ath_tx_rc_status() but the logic makes
no sense if bf_retries holds the number of software retries...

>> Any ideas on how to fix this? To me the aggregation and rate control
>> code seems to need a major overhaul, something which would require
>> changes to the interface between mac80211 and drivers, e.g. ath9k.
>> That's out of my league unfortunately...
> I've already made a lot of progress rewriting the entire aggregation
> logic (it'll be in mac80211 instead of ath9k).
> As soon as I'm done fixing the current batch of bugs that I'm debugging
> at the moment, I will post my changes as RFC on the linux-wireless list.

Very nice to hear a rewrite is in progress. :) Looking forward to those patches.

> - Felix
>

/Björn
