Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:34444 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbeCBWUK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 17:20:10 -0500
Received: by mail-ot0-f196.google.com with SMTP id n74so10105238ota.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2018 14:20:10 -0800 (PST)
Subject: Re: [PATCH 05/15] rtlwifi: btcoex: Get status of multichannel
 concurrence
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180228030718.19510-1-pkshih@realtek.com>
 <20180228030718.19510-6-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <ae6d8ef4-9ae3-1181-59a4-1cbfd5621b2e@lwfinger.net> (sfid-20180302_232014_592171_ABCFB39C)
Date: Fri, 2 Mar 2018 16:20:08 -0600
MIME-Version: 1.0
In-Reply-To: <20180228030718.19510-6-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2018 09:07 PM, pkshih@realtek.com wrote:
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
