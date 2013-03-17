Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:43879 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab3CQRQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 13:16:51 -0400
Received: by mail-qc0-f177.google.com with SMTP id u28so2355638qcs.22
        for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2013 10:16:50 -0700 (PDT)
Message-ID: <5145FA80.7040209@lwfinger.net> (sfid-20130317_181708_764187_20AB4C5F)
Date: Sun, 17 Mar 2013 12:16:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
CC: linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rtlwifi: usb: add missing freeing of skbuff
References: <20130317095404.23346.42853.stgit@localhost6.localdomain6>
In-Reply-To: <20130317095404.23346.42853.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/17/2013 04:54 AM, Jussi Kivilinna wrote:
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> ---
>   drivers/net/wireless/rtlwifi/usb.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
> index b5c80b5..41dce83 100644
> --- a/drivers/net/wireless/rtlwifi/usb.c
> +++ b/drivers/net/wireless/rtlwifi/usb.c
> @@ -850,6 +850,7 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
>   	if (unlikely(!_urb)) {
>   		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
>   			 "Can't allocate urb. Drop skb!\n");
> +		kfree_skb(skb);
>   		return;
>   	}
>   	_rtl_submit_tx_urb(hw, _urb);
>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

John - Add Stable as Cc.

Good catch. Thanks,

Larry


