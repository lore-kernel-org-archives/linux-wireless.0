Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33233 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab2BMLZC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 06:25:02 -0500
Message-ID: <4F38F303.3010007@openwrt.org> (sfid-20120213_122507_433563_88AE1FB4)
Date: Mon, 13 Feb 2012 12:24:51 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 1/7] ath9k: Remove redundant max_streams assignment
References: <20280.43934.3990.442268@gargle.gargle.HOWL>
In-Reply-To: <20280.43934.3990.442268@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-13 7:20 AM, Sujith Manoharan wrote:
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/init.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 53a005d..a625c9a 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -258,8 +258,6 @@ static void setup_ht_cap(struct ath_softc *sc,
>  
>  	if (AR_SREV_9330(ah) || AR_SREV_9485(ah))
>  		max_streams = 1;
> -	else if (AR_SREV_9462(ah))
> -		max_streams = 2;
>  	else if (AR_SREV_9300_20_OR_LATER(ah))
>  		max_streams = 3;
>  	else
I think AR9462 is also matched by AR_SREV_9300_20_OR_LATER(ah), so that
one may not be redundant.

- Felix
