Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34544 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbeAVS4j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 13:56:39 -0500
Received: by mail-ot0-f193.google.com with SMTP id x15so3716616ote.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jan 2018 10:56:38 -0800 (PST)
Subject: Re: [PATCH 03/10] rtlwifi: btcoex: Add variable ant_div_cfg to
 support antenna diversity
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180119064551.10084-1-pkshih@realtek.com>
 <20180119064551.10084-4-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <50fc689d-593c-fa96-ec5b-a27eb9e21805@lwfinger.net> (sfid-20180122_195654_175824_DDCD21FB)
Date: Mon, 22 Jan 2018 12:56:32 -0600
MIME-Version: 1.0
In-Reply-To: <20180119064551.10084-4-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/2018 12:45 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> The variable will be used by btcoex of 8822be, so we prepare this variable
> in advance.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 1 +
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 1 +
>   2 files changed, 2 insertions(+)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> index b51189ae1bfd..8dc646190e35 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -1310,6 +1310,7 @@ bool exhalbtc_bind_bt_coex_withadapter(void *adapter)
>   			 "[BTCoex], Package Type = Non-TFBGA\n");
>   
>   	btcoexist->board_info.rfe_type = rtl_get_hwpg_rfe_type(rtlpriv);
> +	btcoexist->board_info.ant_div_cfg = 0;
>   
>   	return true;
>   }
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index cd3925d34854..e0818f6efb87 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -153,6 +153,7 @@ struct btc_board_info {
>   	bool tfbga_package;
>   
>   	u8 rfe_type;
> +	u8 ant_div_cfg;
>   };
>   
>   enum btc_dbg_opcode {
> 
