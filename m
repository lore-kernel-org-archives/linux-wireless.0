Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18413 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178Ab0LBXv5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 18:51:57 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 15:51:43 -0800
Date: Thu, 2 Dec 2010 15:51:55 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Matteo Croce <technoboy85@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [PATCH]: ath9k: fix bug in tx power
Message-ID: <20101202235155.GN7399@tux>
References: <AANLkTim0L7e+RZ1v6B3+s_Z7pOZ6KAgvZ_tZEQJnMHET@mail.gmail.com>
 <AANLkTikq7h3hwVBQBWv+Avhzc6KZLxRC3OkxjpbgwQ8M@mail.gmail.com>
 <AANLkTinY5Ook3Jk=P8KW34djuAzK1sVJgPds9mZkU4sk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTinY5Ook3Jk=P8KW34djuAzK1sVJgPds9mZkU4sk@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 02, 2010 at 03:39:49PM -0800, Matteo Croce wrote:
> The ath9k driver subtracts 3 dBm to the txpower as with two radios the
> signal power is doubled.
> The resulting value is assigned in an u16 which overflows and makes
> the card work at full power.

Sorry can you also add:

Cc: stable@kernel.org

Right above your Signed-off-by, this is a regulatory fix,
thanks.
 
  Luis
> 
> Signed-off-by: Matteo Croce <matteo@openwrt.org>
> 
> --- a/drivers/net/wireless/ath/ath9k/eeprom_def.c	2010-12-02
> 22:39:58.982020001 +0100
> +++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c	2010-12-03
> 00:36:23.637799002 +0100
> @@ -1065,15 +1065,19 @@
>  	case 1:
>  		break;
>  	case 2:
> -		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
> +		if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
> +			scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
> +		else
> +			scaledPower = 0;
>  		break;
>  	case 3:
> -		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
> +		if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
> +			scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
> +		else
> +			scaledPower = 0;
>  		break;
>  	}
> 
> -	scaledPower = max((u16)0, scaledPower);
> -
>  	if (IS_CHAN_2GHZ(chan)) {
>  		numCtlModes = ARRAY_SIZE(ctlModesFor11g) -
>  			SUB_NUM_CTL_MODES_AT_2G_40;
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
