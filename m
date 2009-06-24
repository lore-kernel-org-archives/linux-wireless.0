Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:23521 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760375AbZFXQFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 12:05:16 -0400
Received: by an-out-0708.google.com with SMTP id d40so1703821and.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2009 09:05:18 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Jun 2009 17:58:18 +0200
Message-ID: <63d38a500906240858q5433cdf4jb58129a9770ee13e@mail.gmail.com>
Subject: rt2500usb bug with latest version
From: =?ISO-8859-2?Q?Viktor_Ilija=B9i=E6?= <viktor.ilijasic@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all.

When I dl and build the latest version of compat-wireless
(compat-wireless-2009-06-24.tar.bz2) i cannot use my Edimax
EW-7318USg.

Here is a link to the product:
http://www.edimax.com/en/produce_detail.php?pd_id=8&pl1_id=1&pl2_id=44

Here is some info about when it's NOT working... Way down below is
some info when it IS working.

$ uname -a
Linux kinderei 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17 01:58:03
UTC 2009 x86_64 GNU/Linux

$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 9.04
Release:	9.04
Codename:	jaunty

$ sudo lsusb -vv
Bus 001 Device 014: ID 148f:2573 Ralink Technology, Corp. RT2501USB
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
  idProduct          0x2573 RT2501USB Wireless Adapter
  bcdDevice            0.01
  iManufacturer           1 Ralink
  iProduct                2 802.11 bg WLAN
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              300mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
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

$ modinfo rt2500usb
filename:
/lib/modules/2.6.28-11-generic/updates/drivers/net/wireless/rt2x00/rt2500usb.ko
license:        GPL
description:    Ralink RT2500 USB Wireless LAN driver.
version:        2.3.0
author:         http://rt2x00.serialmonkey.com
srcversion:     CEDBE01EDCE98BE5C45278B
alias:          usb:v5A57p0260d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0F88p3012d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0EB0p9020d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0769p11F3d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v114Bp0110d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0707pEE13d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0681p3C06d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v079Bp004Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp9020d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp2573d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp2570d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp1706d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0p6869d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0p6865d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0p6861d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p0097d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p008Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p0067d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p0066d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p005Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v06F8pE000d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1044p8007d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1044p8001d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2001p3C00d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14B2p3C02d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1371p9022d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13B1p001Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13B1p0011d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13B1p000Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp705Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp7051d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp7050d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p1707d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p1706d*dc*dsc*dp*ic*isc*ip*
depends:        rt2x00lib,rt2x00usb
vermagic:       2.6.28-11-generic SMP mod_unload modversions
parm:           nohwcrypt:Disable hardware encryption. (bool)

$ modinfo rt73usb
filename:
/lib/modules/2.6.28-11-generic/updates/drivers/net/wireless/rt2x00/rt73usb.ko
license:        GPL
firmware:       rt73.bin
description:    Ralink RT73 USB Wireless LAN driver.
version:        2.3.0
author:         http://rt2x00.serialmonkey.com
srcversion:     EBA867FCDE5EB3C2521072C
alias:          usb:v0586p3415d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CDEp001Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2019pAB50d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2019pAB01d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0471p200Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v6933p5001d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0769p31F3d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p9712d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p90ACd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p002Fd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p0027d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p0024d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1740p7100d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v04E8p4471d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v18E8p6238d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v18E8p6229d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v18E8p6196d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp2671d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp2573d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v04BBp093Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0pA874d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0pA861d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0p6874d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0p6877d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13B1p0028d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13B1p0023d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13B1p0020d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v06F8pE020d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v06F8pE010d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1472p0009d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1044p800Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1044p8008d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15A9p0004d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1740p3701d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v7392p7618d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v7392p7318d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07D1p3C07d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07D1p3C06d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07D1p3C04d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07D1p3C03d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07AAp002Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14B2p3C22d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1371p9032d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1371p9022d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p0119d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p0116d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p00F4d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p00D8d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v08DDp0120d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1631pC019d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp905Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp905Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp705Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp7050d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p1724d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p1723d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1690p0722d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v18C5p0002d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0EB0p9021d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp9021d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14B2p3C10d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07B8pB21Fd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07B8pB21Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07B8pB21Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07B8pB21Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07B8pB21Bd*dc*dsc*dp*ic*isc*ip*
depends:        rt2x00lib,rt2x00usb,crc-itu-t
vermagic:       2.6.28-11-generic SMP mod_unload modversions
parm:           nohwcrypt:Disable hardware encryption. (bool)

$ tail -f /var/log/syslog
Jun 24 17:27:19 kinderei kernel: [12554.745026] usb 1-5: new high
speed USB device using ehci_hcd and address 13
Jun 24 17:27:20 kinderei kernel: [12555.028920] usb 1-5: configuration
#1 chosen from 1 choice
Jun 24 17:27:20 kinderei kernel: [12555.109078] cfg80211: Calling CRDA
to update world regulatory domain
Jun 24 17:27:20 kinderei kernel: [12555.129181] cfg80211: World
regulatory domain updated:
Jun 24 17:27:20 kinderei kernel: [12555.129184] ^I(start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jun 24 17:27:20 kinderei kernel: [12555.129185] ^I(2402000 KHz -
2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jun 24 17:27:20 kinderei kernel: [12555.129186] ^I(2457000 KHz -
2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jun 24 17:27:20 kinderei kernel: [12555.129187] ^I(2474000 KHz -
2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jun 24 17:27:20 kinderei kernel: [12555.129188] ^I(5170000 KHz -
5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jun 24 17:27:20 kinderei kernel: [12555.129189] ^I(5735000 KHz -
5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jun 24 17:27:20 kinderei kernel: [12555.248175] phy0: Selected rate
control algorithm 'minstrel'
Jun 24 17:27:20 kinderei kernel: [12555.249044] Registered led device:
rt2500usb-phy0::radio
Jun 24 17:27:20 kinderei kernel: [12555.249052] Registered led device:
rt2500usb-phy0::quality
Jun 24 17:27:20 kinderei kernel: [12555.249494] usbcore: registered
new interface driver rt2500usb
Jun 24 17:27:20 kinderei kernel: [12555.253453] usbcore: registered
new interface driver rt73usb
Jun 24 17:27:20 kinderei kernel: [12555.268332] udev: renamed network
interface wlan0 to wlan1
Jun 24 17:27:20 kinderei nm-system-settings:    SCPlugin-Ifupdown:
device added (udi: /org/freedesktop/Hal/devices/net_00_xx_xx_xx_xx_xx,
iface: wlan1): not well known
Jun 24 17:27:20 kinderei NetworkManager: <info>  (wlan1): driver
supports SSID scans (scan_capa 0x01).
Jun 24 17:27:20 kinderei NetworkManager: <info>  (wlan1): new 802.11
WiFi device (driver: 'rt2500usb')
Jun 24 17:27:20 kinderei NetworkManager: <info>  (wlan1): exported as
/org/freedesktop/Hal/devices/net_xx_xx_xx_xx_xx_xx
Jun 24 17:27:25 kinderei NetworkManager: <info>  (wlan1): device state
change: 1 -> 2
Jun 24 17:27:25 kinderei NetworkManager: <info>  (wlan1): bringing up device.
Jun 24 17:27:25 kinderei NetworkManager: <info>  (wlan1): preparing device.
Jun 24 17:27:25 kinderei NetworkManager: <info>  (wlan1): deactivating
device (reason: 2).
Jun 24 17:27:25 kinderei NetworkManager: <info>  (wlan1): device state
change: 2 -> 3
Jun 24 17:27:25 kinderei kernel: [12560.060050] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 3
(-16).
Jun 24 17:27:25 kinderei kernel: [12560.060053] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 4
(-5).
Jun 24 17:27:25 kinderei kernel: [12560.060280] ADDRCONF(NETDEV_UP):
wlan1: link is not ready
Jun 24 17:27:25 kinderei NetworkManager: <info>  (wlan1): supplicant
interface state:  starting -> ready
Jun 24 17:27:25 kinderei kernel: [12560.290227] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 3
(-16).
Jun 24 17:27:25 kinderei kernel: [12560.290229] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 4
(-5).
Jun 24 17:27:25 kinderei kernel: [12560.500043] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 3
(-16).
Jun 24 17:27:25 kinderei kernel: [12560.500045] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 4
(-5).
Jun 24 17:27:25 kinderei kernel: [12560.684035] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 3
(-16).
Jun 24 17:27:25 kinderei kernel: [12560.684038] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 4
(-5).
Jun 24 17:27:26 kinderei kernel: [12560.873183] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 3
(-16).
Jun 24 17:27:26 kinderei kernel: [12560.873186] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 4
(-5).
Jun 24 17:27:26 kinderei kernel: [12561.057035] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 3
(-16).
Jun 24 17:27:26 kinderei kernel: [12561.057037] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 4
(-5).
<cut> <!-- this goes on as long as i leave the device plugged in... -->
Jun 24 17:28:58 kinderei kernel: [12653.045093] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 3
(-16).
Jun 24 17:28:58 kinderei kernel: [12653.045096] phy0 ->
rt2500usb_set_device_state: Error - Device failed to enter state 4
(-5).
Jun 24 17:29:06 kinderei kernel: [12661.761764] usb 1-5: USB
disconnect, address 13
Jun 24 17:29:06 kinderei kernel: [12661.761972] phy0 ->
rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for
offset 0x0428 with error -19.
Jun 24 17:29:06 kinderei kernel: [12661.761974] phy0 ->
rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for
offset 0x0428 with error -19.
Jun 24 17:29:06 kinderei kernel: [12661.761985] phy0 ->
rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for
offset 0x0428 with error -19.
Jun 24 17:29:06 kinderei kernel: [12661.761987] phy0 ->
rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for
offset 0x0428 with error -19.
Jun 24 17:29:06 kinderei nm-system-settings:    SCPlugin-Ifupdown:
devices removed (udi:
/org/freedesktop/Hal/devices/net_00_xx_xx_xx_xx_xx)
Jun 24 17:29:06 kinderei NetworkManager: <info>  (wlan1): now unmanaged
Jun 24 17:29:06 kinderei NetworkManager: <info>  (wlan1): device state
change: 3 -> 1
Jun 24 17:29:06 kinderei NetworkManager: <info>  (wlan1): cleaning up...


However, when I do

$ sudo make unload
$ sudo make uninstall
$ sudo make unload # for good measure

then plug the device in, everything seems to work (with a pinch of
salt). I didn't test it extensively because I have other devices that
i KNOW work so I didnt test it thoroughly.

"Default" ubuntu modules kick in and no errors reported, connection
establishes, NM doing it's job, pinging, surfing, everything seems
normal. Here they are:

$ modinfo rt73usb
filename:
/lib/modules/2.6.28-11-generic/kernel/drivers/net/wireless/rt2x00/rt73usb.ko
license:        GPL
firmware:       rt73.bin
description:    Ralink RT73 USB Wireless LAN driver.
version:        2.2.1
author:         http://rt2x00.serialmonkey.com
srcversion:     06392C23FAB17454A308DBE
alias:          usb:v2019pAB50d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2019pAB01d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0769p31F3d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p90ACd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p9712d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1740p7100d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v18E8p6238d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v18E8p6229d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v18E8p6196d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp2671d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp2573d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0pA874d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0pA861d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0p6874d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0p6877d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13B1p0028d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13B1p0023d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13B1p0020d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v06F8pE020d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v06F8pE010d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1472p0009d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1044p800Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1044p8008d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15A9p0004d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07D1p3C07d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07D1p3C06d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07D1p3C04d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07D1p3C03d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07AAp002Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14B2p3C22d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1371p9032d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1371p9022d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p00F4d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1631pC019d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp905Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp905Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp705Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp7050d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p1724d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p1723d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1690p0722d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07B8pB21Dd*dc*dsc*dp*ic*isc*ip*
depends:        rt2x00lib,rt2x00usb,crc-itu-t
vermagic:       2.6.28-11-generic SMP mod_unload modversions
parm:           nohwcrypt:Disable hardware encryption. (bool)

$ modinfo rt2500usb
filename:
/lib/modules/2.6.28-11-generic/kernel/drivers/net/wireless/rt2x00/rt2500usb.ko
license:        GPL
description:    Ralink RT2500 USB Wireless LAN driver.
version:        2.2.1
author:         http://rt2x00.serialmonkey.com
srcversion:     CF8DEA0313F8F3D3C52C8DC
alias:          usb:v5A57p0260d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0EB0p9020d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v114Bp0110d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0707pEE13d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0681p3C06d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp9020d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp2573d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp2570d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp1706d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0p6869d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0p6865d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0p6861d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p0097d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p008Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p0067d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p0066d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p005Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v06F8pE000d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1044p8007d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1044p8001d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2001p3C00d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14B2p3C02d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13B1p001Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13B1p0011d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13B1p000Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp705Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp7051d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp7050d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p1707d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p1706d*dc*dsc*dp*ic*isc*ip*
depends:        rt2x00lib,rt2x00usb
vermagic:       2.6.28-11-generic SMP mod_unload modversions

I tried installing compat-wireless and then manually deleting rt2x00
folder with modules, running depmod, and using the card like that,
but, of course, I cannot do that because incompatibilities between
different versions of modules and mac80211 and cfg80211 prevent the
thing from working.

I'd appreciate any ideas, help, bugfixii or something else that might
enable me to use ALL my cards with latest version of compat-wireless.
BTW, I have 4 usb cards at my disposal that I can test with, but this
one is the one with external connector that is travelling with my
laptop, so... I prefer this one at the moment. :)

I realize that I didnt post syslog when I use the card with default
modules, but I think it's irrelevant ATM, correct me if I'm wrong.

I'm open for testing patches and changes.

Viktor

--
Don't let people drive you crazy when you know it's in walking distance.
