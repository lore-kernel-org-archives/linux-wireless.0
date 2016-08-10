Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35928 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbcHJSBQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:01:16 -0400
Received: by mail-oi0-f68.google.com with SMTP id a101so4520608oic.3
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2016 11:01:15 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: rtl8723ae: Fix leak in
 _rtl8723e_read_adapter_info()
To: Christian Engelmayer <cengelma@gmx.at>, chaoming_li@realsil.com.cn
References: <1470772452-24642-1-git-send-email-cengelma@gmx.at>
Cc: kvalo@codeaurora.org, arnd@arndb.de, joe@perches.com,
	linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e39469af-9790-bd03-7b3f-81ea2296f834@lwfinger.net> (sfid-20160810_200128_914433_16780BAD)
Date: Wed, 10 Aug 2016 09:11:06 -0500
MIME-Version: 1.0
In-Reply-To: <1470772452-24642-1-git-send-email-cengelma@gmx.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2016 02:54 PM, Christian Engelmayer wrote:
> In case of (rtlhal->oem_id != RT_CID_DEFAULT), the function directly
> returns and leaks the already allocated hwinfo memory. Go through the
> correct exit path.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
This patch looks good. Thanks.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>


> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
> index b88c7ee72dbf..ba30efc2d195 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
> @@ -1654,7 +1654,7 @@ static void _rtl8723e_read_adapter_info(struct ieee80211_hw *hw,
>  			rtlefuse->autoload_failflag, hwinfo);
>
>  	if (rtlhal->oem_id != RT_CID_DEFAULT)
> -		return;
> +		goto exit;
>
>  	switch (rtlefuse->eeprom_oemid) {
>  	case EEPROM_CID_DEFAULT:
>

