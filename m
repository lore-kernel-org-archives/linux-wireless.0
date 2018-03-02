Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:38190 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbeCBWHe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 17:07:34 -0500
Received: by mail-ot0-f194.google.com with SMTP id 95so10068459ote.5
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2018 14:07:34 -0800 (PST)
Subject: Re: [PATCH 02/15] rtlwifi: remove redundant statement found by static
 checker
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180228030718.19510-1-pkshih@realtek.com>
 <20180228030718.19510-3-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <14a0642d-b8d5-2111-c937-96c22987ec49@lwfinger.net> (sfid-20180302_230737_950138_435449C8)
Date: Fri, 2 Mar 2018 16:07:32 -0600
MIME-Version: 1.0
In-Reply-To: <20180228030718.19510-3-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2018 09:07 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> smatch reports "rtl_is_special_data() warn: inconsistent indenting", but
> it is an obvious redundant statement so remove it.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   drivers/net/wireless/realtek/rtlwifi/base.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
> index 6db3389e2ced..762a29cdf7ad 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -1549,7 +1549,6 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
>   		/* EAPOL is seens as in-4way */
>   		rtlpriv->btcoexist.btc_info.in_4way = true;
>   		rtlpriv->btcoexist.btc_info.in_4way_ts = jiffies;
> -	rtlpriv->btcoexist.btc_info.in_4way_ts = jiffies;
>   
>   		RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
>   			 "802.1X %s EAPOL pkt!!\n", (is_tx) ? "Tx" : "Rx");
> 
