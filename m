Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42373 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1BVFD1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 00:03:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 21:03:05 -0800
Date: Tue, 22 Feb 2011 10:33:03 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>
Subject: Re: [PATCH 12/23] ath9k_htc: Maintain individual counters for
 interfaces
Message-ID: <20110222050302.GA11916@vmraj-lnx.users.atheros.com>
References: <19809.52131.619464.414079@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19809.52131.619464.414079@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 21, 2011 at 07:49:15AM +0530, Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> This is required for allowing only one IBSS interface to be
> configured.
> 
> Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc.h          |   28 +++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |   14 ++++++++++-
>  2 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
> index 97f7ae0..0088c6e 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -206,6 +206,32 @@ struct ath9k_htc_target_stats {
>  
>  #define ATH9K_HTC_MAX_VIF 2
>  
> +#define INC_VIF(_priv, _type) do {		\
> +		switch (_type) {		\
> +		case NL80211_IFTYPE_STATION:	\
> +			_priv->num_sta_vif++;	\
> +			break;			\
> +		case NL80211_IFTYPE_ADHOC:	\
> +			_priv->num_ibss_vif++;	\
> +			break;			\
> +		default:			\
> +			break;			\
> +		}				\
> +	} while (0)
> +
> +#define DEC_VIF(_priv, _type) do {		\
> +		switch (_type) {		\
> +		case NL80211_IFTYPE_STATION:	\
> +			_priv->num_sta_vif--;	\
> +			break;			\
> +		case NL80211_IFTYPE_ADHOC:	\
> +			_priv->num_ibss_vif--;	\
> +			break;			\
> +		default:			\
> +			break;			\
> +		}				\
> +	} while (0)
> +
>  struct ath9k_htc_vif {
>  	u8 index;
>  	u16 seq_no;
> @@ -367,6 +393,8 @@ struct ath9k_htc_priv {
>  	u8 mon_vif_idx;
>  	u8 sta_slot;
>  	u8 vif_sta_pos[ATH9K_HTC_MAX_VIF];
> +	u8 num_ibss_vif;
> +	u8 num_sta_vif;
>  
>  	u16 op_flags;
>  	u16 curtxpow;
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> index 04cb243..39074fc 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -1193,9 +1193,15 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
>  	mutex_lock(&priv->mutex);
>  
>  	if (priv->nvifs >= ATH9K_HTC_MAX_VIF) {
> -		ret = -ENOBUFS;
>  		mutex_unlock(&priv->mutex);
> -		return ret;
> +		return -ENOBUFS;
> +	}
> +
> +	if (priv->num_ibss_vif ||
> +	    (priv->nvifs && vif->type == NL80211_IFTYPE_ADHOC)) {
> +		ath_err(common, "IBSS coexistence with other modes is not allowed\n");
> +		mutex_unlock(&priv->mutex);
> +		return -ENOBUFS;
>  	}
Need to handle IBSS interface if vifs are already present.
>  
>  	ath9k_htc_ps_wakeup(priv);
> @@ -1240,6 +1246,8 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
>  	priv->nvifs++;
>  	priv->vif = vif;
>  
> +	INC_VIF(priv, vif->type);
> +
>  	ath_dbg(common, ATH_DBG_CONFIG,
>  		"Attach a VIF of type: %d at idx: %d\n", vif->type, avp->index);
>  
> @@ -1273,6 +1281,8 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
>  	ath9k_htc_remove_station(priv, vif, NULL);
>  	priv->vif = NULL;
>  
> +	DEC_VIF(priv, vif->type);
> +
>  	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface at idx: %d\n", avp->index);
>  
>  	ath9k_htc_ps_restore(priv);
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
