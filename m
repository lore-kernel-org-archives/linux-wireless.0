Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.esisar.inpg.fr ([195.220.37.33]:40154 "EHLO
	mx1.esisar.inpg.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab0DLLv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 07:51:56 -0400
Message-ID: <4BC30511.9090207@esisar.grenoble-inp.fr>
Date: Mon, 12 Apr 2010 13:33:37 +0200
From: =?ISO-8859-1?Q?WATY_S=E9bastien?= <pi16-03@esisar.grenoble-inp.fr>
Reply-To: PI2010-16@esisar.grenoble-inp.fr
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-wireless@vger.kernel.org
Subject: AR9170 Wifi USB module driver on powerpc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm trying to use a USB Wifi module on a linux 2.6.33 kernel using 
powerpc architecture. The Wifi module is a UNEX DNUA-81 based on an 
AR9170 from Atheros.

My problem is that the firmware provided by Atheros can't get uploaded 
into the device.

I have tested the same driver and firmware on an X86 platform, it works 
fine.

Please find at the end of the message, an extract of what dmesg after 
plugging the device.

For what I understand, the driver wants to use the ep_00 device to 
transmit the firmware, but this device isn't initialized when it try to 
begin the transfer. Is this correct ?
Any idea on how to solve this ?

Regards Sebastien

---------------------------------------
usb 1-1.2: New USB device found, idVendor=0cf3, idProduct=9170
usb 1-1.2: New USB device strings: Mfr=16, Product=32, SerialNumber=48
usb 1-1.2: Product: USB2.0 WLAN
usb 1-1.2: Manufacturer: ATHER
usb 1-1.2: SerialNumber: 12345
device: '1-1.2': device_add
bus: 'usb': add device 1-1.2
usb 1-1.2: uevent
bus: 'usb': driver_probe_device: matched device 1-1.2 with driver usb
bus: 'usb': really_probe: probing driver usb with device 1-1.2
usb 1-1.2: usb_probe_device
usb 1-1.2: configuration #1 chosen from 1 choice
usb 1-1.2: adding 1-1.2:1.0 (config #1, interface 0)
device: '1-1.2:1.0': device_add
bus: 'usb': add device 1-1.2:1.0
usb 1-1.2:1.0: uevent
bus: 'usb': driver_probe_device: matched device 1-1.2:1.0 with driver 
ar9170usb
bus: 'usb': really_probe: probing driver ar9170usb with device 1-1.2:1.0
ar9170usb 1-1.2:1.0: usb_probe_interface

ar9170usb 1-1.2:1.0: usb_probe_interface - got id
usb 1-1.2: reset high speed USB device using xilinx-of-ehci and address 4
usb 1-1.2: firmware: using built-in firmware ar9170.fw
usb 1-1.2: link qh0-00ff/cf0e8120 start 0 [2/0 us]
usb 1-1.2: khubd timed out on ep0out len=0/4096
usb 1-1.2: device is in a bad state. please reconnect it!
usb 1-1.2: stuck tx urbs!
usb 1-1.2: unlink qh0-00ff/cf0e8120 start 0 [2/0 us]
ar9170usb: probe of 1-1.2:1.0 failed with error -110
device: 'ep_01': device_add
device: 'ep_82': device_add
device: 'ep_83': device_add
device: 'ep_04': device_add
device: 'usbdev1.4': device_add
drivers/usb/core/inode.c: creating file '004'
driver: '1-1.2': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device 1-1.2 to driver usb
device: 'ep_00': device_add

hub 1-1:1.0: state 7 ports 4 chg 0000 evt 0004
usb 1-1.2: usb_disable_device nuking non-ep0 URBs
usb 1-1.2: unregistering interface 1-1.2:1.0
device: 'ep_01': device_unregister
device: 'ep_82': device_unregister
device: 'ep_83': device_unregister
device: 'ep_04': device_unregister
bus: 'usb': remove device 1-1.2:1.0

