Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48580 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab2GKSm5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 14:42:57 -0400
Message-ID: <4FFDC92D.2010103@openwrt.org> (sfid-20120711_204300_742155_EF32A35C)
Date: Wed, 11 Jul 2012 20:42:53 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 02/12] ath9k: validate rx antenna settings
References: <1342029555-31618-1-git-send-email-nbd@openwrt.org> <1342029555-31618-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1342029555-31618-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.07.11. 19:59 keltezéssel, Felix Fietkau írta:
> Many chips are not able to deal with non-consecutive rx antenna selections
> and respond with calibration errors, reset errors, etc.
> When an antenna is selected as a tx antenna, also flag it for rx to avoid
> chip issues.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |   19 ++++++++++++++++++-
>  1 files changed, 18 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 248e5b2..49f293a 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1912,12 +1912,29 @@ static u32 fill_chainmask(u32 cap, u32 new)
>  	return filled;
>  }
>  
> +static bool validate_antenna_mask(struct ath_hw *ah, u32 val)
> +{
> +	switch (val & ah->caps.rx_chainmask) {
> +	case 0x1:
> +	case 0x3:
> +	case 0x7:
> +		return true;
> +	case 0x2:
> +		return (ah->caps.rx_chainmask == 1);

This case statement seems superfluous. If 'rx_chainmask == 1' then 'val &
rx_chainmask' never will be 0x2.

> +	default:
> +		return false;
> +	}

Additionally, the function does not allows to set rx antenna to 0x2/0x3 for
chips with antenna diversity capabilities.

-Gabor
