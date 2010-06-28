Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:56491 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab0F1K1r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jun 2010 06:27:47 -0400
Message-ID: <4C287913.8070405@openwrt.org>
Date: Mon, 28 Jun 2010 12:27:31 +0200
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
References: <4B8C3A21.2050105@openwrt.org>	<133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>	<4B8D25DC.8070502@openwrt.org>	<133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com>	<4B8D396B.5040007@openwrt.org>	<AANLkTilWfp6LzCYhxFweqAP_GceRz5PQBIBl5AksLKUf@mail.gmail.com>	<4C223F58.3060509@openwrt.org>	<AANLkTikmXoEnHb1K9StEgszdllAxdsAbm9WdtSUiwKWE@mail.gmail.com>	<4C27E8E8.8040606@openwrt.org> <AANLkTinoz66aXYBSlwVtTnJBs1u-4FfOCphHTZONHc4B@mail.gmail.com>
In-Reply-To: <AANLkTinoz66aXYBSlwVtTnJBs1u-4FfOCphHTZONHc4B@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-28 12:20 PM, Björn Smedman wrote:
> 2010/6/28 Felix Fietkau <nbd@openwrt.org>:
>> On 2010-06-28 2:01 AM, Björn Smedman wrote:
> [snip]
>>> I guess the real solution is your rewrite... But in the mean time
>>> perhaps we can memcpy the tx_info control from the last subframe to
>>> the first before calling ath_buf_set_rate() in ath_tx_sched_aggr()?
>>> Could that have any side effects? It could make the aggregate size go
>>> over the 4 ms limit I guess... How bad is that?
>> There's an easy solution which would take into account the 4ms frame
>> limit properly, and which could work without any memcpy() hacks:
>>
>> I could just grab a pointer to the last buffer in the tid queue in the
>> ath_tx_sched_aggr() function, then pass it to ath_lookup_rate() via
>> ath_tx_form_aggr(), and also to ath_buf_set_rate(). Then I make those
>> functions use this last buffer as reference for the rate lookup.
> 
> Sounds better to use the rate control from the last buffer in the tid
> queue. But be careful if you don't memcpy it to the first frame of the
> aggregate then the feedback calculated in ath_tx_rc_status() after tx
> will be incorrect again, no?
Right. I intend to let ath_buf_set_rate() set the rates array of the
first subframe accordingly.

- Felix
