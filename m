Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:61814 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbbBYQeK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 11:34:10 -0500
Message-ID: <54EDF97E.3060507@lwfinger.net> (sfid-20150225_173416_408850_C66EB074)
Date: Wed, 25 Feb 2015 10:34:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] rtlwifi: rtl8188ee: missing curly braces in handle_branch1()
References: <20150225132451.GL19745@mwanda>
In-Reply-To: <20150225132451.GL19745@mwanda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2015 07:24 AM, Dan Carpenter wrote:
>>From the indenting, it seems like the READ_NEXT_PAIR() was supposed to
> be inside the while loop.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Good catch.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
> index 3f6c59c..a2bb02c 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
> @@ -452,9 +452,10 @@ static void handle_branch1(struct ieee80211_hw *hw, u16 arraylen,
>   				READ_NEXT_PAIR(v1, v2, i);
>   				while (v2 != 0xDEAD &&
>   				       v2 != 0xCDEF &&
> -				       v2 != 0xCDCD && i < arraylen - 2)
> +				       v2 != 0xCDCD && i < arraylen - 2) {
>   					_rtl8188e_config_bb_reg(hw, v1, v2);
>   					READ_NEXT_PAIR(v1, v2, i);
> +				}
>
>   				while (v2 != 0xDEAD && i < arraylen - 2)
>   					READ_NEXT_PAIR(v1, v2, i);
>

