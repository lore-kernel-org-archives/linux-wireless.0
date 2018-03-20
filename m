Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:34539 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbeCTDz3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 23:55:29 -0400
Received: by mail-ot0-f196.google.com with SMTP id m7-v6so289032otd.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2018 20:55:28 -0700 (PDT)
Subject: Re: [PATCH v2 03/15] rtlwifi: btcoex: Add enum DM_INFO for btcoex to
 query dm's counters
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180306012554.3108-1-pkshih@realtek.com>
 <20180306012554.3108-4-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <8e5fa50c-bdc8-1170-2af3-e04c149b714e@lwfinger.net> (sfid-20180320_045533_289058_E4926797)
Date: Mon, 19 Mar 2018 22:55:27 -0500
MIME-Version: 1.0
In-Reply-To: <20180306012554.3108-4-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2018 07:25 PM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> btcoex uses dm's counters to check the environment is noisy or not. If it
> is clean, btcoex set more time slots to WiFi so that it can transmit as
> soon as possible. That will save time, and BT will have more time slots
> after WiFi traffic is complete.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>


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
