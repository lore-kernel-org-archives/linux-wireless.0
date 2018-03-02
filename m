Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:32840 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752726AbeCBWTC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 17:19:02 -0500
Received: by mail-oi0-f67.google.com with SMTP id e9so1502542oii.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2018 14:19:02 -0800 (PST)
Subject: Re: [PATCH 03/15] rtlwifi: btcoex: Add enum DM_INFO for btcoex to
 query dm's counters
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180228030718.19510-1-pkshih@realtek.com>
 <20180228030718.19510-4-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <1ee67725-5198-9dae-3f46-331774f8003b@lwfinger.net> (sfid-20180302_231906_781808_CF52CD70)
Date: Fri, 2 Mar 2018 16:19:00 -0600
MIME-Version: 1.0
In-Reply-To: <20180228030718.19510-4-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2018 09:07 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> btcoex uses dm's counters to check the envoriment is nosiy or not. If it
> is clean, btcoex set more time solts to WiFi so that it can transimt as
> soon as possible. That will save time, and BT will have more time solts
> after WiFi traffic is complete.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

The commit message needs to have the following typos fixed:
envoriment should be environment
nosiy should be noisy
solts should be slots (2 places)
transimt should be transmit

Yes, I know it is difficult to write in a second language.

Larry



> ---
>   drivers/net/wireless/realtek/rtlwifi/wifi.h | 32 +++++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> index 4f48b934ec01..438678c2d14a 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -977,6 +977,38 @@ enum rtl_spec_ver {
>   	RTL_SPEC_EXT_C2H = BIT(2),	/* extend FW C2H (e.g. TX REPORT) */
>   };
>   
> +enum dm_info_query {
> +	DM_INFO_FA_OFDM,
> +	DM_INFO_FA_CCK,
> +	DM_INFO_FA_TOTAL,
> +	DM_INFO_CCA_OFDM,
> +	DM_INFO_CCA_CCK,
> +	DM_INFO_CCA_ALL,
> +	DM_INFO_CRC32_OK_VHT,
> +	DM_INFO_CRC32_OK_HT,
> +	DM_INFO_CRC32_OK_LEGACY,
> +	DM_INFO_CRC32_OK_CCK,
> +	DM_INFO_CRC32_ERROR_VHT,
> +	DM_INFO_CRC32_ERROR_HT,
> +	DM_INFO_CRC32_ERROR_LEGACY,
> +	DM_INFO_CRC32_ERROR_CCK,
> +	DM_INFO_EDCCA_FLAG,
> +	DM_INFO_OFDM_ENABLE,
> +	DM_INFO_CCK_ENABLE,
> +	DM_INFO_CRC32_OK_HT_AGG,
> +	DM_INFO_CRC32_ERROR_HT_AGG,
> +	DM_INFO_DBG_PORT_0,
> +	DM_INFO_CURR_IGI,
> +	DM_INFO_RSSI_MIN,
> +	DM_INFO_RSSI_MAX,
> +	DM_INFO_CLM_RATIO,
> +	DM_INFO_NHM_RATIO,
> +	DM_INFO_IQK_ALL,
> +	DM_INFO_IQK_OK,
> +	DM_INFO_IQK_NG,
> +	DM_INFO_SIZE,
> +};
> +
>   struct octet_string {
>   	u8 *octet;
>   	u16 length;
> 
