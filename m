Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:43487 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbeA0TfG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 14:35:06 -0500
Received: by mail-ot0-f194.google.com with SMTP id p36so3192630otd.10
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jan 2018 11:35:05 -0800 (PST)
Subject: Re: [PATCH 07/10] rtlwifi: add definition radio_mask for RF and
 maximum bandwidth
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180126074645.27201-1-pkshih@realtek.com>
 <20180126074645.27201-8-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5f0ee5ef-e067-53dd-4a67-915274374091@lwfinger.net> (sfid-20180127_203837_608750_949AA7C0)
Date: Sat, 27 Jan 2018 13:35:04 -0600
MIME-Version: 1.0
In-Reply-To: <20180126074645.27201-8-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 01:46 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Add rf mask definition (BIT 0, BIT 1, BIT 2, ...) that is different from
> rf path definition (0, 1, 2, ...), and then combinations of rf path are
> possible.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

I agree that an rf path mask is useful.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   drivers/net/wireless/realtek/rtlwifi/wifi.h | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> index 4de2ab1d5416..2e9a20273a2d 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -286,6 +286,13 @@ enum radio_path {
>   	RF90_PATH_D = 3,
>   };
>   
> +enum radio_mask {
> +	RF_MASK_A = BIT(0),
> +	RF_MASK_B = BIT(1),
> +	RF_MASK_C = BIT(2),
> +	RF_MASK_D = BIT(3),
> +};
> +
>   enum regulation_txpwr_lmt {
>   	TXPWR_LMT_FCC = 0,
>   	TXPWR_LMT_MKK = 1,
> @@ -579,6 +586,7 @@ enum ht_channel_width {
>   	HT_CHANNEL_WIDTH_20 = 0,
>   	HT_CHANNEL_WIDTH_20_40 = 1,
>   	HT_CHANNEL_WIDTH_80 = 2,
> +	HT_CHANNEL_WIDTH_MAX,
>   };
>   
>   /* Ref: 802.11i sepc D10.0 7.3.2.25.1
> 
