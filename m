Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36646 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756314AbeASWmB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 17:42:01 -0500
Received: by mail-oi0-f66.google.com with SMTP id w135so2184983oie.3
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jan 2018 14:42:01 -0800 (PST)
Subject: Re: [PATCH 08/10] rtlwifi: 8822be has to report vht capability to
 mac80211
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180119064551.10084-1-pkshih@realtek.com>
 <20180119064551.10084-9-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <0a29c76b-d14f-2cdb-4723-6597ba38a8de@lwfinger.net> (sfid-20180119_234205_984348_F7CCDD9C)
Date: Fri, 19 Jan 2018 16:41:59 -0600
MIME-Version: 1.0
In-Reply-To: <20180119064551.10084-9-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/2018 12:45 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> 8822be is 2x2 11ac wifi chip, so report VHT capability to mac80211.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/base.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>


> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
> index c8ebf738cb2b..7fa435e95c0e 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -244,7 +244,8 @@ static void _rtl_init_hw_vht_capab(struct ieee80211_hw *hw,
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
>   
> -	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE) {
> +	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE ||
> +	    rtlhal->hw_type == HARDWARE_TYPE_RTL8822BE) {
>   		u16 mcs_map;
>   
>   		vht_cap->vht_supported = true;
> 
