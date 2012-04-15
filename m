Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41927 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab2DOSWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 14:22:35 -0400
Received: by vcqp1 with SMTP id p1so2909020vcq.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Apr 2012 11:22:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334484941-27673-2-git-send-email-nbd@openwrt.org>
References: <1334484941-27673-1-git-send-email-nbd@openwrt.org> <1334484941-27673-2-git-send-email-nbd@openwrt.org>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sun, 15 Apr 2012 11:22:14 -0700
Message-ID: <CALSq=BZgn+O2BNq=yAe_g5DAqR7jO3eSX2AcABtWqGUcYjB_qQ@mail.gmail.com> (sfid-20120415_202300_873974_C2CA919B)
Subject: Re: [PATCH 2/9] ath9k_hw: do not override SIFS time for half/quarter channels
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix,

This whole patch series throws the NICs out of spec compliance. For
instance, page 626 of the 802.11-2007 standard (Table 17-15) says that
aSIFStime is 32 us in 10 MHz mode and 64 us in 5 MHz mode.

This might be okay to do for certain implementations (as, apparently,
AR9280/AR9380), but will break compatibility with any device obeying
the standard instead.

(I wonder that, if this code below still works, then it seems that you
might not be properly downclocking the chips' reference clock...)

Are you aware there's a standard for this? Why violate it?

Dan

On Sun, Apr 15, 2012 at 3:15 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Significantly improves performance on AR9280/AR9380
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index c7faf10..e408aaf 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -1000,7 +1000,6 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>                    tx_lat += 11;
>
>                slottime = 13;
> -               sifstime = 32;
>        } else if (IS_CHAN_QUARTER_RATE(chan)) {
>                eifs = 340;
>                rx_lat = 20;
> @@ -1009,7 +1008,6 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>                    tx_lat += 22;
>
>                slottime = 21;
> -               sifstime = 64;
>        } else {
>                if (AR_SREV_9287(ah) && AR_SREV_9287_13_OR_LATER(ah)) {
>                        eifs = AR_D_GBL_IFS_EIFS_ASYNC_FIFO;
> @@ -1023,12 +1021,13 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>                tx_lat = MS(reg, AR_USEC_TX_LAT);
>
>                slottime = ah->slottime;
> -               if (IS_CHAN_5GHZ(chan))
> -                       sifstime = 16;
> -               else
> -                       sifstime = 10;
>        }
>
> +       if (IS_CHAN_5GHZ(chan))
> +               sifstime = 16;
> +       else
> +               sifstime = 10;
> +
>        /* As defined by IEEE 802.11-2007 17.3.8.6 */
>        acktimeout = slottime + sifstime + 3 * ah->coverage_class;
>        ctstimeout = acktimeout;
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
