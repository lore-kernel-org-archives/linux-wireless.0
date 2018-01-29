Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:40430 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbeA2Dwz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Jan 2018 22:52:55 -0500
Received: by mail-oi0-f65.google.com with SMTP id a184so4080344oif.7
        for <linux-wireless@vger.kernel.org>; Sun, 28 Jan 2018 19:52:55 -0800 (PST)
Subject: Re: [PATCH v2 06/10] rtlwifi: Fix VHT NSS in RC
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180129032641.17841-1-pkshih@realtek.com>
 <20180129032641.17841-7-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4479df0b-b6aa-bbf4-e0d2-186e0d8d856d@lwfinger.net> (sfid-20180129_045500_459906_CA5F5095)
Date: Sun, 28 Jan 2018 21:52:50 -0600
MIME-Version: 1.0
In-Reply-To: <20180129032641.17841-7-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2018 09:26 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> NSS is a argument of highest rate in RC, and it occupies bit 4-7 so use
> ieee80211_rate_set_vht() to fill the values. Since it got correct rate
> index, we don't need to check chips to assign NSS in set function anymore.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rc.c | 55 ++++++++++++++++++++++++++-----
>   1 file changed, 46 insertions(+), 9 deletions(-)

The switch statement is cleaner.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rc.c b/drivers/net/wireless/realtek/rtlwifi/rc.c
> index d1cb7d405618..6c78c6dabbdf 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rc.c
> @@ -42,6 +42,23 @@ static u8 _rtl_rc_get_highest_rix(struct rtl_priv *rtlpriv,
>   	struct rtl_phy *rtlphy = &(rtlpriv->phy);
>   	struct rtl_sta_info *sta_entry = NULL;
>   	u16 wireless_mode = 0;
> +	u8 nss;
> +	struct ieee80211_tx_rate rate;
> +
> +	switch (get_rf_type(rtlphy)) {
> +	case RF_4T4R:
> +		nss = 4;
> +		break;
> +	case RF_3T3R:
> +		nss = 3;
> +		break;
> +	case RF_2T2R:
> +		nss = 2;
> +		break;
> +	default:
> +		nss = 1;
> +		break;
> +	}
>   
>   	/*
>   	 *this rate is no use for true rate, firmware
> @@ -66,28 +83,51 @@ static u8 _rtl_rc_get_highest_rix(struct rtl_priv *rtlpriv,
>   			} else if (wireless_mode == WIRELESS_MODE_G) {
>   				return G_MODE_MAX_RIX;
>   			} else if (wireless_mode == WIRELESS_MODE_N_24G) {
> -				if (get_rf_type(rtlphy) != RF_2T2R)
> +				if (nss == 1)
>   					return N_MODE_MCS7_RIX;
>   				else
>   					return N_MODE_MCS15_RIX;
>   			} else if (wireless_mode == WIRELESS_MODE_AC_24G) {
> -				return AC_MODE_MCS9_RIX;
> +				if (sta->bandwidth == IEEE80211_STA_RX_BW_20) {
> +					ieee80211_rate_set_vht(&rate,
> +							       AC_MODE_MCS8_RIX,
> +							       nss);
> +					goto out;
> +				} else {
> +					ieee80211_rate_set_vht(&rate,
> +							       AC_MODE_MCS9_RIX,
> +							       nss);
> +					goto out;
> +				}
>   			}
>   			return 0;
>   		} else {
>   			if (wireless_mode == WIRELESS_MODE_A) {
>   				return A_MODE_MAX_RIX;
>   			} else if (wireless_mode == WIRELESS_MODE_N_5G) {
> -				if (get_rf_type(rtlphy) != RF_2T2R)
> +				if (nss == 1)
>   					return N_MODE_MCS7_RIX;
>   				else
>   					return N_MODE_MCS15_RIX;
>   			} else if (wireless_mode == WIRELESS_MODE_AC_5G) {
> -				return AC_MODE_MCS9_RIX;
> +				if (sta->bandwidth == IEEE80211_STA_RX_BW_20) {
> +					ieee80211_rate_set_vht(&rate,
> +							       AC_MODE_MCS8_RIX,
> +							       nss);
> +					goto out;
> +				} else {
> +					ieee80211_rate_set_vht(&rate,
> +							       AC_MODE_MCS9_RIX,
> +							       nss);
> +					goto out;
> +				}
>   			}
>   			return 0;
>   		}
>   	}
> +
> +out:
> +	return rate.idx;
>   }
>   
>   static void _rtl_rc_rate_set_series(struct rtl_priv *rtlpriv,
> @@ -111,9 +151,6 @@ static void _rtl_rc_rate_set_series(struct rtl_priv *rtlpriv,
>   	}
>   	rate->count = tries;
>   	rate->idx = rix >= 0x00 ? rix : 0x00;
> -	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8812AE &&
> -	    wireless_mode == WIRELESS_MODE_AC_5G)
> -		rate->idx += 0x10;/*2NSS for 8812AE*/
>   
>   	if (!not_data) {
>   		if (txrc->short_preamble)
> @@ -126,10 +163,10 @@ static void _rtl_rc_rate_set_series(struct rtl_priv *rtlpriv,
>   			if (sta && sta->vht_cap.vht_supported)
>   				rate->flags |= IEEE80211_TX_RC_80_MHZ_WIDTH;
>   		} else {
> -			if (mac->bw_40)
> -				rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
>   			if (mac->bw_80)
>   				rate->flags |= IEEE80211_TX_RC_80_MHZ_WIDTH;
> +			else if (mac->bw_40)
> +				rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
>   		}
>   
>   		if (sgi_20 || sgi_40 || sgi_80)
> 
