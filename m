Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36343 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbcHKVfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 17:35:54 -0400
Subject: Re: [PATCH 16/16] net: wireless: realtek: rtlwifi: usb: don't print
 error when allocating urb fails
To: Wolfram Sang <wsa-dev@sang-engineering.com>,
	linux-usb@vger.kernel.org
References: <1470949539-25392-1-git-send-email-wsa-dev@sang-engineering.com>
 <1470949988-25705-1-git-send-email-wsa-dev@sang-engineering.com>
 <1470949988-25705-4-git-send-email-wsa-dev@sang-engineering.com>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <47932679-21ea-18ba-d918-715dc2fe5e96@lwfinger.net> (sfid-20160811_233600_076485_A3FCCDF0)
Date: Thu, 11 Aug 2016 16:35:51 -0500
MIME-Version: 1.0
In-Reply-To: <1470949988-25705-4-git-send-email-wsa-dev@sang-engineering.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2016 04:13 PM, Wolfram Sang wrote:
> kmalloc will print enough information in case of failure.
>
> Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/usb.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
> index 41617b7b082260..32aa5c1d070a07 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/usb.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
> @@ -739,11 +739,8 @@ static int _rtl_usb_receive(struct ieee80211_hw *hw)
>  	for (i = 0; i < rtlusb->rx_urb_num; i++) {
>  		err = -ENOMEM;
>  		urb = usb_alloc_urb(0, GFP_KERNEL);
> -		if (!urb) {
> -			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
> -				 "Failed to alloc URB!!\n");
> +		if (!urb)
>  			goto err_out;
> -		}
>
>  		err = _rtl_prep_rx_urb(hw, rtlusb, urb, GFP_KERNEL);
>  		if (err < 0) {
> @@ -907,15 +904,12 @@ static void _rtl_tx_complete(struct urb *urb)
>  static struct urb *_rtl_usb_tx_urb_setup(struct ieee80211_hw *hw,
>  				struct sk_buff *skb, u32 ep_num)
>  {
> -	struct rtl_priv *rtlpriv = rtl_priv(hw);
>  	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
>  	struct urb *_urb;
>
>  	WARN_ON(NULL == skb);
>  	_urb = usb_alloc_urb(0, GFP_ATOMIC);
>  	if (!_urb) {
> -		RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
> -			 "Can't allocate URB for bulk out!\n");
>  		kfree_skb(skb);
>  		return NULL;
>  	}
>

