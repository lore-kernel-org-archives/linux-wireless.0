Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38195 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab0EFPQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 11:16:58 -0400
Received: from localhost (localhost [127.0.0.1])
	by borg.medozas.de (Postfix) with ESMTP id 9829D2249
	for <linux-wireless@vger.kernel.org>; Thu,  6 May 2010 17:16:55 +0200 (CEST)
Date: Thu, 6 May 2010 17:16:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: linux-wireless@vger.kernel.org
Subject: b43: force_pio must be set in your kernel conf
Message-ID: <alpine.LSU.2.01.1005061707140.32387@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


I have here some typical windowscentric Dell laptop with a b43 chipset 
that refuses to work due to something with DMA.

lspci:
08:00.0 Network controller: Broadcom Corporation BCM4312 802.11b/g (rev 
01)
08:00.0 0280: 14e4:4315 (rev 01)

I installed the firmware using one of opensuse's scripts 
(install_bcm43xx_firmware, though it handles b43 and b43legacy according 
to the script's inner comments), which retrieves

wl_apsta_mimo.o from 
mirror2.openwrt.org/sources/broadcom-wl-4.150.10.5.tar.bz2

and runs fwcutter on it. In dmesg, I then find on modprobe b43 
verbose=3:

b43 ssb0:0: firmware: requesting b43/ucode15.fw
b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
b43-phy0 debug: Chip initialized
b43-phy0 debug: 64-bit DMA initialized
b43-phy0 debug: QoS enabled
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2
b43-phy0 ERROR: Fatal DMA error: 0x400, 0x0, 0x0, 0x0, 0x0, 0x0
b43-phy0 ERROR: This device does not support DMA on your system. Please 
use PIO instead.
b43-phy0 ERROR: CONFIG_B43_FORCE_PIO must be set in your kernel 
configuration.
ADDRCONF(NETDEV_UP): wlan0: link is not ready


So, can I get PIO mode for free without recompiling? (Since 
CONFIG_B43_PIO=y already.) What other info needs to be provided to help 
resolve this?

System is a 2.6.33.2-x86_64.


thanks,
Jan
