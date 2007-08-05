Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:63964 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199AbXHEXIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 19:08:19 -0400
Message-ID: <46B65861.6050502@lwfinger.net>
Date: Sun, 05 Aug 2007 18:08:17 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Richard Jonsson <richie@coderworld.net>
CC: bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Port of bcm43xx from softmac to mac80211 is available for testing
References: <46B50B3C.7000906@lwfinger.net>	<200708052115.51758.richie@coderworld.net> <46B63D05.8040709@lwfinger.net>
In-Reply-To: <46B63D05.8040709@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Jonsson wrote:

> "rmmod bcm43xx" when kde is running hangs rmmod and prevents a clean shutdown. 
> I tried to find which program causes this while using bcm4301 driver, but so 
> far no luck. System shuts down fine if I don't try to rmmod first. rmmod 
> works fine from runlevel 3 aside from this message when inserting module 
> again:
> "net eth1: device_rename: sysfs_create_symlink failed (-17)"

I just got one of these during bootup, which prevented bcm43xx from starting correctly.

The logged sequence was:

kernel: bcm43xx-phy1: Broadcom 4311 WLAN found
kernel: ssb: Switching to IEEE 802.11 core, index 1
kernel: bcm43xx-phy1 debug: Found PHY: Analog 4, Type 2, Revision 8
kernel: bcm43xx-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
kernel: bcm43xx-phy1 debug: Radio turned off
kernel: wmaster0: Selected rate control algorithm 'simple'
ifup: Service network not started and mode 'auto' -> skipping
kernel: net eth1: device_rename: sysfs_create_symlink failed (-17)
ifup: Network interface is managed from NetworkManager
ifup: NetworkManager will be advised to set up eth1
ifup: but it cannot be assured from here.
kernel: bcm43xx-phy1 debug: Adding Interface type 2
kernel: ssb: Switching to PCI-E core, index 3
kernel: ssb: Switching to IEEE 802.11 core, index 1
kernel: bcm43xx-phy1: bcm43xx: Microcode bcm43xx_microcode5.fw3.fw loaded

The fix for this was to 'modprobe -r bcm43xx' followed by 'modprobe bcm43xx', which got everything 
started OK.

Larry
