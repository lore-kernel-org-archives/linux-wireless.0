Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbbJUCAd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 22:00:33 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 10/16] rtl8xxxu: Rename struct rtl8723au_idx
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
	<1445323546-12807-11-git-send-email-jsitnicki@gmail.com>
Date: Tue, 20 Oct 2015 22:00:31 -0400
In-Reply-To: <1445323546-12807-11-git-send-email-jsitnicki@gmail.com> (Jakub
	Sitnicki's message of "Tue, 20 Oct 2015 08:45:40 +0200")
Message-ID: <wrfj7fmhvv40.fsf@redhat.com> (sfid-20151021_040035_697188_AC68DDF6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 16 +++++-----
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 38 ++++++++++++------------
>  2 files changed, 27 insertions(+), 27 deletions(-)

This name change just make the naming worse. If this really needs to be
changed, at least make the change something that improves the naming.

Jes

>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> index 992bcda..d48db87 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> @@ -1505,21 +1505,21 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
>  	ofdm[0] = tx_power->ht40_1s_index_A[group];
>  	ofdm[1] = tx_power->ht40_1s_index_B[group];
>  
> -	ofdmbase[0] = ofdm[0] +	tx_power->ofdm_index_diff[group].a;
> -	ofdmbase[1] = ofdm[1] +	tx_power->ofdm_index_diff[group].b;
> +	ofdmbase[0] = ofdm[0] +	tx_power->ofdm_index_diff[group].low;
> +	ofdmbase[1] = ofdm[1] +	tx_power->ofdm_index_diff[group].high;
>  
>  	mcsbase[0] = ofdm[0];
>  	mcsbase[1] = ofdm[1];
>  	if (!ht40) {
> -		mcsbase[0] += tx_power->ht20_index_diff[group].a;
> -		mcsbase[1] += tx_power->ht20_index_diff[group].b;
> +		mcsbase[0] += tx_power->ht20_index_diff[group].low;
> +		mcsbase[1] += tx_power->ht20_index_diff[group].high;
>  	}
>  
>  	if (priv->tx_paths > 1) {
> -		if (ofdm[0] > tx_power->ht40_2s_index_diff[group].a)
> -			ofdm[0] -= tx_power->ht40_2s_index_diff[group].a;
> -		if (ofdm[1] > tx_power->ht40_2s_index_diff[group].b)
> -			ofdm[1] -= tx_power->ht40_2s_index_diff[group].b;
> +		if (ofdm[0] > tx_power->ht40_2s_index_diff[group].low)
> +			ofdm[0] -= tx_power->ht40_2s_index_diff[group].low;
> +		if (ofdm[1] > tx_power->ht40_2s_index_diff[group].high)
> +			ofdm[1] -= tx_power->ht40_2s_index_diff[group].high;
>  	}
>  
>  	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_CHANNEL)
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index 23bf4c0..2f5f903 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -407,13 +407,13 @@ struct rtl8xxxu_firmware_header {
>  /*
>   * The 8723au has 3 channel groups: 1-3, 4-9, and 10-14
>   */
> -struct rtl8723au_idx {
> +struct nibble_pair {
>  #ifdef __LITTLE_ENDIAN
> -	int	a:4;
> -	int	b:4;
> +	int	low:4;
> +	int	high:4;
>  #else
> -	int	b:4;
> -	int	a:4;
> +	int	high:4;
> +	int	low:4;
>  #endif
>  } __attribute__((packed));
>  
> @@ -428,10 +428,10 @@ struct rtl8723au_efuse {
>  	 * The following entries are half-bytes split as:
>  	 * bits 0-3: path A, bits 4-7: path B, all values 4 bits signed
>  	 */
> -	struct rtl8723au_idx ht20_tx_power_index_diff[3];
> -	struct rtl8723au_idx ofdm_tx_power_index_diff[3];
> -	struct rtl8723au_idx ht40_max_power_offset[3];
> -	struct rtl8723au_idx ht20_max_power_offset[3];
> +	struct nibble_pair ht20_tx_power_index_diff[3];
> +	struct nibble_pair ofdm_tx_power_index_diff[3];
> +	struct nibble_pair ht40_max_power_offset[3];
> +	struct nibble_pair ht20_max_power_offset[3];
>  	u8 channel_plan;		/* 0x28 */
>  	u8 tssi_a;
>  	u8 thermal_meter;
> @@ -482,11 +482,11 @@ struct rtl8192cu_efuse {
>  	 * The following entries are half-bytes split as:
>  	 * bits 0-3: path A, bits 4-7: path B, all values 4 bits signed
>  	 */
> -	struct rtl8723au_idx ht40_2s_tx_power_index_diff[3];
> -	struct rtl8723au_idx ht20_tx_power_index_diff[3];	/* 0x69 */
> -	struct rtl8723au_idx ofdm_tx_power_index_diff[3];
> -	struct rtl8723au_idx ht40_max_power_offset[3];		/* 0x6f */
> -	struct rtl8723au_idx ht20_max_power_offset[3];
> +	struct nibble_pair ht40_2s_tx_power_index_diff[3];
> +	struct nibble_pair ht20_tx_power_index_diff[3];		/* 0x69 */
> +	struct nibble_pair ofdm_tx_power_index_diff[3];
> +	struct nibble_pair ht40_max_power_offset[3];		/* 0x6f */
> +	struct nibble_pair ht20_max_power_offset[3];
>  	u8 channel_plan;					/* 0x75 */
>  	u8 tssi_a;
>  	u8 tssi_b;
> @@ -573,11 +573,11 @@ struct rtl8723au_tx_power {
>  	 * The following entries are half-bytes split as:
>  	 * bits 0-3: path A, bits 4-7: path B, all values 4 bits signed
>  	 */
> -	struct rtl8723au_idx ht40_2s_index_diff[3];
> -	struct rtl8723au_idx ht20_index_diff[3];
> -	struct rtl8723au_idx ofdm_index_diff[3];
> -	struct rtl8723au_idx ht40_max_offset[3];
> -	struct rtl8723au_idx ht20_max_offset[3];
> +	struct nibble_pair ht40_2s_index_diff[3];
> +	struct nibble_pair ht20_index_diff[3];
> +	struct nibble_pair ofdm_index_diff[3];
> +	struct nibble_pair ht40_max_offset[3];
> +	struct nibble_pair ht20_max_offset[3];
>  };
>  
>  struct rtl8xxxu_priv {
