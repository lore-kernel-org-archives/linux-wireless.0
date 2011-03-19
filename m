Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chiark.greenend.org.uk ([212.13.197.229]:36804 "EHLO
	chiark.greenend.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1CSSWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 14:22:52 -0400
Message-ID: <4D84EC90.4090803@greenend.org.uk>
Date: Sat, 19 Mar 2011 17:49:04 +0000
From: Richard Kettlewell <rjk@greenend.org.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: 618930@bugs.debian.org
Subject: Re: Bug#618930: High network latency with ralink usb wireless device
References: <4D84E433.70001@greenend.org.uk> <1300555815.26693.83.camel@localhost>
In-Reply-To: <1300555815.26693.83.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(see also bugs.debian.org/618930 though AFAIK everything important is 
reproduced in this message.)

On 19/03/2011 17:30, Ben Hutchings wrote:
> Sorry, no.  Please report this upstream to
> linux-wireless@vger.kernel.org and cc the bug address.

I have a TP-Link TL-WN321G USB wireless adapter, which is a badged 
Ralink RT2070.  Under Debian's 2.6.32 this worked smoothly with 
rt2870sta.  On upgrading to Debian's 2.6.38, however, only rt2800usb was 
available and with that I found that ping latency is around 600ms.

== Under 2.6.32, with rt2870sta ==

richard@violeer:~$ uname -a
Linux violeer 2.6.32-5-686 #1 SMP Wed Jan 12 04:01:41 UTC 2011 i686 
GNU/Linux
richard@violeer:~$ iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wlan0     Ralink STA  ESSID:"wlan.anjou.terraraq.org.uk" 
Nickname:"RT2870STA"
           Mode:Managed  Frequency=2.442 GHz  Access Point: 
00:0F:CB:A0:0C:70
           Bit Rate=54 Mb/s
           RTS thr:off   Fragment thr:off
           Link Quality=100/100  Signal level:-45 dBm  Noise level:-83 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

richard@sfere:~$ ping -qc10 violeer
PING violeer.wlan.anjou.terraraq.org.uk (172.31.59.138) 56(84) bytes of 
data.

--- violeer.wlan.anjou.terraraq.org.uk ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9013ms
rtt min/avg/max/mdev = 0.973/1.094/1.490/0.141 ms

== Under 2.6.38, with rt2800usb ==

richard@violeer:~$ uname -a
Linux violeer 2.6.38-1-686 #1 SMP Wed Mar 16 17:37:47 UTC 2011 i686 
GNU/Linux
richard@violeer:~$ iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:"wlan.anjou.terraraq.org.uk"
           Mode:Managed  Frequency:2.442 GHz  Access Point: 
00:0F:CB:A0:0C:70
           Bit Rate=18 Mb/s   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Power Management:on
           Link Quality=67/70  Signal level=-43 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:2  Invalid misc:6   Missed beacon:0


richard@sfere:~$ ping -qc10 violeer
PING violeer.wlan.anjou.terraraq.org.uk (172.31.59.138) 56(84) bytes of 
data.

--- violeer.wlan.anjou.terraraq.org.uk ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9006ms
rtt min/avg/max/mdev = 509.111/603.472/630.232/47.090 ms

== lsusb output ==

Bus 001 Device 002: ID 148f:2070 Ralink Technology, Corp. RT2070 
Wireless Adapter
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x148f Ralink Technology, Corp.
   idProduct          0x2070 RT2070 Wireless Adapter
   bcdDevice            1.01
   iManufacturer           1 Ralink
   iProduct                2 802.11 g WLAN
   iSerial                 3 1.0
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
       iInterface              5 1.0
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

== dmesg output ==

root@violeer:~# dmesg|grep -E rt2\|wlan
[   12.344624] Registered led device: rt2800usb-phy0::radio
[   12.344653] Registered led device: rt2800usb-phy0::assoc
[   12.344679] Registered led device: rt2800usb-phy0::quality
[   12.346539] usbcore: registered new interface driver rt2800usb
[   14.895564] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   18.829895] wlan0: authenticate with 00:0f:cb:a0:0c:70 (try 1)
[   18.831281] wlan0: authenticated
[   20.432339] wlan0: associate with 00:0f:cb:a0:0c:70 (try 1)
[   20.434597] wlan0: RX AssocResp from 00:0f:cb:a0:0c:70 (capab=0x431 
status=0 aid=2)
[   20.434601] wlan0: associated
[   20.442967] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
