Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3539 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbZJZNRB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 09:17:01 -0400
Received: from webmail.xs4all.nl (dovemail11.xs4all.nl [194.109.26.13])
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id n9QDH2SI028203
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 14:17:03 +0100 (CET)
	(envelope-from evaessen@xs4all.nl)
Message-ID: <e14196febc59d9ca25868fec63816139.squirrel@webmail.xs4all.nl>
In-Reply-To: <4AE1FE7F.2090309@gmail.com>
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
    <20090831175932.GC5631@tuxdriver.com>
    <b88bb1ad0909121654w43215f60lf9d7b90d4b54bf35@mail.gmail.com>
    <4AE1FE7F.2090309@gmail.com>
Date: Mon, 26 Oct 2009 14:17:02 +0100
Subject: Only device wlan1 but no connection Fritz!WLAN USB stick N2.4
From: "Ed Vaessen" <evaessen@xs4all.nl>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a Fritz!Box Fon WLAN 7170 as router and try to connect wireless to
it with the Fritz!WLAN USB N2.4 stick using the compat-wireless software.
Without succes so far.

Software: yesterdays bleeding edge tarball: compat-wireless-2.6.tar.bz2
Kernel: Ubuntu 9.04 2.6.28-16-generic
PC: Athec L51A10
Firmware: ar9170.fw put in /lib/firmware

The software compiles without problem and installs the driver after reboot:

sudo lsmod | grep 9170 gives:
ar9170usb 63624 0
led_class 12036 1 ar9170usb
ath 17024 1 ar9170usb
mac80211 218160 1 ar9170usb
cfg80211 135240 3 ar9170usb,ath,mac80211

After inserting the usb stick, this is shown in /var/log/messages

Oct 25 15:37:00 vaessen-laptop kernel: [ 301.480049] usb 1-1: new high
speed USB device using ehci_hcd and address 5
Oct 25 15:37:00 vaessen-laptop kernel: [ 301.643507] usb 1-1:
configuration #1 chosen from 1 choice
Oct 25 15:37:00 vaessen-laptop kernel: [ 301.702461] Initializing USB Mass
Storage driver...
Oct 25 15:37:00 vaessen-laptop kernel: [ 301.702650] scsi4 : SCSI
emulation for USB Mass Storage devices
Oct 25 15:37:00 vaessen-laptop kernel: [ 301.702803] usbcore: registered
new interface driver usb-storage
Oct 25 15:37:00 vaessen-laptop kernel: [ 301.702808] USB Mass Storage
support registered.
Oct 25 15:37:05 vaessen-laptop kernel: [ 306.709252] scsi 4:0:0:0: CD-ROM
FRITZ! WLAN selfinstall 1.00 PQ: 0 ANSI: 0 CCS
Oct 25 15:37:05 vaessen-laptop kernel: [ 306.722276] sr1: scsi3-mmc drive:
52x/52x cd/rw xa/form2 cdda tray
Oct 25 15:37:05 vaessen-laptop kernel: [ 306.723067] sr 4:0:0:0: Attached
scsi generic sg2 type 5

Oct 25 15:38:38 vaessen-laptop kernel: [ 399.349605] usb 1-1: USB
disconnect, address 5
Oct 25 15:38:39 vaessen-laptop kernel: [ 400.608057] usb 1-1: new high
speed USB device using ehci_hcd and address 6
Oct 25 15:38:39 vaessen-laptop kernel: [ 400.771795] usb 1-1:
configuration #1 chosen from 1 choice
Oct 25 15:38:39 vaessen-laptop kernel: [ 400.888063] usb 1-1: reset high
speed USB device using ehci_hcd and address 6
Oct 25 15:38:40 vaessen-laptop kernel: [ 402.044043] usb 1-1: firmware:
requesting ar9170.fw
Oct 25 15:38:41 vaessen-laptop kernel: [ 402.465806] Registered led
device: ar9170-phy1::tx
Oct 25 15:38:41 vaessen-laptop kernel: [ 402.465846] Registered led
device: ar9170-phy1::assoc
Oct 25 15:38:41 vaessen-laptop kernel: [ 402.465851] usb 1-1: Atheros
AR9170 is registered as 'phy1'
Oct 25 15:38:41 vaessen-laptop kernel: [ 402.471136] udev: renamed network
interface wlan0 to wlan1

It seems the firmware is installed.
Command iwconfig:

lo no wireless extensions.

eth0 no wireless extensions.

pan0 no wireless extensions.

wlan1 IEEE 802.11bg Mode:Managed Access Point: Not-Associated
Tx-Power=0 dBm
Retry long limit:7 RTS thrff Fragment thrff
Power Managementff

Command sudo lshw -C network gives for the wireless this information:

*-network:1 DISABLED
description: Wireless interface
physical id: 2
bus info: usb@1:1
logical name: wlan1
serial: 00:1f:3f:09:2d:40
capabilities: ethernet physical wireless
configuration: broadcast=yes driver=ar9170usb
driverversion=2.6.28-16-generic firmware=N/A link=yes multicast=yes
wireless=IEEE 802.11bg

This 'firmware=N/A' puzzles me.

I used System->Administration->Network Tools but cannot ping the Fritz!Box
router
The interface information says that wireless interface wlan1 is inactive.

How do I make it active?


