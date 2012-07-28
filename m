Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:59044 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680Ab2G1P04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2012 11:26:56 -0400
Message-ID: <501404BE.7040606@net.t-labs.tu-berlin.de> (sfid-20120728_172658_595930_079D802D)
Date: Sat, 28 Jul 2012 17:26:54 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 3/4] ath5k: Preserve tx power level requested from above
 on phy_init
References: <1343485971-31360-1-git-send-email-mickflemm@gmail.com> <1343485971-31360-3-git-send-email-mickflemm@gmail.com>
In-Reply-To: <1343485971-31360-3-git-send-email-mickflemm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick,

Nick Kossifidis schrieb:

> By using cur_pwr on phy_init we re-use the power level previously set by the
> driver, not the one we got from above.
> 
> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 84a9aaf..27ca993 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -3802,8 +3802,8 @@ ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>  	 * RF buffer settings on 5211/5212+ so that we
>  	 * properly set curve indices.
>  	 */
> -	ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_cur_pwr ?
> -			ah->ah_txpower.txp_cur_pwr / 2 : AR5K_TUNE_MAX_TXPOWER);
> +	ret = ath5k_hw_txpower(ah, channel, ah->power_level ?
> +			ah->power_level * 2 : AR5K_TUNE_MAX_TXPOWER);
>  	if (ret)
>  		return ret;
>  


I would suggest to initialise the power_level as AR5K_TUNE_MAX_TXPOWER
in base.c funktion ath5k_init(struct ieee80211_hw *hw)

      /* init tx_power setting to maximum */
      ah->ah_txpower.txp_user_pwr = AR5K_TUNE_MAX_TXPOWER;

that would simplify the readability form above into:
	ret = ath5k_hw_txpower(ah, channel, ah->power_level)

What do you think ?

Greetings Thomas
