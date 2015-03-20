Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33197 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbbCTNCM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:02:12 -0400
Message-ID: <550C1A3F.5090101@openwrt.org> (sfid-20150320_140216_209960_A54151F6)
Date: Fri, 20 Mar 2015 14:01:51 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, adrian@freebsd.org
Subject: Re: [PATCH 18/18] ath9k: use REG_RMW and rmw buffer in ath9k_hw_def_set_gain
References: <1426855138-6121-1-git-send-email-linux@rempel-privat.de> <1426855138-6121-19-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1426855138-6121-19-git-send-email-linux@rempel-privat.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-03-20 13:38, Oleksij Rempel wrote:
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> ---
>  drivers/net/wireless/ath/ath9k/eeprom_def.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
> index 0980590..4b43539 100644
> --- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
> +++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
> @@ -466,6 +466,7 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
>  				  struct ar5416_eeprom_def *eep,
>  				  u8 txRxAttenLocal, int regChainOffset, int i)
>  {
> +	ENABLE_REG_RMW_BUFFER(ah);
>  	if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_3) {
>  		txRxAttenLocal = pModal->txRxAttenCh[i];
>  
> @@ -483,16 +484,16 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
>  			      AR_PHY_GAIN_2GHZ_XATTEN2_DB,
>  			      pModal->xatten2Db[i]);
>  		} else {
> -			REG_WRITE(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
> +			REG_RMW(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
>  			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
>  			   ~AR_PHY_GAIN_2GHZ_BSW_MARGIN)
>  			  | SM(pModal-> bswMargin[i],
> -			       AR_PHY_GAIN_2GHZ_BSW_MARGIN));
> -			REG_WRITE(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
> +			       AR_PHY_GAIN_2GHZ_BSW_MARGIN), 0);
> +			REG_RMW(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
>  			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
>  			   ~AR_PHY_GAIN_2GHZ_BSW_ATTEN)
>  			  | SM(pModal->bswAtten[i],
> -			       AR_PHY_GAIN_2GHZ_BSW_ATTEN));
> +			       AR_PHY_GAIN_2GHZ_BSW_ATTEN), 0);
>  		}
>  	}
>  
> @@ -504,17 +505,19 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
>  		      AR_PHY_RXGAIN + regChainOffset,
>  		      AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[i]);
>  	} else {
> -		REG_WRITE(ah,
> +		REG_RMW(ah,
>  			  AR_PHY_RXGAIN + regChainOffset,
>  			  (REG_READ(ah, AR_PHY_RXGAIN + regChainOffset) &
>  			   ~AR_PHY_RXGAIN_TXRX_ATTEN)
> -			  | SM(txRxAttenLocal, AR_PHY_RXGAIN_TXRX_ATTEN));
> -		REG_WRITE(ah,
> +			  | SM(txRxAttenLocal, AR_PHY_RXGAIN_TXRX_ATTEN), 0);
> +		REG_RMW(ah,
>  			  AR_PHY_GAIN_2GHZ + regChainOffset,
>  			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
>  			   ~AR_PHY_GAIN_2GHZ_RXTX_MARGIN) |
> -			  SM(pModal->rxTxMarginCh[i], AR_PHY_GAIN_2GHZ_RXTX_MARGIN));
> +			  SM(pModal->rxTxMarginCh[i],
> +			  AR_PHY_GAIN_2GHZ_RXTX_MARGIN), 0);
>  	}
> +	REG_RMW_BUFFER_FLUSH(ah);
Same in those chunks as in the other patch, do proper conversion to
REG_RMW by eliminating the REG_READ.

- Felix
