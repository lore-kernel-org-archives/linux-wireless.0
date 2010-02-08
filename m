Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:49674 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0BHJU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 04:20:26 -0500
Received: from az33smr02.freescale.net (az33smr02.freescale.net [10.64.34.200])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id o189KFkD007951
	for <linux-wireless@vger.kernel.org>; Mon, 8 Feb 2010 02:20:15 -0700 (MST)
Received: from zmy16exm21.fsl.freescale.net (zmy16exm21.ap.freescale.net [10.211.3.25])
	by az33smr02.freescale.net (8.13.1/8.13.0) with ESMTP id o189KIvq002805
	for <linux-wireless@vger.kernel.org>; Mon, 8 Feb 2010 03:20:19 -0600 (CST)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Subject: RE: [ath9k-devel] can ath9k run on linux 2.6.25
Date: Mon, 8 Feb 2010 17:20:09 +0800
Message-ID: <25E8B46727291E4EB5A1CB88CBC4284E0100A711@zmy16exm21.fsl.freescale.net>
In-Reply-To: <1265467103-11474-1-git-send-email-tom.leiming@gmail.com>
References: <1265467103-11474-1-git-send-email-tom.leiming@gmail.com>
From: "Zhang Yanfei-B21500" <B21500@freescale.com>
To: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<ath9k-devel@venema.h4ckr.net>, <johannes@sipsolutions.net>,
	<stable@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All
	Anyone have porting the ath9k to 2.6.25? Is it can work on
2.6.25?


Regards,
Yanfei Zhang
 

> -----Original Message-----
> From: ath9k-devel-bounces@venema.h4ckr.net 
> [mailto:ath9k-devel-bounces@venema.h4ckr.net] On Behalf Of 
> tom.leiming@gmail.com
> Sent: Saturday, February 06, 2010 10:38 PM
> To: lrodriguez@atheros.com
> Cc: linux-wireless@vger.kernel.org; linville@tuxdriver.com; 
> ath9k-devel@venema.h4ckr.net; johannes@sipsolutions.net; 
> stable@kernel.org
> Subject: [ath9k-devel] [PATCH] ath9k: fix keycache leak in 
> split tkip case
> 
> From: Ming Lei <tom.leiming@gmail.com>
> 
> If split tkip key is used, ath_delete_key should delete rx 
> key and rx mic key. This patch fixes the leak of hw keycache 
> in the case.
> 
> ---
> The patch is against the latest wireless test tree.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c 
> b/drivers/net/wireless/ath/ath9k/main.c
> index 6796d5c..928402b 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -809,6 +809,7 @@ static void ath_key_delete(struct 
> ath_common *common, struct ieee80211_key_conf
>  
>  	clear_bit(key->hw_key_idx + 64, common->keymap);
>  	if (common->splitmic) {
> +		ath9k_hw_keyreset(ah, key->hw_key_idx + 32);
>  		clear_bit(key->hw_key_idx + 32, common->keymap);
>  		clear_bit(key->hw_key_idx + 64 + 32, common->keymap);
>  	}
> --
> 1.6.2.5
> 
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
> 
> 
