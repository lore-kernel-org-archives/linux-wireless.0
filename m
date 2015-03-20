Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33172 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbbCTNA1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:00:27 -0400
Message-ID: <550C19E1.1020305@openwrt.org> (sfid-20150320_140030_496486_B5D384CB)
Date: Fri, 20 Mar 2015 14:00:17 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, adrian@freebsd.org
Subject: Re: [PATCH 16/18] ath9k: use REG_RMW and rmw buffer in ath9k_hw_4k_set_gain
References: <1426855138-6121-1-git-send-email-linux@rempel-privat.de> <1426855138-6121-17-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1426855138-6121-17-git-send-email-linux@rempel-privat.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-03-20 13:38, Oleksij Rempel wrote:
> it is possible to reduce time needed for this function
> by rplacing REG_WRITE with REG_RMW (plus dummy 0) and putt all commands
> in same buffer.
> 
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> ---
>  drivers/net/wireless/ath/ath9k/eeprom_4k.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
> index 291c1d1..56621be 100644
> --- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
> +++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
> @@ -772,15 +772,16 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
>  				 struct ar5416_eeprom_4k *eep,
>  				 u8 txRxAttenLocal)
>  {
> -	REG_WRITE(ah, AR_PHY_SWITCH_CHAIN_0,
> -		  pModal->antCtrlChain[0]);
> +	ENABLE_REG_RMW_BUFFER(ah);
> +	REG_RMW(ah, AR_PHY_SWITCH_CHAIN_0,
> +		pModal->antCtrlChain[0], 0);
How about combining the WRITE/RMW buffering in ath9k_htc (automatically
deciding whether to use RMW or WRITE for the whole transaction), instead
of quirky looking REG_WRITE to REG_RMW conversions?

> -	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0),
> -		  (REG_READ(ah, AR_PHY_TIMING_CTRL4(0)) &
> -		   ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
> -		     AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
> -		  SM(pModal->iqCalICh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
> -		  SM(pModal->iqCalQCh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
> +	REG_RMW(ah, AR_PHY_TIMING_CTRL4(0),
> +		(REG_READ(ah, AR_PHY_TIMING_CTRL4(0)) &
> +		 ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
> +		   AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
> +		SM(pModal->iqCalICh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
> +		SM(pModal->iqCalQCh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF), 0);
If you translate it to REG_RMW, you should get rid of the REG_READ part.

- Felix
