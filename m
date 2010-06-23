Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37927 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab0FWX4B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 19:56:01 -0400
Received: by iwn41 with SMTP id 41so224806iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jun 2010 16:56:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C22601E.5050101@openwrt.org>
References: <4B8C3A21.2050105@openwrt.org>
	<133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>
	<4B8D25DC.8070502@openwrt.org>
	<133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com>
	<4B8D396B.5040007@openwrt.org>
	<AANLkTilWfp6LzCYhxFweqAP_GceRz5PQBIBl5AksLKUf@mail.gmail.com>
	<4C223F58.3060509@openwrt.org>
	<AANLkTilDTZRUk_3iI5NPX0JhqG7N8LtKcE3VSSnqFGk9@mail.gmail.com>
	<4C22601E.5050101@openwrt.org>
Date: Thu, 24 Jun 2010 01:56:00 +0200
Message-ID: <AANLkTilZHfJ_PSAf-2gm1dW-2rUJFWaHARhPMicckXx5@mail.gmail.com>
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
> On 2010-06-23 8:47 PM, Björn Smedman wrote:
[snip]
>> But on the other hand doesn't that also mean that MRR rates and counts
>> in the tx status will be incorrect? I.e. one set of rates/counts used
>> to transmit the aggregate (first subframe) and (possibly) another set
>> reported back in tx status (first acked/expired subframe)?
> No, MRR info is just fine. The retry stats are reported for the whole
> A-MPDU, not for indvididual subframes. It's always present in the last
> descriptor of the whole batch. Also, since my code cleanup a while ago,
> the converted rx/tx status info is not longer part of the allocated
> descriptor space, but instead kept on stack in the function that
> processes the tx status. This on stack tx status is then passed to the
> rc update function, which sends the data to mac80211 along with the
> AMPDU tx status report.

That part looks reasonable to me. The part I don't understand is how
ath_tx_rc_update() builds the 'status' field of the
'ieee80211_tx_info' struct. The way I read the code we rely on the
compiler laying out the 'status' field on top of the 'control' field
(both members of an anonymous union) so that rates and counts align.
Since the 'control' field was (presumably) used to set up the tx we
already have a 'status' field that is almost correct. We only have to
remove the retries that where not actually needed from the counts. But
the presumption seems incorrect in the aggregation case. We may be
adjusting an MRR series that has never been used to control tx, right?

> - Felix
>

/Björn
