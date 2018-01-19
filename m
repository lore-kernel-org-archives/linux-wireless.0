Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:41835 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756471AbeASWqU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 17:46:20 -0500
Received: by mail-oi0-f68.google.com with SMTP id n81so2183175oig.8
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jan 2018 14:46:20 -0800 (PST)
Subject: Re: [PATCH 07/10] rtlwifi: btcoex: Fix some static warnings from
 Sparse
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180119064551.10084-1-pkshih@realtek.com>
 <20180119064551.10084-8-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <79544f61-8a0d-283d-6370-1197b31aa59f@lwfinger.net> (sfid-20180119_234624_605462_0D51F469)
Date: Fri, 19 Jan 2018 16:46:18 -0600
MIME-Version: 1.0
In-Reply-To: <20180119064551.10084-8-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/2018 12:45 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Add 'static' or declaration to resolve the warnings.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 36 +++++++---------------
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  4 +++
>   2 files changed, 15 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> index 73ef5b271f3b..1404729441a2 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -29,7 +29,7 @@
>    *		Debug related function
>    ***************************************************/
>   
> -const char *const gl_btc_wifi_bw_string[] = {
> +static const char *const gl_btc_wifi_bw_string[] = {
>   	"11bg",
>   	"HT20",
>   	"HT40",
> @@ -37,7 +37,7 @@ const char *const gl_btc_wifi_bw_string[] = {
>   	"HT160"
>   };
>   
> -const char *const gl_btc_wifi_freq_string[] = {
> +static const char *const gl_btc_wifi_freq_string[] = {
>   	"2.4G",
>   	"5G"
>   };
> @@ -156,7 +156,7 @@ static u8 halbtc_get_wifi_central_chnl(struct btc_coexist *btcoexist)
>   	return chnl;
>   }
>   
> -u8 rtl_get_hwpg_single_ant_path(struct rtl_priv *rtlpriv)
> +static u8 rtl_get_hwpg_single_ant_path(struct rtl_priv *rtlpriv)
>   {
>   	struct rtl_mod_params *mod_params = rtlpriv->cfg->mod_params;
>   
> @@ -171,12 +171,12 @@ u8 rtl_get_hwpg_single_ant_path(struct rtl_priv *rtlpriv)
>   	return rtlpriv->btcoexist.btc_info.single_ant_path;
>   }
>   
> -u8 rtl_get_hwpg_bt_type(struct rtl_priv *rtlpriv)
> +static u8 rtl_get_hwpg_bt_type(struct rtl_priv *rtlpriv)
>   {
>   	return rtlpriv->btcoexist.btc_info.bt_type;
>   }
>   
> -u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv)
> +static u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv)
>   {
>   	struct rtl_mod_params *mod_params = rtlpriv->cfg->mod_params;
>   	u8 num;
> @@ -193,7 +193,7 @@ u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv)
>   	return num;
>   }
>   
> -u8 rtl_get_hwpg_package_type(struct rtl_priv *rtlpriv)
> +static u8 rtl_get_hwpg_package_type(struct rtl_priv *rtlpriv)
>   {
>   	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
>   
> @@ -504,7 +504,7 @@ static u32 halbtc_get_bt_forbidden_slot_val(void *btc_context)
>   	return btcoexist->bt_info.bt_forb_slot_val;
>   }
>   
> -u32 halbtc_get_wifi_link_status(struct btc_coexist *btcoexist)
> +static u32 halbtc_get_wifi_link_status(struct btc_coexist *btcoexist)
>   {
>   	/* return value:
>   	 * [31:16] => connected port number
> @@ -980,7 +980,8 @@ static void halbtc_write_4byte(void *bt_context, u32 reg_addr, u32 data)
>   	rtl_write_dword(rtlpriv, reg_addr, data);
>   }
>   
> -void halbtc_write_local_reg_1byte(void *btc_context, u32 reg_addr, u8 data)
> +static void halbtc_write_local_reg_1byte(void *btc_context, u32 reg_addr,
> +					 u8 data)
>   {
>   	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
>   	struct rtl_priv *rtlpriv = btcoexist->adapter;
> @@ -993,22 +994,6 @@ void halbtc_write_local_reg_1byte(void *btc_context, u32 reg_addr, u8 data)
>   		rtl_write_byte(rtlpriv, reg_addr, data);
>   }
>   
> -void halbtc_set_macreg(void *btc_context, u32 reg_addr, u32 bit_mask, u32 data)
> -{
> -	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
> -	struct rtl_priv *rtlpriv = btcoexist->adapter;
> -
> -	rtl_set_bbreg(rtlpriv->mac80211.hw, reg_addr, bit_mask, data);
> -}
> -
> -u32 halbtc_get_macreg(void *btc_context, u32 reg_addr, u32 bit_mask)
> -{
> -	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
> -	struct rtl_priv *rtlpriv = btcoexist->adapter;
> -
> -	return rtl_get_bbreg(rtlpriv->mac80211.hw, reg_addr, bit_mask);
> -}
> -

Should we conclude that the two routines above are not used, and that fact was 
exposed when they were made static? If so, please note that they were deleted in 
the commit message.

Larry
