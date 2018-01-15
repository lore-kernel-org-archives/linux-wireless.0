Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:44546 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbeAOTQB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 14:16:01 -0500
Received: by mail-ot0-f195.google.com with SMTP id t20so2196976ote.11
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 11:16:01 -0800 (PST)
Subject: Re: [PATCH v2 09/10] rtlwifi: btcoex: Add common function for
 qeurying BT information
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: yhchuang@realtek.com, linux-wireless@vger.kernel.org
References: <20180111070932.9929-1-pkshih@realtek.com>
 <20180111070932.9929-10-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <47949eee-9fe9-271a-bb4c-a287bbd62ca2@lwfinger.net> (sfid-20180115_201606_971996_B95B98E7)
Date: Mon, 15 Jan 2018 13:15:59 -0600
MIME-Version: 1.0
In-Reply-To: <20180111070932.9929-10-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2018 01:09 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> This commit implement the common function to sort old features, and add
> more new features that are get_supported_feature, get_supported_version,
> get_ant_det_val, ble_scan_type, ble_scan_para, bt_dev_info,
> forbidden_slot_val, afh_map and etc.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 309 ++++++++++++++++++---
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  70 +++++
>   .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  48 +++-
>   3 files changed, 394 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> index 2be81fec789a..30d940cf3abf 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -207,6 +207,102 @@ u8 rtl_get_hwpg_package_type(struct rtl_priv *rtlpriv)
>   	return rtlhal->package_type;
>   }
>   
> +static
> +bool halbtc_is_hw_mailbox_exist(struct btc_coexist *btcoexist)
> +{
> +	if (IS_HARDWARE_TYPE_8812(btcoexist->adapter))
> +		return false;
> +	else
> +		return true;

Once you have returned false for 8812, you do not need the 'else'. Use a simple 
'	return true;'. As this is the only objection in this patch, I will let it 
pass. Some user with a suitable tool will change it.

> +}
> +
> +static
> +bool halbtc_send_bt_mp_operation(struct btc_coexist *btcoexist, u8 op_code,
> +				 u8 *cmd, u32 len, unsigned long wait_ms)
--snip--

>   
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index 5a7816ff6877..cbbf5e5a9c9b 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -278,6 +278,8 @@ enum btc_get_type {
>   	BTC_GET_U4_VENDOR,
>   	BTC_GET_U4_SUPPORTED_VERSION,
>   	BTC_GET_U4_SUPPORTED_FEATURE,
> +	BTC_GET_U4_BT_DEVICE_INFO,
> +	BTC_GET_U4_BT_FORBIDDEN_SLOT_VAL,
>   	BTC_GET_U4_WIFI_IQK_TOTAL,
>   	BTC_GET_U4_WIFI_IQK_OK,
>   	BTC_GET_U4_WIFI_IQK_FAIL,
> @@ -459,6 +461,19 @@ typedef	bool (*bfp_btc_get)(void *btcoexist, u8 get_type, void *out_buf);
>   
>   typedef	bool (*bfp_btc_set)(void *btcoexist, u8 set_type, void *in_buf);
>   
> +typedef u32 (*bfp_btc_get_bt_coex_supported_feature)(void *btcoexist);
> +
> +typedef u32 (*bfp_btc_get_bt_coex_supported_version)(void *btcoexist);
> +
> +typedef u8 (*bfp_btc_get_ant_det_val_from_bt)(void *btcoexist);
> +
> +typedef u8 (*bfp_btc_get_ble_scan_type_from_bt)(void *btcoexist);
> +
> +typedef u32 (*bfp_btc_get_ble_scan_para_from_bt)(void *btcoexist, u8 scan_type);
> +
> +typedef bool (*bfp_btc_get_bt_afh_map_from_bt)(void *btcoexist, u8 map_type,
> +					       u8 *afh_map);
> +
>   typedef void (*bfp_btc_set_bt_reg)(void *btc_context, u8 reg_type, u32 offset,
>   				   u32 value);

I would prefer that you not add additional typedef statements, but I will let it 
pass.


Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
