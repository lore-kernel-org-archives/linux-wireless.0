Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56936 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1HYPcU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 11:32:20 -0400
Message-ID: <4E566AFA.8050203@openwrt.org> (sfid-20110825_173227_059432_55F333D4)
Date: Thu, 25 Aug 2011 17:32:10 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k_hw: Fix rx latency of 11a mode
References: <1314283522-6143-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1314283522-6143-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-25 4:45 PM, Rajkumar Manoharan wrote:
> Rx latecy to start signal(usec) of 11a is 41 not 37 and
> also corrected the rx delay in quarter rate.
>
> Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/hw.c |    7 +++++--
>   1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index 88100cc..d4dce6b 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -974,7 +974,10 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>   	if (ah->misc_mode != 0)
>   		REG_SET_BIT(ah, AR_PCU_MISC, ah->misc_mode);
>
> -	rx_lat = 37;
> +	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
> +		rx_lat = 41;
> +	else
> +		rx_lat = 37;
>   	tx_lat = 54;
>
>   	if (IS_CHAN_HALF_RATE(chan)) {
> @@ -988,7 +991,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>   		sifstime = 32;
>   	} else if (IS_CHAN_QUARTER_RATE(chan)) {
>   		eifs = 340;
> -		rx_lat *= 4;
> +		rx_lat *= 4 - 1;
That looks a bit weird. Did you mean to change it to *= 3 or was this 
just mistyped because you wanted to subtract one after the multiplication?

- Felix
