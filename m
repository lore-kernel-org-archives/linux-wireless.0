Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33643 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756577AbeASWws (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 17:52:48 -0500
Received: by mail-ot0-f195.google.com with SMTP id x15so2758192ote.0
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jan 2018 14:52:48 -0800 (PST)
Subject: Re: [PATCH 01/10] rtlwifi: btcoex: extend get_wifi_bw to support
 bandwidth 80M
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180119064551.10084-1-pkshih@realtek.com>
 <20180119064551.10084-2-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <ea63202c-16e9-5ec4-fa7c-6343e9d42db8@lwfinger.net> (sfid-20180119_235252_497334_711D41C2)
Date: Fri, 19 Jan 2018 16:52:46 -0600
MIME-Version: 1.0
In-Reply-To: <20180119064551.10084-2-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/2018 12:45 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> The rtlwifi newer ICs support 80M bandwidth in 5G band, so extend
> get_wifi_bw() to know bandwidth 80M that helps btcoex to make correct
> decisions.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 37 +++++++++-------------
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  1 +
>   2 files changed, 16 insertions(+), 22 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> index af8f3778dc91..c335f06eb13b 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -95,21 +95,6 @@ static bool is_any_client_connect_to_ap(struct btc_coexist *btcoexist)
>   		return false;
>   }
>   
> -static bool halbtc_is_bt40(struct rtl_priv *adapter)
> -{
> -	struct rtl_priv *rtlpriv = adapter;
> -	struct rtl_phy *rtlphy = &(rtlpriv->phy);
> -	bool is_ht40 = true;
> -	enum ht_channel_width bw = rtlphy->current_chan_bw;
> -
> -	if (bw == HT_CHANNEL_WIDTH_20)
> -		is_ht40 = false;
> -	else if (bw == HT_CHANNEL_WIDTH_20_40)
> -		is_ht40 = true;
> -
> -	return is_ht40;
> -}
> -
>   static bool halbtc_legacy(struct rtl_priv *adapter)
>   {
>   	struct rtl_priv *rtlpriv = adapter;
> @@ -135,18 +120,26 @@ bool halbtc_is_wifi_uplink(struct rtl_priv *adapter)
>   
>   static u32 halbtc_get_wifi_bw(struct btc_coexist *btcoexist)
>   {
> -	struct rtl_priv *rtlpriv =
> -		(struct rtl_priv *)btcoexist->adapter;
> +	struct rtl_priv *rtlpriv = btcoexist->adapter;
> +	struct rtl_phy *rtlphy = &rtlpriv->phy;
>   	u32 wifi_bw = BTC_WIFI_BW_HT20;
>   
> -	if (halbtc_is_bt40(rtlpriv)) {
> -		wifi_bw = BTC_WIFI_BW_HT40;
> +	if (halbtc_legacy(rtlpriv)) {
> +		wifi_bw = BTC_WIFI_BW_LEGACY;
>   	} else {
> -		if (halbtc_legacy(rtlpriv))
> -			wifi_bw = BTC_WIFI_BW_LEGACY;
> -		else
> +		switch (rtlphy->current_chan_bw) {
> +		case HT_CHANNEL_WIDTH_20:
>   			wifi_bw = BTC_WIFI_BW_HT20;
> +			break;
> +		case HT_CHANNEL_WIDTH_20_40:
> +			wifi_bw = BTC_WIFI_BW_HT40;
> +			break;
> +		case HT_CHANNEL_WIDTH_80:
> +			wifi_bw = BTC_WIFI_BW_HT80;
> +			break;
> +		}
>   	}
> +
>   	return wifi_bw;
>   }
>   
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index 57caaf130a46..bc854ff2ab8a 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -190,6 +190,7 @@ enum btc_wifi_bw_mode {
>   	BTC_WIFI_BW_LEGACY = 0x0,
>   	BTC_WIFI_BW_HT20 = 0x1,
>   	BTC_WIFI_BW_HT40 = 0x2,
> +	BTC_WIFI_BW_HT80 = 0x3,
>   	BTC_WIFI_BW_MAX
>   };
>   
> 
