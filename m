Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:40384 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751118AbeAOStm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 13:49:42 -0500
Received: by mail-oi0-f65.google.com with SMTP id u83so8924848oie.7
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 10:49:41 -0800 (PST)
Subject: Re: [PATCH v2 02/10] rtlwifi: fix scan channel 1 fail after IPS
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: yhchuang@realtek.com, linux-wireless@vger.kernel.org
References: <20180111070932.9929-1-pkshih@realtek.com>
 <20180111070932.9929-3-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <2015659f-afbd-2ec9-9ccb-70370b9872f5@lwfinger.net> (sfid-20180115_194947_202460_D889D8F5)
Date: Mon, 15 Jan 2018 12:49:40 -0600
MIME-Version: 1.0
In-Reply-To: <20180111070932.9929-3-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2018 01:09 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> If there is no connection, driver will enter IPS state. Meanwhile, it
> fails to scan channel 1 by the command 'iw dev wlan0 scan freq 2412',
> because hardware channel setting lose after IPS. Thus, restore channel
> setting from hw->conf.channel set by last rtl_op_config().
> 
> Signed-off-by: Tim Lee <timlee@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/ps.c | 5 +++++
>   1 file changed, 5 insertions(+)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>


> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
> index 6a4008845f49..71af24e2e051 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/ps.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
> @@ -51,6 +51,11 @@ bool rtl_ps_enable_nic(struct ieee80211_hw *hw)
>   			&rtlmac->retry_long);
>   	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
>   
> +	rtlpriv->cfg->ops->switch_channel(hw);
> +	rtlpriv->cfg->ops->set_channel_access(hw);
> +	rtlpriv->cfg->ops->set_bw_mode(hw,
> +			cfg80211_get_chandef_type(&hw->conf.chandef));
> +
>   	/*<3> Enable Interrupt */
>   	rtlpriv->cfg->ops->enable_interrupt(hw);
>   
> 
