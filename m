Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36056 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbeAOTSB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 14:18:01 -0500
Received: by mail-oi0-f66.google.com with SMTP id w135so9004554oie.3
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 11:18:01 -0800 (PST)
Subject: Re: [PATCH v2 10/10] rtlwifi: btcoex: add rfe_type parameter to
 btcoex
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: yhchuang@realtek.com, linux-wireless@vger.kernel.org
References: <20180111070932.9929-1-pkshih@realtek.com>
 <20180111070932.9929-11-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <df218d06-7f5d-7552-aa4a-4a140629205d@lwfinger.net> (sfid-20180115_201809_294012_D954F2A5)
Date: Mon, 15 Jan 2018 13:17:59 -0600
MIME-Version: 1.0
In-Reply-To: <20180111070932.9929-11-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2018 01:09 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> btcoex configure antenna by rfe_type that is RF type programmed in efuse.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 10 ++++++++++
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h |  2 ++
>   2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> index 30d940cf3abf..7b7099cbb1c7 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -207,6 +207,14 @@ u8 rtl_get_hwpg_package_type(struct rtl_priv *rtlpriv)
>   	return rtlhal->package_type;
>   }
>   
> +static
> +u8 rtl_get_hwpg_rfe_type(struct rtl_priv *rtlpriv)
> +{
> +	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
> +
> +	return rtlhal->rfe_type;
> +}
> +
>   static
>   bool halbtc_is_hw_mailbox_exist(struct btc_coexist *btcoexist)
>   {
> @@ -1309,6 +1317,8 @@ bool exhalbtc_bind_bt_coex_withadapter(void *adapter)
>   		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
>   			 "[BTCoex], Package Type = Non-TFBGA\n");
>   
> +	btcoexist->board_info.rfe_type = rtl_get_hwpg_rfe_type(rtlpriv);
> +
>   	return true;
>   }
>   
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index cbbf5e5a9c9b..ee7bbbd87eae 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -151,6 +151,8 @@ struct btc_board_info {
>   	u8 btdm_ant_pos;
>   	u8 single_ant_path; /* current used for 8723b only, 1=>s0,  0=>s1 */
>   	bool tfbga_package;
> +
> +	u8 rfe_type;
>   };
>   
>   enum btc_dbg_opcode {

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Of course, until HP starts encoding efuse correctly, the special ant_sel code is 
still needed.

Larry
