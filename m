Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:52474 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbXI1UKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 16:10:37 -0400
Received: by nf-out-0910.google.com with SMTP id g13so2621959nfb
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2007 13:10:35 -0700 (PDT)
Message-ID: <aa73b9a0709281310w6030e0f5g4e3195cf800b5e7d@mail.gmail.com>
Date: Fri, 28 Sep 2007 15:10:34 -0500
From: "John Pierce" <john.j35@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Belkin Wireless G USB
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I just purchased a belkin wireless g usb adapter and am not having any
luck getting it to work.

The following is the output from various commands, if more info is
needed then I will post it back.

Distro: Fedora 7
Kernel: 2.6.22.4-65.fc7

I have created a ifcfg-wlan0 file in /etc/sysconfig/network-scripts
with the following:

GATEWAY=192.168.1.1
TYPE=Wireless
DEVICE=wlan0
BOOTPROTO=static
NETMASK=255.255.255.0
IPADDR=192.168.1.60
ONBOOT=yes
USERCTL=yes
IPV6INIT=no
PEERDNS=yes
ESSID=thedungeon
CHANNEL=11
MODE=Managed
RATE=Auto
SECURITYMODE=open

I have a keys-wlan0 file in that same directory with the wep key for my router.

I set up a file named zd1211 in the /etc/modprobe.d/ directory with
the following in it.

alias wlan0 zd1211rw_mac80211

This is the output of dmesg immediately after inserting the usb adapter.

usb 2-2: new high speed USB device using ehci_hcd and address 7
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: reset high speed USB device using ehci_hcd and address 7
wmaster0: Failed to select rate control algorithm
wmaster0: Failed to initialize rate control algorithm
usb 2-2: reset high speed USB device using ehci_hcd and address 7
zd1211rw_mac80211: probe of 2-2:1.0 failed with error -2
usbcore: registered new interface driver zd1211rw_mac80211

This is the output of lsusb after inserting the adapter.

Bus 002 Device 007: ID 050d:705c Belkin Components
Bus 002 Device 001: ID 0000:0000
Bus 001 Device 002: ID 15d9:0a33
Bus 001 Device 001: ID 0000:0000

When I try the run ifup wlan0 this is the output.

zd1211rw_mac80211 device wlan0 does not seem to be present, delaying
initialization.

Every thing I have read indicates that this device is supported in
linux, including the vendor and device id.

Any thoughts or suggestions would be appreciated.

-- 
John
Registered Linux User 263680, get counted at
http://counter.li.org
