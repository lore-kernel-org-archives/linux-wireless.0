Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.201.117]:40633 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132AbZDOTfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 15:35:54 -0400
Received: from [128.2.222.132] (LIMA-2.SPEECH.CS.CMU.EDU [128.2.222.132])
	by chokecherry.srv.cs.cmu.edu (8.13.6/8.13.6) with ESMTP id n3FJ5bY3020164
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 15:05:37 -0400 (EDT)
Message-ID: <49E63000.4070500@cs.cmu.edu> (sfid-20090415_213556_843780_F2D895AF)
Date: Wed, 15 Apr 2009 15:05:36 -0400
From: David Huggins-Daines <dhuggins@cs.cmu.edu>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: zd1211rw: timeout loading firmware in 2.6.29 on ARM (ep93xx)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm having trouble with two different zd1211 based cards on an 
ep93xx-based system using Linux 2.6.29.  Although the firmware is 
present and in the right place, loading it consistently fails with 
ETIMEDOUT.

I have the same problem with 2.6.27 and 2.6.28, as well as with the 
wireless-testing tree from a week ago.  dmesg (with debug enabled) says:

usb 1-1: New USB device found, idVendor=0ace, idProduct=1215
usb 1-1: New USB device strings: Mfr=16, Product=32, SerialNumber=0
usb 1-1: Product: USB2.0 WLAN
usb 1-1: Manufacturer: ZyDAS
usb 1-1: uevent
usb 1-1: usb_probe_device
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: adding 1-1:1.0 (config #1, interface 0)
usb 1-1:1.0: uevent
drivers/usb/core/inode.c: creating file '002'
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0002
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
    (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
    (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
    (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
    (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
zd1211rw usb_init()
zd1211rw 1-1:1.0: usb_probe_interface
zd1211rw 1-1:1.0: usb_probe_interface - got id
usb 1-1: print_id() 0ace:1215 v4810 full
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0002
ep93xx-ohci ep93xx-ohci: GetStatus roothub.portstatus [0] = 0x00100103 
PRSC PPS PES CCS
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0002
usb 1-1: reset full speed USB device using ep93xx-ohci and address 2
ep93xx-ohci ep93xx-ohci: GetStatus roothub.portstatus [0] = 0x00100103 
PRSC PPS PES CCS
zd1211rw 1-1:1.0: zd_chip_read_mac_addr_fw()
wmaster0 (zd1211rw): not using net_device_ops yet
phy0: Selected rate control algorithm 'minstrel'
wlan0 (zd1211rw): not using net_device_ops yet
zd1211rw 1-1:1.0: probe() successful
zd1211rw 1-1:1.0: phy0
usbcore: registered new interface driver zd1211rw
zd1211rw initialized
zd1211rw 1-1:1.0: zd_usb_init_hw()
usb 1-1: request_fw_file() fw name zd1211/zd1211b_ub
usb 1-1: firmware: requesting zd1211/zd1211b_ub
usb 1-1: upload_firmware() firmware device id 0x4810 is equal to the 
actual device id
usb 1-1: request_fw_file() fw name zd1211/zd1211b_uphr
usb 1-1: firmware: requesting zd1211/zd1211b_uphr
usb 1-1: upload_code() transfer size 4018
usb 1-1: upload_code() firmware confirm return value 0x01
usb 1-1: ifconfig timed out on ep0out len=0/0
zd1211rw 1-1:1.0: zd_usb_init_hw() couldn't reset configuration. Error 
number -110
zd1211rw 1-1:1.0: zd_usb_init_hw()
usb 1-1: request_fw_file() fw name zd1211/zd1211b_ub
usb 1-1: firmware: requesting zd1211/zd1211b_ub
usb 1-1: upload_firmware() firmware device id 0x4810 is equal to the 
actual device id
usb 1-1: request_fw_file() fw name zd1211/zd1211b_uphr
usb 1-1: firmware: requesting zd1211/zd1211b_uphr
usb 1-1: upload_code() transfer size 4018
usb 1-1: ifconfig timed out on ep0out len=0/4018
usb 1-1: USB control request for firmware upload failed. Error number -110
usb 1-1: Could not upload firmware code uph. Error number -110
zd1211rw 1-1:1.0: couldn't load firmware. Error number -110
