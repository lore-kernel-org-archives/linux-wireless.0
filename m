Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:41740 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab3FOT5v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jun 2013 15:57:51 -0400
Received: from e178084155.adsl.alicedsl.de ([85.178.84.155] helo=[192.168.2.49])
	by mail.gw90.de with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <paulepanter@users.sourceforge.net>)
	id 1Unwbc-0005aY-SF
	for linux-wireless@vger.kernel.org; Sat, 15 Jun 2013 19:57:49 +0000
Message-ID: <1371326265.9845.54.camel@mattotaupa> (sfid-20130615_215755_696848_49DF4E0F)
Subject: Connection not established with Realtek RTL8188CUS based USB device
 (EDIMAX)
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: linux-wireless@vger.kernel.org
Date: Sat, 15 Jun 2013 21:57:45 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-WULmX2gyPdgvpY6kjn1O"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WULmX2gyPdgvpY6kjn1O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Linux wireless folks,


hopefully I am contacting the correct list. I am not able to use the
Realtek RTL8188CUS based USB WLAN device Edimax EW-7811Un.

        Bus 002 Device 005: ID 7392:7811 Edimax Technology Co., Ltd EW-7811=
Un 802.11n Wireless Adapter [Realtek RTL8188CUS]

The device did not work with Debian Wheezy with Linux 3.2.x, Debian
Sid/unstable with Linux 3.9.x, Ubuntu 12.04 with Linux 3.2.12 to 3.5 and
Ubuntu 13.04 with Linux 3.8. The person, from whom the device is from,
claims the device once worked with Ubuntu, but I do not know which
version and what WLAN type(?) this was with.

The behavior is always the same. The device is detected and the
NetworkManager applet `nm-applet` is also able to detect the available
networks. But wanting to connect to one and entering the correct
password, the connection cannot be established and I am asked for the
password again. I tested this with different systems and different
networks and also with wpa_supplicant. A Ralink based WLAN USB device
works just fine.

The Realtek RTL8188CUS WLAN device works also fine under Microsoft
Windows, so the device is functional.

Reporting this bug to the NetworkManager list [1], Dan Williams kindly
replied with the following analysis [2].


Am Dienstag, den 21.05.2013, 10:57 -0500 schrieb Dan Williams:

[=E2=80=A6]

> May 19 14:30:07 myhostname wpa_supplicant[5542]: wlan1: WPA: Sending EAPO=
L-Key 2/4
> May 19 14:30:17 myhostname wpa_supplicant[5542]: wlan1: Authentication wi=
th bc:05:43:ae:b5:a3 timed out.
>=20
> this means that the driver tried to send data to the AP, but didn't hear
> anything back from the AP for 10 seconds, which of course is way, way
> too long.

[=E2=80=A6]

Please find the logs from the Debian Sid system (Linux 3.9) pasted at
the end. Please tell me, if you need anything else.


Thanks,

Paul


[1] https://mail.gnome.org/archives/networkmanager-list/2013-May/msg00149.h=
tml
[2] https://mail.gnome.org/archives/networkmanager-list/2013-May/msg00161.h=
tml


$ lsusb -s 002:005
[=E2=80=A6]
Bus 002 Device 005: ID 7392:7811 Edimax Technology Co., Ltd EW-7811Un 802.1=
1n Wireless Adapter [Realtek RTL8188CUS]
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  idVendor           0x7392 Edimax Technology Co., Ltd
  idProduct          0x7811 EW-7811Un 802.11n Wireless Adapter [Realtek RTL=
8188CUS]
  bcdDevice            2.00
  iManufacturer           1=20
  iProduct                2=20
  iSerial                 3=20
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0=20
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
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0=20
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
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1

$ dmesg
[=E2=80=A6]
[ 2582.903731] usb 2-3: new high-speed USB device number 5 using ehci-pci
[ 2583.038925] usb 2-3: New USB device found, idVendor=3D7392, idProduct=3D=
7811
[ 2583.038942] usb 2-3: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[ 2583.038952] usb 2-3: Product: 802.11n WLAN Adapter
[ 2583.038961] usb 2-3: Manufacturer: Realtek
[ 2583.038970] usb 2-3: SerialNumber: 00e04c000001
[ 2583.326713] calling  rtl_core_module_init+0x0/0x1000 [rtlwifi] @ 16003
[ 2583.326753] initcall rtl_core_module_init+0x0/0x1000 [rtlwifi] returned =
0 after 3 usecs
[ 2583.355323] calling  rtl8192cu_driver_init+0x0/0x1000 [rtl8192cu] @ 1600=
3
[ 2583.356123] rtl8192cu: Chip version 0x10
[ 2583.471162] rtl8192cu: MAC address: 80:1f:02:7c:de:7b
[ 2583.471181] rtl8192cu: Board Type 0
[ 2583.471571] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[ 2583.472008] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
[ 2583.472397] usbcore: registered new interface driver rtl8192cu
[ 2583.472436] initcall rtl8192cu_driver_init+0x0/0x1000 [rtl8192cu] return=
ed 0 after 114324 usecs
[ 2583.490519] usb 2-3: firmware: agent loaded rtlwifi/rtl8192cufw.bin into=
 memory
[ 2583.490953] ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
[ 2583.497232] rtlwifi: wireless switch is on
[ 2583.543970] rtl8192cu: MAC auto ON okay!
[ 2583.583088] rtl8192cu: Tx queue select: 0x05
[ 2583.962276] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[ 2585.601177] wlan1: authenticate with bc:05:43:ae:b5:a3
[ 2585.629238] wlan1: send auth to bc:05:43:ae:b5:a3 (try 1/3)
[ 2585.656227] wlan1: authenticated
[ 2585.659521] wlan1: associate with bc:05:43:ae:b5:a3 (try 1/3)
[ 2585.684481] wlan1: RX AssocResp from bc:05:43:ae:b5:a3 (capab=3D0x431 st=
atus=3D0 aid=3D1)
[ 2585.684594] wlan1: associated
[ 2585.685258] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[ 2595.690834] wlan1: disassociating from bc:05:43:ae:b5:a3 by local choice=
 (reason=3D3)
[ 2595.706266] cfg80211: Calling CRDA for country: US
[ 2595.708064] wlan1: deauthenticating from bc:05:43:ae:b5:a3 by local choi=
ce (reason=3D3)
[ 2597.453075] wlan1: authenticate with bc:05:43:ae:b5:a3
[ 2597.481398] wlan1: send auth to bc:05:43:ae:b5:a3 (try 1/3)
[ 2597.553088] wlan1: authenticated
[ 2597.555891] wlan1: associate with bc:05:43:ae:b5:a3 (try 1/3)
[ 2597.635637] wlan1: RX AssocResp from bc:05:43:ae:b5:a3 (capab=3D0x431 st=
atus=3D0 aid=3D1)
[ 2597.635748] wlan1: associated
[ 2607.640170] wlan1: disassociating from bc:05:43:ae:b5:a3 by local choice=
 (reason=3D3)
[ 2607.654449] cfg80211: Calling CRDA to update world regulatory domain
[ 2607.656985] wlan1: deauthenticating from bc:05:43:ae:b5:a3 by local choi=
ce (reason=3D3)
[ 2609.409429] wlan1: authenticate with bc:05:43:ae:b5:a3
[ 2609.437185] wlan1: send auth to bc:05:43:ae:b5:a3 (try 1/3)
[ 2609.460052] wlan1: authenticated
[ 2609.463842] wlan1: associate with bc:05:43:ae:b5:a3 (try 1/3)
[ 2609.545170] wlan1: RX AssocResp from bc:05:43:ae:b5:a3 (capab=3D0x431 st=
atus=3D0 aid=3D1)
[ 2609.545313] wlan1: associated
[ 2610.122545] wlan1: deauthenticating from bc:05:43:ae:b5:a3 by local choi=
ce (reason=3D3)
[ 2610.137204] cfg80211: Calling CRDA to update world regulatory domain
[ 2639.310805] usb 2-3: USB disconnect, device number 5
[=E2=80=A6]

$ more /var/log/syslog
[=E2=80=A6]
Jun 15 18:56:51 myhostname kernel: [ 2582.903731] usb 2-3: new high-speed U=
SB device number 5 using ehci-pci
Jun 15 18:56:51 myhostname kernel: [ 2583.038925] usb 2-3: New USB device f=
ound, idVendor=3D7392, idProduct=3D7811
Jun 15 18:56:51 myhostname kernel: [ 2583.038942] usb 2-3: New USB device s=
trings: Mfr=3D1, Product=3D2, SerialNumber=3D3
Jun 15 18:56:51 myhostname kernel: [ 2583.038952] usb 2-3: Product: 802.11n=
 WLAN Adapter
Jun 15 18:56:51 myhostname kernel: [ 2583.038961] usb 2-3: Manufacturer: Re=
altek
Jun 15 18:56:51 myhostname kernel: [ 2583.038970] usb 2-3: SerialNumber: 00=
e04c000001
Jun 15 18:56:51 myhostname mtp-probe: checking bus 2, device 5: "/sys/devic=
es/pci0000:00/0000:00:12.2/usb2/2-3"
Jun 15 18:56:51 myhostname mtp-probe: bus: 2, device: 5 was not an MTP devi=
ce
Jun 15 18:56:51 myhostname kernel: [ 2583.326713] calling  rtl_core_module_=
init+0x0/0x1000 [rtlwifi] @ 16003
Jun 15 18:56:51 myhostname kernel: [ 2583.326753] initcall rtl_core_module_=
init+0x0/0x1000 [rtlwifi] returned 0 after 3 usecs
Jun 15 18:56:51 myhostname kernel: [ 2583.355323] calling  rtl8192cu_driver=
_init+0x0/0x1000 [rtl8192cu] @ 16003
Jun 15 18:56:51 myhostname kernel: [ 2583.356123] rtl8192cu: Chip version 0=
x10
Jun 15 18:56:51 myhostname kernel: [ 2583.471162] rtl8192cu: MAC address: 8=
0:1f:02:7c:de:7b
Jun 15 18:56:51 myhostname kernel: [ 2583.471181] rtl8192cu: Board Type 0
Jun 15 18:56:51 myhostname kernel: [ 2583.471571] rtlwifi: rx_max_size 1536=
0, rx_urb_num 8, in_ep 1
Jun 15 18:56:51 myhostname kernel: [ 2583.472008] rtl8192cu: Loading firmwa=
re rtlwifi/rtl8192cufw.bin
Jun 15 18:56:51 myhostname kernel: [ 2583.472397] usbcore: registered new i=
nterface driver rtl8192cu
Jun 15 18:56:51 myhostname kernel: [ 2583.472436] initcall rtl8192cu_driver=
_init+0x0/0x1000 [rtl8192cu] returned 0 after 114324 usecs
Jun 15 18:56:51 myhostname kernel: [ 2583.490519] usb 2-3: firmware: agent =
loaded rtlwifi/rtl8192cufw.bin into memory
Jun 15 18:56:51 myhostname kernel: [ 2583.490953] ieee80211 phy1: Selected =
rate control algorithm 'rtl_rc'
Jun 15 18:56:51 myhostname NetworkManager[3002]: <info> found WiFi radio ki=
llswitch rfkill1 (at /sys/devices/pci0000:00/0000:00:12.2/usb2/2-3/2-3:1.0/=
ieee80211/phy1/rfkill1) (driver (unknown))
Jun 15 18:56:51 myhostname kernel: [ 2583.497232] rtlwifi: wireless switch =
is on
Jun 15 18:56:51 myhostname NetworkManager[3002]:    SCPlugin-Ifupdown: devi=
ces added (path: /sys/devices/pci0000:00/0000:00:12.2/usb2/2-3/2-3:1.0/net/=
wlan1, iface: wlan1)
Jun 15 18:56:51 myhostname NetworkManager[3002]:    SCPlugin-Ifupdown: devi=
ce added (path: /sys/devices/pci0000:00/0000:00:12.2/usb2/2-3/2-3:1.0/net/w=
lan1, iface: wlan1): no ifupdown configuration found.
Jun 15 18:56:51 myhostname NetworkManager[3002]: <info> (wlan1): using nl80=
211 for WiFi device control
Jun 15 18:56:51 myhostname NetworkManager[3002]: <warn> (wlan1): driver sup=
ports Access Point (AP) mode
Jun 15 18:56:51 myhostname NetworkManager[3002]: <info> (wlan1): new 802.11=
 WiFi device (driver: 'rtl8192cu' ifindex: 4)
Jun 15 18:56:51 myhostname NetworkManager[3002]: <info> (wlan1): exported a=
s /org/freedesktop/NetworkManager/Devices/2
Jun 15 18:56:51 myhostname NetworkManager[3002]: <info> (wlan1): now manage=
d
Jun 15 18:56:51 myhostname NetworkManager[3002]: <info> (wlan1): device sta=
te change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Jun 15 18:56:51 myhostname NetworkManager[3002]: <info> (wlan1): bringing u=
p device.
Jun 15 18:56:51 myhostname kernel: [ 2583.543970] rtl8192cu: MAC auto ON ok=
ay!
Jun 15 18:56:51 myhostname kernel: [ 2583.583088] rtl8192cu: Tx queue selec=
t: 0x05
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> (wlan1): preparing =
device.
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> (wlan1): deactivati=
ng device (reason 'managed') [2]
Jun 15 18:56:52 myhostname kernel: [ 2583.962276] IPv6: ADDRCONF(NETDEV_UP)=
: wlan1: link is not ready
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: starting -> ready
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> (wlan1): device sta=
te change: unavailable -> disconnected (reason 'supplicant-available') [20 =
30 42]
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: ready -> inactive
Jun 15 18:56:52 myhostname NetworkManager[3002]: <warn> Trying to remove a =
non-existant call id.
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> Auto-activating con=
nection 'MYWLAN 1'.
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
starting connection 'MYWLAN 1'
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> (wlan1): device sta=
te change: disconnected -> prepare (reason 'none') [30 40 0]
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
Stage 1 of 5 (Device Prepare) scheduled...
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
Stage 1 of 5 (Device Prepare) started...
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
Stage 2 of 5 (Device Configure) scheduled...
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
Stage 1 of 5 (Device Prepare) complete.
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
Stage 2 of 5 (Device Configure) starting...
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> (wlan1): device sta=
te change: prepare -> config (reason 'none') [40 50 0]
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> Activation (wlan1/w=
ireless): access point 'MYWLAN 1' has security, but secrets are required.
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> (wlan1): device sta=
te change: config -> need-auth (reason 'none') [50 60 0]
Jun 15 18:56:52 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
Stage 2 of 5 (Device Configure) complete.
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
Stage 1 of 5 (Device Prepare) scheduled...
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
Stage 1 of 5 (Device Prepare) started...
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> (wlan1): device sta=
te change: need-auth -> prepare (reason 'none') [60 40 0]
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
Stage 2 of 5 (Device Configure) scheduled...
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
Stage 1 of 5 (Device Prepare) complete.
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
Stage 2 of 5 (Device Configure) starting...
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> (wlan1): device sta=
te change: prepare -> config (reason 'none') [40 50 0]
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Activation (wlan1/w=
ireless): connection 'MYWLAN 1' has security, and secrets exist.  No new se=
crets needed.
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Config: added 'ssid=
' value 'MYWLAN'
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Config: added 'scan=
_ssid' value '1'
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Config: added 'key_=
mgmt' value 'WPA-PSK'
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Config: added 'auth=
_alg' value 'OPEN'
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Config: added 'psk'=
 value '<omitted>'
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Activation (wlan1) =
Stage 2 of 5 (Device Configure) complete.
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> Config: set interfa=
ce ap_scan to 1
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: inactive -> scanning
Jun 15 18:56:53 myhostname wpa_supplicant[4806]: wlan1: SME: Trying to auth=
enticate with bc:05:43:ae:b5:a3 (SSID=3D'MYWLAN' freq=3D2457 MHz)
Jun 15 18:56:53 myhostname kernel: [ 2585.601177] wlan1: authenticate with =
bc:05:43:ae:b5:a3
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: scanning -> authenticating
Jun 15 18:56:53 myhostname kernel: [ 2585.629238] wlan1: send auth to bc:05=
:43:ae:b5:a3 (try 1/3)
Jun 15 18:56:53 myhostname wpa_supplicant[4806]: wlan1: Trying to associate=
 with bc:05:43:ae:b5:a3 (SSID=3D'MYWLAN' freq=3D2457 MHz)
Jun 15 18:56:53 myhostname kernel: [ 2585.656227] wlan1: authenticated
Jun 15 18:56:53 myhostname kernel: [ 2585.659521] wlan1: associate with bc:=
05:43:ae:b5:a3 (try 1/3)
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: authenticating -> associating
Jun 15 18:56:53 myhostname wpa_supplicant[4806]: wlan1: Associated with bc:=
05:43:ae:b5:a3
Jun 15 18:56:53 myhostname kernel: [ 2585.684481] wlan1: RX AssocResp from =
bc:05:43:ae:b5:a3 (capab=3D0x431 status=3D0 aid=3D1)
Jun 15 18:56:53 myhostname kernel: [ 2585.684594] wlan1: associated
Jun 15 18:56:53 myhostname kernel: [ 2585.685258] IPv6: ADDRCONF(NETDEV_CHA=
NGE): wlan1: link becomes ready
Jun 15 18:56:53 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: associating -> 4-way handshake
Jun 15 18:56:55 myhostname avahi-daemon[3172]: Joining mDNS multicast group=
 on interface wlan1.IPv6 with address fe80::821f:2ff:fe7c:de7b.
Jun 15 18:56:55 myhostname avahi-daemon[3172]: New relevant interface wlan1=
.IPv6 for mDNS.
Jun 15 18:56:55 myhostname avahi-daemon[3172]: Registering new address reco=
rd for fe80::821f:2ff:fe7c:de7b on wlan1.*.
Jun 15 18:56:57 myhostname ntpd[3397]: Listen normally on 6 wlan1 fe80::821=
f:2ff:fe7c:de7b UDP 123
Jun 15 18:56:57 myhostname ntpd[3397]: peers refreshed
Jun 15 18:57:03 myhostname wpa_supplicant[4806]: wlan1: Authentication with=
 bc:05:43:ae:b5:a3 timed out.
Jun 15 18:57:03 myhostname kernel: [ 2595.690834] wlan1: disassociating fro=
m bc:05:43:ae:b5:a3 by local choice (reason=3D3)
Jun 15 18:57:03 myhostname kernel: [ 2595.706266] cfg80211: Calling CRDA fo=
r country: US
Jun 15 18:57:03 myhostname wpa_supplicant[4806]: wlan1: CTRL-EVENT-DISCONNE=
CTED bssid=3D00:00:00:00:00:00 reason=3D3
Jun 15 18:57:03 myhostname kernel: [ 2595.708064] wlan1: deauthenticating f=
rom bc:05:43:ae:b5:a3 by local choice (reason=3D3)
Jun 15 18:57:03 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: 4-way handshake -> disconnected
Jun 15 18:57:04 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: disconnected -> scanning
Jun 15 18:57:05 myhostname wpa_supplicant[4806]: wlan1: SME: Trying to auth=
enticate with bc:05:43:ae:b5:a3 (SSID=3D'MYWLAN' freq=3D2457 MHz)
Jun 15 18:57:05 myhostname kernel: [ 2597.453075] wlan1: authenticate with =
bc:05:43:ae:b5:a3
Jun 15 18:57:05 myhostname kernel: [ 2597.481398] wlan1: send auth to bc:05=
:43:ae:b5:a3 (try 1/3)
Jun 15 18:57:05 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: scanning -> authenticating
Jun 15 18:57:05 myhostname wpa_supplicant[4806]: wlan1: Trying to associate=
 with bc:05:43:ae:b5:a3 (SSID=3D'MYWLAN' freq=3D2457 MHz)
Jun 15 18:57:05 myhostname kernel: [ 2597.553088] wlan1: authenticated
Jun 15 18:57:05 myhostname kernel: [ 2597.555891] wlan1: associate with bc:=
05:43:ae:b5:a3 (try 1/3)
Jun 15 18:57:05 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: authenticating -> associating
Jun 15 18:57:05 myhostname wpa_supplicant[4806]: wlan1: Associated with bc:=
05:43:ae:b5:a3
Jun 15 18:57:05 myhostname kernel: [ 2597.635637] wlan1: RX AssocResp from =
bc:05:43:ae:b5:a3 (capab=3D0x431 status=3D0 aid=3D1)
Jun 15 18:57:05 myhostname kernel: [ 2597.635748] wlan1: associated
Jun 15 18:57:05 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: associating -> 4-way handshake
Jun 15 18:57:15 myhostname wpa_supplicant[4806]: wlan1: Authentication with=
 bc:05:43:ae:b5:a3 timed out.
Jun 15 18:57:15 myhostname kernel: [ 2607.640170] wlan1: disassociating fro=
m bc:05:43:ae:b5:a3 by local choice (reason=3D3)
Jun 15 18:57:15 myhostname kernel: [ 2607.654449] cfg80211: Calling CRDA to=
 update world regulatory domain
Jun 15 18:57:15 myhostname wpa_supplicant[4806]: wlan1: CTRL-EVENT-DISCONNE=
CTED bssid=3D00:00:00:00:00:00 reason=3D3
Jun 15 18:57:15 myhostname kernel: [ 2607.656985] wlan1: deauthenticating f=
rom bc:05:43:ae:b5:a3 by local choice (reason=3D3)
Jun 15 18:57:15 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: 4-way handshake -> disconnected
Jun 15 18:57:16 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: disconnected -> scanning
Jun 15 18:57:17 myhostname wpa_supplicant[4806]: wlan1: SME: Trying to auth=
enticate with bc:05:43:ae:b5:a3 (SSID=3D'MYWLAN' freq=3D2457 MHz)
Jun 15 18:57:17 myhostname kernel: [ 2609.409429] wlan1: authenticate with =
bc:05:43:ae:b5:a3
Jun 15 18:57:17 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: scanning -> authenticating
Jun 15 18:57:17 myhostname kernel: [ 2609.437185] wlan1: send auth to bc:05=
:43:ae:b5:a3 (try 1/3)
Jun 15 18:57:17 myhostname wpa_supplicant[4806]: wlan1: Trying to associate=
 with bc:05:43:ae:b5:a3 (SSID=3D'MYWLAN' freq=3D2457 MHz)
Jun 15 18:57:17 myhostname kernel: [ 2609.460052] wlan1: authenticated
Jun 15 18:57:17 myhostname kernel: [ 2609.463842] wlan1: associate with bc:=
05:43:ae:b5:a3 (try 1/3)
Jun 15 18:57:17 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: authenticating -> associating
Jun 15 18:57:17 myhostname wpa_supplicant[4806]: wlan1: Associated with bc:=
05:43:ae:b5:a3
Jun 15 18:57:17 myhostname kernel: [ 2609.545170] wlan1: RX AssocResp from =
bc:05:43:ae:b5:a3 (capab=3D0x431 status=3D0 aid=3D1)
Jun 15 18:57:17 myhostname kernel: [ 2609.545313] wlan1: associated
Jun 15 18:57:17 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: associating -> 4-way handshake
Jun 15 18:57:18 myhostname kernel: [ 2610.122545] wlan1: deauthenticating f=
rom bc:05:43:ae:b5:a3 by local choice (reason=3D3)
Jun 15 18:57:18 myhostname NetworkManager[3002]: <warn> Activation (wlan1/w=
ireless): association took too long.
Jun 15 18:57:18 myhostname NetworkManager[3002]: <info> (wlan1): device sta=
te change: config -> need-auth (reason 'none') [50 60 0]
Jun 15 18:57:18 myhostname NetworkManager[3002]: <warn> Activation (wlan1/w=
ireless): asking for new secrets
Jun 15 18:57:18 myhostname kernel: [ 2610.137204] cfg80211: Calling CRDA to=
 update world regulatory domain
Jun 15 18:57:18 myhostname wpa_supplicant[4806]: wlan1: CTRL-EVENT-DISCONNE=
CTED bssid=3D00:00:00:00:00:00 reason=3D3
Jun 15 18:57:18 myhostname NetworkManager[3002]: <info> (wlan1): supplicant=
 interface state: 4-way handshake -> disconnected
Jun 15 18:57:18 myhostname NetworkManager[3002]: <warn> Couldn't disconnect=
 supplicant interface: This interface is not connected.
Jun 15 18:57:18 myhostname dbus[2950]: [system] Activating service name=3D'=
org.freedesktop.UDisks' (using servicehelper)
Jun 15 18:57:18 myhostname dbus[2950]: [system] Successfully activated serv=
ice 'org.freedesktop.UDisks'
Jun 15 18:57:25 myhostname NetworkManager[3002]: <warn> No agents were avai=
lable for this request.
Jun 15 18:57:25 myhostname NetworkManager[3002]: <info> (wlan1): device sta=
te change: need-auth -> failed (reason 'no-secrets') [60 120 7]
Jun 15 18:57:25 myhostname NetworkManager[3002]: <warn> Activation (wlan1) =
failed for access point (MYWLAN)
Jun 15 18:57:25 myhostname NetworkManager[3002]: <info> Marking connection =
'MYWLAN 1' invalid.
Jun 15 18:57:25 myhostname NetworkManager[3002]: <warn> Activation (wlan1) =
failed.
Jun 15 18:57:25 myhostname NetworkManager[3002]: <info> (wlan1): device sta=
te change: failed -> disconnected (reason 'none') [120 30 0]
Jun 15 18:57:25 myhostname NetworkManager[3002]: <info> (wlan1): deactivati=
ng device (reason 'none') [0]
Jun 15 18:57:47 myhostname kernel: [ 2639.310805] usb 2-3: USB disconnect, =
device number 5
Jun 15 18:57:47 myhostname kernel: [ 2639.332649] rtlwifi: reg 0x102, usbct=
rl_vendorreq TimeOut! status:0xffffffed value=3D0x0
Jun 15 18:57:47 myhostname kernel: [ 2639.341027] rtlwifi: reg 0x422, usbct=
rl_vendorreq TimeOut! status:0xffffffed value=3D0x4d5
Jun 15 18:57:47 myhostname kernel: [ 2639.349204] rtlwifi: reg 0x542, usbct=
rl_vendorreq TimeOut! status:0xffffffed value=3D0x3903f2a
Jun 15 18:57:47 myhostname kernel: [ 2639.357666] rtlwifi: reg 0x608, usbct=
rl_vendorreq TimeOut! status:0xffffffed value=3D0x3f3f3f3f
Jun 15 18:57:47 myhostname avahi-daemon[3172]: Interface wlan1.IPv6 no long=
er relevant for mDNS.
Jun 15 18:57:47 myhostname avahi-daemon[3172]: Leaving mDNS multicast group=
 on interface wlan1.IPv6 with address fe80::821f:2ff:fe7c:de7b.
Jun 15 18:57:47 myhostname avahi-daemon[3172]: Withdrawing address record f=
or fe80::821f:2ff:fe7c:de7b on wlan1.
Jun 15 18:57:47 myhostname avahi-daemon[3172]: Withdrawing workstation serv=
ice for wlan1.
Jun 15 18:57:47 myhostname NetworkManager[3002]:    SCPlugin-Ifupdown: devi=
ces removed (path: /sys/devices/pci0000:00/0000:00:12.2/usb2/2-3/2-3:1.0/ne=
t/wlan1, iface: wlan1)
Jun 15 18:57:47 myhostname NetworkManager[3002]: <info> (wlan1): now unmana=
ged
Jun 15 18:57:47 myhostname NetworkManager[3002]: <info> (wlan1): device sta=
te change: disconnected -> unmanaged (reason 'removed') [30 10 36]
Jun 15 18:57:47 myhostname NetworkManager[3002]: <info> (wlan1): cleaning u=
p...
Jun 15 18:57:47 myhostname NetworkManager[3002]: <warn> (4) failed to find =
interface name for index
Jun 15 18:57:47 myhostname NetworkManager[3002]: (nm-system.c:685):nm_syste=
m_iface_get_flags: runtime check failed: (iface !=3D NULL)
Jun 15 18:57:47 myhostname NetworkManager[3002]: <error> [1371315467.634015=
] [nm-system.c:687] nm_system_iface_get_flags(): (unknown): failed to get i=
nterface link object
Jun 15 18:57:47 myhostname NetworkManager[3002]: <info> radio killswitch /s=
ys/devices/pci0000:00/0000:00:12.2/usb2/2-3/2-3:1.0/ieee80211/phy1/rfkill1 =
disappeared
Jun 15 18:57:47 myhostname wpa_supplicant[4806]: Could not read interface w=
lan1 flags: No such device
Jun 15 18:57:48 myhostname ntpd[3397]: Deleting interface #6 wlan1, fe80::8=
21f:2ff:fe7c:de7b#123, interface stats: received=3D0, sent=3D0, dropped=3D0=
, active_time=3D51 secs
[=E2=80=A6]

--=-WULmX2gyPdgvpY6kjn1O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlG8xzkACgkQPX1aK2wOHVgdnACcCYgpveXblWoeHYZbm5XEHgES
WN0An1Rsa4cpcjzpXBVmOZb87ZJ7UkMU
=pCBU
-----END PGP SIGNATURE-----

--=-WULmX2gyPdgvpY6kjn1O--

