Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:62514 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab3A0WLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2013 17:11:54 -0500
Message-ID: <5105A627.5000208@lwfinger.net> (sfid-20130127_231158_565706_E9AB8DA2)
Date: Sun, 27 Jan 2013 16:11:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Potential problem in drivers/net/wireless/rtlwifi/usb.c:_rtl_rx_pre_process()
References: <20130127211811.GA6680@roeck-us.net>
In-Reply-To: <20130127211811.GA6680@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/2013 03:18 PM, Guenter Roeck wrote:
> Hi all,
>
> while browsing through 'warning: variable ‘...’ set but not used' warnings, I
> found the following code in drivers/net/wireless/rtlwifi/usb.c:_rtl_rx_pre_process().
>
> 	while (!skb_queue_empty(&rx_queue)) {
>          	_skb = skb_dequeue(&rx_queue);
> 		_rtl_usb_rx_process_agg(hw, skb);
> 		ieee80211_rx_irqsafe(hw, skb);
> 	}
>
> Question: Should the parameter to _rtl_usb_rx_process_agg() and
> ieee80211_rx_irqsafe() be '_skb' instead of 'skb' ?

I think you are right and I will submit a patch to fix this.

What compiler version reported this? I use "gcc (SUSE Linux) 4.7.2 20130108 
[gcc-4_7-branch revision 195012]" and I do not see this warning.

Thanks,

Larry


