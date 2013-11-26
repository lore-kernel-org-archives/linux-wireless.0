Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57246 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab3KZUoO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 15:44:14 -0500
Received: from [192.168.1.138] ([93.218.84.124]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0Mbfyr-1W1hzK3bW9-00IyZc for
 <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 21:44:12 +0100
Message-ID: <52950812.20001@rempel-privat.de> (sfid-20131126_214419_858150_66DA91CD)
Date: Tue, 26 Nov 2013 21:44:02 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Mathy Vanhoef <mathy.vanhoef@cs.kuleuven.be>,
	linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com
Subject: Re: [PATCH] ath9k_htc: properly set MAC address and BSSID mask
References: <5294E4C5.4050301@cs.kuleuven.be>
In-Reply-To: <5294E4C5.4050301@cs.kuleuven.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mathy,

thank you for your work!
suddenly this patch do not apply on top of
 git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

can you please update it.


Am 26.11.2013 19:13, schrieb Mathy Vanhoef:
> From: "Mathy Vanhoef" <Mathy.Vanhoef@cs.kuleuven.be>
> 
> Pick the MAC address of the first virtual interface as the new hardware MAC
> address. Set BSSID mask according to this MAC address. This fixes
> CVE-2013-4579.
> 
> Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>
> ---
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> index d441045..84359c3 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -147,21 +147,26 @@ static void ath9k_htc_bssid_iter(void *data, u8
> *mac, struct ieee80211_vif *vif)
>      struct ath9k_vif_iter_data *iter_data = data;
>      int i;
>  
> -    for (i = 0; i < ETH_ALEN; i++)
> -        iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
> +    if (iter_data->hw_macaddr != NULL) {
> +        for (i = 0; i < ETH_ALEN; i++)
> +            iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
> +    } else {
> +        iter_data->hw_macaddr = mac;
> +    }
>  }
>  
> -static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
> +static void ath9k_htc_set_mac_bssid_mask(struct ath9k_htc_priv *priv,
>                       struct ieee80211_vif *vif)
>  {
>      struct ath_common *common = ath9k_hw_common(priv->ah);
>      struct ath9k_vif_iter_data iter_data;
>  
>      /*
> -     * Use the hardware MAC address as reference, the hardware uses it
> -     * together with the BSSID mask when matching addresses.
> +     * Pick the MAC address of the first interface as the new hardware
> +     * MAC address. The hardware will use it together with the BSSID mask
> +     * when matching addresses.
>       */
> -    iter_data.hw_macaddr = common->macaddr;
> +    iter_data.hw_macaddr = NULL;
>      memset(&iter_data.mask, 0xff, ETH_ALEN);
>  
>      if (vif)
> @@ -173,6 +178,10 @@ static void ath9k_htc_set_bssid_mask(struct
> ath9k_htc_priv *priv,
>          ath9k_htc_bssid_iter, &iter_data);
>  
>      memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
> +
> +    if (iter_data.hw_macaddr)
> +        memcpy(common->macaddr, iter_data.hw_macaddr, ETH_ALEN);
> +
>      ath_hw_setbssidmask(common);
>  }
>  
> @@ -1083,7 +1092,7 @@ static int ath9k_htc_add_interface(struct
> ieee80211_hw *hw,
>          goto out;
>      }
>  
> -    ath9k_htc_set_bssid_mask(priv, vif);
> +    ath9k_htc_set_mac_bssid_mask(priv, vif);
>  
>      priv->vif_slot |= (1 << avp->index);
>      priv->nvifs++;
> @@ -1148,7 +1157,7 @@ static void ath9k_htc_remove_interface(struct
> ieee80211_hw *hw,
>  
>      ath9k_htc_set_opmode(priv);
>  
> -    ath9k_htc_set_bssid_mask(priv, vif);
> +    ath9k_htc_set_mac_bssid_mask(priv, vif);
>  
>      /*
>       * Stop ANI only if there are no associated station interfaces.
> diff --git a/drivers/net/wireless/ath/ath9k/main.c
> b/drivers/net/wireless/ath/ath9k/main.c
> index b6aad69..99ab0aa 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -885,8 +885,9 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
>      struct ath_common *common = ath9k_hw_common(ah);
>  
>      /*
> -     * Use the hardware MAC address as reference, the hardware uses it
> -     * together with the BSSID mask when matching addresses.
> +     * Pick the MAC address of the first interface as the new hardware
> +     * MAC address. The hardware will use it together with the BSSID mask
> +     * when matching addresses.
>       */
>      memset(iter_data, 0, sizeof(*iter_data));
>      memset(&iter_data->mask, 0xff, ETH_ALEN);
> 
> 
> Disclaimer: http://www.kuleuven.be/cwis/email_disclaimer.htm
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Regards,
Oleksij
