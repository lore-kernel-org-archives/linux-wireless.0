Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbbKJV5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 16:57:08 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: rtl8192eu: Map out EFUSE TX power area
References: <wrfjh9ld34ng.fsf@redhat.com>
	<1446452517-14920-1-git-send-email-jsitnicki@gmail.com>
Date: Tue, 10 Nov 2015 16:57:04 -0500
In-Reply-To: <1446452517-14920-1-git-send-email-jsitnicki@gmail.com> (Jakub
	Sitnicki's message of "Mon, 2 Nov 2015 09:21:57 +0100")
Message-ID: <wrfjwptpsekv.fsf@carbonite.lan.trained-monkey.org> (sfid-20151110_225712_343362_56B6215F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> TX power values are laid out differently in EFUSE found in RTL8192EU &
> RTL8188EU devices.  TX power indices and differences for each RF path
> are not interleaved (A, B, A, B), as in other chips, but follow one
> another (A, B, C, D).
>
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
> ---
>
> Jes,
>
> I reckon this is as "pretty" as it gets.  I even took the time to draw
> it out:
>
>   https://github.com/jsitnicki/realtek-notes/blob/master/efuse-tx-power.pdf
>
> The whole TX power area is aligned to a multiple of 8, but subareas
> for each RF path are not aligned (they are 18 bytes long each).
>
> Patch is for rtl8xxxu-nextgen, of course.  Anything you would rename?
>
> Cheers,
> Jakub

Jakub,

Thanks for digging through this! Patch looks good to me, I'll try to
see if it applies. I have been working on 8723bu support so things have
changed a bit.

Cheers,
Jes

>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c |  4 ++--
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 22 +++++++++++++++++-----
>  2 files changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> index 8c7d2da..6a89710 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> @@ -2300,7 +2300,7 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
>  		return -EINVAL;
>  
>  	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
> -
> +#if 0
>  	memcpy(priv->cck_tx_power_index_A, efuse->cck_tx_power_index_A,
>  	       sizeof(priv->cck_tx_power_index_A));
>  	memcpy(priv->cck_tx_power_index_B, efuse->cck_tx_power_index_B,
> @@ -2310,7 +2310,7 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
>  	       sizeof(priv->ht40_1s_tx_power_index_A));
>  	memcpy(priv->ht40_1s_tx_power_index_B, efuse->ht40_1s_tx_power_index_B,
>  	       sizeof(priv->ht40_1s_tx_power_index_B));
> -#if 0
> +
>  	memcpy(priv->ht40_2s_tx_power_index_diff,
>  	       efuse->ht40_2s_tx_power_index_diff,
>  	       sizeof(priv->ht40_2s_tx_power_index_diff));
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index 4b8431d..b223831 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -543,14 +543,26 @@ struct rtl8723bu_efuse {
>  	u8 res12[0x4];
>  };
>  
> +struct rtl8192eu_efuse_tx_power {
> +	u8 cck_base[6];
> +	u8 ht40_base[5];
> +	struct rtl8723au_idx ht20_ofdm_1s_diff;
> +	struct rtl8723au_idx ht40_ht20_2s_diff;
> +	struct rtl8723au_idx ofdm_cck_2s_diff; /* not used */
> +	struct rtl8723au_idx ht40_ht20_3s_diff;
> +	struct rtl8723au_idx ofdm_cck_3s_diff; /* not used */
> +	struct rtl8723au_idx ht40_ht20_4s_diff;
> +	struct rtl8723au_idx ofdm_cck_4s_diff; /* not used */
> +};
> +
>  struct rtl8192eu_efuse {
>  	__le16 rtl_id;
>  	u8 res0[0x0e];
> -	u8 cck_tx_power_index_A[3];	/* 0x10 */
> -	u8 cck_tx_power_index_B[3];
> -	u8 ht40_1s_tx_power_index_A[3];	/* 0x16 */
> -	u8 ht40_1s_tx_power_index_B[3];
> -	u8 res1[0x9c];
> +	struct rtl8192eu_efuse_tx_power tx_power_index_A;	/* 0x10 */
> +	struct rtl8192eu_efuse_tx_power tx_power_index_B;	/* 0x22 */
> +	struct rtl8192eu_efuse_tx_power tx_power_index_C;	/* 0x34 */
> +	struct rtl8192eu_efuse_tx_power tx_power_index_D;	/* 0x46 */
> +	u8 res1[0x60];
>  	u8 channel_plan;		/* 0xb8 */
>  	u8 xtal_k;
>  	u8 thermal_meter;
