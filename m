Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.active-venture.com ([67.228.131.205]:56359 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab3A0Xvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2013 18:51:45 -0500
Date: Sun, 27 Jan 2013 15:52:03 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Potential problem in
 drivers/net/wireless/rtlwifi/usb.c:_rtl_rx_pre_process()
Message-ID: <20130127235203.GA24524@roeck-us.net> (sfid-20130128_005150_358392_7D15FA74)
References: <20130127211811.GA6680@roeck-us.net>
 <5105A627.5000208@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5105A627.5000208@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 27, 2013 at 04:11:51PM -0600, Larry Finger wrote:
> On 01/27/2013 03:18 PM, Guenter Roeck wrote:
> >Hi all,
> >
> >while browsing through 'warning: variable ‘...’ set but not used' warnings, I
> >found the following code in drivers/net/wireless/rtlwifi/usb.c:_rtl_rx_pre_process().
> >
> >	while (!skb_queue_empty(&rx_queue)) {
> >         	_skb = skb_dequeue(&rx_queue);
> >		_rtl_usb_rx_process_agg(hw, skb);
> >		ieee80211_rx_irqsafe(hw, skb);
> >	}
> >
> >Question: Should the parameter to _rtl_usb_rx_process_agg() and
> >ieee80211_rx_irqsafe() be '_skb' instead of 'skb' ?
> 
> I think you are right and I will submit a patch to fix this.
> 
> What compiler version reported this? I use "gcc (SUSE Linux) 4.7.2
> 20130108 [gcc-4_7-branch revision 195012]" and I do not see this
> warning.
> 
Hi Larry,

I use "gcc (Ubuntu/Linaro 4.7.2-2ubuntu1) 4.7.2".

You'll see the warning if you build the kernel with W=1.

Guenter
