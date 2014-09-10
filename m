Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:61138 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaIJHaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 03:30:08 -0400
Message-ID: <540FFDFD.2070302@broadcom.com> (sfid-20140910_093014_104556_25678A88)
Date: Wed, 10 Sep 2014 09:30:05 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Jithu Jance <jithu@broadcom.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: P2P_DEVICE support in Android KitKat
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

I am running some tests on a haswell target with Android KitKat (3.10.20 
kernel). In this configuration our brcmfmac driver is used with driver 
param 'p2p_device=1'. So we end up with wlan0 and p2p-dev-wlan0 
interfaces (can blame myself for that). The configuration has a network 
configured, but I did not expect wpa_supplicant to start association 
using the p2p device interface. The wlan0 interface is already connected 
to the AP. How can I fix this to assure p2p-dev-wlan0 is only used for 
p2p management scenarios.

Regards,
Arend

---8<------------------------------------------------------------------
D/wpa_supplicant( 2613): p2p-dev-wlan0: 12: c0:c1:c0:04:b8:2c 
ssid='NSN24' wpa_ie_len=0 rsn_ie_len=0 caps=0x401 level=-36 wps
D/wpa_supplicant( 2613): p2p-dev-wlan0:    allow in non-WPA/WPA2
D/wpa_supplicant( 2613): p2p-dev-wlan0:    selected BSS 
c0:c1:c0:04:b8:2c ssid='NSN24'
D/wpa_supplicant( 2613): p2p-dev-wlan0: Considering connect request: 
reassociate: 0  selected: c0:c1:c0:04:b8:2c  bssid: 00:00:00:00:00:00 
pending: 00:00:00:00:00:00  wpa_state: SCANNING  ssid=0xf9074cd0 
current_ssid=0x0
D/wpa_supplicant( 2613): p2p-dev-wlan0: Request association with 
c0:c1:c0:04:b8:2c
D/wpa_supplicant( 2613): WPA: Unrecognized EAPOL-Key Key Data IE - 
hexdump(len=7): 00 05 4e 53 4e 32 34
D/wpa_supplicant( 2613): WPA: Unrecognized EAPOL-Key Key Data IE - 
hexdump(len=3): 03 01 0b
D/wpa_supplicant( 2613): WPA: Unrecognized EAPOL-Key Key Data IE - 
hexdump(len=6): 05 04 00 01 00 00
D/wpa_supplicant( 2613): WPA: Unrecognized EAPOL-Key Key Data IE - 
hexdump(len=3): 2a 01 00
D/wpa_supplicant( 2613): WPA: Unrecognized EAPOL-Key Key Data IE - 
hexdump(len=3): 2f 01 00
D/wpa_supplicant( 2613): WPA: Unrecognized EAPOL-Key Key Data IE - 
hexdump(len=24): 3d 16 0b 0f 04 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
D/wpa_supplicant( 2613): WPA: Unrecognized EAPOL-Key Key Data IE - 
hexdump(len=16): 4a 0e 14 00 0a 00 2c 01 c8 00 14 00 05 00 19 00
D/wpa_supplicant( 2613): TDLS: TDLS is allowed in the target BSS
I/wpa_supplicant( 2613): p2p-dev-wlan0: Trying to associate with SSID 
'NSN24'
D/wpa_supplicant( 2613): CTRL_IFACE monitor send - hexdump(len=40): 2f 
64 61 74 61 2f 6d 69 73 63 2f 77 69 66 69 2f 73 6f 63 6b 65 74 73 2f 77 
70 61 5f 63 74 72 6c ...
D/wpa_supplicant( 2613): p2p-dev-wlan0: Cancelling scan request
D/wpa_supplicant( 2613): p2p-dev-wlan0: P2P: Station mode scan operation 
not pending anymore (sta_scan_pending=0 p2p_cb_on_scan_complete=0)
D/wpa_supplicant( 2613): p2p-dev-wlan0: WPA: clearing own WPA/RSN IE
D/wpa_supplicant( 2613): p2p-dev-wlan0: Automatic auth_alg selection: 0x1
D/wpa_supplicant( 2613): p2p-dev-wlan0: WPA: clearing AP WPA IE
D/wpa_supplicant( 2613): p2p-dev-wlan0: WPA: clearing AP RSN IE
D/wpa_supplicant( 2613): p2p-dev-wlan0: WPA: clearing own WPA/RSN IE
D/wpa_supplicant( 2613): p2p-dev-wlan0: No keys have been configured - 
skip key clearing
D/wpa_supplicant( 2613): p2p-dev-wlan0: State: SCANNING -> ASSOCIATING
D/wpa_supplicant( 2613): wpa_driver_nl80211_set_operstate: operstate 
0->0 (DORMANT)
D/wpa_supplicant( 2613): netlink: Operstate: linkmode=-1, operstate=5
D/wpa_supplicant( 2613): CTRL_IFACE monitor send - hexdump(len=40): 2f 
64 61 74 61 2f 6d 69 73 63 2f 77 69 66 69 2f 73 6f 63 6b 65 74 73 2f 77 
70 61 5f 63 74 72 6c ...
D/wpa_supplicant( 2613): nl80211: Set mode ifindex 0 iftype 2 (STATION)
D/wpa_supplicant( 2613): nl80211: Failed to set interface 0 to mode 2: 
-22 (Invalid argument)
D/wpa_supplicant( 2613): nl80211: Try mode change after setting 
interface down
D/wpa_supplicant( 2613): nl80211: Stop P2P Device p2p-dev-wlan0 (0x2): 
Success
D/wpa_supplicant( 2613): nl80211: Set mode ifindex 0 iftype 2 (STATION)
D/wpa_supplicant( 2613): nl80211: Failed to set interface 0 to mode 2: 
-22 (Invalid argument)
D/wpa_supplicant( 2613): nl80211: Start P2P Device p2p-dev-wlan0 (0x2): 
Success
D/wpa_supplicant( 2613): nl80211: Interface mode change to 2 from 10 failed
I/wpa_supplicant( 2613): p2p-dev-wlan0: Association request to the 
driver failed
D/wpa_supplicant( 2613): CTRL_IFACE monitor send - hexdump(len=40): 2f 
64 61 74 61 2f 6d 69 73 63 2f 77 69 66 69 2f 73 6f 63 6b 65 74 73 2f 77 
70 61 5f 63 74 72 6c ...
D/wpa_supplicant( 2613): Added BSSID 00:00:00:00:00:00 into blacklist
D/wpa_supplicant( 2613): p2p-dev-wlan0: Blacklist count 1 --> request 
scan in 100 ms
D/wpa_supplicant( 2613): p2p-dev-wlan0: Setting scan request: 0 sec 
100000 usec
D/wpa_supplicant( 2613): p2p-dev-wlan0: P2P: Station mode scan operation 
not pending anymore (sta_scan_pending=0 p2p_cb_on_scan_complete=0)
D/wpa_supplicant( 2613): p2p-dev-wlan0: State: ASSOCIATING -> DISCONNECTED
D/wpa_supplicant( 2613): wpa_driver_nl80211_set_operstate: operstate 
0->0 (DORMANT)
D/wpa_supplicant( 2613): netlink: Operstate: linkmode=-1, operstate=5
D/wpa_supplicant( 2613): CTRL_IFACE monitor send - hexdump(len=40): 2f 
64 61 74 61 2f 6d 69 73 63 2f 77 69 66 69 2f 73 6f 63 6b 65 74 73 2f 77 
70 61 5f 63 74 72 6c ...
D/wpa_supplicant( 2613): p2p-dev-wlan0: P2P: Station mode scan operation 
not pending anymore (sta_scan_pending=0 p2p_cb_on_scan_complete=0)
D/wpa_supplicant( 2613): RX ctrl_iface - hexdump(len=11): 53 49 47 4e 41 
4c 5f 50 4f 4c 4c
D/wpa_supplicant( 2613): wlan0: Control interface command 'SIGNAL_POLL'
D/wpa_supplicant( 2613): nl80211: survey data missing!
D/wpa_supplicant( 2613): p2p-dev-wlan0: State: DISCONNECTED -> SCANNING
D/wpa_supplicant( 2613): CTRL_IFACE monitor send - hexdump(len=40): 2f 
64 61 74 61 2f 6d 69 73 63 2f 77 69 66 69 2f 73 6f 63 6b 65 74 73 2f 77 
70 61 5f 63 74 72 6c ...
D/wpa_supplicant( 2613): p2p-dev-wlan0: Starting AP scan for wildcard SSID
D/wpa_supplicant( 2613): WPS: Building WPS IE for Probe Request
D/wpa_supplicant( 2613): WPS:  * Version (hardcoded 0x10)
D/wpa_supplicant( 2613): WPS:  * Request Type
D/wpa_supplicant( 2613): WPS:  * Config Methods (4288)
D/wpa_supplicant( 2613): WPS:  * UUID-E
D/wpa_supplicant( 2613): WPS:  * Primary Device Type
D/wpa_supplicant( 2613): WPS:  * RF Bands (3)
D/wpa_supplicant( 2613): WPS:  * Association State
D/wpa_supplicant( 2613): WPS:  * Configuration Error (0)
D/wpa_supplicant( 2613): WPS:  * Device Password ID (0)
D/wpa_supplicant( 2613): WPS:  * Manufacturer
D/wpa_supplicant( 2613): WPS:  * Model Name
D/wpa_supplicant( 2613): WPS:  * Model Number
D/wpa_supplicant( 2613): WPS:  * Device Name
D/wpa_supplicant( 2613): WPS:  * Version2 (0x20)
D/wpa_supplicant( 2613): P2P: * P2P IE header
D/wpa_supplicant( 2613): P2P: * Capability dev=25 group=00
D/wpa_supplicant( 2613): P2P: * Listen Channel: Regulatory Class 81 
Channel 6
D/wpa_supplicant( 2613): p2p-dev-wlan0: nl80211: scan request
