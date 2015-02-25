Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:45581 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbbBYUXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 15:23:44 -0500
Received: by mail-ob0-f180.google.com with SMTP id vb8so6400756obc.11
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 12:23:43 -0800 (PST)
Message-ID: <54EE2F4D.6080609@lwfinger.net> (sfid-20150225_212401_429347_F945B07F)
Date: Wed, 25 Feb 2015 14:23:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Add case in rtl92cu_get_hw_reg
References: <1424892841-6446-1-git-send-email-ap420073@gmail.com>
In-Reply-To: <1424892841-6446-1-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2015 01:34 PM, Taehee Yoo wrote:
> Add HAL_DEF_WOWLAN case in rtl92cu_get_hw_reg
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

@Kalle: This is V2. V1 is not OK.

Larry

> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index fe4b699..96bae39 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -1589,6 +1589,8 @@ void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   	case HW_VAR_DATA_FILTER:
>   		*((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP2);
>   		break;
> +	case HAL_DEF_WOWLAN:
> +		break;
>   	default:
>   		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
>   			 "switch case not processed\n");
>

