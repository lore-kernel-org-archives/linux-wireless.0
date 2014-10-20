Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:50901 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaJTIsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 04:48:21 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21572.51260.633137.409500@gargle.gargle.HOWL> (sfid-20141020_104824_397460_9C6D0799)
Date: Mon, 20 Oct 2014 14:00:52 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 05/10] ath9k: restart hardware after noise floor calibration failure
In-Reply-To: <1413651732-69783-5-git-send-email-nbd@openwrt.org>
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
	<1413651732-69783-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
> index 2343f56..713b040 100644
> --- a/drivers/net/wireless/ath/ath9k/link.c
> +++ b/drivers/net/wireless/ath/ath9k/link.c
> @@ -371,9 +371,14 @@ void ath_ani_calibrate(unsigned long data)
>  
>  	/* Perform calibration if necessary */
>  	if (longcal || shortcal) {
> -		common->ani.caldone =
> -			ath9k_hw_calibrate(ah, ah->curchan,
> -					   ah->rxchainmask, longcal);
> +		int ret = ath9k_hw_calibrate(ah, ah->curchan, ah->rxchainmask,
> +					     longcal);
> +		if (ret < 0) {
> +			ath9k_queue_reset(sc, RESET_TYPE_CALIBRATION);
> +			return;
> +		}
> +
> +		common->ani.caldone = ret;

Shouldn't ani.caldone be set to false if calibration fails
(and true otherwise) ? It is used earlier in the ANI routine and
since this returns after queuing a reset, caldone will have
incorrect information, no ?

Sujith
