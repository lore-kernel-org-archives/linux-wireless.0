Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35462 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751920AbeCTD7d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 23:59:33 -0400
Received: by mail-oi0-f65.google.com with SMTP id a189-v6so227144oii.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2018 20:59:33 -0700 (PDT)
Subject: Re: [PATCH v2 07/15] rtlwifi: btcoex: Add interaction with phydm
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180306012554.3108-1-pkshih@realtek.com>
 <20180306012554.3108-8-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <7bd09909-b2f7-d183-8c30-057333dc5a4a@lwfinger.net> (sfid-20180320_050252_275796_49C29FEC)
Date: Mon, 19 Mar 2018 22:59:31 -0500
MIME-Version: 1.0
In-Reply-To: <20180306012554.3108-8-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2018 07:25 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Get phydm's counter and version from the module phydm that is not
> submitted so we implement dummy functions.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 38 ++++++++++++++++++++++
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  6 ++++
>   2 files changed, 44 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> index 1a24aed34094..bfb32d476a70 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -680,6 +680,21 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
>   	case BTC_GET_U4_BT_FORBIDDEN_SLOT_VAL:
>   		*u32_tmp = halbtc_get_bt_forbidden_slot_val(btcoexist);
>   		break;
> +	case BTC_GET_U4_WIFI_IQK_TOTAL:
> +		*u32_tmp =
> +			btcoexist->btc_phydm_query_phy_counter(btcoexist,
> +							       DM_INFO_IQK_ALL);
> +		break;
> +	case BTC_GET_U4_WIFI_IQK_OK:
> +		*u32_tmp =
> +			btcoexist->btc_phydm_query_phy_counter(btcoexist,
> +							       DM_INFO_IQK_OK);
> +		break;
> +	case BTC_GET_U4_WIFI_IQK_FAIL:
> +		*u32_tmp =
> +			btcoexist->btc_phydm_query_phy_counter(btcoexist,
> +							       DM_INFO_IQK_NG);
> +		break;
>   	case BTC_GET_U1_WIFI_DOT11_CHNL:
>   		*u8_tmp = rtlphy->current_channel;
>   		break;
> @@ -1122,6 +1137,25 @@ static bool halbtc_under_ips(struct btc_coexist *btcoexist)
>   	return false;
>   }
>   
> +static
> +u32 halbtc_get_phydm_version(void *btc_context)
> +{
> +	return 0;
> +}
> +
> +static
> +void halbtc_phydm_modify_ra_pcr_threshold(void *btc_context,
> +					  u8 ra_offset_direction,
> +					  u8 ra_threshold_offset)
> +{
> +}
> +
> +static
> +u32 halbtc_phydm_query_phy_counter(void *btc_context, enum dm_info_query dm_id)
> +{
> +	return 0;
> +}
> +
>   static u8 halbtc_get_ant_det_val_from_bt(void *btc_context)
>   {
>   	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
> @@ -1245,6 +1279,10 @@ bool exhalbtc_initlize_variables(struct rtl_priv *rtlpriv)
>   					halbtc_get_bt_coex_supported_feature;
>   	btcoexist->btc_get_bt_coex_supported_version =
>   					halbtc_get_bt_coex_supported_version;
> +	btcoexist->btc_get_bt_phydm_version = halbtc_get_phydm_version;
> +	btcoexist->btc_phydm_modify_ra_pcr_threshold =
> +					halbtc_phydm_modify_ra_pcr_threshold;
> +	btcoexist->btc_phydm_query_phy_counter = halbtc_phydm_query_phy_counter;
>   	btcoexist->btc_get_ant_det_val_from_bt = halbtc_get_ant_det_val_from_bt;
>   	btcoexist->btc_get_ble_scan_type_from_bt =
>   					halbtc_get_ble_scan_type_from_bt;
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index bc2388f3f953..1f12449363c2 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -730,6 +730,12 @@ struct btc_coexist {
>   			       u32 value);
>   	u32 (*btc_get_bt_coex_supported_feature)(void *btcoexist);
>   	u32 (*btc_get_bt_coex_supported_version)(void *btcoexist);
> +	u32 (*btc_get_bt_phydm_version)(void *btcoexist);
> +	void (*btc_phydm_modify_ra_pcr_threshold)(void *btcoexist,
> +						  u8 ra_offset_direction,
> +						  u8 ra_threshold_offset);
> +	u32 (*btc_phydm_query_phy_counter)(void *btcoexist,
> +					   enum dm_info_query dm_id);
>   	u8 (*btc_get_ant_det_val_from_bt)(void *btcoexist);
>   	u8 (*btc_get_ble_scan_type_from_bt)(void *btcoexist);
>   	u32 (*btc_get_ble_scan_para_from_bt)(void *btcoexist, u8 scan_type);
> 
