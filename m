Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36195 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaISIQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2014 04:16:51 -0400
Message-ID: <541BE66F.9040307@openwrt.org> (sfid-20140919_101657_645916_09A001BE)
Date: Fri, 19 Sep 2014 10:16:47 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH] ath9k: Fix p2p address management
References: <1411111842-24503-1-git-send-email-sujith@msujith.org>
In-Reply-To: <1411111842-24503-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-09-19 09:30, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> When multiple channel contexts are enabled, a p2p interface
> that is assigned to a context will have an address that
> is different from the device mac address, which is used
> by wpa_s as the p2p device ID.
> 
> Certain frames like provision requests use the device address
> and these get dropped since ath9k_calculate_summary_state()
> iterates over only the active interfaces in a context and the
> device address is not used.
> 
> Fix this by adding the device mac address to the bssid mask.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
>  drivers/net/wireless/ath/ath9k/main.c  | 36 ++++++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 78fc539..32f9db9 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -940,6 +940,34 @@ static void ath9k_vif_iter(struct ath9k_vif_iter_data *iter_data,
>  	}
>  }
>  
> +static void ath9k_update_bssid_mask(struct ath_softc *sc,
> +				    struct ath_chanctx *ctx,
> +				    struct ath9k_vif_iter_data *iter_data)
> +{
> +	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> +	struct ath_vif *avp;
> +	int i;
> +
> +	if (!ath9k_is_chanctx_enabled())
> +		return;
> +
> +	list_for_each_entry(avp, &ctx->vifs, list) {
> +		if (ctx->nvifs_assigned != 1)
> +			continue;
> +
> +		if (!avp->vif->p2p || !iter_data->has_hw_macaddr)
> +			continue;
> +
> +		ether_addr_copy(common->curbssid, avp->bssid);
> +
> +		/* perm_addr will be used as the p2p device address. */
> +		for (i = 0; i < ETH_ALEN; i++)
> +			iter_data->mask[i] &=
> +				~(iter_data->hw_macaddr[i] ^
> +				  sc->hw->wiphy->perm_addr[i]);
> +	}
> +}
Wouldn't it make more sense to put this into ath9k_vif_iter()

- Felix
