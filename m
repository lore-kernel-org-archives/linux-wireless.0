Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:46204 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751337AbeA2SSb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 13:18:31 -0500
Received: by mail-ot0-f196.google.com with SMTP id t35so7417534otd.13
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jan 2018 10:18:31 -0800 (PST)
Subject: Re: [PATCH 02/10] rtlwifi: Add Support VHT to spec_ver
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180126074645.27201-1-pkshih@realtek.com>
 <20180126074645.27201-3-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <7c29967a-80b0-a2c7-dd1e-1fc3109e1492@lwfinger.net> (sfid-20180129_191836_174848_1587E375)
Date: Mon, 29 Jan 2018 12:18:30 -0600
MIME-Version: 1.0
In-Reply-To: <20180126074645.27201-3-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 01:46 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> We are going to add 8822be, which is a VHT 2x2 wifi chip, so add VHT flag
> to replace enumeration of chips.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>


> ---
>   drivers/net/wireless/realtek/rtlwifi/base.c         | 6 ++++--
>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 1 +
>   drivers/net/wireless/realtek/rtlwifi/wifi.h         | 1 +
>   3 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
> index e461eed32699..a2da057d3cdd 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -244,6 +244,9 @@ static void _rtl_init_hw_vht_capab(struct ieee80211_hw *hw,
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
>   
> +	if (!(rtlpriv->cfg->spec_ver & RTL_SPEC_SUPPORT_VHT))
> +		return;
> +
>   	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE ||
>   	    rtlhal->hw_type == HARDWARE_TYPE_RTL8822BE) {
>   		u16 mcs_map;
> @@ -887,8 +890,7 @@ static void _rtl_query_bandwidth_mode(struct ieee80211_hw *hw,
>   
>   	tcb_desc->packet_bw = HT_CHANNEL_WIDTH_20_40;
>   
> -	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8812AE ||
> -	    rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8821AE) {
> +	if (rtlpriv->cfg->spec_ver & RTL_SPEC_SUPPORT_VHT) {
>   		if (mac->opmode == NL80211_IFTYPE_AP ||
>   		    mac->opmode == NL80211_IFTYPE_ADHOC ||
>   		    mac->opmode == NL80211_IFTYPE_MESH_POINT) {
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
> index ab5d462b1a3a..9bb3d9dfce79 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
> @@ -328,6 +328,7 @@ static const struct rtl_hal_cfg rtl8821ae_hal_cfg = {
>   	.alt_fw_name = "rtlwifi/rtl8821aefw.bin",
>   	.ops = &rtl8821ae_hal_ops,
>   	.mod_params = &rtl8821ae_mod_params,
> +	.spec_ver = RTL_SPEC_SUPPORT_VHT,
>   	.maps[SYS_ISO_CTRL] = REG_SYS_ISO_CTRL,
>   	.maps[SYS_FUNC_EN] = REG_SYS_FUNC_EN,
>   	.maps[SYS_CLK] = REG_SYS_CLKR,
> diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> index a7aacbc3984e..2df0bc316532 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -951,6 +951,7 @@ enum package_type {
>   
>   enum rtl_spec_ver {
>   	RTL_SPEC_NEW_RATEID = BIT(0),	/* use ratr_table_mode_new */
> +	RTL_SPEC_SUPPORT_VHT = BIT(1),	/* support VHT */
>   };
>   
>   struct octet_string {
> 
