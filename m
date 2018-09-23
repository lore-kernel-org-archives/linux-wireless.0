Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36335 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbeIWMkF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Sep 2018 08:40:05 -0400
Date: Sat, 22 Sep 2018 23:43:39 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: btcoex: Use proper enumerated types for Wi-Fi
 only interface
Message-ID: <20180923064339.GB12338@flashbox> (sfid-20180923_084433_457484_27AB1DD5)
References: <20180921220824.18344-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180921220824.18344-1-natechancellor@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 21, 2018 at 03:08:24PM -0700, Nathan Chancellor wrote:
> Clang warns when one enumerated type is implicitly converted to another.
> 
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1327:34:
> warning: implicit conversion from enumeration type 'enum
> btc_chip_interface' to different enumeration type 'enum
> wifionly_chip_interface' [-Wenum-conversion]
>                 wifionly_cfg->chip_interface = BTC_INTF_PCI;
>                                              ~ ^~~~~~~~~~~~
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1330:34:
> warning: implicit conversion from enumeration type 'enum
> btc_chip_interface' to different enumeration type 'enum
> wifionly_chip_interface' [-Wenum-conversion]
>                 wifionly_cfg->chip_interface = BTC_INTF_USB;
>                                              ~ ^~~~~~~~~~~~
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1333:34:
> warning: implicit conversion from enumeration type 'enum
> btc_chip_interface' to different enumeration type 'enum
> wifionly_chip_interface' [-Wenum-conversion]
>                 wifionly_cfg->chip_interface = BTC_INTF_UNKNOWN;
>                                              ~ ^~~~~~~~~~~~~~~~
> 3 warnings generated.
> 
> Use the values from the correct enumerated type, wifionly_chip_interface.
> 
> BTC_INTF_UNKNOWN = WIFIONLY_INTF_UNKNOWN = 0
> BTC_INTF_PCI = WIFIONLY_INTF_PCI = 0
> BTC_INTF_USB = WIFIONLY_INTF_USB = 0
> 

I have sent a v2 making these values correct.

I will make sure the '--in-reply-to' option in the future.

Nathan

> Link: https://github.com/ClangBuiltLinux/linux/issues/135
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  .../net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c   | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> index b026e80940a4..6fbf8845a2ab 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -1324,13 +1324,13 @@ bool exhalbtc_initlize_variables_wifi_only(struct rtl_priv *rtlpriv)
>  
>  	switch (rtlpriv->rtlhal.interface) {
>  	case INTF_PCI:
> -		wifionly_cfg->chip_interface = BTC_INTF_PCI;
> +		wifionly_cfg->chip_interface = WIFIONLY_INTF_PCI;
>  		break;
>  	case INTF_USB:
> -		wifionly_cfg->chip_interface = BTC_INTF_USB;
> +		wifionly_cfg->chip_interface = WIFIONLY_INTF_USB;
>  		break;
>  	default:
> -		wifionly_cfg->chip_interface = BTC_INTF_UNKNOWN;
> +		wifionly_cfg->chip_interface = WIFIONLY_INTF_UNKNOWN;
>  		break;
>  	}
>  
> -- 
> 2.19.0
> 
