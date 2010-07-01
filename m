Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49467 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0GAHv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 03:51:29 -0400
Message-ID: <4C2C48F5.70307@openwrt.org>
Date: Thu, 01 Jul 2010 09:51:17 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?UTF-8?B?QmrDtnJuIFNtZWRtYW4=?= <bjorn.smedman@venatech.se>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: fix TSF after reset on AR913x
References: <4C2A8AD4.8070504@openwrt.org>	<1277935351.17170.1.camel@mj>	 <AANLkTim8NrVZfcJGi4NK_OhXBxEY0Lw9fdg1bcbzDU0X@mail.gmail.com>	 <4C2BE5A8.9030003@openwrt.org> <1277966396.3788.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1277966396.3788.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-01 8:39 AM, Johannes Berg wrote:
> On Thu, 2010-07-01 at 02:47 +0200, Felix Fietkau wrote:
> 
>> No, the TSF value at this point is not accurate. It differs
>> semi-randomly by a few orders of magnitude from the time measured by the
>> CPU timer. The value I put in above is just an approximation, but since
>> making it completely accurate is impossible, I figured this is good
>> enough, especially since the value will most likely not deviate much
>> from what I've measured here.
> 
> Are you sure it doesn't depend on CPU speed as well since the driver is
> involved here? Or DMA speed?
Yes, it depends on CPU speed, but there's not a lot of variation
possible, because this only affects one, maybe two different SoC types
with similar CPU speed, and a large part of the delay is probably
constant because of udelay calls.
As I said, being precise here is impossible anyway, this is only a
workaround for a hw issue, and this simple approximation should not
cause any problems for anything. Even if the AP's TSF jumps by a few
microseconds, the clients will catch on to that pretty quickly.

- Felix
