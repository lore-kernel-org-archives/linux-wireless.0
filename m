Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:42302 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbbCJVmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 17:42:21 -0400
Received: by wesq59 with SMTP id q59so4845377wes.9
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2015 14:42:20 -0700 (PDT)
Received: from [192.168.1.21] ([92.45.170.19])
        by mx.google.com with ESMTPSA id hl8sm2593899wjb.38.2015.03.10.14.42.18
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 10 Mar 2015 14:42:18 -0700 (PDT)
From: Huseyin <revanthedarth@gmail.com>
Content-Type: text/plain; charset=windows-1252
Subject: Developing a new Driver
Message-Id: <8BC2636B-D1F0-431C-90F4-1290A4158DC2@gmail.com> (sfid-20150310_224224_691612_CFB5A05D)
Date: Tue, 10 Mar 2015 23:42:24 +0200
To: linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,

I want to develop a driver for my usb wireless adapter. The device name is AirTies Air 2410, codes are 0x1eda 0x2410. The company’s other usb wireless adapters (for example, AirTies Air 2310, 0x1eda 0x2310) were using ralink rt2800 driver, but this one doesn’t work with it.

I opened up the device’s case, I could only find out that the board was plotech e169497, 6 94v-0. I googled but these seem to be too vague and I cannot go any further with it. I couldn’t find any other text on the board.

I also contacted the company (AirTies) but they didn’t bother to reply. They provide drivers for windows only.

What should be the next step? Reverse-engineering the windows driver (I have no expertise on the subject, and little expertise on windows altogether) or trying to write a new driver using ralink or any other existing driver code? Is it a good idea to guess that the driver I’m going to develop will be similar to rt2800? This way I can make rt2800 recognize my device and try to find out what goes wrong (which, seems to me, would be meaningless if device is using a chipset not related to ralink), and change those parts.

I asked a little about the subject in the #kernelnewbies channel, people redirected me to this mail list.

When I make rt2800 driver recognize my device, this is what I get:

ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x1000 with error -110
ieee80211 phy0: rt2800_probe_rt: Error - Invalid RT chipset 0xffff, rev 8800 detected
ieee80211 phy0: rt2x00lib_probe_dev: Error - Failed to allocate device
usbcore: registered new interface driver rt2800usb

Thank You,
holgac