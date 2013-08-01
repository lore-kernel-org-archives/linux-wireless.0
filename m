Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:40566 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab3HAC0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 22:26:42 -0400
Received: by mail-ob0-f175.google.com with SMTP id xn12so2791075obc.20
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 19:26:41 -0700 (PDT)
Message-ID: <51F9C75F.50502@lwfinger.net> (sfid-20130801_042645_129923_FC882954)
Date: Wed, 31 Jul 2013 21:26:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Schulte <schultetwin@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rtlwifi: rtl8192cu: fix function declaration header
References: <1375319810-20392-1-git-send-email-schultetwin@gmail.com>
In-Reply-To: <1375319810-20392-1-git-send-email-schultetwin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2013 08:16 PM, Mark Schulte wrote:
> Move rtl92cu_update_hal_rate_tbl declartion to hw.h to correspond with function

The spelling is "declaration"!.

Larry

> definition in hw.c.
> Fixes sparse warning in hw.c warning: symbol 'rtl92cu_update_hal_rate_tbl' was
> not declared.
>
> Signed-off-by: Mark Schulte <schultetwin@gmail.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.h | 3 +++
>   drivers/net/wireless/rtlwifi/rtl8192cu/sw.h | 3 ---
>   2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
> index 8e3ec1e..0f7812e 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
> @@ -109,5 +109,8 @@ void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
>   void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw,
>   			 u8 element_id, u32 cmd_len, u8 *p_cmdbuffer);
>   bool rtl92cu_phy_mac_config(struct ieee80211_hw *hw);
> +void rtl92cu_update_hal_rate_tbl(struct ieee80211_hw *hw,
> +				 struct ieee80211_sta *sta,
> +				 u8 rssi_level);
>
>   #endif
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
> index 262e1e4..a1310ab 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
> @@ -49,8 +49,5 @@ bool rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
>   u32 rtl92cu_phy_query_rf_reg(struct ieee80211_hw *hw,
>   			    enum radio_path rfpath, u32 regaddr, u32 bitmask);
>   void rtl92cu_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
> -void rtl92cu_update_hal_rate_tbl(struct ieee80211_hw *hw,
> -				 struct ieee80211_sta *sta,
> -				 u8 rssi_level);
>
>   #endif
>

