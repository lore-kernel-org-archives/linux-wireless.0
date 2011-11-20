Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39282 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab1KTJXZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 04:23:25 -0500
Message-ID: <4EC8C6FD.1030103@openwrt.org> (sfid-20111120_102329_978217_DB9EFF53)
Date: Sun, 20 Nov 2011 10:23:09 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com
Subject: Re: [PATCH 06/13] ath5k: Use usleep_range where possible
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com> <1321775788-12520-7-git-send-email-mickflemm@gmail.com>
In-Reply-To: <1321775788-12520-7-git-send-email-mickflemm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-11-20 8:56 AM, Nick Kossifidis wrote:
> Use usleep_range where possible to reduce busy waits
> 
> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
> ---
>  drivers/net/wireless/ath/ath5k/attach.c |    2 +-
>  drivers/net/wireless/ath/ath5k/pci.c    |    2 +-
>  drivers/net/wireless/ath/ath5k/phy.c    |   22 +++++++++++-----------
>  drivers/net/wireless/ath/ath5k/reset.c  |   14 +++++++-------
>  4 files changed, 20 insertions(+), 20 deletions(-)
> 
> @@ -1454,7 +1454,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
>  	beacon = ath5k_hw_reg_read(ah, AR5K_BEACON_5210);
>  	ath5k_hw_reg_write(ah, beacon & ~AR5K_BEACON_ENABLE, AR5K_BEACON_5210);
>  
> -	mdelay(2);
> +	usleep_range(2000, 2500);
>  
>  	/*
>  	 * Set the channel (with AGC turned off)
> @@ -1467,7 +1467,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
>  	 * Activate PHY and wait
>  	 */
>  	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
> -	mdelay(1);
> +	usleep_range(1000, 1500);
>  
>  	AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
>  
Are you sure this is safe? This looks like it's being called from
tasklet context, and I think usleep_range is not allowed there.

- Felix
