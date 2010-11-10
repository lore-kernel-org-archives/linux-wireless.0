Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42951 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756001Ab0KJNG0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 08:06:26 -0500
Message-ID: <4CDA98CF.4060904@openwrt.org>
Date: Wed, 10 Nov 2010 14:06:23 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vivek Natarajan <vnatarajan@atheros.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 4/5] ath9k: Add support for Tx beamforming feature.
References: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com> <1289391829-8577-2-git-send-email-vnatarajan@atheros.com> <1289391829-8577-3-git-send-email-vnatarajan@atheros.com> <1289391829-8577-4-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1289391829-8577-4-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-10 1:23 PM, Vivek Natarajan wrote:
> Beamforming is enabled with the latest hardware if the module parameter
> is set.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h |    2 +
>  drivers/net/wireless/ath/ath9k/init.c  |    9 +
>  drivers/net/wireless/ath/ath9k/main.c  |   22 ++
>  drivers/net/wireless/ath/ath9k/rc.c    |  453 ++++++++++++++++++++------------
>  drivers/net/wireless/ath/ath9k/rc.h    |   90 +++++++-
>  drivers/net/wireless/ath/ath9k/xmit.c  |   43 +++-
>  6 files changed, 454 insertions(+), 165 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 8a2b04e..5216999 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -270,6 +270,8 @@ struct ath_node {
>  	struct ath_atx_ac ac[WME_NUM_AC];
>  	u16 maxampdu;
>  	u8 mpdudensity;
> +	bool txbf;
> +	u8 key_idx;
>  };
>  
>  #define AGGR_CLEANUP         BIT(1)
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index f14fe53..531efe7 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -38,6 +38,10 @@ int led_blink;
>  module_param_named(blink, led_blink, int, 0444);
>  MODULE_PARM_DESC(blink, "Enable LED blink on activity");
>  
> +int txbf;
> +module_param_named(txbf, txbf, int, 0444);
> +MODULE_PARM_DESC(blink, "Enable TxBF");
> +
I don't think a module parameter is a good idea here. If you want to
make it possible to disable txbf, just add a debugfs entry.

> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> index 85c8e93..0b9c405 100644
> --- a/drivers/net/wireless/ath/ath9k/rc.c
> +++ b/drivers/net/wireless/ath/ath9k/rc.c
> @@ -749,6 +828,14 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
>  	if (rate_control_send_low(sta, priv_sta, txrc))
>  		return;
>  
> +#define MS(_v, _f)  (((_v) & _f) >> _f##_S)
That one's already defined in hw.h

> @@ -807,6 +903,16 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
>  		/* All other rates in the series have RTS enabled */
>  		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
>  				       try_per_rate, rix, 1);
> +
> +		if (ath_rc_priv->txbf && ath_rc_priv->txbf_sounding) {
> +			if (rates[i].flags & IEEE80211_TX_RC_MCS)
> +				rates[i].flags &= ~IEEE80211_TX_RC_SHORT_GI;
> +			else {
> +				/* Remove sounding */
> +				hdr->frame_control &=
> +					~cpu_to_le16(IEEE80211_FCTL_ORDER);
Shouldn't mac80211 take care of ensuring hdr->frame_control sanity?
Doing this in the rate control module seems a little messy to me.

> @@ -1189,6 +1298,10 @@ struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
>  	}
>  }
>  
> +#ifndef MIN
> +#define MIN(a, b) (((a) < (b)) ? (a) : (b))
> +#endif
There's a Linux kernel macro for exactly the same purpose.

> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 2bc422e..73e3723 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -668,18 +668,32 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
>  					     struct list_head *bf_q)
>  {
>  #define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
> +#define MS(_v, _f)  (((_v) & _f) >> _f##_S)
Again, already defined in hw.h

>  	struct ath_buf *bf, *bf_first, *bf_prev = NULL;
>  	int rl = 0, nframes = 0, ndelim, prev_al = 0;
>  	u16 aggr_limit = 0, al = 0, bpad = 0,
>  		al_delta, h_baw = tid->baw_size / 2;
>  	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
>  	struct ieee80211_tx_info *tx_info;
> +	u8 is_prev_sounding = 0;
>  
>  	bf_first = list_first_entry(&tid->buf_q, struct ath_buf, list);
>  
>  	do {
>  		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
>  
> +		/* send the sounding frame as a single frame */
> +		if (bf->bf_flags &
> +		   (ATH9K_TXDESC_TXBF_SOUND | ATH9K_TXDESC_TXBF_STAG_SOUND)) {
> +			if (nframes != 0)
> +				break;
> +			else
> +				is_prev_sounding = 1;
> +		}
> +
> +		if ((nframes == 1) & (is_prev_sounding))
> +			break;
> +
How about adding this check in a similar way as the
IEEE80211_TX_CTL_RATE_CTRL_PROBE flag check, instead of adding the
is_prev_sounding variable. That way you won't introduce the same bug
that rate control probing had before I fixed it.

- Felix
