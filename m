Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:60313 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbXLFRJD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 12:09:03 -0500
Received: from [195.4.92.23] (helo=13.mx.freenet.de)
	by mout1.freenet.de with esmtpa (Exim 4.68)
	(envelope-from <lynx.abraxas@freenet.de>)
	id 1J0KDc-00064M-MR
	for linux-wireless@vger.kernel.org; Thu, 06 Dec 2007 18:09:00 +0100
Received: from p508e6f25.dip.t-dialin.net ([80.142.111.37]:55985 helo=localhost)
	by 13.mx.freenet.de with esmtpsa (ID lynx.abraxas@freenet.de) (TLSv1:AES256-SHA:256) (port 587) (Exim 4.68 #1)
	id 1J0KDc-0006iL-4Y
	for linux-wireless@vger.kernel.org; Thu, 06 Dec 2007 18:09:00 +0100
Date: Thu, 6 Dec 2007 18:08:58 +0100
From: lynx.abraxas@freenet.de
To: linux-wireless@vger.kernel.org
Subject: What's wrong if wlan0 device is not reacting?
Message-ID: <20071206170858.GA2008@drago> (sfid-20071206_170946_705062_3F9FBA92)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!


I'm  desperately  trying  to get a micronet SP907GK V5 (USB 1.1 WLAN-Stick) to
run under openSuSE 10.3.

lsusb tells me the manufacturer is Realtek rtl8187 so  I  compiled,  installed
and modprobed rtl8187 for the 2.6.22.5 kernel.

The module loads and iwconfig lists wlan0 as wireless device. wmaster0 is also
created. I could not find any info on what wmaster0 is for. Some say it  is  a
hint  for  malfunction of the driver. I did configure the device with Yast and
also by hand (setting essid and key with iwconfig and using dhcpcd or ifconfig
with static local ip) but had no success when pinging the router.

Micronet does not list my device as linux compatible but the support says they
don't have any devices that run under linux although the FAQ  list  a  few.  A
similar  one SP907BB is said to work under linux but it seems not to be on the
market.

Well any help or hint on how to get my device working are very appreciated.

Thanks
Lynx


PS: I'm not a list member.


part of dmesg:


rtl8187: no version for "eeprom_93cx6_multiread" found: kernel tainted.
wmaster0: Selected rate control algorithm 'simple'
phy0: hwaddr 00:11:3b:0a:fc:ac, rtl8187 V1 + rtl8225z2
usbcore: registered new interface driver rtl8187
.
.
.
usb 1-2: USB disconnect, address 5
usb 1-2: new full speed USB device using uhci_hcd and address 6
usb 1-2: new device found, idVendor=0bda, idProduct=8187
usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-2: Product: RTL8187_Wireless_LAN_Adapter
usb 1-2: Manufacturer: Manufacturer_Realtek_RTL8187_
usb 1-2: SerialNumber: 00113B0AFCAC
usb 1-2: configuration #1 chosen from 1 choice
wmaster0: Selected rate control algorithm 'simple'
phy2: hwaddr 00:11:3b:0a:fc:ac, rtl8187 V1 + rtl8225z2
ADDRCONF(NETDEV_UP): wlan0: link is not ready


___________________________________________


iwconfig
lo        no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11g  ESSID:"WLAN"
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Encryption key:foo_key
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

____________________________________________

lsusb -v -d 0bda:8187


Bus 001 Device 006: ID 0bda:8187 Realtek Semiconductor Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x8187
  bcdDevice            1.00
  iManufacturer           1 Manufacturer_Realtek_RTL8187_
  iProduct                2 RTL8187_Wireless_LAN_Adapter
  iSerial                 3 00113B0AFCAC
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 Wireless Network Card
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              5 Bulk-IN,Bulk-OUT,Bulk-OUT
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)



