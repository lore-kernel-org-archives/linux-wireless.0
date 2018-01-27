Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:37509 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbeA0TjY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 14:39:24 -0500
Received: by mail-ot0-f194.google.com with SMTP id a24so3206327otd.4
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jan 2018 11:39:24 -0800 (PST)
Subject: Re: [PATCH 06/10] rtlwifi: Fix VHT NSS in RC
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180126074645.27201-1-pkshih@realtek.com>
 <20180126074645.27201-7-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <940c2aa9-67c3-7058-7e25-665a56eb4b1b@lwfinger.net> (sfid-20180127_203946_228088_D7EF244E)
Date: Sat, 27 Jan 2018 13:39:22 -0600
MIME-Version: 1.0
In-Reply-To: <20180126074645.27201-7-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 01:46 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> NSS is a argument of highest rate in RC, and it occupies bit 4-7 so use
> ieee80211_rate_set_vht() to fill the values. Since it got correct rate
> index, we don't need to check chips to assign NSS in set function anymore.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rc.c | 49 +++++++++++++++++++++++++------
>   1 file changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rc.c b/drivers/net/wireless/realtek/rtlwifi/rc.c
> index d1cb7d405618..396bed8d3d51 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rc.c
> @@ -42,6 +42,17 @@ static u8 _rtl_rc_get_highest_rix(struct rtl_priv *rtlpriv,
>   	struct rtl_phy *rtlphy = &(rtlpriv->phy);
>   	struct rtl_sta_info *sta_entry = NULL;
>   	u16 wireless_mode = 0;
> +	u8 nss;
> +	struct ieee80211_tx_rate rate;
> +
> +	if (get_rf_type(rtlphy) >= RF_4T4R)
> +		nss = 4;
> +	else if (get_rf_type(rtlphy) >= RF_3T3R)
> +		nss = 3;
> +	else if (get_rf_type(rtlphy) >= RF_2T2R)
> +		nss = 2;
> +	else
> +		nss = 1;

As a general rule, I think that if ... else if ... else if ... else ... 
constructions should be changed to switch statements. This one is simple enough 
that there will be no complications, but keep this in mind in the future.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
