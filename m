Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:38465 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbeCTD4g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 23:56:36 -0400
Received: by mail-ot0-f195.google.com with SMTP id 95-v6so283897ote.5
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2018 20:56:36 -0700 (PDT)
Subject: Re: [PATCH v2 05/15] rtlwifi: btcoex: Get status of multichannel
 concurrence
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180306012554.3108-1-pkshih@realtek.com>
 <20180306012554.3108-6-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <96051650-7c79-57d1-dcb3-9b102eb46790@lwfinger.net> (sfid-20180320_045640_596555_59E257F1)
Date: Mon, 19 Mar 2018 22:56:34 -0500
MIME-Version: 1.0
In-Reply-To: <20180306012554.3108-6-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2018 07:25 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> btcoex does different decision according to MCC or SCC status, but
> driver is still SCC currently.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 3 +++
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 8 ++++++++
>   2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> index 823694cb4fdb..1a24aed34094 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -577,6 +577,9 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
>   			tmp = true;
>   		*bool_tmp = tmp;
>   		break;
> +	case BTC_GET_BL_WIFI_DUAL_BAND_CONNECTED:
> +		*u8_tmp = BTC_MULTIPORT_SCC;
> +		break;
>   	case BTC_GET_BL_WIFI_BUSY:
>   		if (halbtc_is_wifi_busy(rtlpriv))
>   			*bool_tmp = true;
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index 3c6a1e8851ec..fe793b787716 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -251,6 +251,7 @@ enum btc_get_type {
>   	BTC_GET_BL_HS_OPERATION,
>   	BTC_GET_BL_HS_CONNECTING,
>   	BTC_GET_BL_WIFI_CONNECTED,
> +	BTC_GET_BL_WIFI_DUAL_BAND_CONNECTED,
>   	BTC_GET_BL_WIFI_BUSY,
>   	BTC_GET_BL_WIFI_SCAN,
>   	BTC_GET_BL_WIFI_LINK,
> @@ -436,6 +437,13 @@ enum btc_notify_type_stack_operation {
>   	BTC_STACK_OP_MAX
>   };
>   
> +enum {
> +	BTC_MULTIPORT_SCC,
> +	BTC_MULTIPORT_MCC_2CHANNEL,
> +	BTC_MULTIPORT_MCC_2BAND,
> +	BTC_MULTIPORT_MAX
> +};
> +
>   struct btc_bt_info {
>   	bool bt_disabled;
>   	u8 rssi_adjust_for_agc_table_on;
> 
