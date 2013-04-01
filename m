Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47018 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757507Ab3DARkq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 13:40:46 -0400
Message-ID: <5159C697.4040609@openwrt.org> (sfid-20130401_194052_164924_5CBE6921)
Date: Mon, 01 Apr 2013 19:40:39 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Robert Shade <robert.shade@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Adrian Chadd <adrian@freebsd.org>
Subject: Re: [PATCH] ath9k: Re-enable interrupts after a channel change failure
References: <CAMgrJ3b0EUUae8k1Z2RR92eLbFyPGpqA5px1J_gALDTJ+rmAnA@mail.gmail.com>
In-Reply-To: <CAMgrJ3b0EUUae8k1Z2RR92eLbFyPGpqA5px1J_gALDTJ+rmAnA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-01 4:22 PM, Robert Shade wrote:
> Re-enable interrupts after a channel change failure, since
> ath_complete_reset will not be called.  Also schedule a reset as a
> best effort method to recover the chip from whatever state caused the
> channel change failure.
> 
> Signed-off-by: Robert Shade <robert.shade@gmail.com>
Your patch is badly whitespace damaged.

> ---
>  drivers/net/wireless/ath/ath9k/main.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c
> b/drivers/net/wireless/ath/ath9k/main.c
> index 24650fd..0567ac9 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -280,6 +280,12 @@ static int ath_reset_internal(struct ath_softc
> *sc, struct ath9k_channel *hchan)
>   if (r) {
>   ath_err(common,
>   "Unable to reset channel, reset status %d\n", r);
> +
> + ath9k_hw_set_interrupts(ah);
Why the call to ath9k_hw_set_interrupts here?

> + ath9k_hw_enable_interrupts(ah);
> +
> + ath9k_queue_reset(sc, RESET_TYPE_BB_HANG);
> +
>   goto out;
>   }

