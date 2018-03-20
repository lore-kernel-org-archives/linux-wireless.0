Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:44359 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752332AbeCTEAw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 00:00:52 -0400
Received: by mail-oi0-f66.google.com with SMTP id 23-v6so217078oir.11
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2018 21:00:51 -0700 (PDT)
Subject: Re: [PATCH v2 08/15] rtlwifi: btcoex: Add pre- and post- normal LPS
 function
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180306012554.3108-1-pkshih@realtek.com>
 <20180306012554.3108-9-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <970b8754-1930-8251-dc8d-4b43bc3c4dd9@lwfinger.net> (sfid-20180320_050057_709787_3271F9EA)
Date: Mon, 19 Mar 2018 23:00:49 -0500
MIME-Version: 1.0
In-Reply-To: <20180306012554.3108-9-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2018 07:25 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Normal LPS is decomposed into pre- and post- parts, so we can issue H2C
> with TDMA parameters in the "critical section" that dirver can't change
> LPS state at the moment.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 22 ++++++++++++++++++++++
>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  2 ++
>   2 files changed, 24 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> index bfb32d476a70..0f664a0490a7 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -363,6 +363,22 @@ static void halbtc_normal_lps(struct btc_coexist *btcoexist)
>   	}
>   }
>   
> +static void halbtc_pre_normal_lps(struct btc_coexist *btcoexist)
> +{
> +	struct rtl_priv *rtlpriv = btcoexist->adapter;
> +
> +	if (btcoexist->bt_info.bt_ctrl_lps) {
> +		btcoexist->bt_info.bt_lps_on = false;
> +		rtl_lps_leave(rtlpriv->mac80211.hw);
> +	}
> +}
> +
> +static void halbtc_post_normal_lps(struct btc_coexist *btcoexist)
> +{
> +	if (btcoexist->bt_info.bt_ctrl_lps)
> +		btcoexist->bt_info.bt_ctrl_lps = false;
> +}
> +
>   static void halbtc_leave_low_power(struct btc_coexist *btcoexist)
>   {
>   }
> @@ -806,6 +822,12 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
>   	case BTC_SET_ACT_NORMAL_LPS:
>   		halbtc_normal_lps(btcoexist);
>   		break;
> +	case BTC_SET_ACT_PRE_NORMAL_LPS:
> +		halbtc_pre_normal_lps(btcoexist);
> +		break;
> +	case BTC_SET_ACT_POST_NORMAL_LPS:
> +		halbtc_post_normal_lps(btcoexist);
> +		break;
>   	case BTC_SET_ACT_DISABLE_LOW_POWER:
>   		halbtc_disable_low_power(btcoexist, *bool_tmp);
>   		break;
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> index 1f12449363c2..ad80ec05975e 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> @@ -349,6 +349,8 @@ enum btc_set_type {
>   	BTC_SET_ACT_LEAVE_LPS,
>   	BTC_SET_ACT_ENTER_LPS,
>   	BTC_SET_ACT_NORMAL_LPS,
> +	BTC_SET_ACT_PRE_NORMAL_LPS,
> +	BTC_SET_ACT_POST_NORMAL_LPS,
>   	BTC_SET_ACT_INC_FORCE_EXEC_PWR_CMD_CNT,
>   	BTC_SET_ACT_DISABLE_LOW_POWER,
>   	BTC_SET_ACT_UPDATE_RAMASK,
> 
