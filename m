Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:44120 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeCBWGv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 17:06:51 -0500
Received: by mail-oi0-f65.google.com with SMTP id b8so8115304oib.11
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2018 14:06:51 -0800 (PST)
Subject: Re: [PATCH 01/15] rtlwifi: Add modifier static to functions reported
 by sparse
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180228030718.19510-1-pkshih@realtek.com>
 <20180228030718.19510-2-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <fac51743-0cd0-b4a9-37c5-48dc73de4526@lwfinger.net> (sfid-20180302_230656_296984_3BA9F64F)
Date: Fri, 2 Mar 2018 16:06:48 -0600
MIME-Version: 1.0
In-Reply-To: <20180228030718.19510-2-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2018 09:07 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> sparse reports some functions were not declared, so add 'static' as
> modifier. Remove an unused function btc8821a1ant_is_wifi_status_changed()
> exposed due to 'static'.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |  1 +
>   .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |  6 ++--
>   .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 33 ----------------------
>   .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |  4 +--
>   4 files changed, 6 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
> index 05beb16f0a0a..59553db020ef 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
> @@ -1436,6 +1436,7 @@ static void halbtc8723b1ant_ps_tdma(struct btc_coexist *btcoexist,
>   	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
>   }
>   
> +static
>   void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
>   				       u8 wifi_status)
>   {
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
> index 4907c2ffadfe..73ec31972944 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
> @@ -833,9 +833,9 @@ static void btc8723b2ant_set_sw_fulltime_dac_swing(struct btc_coexist *btcoex,
>   		btc8723b2ant_set_dac_swing_reg(btcoex, 0x18);
>   }
>   
> -void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
> -			    bool force_exec, bool dac_swing_on,
> -			    u32 dac_swing_lvl)
> +static void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
> +				   bool force_exec, bool dac_swing_on,
> +				   u32 dac_swing_lvl)
>   {
>   	struct rtl_priv *rtlpriv = btcoexist->adapter;
>   
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
> index 0b26419881c0..202597cf8915 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
> @@ -426,39 +426,6 @@ static void btc8821a1ant_query_bt_info(struct btc_coexist *btcoexist)
>   	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
>   }
>   
> -bool btc8821a1ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
> -{
> -	static bool pre_wifi_busy = true;
> -	static bool pre_under_4way = true;
> -	static bool pre_bt_hs_on = true;
> -	bool wifi_busy = false, under_4way = false, bt_hs_on = false;
> -	bool wifi_connected = false;
> -
> -	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
> -			   &wifi_connected);
> -	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
> -	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
> -	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
> -			   &under_4way);
> -
> -	if (wifi_connected) {
> -		if (wifi_busy != pre_wifi_busy) {
> -			pre_wifi_busy = wifi_busy;
> -			return true;
> -		}
> -		if (under_4way != pre_under_4way) {
> -			pre_under_4way = under_4way;
> -			return true;
> -		}
> -		if (bt_hs_on != pre_bt_hs_on) {
> -			pre_bt_hs_on = bt_hs_on;
> -			return true;
> -		}
> -	}
> -
> -	return false;
> -}
> -
>   static void btc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
>   {
>   	struct btc_bt_link_info	*bt_link_info = &btcoexist->bt_link_info;
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
> index d5f282cb9d24..2202d5e18977 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
> @@ -359,7 +359,7 @@ static void btc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
>   	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
>   }
>   
> -bool btc8821a2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
> +static bool btc8821a2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
>   {
>   	static bool pre_wifi_busy = true;
>   	static bool pre_under_4way = true;
> @@ -1517,7 +1517,7 @@ static void btc8821a2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
>   	btc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
>   }
>   
> -void btc8821a2ant_action_wifi_link_process(struct btc_coexist *btcoexist)
> +static void btc8821a2ant_action_wifi_link_process(struct btc_coexist *btcoexist)
>   {
>   	struct rtl_priv *rtlpriv = btcoexist->adapter;
>   	u8 u8tmpa, u8tmpb;
> 
