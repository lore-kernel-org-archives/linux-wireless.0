Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63506 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1H2JBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 05:01:09 -0400
Received: by vxi9 with SMTP id 9so4072967vxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 02:01:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314605174-66206-1-git-send-email-nbd@openwrt.org>
References: <1314605174-66206-1-git-send-email-nbd@openwrt.org>
Date: Mon, 29 Aug 2011 17:01:09 +0800
Message-ID: <CAJ-Vmonvcrd49rQbgeyO3HCLxkTbww3mTypR87CuPBiu9uwhHA@mail.gmail.com> (sfid-20110829_110113_853870_EE4FBAD9)
Subject: Re: [PATCH 3.1] ath9k_hw: fix calibration on 5 ghz
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can we please hold off of this until we know if this is indeed the correct fix?

Ie, I'm not sure yet whether 5ghz fast clock (which clocks the mac/bb
like it was doing 2.4ghz) needs the dual ADCs enabled or not.
It may be that something is being incorrectly disabled when the
fastclock initvals are being written over the normal 5ghz values.

Thanks,


Adrian

On 29 August 2011 16:06, Felix Fietkau <nbd@openwrt.org> wrote:
> ADC calibrations cannot run on 5 GHz with fast clock enabled. They
> need to be disabled, otherwise they'll hang and IQ mismatch calibration
> will not be run either.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Reported-by: Adrian Chadd <adrian@freebsd.org>
> Cc: stable@kernel.org
> ---
>  drivers/net/wireless/ath/ath9k/ar9002_calib.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> index 2d4c091..2d394af 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> @@ -41,7 +41,8 @@ static bool ar9002_hw_is_cal_supported(struct ath_hw *ah,
>        case ADC_DC_CAL:
>                /* Run ADC Gain Cal for non-CCK & non 2GHz-HT20 only */
>                if (!IS_CHAN_B(chan) &&
> -                   !(IS_CHAN_2GHZ(chan) && IS_CHAN_HT20(chan)))
> +                   !((IS_CHAN_2GHZ(chan) || IS_CHAN_A_FAST_CLOCK(ah, chan)) &&
> +                     IS_CHAN_HT20(chan)))
>                        supported = true;
>                break;
>        }
> --
> 1.7.3.2
>
>
