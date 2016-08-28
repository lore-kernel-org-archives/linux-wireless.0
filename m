Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35229 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbcH1CaI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Aug 2016 22:30:08 -0400
Subject: Re: [PATCH] rtlwifi/rtl8192de: Fix print format string
To: Oleg Drokin <green@linuxhacker.ru>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1472267543-810602-1-git-send-email-green@linuxhacker.ru>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <02432ef7-0e5e-5c83-bde9-6269dabac3b6@lwfinger.net> (sfid-20160828_043036_594173_428D1F35)
Date: Sat, 27 Aug 2016 21:30:06 -0500
MIME-Version: 1.0
In-Reply-To: <1472267543-810602-1-git-send-email-green@linuxhacker.ru>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/26/2016 10:12 PM, Oleg Drokin wrote:
> %ul was likely meant as %lu to print an unsigned long,
> not an unsigned with a letter l at the end.
> But in fact the value printed is u32 anyway, so just drop
> the l completely.

This patch looks OK, thus

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> index d334d2a..2a4810d 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> @@ -588,7 +588,7 @@ static bool _rtl92d_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
>  				 * setting. */
>  				udelay(1);
>  				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
> -					 "The Rtl819XAGCTAB_Array_Table[0] is %ul Rtl819XPHY_REGArray[1] is %ul\n",
> +					 "The Rtl819XAGCTAB_Array_Table[0] is %u Rtl819XPHY_REGArray[1] is %u\n",
>  					 agctab_array_table[i],
>  					 agctab_array_table[i + 1]);
>  			}
> @@ -604,7 +604,7 @@ static bool _rtl92d_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
>  					 * setting. */
>  					udelay(1);
>  					RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
> -						 "The Rtl819XAGCTAB_Array_Table[0] is %ul Rtl819XPHY_REGArray[1] is %ul\n",
> +						 "The Rtl819XAGCTAB_Array_Table[0] is %u Rtl819XPHY_REGArray[1] is %u\n",
>  						 agctab_array_table[i],
>  						 agctab_array_table[i + 1]);
>  				}
> @@ -620,7 +620,7 @@ static bool _rtl92d_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
>  					 * setting. */
>  					udelay(1);
>  					RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
> -						 "The Rtl819XAGCTAB_5GArray_Table[0] is %ul Rtl819XPHY_REGArray[1] is %ul\n",
> +						 "The Rtl819XAGCTAB_5GArray_Table[0] is %u Rtl819XPHY_REGArray[1] is %u\n",
>  						 agctab_5garray_table[i],
>  						 agctab_5garray_table[i + 1]);
>  				}
>
