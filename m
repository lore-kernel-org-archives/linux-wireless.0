Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:51700 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754883AbdKPGdU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Nov 2017 01:33:20 -0500
Received: by mail-pg0-f65.google.com with SMTP id p9so19879867pgc.8
        for <linux-wireless@vger.kernel.org>; Wed, 15 Nov 2017 22:33:20 -0800 (PST)
Date: Wed, 15 Nov 2017 22:33:17 -0800
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: kvalo@codeaurora.org, k.eugene.e@gmail.com,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nicolas.dechesne@linaro.org,
        Eyal Ilsar <eilsar@codeaurora.org>
Subject: Re: [PATCH v3] wcn36xx: Set default BTLE coexistence config
Message-ID: <20171116063317.GM28761@minitux> (sfid-20171116_073711_911739_2F2563DB)
References: <20171114072319.32705-1-rfried@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171114072319.32705-1-rfried@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon 13 Nov 23:23 PST 2017, Ramon Fried wrote:

> From: Eyal Ilsar <eilsar@codeaurora.org>
> 
> If the value for the firmware configuration parameters
> BTC_STATIC_LEN_LE_BT and BTC_STATIC_LEN_LE_WLAN are not set the duty
> cycle between BT and WLAN is such that if BT (including BLE) is active
> WLAN gets 0 bandwidth. When tuning these parameters having a too high
> value for WLAN means that BLE performance degrades.
> The "sweet" point of roughly half of the maximal values was empirically
> found to achieve a balance between BLE and Wi-Fi coexistence
> performance.
> 
> Signed-off-by: Eyal Ilsar <eilsar@codeaurora.org>
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 9c6590d5348a..1c7598752255 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -72,8 +72,10 @@ static struct wcn36xx_cfg_val wcn36xx_cfg_vals[] = {
>  	WCN36XX_CFG_VAL(DYNAMIC_PS_POLL_VALUE, 0),
>  	WCN36XX_CFG_VAL(TX_PWR_CTRL_ENABLE, 1),
>  	WCN36XX_CFG_VAL(ENABLE_CLOSE_LOOP, 1),
> -	WCN36XX_CFG_VAL(ENABLE_LPWR_IMG_TRANSITION, 0),

I still don't see why you're moving this unrelated line, can you please
help me see what I'm missing?

Thanks,
Bjorn

> +	WCN36XX_CFG_VAL(BTC_STATIC_LEN_LE_BT, 120000),
> +	WCN36XX_CFG_VAL(BTC_STATIC_LEN_LE_WLAN, 30000),
>  	WCN36XX_CFG_VAL(MAX_ASSOC_LIMIT, 10),
> +	WCN36XX_CFG_VAL(ENABLE_LPWR_IMG_TRANSITION, 0),
>  	WCN36XX_CFG_VAL(ENABLE_MCC_ADAPTIVE_SCHEDULER, 0),
>  };
>  
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
