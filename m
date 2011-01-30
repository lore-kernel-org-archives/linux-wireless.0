Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:43287 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab1A3Mq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:46:58 -0500
Message-ID: <4D455DC1.6010909@pardus.org.tr>
Date: Sun, 30 Jan 2011 14:46:57 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Rfkill always soft/hard blocked upon boot
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

How to fix or debug the $subject? You always have to press Fn+F2 to hard 
unblock the rfkill after every boot on a local brand laptop.

If the rfkill switch is really a switch which can be toggled on/off, 
this makes sense. If you keep it Off, it will come as blocked. But it 
seems that on this machine Fn+F2 controls the hard block state.

It should either be saved in somewhere (I've read that there is a 
persistent knob for rfkill drivers in sysfs which tells whether the 
state is kept in a non-volatile space across boots or not) or all soft 
and this kind of Fn+Fx hard blocks should be explicitly disabled by 
kernel during boots.

I don't have direct access to the machine but the owner will help if you 
need any output, etc.

After booting:

0: hci0: Bluetooth
         Soft blocked: no
         Hard blocked: no
1: phy0: Wireless LAN
         Soft blocked: no
         Hard blocked: yes

After pressing Fn+F2:
0: phy0: Wireless LAN
         Soft blocked: no
         Hard blocked: no
1: hci0: Bluetooth
         Soft blocked: no
         Hard blocked: no

03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless 
Network Adapter (PCI-Express) (rev 01)
         Subsystem: Device 1a3b:1089
         Flags: bus master, fast devsel, latency 0, IRQ 17
         Memory at f1d00000 (64-bit, non-prefetchable) [size=64K]
         Capabilities: [40] Power Management version 3
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
         Capabilities: [60] Express Legacy Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Virtual Channel
         Capabilities: [160] Device Serial Number 00-15-17-ff-ff-24-14-12
         Capabilities: [170] Power Budgeting <?>
         Kernel driver in use: ath9k
         Kernel modules: ath9k

This is on 2.6.37. I'm waiting for the dmesg output.

-- 
Pardus Linux
http://www.pardus.org.tr/eng
