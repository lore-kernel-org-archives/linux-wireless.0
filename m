Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:52968 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751733AbdKDU0m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Nov 2017 16:26:42 -0400
Subject: Re: [PATCH] rtlwifi: remove redundant initialization to cfg_cmd
To: Colin King <colin.king@canonical.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20171104193759.919-1-colin.king@canonical.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <9b9712ba-42fd-8683-2d65-e72187647902@lwfinger.net> (sfid-20171104_212713_946665_648C6238)
Date: Sat, 4 Nov 2017 15:26:40 -0500
MIME-Version: 1.0
In-Reply-To: <20171104193759.919-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2017 02:37 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> cfg_cmd is initialized to zero and this value is never read, instead
> it is over-written in the start of a do-while loop. Remove the
> redundant initialization. Cleans up clang warning:
> 
> drivers/net/wireless/realtek/rtlwifi/core.c:1750:22: warning: Value
> stored to 'cfg_cmd' during its initialization is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Looks OK to me.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

> ---
>   drivers/net/wireless/realtek/rtlwifi/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
> index 1147327e6f52..7a17cc20c57e 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -1748,7 +1748,7 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
>   			      u8 faversion, u8 interface_type,
>   			      struct wlan_pwr_cfg pwrcfgcmd[])
>   {
> -	struct wlan_pwr_cfg cfg_cmd = {0};
> +	struct wlan_pwr_cfg cfg_cmd;
>   	bool polling_bit = false;
>   	u32 ary_idx = 0;
>   	u8 value = 0;
> 
