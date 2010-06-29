Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43270 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab0F2Vyq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 17:54:46 -0400
Message-ID: <4C2A6BA4.8080000@openwrt.org>
Date: Tue, 29 Jun 2010 23:54:44 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: ath9k: ap tsf seems random and only uses lower 24 bits or so
References: <AANLkTilG4qxjX0e5u_BGp0YcPoVBbsqd6Hlb8E0j_S8S@mail.gmail.com>	<4C29284C.5050707@openwrt.org>	<AANLkTint2L1xSMughBA5aHCFMRB5KMC8EfwcxJJU5XYW@mail.gmail.com>	<4C2A1776.2080508@openwrt.org>	<AANLkTik_d6tIKj3otsgaojVBPfvW1lz9OBRujeZLyv1U@mail.gmail.com>	<4C2A24D2.4070007@openwrt.org>	<AANLkTikw3l6FIxLtIwxofGaqGQD_b7LO25uu-JV45UL6@mail.gmail.com> <AANLkTikQz34vgfweDrzH_9_a-BU4dPXbX2UGR61jtJ9n@mail.gmail.com>
In-Reply-To: <AANLkTikQz34vgfweDrzH_9_a-BU4dPXbX2UGR61jtJ9n@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-29 11:40 PM, Björn Smedman wrote:
> 2010/6/29 Björn Smedman <bjorn.smedman@venatech.se>:
>> Yes, hw reset is due to reg = 0x01702400 every 4 - 40 seconds or so:
>> ...
> 
> When the chip is really stuck, does 'reg' (at 'return false') change
> over time? If I add a second requirement that ath9k_hw_check_alive()
> must fail three times in a row (in different invocations of
> ath9k_tasklet()) before we reset the chip the ap seems fine. I
> sometimes get several of these reg = 0x01702400 every second but only
> one or at the max two in a row.
> 
> Under load I sometimes see some reg = 0x00f02400 as well. I also see
> an occasional reset now and then (about once a minute) that must be
> caused by something else.
> 
> Any insight into what these reg values mean? Do you think they can
> safely be ignored as per above?
I had a similar thought about the multiple invocations thing. I think
that's a good approach in general, but we need to ensure that we make it
safe.
The main point of this function is to detect baseband hangs. If we
experience such a hang, I'm not sure we will always get enough
interrupts to do multiple consecutive tests.
One way to make it safe would be to reschedule the tasklet each time we
ignore the result of the ath9k_hw_check_alive(), that way we keep the
detection time low as well. Maybe we could also use a timer for leaving
10 ms time between attempts.

Another thing that I'm working on right now is to ensure that the TSF
gets preserved across resets. For some AR9280 based cards the code
already preserves TSF in software over the chip reset, I could simply
extend that to cover SoC as well.
But before I post such a patch, I'll do a test on AR9160 - to see if it
would be better to make the TSF preserve unconditional.

- Felix
