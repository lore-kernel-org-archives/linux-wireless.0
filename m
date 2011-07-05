Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50957 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1GEEwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 00:52:02 -0400
Received: by gxk21 with SMTP id 21so2112669gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 21:52:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309835484-26653-1-git-send-email-nbd@openwrt.org>
References: <1309835484-26653-1-git-send-email-nbd@openwrt.org>
Date: Tue, 5 Jul 2011 07:46:07 +0300
Message-ID: <CAFtRNNwK_LjP_2cAp0macP+8My4nzextWMNz9pLTKRW6V8tDjw@mail.gmail.com> (sfid-20110705_065206_856091_9A142A25)
Subject: Re: [PATCH v2 1/8] ath5k: add missing checks for rfgain probe
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/5 Felix Fietkau <nbd@openwrt.org>:
> rfgain probe is only necessary for OFDM operation on AR5111 and AR5112.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 5544191..d0bfcad 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1604,11 +1604,13 @@ int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
>        int ret;
>
>        if (ah->ah_radio == AR5K_RF5110)
> -               ret = ath5k_hw_rf5110_calibrate(ah, channel);
> -       else {
> -               ret = ath5k_hw_rf511x_iq_calibrate(ah);
> +               return ath5k_hw_rf5110_calibrate(ah, channel);
> +
> +       ret = ath5k_hw_rf511x_iq_calibrate(ah);
> +
> +       if ((ah->ah_radio == AR5K_RF5112 || ah->ah_radio == AR5K_RF5112) &&

You probably mean
ah->ah_radio == AR5K_RF5111 || ah->ah_radio == AR5K_RF5112

> +           (channel->hw_value & CHANNEL_OFDM))
>                ath5k_hw_request_rfgain_probe(ah);
> -       }
>
>        return ret;
>  }
> --
> 1.7.3.2
>
>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
