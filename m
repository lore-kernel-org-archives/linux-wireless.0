Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36135 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbdFPUij (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 16:38:39 -0400
Subject: Re: [PATCH] rtlwifi: rtl8821ae: remove unused variable
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170613204259.GA9189@embeddedgus>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <07125d75-90a5-5255-d270-2ab8c6522b39@lwfinger.net> (sfid-20170616_223912_151655_1AF81626)
Date: Fri, 16 Jun 2017 15:38:36 -0500
MIME-Version: 1.0
In-Reply-To: <20170613204259.GA9189@embeddedgus>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/13/2017 03:42 PM, Gustavo A. R. Silva wrote:
> Remove unused variable rtlhal.
> 
> Addresses-Coverity-ID: 1248810
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---

NACK!! That variable is used in file core.c in driver rtlwifi, which is loaded 
and used by rtl8821ae.

Please do more than blindly follow Coverity outputs, or improve that tool!

Larry

>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> index 2bc6bac..d158e34 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> @@ -1360,7 +1360,6 @@ static bool _rtl8821ae_reset_pcie_interface_dma(struct ieee80211_hw *hw,
>   static void _rtl8821ae_get_wakeup_reason(struct ieee80211_hw *hw)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
>   	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
>   	u8 fw_reason = 0;
>   	struct timeval ts;
> @@ -1372,8 +1371,6 @@ static void _rtl8821ae_get_wakeup_reason(struct ieee80211_hw *hw)
>   
>   	ppsc->wakeup_reason = 0;
>   
> -	rtlhal->last_suspend_sec = ts.tv_sec;
> -
>   	switch (fw_reason) {
>   	case FW_WOW_V2_PTK_UPDATE_EVENT:
>   		ppsc->wakeup_reason = WOL_REASON_PTK_UPDATE;
> 
