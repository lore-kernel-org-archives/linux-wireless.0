Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41350 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbZH3UpF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 16:45:05 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MhrGo-00052I-Io
	for linux-wireless@vger.kernel.org; Sun, 30 Aug 2009 22:45:02 +0200
Received: from f051051035.adsl.alicedsl.de ([78.51.51.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2009 22:45:02 +0200
Received: from keinstein_junior by f051051035.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2009 22:45:02 +0200
To: linux-wireless@vger.kernel.org
From: Tobias Schlemmer <keinstein_junior@gmx.net>
Subject: rtl8187b Problem with tx level 
Date: Sun, 30 Aug 2009 22:44:03 +0200
Message-ID: <h7eo7q$7ks$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020703040604020104060300"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020703040604020104060300
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I have some problem with my rtl8187b device. It is included in my laptop 
running Ubuntu linux 2.6.28. I've tested several compat-wireless 
releases including 2.6.30 and 2.6.31-rc7.

The problem is that the network adapter looses the connection to the 
access point at very low distances. It seems to be as if the driver is 
too optimistic about tx power. I monitored the singnal strength on the 
access point (Buffalo running DD-WRT). When I associate the laptop with 
it the recieved signal strength starts full and drops rapidly in the 
first seconds. At the end it is about 0 at a distance of 4m. At this 
moment no ping will arrive the destination. Tests with other access 
points show similar results.

After several attempts to get different drivers working I used an Ubuntu 
8.04 boot CD this morning which seems to work out of the box. It has 
kernel 2.6.24 using a module called r8187. I compared these two drivers 
and got much better signal strengths, at least more stable connections. 
Maybe it's interesting that the two drivers report different signal 
strength (compat-wireless reports about 10dBm higher values than the old 
driver) also in signal quality the compat wireless driver seems to be 
more optimistic.

Interestingly iwconfig always reports TX power of 20dBm, regardless of 
the actual tx power, but always a TX rate of 1M. Setting the latter to a 
higher value results in packet loss.

As I leave for holidays on Tuesday I can give further information only 
tomorrow and in two weeks.

Tobias

--------------020703040604020104060300
Content-Type: text/plain;
 name="eventlog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="eventlog"

Log of iw event -t 
Sun Aug 30 21:26:57 2009

iwdied with signal 2

Sun Aug 30 21:27:22 2009
----------------
1251660460.087134: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660481.753561: wlan0 (phy #0): disassoc 00:16:44:fb:52:6c -> 00:17:3f:7e:ab:08 reason 1: Unspecified
1251660486.831135: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660487.041865: wlan0 (phy #0): auth 00:17:3f:7e:ab:08 -> 00:16:44:fb:52:6c status: 0: Successful
1251660487.050600: wlan0 (phy #0): assoc 00:17:3f:7e:ab:08 -> 00:16:44:fb:52:6c status: 0: Successful
1251660588.213505: wlan0 (phy #0): deauth 00:16:44:fb:52:6c -> 00:17:3f:7e:ab:08 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS
1251660600.900453: wlan0 (phy #0): scan aborted: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660607.237699: wlan0 (phy #0): disassoc 00:16:44:fb:52:6c -> 00:17:3f:7e:ab:08 reason 1: Unspecified
1251660613.427166: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660614.348485: wlan0 (phy #0): auth: timed out
1251660620.263160: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660621.152487: wlan0 (phy #0): auth: timed out
1251660626.311193: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660627.200489: wlan0 (phy #0): auth: timed out
1251660632.359167: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660633.248491: wlan0 (phy #0): auth: timed out
1251660638.415165: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660639.304490: wlan0 (phy #0): auth: timed out
1251660644.467730: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660645.356493: wlan0 (phy #0): auth: timed out
1251660650.519172: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660651.419254: wlan0 (phy #0): auth: timed out
1251660656.587182: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660657.512517: wlan0 (phy #0): auth: timed out
1251660662.655181: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660663.532509: wlan0 (phy #0): auth: timed out
1251660668.711181: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660669.588513: wlan0 (phy #0): auth: timed out
1251660674.779164: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660675.656519: wlan0 (phy #0): auth: timed out
1251660680.943163: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660681.836528: wlan0 (phy #0): auth: timed out
1251660686.879163: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660687.768520: wlan0 (phy #0): auth: timed out
1251660692.927168: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660693.816525: wlan0 (phy #0): auth: timed out
1251660698.975165: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 2484, ""
1251660699.400865: wlan0 (phy #0): auth 00:17:3f:7e:ab:08 -> 00:16:44:fb:52:6c status: 0: Successful
1251660699.412964: wlan0 (phy #0): assoc 00:17:3f:7e:ab:08 -> 00:16:44:fb:52:6c status: 0: Successful


--------------020703040604020104060300
Content-Type: text/x-log;
 name="kernel-short.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel-short.log"

[  346.940054] usb 1-1: new high speed USB device using ehci_hcd and address 4
[  347.086851] usb 1-1: configuration #1 chosen from 1 choice
[  347.418280] cfg80211: Calling CRDA for country: EU
[  348.348579] phy0: Selected rate control algorithm 'minstrel'
[  348.349108] phy0: hwaddr e3c7a080, RTL8187BvE V0 + rtl8225z2
[  348.349131] usbcore: registered new interface driver rtl8187
[  361.807409] phy0: device now idle
[  361.878423] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  361.893826] phy0: device no longer idle - scanning
[  364.225226] phy0: device now idle
[  364.806379] phy0: device no longer idle - scanning
[  366.893227] phy0: device now idle
[  390.835706] phy0: device no longer idle - scanning
[  392.917362] phy0: device now idle
[  412.002426] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  412.371061] phy0: device no longer idle - scanning
[  414.498373] wlan0: authenticate with AP e3c7b708
[  414.498397] wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
[  414.499742] phy0: device now idle
[  417.572157] phy0: device no longer idle - scanning
[  419.649259] phy0: device now idle
[  419.718250] phy0: device no longer idle - in use
[  419.785249] wlan0: authenticate with AP e3c7b708
[  419.786755] wlan0: authenticated
[  419.786756] wlan0: associate with AP e3c7b708
[  419.789134] wlan0: RX AssocResp from e3f8201a (capab=0x411 status=0 aid=3)
[  419.789138] wlan0: associated
[  419.789142] phy0: Allocated STA e3c00a08
[  419.789403] phy0: Inserted STA e3c00a08
[  419.790372] wlan0: switched to short barker preamble (BSSID=e3c7b708)
[  419.790374] wlan0: switched to short slot time (BSSID=e3c7b708)
[  419.795862] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  420.664625] padlock: VIA PadLock not detected.
[  426.992527] wlan0: setting MTU 1492
[  429.796020] wlan0: no IPv6 routers present
[  465.032820] usb 2-2: USB disconnect, address 2
[  520.958259] wlan0: deauthenticating by local choice (reason=3)
[  520.959293] phy0: device now idle
[  521.037304] phy0: Removed STA e3c00a08
[  521.037411] phy0: Destroyed STA e3c00a08
[  524.902800] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  533.450798] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  533.452844] phy0: device no longer idle - scanning
[  533.645340] phy0: device now idle
[  537.890760] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  537.890876] phy0: device no longer idle - scanning
[  539.982438] wlan0: direct probe to AP e3c7b708 try 1
[  539.982476] wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
[  539.983926] phy0: device now idle
[  543.973724] phy0: device no longer idle - scanning
[  546.270791] phy0: device now idle
[  546.358314] phy0: device no longer idle - in use
[  546.425311] wlan0: direct probe to AP e3c7b708 try 1
[  546.624050] wlan0: direct probe to AP e3c7b708 try 2
[  546.824039] wlan0: direct probe to AP e3c7b708 try 3
[  547.024037] wlan0: direct probe to AP e3c7b708 timed out
[  547.024044] phy0: device now idle
[  551.030732] phy0: device no longer idle - scanning
[  553.093323] phy0: device now idle
[  553.162315] phy0: device no longer idle - in use
[  553.229316] wlan0: direct probe to AP e3c7b708 try 1
[  553.428042] wlan0: direct probe to AP e3c7b708 try 2
[  553.628037] wlan0: direct probe to AP e3c7b708 try 3
[  553.828036] wlan0: direct probe to AP e3c7b708 timed out
[  553.828043] phy0: device now idle
[  557.082433] phy0: device no longer idle - scanning
[  559.141327] phy0: device now idle
[  559.210312] phy0: device no longer idle - in use
[  559.277319] wlan0: direct probe to AP e3c7b708 try 1
[  559.476045] wlan0: direct probe to AP e3c7b708 try 2
[  559.676044] wlan0: direct probe to AP e3c7b708 try 3
[  559.876044] wlan0: direct probe to AP e3c7b708 timed out


--------------020703040604020104060300
Content-Type: text/plain;
 name="lsusb"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lsusb"

Bus 001 Device 004: ID 0bda:8189 Realtek Semiconductor Corp. RTL8187B Wireless 802.11g 54Mbps Network Adapter
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x8189 RTL8187B Wireless 802.11g 54Mbps Network Adapter
  bcdDevice            2.00
  iManufacturer           1 Manufacturer_Realtek
  iProduct                2 
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
      iInterface              2 
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


--------------020703040604020104060300--

