Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:55569 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2D3NKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 09:10:35 -0400
Message-ID: <4F9E8F49.3080700@mlbassoc.com> (sfid-20120430_151039_705720_66D12F4C)
Date: Mon, 30 Apr 2012 07:10:33 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: Luciano Coelho <coelho@ti.com>
Subject: wl1271 woes continue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano,

I'm still having troubles with the WL1271.  I now have a
brand new platform - same basic design as before but with
a DM3730 instead of the DM8148.  I've tried a couple of
off-the-shelf kernels (3.0.0 and 3.3.0) with it, with mixed
results.

With 3.3.0 I could not get the device to associate with the AP.
It would get started and then the wl1271 stopped talking and
the process failed.

With 3.0.0, I can get it to work reasonably well.  However, I
still have to go through the manual steps to get it to associate.
Anything other than the process below causes the wl1271 to reset
and die...  I also cannot shut the device down and restart it.
Attempts at a restart cause the wl1271 to lock up and I have to
reboot to recover.

Only these steps work for the initial association:
   # ifconfig wlan0 hw ether 0:1:2:3:4:5
   # ifconfig wlan0 up
   # iw wlan0 scan
   # ifup wlan0
Note: my AP is using WPA2 so I'm also running wpa_supplicant

I'm going to try using the latest compat-wireless, using the
3.0.0 kernel as overall it is more stable on this platform.
I also plan to experiment a bit with the Panda (OMAP4) as it
has the same peripherals (and I assume that it works?)

What can I do to make this work better?
What data need I provide to help diagnose the failures?

Thanks for your time

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
