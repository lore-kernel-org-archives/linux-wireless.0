Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48741 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3LPEXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 23:23:48 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21166.30518.304613.545323@gargle.gargle.HOWL> (sfid-20131216_052351_563516_348B4578)
Date: Mon, 16 Dec 2013 09:14:54 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 06/11] ath9k_hw: remove ah->config.pcie_clock_req
In-Reply-To: <1387040625-38114-6-git-send-email-nbd@openwrt.org>
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
	<1387040625-38114-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> -	if (ah->config.pcie_clock_req)
> -		INIT_INI_ARRAY(&ah->iniPcieSerdes,
> -			   ar9280PciePhy_clkreq_off_L1_9280);
> -	else
> -		INIT_INI_ARRAY(&ah->iniPcieSerdes,
> -			   ar9280PciePhy_clkreq_always_on_L1_9280);
> +	INIT_INI_ARRAY(&ah->iniPcieSerdes,
> +		       ar9280PciePhy_clkreq_always_on_L1_9280);
>  
>  	if (AR_SREV_9287_11_OR_LATER(ah)) {
>  		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1);
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index a403cfc..eeb0741 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -446,7 +446,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
>  	ah->config.additional_swba_backoff = 0;
>  	ah->config.ack_6mb = 0x0;
>  	ah->config.cwm_ignore_extcca = 0;
> -	ah->config.pcie_clock_req = 0;
>  	ah->config.analog_shiftreg = 1;

Please leave this in the driver, this has to be set for selected
cards. I'll look at the Windows registry and add platform support.

Sujith
