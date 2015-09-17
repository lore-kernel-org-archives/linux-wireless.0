Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34431 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbbIQBny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 21:43:54 -0400
Received: by oiev17 with SMTP id v17so2204884oie.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 18:43:53 -0700 (PDT)
Subject: Re: [PATCH RFC] rtlwifi: rtl8192cu: Add missing case in
 rtl92cu_get_hw_reg
To: Priit Laes <plaes@plaes.org>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	Taehee Yoo <ap420073@gmail.com>
References: <1442296916-24336-1-git-send-email-plaes@plaes.org>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55FA1AD6.9000105@lwfinger.net> (sfid-20150917_034357_477659_524275A8)
Date: Wed, 16 Sep 2015 20:43:50 -0500
MIME-Version: 1.0
In-Reply-To: <1442296916-24336-1-git-send-email-plaes@plaes.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2015 01:01 AM, Priit Laes wrote:
> Driver was reporting 'switch case not processed' after association,
> so HW_VAR_KEEP_ALIVE was added and filled similarily to other drivers.
>
> Positive side effect to this seems to be a bit more stable connection.
>
> Signed-off-by: Priit Laes <plaes@plaes.org>
> ---

This patch looks good to me. Thanks.

Cc: Stable <stable@vger.kernel.org> 3.4+
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index 25db369..34ce064 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -1946,6 +1946,14 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   		rtl_write_word(rtlpriv, REG_RXFLTMAP2, *(u16 *)val);
>   		mac->rx_data_filter = *(u16 *)val;
>   		break;
> +	case HW_VAR_KEEP_ALIVE:{
> +			u8 array[2];
> +			array[0] = 0xff;
> +			array[1] = *((u8 *)val);
> +			rtl92c_fill_h2c_cmd(hw, H2C_92C_KEEP_ALIVE_CTRL, 2,
> +					    array);
> +			break;
> +		}
>   	default:
>   		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
>   			 "switch case not processed\n");
>

