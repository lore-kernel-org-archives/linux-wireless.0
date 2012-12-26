Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63871 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2LZVPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2012 16:15:24 -0500
Message-ID: <50DB68E8.2010506@lwfinger.net> (sfid-20121226_221548_045896_3E8A9E05)
Date: Wed, 26 Dec 2012 15:15:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, wlanfae <wlanfae@realtek.com>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH] rtlwifi: Don't leak on error in _rtl_usb_receive()
References: <alpine.LNX.2.00.1212262145220.23814@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1212262145220.23814@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/26/2012 02:51 PM, Jesper Juhl wrote:
> We fail to release 'urb' if '_rtl_prep_rx_urb()' fails in
> _rtl_usb_receive().
> This patch should take care of the leak.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>   drivers/net/wireless/rtlwifi/usb.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
>   note: compile tested only.

This looks correct to me. I have never seen that RT_TRACE() fire, thus such an 
error must be uncommon, at least on my system.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
> index 29f0969..75c29e6 100644
> --- a/drivers/net/wireless/rtlwifi/usb.c
> +++ b/drivers/net/wireless/rtlwifi/usb.c
> @@ -640,6 +640,7 @@ static int _rtl_usb_receive(struct ieee80211_hw *hw)
>   			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
>   				 "Failed to prep_rx_urb!!\n");
>   			err = PTR_ERR(skb);
> +			usb_free_urb(urb);
>   			goto err_out;
>   		}
>
>

