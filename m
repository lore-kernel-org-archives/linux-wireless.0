Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35182 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675AbcCQQJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 12:09:44 -0400
Subject: Re: [PATCH] rtlwifi: fix gcc-6 indentation warning
To: Arnd Bergmann <arnd@arndb.de>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1458209066-3979295-1-git-send-email-arnd@arndb.de>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56EAD6C5.9030208@lwfinger.net> (sfid-20160317_171009_584914_37E01EB5)
Date: Thu, 17 Mar 2016 11:09:41 -0500
MIME-Version: 1.0
In-Reply-To: <1458209066-3979295-1-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/17/2016 05:03 AM, Arnd Bergmann wrote:
> The rtl8821ae_dm_txpower_tracking_callback_thermalmeter function
> contains a call to RT_TRACE() that is indented in a misleading
> way, as pointed out by a gcc-6 warning:
>
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c: In function 'rtl8821ae_dm_txpower_tracking_callback_thermalmeter':
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c:2491:4: error: statement is indented as if it were guarded by...
>      RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
>      ^~~~~~~~
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c:2488:3: note: ...this 'for' clause, but it is not
>     for (p = RF90_PATH_A; p < MAX_PATH_NUM_8821A; p++)
>     ^~~
>
> It is clear from the context that the call was not meant to be
> part of the loop and only the indentation is wrong, so this
> removes the extra tabs.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
> index 95dcbff4673b..6a8245c4ea48 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
> @@ -2488,9 +2488,9 @@ void rtl8821ae_dm_txpower_tracking_callback_thermalmeter(
>   		for (p = RF90_PATH_A; p < MAX_PATH_NUM_8821A; p++)
>   			rtldm->swing_idx_ofdm_base[p] = rtldm->swing_idx_ofdm[p];
>
> -			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
> -				 "pDM_Odm->RFCalibrateInfo.ThermalValue = %d ThermalValue= %d\n",
> -				 rtldm->thermalvalue, thermal_value);
> +		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
> +			 "pDM_Odm->RFCalibrateInfo.ThermalValue = %d ThermalValue= %d\n",
> +			 rtldm->thermalvalue, thermal_value);
>   		/*Record last Power Tracking Thermal Value*/
>   		rtldm->thermalvalue = thermal_value;
>   	}
>

This change looks good to me.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

