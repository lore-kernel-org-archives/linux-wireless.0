Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63616 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1ADEaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 23:30:25 -0500
Received: by gyb11 with SMTP id 11so5402162gyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jan 2011 20:30:24 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 3 Jan 2011 22:30:23 -0600
Message-ID: <AANLkTinM9oPV=CJ3iUP2=fEH=+fRP5JPMO4tHLOZzHrS@mail.gmail.com>
Subject: (rt61pci/hostapd) no packet activity when encryption is enabled and
 interface is bridged
From: C Anthony Risinger <anthony@extof.me>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello,

i've been trying to solve this for a few days, so after much googling,
i've given in and am looking here for assistance.

problem summary: an rt61pci driven card does not seem to allow any
packets to enter/exit it's bridge ONLY WHEN ENCRYPTION is enabled;
without it, everything works perfectly.

i recently bought an older wireless G card for use as an access point
to replace my ageing wrt54g.  my physical server runs libvirt/kvm and
[next to] nothing else.  hostapd runs on the host.  when hostapd
starts up, the card's interface (wlan0) is added to an existing bridge
(green0) via hostapd's config option.  a small VM is also linked to
this bridge; this "router/gateway" VM provides all local networking
services (NAT/DHCP/DNS forward/etc.), and manages the untrusted,
outside connection (red0)... also a bridge.

interface summary:

---------------------------------------------------------------

red0
    bridge.  untrusted; direct attached to internet
green0
    bridge.  trusted; [W]LAN and VM clients
wlan0
    wireless interface (rt61pci)
vnet0-0
    host facing interface of the router VM (WAN [red0])
vnet0-1
    VM facing interface of the router VM (WAN [red0])
vnet1-0
    host facing interface of the router VM (LAN [green0])
vnet1-1
    VM facing interface of the router VM (LAN [green0])
eth0
    untrusted physical link to internet

---------------------------------------------------------------

visual-ish summary:

---------------------------------------------------------------

[ green0 ]( wlan0, vnet1-0 )
|
|
[ vnet1-1 ]
:
: (firewall rules, policies, etc.)
:
[ vnet0-1 ]
|
|
[ red0 ]( eth0, vnet0-0 )

---------------------------------------------------------------

now, everything works perfectly... right up until i enable WPA in
hostapd.  after that, my clients can associate just fine (in fact, -dd
shows no sign of any problems whatsoever, see below) but they cannot
receive an IP via DHCP... no packets seem to pass through at all
(ifconfig?).

i have read elsewhere about problems with bridging, so i'm about to
test right now by running a DHCP daemon directly on wlan0... but i
can't do anything useful/simply without bridge support.

does anyone know what's going on here, or any tips on how to
confirm/test/debug?  i have tried from 4 clients with the same
results:

) google nexus s mobile
) samsung vibrant mobile
) thinkpad t43
) eee s101

so i'm fairly confident it's the AP.  also, when i do this (on host)
while hostapd is running:

ip link set wlan0 down && ip link set wlan0 up;

it strangely starts working (clients get IP, and can use the
connection for awhile), but not consistently; the nexus reconnects
every 5-10 seconds, and though the t43 remains connected... the AP
will shortly stop allowing traffic, and back to square one.

ideas?  following is every piece of info i thought might be useful :-)
let me know if i missed anything.  all commands (except last) ran from
host while hostapd runs in background.

thanks,

C Anthony

---------------------------------------------------------------

# lspci -s 04:06.0 -vv
04:06.0 Network controller: RaLink RT2561/RT61 802.11g PCI
	Subsystem: ASUSTeK Computer Inc. Device 837e
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at febf8000 (32-bit, non-prefetchable) [size=32K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: rt61pci
	Kernel modules: rt61pci

---------------------------------------------------------------

(kernel 2.6.36.2)
# uname -a
Linux extofme-p01 2.6.36-ARCH #1 SMP PREEMPT Fri Dec 10 20:32:37 CET
2010 x86_64 AMD Phenom(tm) 9950 Quad-Core Processor AuthenticAMD
GNU/Linux

---------------------------------------------------------------

# modinfo rt61pci
filename:
/lib/modules/2.6.36-ARCH/kernel/drivers/net/wireless/rt2x00/rt61pci.ko
license:        GPL
firmware:       rt2661.bin
firmware:       rt2561s.bin
firmware:       rt2561.bin
description:    Ralink RT61 PCI & PCMCIA Wireless LAN driver.
version:        2.3.0
author:         http://rt2x00.serialmonkey.com
srcversion:     F1774A00C329E6A439932A5
alias:          pci:v00001814d00000401sv*sd*bc*sc*i*
alias:          pci:v00001814d00000302sv*sd*bc*sc*i*
alias:          pci:v00001814d00000301sv*sd*bc*sc*i*
depends:        rt2x00lib,rt2x00pci,eeprom_93cx6,crc-itu-t
vermagic:       2.6.36-ARCH SMP preempt mod_unload
parm:           nohwcrypt:Disable hardware encryption. (bool)

---------------------------------------------------------------

# ip link && ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc
pfifo_fast state UP qlen 1000
    link/ether 00:23:54:16:74:82 brd ff:ff:ff:ff:ff:ff
4: red0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
    link/ether 00:23:54:16:74:82 brd ff:ff:ff:ff:ff:ff
5: green0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
state UNKNOWN
    link/ether 48:5b:39:bd:fe:a2 brd ff:ff:ff:ff:ff:ff
7: vnet0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
state UNKNOWN qlen 500
    link/ether fe:54:00:75:c8:9d brd ff:ff:ff:ff:ff:ff
8: vnet1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
state UNKNOWN qlen 500
    link/ether fe:54:00:07:60:02 brd ff:ff:ff:ff:ff:ff
26: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state
UNKNOWN qlen 1000
    link/ether 48:5b:39:bd:fe:a2 brd ff:ff:ff:ff:ff:ff
27: mon.wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq
state UNKNOWN qlen 1000
    link/ieee802.11/radiotap 48:5b:39:bd:fe:a2 brd ff:ff:ff:ff:ff:ff
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc
pfifo_fast state UP qlen 1000
    link/ether 00:23:54:16:74:82 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::223:54ff:fe16:7482/64 scope link
       valid_lft forever preferred_lft forever
4: red0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
    link/ether 00:23:54:16:74:82 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.150/24 brd 192.168.1.255 scope global red0
    inet6 fe80::223:54ff:fe16:7482/64 scope link
       valid_lft forever preferred_lft forever
5: green0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
state UNKNOWN
    link/ether 48:5b:39:bd:fe:a2 brd ff:ff:ff:ff:ff:ff
    inet 10.10.10.102/24 brd 10.10.10.255 scope global green0
    inet6 fe80::4a5b:39ff:febd:fea2/64 scope link
       valid_lft forever preferred_lft forever
7: vnet0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
state UNKNOWN qlen 500
    link/ether fe:54:00:75:c8:9d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::fc54:ff:fe75:c89d/64 scope link
       valid_lft forever preferred_lft forever
8: vnet1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
state UNKNOWN qlen 500
    link/ether fe:54:00:07:60:02 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::fc54:ff:fe07:6002/64 scope link
       valid_lft forever preferred_lft forever
26: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state
UNKNOWN qlen 1000
    link/ether 48:5b:39:bd:fe:a2 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::4a5b:39ff:febd:fea2/64 scope link
       valid_lft forever preferred_lft forever
27: mon.wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq
state UNKNOWN qlen 1000
    link/ieee802.11/radiotap 48:5b:39:bd:fe:a2 brd ff:ff:ff:ff:ff:ff

---------------------------------------------------------------

(slightly edited for email)
# brctl show
bridge name	bridge id		STP enabled	interfaces
green0		8000.485b39bdfea2	no		vnet1, wlan0
red0		8000.002354167482	no		eth0, vnet0

---------------------------------------------------------------

(minimal version... the one i tweaked based on defaults had same results)
# cat /etc/hostapd/hostapd.conf
interface=wlan0
bridge=green0
logger_stdout=-1
logger_stdout_level=0
ssid=MySSID
hw_mode=g
channel=8
wpa=2
wpa_passphrase=wifipass
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP

---------------------------------------------------------------

# hostapd -dd /etc/hostapd/hostapd.conf
Configuration file: /etc/hostapd/hostapd.conf
nl80211: Add own interface ifindex 5
nl80211: Add own interface ifindex 18
nl80211: New interface mon.wlan0 created: ifindex=24
nl80211: Add own interface ifindex 24
nl80211: Adding interface wlan0 into bridge green0
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=19 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=19 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=19 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=19 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=19 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=17 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=17 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=17 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=17 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=17 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=15 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=19 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=19 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=19 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=19 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=19 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=17 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=17 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=17 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=17 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=17 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=15 dBm
RATE[0] rate=10 flags=0x1
RATE[1] rate=20 flags=0x1
RATE[2] rate=55 flags=0x1
RATE[3] rate=110 flags=0x1
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Completing interface initialization
Mode: IEEE 802.11g  Channel: 8  Frequency: 2447 MHz
Flushing old station entries
Deauthenticate all stations
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=(nil) key_idx=0
set_tx=1 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=(nil) key_idx=1
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=(nil) key_idx=2
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=(nil) key_idx=3
set_tx=0 seq_len=0 key_len=0
Using interface wlan0 with hwaddr 48:5b:39:bd:fe:a2 and ssid 'MySSID'
Deriving WPA PSK based on passphrase
SSID - hexdump_ascii(len=6):
     4d 79 53 53 49 44                                 MySSID
PSK (ASCII passphrase) - hexdump_ascii(len=8): [REMOVED]
PSK (from passphrase) - hexdump(len=32): [REMOVED]
WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=16): [REMOVED]
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
wpa_driver_nl80211_set_key: ifindex=18 alg=3 addr=(nil) key_idx=1
set_tx=1 seq_len=0 key_len=16
nl80211: Set beacon (beacon_set=0)
wlan0: Setup of interface done.
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x1102 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 5 for bridge green0
nl80211: Add own interface ifindex 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11143 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11143 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 5 for bridge green0
nl80211: Add own interface ifindex 5
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for our SSID
mgmt::proberesp cb
mgmt::auth
authentication: STA=b4:07:f9:e3:1d:5c auth_alg=0 auth_transaction=1
status_code=0 wep=0
  New STA
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.11: authentication OK (open system)
wlan0: STA b4:07:f9:e3:1d:5c MLME:
MLME-AUTHENTICATE.indication(b4:07:f9:e3:1d:5c, OPEN_SYSTEM)
wlan0: STA b4:07:f9:e3:1d:5c MLME: MLME-DELETEKEYS.request(b4:07:f9:e3:1d:5c)
authentication reply: STA=b4:07:f9:e3:1d:5c auth_alg=0
auth_transaction=2 resp=0 (IE len=0)
mgmt::assoc_req
association request: STA=b4:07:f9:e3:1d:5c capab_info=0x431 listen_interval=10
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
  new AID 1
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.11: association OK (aid 1)
mgmt::auth cb
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.11: authenticated
mgmt::assoc_resp cb
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.11: associated (aid 1)
wlan0: STA b4:07:f9:e3:1d:5c MLME: MLME-ASSOCIATE.indication(b4:07:f9:e3:1d:5c)
wlan0: STA b4:07:f9:e3:1d:5c MLME: MLME-DELETEKEYS.request(b4:07:f9:e3:1d:5c)
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c WPA: event 1 notification
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c WPA: start authentication
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.1X: unauthorizing port
WPA: b4:07:f9:e3:1d:5c WPA_PTK_GROUP entering state IDLE
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state AUTHENTICATION
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state AUTHENTICATION2
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state INITPSK
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state PTKSTART
wlan0: STA b4:07:f9:e3:1d:5c WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
nl80211: Event message available
nl80211: Ignored unknown event (cmd=19)
IEEE 802.1X: b4:07:f9:e3:1d:5c TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 121 bytes from b4:07:f9:e3:1d:5c
   IEEE 802.1X: version=1 type=3 length=117
wlan0: STA b4:07:f9:e3:1d:5c WPA: received EAPOL-Key frame (2/4 Pairwise)
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=48:5b:39:bd:fe:a2 A2=b4:07:f9:e3:1d:5c
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state PTKINITNEGOTIATING
wlan0: STA b4:07:f9:e3:1d:5c WPA: sending 3/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=1 pairwise=8
kde_len=46 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=56): [REMOVED]
IEEE 802.1X: b4:07:f9:e3:1d:5c TX status - version=2 type=3 length=151 - ack=1
IEEE 802.1X: 99 bytes from b4:07:f9:e3:1d:5c
   IEEE 802.1X: version=1 type=3 length=95
wlan0: STA b4:07:f9:e3:1d:5c WPA: received EAPOL-Key frame (4/4 Pairwise)
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state PTKINITDONE
wpa_driver_nl80211_set_key: ifindex=18 alg=3 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=16
   addr=b4:07:f9:e3:1d:5c
AP-STA-CONNECTED b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.1X: authorizing port
wlan0: STA b4:07:f9:e3:1d:5c RADIUS: starting accounting session
4D229FBB-00000000
wlan0: STA b4:07:f9:e3:1d:5c WPA: pairwise key handshake completed (RSN)
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
STA 00:23:15:1a:ea:dc sent probe request for broadcast SSID
mgmt::proberesp cb
STA 00:23:15:1a:ea:dc sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
STA 00:13:ce:77:8a:eb sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
STA 00:13:ce:77:8a:eb sent probe request for broadcast SSID
mgmt::proberesp cb
STA 00:13:ce:77:8a:eb sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
mgmt::disassoc
disassocation: STA=b4:07:f9:e3:1d:5c reason_code=8
AP-STA-DISCONNECTED b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c WPA: event 2 notification
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state DISCONNECTED
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.1X: unauthorizing port
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.11: disassociated
wlan0: STA b4:07:f9:e3:1d:5c MLME:
MLME-DISASSOCIATE.indication(b4:07:f9:e3:1d:5c, 8)
wlan0: STA b4:07:f9:e3:1d:5c MLME: MLME-DELETEKEYS.request(b4:07:f9:e3:1d:5c)
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
Sending deauthentication info to STA b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.11: deauthenticated due to inactivity
wlan0: STA b4:07:f9:e3:1d:5c MLME:
MLME-DEAUTHENTICATE.indication(b4:07:f9:e3:1d:5c, 2)
wlan0: STA b4:07:f9:e3:1d:5c MLME: MLME-DELETEKEYS.request(b4:07:f9:e3:1d:5c)
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA b4:07:f9:e3:1d:5c sent probe request for our SSID
mgmt::proberesp cb
mgmt::auth
authentication: STA=b4:07:f9:e3:1d:5c auth_alg=0 auth_transaction=1
status_code=0 wep=0
  New STA
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.11: authentication OK (open system)
wlan0: STA b4:07:f9:e3:1d:5c MLME:
MLME-AUTHENTICATE.indication(b4:07:f9:e3:1d:5c, OPEN_SYSTEM)
wlan0: STA b4:07:f9:e3:1d:5c MLME: MLME-DELETEKEYS.request(b4:07:f9:e3:1d:5c)
authentication reply: STA=b4:07:f9:e3:1d:5c auth_alg=0
auth_transaction=2 resp=0 (IE len=0)
mgmt::auth cb
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.11: authenticated
mgmt::assoc_req
association request: STA=b4:07:f9:e3:1d:5c capab_info=0x431 listen_interval=10
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
  new AID 1
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.11: association OK (aid 1)
mgmt::assoc_resp cb
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.11: associated (aid 1)
wlan0: STA b4:07:f9:e3:1d:5c MLME: MLME-ASSOCIATE.indication(b4:07:f9:e3:1d:5c)
wlan0: STA b4:07:f9:e3:1d:5c MLME: MLME-DELETEKEYS.request(b4:07:f9:e3:1d:5c)
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c WPA: event 1 notification
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c WPA: start authentication
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.1X: unauthorizing port
WPA: b4:07:f9:e3:1d:5c WPA_PTK_GROUP entering state IDLE
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state AUTHENTICATION
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state AUTHENTICATION2
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state INITPSK
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state PTKSTART
wlan0: STA b4:07:f9:e3:1d:5c WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
nl80211: Event message available
nl80211: Ignored unknown event (cmd=19)
IEEE 802.1X: b4:07:f9:e3:1d:5c TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 121 bytes from b4:07:f9:e3:1d:5c
   IEEE 802.1X: version=1 type=3 length=117
wlan0: STA b4:07:f9:e3:1d:5c WPA: received EAPOL-Key frame (2/4 Pairwise)
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=48:5b:39:bd:fe:a2 A2=b4:07:f9:e3:1d:5c
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state PTKINITNEGOTIATING
wlan0: STA b4:07:f9:e3:1d:5c WPA: sending 3/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=1 pairwise=8
kde_len=46 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=56): [REMOVED]
IEEE 802.1X: b4:07:f9:e3:1d:5c TX status - version=2 type=3 length=151 - ack=1
IEEE 802.1X: 99 bytes from b4:07:f9:e3:1d:5c
   IEEE 802.1X: version=1 type=3 length=95
wlan0: STA b4:07:f9:e3:1d:5c WPA: received EAPOL-Key frame (4/4 Pairwise)
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state PTKINITDONE
wpa_driver_nl80211_set_key: ifindex=18 alg=3 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=16
   addr=b4:07:f9:e3:1d:5c
AP-STA-CONNECTED b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.1X: authorizing port
wlan0: STA b4:07:f9:e3:1d:5c RADIUS: starting accounting session
4D229FBB-00000001
wlan0: STA b4:07:f9:e3:1d:5c WPA: pairwise key handshake completed (RSN)
...
...
(the STA will then disco in a couple seconds like above ...)
...
...
mgmt::disassoc
disassocation: STA=b4:07:f9:e3:1d:5c reason_code=8
AP-STA-DISCONNECTED b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c WPA: event 2 notification
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state DISCONNECTED
WPA: b4:07:f9:e3:1d:5c WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.1X: unauthorizing port
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.11: disassociated
wlan0: STA b4:07:f9:e3:1d:5c MLME:
MLME-DISASSOCIATE.indication(b4:07:f9:e3:1d:5c, 8)
wlan0: STA b4:07:f9:e3:1d:5c MLME: MLME-DELETEKEYS.request(b4:07:f9:e3:1d:5c)
wpa_driver_nl80211_set_key: ifindex=18 alg=0 addr=0x2051090 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=b4:07:f9:e3:1d:5c
Sending deauthentication info to STA b4:07:f9:e3:1d:5c
wlan0: STA b4:07:f9:e3:1d:5c IEEE 802.11: deauthenticated due to inactivity
wlan0: STA b4:07:f9:e3:1d:5c MLME:
MLME-DEAUTHENTICATE.indication(b4:07:f9:e3:1d:5c, 2)
wlan0: STA b4:07:f9:e3:1d:5c MLME: MLME-DELETEKEYS.request(b4:07:f9:e3:1d:5c)
...
...
(... and the whole thing repeats over and over because the STA never
receives a DHCP response, and the DHCP server never gets the
request... wtf yo?)
...
...
