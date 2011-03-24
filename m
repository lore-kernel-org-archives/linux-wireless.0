Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:44994 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934343Ab1CXXTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 19:19:40 -0400
Content-Type: text/plain; charset="utf-8"
Date: Fri, 25 Mar 2011 00:19:36 +0100
From: "Martin Knoll" <knoll.martin@gmx.at>
Message-ID: <20110324231936.302500@gmx.net>
MIME-Version: 1.0
Subject: WLAN connect problems: WPA: drop TX EAPOL in non-IEEE 802.1X mode
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello !

It´s a bit strange:
All this was working for years using opensuse 11.3

All the problems started when I set ssid to visible on ZyXEL.

Now I never come back to a stable working system.

Nearly every time I boot the system, I get no connection. When I do 'rcnetwork restart' it never works.
At the same time, my toshiba notebook gets wlan connect. It never had this problem (opensuse 11.4). But it´s wlan is not supported by kismet...

WLAN-Router: ZyXEL P-320W, Firmware V1.00(ZH.4)C0
  Configured SSID 'unsers' (visible), WPA2-PSK, Channel 7
  Just to avoid questions: Passphrase only with upper/lower ASCII-Chars
  and digits (no special chars or umlaute or something else)

opensuse 11.4 (patches until today 3/25/2011) kernel 2.6.37.1-1.2-desktop
  No NetworkManager, ifup configuration (but tested with NetworkManager
  with same problems)

WLAN device: D-LINK DWL-G122 C1

lsusb -v
--------------------------->8<------------------------------------

Bus 001 Device 003: ID 07d1:3c03 D-Link System AirPlus G DWL-G122 Wireless Adapter(rev.C1) [Ralink RT73]
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x07d1 D-Link System
  idProduct          0x3c03 AirPlus G DWL-G122 Wireless Adapter(rev.C1) [Ralink RT73]
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
--------------------------->8<------------------------------------


dmesg
--------------------------->8<------------------------------------
[    1.369855] usb 1-3: New USB device found, idVendor=07d1, idProduct=3c03
[    1.369858] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.369860] usb 1-3: Product: 802.11 bg WLAN
[    1.369861] usb 1-3: Manufacturer: Ralink
...
[   16.162492] r8169 0000:02:00.0: eth0: link up
[   16.162500] r8169 0000:02:00.0: eth0: link up
[   16.677741] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   16.742381] NET: Registered protocol family 17
[   17.491300] start_kdeinit (2460): /proc/2460/oom_adj is deprecated, please use /proc/2460/oom_score_adj instead.
[   18.334599] wlan0: authenticate with 00:13:49:3d:f2:a7 (try 1)
[   18.336121] wlan0: authenticated
[   18.397095] wlan0: associate with 00:13:49:3d:f2:a7 (try 1)
[   18.399122] wlan0: RX AssocResp from 00:13:49:3d:f2:a7 (capab=0x431 status=0 aid=1)
[   18.399126] wlan0: associated
[   18.411347] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   19.209050] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr,commit=0
[   20.092613] EXT4-fs (sda3): re-mounted. Opts: acl,user_xattr,commit=0
[   21.651266] wlan0: disassociated from 00:13:49:3d:f2:a7 (Reason: 3)
[   21.687772] cfg80211: Calling CRDA to update world regulatory domain
[   21.687851] wlan0: deauthenticating from 00:13:49:3d:f2:a7 by local choice (reason=3)
[   21.690935] cfg80211: World regulatory domain updated:
[   21.690937]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   21.690940]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   21.690942]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   21.690943]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   21.690945]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   21.690947]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.250791] wlan0: authenticate with 00:13:49:3d:f2:a7 (try 1)
[   23.263819] wlan0: authenticated
[   23.285377] wlan0: associate with 00:13:49:3d:f2:a7 (try 1)
[   23.287454] wlan0: RX ReassocResp from 00:13:49:3d:f2:a7 (capab=0x431 status=0 aid=1)
[   23.287461] wlan0: associated
[   26.801711] wlan0: disassociated from 00:13:49:3d:f2:a7 (Reason: 3)
[   26.837925] cfg80211: Calling CRDA to update world regulatory domain
[   26.838135] wlan0: deauthenticating from 00:13:49:3d:f2:a7 by local choice (reason=3)
[   26.844663] cfg80211: World regulatory domain updated:
[   26.844665]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   26.844667]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   26.844669]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   26.844671]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   26.844673]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   26.844674]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   28.406758] wlan0: authenticate with 00:13:49:3d:f2:a7 (try 1)
[   28.419785] wlan0: authenticated
[   28.441247] wlan0: associate with 00:13:49:3d:f2:a7 (try 1)
[   28.443265] wlan0: RX ReassocResp from 00:13:49:3d:f2:a7 (capab=0x431 status=0 aid=1)
[   28.443269] wlan0: associated
--------------------------->8<------------------------------------

wpa_supplicant.log
--------------------------->8<------------------------------------
1300902024.976488: EAPOL: Supplicant port status: Unauthorized
1300902025.152014: nl80211: Event message available
1300902025.152095: nl80211: New scan results available
1300902025.152209: Received scan results (4 BSSes)
1300902025.152245: BSS: Start scan result update 5
1300902025.152281: New scan results available
1300902025.152311: WPS: attr type=0x104a len=1
1300902025.152335: WPS: attr type=0x1044 len=1
1300902025.152351: WPS: attr type=0x103b len=1
1300902025.152369: WPS: attr type=0x1047 len=16
1300902025.152384: WPS: attr type=0x1021 len=24
1300902025.152401: WPS: attr type=0x1023 len=24
1300902025.152417: WPS: attr type=0x1024 len=8
1300902025.152477: WPS: attr type=0x1042 len=10
1300902025.152495: WPS: attr type=0x1054 len=8
1300902025.152511: WPS: attr type=0x1011 len=23
1300902025.152528: WPS: attr type=0x1008 len=2
1300902025.152544: WPS: attr type=0x103c len=1
1300902025.152561: WPS: attr type=0x104a len=1
1300902025.152578: WPS: attr type=0x1044 len=1
1300902025.152595: WPS: attr type=0x103b len=1
1300902025.152646: WPS: attr type=0x1047 len=16
1300902025.152664: WPS: attr type=0x1021 len=24
1300902025.152693: WPS: attr type=0x1023 len=24
1300902025.152716: WPS: attr type=0x1024 len=8
1300902025.152732: WPS: attr type=0x1042 len=10
1300902025.152748: WPS: attr type=0x1054 len=8
1300902025.152765: WPS: attr type=0x1011 len=23
1300902025.152781: WPS: attr type=0x1008 len=2
1300902025.152797: WPS: attr type=0x103c len=1
1300902025.152818: Selecting BSS from priority group 0
1300902025.152840: Try to find WPA-enabled AP
1300902025.152876: 0: 00:13:49:3d:f2:a7 ssid='unsers' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
1300902025.152898:    skip - blacklisted
1300902025.152916: 1: 00:18:9b:6f:02:e0 ssid='UPC014643' wpa_ie_len=28 rsn_ie_len=24 caps=0x411
1300902025.152992:    skip - SSID mismatch
1300902025.153011: 2: 02:18:9b:6f:02:e1 ssid='' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
1300902025.153031:    skip - SSID mismatch
1300902025.153046: 3: 40:4a:03:03:48:56 ssid='ordi_wlan' wpa_ie_len=0 rsn_ie_len=20 caps=0xc31
1300902025.153066:    skip - SSID mismatch
1300902025.153082: Try to find non-WPA AP
1300902025.153097: 0: 00:13:49:3d:f2:a7 ssid='unsers' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
1300902025.153121:    skip - blacklisted
1300902025.153138: 1: 00:18:9b:6f:02:e0 ssid='UPC014643' wpa_ie_len=28 rsn_ie_len=24 caps=0x411
1300902025.153167:    skip - SSID mismatch
1300902025.153206: 2: 02:18:9b:6f:02:e1 ssid='' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
1300902025.153228:    skip - SSID mismatch
1300902025.153244: 3: 40:4a:03:03:48:56 ssid='ordi_wlan' wpa_ie_len=0 rsn_ie_len=20 caps=0xc31
1300902025.153269:    skip - SSID mismatch
1300902025.153285: No APs found - clear blacklist and try again
1300902025.153302: Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
1300902025.153321: Removed BSSID 00:13:49:3d:f2:a7 from blacklist (clear)
1300902025.153339: Selecting BSS from priority group 0
1300902025.153358: Try to find WPA-enabled AP
1300902025.153374: 0: 00:13:49:3d:f2:a7 ssid='unsers' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
1300902025.153401:    selected based on RSN IE
1300902025.153419:    selected WPA AP 00:13:49:3d:f2:a7 ssid='unsers'
1300902025.153488: Automatic auth_alg selection: 0x1
1300902025.153514: RSN: using IEEE 802.11i/D9.0
1300902025.153536: WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
1300902025.153565: WPA: clearing AP WPA IE
1300902025.153582: WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902025.153617: WPA: using GTK CCMP
1300902025.153637: WPA: using PTK CCMP
1300902025.153660: WPA: using KEY_MGMT WPA-PSK
1300902025.153677: WPA: not using MGMT group cipher
1300902025.153717: WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902025.153752: Cancelling scan request
1300902025.153776: Trying to authenticate with 00:13:49:3d:f2:a7 (SSID='unsers' freq=2437 MHz)
1300902025.153798: No keys have been configured - skip key clearing
1300902025.153814: State: SCANNING -> AUTHENTICATING
1300902025.153832: EAPOL: External notification - EAP success=0
1300902025.153866: EAPOL: Supplicant port status: Unauthorized
1300902025.153960: EAPOL: External notification - EAP fail=0
1300902025.154011: EAPOL: Supplicant port status: Unauthorized
1300902025.154062: EAPOL: External notification - portControl=Auto
1300902025.154088: EAPOL: Supplicant port status: Unauthorized
1300902025.154153: nl80211: Authenticate (ifindex=3)
1300902025.154179:   * bssid=00:13:49:3d:f2:a7
1300902025.154220:   * freq=2437
1300902025.154238:   * SSID - hexdump_ascii(len=6):
     75 6e 73 65 72 73                                 unsers          
1300902025.154275:   * IEs - hexdump(len=0): [NULL]
1300902025.154298:   * Auth Type 0
1300902025.154343: nl80211: Authentication request send successfully
1300902025.154383: RTM_NEWLINK: operstate=0 ifi_flags=0x1103 ([UP])
1300902025.154409: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902025.184710: nl80211: Event message available
1300902025.184845: nl80211: MLME event 37
1300902025.184898: nl80211: MLME event frame - hexdump(len=30): b0 00 30 01 00 1b 11 c6 67 45 00 13 49 3d f2 a7 00 13 49 3d f2 a7 80 95 00 00 02 00 00 00
1300902025.184942: SME: Authentication response: peer=00:13:49:3d:f2:a7 auth_type=0 status_code=0
1300902025.184962: SME: Authentication response IEs - hexdump(len=0): [NULL]
1300902025.184986: Trying to associate with 00:13:49:3d:f2:a7 (SSID='unsers' freq=2437 MHz)
1300902025.185003: State: AUTHENTICATING -> ASSOCIATING
1300902025.185019: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1300902025.185036: netlink: Operstate: linkmode=-1, operstate=5
1300902025.185066: WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902025.185101: nl80211: Associate (ifindex=3)
1300902025.185121:   * bssid=00:13:49:3d:f2:a7
1300902025.185139:   * freq=2437
1300902025.185153:   * SSID - hexdump_ascii(len=6):
     75 6e 73 65 72 73                                 unsers          
1300902025.185182:   * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902025.185210:   * prev_bssid=00:13:49:3d:f2:a7
1300902025.195696: nl80211: Association request send successfully
1300902025.209317: nl80211: Event message available
1300902025.209415: nl80211: Ignored unknown event (cmd=19)
1300902025.222004: nl80211: Event message available
1300902025.222107: nl80211: MLME event 38
1300902025.222128: nl80211: MLME event frame - hexdump(len=46): 30 00 30 01 00 1b 11 c6 67 45 00 13 49 3d f2 a7 00 13 49 3d f2 a7 90 95 31 04 00 00 02 c0 01 04 82 84 8b 96 32 08 0c 12 18 24 30 48 60 6c
1300902025.222175: Association info event
1300902025.222192: resp_ies - hexdump(len=16): 01 04 82 84 8b 96 32 08 0c 12 18 24 30 48 60 6c
1300902025.222221: freq=2437 MHz
1300902025.222238: State: ASSOCIATING -> ASSOCIATED
1300902025.222254: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1300902025.222272: netlink: Operstate: linkmode=-1, operstate=5
1300902025.222307: Associated to a new BSS: BSSID=00:13:49:3d:f2:a7
1300902025.222340: No keys have been configured - skip key clearing
1300902025.222362: Associated with 00:13:49:3d:f2:a7
1300902025.222378: WPA: Association event - clear replay counter
1300902025.222392: WPA: Clear old PTK
1300902025.222408: EAPOL: External notification - portEnabled=0
1300902025.222425: EAPOL: Supplicant port status: Unauthorized
1300902025.222501: EAPOL: External notification - portValid=0
1300902025.222530: EAPOL: Supplicant port status: Unauthorized
1300902025.222583: EAPOL: External notification - EAP success=0
1300902025.222603: EAPOL: Supplicant port status: Unauthorized
1300902025.222649: EAPOL: External notification - portEnabled=1
1300902025.222702: EAPOL: SUPP_PAE entering state CONNECTING
1300902025.222720: EAPOL: SUPP_BE entering state IDLE
1300902025.222739: Setting authentication timeout: 10 sec 0 usec
1300902025.222764: Cancelling scan request
1300902025.222787: RTM_NEWLINK: operstate=0 ifi_flags=0x11103 ([UP][LOWER_UP])
1300902025.222812: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902025.222837: RTM_NEWLINK: operstate=0 ifi_flags=0x11103 ([UP][LOWER_UP])
1300902025.222889: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902025.222913: RTM_NEWLINK: operstate=0 ifi_flags=0x11103 ([UP][LOWER_UP])
1300902025.222932: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902025.222958: nl80211: Event message available
1300902025.222993: nl80211: Ignore connect event (cmd=46) when using userspace SME
1300902025.977318: EAPOL: startWhen --> 0
1300902025.977386: EAPOL: disable timer tick
1300902025.977405: EAPOL: SUPP_PAE entering state CONNECTING
1300902025.977422: EAPOL: enable timer tick
1300902025.977439: EAPOL: txStart
1300902025.977454: WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
1300902028.728150: RTM_NEWLINK: operstate=0 ifi_flags=0x1103 ([UP])
1300902028.728242: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902028.759749: nl80211: Event message available
1300902028.759895: nl80211: MLME event 40
1300902028.759949: nl80211: MLME event frame - hexdump(len=26): a0 00 30 01 00 1b 11 c6 67 45 00 13 49 3d f2 a7 00 13 49 3d f2 a7 d0 97 03 00
1300902028.759989: Disassociation notification
1300902028.760006: SME: Disassociation event received
1300902028.760021: SME: Deauthenticate to clear driver state
1300902028.760036: wpa_driver_nl80211_deauthenticate
1300902028.760147: Setting scan request: 0 sec 100000 usec
1300902028.760179: Added BSSID 00:13:49:3d:f2:a7 into blacklist
1300902028.760204: CTRL-EVENT-DISCONNECTED bssid=00:13:49:3d:f2:a7 reason=3
1300902028.760222: Disconnect event - remove keys
1300902028.760268: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=0 set_tx=0 seq_len=0 key_len=0
1300902028.760335: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=1 set_tx=0 seq_len=0 key_len=0
1300902028.760427: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=2 set_tx=0 seq_len=0 key_len=0
1300902028.760494: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=3 set_tx=0 seq_len=0 key_len=0
1300902028.760552: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=4 set_tx=0 seq_len=0 key_len=0
1300902028.760608: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=5 set_tx=0 seq_len=0 key_len=0
1300902028.760669: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x6afff0 key_idx=0 set_tx=0 seq_len=0 key_len=0
1300902028.760693:    addr=00:13:49:3d:f2:a7
1300902028.760727: State: ASSOCIATED -> DISCONNECTED
1300902028.760746: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1300902028.760763: netlink: Operstate: linkmode=-1, operstate=5
1300902028.760787: EAPOL: External notification - portEnabled=0
1300902028.760804: EAPOL: SUPP_PAE entering state DISCONNECTED
1300902028.760818: EAPOL: Supplicant port status: Unauthorized
1300902028.760919: EAPOL: SUPP_BE entering state INITIALIZE
1300902028.760944: EAPOL: Supplicant port status: Unauthorized
1300902028.760991: EAPOL: External notification - portValid=0
1300902028.761019: EAPOL: Supplicant port status: Unauthorized
1300902028.761067: EAPOL: External notification - EAP success=0
1300902028.761096: EAPOL: Supplicant port status: Unauthorized
1300902028.761150: nl80211: Event message available
1300902028.761188: nl80211: Ignore disconnect event when using userspace SME
1300902028.761218: RTM_NEWLINK: operstate=0 ifi_flags=0x1103 ([UP])
1300902028.761238: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902028.761264: nl80211: Event message available
1300902028.761298: nl80211: MLME event 39
1300902028.761316: nl80211: MLME event frame - hexdump(len=26): c0 00 00 00 00 13 49 3d f2 a7 00 1b 11 c6 67 45 00 13 49 3d f2 a7 00 00 03 00
1300902028.761354: Deauthentication notification
1300902028.761371: Added BSSID 00:00:00:00:00:00 into blacklist
1300902028.761427: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
1300902028.761444: Disconnect event - remove keys
1300902028.761472: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=0 set_tx=0 seq_len=0 key_len=0
1300902028.761526: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=1 set_tx=0 seq_len=0 key_len=0
1300902028.761578: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=2 set_tx=0 seq_len=0 key_len=0
1300902028.761627: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=3 set_tx=0 seq_len=0 key_len=0
1300902028.761678: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=4 set_tx=0 seq_len=0 key_len=0
1300902028.761726: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=5 set_tx=0 seq_len=0 key_len=0
1300902028.761775: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x6afff0 key_idx=0 set_tx=0 seq_len=0 key_len=0
1300902028.761799:    addr=00:00:00:00:00:00
1300902028.761832: State: DISCONNECTED -> DISCONNECTED
1300902028.762132: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1300902028.762216: netlink: Operstate: linkmode=-1, operstate=5
1300902028.762289: EAPOL: External notification - portEnabled=0
1300902028.762372: EAPOL: Supplicant port status: Unauthorized
1300902028.762488: EAPOL: External notification - portValid=0
1300902028.762509: EAPOL: Supplicant port status: Unauthorized
1300902028.762557: EAPOL: External notification - EAP success=0
1300902028.762576: EAPOL: Supplicant port status: Unauthorized
1300902028.860301: State: DISCONNECTED -> SCANNING
1300902028.860360: Starting AP scan for wildcard SSID
1300902028.860396: nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
1300902028.882232: Scan requested (ret=0) - scan timeout 30 seconds
1300902028.882295: nl80211: Event message available
1300902028.882331: nl80211: Scan trigger
1300902028.979728: EAPOL: Supplicant port status: Unauthorized
1300902029.979889: EAPOL: Supplicant port status: Unauthorized
1300902030.005919: nl80211: Event message available
1300902030.005958: nl80211: Scan aborted
1300902030.064084: Received scan results (4 BSSes)
1300902030.064176: BSS: Start scan result update 6
1300902030.064208: New scan results available
1300902030.064240: WPS: attr type=0x104a len=1
1300902030.064264: WPS: attr type=0x1044 len=1
1300902030.064284: WPS: attr type=0x103b len=1
1300902030.064304: WPS: attr type=0x1047 len=16
1300902030.064323: WPS: attr type=0x1021 len=24
1300902030.064343: WPS: attr type=0x1023 len=24
1300902030.064362: WPS: attr type=0x1024 len=8
1300902030.064381: WPS: attr type=0x1042 len=10
1300902030.064400: WPS: attr type=0x1054 len=8
1300902030.064419: WPS: attr type=0x1011 len=23
1300902030.064439: WPS: attr type=0x1008 len=2
1300902030.064459: WPS: attr type=0x103c len=1
1300902030.064479: WPS: attr type=0x104a len=1
1300902030.064498: WPS: attr type=0x1044 len=1
1300902030.064517: WPS: attr type=0x103b len=1
1300902030.064535: WPS: attr type=0x1047 len=16
1300902030.064555: WPS: attr type=0x1021 len=24
1300902030.064574: WPS: attr type=0x1023 len=24
1300902030.064593: WPS: attr type=0x1024 len=8
1300902030.064612: WPS: attr type=0x1042 len=10
1300902030.064630: WPS: attr type=0x1054 len=8
1300902030.064678: WPS: attr type=0x1011 len=23
1300902030.064698: WPS: attr type=0x1008 len=2
1300902030.064721: WPS: attr type=0x103c len=1
1300902030.064746: Selecting BSS from priority group 0
1300902030.064766: Try to find WPA-enabled AP
1300902030.064785: 0: 00:13:49:3d:f2:a7 ssid='unsers' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
1300902030.064817:    selected based on RSN IE
1300902030.064837:    selected WPA AP 00:13:49:3d:f2:a7 ssid='unsers'
1300902030.064910: Automatic auth_alg selection: 0x1
1300902030.064935: RSN: using IEEE 802.11i/D9.0
1300902030.064960: WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
1300902030.064978: WPA: clearing AP WPA IE
1300902030.064996: WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902030.065032: WPA: using GTK CCMP
1300902030.065049: WPA: using PTK CCMP
1300902030.065065: WPA: using KEY_MGMT WPA-PSK
1300902030.065083: WPA: not using MGMT group cipher
1300902030.065099: WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902030.065136: Cancelling scan request
1300902030.065157: Trying to authenticate with 00:13:49:3d:f2:a7 (SSID='unsers' freq=2437 MHz)
1300902030.065173: No keys have been configured - skip key clearing
1300902030.065187: State: SCANNING -> AUTHENTICATING
1300902030.065203: EAPOL: External notification - EAP success=0
1300902030.065219: EAPOL: Supplicant port status: Unauthorized
1300902030.065297: EAPOL: External notification - EAP fail=0
1300902030.065317: EAPOL: Supplicant port status: Unauthorized
1300902030.065364: EAPOL: External notification - portControl=Auto
1300902030.065383: EAPOL: Supplicant port status: Unauthorized
1300902030.065444: nl80211: Authenticate (ifindex=3)
1300902030.065465:   * bssid=00:13:49:3d:f2:a7
1300902030.065482:   * freq=2437
1300902030.065498:   * SSID - hexdump_ascii(len=6):
     75 6e 73 65 72 73                                 unsers          
1300902030.065528:   * IEs - hexdump(len=0): [NULL]
1300902030.065545:   * Auth Type 0
1300902030.065620: nl80211: MLME command failed: ret=-100 (Network is down)
1300902030.065645: Authentication request to the driver failed
1300902030.065665: Setting scan request: 1 sec 0 usec
1300902030.065700: RTM_NEWLINK: operstate=0 ifi_flags=0x1102 ()
1300902030.065721: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902030.087978: CTRL-EVENT-TERMINATING - signal 15 received
1300902030.088015: Removing interface wlan0
1300902030.088026: No keys have been configured - skip key clearing
1300902030.088035: State: AUTHENTICATING -> DISCONNECTED
1300902030.088044: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1300902030.088081: netlink: Operstate: linkmode=-1, operstate=5
1300902030.088103: EAPOL: External notification - portEnabled=0
1300902030.088113: EAPOL: Supplicant port status: Unauthorized
1300902030.088162: EAPOL: External notification - portValid=0
1300902030.088172: EAPOL: Supplicant port status: Unauthorized
1300902030.088196: EAPOL: External notification - EAP success=0
1300902030.088206: EAPOL: Supplicant port status: Unauthorized
1300902030.088230: No keys have been configured - skip key clearing
1300902030.092106: Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
1300902030.092134: Removed BSSID 00:13:49:3d:f2:a7 from blacklist (clear)
1300902030.092141: BSS: Remove id 0 BSSID 00:13:49:3d:f2:a7 SSID 'unsers'
1300902030.092189: BSS: Remove id 2 BSSID 00:18:9b:6f:02:e0 SSID 'UPC014643'
1300902030.092199: BSS: Remove id 3 BSSID 02:18:9b:6f:02:e1 SSID ''
1300902030.092206: BSS: Remove id 1 BSSID 40:4a:03:03:48:56 SSID 'ordi_wlan'
1300902030.092215: Cancelling scan request
1300902030.092222: Cancelling authentication timeout
1300902030.092231: netlink: Operstate: linkmode=0, operstate=6
1300902367.632600: Initializing interface 'wlan0' conf '/var/run/wpa_supplicant-wlan0.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
1300902367.710542: Configuration file '/var/run/wpa_supplicant-wlan0.conf' -> '/var/run/wpa_supplicant-wlan0.conf'
1300902367.710557: Reading configuration file '/var/run/wpa_supplicant-wlan0.conf'
1300902367.710628: ctrl_interface='/var/run/wpa_supplicant'
1300902367.710643: ap_scan=1
1300902367.710651: Line: 3 - start of a new network block
1300902367.710666: scan_ssid=0 (0x0)
1300902367.710680: ssid - hexdump_ascii(len=6):
     75 6e 73 65 72 73                                 unsers          
1300902367.710702: key_mgmt: 0x2
1300902367.710711: PSK (ASCII passphrase) - hexdump_ascii(len=11): [REMOVED]
1300902367.725875: PSK (from passphrase) - hexdump(len=32): [REMOVED]
1300902367.725903: Priority group 0
1300902367.725909:    id=0 ssid='unsers'
1300902367.728888: netlink: Operstate: linkmode=1, operstate=5
1300902367.759373: Own MAC address: 00:1b:11:c6:67:45
1300902367.759403: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=0 set_tx=0 seq_len=0 key_len=0
1300902367.759442: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=1 set_tx=0 seq_len=0 key_len=0
1300902367.759460: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=2 set_tx=0 seq_len=0 key_len=0
1300902367.759475: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=3 set_tx=0 seq_len=0 key_len=0
1300902367.759490: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=4 set_tx=0 seq_len=0 key_len=0
1300902367.759505: wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x4793fe key_idx=5 set_tx=0 seq_len=0 key_len=0
1300902367.759516: RSN: flushing PMKID list in the driver
1300902367.759529: Setting scan request: 0 sec 100000 usec
1300902367.759543: WPS: UUID based on MAC address - hexdump(len=16): 97 10 d4 da 71 cb 53 de 82 40 9e 62 00 57 6a 5e
1300902367.761374: EAPOL: SUPP_PAE entering state DISCONNECTED
1300902367.761385: EAPOL: Supplicant port status: Unauthorized
1300902367.761413: EAPOL: KEY_RX entering state NO_KEY_RECEIVE
1300902367.761420: EAPOL: SUPP_BE entering state INITIALIZE
1300902367.761425: EAP: EAP entering state DISABLED
1300902367.761430: EAPOL: Supplicant port status: Unauthorized
1300902367.761456: EAPOL: Supplicant port status: Unauthorized
1300902367.761488: Using existing control interface directory.
1300902367.761525: Added interface wlan0
1300902367.761541: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1300902367.761549: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902367.859655: State: DISCONNECTED -> SCANNING
1300902367.859675: Starting AP scan for wildcard SSID
1300902367.859691: nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
1300902367.870465: Scan requested (ret=0) - scan timeout 10 seconds
1300902367.870477: nl80211: Event message available
1300902367.870486: nl80211: Scan trigger
1300902368.762379: EAPOL: disable timer tick
1300902368.762398: EAPOL: Supplicant port status: Unauthorized
1300902369.311416: nl80211: Event message available
1300902369.311455: nl80211: New scan results available
1300902369.312387: Received scan results (6 BSSes)
1300902369.312405: BSS: Start scan result update 1
1300902369.312430: BSS: Add new id 0 BSSID 00:13:49:3d:f2:a7 SSID 'unsers'
1300902369.312439: BSS: Add new id 1 BSSID 00:18:9b:6f:02:e0 SSID 'UPC014643'
1300902369.312445: BSS: Add new id 2 BSSID 02:18:9b:6f:02:e1 SSID ''
1300902369.312452: BSS: Add new id 3 BSSID 02:24:d1:73:00:c5 SSID ''
1300902369.312457: BSS: Add new id 4 BSSID 00:24:d1:73:00:c4 SSID 'UPC012257'
1300902369.312463: BSS: Add new id 5 BSSID 40:4a:03:03:48:56 SSID 'ordi_wlan'
1300902369.312470: New scan results available
1300902369.312479: WPS: attr type=0x104a len=1
1300902369.312485: WPS: attr type=0x1044 len=1
1300902369.312489: WPS: attr type=0x103b len=1
1300902369.312493: WPS: attr type=0x1047 len=16
1300902369.312497: WPS: attr type=0x1021 len=24
1300902369.312501: WPS: attr type=0x1023 len=24
1300902369.312504: WPS: attr type=0x1024 len=8
1300902369.312508: WPS: attr type=0x1042 len=10
1300902369.312512: WPS: attr type=0x1054 len=8
1300902369.312515: WPS: attr type=0x1011 len=23
1300902369.312519: WPS: attr type=0x1008 len=2
1300902369.312523: WPS: attr type=0x103c len=1
1300902369.312526: WPS: attr type=0x104a len=1
1300902369.312530: WPS: attr type=0x1044 len=1
1300902369.312533: WPS: attr type=0x103b len=1
1300902369.312537: WPS: attr type=0x1047 len=16
1300902369.312541: WPS: attr type=0x1021 len=24
1300902369.312544: WPS: attr type=0x1023 len=24
1300902369.312547: WPS: attr type=0x1024 len=8
1300902369.312551: WPS: attr type=0x1042 len=10
1300902369.312555: WPS: attr type=0x1054 len=8
1300902369.312558: WPS: attr type=0x1011 len=23
1300902369.312561: WPS: attr type=0x1008 len=2
1300902369.312565: WPS: attr type=0x103c len=1
1300902369.312571: Selecting BSS from priority group 0
1300902369.312575: Try to find WPA-enabled AP
1300902369.312580: 0: 00:13:49:3d:f2:a7 ssid='unsers' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
1300902369.312587:    selected based on RSN IE
1300902369.312591:    selected WPA AP 00:13:49:3d:f2:a7 ssid='unsers'
1300902369.312598: Automatic auth_alg selection: 0x1
1300902369.312605: RSN: using IEEE 802.11i/D9.0
1300902369.312609: WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
1300902369.312614: WPA: clearing AP WPA IE
1300902369.312618: WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902369.312625: WPA: using GTK CCMP
1300902369.312629: WPA: using PTK CCMP
1300902369.312633: WPA: using KEY_MGMT WPA-PSK
1300902369.312638: WPA: not using MGMT group cipher
1300902369.312642: WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902369.312650: Cancelling scan request
1300902369.312655: Trying to authenticate with 00:13:49:3d:f2:a7 (SSID='unsers' freq=2437 MHz)
1300902369.312667: No keys have been configured - skip key clearing
1300902369.312672: State: SCANNING -> AUTHENTICATING
1300902369.312676: EAPOL: External notification - EAP success=0
1300902369.312681: EAPOL: Supplicant port status: Unauthorized
1300902369.312710: EAPOL: External notification - EAP fail=0
1300902369.312715: EAPOL: Supplicant port status: Unauthorized
1300902369.312729: EAPOL: External notification - portControl=Auto
1300902369.312743: EAPOL: Supplicant port status: Unauthorized
1300902369.312764: nl80211: Authenticate (ifindex=3)
1300902369.312770:   * bssid=00:13:49:3d:f2:a7
1300902369.312774:   * freq=2437
1300902369.312778:   * SSID - hexdump_ascii(len=6):
     75 6e 73 65 72 73                                 unsers          
1300902369.312787:   * IEs - hexdump(len=0): [NULL]
1300902369.312791:   * Auth Type 0
1300902369.312805: nl80211: Authentication request send successfully
1300902369.312827: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
1300902369.312833: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902369.351695: nl80211: Event message available
1300902369.351724: nl80211: MLME event 37
1300902369.351729: nl80211: MLME event frame - hexdump(len=30): b0 00 30 01 00 1b 11 c6 67 45 00 13 49 3d f2 a7 00 13 49 3d f2 a7 90 69 00 00 02 00 00 00
1300902369.351738: SME: Authentication response: peer=00:13:49:3d:f2:a7 auth_type=0 status_code=0
1300902369.351743: SME: Authentication response IEs - hexdump(len=0): [NULL]
1300902369.351751: Trying to associate with 00:13:49:3d:f2:a7 (SSID='unsers' freq=2437 MHz)
1300902369.351755: State: AUTHENTICATING -> ASSOCIATING
1300902369.351760: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1300902369.351764: netlink: Operstate: linkmode=-1, operstate=5
1300902369.351775: WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902369.351785: nl80211: Associate (ifindex=3)
1300902369.351790:   * bssid=00:13:49:3d:f2:a7
1300902369.351795:   * freq=2437
1300902369.351799:   * SSID - hexdump_ascii(len=6):
     75 6e 73 65 72 73                                 unsers          
1300902369.351806:   * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902369.381450: nl80211: Association request send successfully
1300902369.415238: nl80211: Event message available
1300902369.429849: nl80211: Ignored unknown event (cmd=19)
1300902369.429888: nl80211: Event message available
1300902369.429912: nl80211: MLME event 38
1300902369.429930: nl80211: MLME event frame - hexdump(len=46): 10 00 30 01 00 1b 11 c6 67 45 00 13 49 3d f2 a7 00 13 49 3d f2 a7 b0 69 31 04 00 00 02 c0 01 04 82 84 8b 96 32 08 0c 12 18 24 30 48 60 6c
1300902369.429973: Association info event
1300902369.429988: resp_ies - hexdump(len=16): 01 04 82 84 8b 96 32 08 0c 12 18 24 30 48 60 6c
1300902369.430012: freq=2437 MHz
1300902369.430028: State: ASSOCIATING -> ASSOCIATED
1300902369.430044: wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
1300902369.430062: netlink: Operstate: linkmode=-1, operstate=5
1300902369.430100: Associated to a new BSS: BSSID=00:13:49:3d:f2:a7
1300902369.430119: No keys have been configured - skip key clearing
1300902369.430139: Associated with 00:13:49:3d:f2:a7
1300902369.430155: WPA: Association event - clear replay counter
1300902369.430178: WPA: Clear old PTK
1300902369.430194: EAPOL: External notification - portEnabled=0
1300902369.430210: EAPOL: Supplicant port status: Unauthorized
1300902369.430304: EAPOL: External notification - portValid=0
1300902369.430325: EAPOL: Supplicant port status: Unauthorized
1300902369.430399: EAPOL: External notification - EAP success=0
1300902369.430422: EAPOL: Supplicant port status: Unauthorized
1300902369.430472: EAPOL: External notification - portEnabled=1
1300902369.430492: EAPOL: SUPP_PAE entering state CONNECTING
1300902369.430506: EAPOL: enable timer tick
1300902369.430522: EAPOL: SUPP_BE entering state IDLE
1300902369.430542: Setting authentication timeout: 10 sec 0 usec
1300902369.430560: Cancelling scan request
1300902369.430581: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1300902369.430601: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902369.430621: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1300902369.430639: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902369.430657: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1300902369.430675: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902369.430713: nl80211: Event message available
1300902369.430737: nl80211: Ignore connect event (cmd=46) when using userspace SME
1300902369.589990: RX EAPOL from 00:13:49:3d:f2:a7
1300902369.590040: RX EAPOL - hexdump(len=99): 01 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 01 4e d8 75 ab 1a 8e 3b 92 d8 ee 34 42 16 4e b7 fe c2 a3 de 10 e3 27 eb ce ef 2e dc 84 4d 98 cf 32 b5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1300902369.590110: Setting authentication timeout: 10 sec 0 usec
1300902369.590129: IEEE 802.1X RX: version=1 type=3 length=95
1300902369.590144:   EAPOL-Key type=2
1300902369.590163:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
1300902369.590179:   key_length=16 key_data_length=0
1300902369.590192:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 01 4e
1300902369.590209:   key_nonce - hexdump(len=32): d8 75 ab 1a 8e 3b 92 d8 ee 34 42 16 4e b7 fe c2 a3 de 10 e3 27 eb ce ef 2e dc 84 4d 98 cf 32 b5
1300902369.590236:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1300902369.590257:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
1300902369.590273:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1300902369.590289:   key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1300902369.590313: WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 01 4e d8 75 ab 1a 8e 3b 92 d8 ee 34 42 16 4e b7 fe c2 a3 de 10 e3 27 eb ce ef 2e dc 84 4d 98 cf 32 b5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1300902369.590404: State: ASSOCIATED -> 4WAY_HANDSHAKE
1300902369.590418: WPA: RX message 1 of 4-Way Handshake from 00:13:49:3d:f2:a7 (ver=2)
1300902369.590434: RSN: msg 1/4 key data - hexdump(len=0):
1300902369.592143: WPA: Renewed SNonce - hexdump(len=32): 95 39 5f 86 2d e9 1b 44 47 97 ce 5c 17 6a da 25 1e e1 d8 a4 1f 37 83 aa de 2a dd fb 6f 2c 89 d8
1300902369.592209: WPA: PTK derivation - A1=00:1b:11:c6:67:45 A2=00:13:49:3d:f2:a7
1300902369.592227: WPA: PMK - hexdump(len=32): [REMOVED]
1300902369.592241: WPA: PTK - hexdump(len=48): [REMOVED]
1300902369.592254: WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902369.592285: WPA: Sending EAPOL-Key 2/4
1300902369.592304: WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 01 4e 95 39 5f 86 2d e9 1b 44 47 97 ce 5c 17 6a da 25 1e e1 d8 a4 1f 37 83 aa de 2a dd fb 6f 2c 89 d8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a4 f8 b9 52 60 dc cb e5 4c 5b 5b e7 85 16 49 16 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902369.618572: RX EAPOL from 00:13:49:3d:f2:a7
1300902369.618611: RX EAPOL - hexdump(len=155): 01 03 00 97 02 13 ca 00 10 00 00 00 00 00 00 01 4f d8 75 ab 1a 8e 3b 92 d8 ee 34 42 16 4e b7 fe c2 a3 de 10 e3 27 eb ce ef 2e dc 84 4d 98 cf 32 b5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 82 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3e 68 43 7b 7f 8d 42 e9 58 3b 53 0f 43 60 8b 23 00 38 88 59 bc bf 56 a7 fb 13 17 13 58 06 a0 68 c8 23 9b d1 70 8c 4c 6d 96 f0 10 10 d8 87 ef 04 c1 d9 b8 31 14 ea 49 9c eb 4d 6d 02 45 a0 68 78 70 e1 02 a1 e3 0e 3f e5 86 fb
1300902369.618700: IEEE 802.1X RX: version=1 type=3 length=151
1300902369.618714:   EAPOL-Key type=2
1300902369.618726:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
1300902369.618743:   key_length=16 key_data_length=56
1300902369.618755:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 01 4f
1300902369.618772:   key_nonce - hexdump(len=32): d8 75 ab 1a 8e 3b 92 d8 ee 34 42 16 4e b7 fe c2 a3 de 10 e3 27 eb ce ef 2e dc 84 4d 98 cf 32 b5
1300902369.618799:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
1300902369.618820:   key_rsc - hexdump(len=8): 82 01 00 00 00 00 00 00
1300902369.618856:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
1300902369.618874:   key_mic - hexdump(len=16): 3e 68 43 7b 7f 8d 42 e9 58 3b 53 0f 43 60 8b 23
1300902369.618897: WPA: RX EAPOL-Key - hexdump(len=155): 01 03 00 97 02 13 ca 00 10 00 00 00 00 00 00 01 4f d8 75 ab 1a 8e 3b 92 d8 ee 34 42 16 4e b7 fe c2 a3 de 10 e3 27 eb ce ef 2e dc 84 4d 98 cf 32 b5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 82 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3e 68 43 7b 7f 8d 42 e9 58 3b 53 0f 43 60 8b 23 00 38 88 59 bc bf 56 a7 fb 13 17 13 58 06 a0 68 c8 23 9b d1 70 8c 4c 6d 96 f0 10 10 d8 87 ef 04 c1 d9 b8 31 14 ea 49 9c eb 4d 6d 02 45 a0 68 78 70 e1 02 a1 e3 0e 3f e5 86 fb
1300902369.619004: RSN: encrypted key data - hexdump(len=56): 88 59 bc bf 56 a7 fb 13 17 13 58 06 a0 68 c8 23 9b d1 70 8c 4c 6d 96 f0 10 10 d8 87 ef 04 c1 d9 b8 31 14 ea 49 9c eb 4d 6d 02 45 a0 68 78 70 e1 02 a1 e3 0e 3f e5 86 fb
1300902369.619098: WPA: decrypted EAPOL-Key key data - hexdump(len=48): [REMOVED]
1300902369.619114: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
1300902369.619127: WPA: RX message 3 of 4-Way Handshake from 00:13:49:3d:f2:a7 (ver=2)
1300902369.619142: WPA: IE KeyData - hexdump(len=48): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 16 00 0f ac 01 01 00 00 00 1c 0e 01 00 00 00 00 00 26 11 00 00 40 91 00 00
1300902369.619179: WPA: RSN IE in EAPOL-Key - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
1300902369.619206: WPA: GTK in EAPOL-Key - hexdump(len=24): [REMOVED]
1300902369.619219: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=2): 00 00
1300902369.619236: WPA: Sending EAPOL-Key 4/4
1300902369.619254: WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00 00 00 00 01 4f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2b 11 43 68 26 59 97 e1 79 af 74 2b b5 ef 24 bf 00 00
1300902369.619380: WPA: Installing PTK to the driver.
1300902369.619436: wpa_driver_nl80211_set_key: ifindex=3 alg=3 addr=0x6b3130 key_idx=0 set_tx=1 seq_len=6 key_len=16
1300902369.619468:    addr=00:13:49:3d:f2:a7
1300902369.621427: EAPOL: External notification - portValid=1
1300902369.621471: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
1300902369.621487: RSN: received GTK in pairwise handshake - hexdump(len=18): [REMOVED]
1300902369.621509: WPA: Group Key - hexdump(len=16): [REMOVED]
1300902369.621522: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=16).
1300902369.621536: WPA: RSC - hexdump(len=6): 82 01 00 00 00 00
1300902369.621589: wpa_driver_nl80211_set_key: ifindex=3 alg=3 addr=0x4793fe key_idx=1 set_tx=0 seq_len=6 key_len=16
1300902369.623392: WPA: Key negotiation completed with 00:13:49:3d:f2:a7 [PTK=CCMP GTK=CCMP]
1300902369.623420: Cancelling authentication timeout
1300902369.623435: State: GROUP_HANDSHAKE -> COMPLETED
1300902369.623454: CTRL-EVENT-CONNECTED - Connection to 00:13:49:3d:f2:a7 completed (auth) [id=0 id_str=]
1300902369.623467: wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
1300902369.623482: netlink: Operstate: linkmode=-1, operstate=6
1300902369.624683: EAPOL: External notification - portValid=1
1300902369.624714: EAPOL: External notification - EAP success=1
1300902369.624727: EAPOL: SUPP_PAE entering state AUTHENTICATING
1300902369.624739: EAPOL: SUPP_BE entering state SUCCESS
1300902369.624751: EAP: EAP entering state DISABLED
1300902369.624764: EAPOL: SUPP_PAE entering state AUTHENTICATED
1300902369.624776: EAPOL: Supplicant port status: Authorized
1300902369.624858: EAPOL: SUPP_BE entering state IDLE
1300902369.624875: EAPOL authentication completed successfully
1300902369.624907: RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
1300902369.624925: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
1300902370.431409: EAPOL: startWhen --> 0
1300902370.431464: EAPOL: disable timer tick
1300902557.949116: BSS: Expire BSS 1 due to age
1300902557.949222: BSS: Remove id 1 BSSID 00:18:9b:6f:02:e0 SSID 'UPC014643'
1300902557.949262: BSS: Expire BSS 2 due to age
1300902557.949285: BSS: Remove id 2 BSSID 02:18:9b:6f:02:e1 SSID ''
1300902557.949310: BSS: Expire BSS 3 due to age
1300902557.949327: BSS: Remove id 3 BSSID 02:24:d1:73:00:c5 SSID ''
1300902557.949397: BSS: Expire BSS 4 due to age
1300902557.949417: BSS: Remove id 4 BSSID 00:24:d1:73:00:c4 SSID 'UPC012257'
1300902557.949444: BSS: Expire BSS 5 due to age
1300902557.949461: BSS: Remove id 5 BSSID 40:4a:03:03:48:56 SSID 'ordi_wlan'
--------------------------->8<------------------------------------

Any Ideas ?

Thanks,
Martin
-- 
NEU: FreePhone - kostenlos mobil telefonieren und surfen!			
Jetzt informieren: http://www.gmx.net/de/go/freephone
