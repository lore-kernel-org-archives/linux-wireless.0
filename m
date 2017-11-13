Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:48740 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752710AbdKMSQq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 13:16:46 -0500
Received: by mail-pg0-f42.google.com with SMTP id s11so7810931pgc.5
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2017 10:16:46 -0800 (PST)
Date: Mon, 13 Nov 2017 10:16:42 -0800
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: kvalo@codeaurora.org, k.eugene.e@gmail.com,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicolas.dechesne@linaro.org, Eyal Ilsar <eilsar@codeaurora.org>
Subject: Re: [PATCH] wcn36xx: Set BTLE coexistence related configuration
 values to defaults
Message-ID: <20171113181642.GE28761@minitux> (sfid-20171113_191737_668332_3240D2E9)
References: <1510496506-4428-1-git-send-email-rfried@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1510496506-4428-1-git-send-email-rfried@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun 12 Nov 06:21 PST 2017, Ramon Fried wrote:

> From: Eyal Ilsar <eilsar@codeaurora.org>
> 
> If the value for the firmware configuration parameters BTC_STATIC_LEN_LE_BT
> and BTC_STATIC_LEN_LE_WLAN are not set the duty cycle between BT and WLAN
> is such that if BT (including BLE) is active WLAN gets 0 bandwidth.
> When tuning these parameters having a too high value for WLAN means that BLE performance degrades.
> The "sweet" point of roughly half of the maximal values was empirically found to achieve
> a balance between BLE and Wi-Fi coexistence performance.
> 

Thanks for the patch! Just some minor comments.

Please limit subject to 50 chars and wrap body at 72 chars.

> Signed-off-by: Eyal Ilsar <eilsar@codeaurora.org>
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 9c6590d..1c75987 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -72,8 +72,10 @@ struct wcn36xx_cfg_val {
>  	WCN36XX_CFG_VAL(DYNAMIC_PS_POLL_VALUE, 0),
>  	WCN36XX_CFG_VAL(TX_PWR_CTRL_ENABLE, 1),
>  	WCN36XX_CFG_VAL(ENABLE_CLOSE_LOOP, 1),
> -	WCN36XX_CFG_VAL(ENABLE_LPWR_IMG_TRANSITION, 0),

I don't see a need for moving this line.

> +	WCN36XX_CFG_VAL(BTC_STATIC_LEN_LE_BT, 120000),
> +	WCN36XX_CFG_VAL(BTC_STATIC_LEN_LE_WLAN, 30000),

These looks reasonable, are we okay leaving the other coexistence
properties at their preconfigured values?

>  	WCN36XX_CFG_VAL(MAX_ASSOC_LIMIT, 10),
> +	WCN36XX_CFG_VAL(ENABLE_LPWR_IMG_TRANSITION, 0),
>  	WCN36XX_CFG_VAL(ENABLE_MCC_ADAPTIVE_SCHEDULER, 0),

Regards,
Bjorn
