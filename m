Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:63969 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932451AbYBZXNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 18:13:45 -0500
Message-ID: <47C49D21.1030905@lwfinger.net> (sfid-20080226_231354_041698_BF4371C6)
Date: Tue, 26 Feb 2008 16:13:37 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Problems with RTL8187 USB device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the BCM4311 that is built-in on my laptop failed, I bought a USB wi-fi device to use until I
get my laptop fixed. Based on suggestions from the wireless mailing list, I bought one with an
RTL8187 chip. Naturally, I am having problems getting it working.

First of all, the device works with Windows - thus it is OK.

The device is manufactured by "Level 1". The FCC ID is NDD9573160714 and it has the identifying code
of WNC-0301USB07091001070-V5.

The output of 'lsusb -v' for this device when run as root is

Bus 001 Device 002: ID 0bda:8187 Realtek Semiconductor Corp.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0bda Realtek Semiconductor Corp.
   idProduct          0x8187
   bcdDevice            2.00
   iManufacturer           1 Manufacturer_Realtek
   iProduct                2 RTL8187B_WLAN_Adapter
   iSerial                 3 00e04c000001
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           81
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
       bNumEndpoints           9
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass    255 Vendor Specific Subclass
       bInterfaceProtocol    255 Vendor Specific Protocol
       iInterface              2 RTL8187B_WLAN_Adapter
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x04  EP 4 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x05  EP 5 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x06  EP 6 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x07  EP 7 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x89  EP 9 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x0a  EP 10 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x0b  EP 11 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x0c  EP 12 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)

Using kernel 2.6.25-rc3 from Linus's tree, the following appear in dmesg output:

usb 1-6: new high speed USB device using ehci_hcd and address 2
usb 1-6: configuration #1 chosen from 1 choice
phy0: Selected rate control algorithm 'pid'
phy0: hwaddr 00:11:6b:3e:c2:79, rtl8187 V0 + rtl8225
usbcore: registered new interface driver rtl8187
udev: renamed network interface wlan0 to eth2
phy0: RF Calibration Failed! 0 in rtl8225_rf_init

The wireless device appears in the iwconfig and ifconfig lists, but no scan data are received.

When I try to use the device with a kernel from the 'everything' branch of Linville's tree, the
machine crashes with a blinking caps lock key indicating a kernel panic. I have not succeeded in
capturing a netconsole dump for this situation.

What additional information besides the netconsole dump would be useful in sorting out these problems?

Thanks,

Larry

