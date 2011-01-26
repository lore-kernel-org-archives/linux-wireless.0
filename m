Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39003 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1AZRdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 12:33:24 -0500
Received: by qwa26 with SMTP id 26so1152291qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 09:33:23 -0800 (PST)
Message-ID: <4D405B09.9070900@lwfinger.net>
Date: Wed, 26 Jan 2011 11:34:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?GB2312?B?wO6zr8P3?= <chaoming_li@realsil.com.cn>,
	linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] fix_rtlwifi_rfkill_state_not_synchronous_with_true_rfstate_issue
References: <1291828372-25159-1-git-send-email-Larry.Finger@lwfinger.net>     <1291828372-25159-5-git-send-email-Larry.Finger@lwfinger.net> <301B5E6D9B3042F6ABB4C6479ACB875E@realsil.com.cn> <5D449C23195D46B388A79AE17932553E@realsil.com.cn>
In-Reply-To: <5D449C23195D46B388A79AE17932553E@realsil.com.cn>
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2011 11:08 PM, Àî³¯Ã÷ wrote:
> Sorry for last patch have no description.
> 
> 1. when driver init, rfkill_state was setted, but because the flag valid may
> not be true, this will cause rfkill_state
> not synchronous with the true rf state, and will cause some issues when we
> do rfkill.
> and now in driver init we will set rfkill_state to rf_on, and at the same
> time 
> we tell rfkill to set rf_on also.
> 
> 2. for rtl8192ce you can check GPIO any time, not only after up_first_time
> == true. so we delete rtlpci->up_first_time
> in rtl92ce_gpio_radio_on_off_checking.
> 
> Signed-off-by: chaoming_li  <chaoming_li@realsil.com.cn>

Chaoming,

This patch was line wrapped by your mailer. I'm not sure what you need to do to
allow longer lines, but we can discuss this offline.

I still see a couple of problems with the code after this patch is applied. When
the system is booted or when rtl8192ce is loaded, the log always shows the
switch to be off, no matter the actual position. In addition, the status is not
logged when the switch is moved.

@John,

 We will work out the points noted above and get a revised patch to you. I t
will likely be part of some larger changes in rtlwifi that are needed to
accommodate some new drivers that are nearly ready.

Larry

> 
> ---
>  drivers/net/wireless/rtlwifi/base.c         |   13 ++++++++-----
>  drivers/net/wireless/rtlwifi/rtl8192ce/hw.c |    2 +-
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/base.c
> b/drivers/net/wireless/rtlwifi/base.c
> index cf0b73e..33323b4 100644
> --- a/drivers/net/wireless/rtlwifi/base.c
> +++ b/drivers/net/wireless/rtlwifi/base.c
> @@ -251,15 +251,18 @@ void rtl_init_rfkill(struct ieee80211_hw *hw)
>  	bool blocked;
>  	u8 valid = 0;
>  
> -	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
> +	/*1. set init state to on */
> +	rtlpriv->rfkill.rfkill_state = 1;
> +	wiphy_rfkill_set_hw_state(hw->wiphy, 0);
>  
> -	/*set init state to that of switch */
> -	rtlpriv->rfkill.rfkill_state = radio_state;
> -	printk(KERN_INFO "rtlwifi: wireless switch is %s\n",
> -	       rtlpriv->rfkill.rfkill_state ? "on" : "off");
> +	/*2. check gpio for rf state */
> +	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
>  
> +	/*3. if valid, change state based on gpio */
>  	if (valid) {
>  		rtlpriv->rfkill.rfkill_state = radio_state;
> +		printk(KERN_INFO "rtlwifi: wireless switch is %s\n",
> +				rtlpriv->rfkill.rfkill_state ? "on" :
> "off");
>  
>  		blocked = (rtlpriv->rfkill.rfkill_state == 1) ? 0 : 1;
>  		wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> index 1c41a0c..cb2e01a 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> @@ -1943,7 +1943,7 @@ bool rtl92ce_gpio_radio_on_off_checking(struct
> ieee80211_hw *hw, u8 * valid)
>  	bool b_actuallyset = false;
>  	unsigned long flag;
>  
> -	if ((rtlpci->up_first_time == 1) || (rtlpci->being_init_adapter))
> +	if (rtlpci->being_init_adapter)
>  		return false;
>  
>  	if (ppsc->b_swrf_processing)

