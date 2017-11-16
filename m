Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:51485 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdKPSgW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Nov 2017 13:36:22 -0500
Received: by mail-pf0-f194.google.com with SMTP id j28so17904340pfk.8
        for <linux-wireless@vger.kernel.org>; Thu, 16 Nov 2017 10:36:22 -0800 (PST)
Date: Thu, 16 Nov 2017 10:36:18 -0800
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: kvalo@codeaurora.org, k.eugene.e@gmail.com,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nicolas.dechesne@linaro.org,
        Eyal Ilsar <eilsar@codeaurora.org>
Subject: Re: [PATCH v4] wcn36xx: Set default BTLE coexistence config
Message-ID: <20171116183618.GA5284@builder> (sfid-20171116_193633_529224_07EF83CD)
References: <20171116080126.17239-1-rfried@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171116080126.17239-1-rfried@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu 16 Nov 00:01 PST 2017, Ramon Fried wrote:

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

Looks good,

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 9c6590d5348a..6f1e741acf3e 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -73,6 +73,8 @@ static struct wcn36xx_cfg_val wcn36xx_cfg_vals[] = {
>  	WCN36XX_CFG_VAL(TX_PWR_CTRL_ENABLE, 1),
>  	WCN36XX_CFG_VAL(ENABLE_CLOSE_LOOP, 1),
>  	WCN36XX_CFG_VAL(ENABLE_LPWR_IMG_TRANSITION, 0),
> +	WCN36XX_CFG_VAL(BTC_STATIC_LEN_LE_BT, 120000),
> +	WCN36XX_CFG_VAL(BTC_STATIC_LEN_LE_WLAN, 30000),
>  	WCN36XX_CFG_VAL(MAX_ASSOC_LIMIT, 10),
>  	WCN36XX_CFG_VAL(ENABLE_MCC_ADAPTIVE_SCHEDULER, 0),
>  };
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
