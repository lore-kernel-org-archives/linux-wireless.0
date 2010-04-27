Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 29.mail-out.ovh.net ([87.98.216.213]:49294 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750735Ab0D0GWn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 02:22:43 -0400
Message-ID: <4BD682AF.6030206@free.fr>
Date: Tue, 27 Apr 2010 08:22:39 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: remove usage of deprecated noise value
References: <1272312561-22648-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1272312561-22648-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville a écrit :
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath/ath9k/common.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
> index 09effde..b4424a6 100644
> --- a/drivers/net/wireless/ath/ath9k/common.c
> +++ b/drivers/net/wireless/ath/ath9k/common.c
> @@ -212,7 +212,6 @@ int ath9k_cmn_rx_skb_preprocess(struct ath_common *common,
>  	rx_status->mactime = ath9k_hw_extend_tsf(ah, rx_stats->rs_tstamp);
>  	rx_status->band = hw->conf.channel->band;
>  	rx_status->freq = hw->conf.channel->center_freq;
> -	rx_status->noise = common->ani.noise_floor;
>  	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
>  	rx_status->antenna = rx_stats->rs_antenna;
>  	rx_status->flag |= RX_FLAG_TSFT;
>   
Hey, I'm still using this value here in my setup (I've done some work on 
noise floor calibration and can submit a patch that report noise & 
signal values that makes more sense to me). I mentioned in an earlier 
patch that I was using the {last_signal, last_noise} debugfs file as 
well (in February, 17th).

Before removing noise reporting and all related code, wouln't it be 
better to have a replacement API? I was told that noise reporting is 
buggy for most chipset, but that's a bug in each driver, not in mac80211 
then. Such bugs could be fixed by using a default value of -101dBm 
(thermal noise at room temperature over a 20 MHz channel) if they are 
unable to determine a correct value.

Moreover, it is very convenient to have the {last_signal, last_noise} 
sampled at the same time and be in the same location. Likewise for the 
radiotap header, it is very easy to plot noise value over time if it is 
stored on a per packet basis. Of course, I know noise is a global 
property of the channel and not DEFINED on a per packet basis, but once 
you know that, it's still useful to have it REPORTED on a per packet basis.

So far, the solution for me was to revert the single patch for making 
the noise field deprecated, but I'm not going to revert each & every 
patches related to noise. After all, isn't it the purpose of peer review?

Regards,
Benoit

