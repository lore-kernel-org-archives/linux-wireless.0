Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:44545 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbbCIPkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 11:40:23 -0400
Received: by oifu20 with SMTP id u20so30006106oif.11
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 08:40:23 -0700 (PDT)
Message-ID: <54FDBEE4.8090706@lwfinger.net> (sfid-20150309_164026_657630_F06E1787)
Date: Mon, 09 Mar 2015 10:40:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Remove unnecessary parameter
References: <1425913628-6415-1-git-send-email-ap420073@gmail.com>
In-Reply-To: <1425913628-6415-1-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/09/2015 10:07 AM, Taehee Yoo wrote:
> Remove unnecessary parameter in rtl8192cu/hw.c
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)

The patch is OK, but the subject is awful. When I first saw it, I thought that 
you were removing a module parameter. On inspection, I see that you are removing 
function arguments from _beacon_function_enable(). Why not say that?

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index 0c20dd7..43b2b20 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -1471,8 +1471,7 @@ static void _InitBeaconParameters(struct ieee80211_hw *hw)
>   		rtl_write_word(rtlpriv, REG_BCNTCFG, 0x66FF);
>   }
>
> -static void _beacon_function_enable(struct ieee80211_hw *hw, bool Enable,
> -				    bool Linked)
> +static void _beacon_function_enable(struct ieee80211_hw *hw)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>
> @@ -1517,7 +1516,7 @@ void rtl92cu_set_beacon_related_registers(struct ieee80211_hw *hw)
>   		rtl_write_byte(rtlpriv, REG_RXTSF_OFFSET_CCK, 0x50);
>   		rtl_write_byte(rtlpriv, REG_RXTSF_OFFSET_OFDM, 0x50);
>   	}
> -	_beacon_function_enable(hw, true, true);
> +	_beacon_function_enable(hw);
>   }
>
>   void rtl92cu_set_beacon_interval(struct ieee80211_hw *hw)
>

