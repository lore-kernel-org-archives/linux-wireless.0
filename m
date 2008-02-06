Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ascomax.hasler.ascom.ch ([139.79.135.1]:33442 "EHLO
	ascomax.hasler.ascom.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760036AbYBFKEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 05:04:32 -0500
Received: from eiger.ma.tech.ascom.ch (eiger.ma.tech.ascom.ch [139.79.100.1])
	by ascomax.hasler.ascom.ch (8.14.1/8.14.1) with ESMTP id m169x9dF012308
	for <linux-wireless@vger.kernel.org>; Wed, 6 Feb 2008 10:59:10 +0100 (MET)
Received: from [139.79.100.143] (helo=donkey.ma.tech.ascom.ch)
	by eiger.ma.tech.ascom.ch with esmtp (Exim 3.16 #1)
	id 1JMh3c-0003ea-00
	for linux-wireless@vger.kernel.org; Wed, 06 Feb 2008 10:59:08 +0100
Received: from lunn by donkey.ma.tech.ascom.ch with local (Exim 3.36 #1 (Debian))
	id 1JMh3c-00055R-00
	for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2008 10:59:08 +0100
Date: Wed, 6 Feb 2008 10:59:08 +0100
From: Andrew Lunn <andrew.lunn@ascom.ch>
To: linux-wireless@vger.kernel.org
Subject: B43 not seeing MadWifi AP
Message-ID: <20080206095908.GU25912@donkey.ma.tech.ascom.ch> (sfid-20080206_100438_305302_EB2FFDB2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Folks

I have a number of Linux laptops running kernel 2.6.23.9, and
compat-wireless-2.6 with what git-describe says is
v2.6.24-rc7-716-g62ec51e and i am using the b43 driver with a BCM4312
device.

I also have some laptop with Atheros PCCard devices and the Madwifi
driver from SVN, version r3318.

The Madwifi device is running as an AP. The problem i have is that the
b43 does not see it. iwlist wlan0 scan does not see this madwifi
AP. It does see other APs, but not my madwifi driver. Other madwifi
devices see the AP. Also an ipw2200 device sees the AP. So i know the
AP is running, sending beacons, etc. It just seems that the b43 does
not like it. 

iwlist ath0 scan lists the "missing" AP as:

   Cell 04 - Address: 06:03:7F:03:42:0B
             ESSID:"TOWN-SSID"
             Mode:Master
             Frequency:2.442 GHz (Channel 7)
             Quality=49/70  Signal level=-46 dBm  Noise level=-95 dBm
             Encryption key:off
             Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 6 Mb/s; 9 Mb/s
                       11 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                       48 Mb/s; 54 Mb/s
             Extra:bcn_int=100
             Extra:wme_ie=dd180050f2020101830002a4400027a4000042435e0062322f00
             Extra:ath_ie=dd0900037f01010034ff7f

Is the b43 picky about Extra things in the beacon? 

At the beginning of ieee80211_rx_bss_info() there is some commented
out printk for all received beacons and probe responses. I enabled
this and don't see anything for the missing device. So it looks like
the problem is lower down the stack. However i don't see any obvious
place were it would be discarding beacons.

Anybody got any ideas?

        Thanks
                Andrew
