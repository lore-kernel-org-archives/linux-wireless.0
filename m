Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43260 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752217AbdG1PnT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 11:43:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8821ae: Fix HW_VAR_NAV_UPPER operation
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170713074323.r7rjpnp6ghrdtjgx@mwanda>
References: <20170713074323.r7rjpnp6ghrdtjgx@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Masanari Iida <standby24x7@gmail.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20170728154319.6B1E96090D@smtp.codeaurora.org> (sfid-20170728_174323_765760_FA955621)
Date: Fri, 28 Jul 2017 15:43:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The cast here is wrong.  We want to cast the pointer but we accidentally
> do a no-op cast of the value.  We normally want to set us_nav_upper to
> WIFI_NAV_UPPER_US (30000) but because of this bug we instead set it to
> 184 on little endian systems and 0 on big endian ones.
> 
> Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> index 2bc6bace069c..230f92a48f3c 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> @@ -779,7 +779,7 @@ void rtl8821ae_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>  			_rtl8821ae_resume_tx_beacon(hw);
>  		break; }
>  	case HW_VAR_NAV_UPPER: {
> -		u32	us_nav_upper = ((u32)*val);
> +		u32	us_nav_upper = *(u32 *)val;
>  
>  		if (us_nav_upper > HAL_92C_NAV_UPPER_UNIT * 0xFF) {
>  			RT_TRACE(rtlpriv, COMP_INIT , DBG_WARNING,

Patch applied to wireless-drivers-next.git, thanks.

d28ac7be15c7 rtlwifi: rtl8821ae: Fix HW_VAR_NAV_UPPER operation

-- 
https://patchwork.kernel.org/patch/9837847/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
