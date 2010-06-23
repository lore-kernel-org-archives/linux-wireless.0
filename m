Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46379 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab0FWT1k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 15:27:40 -0400
Message-ID: <4C22601E.5050101@openwrt.org>
Date: Wed, 23 Jun 2010 21:27:26 +0200
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
References: <4B8C3A21.2050105@openwrt.org>	<133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>	<4B8D25DC.8070502@openwrt.org>	<133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com>	<4B8D396B.5040007@openwrt.org>	<AANLkTilWfp6LzCYhxFweqAP_GceRz5PQBIBl5AksLKUf@mail.gmail.com>	<4C223F58.3060509@openwrt.org> <AANLkTilDTZRUk_3iI5NPX0JhqG7N8LtKcE3VSSnqFGk9@mail.gmail.com>
In-Reply-To: <AANLkTilDTZRUk_3iI5NPX0JhqG7N8LtKcE3VSSnqFGk9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-23 8:47 PM, Björn Smedman wrote:
> 2010/6/23 Felix Fietkau <nbd@openwrt.org>:
>> On 2010-06-23 6:36 PM, Björn Smedman wrote:
> [snip]
>>> If I'm not wrong above then the rate control feedback must also be
>>> incorrect: a disaster of that magnitude simply cannot be conveyed to
>>> the rate control algorithm through the thin tx status interface. As
>>> far as I can tell, whenever the first subframe of an aggregate fails
>>> and is software retried, the rate control feedback for that aggregate
>>> is lost (ath_tx_rc_status() is never called with update_rc = true in
>>> xmit.c).
>> I think you misread that part. The loop iterates over all subframes in
>> the aggregate, and the first successful or swretry-expired frame will
>> trigger an AMPDU status report, which will update the RC. The first
>> subframe of the A-MPDU is not getting any special treatment here.
> 
> You're right, I missed that part. And I guess that's also why the
> worst case is so rare.
> 
> But on the other hand doesn't that also mean that MRR rates and counts
> in the tx status will be incorrect? I.e. one set of rates/counts used
> to transmit the aggregate (first subframe) and (possibly) another set
> reported back in tx status (first acked/expired subframe)?
No, MRR info is just fine. The retry stats are reported for the whole
A-MPDU, not for indvididual subframes. It's always present in the last
descriptor of the whole batch. Also, since my code cleanup a while ago,
the converted rx/tx status info is not longer part of the allocated
descriptor space, but instead kept on stack in the function that
processes the tx status. This on stack tx status is then passed to the
rc update function, which sends the data to mac80211 along with the
AMPDU tx status report.

> Also, bf->bf_retries is used in ath_tx_rc_status() but the logic makes
> no sense if bf_retries holds the number of software retries...
Hmm, that part might indeed be buggy. I'll review it in detail when I'm
at home again.

- Felix
