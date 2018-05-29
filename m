Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58186 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751204AbeE2FST (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 01:18:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 13/14] rtlwifi: access skb->data to get C2H data by macro
References: <20180518093007.23594-1-pkshih@realtek.com>
        <20180518093007.23594-14-pkshih@realtek.com>
Date: Tue, 29 May 2018 08:18:14 +0300
In-Reply-To: <20180518093007.23594-14-pkshih@realtek.com>
        (pkshih@realtek.com's message of "Fri, 18 May 2018 17:30:06 +0800")
Message-ID: <87po1fhwfd.fsf@purkki.adurom.net> (sfid-20180529_071823_869854_463FF633)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<pkshih@realtek.com> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> The format of C2H data is ID(1 byte) + Length(1 byte) + value, and it is
> more readable to use macros to access C2H data.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

[...]

> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -177,6 +177,11 @@ enum rtl_c2h_evt_v2 {
>  	C2H_V2_CCX_RPT = 0x0F,
>  };
>  
> +#define GET_C2H_CMD_ID(c2h)	({u8 *__c2h = c2h; __c2h[0]; })
> +#define GET_C2H_SEQ(c2h)	({u8 *__c2h = c2h; __c2h[1]; })
> +#define C2H_DATA_OFFSET		2
> +#define GET_C2H_DATA_PTR(c2h)	({u8 *__c2h = c2h; &__c2h[C2H_DATA_OFFSET]; })

These macros are not really pretty, a proper static inline function
would be a much better choise. But I'm planning to apply this patch
anyway, I don't think it's a blocker but a good idea to cleanup later.

And rtlwifi really should get away with this foo[0] and foo[1] style of
buffers and switch to proper structs (foo->bar and foo->koo).

-- 
Kalle Valo
