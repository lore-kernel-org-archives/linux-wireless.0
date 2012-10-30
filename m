Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53249 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab2J3NML (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 09:12:11 -0400
Message-ID: <508FD21C.6080707@openwrt.org> (sfid-20121030_141216_356581_55D003BE)
Date: Tue, 30 Oct 2012 14:11:56 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: Do not enable ANT diversity if ANT control
 bit is not set
References: <1351595612-3566-1-git-send-email-bkamatch@qca.qualcomm.com>
In-Reply-To: <1351595612-3566-1-git-send-email-bkamatch@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-30 12:13 PM, Bala Shanmugam wrote:
> RvR test is not good when ANT control bit is not set so
> enable ANT diversity only when ANT control bit is set.
> 
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
I don't really like this patch; not only is the description very vague,
but it seems to me that the checks are done at the wrong place.

Further comments below...

> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> @@ -1340,10 +1340,9 @@ static void ar9003_hw_antctrl_shared_chain_lnadiv(struct ath_hw *ah,
>  	regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
>  	regval &= (~AR_ANT_DIV_CTRL_ALL);
>  	regval |= (ant_div_ctl1 & 0x3f) << AR_ANT_DIV_CTRL_ALL_S;
> -	regval &= ~AR_PHY_ANT_DIV_LNADIV;
> -	regval |= ((ant_div_ctl1 >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
>  
> -	if (enable)
> +	if (enable &&
> +	    (ant_div_ctl1 & AR_EEP_ANT_DIV_ENABLE))
>  		regval |= AR_ANT_DIV_ENABLE;
>  
>  	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
The code should check much earlier (preferably somewhere in the eeprom
code) if diversity is available at all, and set a capability
accordingly, so that it doesn't even call this function with
enable==true if no diversity is available.

> @@ -1352,12 +1351,15 @@ static void ar9003_hw_antctrl_shared_chain_lnadiv(struct ath_hw *ah,
>  	regval &= ~AR_FAST_DIV_ENABLE;
>  	regval |= ((ant_div_ctl1 >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
>  
> -	if (enable)
> +	if (enable &&
> +	    (ant_div_ctl1 & AR_EEP_FAST_DIV_ENABLE))
>  		regval |= AR_FAST_DIV_ENABLE;
>  
It would be much simpler to just remove the if statement and the line
below it. This would be equivalent to what you're doing because of this:
  	regval |= ((ant_div_ctl1 >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;

- Felix
