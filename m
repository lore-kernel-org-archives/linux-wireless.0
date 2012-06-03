Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65152 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab2FCQK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2012 12:10:59 -0400
Received: by yenm10 with SMTP id m10so2591299yen.19
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2012 09:10:58 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 3 Jun 2012 18:10:58 +0200
Message-ID: <CAOUATobNS0XNp6e+-W6VrShXpm2JVVeGUBSKxe9v05M3e00S4g@mail.gmail.com> (sfid-20120603_181111_690511_6A5D61AF)
Subject: RT2800USB driver problem. txpower stuck at 0
From: Vilius Palme <palme3000@gmail.com>
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Cc: helmut.schaa@googlemail.com, IvDoorn@gmail.com, gwingerde@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

I'm having some sort of a problem with RT3070 usb dongle. It works
perfectly fine under 3.3.5 and 3.3.7 kernels, but somewhy refuses to
set txpower under 3.4.0. kernel .config is the same across all three.

Here's some output:

[root@R1 iw]# ifconfig wlan0 up
[root@R1 iw]# iwconfig wlan0
wlan0     IEEE 802.11bgn  ESSID:off/any
         Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm
         Retry  long limit:7   RTS thr:off   Fragment thr:off
         Encryption key:off
         Power Management:off

[root@R1 iw]# iwconfig wlan0 txpower 20
Error for wireless request "Set Tx Power" (8B26) :
   SET failed on device wlan0 ; Invalid argument.
[root@R1 iw]# iwconfig wlan0 txpower 1
Error for wireless request "Set Tx Power" (8B26) :
   SET failed on device wlan0 ; Invalid argument.
[root@R1 iw]# iwconfig wlan0 txpower 0
[root@R1 iw]#


[root@R1 iw]# rfkill list
0: tpacpi_bluetooth_sw: Bluetooth
       Soft blocked: no
       Hard blocked: no
27: phy26: Wireless LAN
       Soft blocked: no
       Hard blocked: no
[root@R1 iw]#

lsusb -vv output:

Bus 002 Device 020: ID 1737:0078 Linksys WUSB100 v2 RangePlus Wireless
Network Adapter [Ralink RT3070]
Device Descriptor:
 bLength                18
 bDescriptorType         1
 bcdUSB               2.00
 bDeviceClass            0 (Defined at Interface level)
 bDeviceSubClass         0
 bDeviceProtocol         0
 bMaxPacketSize0        64
 idVendor           0x1737 Linksys
 idProduct          0x0078 WUSB100 v2 RangePlus Wireless Network
Adapter [Ralink RT3070]
 bcdDevice            1.01
 iManufacturer           1 Cisco-Linksys LLC
 iProduct                2 Linksys RangePlus Wireless Network USB Adapter
 iSerial                 3
 bNumConfigurations      1
 Configuration Descriptor:
   bLength                 9
   bDescriptorType         2
   wTotalLength           67
   bNumInterfaces          1
   bConfigurationValue     1
   iConfiguration          0
   bmAttributes         0x80
     (Bus Powered)
   MaxPower              450mA
   Interface Descriptor:
     bLength                 9
     bDescriptorType         4
     bInterfaceNumber        0
     bAlternateSetting       0
     bNumEndpoints           7
     bInterfaceClass       255 Vendor Specific Class
     bInterfaceSubClass    255 Vendor Specific Subclass
     bInterfaceProtocol    255 Vendor Specific Protocol
     iInterface              5
     Endpoint Descriptor:
       bLength                 7
       bDescriptorType         5
       bEndpointAddress     0x81  EP 1 IN
       bmAttributes            2
         Transfer Type            Bulk
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0200  1x 512 bytes
       bInterval               0
     Endpoint Descriptor:
       bLength                 7
       bDescriptorType         5
       bEndpointAddress     0x01  EP 1 OUT
       bmAttributes            2
         Transfer Type            Bulk
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0200  1x 512 bytes
       bInterval               0
     Endpoint Descriptor:
       bLength                 7
       bDescriptorType         5
       bEndpointAddress     0x02  EP 2 OUT
       bmAttributes            2
         Transfer Type            Bulk
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0200  1x 512 bytes
       bInterval               0
     Endpoint Descriptor:
       bLength                 7
       bDescriptorType         5
       bEndpointAddress     0x03  EP 3 OUT
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

Would appreciate any kind of help,
Vilius
