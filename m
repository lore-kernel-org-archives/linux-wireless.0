Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40409 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1CJV4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 16:56:18 -0500
Received: by fxm17 with SMTP id 17so439152fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 13:56:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299764499-76251-4-git-send-email-nbd@openwrt.org>
References: <1299764499-76251-1-git-send-email-nbd@openwrt.org>
	<1299764499-76251-2-git-send-email-nbd@openwrt.org>
	<1299764499-76251-3-git-send-email-nbd@openwrt.org>
	<1299764499-76251-4-git-send-email-nbd@openwrt.org>
Date: Thu, 10 Mar 2011 16:55:46 -0500
Message-ID: <AANLkTik8CVL-XQvLxORWBcwyW8ZwT6Kk78HoyMAfpgmi@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ath9k: improve reliability of beacon transmission
 and stuck beacon handling
From: Mark Mentovai <mark@moxienet.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, vasanth@atheros.com
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
[...]
> +bool ath9k_hw_stop_dma_queue(struct ath_hw *ah, u32 q)
[...]
> -                               ath_err(common,
> -                                       "Failed to stop TX DMA in 100 msec after killing last frame\n");

Are you concerned about getting rid of this error that
ath9k_hw_stoptxdma used to print? It doesn’t seem like anything else
in the remaining code that uses it (ath_beacon_tasklet and
ath9k_set_beaconing_status) will produce an error.

Based on the message you sent with patch 2/4, “I can no longer trigger
these messages on AR9380, and on AR9280 they become much more rare,”
and the fact that you left the message intact in that patch’s
ath_drain_all_txq, I wonder it’s appropriate to remove the message
from this function.
