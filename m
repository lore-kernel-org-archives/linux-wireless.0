Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44755 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab0LAQux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 11:50:53 -0500
Message-ID: <4CF67CEA.5000305@openwrt.org>
Date: Wed, 01 Dec 2010 17:50:50 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 16/26] ath9k_hw: Configure attenuation control only for
 chain 0 on AR9485
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com> <1291188775-13707-17-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-17-git-send-email-vasanth@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-12-01 8:32 AM, Vasanthakumar Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> index 9ce6846..71316ec 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> @@ -3639,9 +3639,13 @@ static void ar9003_hw_atten_apply(struct ath_hw *ah, struct ath9k_channel *chan)
>  					  AR_PHY_EXT_ATTEN_CTL_1,
>  					  AR_PHY_EXT_ATTEN_CTL_2,
>  					 };
> +	u8 max_chains = AR9300_MAX_CHAINS;
> +
> +	if (AR_SREV_9485(ah))
> +		max_chains = 1;
>  
>  	/* Test value. if 0 then attenuation is unused. Don't load anything. */
> -	for (i = 0; i < 3; i++) {
> +	for (i = 0; i < max_chains; i++) {
>  		value = ar9003_hw_atten_chain_get(ah, i, chan);
>  		REG_RMW_FIELD(ah, ext_atten_reg[i],
>  			      AR_PHY_EXT_ATTEN_CTL_XATTEN1_DB, value);
Since the issue of having second/third chain registers unimplemented in
certain chips is going to be the same on AR9344 and other WiSoC chips as
well, how about adding an ath9k_hw variable max_hw_chains and using that
wherever extended chain registers would be accessed.
That would save us from having to throw around new SREV checks over and
over again for the same issue.

- Felix
