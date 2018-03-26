Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52402 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbeCZM3f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 08:29:35 -0400
Subject: Re: [PATCH v3] wcn36xx: reduce verbosity of drivers messages
To: kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
References: <20180227140535.4794-1-rfried@codeaurora.org>
From: Ramon Fried <rfried@codeaurora.org>
Message-ID: <21c7106f-e84a-18fb-e2d1-989073034e2a@codeaurora.org> (sfid-20180326_142938_858293_A98E736B)
Date: Mon, 26 Mar 2018 15:29:31 +0300
MIME-Version: 1.0
In-Reply-To: <20180227140535.4794-1-rfried@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle.

Kind reminder. Is the patch ok ?

Thanks,

Ramon


On 2/27/2018 4:05 PM, Ramon Fried wrote:
> Whenever the WLAN interface is started the FW
> version and caps are printed.
> The caps now will be displayed only in debug mode.
> Firmware version will be displayed only once on first
> startup of the interface.
>
> Change-Id: I4db6ea7f384fe15eebe4c3ddb1d1ccab00094332
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> ---
> v2: print the firwmare version as info but only
> 	onetime.
> v3: change the static variable to a struct variable.
>
>  drivers/net/wireless/ath/wcn36xx/main.c    |  3 ++-
>  drivers/net/wireless/ath/wcn36xx/smd.c     | 18 ++++++++++--------
>  drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  2 ++
>  3 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index ab5be6d2c691..bfe9062bfa52 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -261,7 +261,7 @@ static void wcn36xx_feat_caps_info(struct wcn36xx *wcn)
>  
>  	for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
>  		if (get_feat_caps(wcn->fw_feat_caps, i))
> -			wcn36xx_info("FW Cap %s\n", wcn36xx_get_cap_name(i));
> +			wcn36xx_dbg(WCN36XX_DBG_MAC, "FW Cap %s\n", wcn36xx_get_cap_name(i));
>  	}
>  }
>  
> @@ -1283,6 +1283,7 @@ static int wcn36xx_probe(struct platform_device *pdev)
>  	wcn = hw->priv;
>  	wcn->hw = hw;
>  	wcn->dev = &pdev->dev;
> +	wcn->first_boot = true;
>  	mutex_init(&wcn->conf_mutex);
>  	mutex_init(&wcn->hal_mutex);
>  	mutex_init(&wcn->scan_lock);
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 2a4871ca9c72..1a5b4d57c0ac 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -409,15 +409,17 @@ static int wcn36xx_smd_start_rsp(struct wcn36xx *wcn, void *buf, size_t len)
>  	wcn->fw_minor = rsp->start_rsp_params.version.minor;
>  	wcn->fw_major = rsp->start_rsp_params.version.major;
>  
> -	wcn36xx_info("firmware WLAN version '%s' and CRM version '%s'\n",
> -		     wcn->wlan_version, wcn->crm_version);
> -
> -	wcn36xx_info("firmware API %u.%u.%u.%u, %u stations, %u bssids\n",
> -		     wcn->fw_major, wcn->fw_minor,
> -		     wcn->fw_version, wcn->fw_revision,
> -		     rsp->start_rsp_params.stations,
> -		     rsp->start_rsp_params.bssids);
> +	if (wcn->first_boot) {
> +		wcn->first_boot = false;
> +		wcn36xx_info("firmware WLAN version '%s' and CRM version '%s'\n",
> +			     wcn->wlan_version, wcn->crm_version);
>  
> +		wcn36xx_info("firmware API %u.%u.%u.%u, %u stations, %u bssids\n",
> +			     wcn->fw_major, wcn->fw_minor,
> +			     wcn->fw_version, wcn->fw_revision,
> +			     rsp->start_rsp_params.stations,
> +			     rsp->start_rsp_params.bssids);
> +	}
>  	return 0;
>  }
>  
> diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> index 81017e6703b4..5854adf43f3a 100644
> --- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> +++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> @@ -192,6 +192,8 @@ struct wcn36xx {
>  	u8			crm_version[WCN36XX_HAL_VERSION_LENGTH + 1];
>  	u8			wlan_version[WCN36XX_HAL_VERSION_LENGTH + 1];
>  
> +	bool		first_boot;
> +
>  	/* IRQs */
>  	int			tx_irq;
>  	int			rx_irq;
