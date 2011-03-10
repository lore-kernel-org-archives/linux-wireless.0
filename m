Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41914 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab1CJWNq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 17:13:46 -0500
Message-ID: <4D794D17.4080809@openwrt.org>
Date: Thu, 10 Mar 2011 23:13:43 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mark Mentovai <mark@moxienet.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, vasanth@atheros.com
Subject: Re: [PATCH v2 4/4] ath9k: improve reliability of beacon transmission
 and stuck beacon handling
References: <1299764499-76251-1-git-send-email-nbd@openwrt.org>	<1299764499-76251-2-git-send-email-nbd@openwrt.org>	<1299764499-76251-3-git-send-email-nbd@openwrt.org>	<1299764499-76251-4-git-send-email-nbd@openwrt.org> <AANLkTik8CVL-XQvLxORWBcwyW8ZwT6Kk78HoyMAfpgmi@mail.gmail.com>
In-Reply-To: <AANLkTik8CVL-XQvLxORWBcwyW8ZwT6Kk78HoyMAfpgmi@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-10 10:55 PM, Mark Mentovai wrote:
> Felix Fietkau wrote:
>> diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
> [...]
>> +bool ath9k_hw_stop_dma_queue(struct ath_hw *ah, u32 q)
> [...]
>> -                               ath_err(common,
>> -                                       "Failed to stop TX DMA in 100 msec after killing last frame\n");
> 
> Are you concerned about getting rid of this error that
> ath9k_hw_stoptxdma used to print? It doesn’t seem like anything else
> in the remaining code that uses it (ath_beacon_tasklet and
> ath9k_set_beaconing_status) will produce an error.
The error message is in a code path that never triggered (or at least
never should have) for the beacon code, based on the fact that it was
only supposed to be called when the number of pending frames in the
queue was already 0.
I removed the entire block of code because attempting to stop DMA by
messing with the queue parameters and doing busy-waiting is completely
bogus and counterproductive for anything beacon related.

> Based on the message you sent with patch 2/4, “I can no longer trigger
> these messages on AR9380, and on AR9280 they become much more rare,”
> and the fact that you left the message intact in that patch’s
> ath_drain_all_txq, I wonder it’s appropriate to remove the message
> from this function.
Anything beacon related will report stuck beacons if frames stay in the
queue until the next interval, so there is some degree of reporting
there already.

- Felix
