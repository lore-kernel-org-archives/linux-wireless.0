Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43519 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbZHKSbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 14:31:18 -0400
Date: Tue, 11 Aug 2009 14:25:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Andrew Morton <akpm@linux-foundation.org>, m.sujith@gmail.com,
	mcgrof@gmail.com
Subject: Re: [PATCH] ath9k: Fix read buffer overflow
Message-ID: <20090811182514.GF2634@tuxdriver.com>
References: <4A7CA188.1070706@gmail.com> <20090810202622.GB6060@tuxdriver.com> <4A811464.4030108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A811464.4030108@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Comments from the ath9k crowd?

On Tue, Aug 11, 2009 at 08:49:08AM +0200, Roel Kluin wrote:
> Prevent a read of powInfo[-1] in the first iteration.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
> index ce0e86c..e67db2c 100644
> --- a/drivers/net/wireless/ath/ath9k/eeprom.c
> +++ b/drivers/net/wireless/ath/ath9k/eeprom.c
> @@ -150,10 +150,10 @@ static void ath9k_hw_get_legacy_target_powers(struct ath_hw *ah,
>  						       IS_CHAN_2GHZ(chan))) {
>  				matchIndex = i;
>  				break;
> -			} else if ((freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
> -						      IS_CHAN_2GHZ(chan))) &&
> -				   (freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
> -						      IS_CHAN_2GHZ(chan)))) {
> +			} else if (freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
> +						IS_CHAN_2GHZ(chan)) && i > 0 &&
> +				   freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
> +						IS_CHAN_2GHZ(chan))) {
>  				lowIndex = i - 1;
>  				break;
>  			}
> @@ -268,10 +268,10 @@ static void ath9k_hw_get_target_powers(struct ath_hw *ah,
>  				matchIndex = i;
>  				break;
>  			} else
> -				if ((freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
> -						       IS_CHAN_2GHZ(chan))) &&
> -				    (freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
> -						       IS_CHAN_2GHZ(chan)))) {
> +				if (freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
> +						IS_CHAN_2GHZ(chan)) && i > 0 &&
> +				    freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
> +						IS_CHAN_2GHZ(chan))) {
>  					lowIndex = i - 1;
>  					break;
>  				}
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
