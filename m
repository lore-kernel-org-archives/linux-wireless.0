Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:37509 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3HACjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 22:39:08 -0400
Received: by mail-oa0-f51.google.com with SMTP id h1so223109oag.24
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 19:39:07 -0700 (PDT)
Message-ID: <51F9CA49.3030805@lwfinger.net> (sfid-20130801_043912_213854_25511242)
Date: Wed, 31 Jul 2013 21:39:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Schulte <schultetwin@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] rtlwifi: rtl8192cu: fix function declaration header
References: <1375324214-24271-1-git-send-email-schultetwin@gmail.com>
In-Reply-To: <1375324214-24271-1-git-send-email-schultetwin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2013 09:30 PM, Mark Schulte wrote:
> Move rtl92cu_update_hal_rate_tbl declaration to hw.h to correspond with function
> definition in hw.c.
> Fixes sparse warning in hw.c warning: symbol 'rtl92cu_update_hal_rate_tbl' was
> not declared.
>
> Signed-off-by: Mark Schulte <schultetwin@gmail.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

The patch is good this time.

Larry

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

