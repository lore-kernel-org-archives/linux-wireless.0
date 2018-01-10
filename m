Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36629 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754979AbeAJIMw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 03:12:52 -0500
Received: by mail-wm0-f68.google.com with SMTP id b76so25431932wmg.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jan 2018 00:12:52 -0800 (PST)
Subject: Re: [PATCH 02/10] rtlwifi: fix scan channel 1 fail after IPS
To: pkshih@realtek.com, kvalo@codeaurora.org
References: <20180110052002.9544-1-pkshih@realtek.com>
 <20180110052002.9544-3-pkshih@realtek.com>
Cc: Larry.Finger@lwfinger.net, yhchuang@realtek.com,
        linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A55CB01.5040504@broadcom.com> (sfid-20180110_091311_605053_1C7B57B2)
Date: Wed, 10 Jan 2018 09:12:49 +0100
MIME-Version: 1.0
In-Reply-To: <20180110052002.9544-3-pkshih@realtek.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/10/2018 6:19 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
>
> If there is no connection, driver will enter IPS state. Meanwhile, it
> fails to scan channel 1 by the command 'iw dev wlan0 scan freq 2412',
> because hardware channel setting lose after IPS. Thus, restore channel
> setting from hw->conf.channel set by last rtl_op_config().
>
> Signed-off-by: Tim Lee <timlee@realtek.com>

You need to add your sob here as well as you are submitting them.

> ---
>   drivers/net/wireless/realtek/rtlwifi/ps.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
> index 6a4008845f49..0ffe43772c9a 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/ps.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
> @@ -51,6 +51,12 @@ bool rtl_ps_enable_nic(struct ieee80211_hw *hw)
>   			&rtlmac->retry_long);
>   	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
>
> +	/*<2.1> Switch Channel & Bandwidth to last rtl_op_config setting*/

Is this type of comment really helpful? To me it seems the callback 
names provide enough context.

Regards,
Arend

> +	rtlpriv->cfg->ops->switch_channel(hw);
> +	rtlpriv->cfg->ops->set_channel_access(hw);
> +	rtlpriv->cfg->ops->set_bw_mode(hw,
> +			cfg80211_get_chandef_type(&hw->conf.chandef));
> +
>   	/*<3> Enable Interrupt */
>   	rtlpriv->cfg->ops->enable_interrupt(hw);
>
>
