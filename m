Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:37390 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbbBYSdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 13:33:37 -0500
Received: by mail-ob0-f181.google.com with SMTP id vb8so5704344obc.12
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 10:33:36 -0800 (PST)
Message-ID: <54EE157D.3050101@lwfinger.net> (sfid-20150225_193341_651394_9D44FCCC)
Date: Wed, 25 Feb 2015 12:33:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Add case in rtl92cu_get_hw_reg
References: <1424887133-5670-1-git-send-email-ap420073@gmail.com>
In-Reply-To: <1424887133-5670-1-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2015 11:58 AM, Taehee Yoo wrote:
> rtl_op_stop get wowlan state but rtl92cu_get_hw_reg has not process.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Has this been tested? I am not aware that the RTL8192CU firmware could handle 
WOWLAN.

Larry

> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index fe4b699..f6ad959 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -1589,6 +1589,12 @@ void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   	case HW_VAR_DATA_FILTER:
>   		*((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP2);
>   		break;
> +	case HAL_DEF_WOWLAN:
> +		if (ppsc->wo_wlan_mode)
> +			*((bool *)(val)) = true;
> +		else
> +			*((bool *)(val)) = false;
> +		break;
>   	default:
>   		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
>   			 "switch case not processed\n");
>

