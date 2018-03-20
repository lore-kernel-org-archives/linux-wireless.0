Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:42875 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbeCTEBd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 00:01:33 -0400
Received: by mail-ot0-f193.google.com with SMTP id v23-v6so286046oth.9
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2018 21:01:33 -0700 (PDT)
Subject: Re: [PATCH v2 09/15] rtlwifi: btcoex: add assoc type v2 to connection
 notify
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180306012554.3108-1-pkshih@realtek.com>
 <20180306012554.3108-10-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d80a0180-1bc4-7784-647f-032198ff87ae@lwfinger.net> (sfid-20180320_050141_667033_4224476E)
Date: Mon, 19 Mar 2018 23:01:31 -0500
MIME-Version: 1.0
In-Reply-To: <20180306012554.3108-10-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2018 07:25 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> In connection notify v1, btcoex only need to know start/end association,
> and it will discriminate 2G and 5G band in v2.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   .../net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c  | 14 +++++++++++---
>   .../net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h  |  2 ++
>   2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> index 0f664a0490a7..05300b466d34 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -1610,7 +1610,8 @@ void exhalbtc_scan_notify_wifi_only(struct wifi_only_cfg *wifionly_cfg,
>   
>   void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
>   {
> -	u8 asso_type;
> +	u8 asso_type, asso_type_v2;
> +	bool wifi_under_5g;
>   
>   	if (!halbtc_is_bt_coexist_available(btcoexist))
>   		return;
> @@ -1618,10 +1619,17 @@ void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
>   	if (btcoexist->manual_control)
>   		return;
>   
> -	if (action)
> +	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
> +
> +	if (action) {
>   		asso_type = BTC_ASSOCIATE_START;
> -	else
> +		asso_type_v2 = wifi_under_5g ? BTC_ASSOCIATE_5G_START :
> +					       BTC_ASSOCIATE_START;
> +	} else {
>   		asso_type = BTC_ASSOCIATE_FINISH;
> +		asso_type_v2 = wifi_under_5g ? BTC_ASSOCIATE_5G_FINISH :
> +					       BTC_ASSOCIATE_FINISH;
> +	}
>   
>   	halbtc_leave_low_power(btcoexist);
>   
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index ad80ec05975e..0a7b09305bc3 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -401,6 +401,8 @@ enum btc_notify_type_switchband {
>   enum btc_notify_type_associate {
>   	BTC_ASSOCIATE_FINISH = 0x0,
>   	BTC_ASSOCIATE_START = 0x1,
> +	BTC_ASSOCIATE_5G_FINISH = 0x2,
> +	BTC_ASSOCIATE_5G_START = 0x3,
>   	BTC_ASSOCIATE_MAX
>   };
>   
> 
