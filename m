Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lucidpixels.com ([72.73.18.11]:34272 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569Ab1HCTxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 15:53:52 -0400
Date: Wed, 3 Aug 2011 15:53:51 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: Linux Wireless USB-Stick Question
Message-ID: <alpine.DEB.2.02.1108031550100.4278@p34.internal.lan> (sfid-20110803_215357_351476_08F6A2CE)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Under Windows, you can achieve 10-15MiB/s..

Under Linux, even with 150mbps USB wireless adapters, the max never 
appears to go above > 3-4MiB/s, to work around this, order more 
USB-wifi ticks and run them in parallel far away from each other with USB
extenders:

box1:
-------------
wlan0     IEEE 802.11bg  ESSID:"hidden"
           Bit Rate=54 Mb/s   Tx-Power=20 dBm
wlan1     IEEE 802.11bgn  ESSID:"hidden"
           Bit Rate=58.5 Mb/s   Tx-Power=20 dBm
wlan2     IEEE 802.11bgn  ESSID:"hidden"
           Bit Rate=39 Mb/s   Tx-Power=20 dBm

box2:
-------------
wlan0     IEEE 802.11bgn  ESSID:"hidden"
           Bit Rate=58.5 Mb/s   Tx-Power=20 dBm
wlan1     IEEE 802.11bgn  ESSID:"hidden"
           Bit Rate=52 Mb/s   Tx-Power=20 dBm
wlan2     IEEE 802.11bgn  ESSID:"hidden"
           Bit Rate=52 Mb/s   Tx-Power=20 dBm

But I was curious if anyone had achieved > 10 MiB/s with any wireless 
adapter with Linux?

Also, those native Linux USB adapters (carl) work good, so far.
With the patch provided earlier for the rt2800usb driver, it is no longer 
crashing under 3.0 so I put two of them on a single box plus a carl based 
one, now I get better I/O, e.g. 4MiB/s x 6 = 24MiB/s.

Justin.
