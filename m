Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49721 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab0F2X4i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 19:56:38 -0400
Message-ID: <4C2A8833.8050602@openwrt.org>
Date: Wed, 30 Jun 2010 01:56:35 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: ath9k: ap tsf seems random and only uses lower 24 bits or so
References: <AANLkTilG4qxjX0e5u_BGp0YcPoVBbsqd6Hlb8E0j_S8S@mail.gmail.com>	<4C29284C.5050707@openwrt.org>	<AANLkTint2L1xSMughBA5aHCFMRB5KMC8EfwcxJJU5XYW@mail.gmail.com>	<4C2A1776.2080508@openwrt.org>	<AANLkTik_d6tIKj3otsgaojVBPfvW1lz9OBRujeZLyv1U@mail.gmail.com>	<4C2A24D2.4070007@openwrt.org>	<AANLkTikw3l6FIxLtIwxofGaqGQD_b7LO25uu-JV45UL6@mail.gmail.com>	<AANLkTikQz34vgfweDrzH_9_a-BU4dPXbX2UGR61jtJ9n@mail.gmail.com>	<4C2A6BA4.8080000@openwrt.org> <AANLkTimhHK461U_qguBGuJjppy5RP2tx5ApasJWVLgr4@mail.gmail.com>
In-Reply-To: <AANLkTimhHK461U_qguBGuJjppy5RP2tx5ApasJWVLgr4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-30 12:50 AM, Björn Smedman wrote:
> 2010/6/29 Felix Fietkau <nbd@openwrt.org>:
>> I had a similar thought about the multiple invocations thing. I think
>> that's a good approach in general, but we need to ensure that we make it
>> safe.
>> The main point of this function is to detect baseband hangs. If we
>> experience such a hang, I'm not sure we will always get enough
>> interrupts to do multiple consecutive tests.
>> One way to make it safe would be to reschedule the tasklet each time we
>> ignore the result of the ath9k_hw_check_alive(), that way we keep the
>> detection time low as well. Maybe we could also use a timer for leaving
>> 10 ms time between attempts.
> 
> The xmit logic has sc->tx_complete_work that periodically checks if
> the tx is hung and resets the chip if so. Maybe we could refactor that
> into a common periodic health checkup task in main.c that could call
> into both xmit.c and recv.c? Or does ath9k_hw_check_alive() have to
> run in the interrupt context in some way?
I'd like to keep them separate. I think a tx queue hang is very rare,
and the check only runs every second or so, whereas the baseband hang
check needs to run very frequently, as in some situations, the hangs can
probably occur frequently as well.

- Felix
