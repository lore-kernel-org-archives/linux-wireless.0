Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52491 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab1BHW55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 17:57:57 -0500
Message-ID: <4D51CA71.7040105@openwrt.org>
Date: Tue, 08 Feb 2011 23:57:53 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless@vger.kernel.org, j@w1.fi, lrodriguez@atheros.com,
	m.sujith@gmail.com
Subject: Re: [RFC 2/2] ath9k: fix powersave frame filtering/buffering in AP
 mode
References: <1297200372-79404-1-git-send-email-nbd@openwrt.org>	<1297200372-79404-2-git-send-email-nbd@openwrt.org> <AANLkTinhX9R9XY2_BoJXkRxNMZ3F_Adzwcq5XVQyEX0t@mail.gmail.com>
In-Reply-To: <AANLkTinhX9R9XY2_BoJXkRxNMZ3F_Adzwcq5XVQyEX0t@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-08 11:06 PM, Björn Smedman wrote:
> On Tue, Feb 8, 2011 at 10:26 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> This patch fixes a long standing issue of pending packets in the queue being
>> sent (and retransmitted many times) to sleeping stations.
>> This was made worse by aggregation through driver-internal retransmitting
>> of A-MDPU subframes.
> 
> Nice. :) Just one thought, shouldn't there be one more call to
> ieee80211_sta_set_tim() somewhere? I'm thinking there might be a race
> condition otherwise where the tid queues are empty on sta_notify but
> then later some failed/filtered A-MPDU subframes get queued...
Good point, I'll fix that...

> Also, just curious so feel free to answer or not, but how does the
> hardware handle the ps filter thing? Does it have a ps bit for every
> dst address? How many different dsts can it keep track of?
The hardware has a bitfield of blocked destinations, using the
destination index of the descriptor (which is also used as an index for
the key cache). The key cache can hold 128 entries.
Having a frame time out with excessive retries will cause the hardware
to block frames using the same destination index, until a frame is sent
with a bit that tells the hardware to clear that flag.
Right now, all unencrypted traffic uses the same destination index (0),
so unencrypted mode will have more corner cases compared to using WPA2,
but I plan on fixing that soon.

- Felix
