Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:60739 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaJTIsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 04:48:36 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21572.52159.282902.959145@gargle.gargle.HOWL> (sfid-20141020_104847_717237_41E80D7D)
Date: Mon, 20 Oct 2014 14:15:51 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 07/10] ath9k_hw: start initial NF calibration after PA calibration on <AR9003
In-Reply-To: <1413651732-69783-7-git-send-email-nbd@openwrt.org>
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
	<1413651732-69783-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
>  	ar9002_hw_pa_cal(ah, true);
> +	ath9k_hw_start_nfcal(ah, true);
>  
>  	if (ah->caldata)
>  		set_bit(NFCAL_PENDING, &ah->caldata->cal_flags);
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index 8be4b14..85a7817 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -1953,8 +1953,10 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
>  	if (ath9k_hw_mci_is_enabled(ah))
>  		ar9003_mci_check_bt(ah);
>  
> -	ath9k_hw_loadnf(ah, chan);
> -	ath9k_hw_start_nfcal(ah, true);
> +	if (AR_SREV_9300_20_OR_LATER(ah)) {
> +		ath9k_hw_loadnf(ah, chan);
> +		ath9k_hw_start_nfcal(ah, true);
> +	}

This doesn't seem to load the NF registers for AR9002 ?
If a chip reset is done for some reason when the driver is
operational, don't we have to load the history values ?

Sujith

