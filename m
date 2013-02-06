Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46612 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949Ab3BFXD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 18:03:29 -0500
Received: by mail-wi0-f177.google.com with SMTP id hm14so2197859wib.4
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 15:03:28 -0800 (PST)
Message-ID: <5112E139.6090701@gmail.com> (sfid-20130207_000334_203455_92E3ED66)
Date: Thu, 07 Feb 2013 00:03:21 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bugreport upstream: 0bda:819a RTL8188CUS WLAN doesn't work out
 of the box
References: <51045387.2040607@gmail.com> <5112A972.3060109@lwfinger.net>
In-Reply-To: <5112A972.3060109@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2013 08:05 PM, Larry Finger wrote:

> Please install the attached patch, and retry the above method. I fixed the probe function to get rid of the oops. If the device is really foreign, the process that writes new_id will not finish until
> the device is unplugged; however, the rest of the system is chugging along.

I tried the patch. And now, rtl8192cu doesn't break the kernel.

But it should go out when an unknown chip/rf is detected,
instead of trying to configure the unknown_device.

rtlwifi: reg 0xf0, usbctrl_vendorreq TimeOut! status:0xffffffe0 value=0x0
rtl8192cu: Chip version 0x10 <<<<<------WTF???
rtlwifi: reg 0xa, usbctrl_vendorreq TimeOut! status:0xffffffe0 value=0x0
rtlwifi: reg 0xfe66, usbctrl_vendorreq TimeOut! status:0xffffffe0 value=0x0
rtlwifi: reg 0xfe67, usbctrl_vendorreq TimeOut! status:0xffffffe0 value=0x0
rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1


Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
