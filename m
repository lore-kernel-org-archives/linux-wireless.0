Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.active-venture.com ([67.228.131.205]:52923 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3A0VRy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2013 16:17:54 -0500
Date: Sun, 27 Jan 2013 13:18:11 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Potential problem in
 drivers/net/wireless/rtlwifi/usb.c:_rtl_rx_pre_process()
Message-ID: <20130127211811.GA6680@roeck-us.net> (sfid-20130127_221903_784954_C8FE0C73)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

while browsing through 'warning: variable ‘...’ set but not used' warnings, I
found the following code in drivers/net/wireless/rtlwifi/usb.c:_rtl_rx_pre_process().

	while (!skb_queue_empty(&rx_queue)) {
        	_skb = skb_dequeue(&rx_queue);
		_rtl_usb_rx_process_agg(hw, skb);
		ieee80211_rx_irqsafe(hw, skb);
	}

Question: Should the parameter to _rtl_usb_rx_process_agg() and
ieee80211_rx_irqsafe() be '_skb' instead of 'skb' ?

Thanks,
Guenter
