Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35570 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934300AbcHJS03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:26:29 -0400
Received: by mail-oi0-f65.google.com with SMTP id e80so1035176oig.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2016 11:26:29 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: rtl8192de: Fix leak in
 _rtl92de_read_adapter_info()
To: Christian Engelmayer <cengelma@gmx.at>, chaoming_li@realsil.com.cn
References: <1470770397-24390-1-git-send-email-cengelma@gmx.at>
Cc: kvalo@codeaurora.org, arnd@arndb.de, linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a04f9806-e8cc-9858-9189-82206fd82d5d@lwfinger.net> (sfid-20160810_202635_764781_F0939C1A)
Date: Wed, 10 Aug 2016 09:10:22 -0500
MIME-Version: 1.0
In-Reply-To: <1470770397-24390-1-git-send-email-cengelma@gmx.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2016 02:19 PM, Christian Engelmayer wrote:
> In case rtl_get_hwinfo() fails, the function directly returns and leaks the
> already allocated hwinfo memory. Go through the correct exit path.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

This patch looks good. Thanks.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
> index b0f632462335..57205514801c 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
> @@ -1757,7 +1757,7 @@ static void _rtl92de_read_adapter_info(struct ieee80211_hw *hw)
>  		return;
>
>  	if (rtl_get_hwinfo(hw, rtlpriv, HWSET_MAX_SIZE, hwinfo, params))
> -		return;
> +		goto exit;
>
>  	_rtl92de_efuse_update_chip_version(hw);
>  	_rtl92de_read_macphymode_and_bandtype(hw, hwinfo);
> @@ -1790,6 +1790,7 @@ static void _rtl92de_read_adapter_info(struct ieee80211_hw *hw)
>  		break;
>  	}
>  	rtlefuse->txpwr_fromeprom = true;
> +exit:
>  	kfree(hwinfo);
>  }
>
>

