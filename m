Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46211 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab0F1ABF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jun 2010 20:01:05 -0400
Received: by iwn7 with SMTP id 7so572926iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jun 2010 17:01:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C223F58.3060509@openwrt.org>
References: <4B8C3A21.2050105@openwrt.org>
	<133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>
	<4B8D25DC.8070502@openwrt.org>
	<133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com>
	<4B8D396B.5040007@openwrt.org>
	<AANLkTilWfp6LzCYhxFweqAP_GceRz5PQBIBl5AksLKUf@mail.gmail.com>
	<4C223F58.3060509@openwrt.org>
Date: Mon, 28 Jun 2010 02:01:04 +0200
Message-ID: <AANLkTikmXoEnHb1K9StEgszdllAxdsAbm9WdtSUiwKWE@mail.gmail.com>
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
>> [snip] As
>> far as I can tell, whenever the first subframe of an aggregate fails
>> and is software retried, the rate control feedback for that aggregate
>> is lost (ath_tx_rc_status() is never called with update_rc = true in
>> xmit.c).
> I think you misread that part. The loop iterates over all subframes in
> the aggregate, and the first successful or swretry-expired frame will
> trigger an AMPDU status report, which will update the RC. The first
> subframe of the A-MPDU is not getting any special treatment here.

You're (still) right I misread that part. But I think there is another
problem when the first subframe of an A-MPDU is not acked: if it has
not expired yet it is (as I understand it) prepended to the tid queue
for software retry and will therefore be the first subframe of the
next aggregate as well, which will then be transmitted with the same
"old" rates and counts as the previous aggregate. So the feedback from
xmit to rc works, but the control information flow from rc to xmit is
delayed.

I guess the real solution is your rewrite... But in the mean time
perhaps we can memcpy the tx_info control from the last subframe to
the first before calling ath_buf_set_rate() in ath_tx_sched_aggr()?
Could that have any side effects? It could make the aggregate size go
over the 4 ms limit I guess... How bad is that?

> - Felix

/Björn
