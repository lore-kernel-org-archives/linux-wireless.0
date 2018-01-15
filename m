Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:43602 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751390AbeAOSvX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 13:51:23 -0500
Received: by mail-oi0-f66.google.com with SMTP id t16so8915361oif.10
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 10:51:23 -0800 (PST)
Subject: Re: [PATCH v2 03/10] rtlwifi: Add sta_statistics of mac80211's op,
 and set filled=0 by default
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: yhchuang@realtek.com, linux-wireless@vger.kernel.org
References: <20180111070932.9929-1-pkshih@realtek.com>
 <20180111070932.9929-4-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4cc39629-a768-60cd-6e75-841f90560114@lwfinger.net> (sfid-20180115_195135_485606_AE5CFB42)
Date: Mon, 15 Jan 2018 12:51:21 -0600
MIME-Version: 1.0
In-Reply-To: <20180111070932.9929-4-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2018 01:09 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> When using iwconfig to check wifi status, wext uses 'static struct' of
> sinfo to get station info so sinfo->filled will be persistent. Since the
> commit 2b9a7e1bac24 ("mac80211: allow drivers to provide most station
> statistics") assumes driver initializes sinfo->filled to declare supported
> fields, without initialization it will report wrong info. This commit
> simply set 'filled' to be zero simply, and left sinfo to be filled by
> mac80211.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/core.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>


> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
> index a78b828f531a..ec639fa8095e 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -992,6 +992,15 @@ static int _rtl_get_hal_qnum(u16 queue)
>   	return qnum;
>   }
>   
> +static void rtl_op_sta_statistics(struct ieee80211_hw *hw,
> +				  struct ieee80211_vif *vif,
> +				  struct ieee80211_sta *sta,
> +				  struct station_info *sinfo)
> +{
> +	/* nothing filled by driver, so mac80211 will update all info */
> +	sinfo->filled = 0;
> +}
> +
>   /*
>    *for mac80211 VO = 0, VI = 1, BE = 2, BK = 3
>    *for rtl819x  BE = 0, BK = 1, VI = 2, VO = 3
> @@ -1878,6 +1887,7 @@ const struct ieee80211_ops rtl_ops = {
>   	.config = rtl_op_config,
>   	.configure_filter = rtl_op_configure_filter,
>   	.set_key = rtl_op_set_key,
> +	.sta_statistics = rtl_op_sta_statistics,
>   	.conf_tx = rtl_op_conf_tx,
>   	.bss_info_changed = rtl_op_bss_info_changed,
>   	.get_tsf = rtl_op_get_tsf,
> 
