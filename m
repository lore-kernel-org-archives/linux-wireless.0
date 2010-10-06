Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49806 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010Ab0JFUpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 16:45:06 -0400
Date: Wed, 6 Oct 2010 16:32:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Rajkumar Manoharan <Rajkumar.Manoharan@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Subject: Re: [PATCH v3 3/4] ath9k_hw: clean up register write buffering
Message-ID: <20101006203240.GM2472@tuxdriver.com>
References: <1286125639-15137-1-git-send-email-nbd@openwrt.org>
 <1286125639-15137-2-git-send-email-nbd@openwrt.org>
 <1286125639-15137-3-git-send-email-nbd@openwrt.org>
 <20101004085608.GA5931@vmraj-lnx.users.atheros.com>
 <4CA9C03D.9010503@openwrt.org>
 <4CAA0D5E.1080200@openwrt.org>
 <20101005043856.GB2462@senthil-lnx.users.atheros.com>
 <4CAAF7FE.1050105@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CAAF7FE.1050105@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 05, 2010 at 12:03:42PM +0200, Felix Fietkau wrote:
> Throughout the code, DISABLE_REGWRITE_BUFFER is always called right after
> REGWRITE_BUFFER_FLUSH. Since that's unlikely to change any time soon, that
> makes keeping those ops separate rather pointless, as it only increases
> code size and line number counts.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath.h                |    4 +---
>  drivers/net/wireless/ath/ath9k/ani.c          |    6 ------
>  drivers/net/wireless/ath/ath9k/ar5008_phy.c   |    9 ++-------
>  drivers/net/wireless/ath/ath9k/ar9002_calib.c |    1 -
>  drivers/net/wireless/ath/ath9k/ar9002_hw.c    |    4 ----
>  drivers/net/wireless/ath/ath9k/ar9002_phy.c   |    1 -
>  drivers/net/wireless/ath/ath9k/calib.c        |    1 -
>  drivers/net/wireless/ath/ath9k/eeprom_4k.c    |    2 --
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |   12 ++----------
>  drivers/net/wireless/ath/ath9k/hw.c           |   14 --------------
>  drivers/net/wireless/ath/ath9k/hw.h           |   10 ++--------
>  drivers/net/wireless/ath/ath9k/mac.c          |    4 ----
>  12 files changed, 7 insertions(+), 61 deletions(-)
> 
> v2: removed mwrite_cnt test
> v3: removed comment about it from description

Several patch hunks are buggered...examples:

>  diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
> index 9936297..61e7a48 100644
> --- a/drivers/net/wireless/ath/ath9k/ani.c
> +++ b/drivers/net/wireless/ath/ath9k/ani.c
> @@ -180,7 +180,6 @@ static void ath9k_ani_restart_old(struct ath_hw *ah)
>  	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
>   	REGWRITE_BUFFER_FLUSH(ah);
> -	DISABLE_REGWRITE_BUFFER(ah);
>   	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
>  @@ -215,7 +214,6 @@ static void ath9k_ani_restart_new(struct ath_hw *ah)
>  	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
>   	REGWRITE_BUFFER_FLUSH(ah);
> -	DISABLE_REGWRITE_BUFFER(ah);
>   	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
>  @@ -643,7 +641,6 @@ static void ath9k_ani_reset_old(struct ath_hw *ah, bool is_scanning)
>  	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
>   	REGWRITE_BUFFER_FLUSH(ah);
> -	DISABLE_REGWRITE_BUFFER(ah);
>  }
>   /*

I applied the v2 version, but w/ the modification to the commit log.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
