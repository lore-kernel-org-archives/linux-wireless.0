Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57211 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab0LFIvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 03:51:41 -0500
Received: by pwj3 with SMTP id 3so1841008pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 00:51:40 -0800 (PST)
Message-ID: <4CFCA416.1010505@gmail.com>
Date: Mon, 06 Dec 2010 19:51:34 +1100
From: Wade Fitzpatrick <wade.fitzpatrick@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ar9170usb slow / poor performance
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have 2 USB wireless dongles:
  - Generic Realtek RTL8187 using rtl8187 driver
  - Netgear WN111v2 [Atheros AR9001-U(2)NG] using ar9170usb driver

Performance of the Netgear has degraded severely since updating to Arch 
Linux kernel 2.6.36.1-3 from 2.6.35.4-2, also reported by 
http://article.gmane.org/gmane.linux.kernel.wireless.general/59911

Note that I only installed and enabled wlan1 because wlan0 was 
performing so badly.

# lsusb -v -d 0bda:8187

Bus 002 Device 005: ID 0bda:8187 Realtek Semiconductor Corp. RTL8187 
Wireless Adapter
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0bda Realtek Semiconductor Corp.
   idProduct          0x8187 RTL8187 Wireless Adapter
   bcdDevice            1.00
   iManufacturer           1 Manufacturer_Realtek_RTL8187_
   iProduct                2 RTL8187_Wireless_LAN_Adapter
   iSerial                 3 001AEF0050E6
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

# lsusb -v -d 0846:9001

Bus 002 Device 004: ID 0846:9001 NetGear, Inc. WN111(v2) RangeMax Next 
Wireless [Atheros AR9001U-(2)NG]
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass          255 Vendor Specific Class
   bDeviceSubClass       255 Vendor Specific Subclass
   bDeviceProtocol       255 Vendor Specific Protocol
   bMaxPacketSize0        64
   idVendor           0x0846 NetGear, Inc.
   idProduct          0x9001 WN111(v2) RangeMax Next Wireless [Atheros 
AR9001U-(2)NG]
   bcdDevice            1.06
   iManufacturer          16 ATHER
   iProduct               32 USB2.0 WLAN
   iSerial                48 12345
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           46
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           4
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
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
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x04  EP 4 OUT
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               1
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass          255 Vendor Specific Class
   bDeviceSubClass       255 Vendor Specific Subclass
   bDeviceProtocol       255 Vendor Specific Protocol
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)

# iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wlan0     IEEE 802.11bgn  ESSID:"waddles"
           Mode:Managed  Frequency:2.412 GHz  Access Point: 
00:22:3F:07:42:F3
           Bit Rate=117 Mb/s   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=34/70  Signal level=-76 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

wlan1     IEEE 802.11bg  ESSID:"waddles"
           Mode:Managed  Frequency:2.412 GHz  Access Point: 
00:22:3F:07:42:F3
           Bit Rate=36 Mb/s   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=44/70  Signal level=-66 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

tun0      no wireless extensions.

My network looks like this:

Linux                          Router/AP       DSL Modem
(wlan0) 192.168.1.57 ---/--- 192.168.1.1 --- 192.168.0.1 --- Internet
(wlan1) 192.168.1.4  ---/---

Between the router and the modem is an ethernet crossover cable.

# ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=1 ttl=63 time=2.23 ms
64 bytes from 192.168.0.1: icmp_seq=2 ttl=63 time=2.11 ms
64 bytes from 192.168.0.1: icmp_seq=3 ttl=63 time=1.88 ms
^C
--- 192.168.0.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 1.882/2.076/2.235/0.146 ms

# route add -host 192.168.0.1 gw 192.168.1.1 dev wlan0

# netstat -nr
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt 
Iface
192.168.0.1     192.168.1.1     255.255.255.255 UGH       0 0          0 
wlan0
192.168.1.0     0.0.0.0         255.255.255.0   U         0 0          0 
wlan1
192.168.1.0     0.0.0.0         255.255.255.0   U         0 0          0 
wlan0
0.0.0.0         192.168.1.1     0.0.0.0         UG        0 0          0 
wlan1

# ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=1 ttl=63 time=158 ms
64 bytes from 192.168.0.1: icmp_seq=2 ttl=63 time=168 ms
64 bytes from 192.168.0.1: icmp_seq=3 ttl=63 time=162 ms
64 bytes from 192.168.0.1: icmp_seq=4 ttl=63 time=170 ms
64 bytes from 192.168.0.1: icmp_seq=5 ttl=63 time=178 ms
64 bytes from 192.168.0.1: icmp_seq=6 ttl=63 time=166 ms
64 bytes from 192.168.0.1: icmp_seq=7 ttl=63 time=166 ms
64 bytes from 192.168.0.1: icmp_seq=8 ttl=63 time=155 ms
64 bytes from 192.168.0.1: icmp_seq=9 ttl=63 time=434 ms
64 bytes from 192.168.0.1: icmp_seq=10 ttl=63 time=154 ms
64 bytes from 192.168.0.1: icmp_seq=11 ttl=63 time=174 ms
64 bytes from 192.168.0.1: icmp_seq=12 ttl=63 time=161 ms
64 bytes from 192.168.0.1: icmp_seq=13 ttl=63 time=147 ms
64 bytes from 192.168.0.1: icmp_seq=14 ttl=63 time=170 ms
64 bytes from 192.168.0.1: icmp_seq=15 ttl=63 time=161 ms
64 bytes from 192.168.0.1: icmp_seq=16 ttl=63 time=190 ms
64 bytes from 192.168.0.1: icmp_seq=17 ttl=63 time=218 ms
64 bytes from 192.168.0.1: icmp_seq=18 ttl=63 time=166 ms
64 bytes from 192.168.0.1: icmp_seq=19 ttl=63 time=514 ms
64 bytes from 192.168.0.1: icmp_seq=20 ttl=63 time=177 ms
64 bytes from 192.168.0.1: icmp_seq=21 ttl=63 time=144 ms
64 bytes from 192.168.0.1: icmp_seq=22 ttl=63 time=191 ms
64 bytes from 192.168.0.1: icmp_seq=23 ttl=63 time=175 ms
64 bytes from 192.168.0.1: icmp_seq=24 ttl=63 time=156 ms
64 bytes from 192.168.0.1: icmp_seq=25 ttl=63 time=947 ms
64 bytes from 192.168.0.1: icmp_seq=26 ttl=63 time=1833 ms
64 bytes from 192.168.0.1: icmp_seq=27 ttl=63 time=2196 ms
64 bytes from 192.168.0.1: icmp_seq=28 ttl=63 time=1542 ms
64 bytes from 192.168.0.1: icmp_seq=29 ttl=63 time=816 ms
64 bytes from 192.168.0.1: icmp_seq=30 ttl=63 time=3045 ms
64 bytes from 192.168.0.1: icmp_seq=31 ttl=63 time=3181 ms
64 bytes from 192.168.0.1: icmp_seq=32 ttl=63 time=2287 ms
64 bytes from 192.168.0.1: icmp_seq=33 ttl=63 time=1496 ms
64 bytes from 192.168.0.1: icmp_seq=34 ttl=63 time=687 ms
64 bytes from 192.168.0.1: icmp_seq=35 ttl=63 time=173 ms
^C
--- 192.168.0.1 ping statistics ---
35 packets transmitted, 35 received, 0% packet loss, time 34037ms
rtt min/avg/max/mdev = 144.678/653.604/3181.758/855.953 ms, pipe 4

NOTE --- The higher ping times occurred when downloading a 39kB image file.

# route del -host 192.168.0.1 gw 192.168.1.1 dev wlan0

# ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=1 ttl=63 time=2.37 ms
64 bytes from 192.168.0.1: icmp_seq=2 ttl=63 time=2.10 ms
64 bytes from 192.168.0.1: icmp_seq=3 ttl=63 time=1.96 ms
64 bytes from 192.168.0.1: icmp_seq=4 ttl=63 time=2.38 ms
^C
--- 192.168.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3003ms
rtt min/avg/max/mdev = 1.964/2.206/2.388/0.187 ms

I have also tried using the carl9170 driver (2010_12_02) with 
compat-wireless and carl9170-fw (1.9.1-1) but I found 'iwconfig' would 
segfault when it tried to display ath0.

Can somebody help me debug it further please?
