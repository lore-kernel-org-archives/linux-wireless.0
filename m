Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48028 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbeDDFkb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 01:40:31 -0400
Subject: Re: [PATCH 3/3] wcn36xx: don't delete invalid bss indices
To: Daniel Mack <daniel@zonque.org>, linux-wireless@vger.kernel.org
Cc: loic.poulain@linaro.org, bjorn.andersson@linaro.org,
        kvalo@codeaurora.org, wcn36xx@lists.infradead.org
References: <20180403165154.18775-1-daniel@zonque.org>
 <20180403165154.18775-3-daniel@zonque.org>
From: Ramon Fried <rfried@codeaurora.org>
Message-ID: <8ee8943c-ff58-60a1-75da-eaf795ff3234@codeaurora.org> (sfid-20180404_074034_307764_AB68CFE7)
Date: Wed, 4 Apr 2018 08:40:26 +0300
MIME-Version: 1.0
In-Reply-To: <20180403165154.18775-3-daniel@zonque.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 4/3/2018 7:51 PM, Daniel Mack wrote:
> The firmware code cannot cope with requests to remove BSS indices that have
> not previously been added. This primarily happens when the device is
> suspended and then resumed. ieee80211_reconfig() then calls into
> wcn36xx_bss_info_changed() with an empty bssid and BSS_CHANGED_BSSID set,
> which subsequently leads to a firmware crash:
>
> [   43.647928] qcom-wcnss-pil a204000.wcnss: fatal error received: halMsg.c:4964:halMsg_DelBss: Invalid BSSIndex 0
> [   43.647959] remoteproc remoteproc0: crash detected in a204000.wcnss: type fatal error
>
> To fix this, set bss_index to WCN36XX_HAL_BSS_INVALID_IDX for all bss
> that have not been configured in the firmware, and don't call into the
> firmware with invalid indices.
>
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/main.c | 1 +
>  drivers/net/wireless/ath/wcn36xx/smd.c  | 6 ++++++
>  2 files changed, 7 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index 69d6be59d97f..32bbd6e2fd09 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -953,6 +953,7 @@ static int wcn36xx_add_interface(struct ieee80211_hw *hw,
>  
>  	mutex_lock(&wcn->conf_mutex);
>  
> +	vif_priv->bss_index = WCN36XX_HAL_BSS_INVALID_IDX;
>  	list_add(&vif_priv->list, &wcn->vif_list);
>  	wcn36xx_smd_add_sta_self(wcn, vif);
>  
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 8932af5e4d8d..5be07e40a86d 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -1446,6 +1446,10 @@ int wcn36xx_smd_delete_bss(struct wcn36xx *wcn, struct ieee80211_vif *vif)
>  	int ret = 0;
>  
>  	mutex_lock(&wcn->hal_mutex);
> +
> +	if (vif_priv->bss_index == WCN36XX_HAL_BSS_INVALID_IDX)
> +		goto out;
> +
>  	INIT_HAL_MSG(msg_body, WCN36XX_HAL_DELETE_BSS_REQ);
>  
>  	msg_body.bss_index = vif_priv->bss_index;
> @@ -1464,6 +1468,8 @@ int wcn36xx_smd_delete_bss(struct wcn36xx *wcn, struct ieee80211_vif *vif)
>  		wcn36xx_err("hal_delete_bss response failed err=%d\n", ret);
>  		goto out;
>  	}
> +
> +	vif_priv->bss_index = WCN36XX_HAL_BSS_INVALID_IDX;
>  out:
>  	mutex_unlock(&wcn->hal_mutex);
>  	return ret;
Interesting. I have never seen this bug before.
Do you have a way of recreating it so I can test it on my side ?

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
