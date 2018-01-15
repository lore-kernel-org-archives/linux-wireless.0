Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:46421 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751345AbeAOSzP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 13:55:15 -0500
Received: by mail-oi0-f68.google.com with SMTP id d124so8931184oib.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 10:55:15 -0800 (PST)
Subject: Re: [PATCH v2 06/10] rtlwifi: Support A-MSDU in A-MPDU capability
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: yhchuang@realtek.com, linux-wireless@vger.kernel.org
References: <20180111070932.9929-1-pkshih@realtek.com>
 <20180111070932.9929-7-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <048f2fad-77f5-f771-3340-61a5b59283aa@lwfinger.net> (sfid-20180115_195520_724414_62EFDFCC)
Date: Mon, 15 Jan 2018 12:55:14 -0600
MIME-Version: 1.0
In-Reply-To: <20180111070932.9929-7-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2018 01:09 AM, pkshih@realtek.com wrote:
> From: Steven Ting <steventing@realtek.com>
> 
> Due to the fact that A-MSDU deaggregation is done in software,
> we set this flag to support the A-MSDU in A-MPDU
> 
> Signed-off-by: Steven Ting <steventing@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/base.c | 1 +
>   1 file changed, 1 insertion(+)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
> index e902cd7adbfe..07b91bc9adf9 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -397,6 +397,7 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
>   	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
>   	ieee80211_hw_set(hw, SUPPORTS_TX_FRAG);
>   	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
> +	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
>   
>   	/* swlps or hwlps has been set in diff chip in init_sw_vars */
>   	if (rtlpriv->psc.swctrl_lps) {
> 
