Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52563 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab2DBQJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 12:09:47 -0400
Received: by obbtb18 with SMTP id tb18so2249780obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 09:09:47 -0700 (PDT)
Message-ID: <4F79CF47.5000804@lwfinger.net> (sfid-20120402_180951_314894_B21D0963)
Date: Mon, 02 Apr 2012 11:09:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Forest Bond <forest@alittletooquiet.net>
CC: linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Jingjun Wu <jingjun_wu@realsil.com.cn>
Subject: Re: [PATCH 2/2] rtl8192de: Recognize 92D E-CUT version.
References: <20120402142537.GB20611@alittletooquiet.net>
In-Reply-To: <20120402142537.GB20611@alittletooquiet.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/02/2012 09:25 AM, Forest Bond wrote:
> From: Forest Bond<forest.bond@rapidrollout.com>
>
> The chip version constant (0xCC33) was taken from version 0001.0105.2011
> of the GPL vendor driver.  Note that this driver version also ships a
> firmware update, but I am unsure if it is required for E-CUT chips to
> function properly.

There is also a new version of the RTL8192SE firmware in that driver. Too bad 
that Realtek doesn't communicate these changes with me, I will test and submit 
the updated firmware if the changes make a difference.

>
> A nearby spelling error was also corrected.
>
> Signed-off-by: Forest Bond<forest.bond@rapidrollout.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/hw.c |    6 +++++-
>   1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> index 509f5af..b338d52 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> @@ -1743,9 +1743,13 @@ static void _rtl92de_efuse_update_chip_version(struct ieee80211_hw *hw)
>   		chipver |= CHIP_92D_D_CUT;
>   		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "D-CUT!!!\n");
>   		break;
> +	case 0xCC33:
> +		chipver |= CHIP_92D_E_CUT;
> +		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "E-CUT!!!\n");
> +		break;

This comment is a note to myself, not a criticism of your patch. These magic 
numbers need to be replaced by defined constants.

>   	default:
>   		chipver |= CHIP_92D_D_CUT;
> -		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Unkown CUT!\n");
> +		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Unknown CUT!\n");
>   		break;
>   	}
>   	rtlpriv->rtlhal.version = chipver;

Thanks,

Larry
