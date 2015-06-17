Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35732 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbbFQOYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 10:24:43 -0400
Received: by lbbwc1 with SMTP id wc1so32937386lbb.2
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 07:24:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJm8KTqVqBCS62QmD=vQB=954Ab4F=740b59bT-7jRoNMRYcUA@mail.gmail.com>
References: <CAJm8KTqVqBCS62QmD=vQB=954Ab4F=740b59bT-7jRoNMRYcUA@mail.gmail.com>
Date: Wed, 17 Jun 2015 10:24:41 -0400
Message-ID: <CAJm8KTr99xn13Bsjpa23gtCoGws1YN5sgpqDMKiaHGFY+bBskg@mail.gmail.com> (sfid-20150617_162447_504914_8EB1E4B2)
Subject: Fwd: P2P Group formation failure
From: Ishan Mandrekar <ishan.mandrekar@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm currently trying to debug a problem with the Provisioning step in
the P2P connection process. More specifically, after the GO_NEG step
is completed there is an *error bringing up* the newly created P2P
interface as can be seen from the wpa_supplicant log attached below.
I've tried to play with various configuration settings of the
supplicant without much luck. Any pointers that can help me debug this
issue would be very much appreciated.

Thanks,
-Ishan



WiFi card:
--------------
Intel 7260-ac (rev bb) dual band PCIe


Kernel version:
---------------------
4.0.1-1-ARCH


wpa_supplicant version:
----------------------------------
wpa_supplicant v2.3


Starting portion of wpa_supplicant log (including conf file):
-----------------------------------------------------------------------------------
wpa_supplicant v2.3
Global control interface '/run/miracle/wifi/wlan0-4.global'
Using UNIX control socket '/run/miracle/wifi/wlan0-4.global'
Successfully initialized wpa_supplicant
Initializing interface 'wlan0' conf '/run/miracle/wifi/wlan0-4.conf'
driver 'default' ctrl_interface '/run/miracle/wifi' bridge 'N/A'
Configuration file '/run/miracle/wifi/wlan0-4.conf' ->
'/run/miracle/wifi/wlan0-4.conf'
Reading configuration file '/run/miracle/wifi/wlan0-4.conf'
device_name='leapfrog'
config_methods='display'
driver_param='p2p_device=1'
ap_scan=1
p2p_no_group_iface=1
rfkill: initial event: idx=0 type=2 op=0 soft=1 hard=0
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
nl80211: Supported cipher 00-0f-ac:4
nl80211: Supported cipher 00-0f-ac:10
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:8
nl80211: Supported cipher 00-0f-ac:9
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:6
nl80211: Supported cipher 00-0f-ac:13
nl80211: Supported cipher 00-0f-ac:11
nl80211: Supported cipher 00-0f-ac:12
nl80211: Supported cipher 00-14-72:1
nl80211: Using driver-based off-channel TX
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: Enable multi-channel concurrent (driver advertised support)
nl80211: interface wlan0 in phy phy0
nl80211: Set mode ifindex 4 iftype 2 (STATION)
nl80211: Subscribe to mgmt frames with non-AP handle 0xae86d0
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=040a
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=040b
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=040c
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=040d
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=090a
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=090b
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=090c
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=090d
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=0409506f9a09
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=7f506f9a09
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=0801
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=06
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=0a07
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xae86d0 match=0a11
netlink: Operstate: ifindex=4 linkmode=1 (userspace-control),
operstate=5 (IF_OPER_DORMANT)
nl80211: driver param='p2p_device=1'
Add interface wlan0 to a new radio phy0
nl80211: Regulatory information - country=00
nl80211: 2402-2472 @ 40 MHz 20 mBm
nl80211: 2457-2482 @ 40 MHz 20 mBm (no IR)
nl80211: 2474-2494 @ 20 MHz 20 mBm (no OFDM) (no IR)
nl80211: 5170-5250 @ 160 MHz 20 mBm (no IR)
nl80211: 5250-5330 @ 160 MHz 20 mBm (DFS) (no IR)
nl80211: 5490-5730 @ 160 MHz 20 mBm (DFS) (no IR)
nl80211: 5735-5835 @ 80 MHz 20 mBm (no IR)
nl80211: 57240-63720 @ 2160 MHz 0 mBm
nl80211: Added 802.11b mode based on 802.11g information
wlan0: Own MAC address: d8:fc:93:e4:e8:e6
wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=(nil)
key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=(nil)
key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=(nil)
key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=(nil)
key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=(nil)
key_idx=4 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 (wlan0) alg=0 addr=(nil)
key_idx=5 set_tx=0 seq_len=0 key_len=0
wlan0: RSN: flushing PMKID list in the driver
nl80211: Flush PMKIDs
wlan0: State: DISCONNECTED -> INACTIVE
TDLS: TDLS operation not supported by driver
TDLS: Driver uses internal link setup
WPS: Converting display to virtual_display for WPS 2.0 compliance
wlan0: WPS: UUID based on MAC address: 7ac8944d-9f62-5a35-adeb-e3f0a49a81c0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
nl80211: Skip set_supp_port(unauthorized) while not associated
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
Using existing control interface directory.
wlan0: Added interface wlan0
wlan0: State: INACTIVE -> DISCONNECTED
nl80211: Set wlan0 operstate 0->0 (DORMANT)
netlink: Operstate: ifindex=4 linkmode=-1 (no change), operstate=5
(IF_OPER_DORMANT)
nl80211: Create interface iftype 10 (P2P_DEVICE)
nl80211: New P2P Device interface p2p-dev-wlan0 (0x3f) created
Initializing interface 'p2p-dev-wlan0' conf
'/run/miracle/wifi/wlan0-4.conf' driver 'nl80211' ctrl_interface
'/run/miracle/wifi' bridge 'N/A'
Configuration file '/run/miracle/wifi/wlan0-4.conf' ->
'/run/miracle/wifi/wlan0-4.conf'
Reading configuration file '/run/miracle/wifi/wlan0-4.conf'
device_name='leapfrog'
config_methods='display'
driver_param='p2p_device=1'
ap_scan=1
p2p_no_group_iface=1
rfkill: initial event: idx=0 type=2 op=0 soft=1 hard=0
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
Could not read interface p2p-dev-wlan0 flags: No such device
nl80211: Supported cipher 00-0f-ac:4
nl80211: Supported cipher 00-0f-ac:10
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:8
nl80211: Supported cipher 00-0f-ac:9
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:6
nl80211: Supported cipher 00-0f-ac:13
nl80211: Supported cipher 00-0f-ac:11
nl80211: Supported cipher 00-0f-ac:12
nl80211: Supported cipher 00-14-72:1
nl80211: Using driver-based off-channel TX
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: Enable multi-channel concurrent (driver advertised support)
nl80211: interface p2p-dev-wlan0 in phy phy0
nl80211: Set mode ifindex 0 iftype 10 (P2P_DEVICE)
nl80211: Failed to set interface 0 to mode 10: -22 (Invalid argument)
nl80211: Subscribe to mgmt frames with non-AP handle 0xb07280
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=040a
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=040b
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=040c
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=040d
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=090a
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=090b
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=090c
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=090d
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=0409506f9a09
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=7f506f9a09
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=0801
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=06
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=0a07
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xb07280 match=0a11
nl80211: Start P2P Device p2p-dev-wlan0 (0x3f): Success
nl80211: driver param='p2p_device=1'
Add interface p2p-dev-wlan0 to existing radio phy0
nl80211: Regulatory information - country=00
nl80211: 2402-2472 @ 40 MHz 20 mBm
nl80211: 2457-2482 @ 40 MHz 20 mBm (no IR)
nl80211: 2474-2494 @ 20 MHz 20 mBm (no OFDM) (no IR)
nl80211: 5170-5250 @ 160 MHz 20 mBm (no IR)
nl80211: 5250-5330 @ 160 MHz 20 mBm (DFS) (no IR)
nl80211: 5490-5730 @ 160 MHz 20 mBm (DFS) (no IR)
nl80211: 5735-5835 @ 80 MHz 20 mBm (no IR)
nl80211: 57240-63720 @ 2160 MHz 0 mBm
nl80211: Added 802.11b mode based on 802.11g information
p2p-dev-wlan0: Own MAC address: d8:fc:93:e4:e8:e7
p2p-dev-wlan0: RSN: flushing PMKID list in the driver
nl80211: Flush PMKIDs
p2p-dev-wlan0: State: DISCONNECTED -> INACTIVE
WPS: Converting display to virtual_display for WPS 2.0 compliance
p2p-dev-wlan0: WPS: UUID from the first interface:
7ac8944d-9f62-5a35-adeb-e3f0a49a81c0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
nl80211: Skip set_supp_port(unauthorized) while not associated
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
Using existing control interface directory.
P2P: Add operating class 81
P2P: Channels - hexdump(len=11): 01 02 03 04 05 06 07 08 09 0a 0b
P2P: Own listen channel: 81:11
P2P: Random operating channel: 81:6
P2P: initialized
P2P: channels: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: cli_channels:
p2p-dev-wlan0: Added interface p2p-dev-wlan0
p2p-dev-wlan0: State: INACTIVE -> DISCONNECTED
nl80211: Set p2p-dev-wlan0 operstate 0->0 (DORMANT)
netlink: Operstate: ifindex=0 linkmode=-1 (no change), operstate=5
(IF_OPER_DORMANT)
RTM_NEWLINK: ifi_index=4 ifname=wlan0 operstate=2 linkmode=1
ifi_family=0 ifi_flags=0x1003 ([UP])
[0000.432824] DEBUG: supplicant: open supplicant of wlan0
(supplicant_open() in wifid-supplicant.c:2233)
CTRL_IFACE monitor attached /tmp/.miracle-wpas-9160-1\x00
CTRL_IFACE monitor attached /tmp/.miracle-wpas-9160-2\x00
RX global ctrl_iface - hexdump_ascii(len=6):
     53 54 41 54 55 53                                 STATUS
[0000.433685] DEBUG: supplicant: local p2p-address is:
d8:fc:93:e4:e8:e7 (supplicant_status_fn() in wifid-supplicant.c:1790)
RX global ctrl_iface - hexdump_ascii(len=24):
     53 45 54 20 64 65 76 69 63 65 5f 6e 61 6d 65 20   SET device_name
     6c 65 61 70 66 72 6f 67                           leapfrog
GLOBAL_CTRL_IFACE SET 'device_name'='leapfrog'
p2p-dev-wlan0: Control interface command 'SET device_name leapfrog'
CTRL_IFACE SET 'device_name'='leapfrog'
device_name='leapfrog'
WPS: Converting display to virtual_display for WPS 2.0 compliance
p2p-dev-wlan0: Control interface command 'P2P_SET disallow_freq 5180-5900'
P2P: Disallowed frequency range 5180-5900
P2P: Add operating class 81
P2P: Channels - hexdump(len=11): 01 02 03 04 05 06 07 08 09 0a 0b
P2P: Update channel list
P2P: channels: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: cli_channels:
p2p-dev-wlan0: Control interface command 'P2P_PEER FIRST'
RX global ctrl_iface - hexdump_ascii(len=18):
     53 45 54 20 77 69 66 69 5f 64 69 73 70 6c 61 79   SET wifi_display
     20 31                                              1
GLOBAL_CTRL_IFACE SET 'wifi_display'='1'
WFD: Wi-Fi Display enabled
WFD: Update WFD IE
WFD: WFD IE for Beacon - hexdump(len=0):
WFD: WFD IE for (Re)Association Request - hexdump(len=0):
WFD: WFD IE for GO Negotiation - hexdump(len=0):
WFD: WFD IE for Provision Discovery Request - hexdump(len=0):
WFD: WFD IE for Probe Request - hexdump(len=0):
WFD: WFD IE for Probe Response - hexdump(len=0):
WFD: WFD IE for P2P Invitation - hexdump(len=0):
WFD: WFD IE for Provision Discovery Response - hexdump(len=0):
[0000.434798] DEBUG: link: link wlan0 started
(link_supplicant_started() in wifid-link.c:277)
p2p-dev-wlan0: Control interface command 'WFD_SUBELEM_SET 0'
EAPOL: disable timer tick
EAPOL: disable timer tick


Trailing portion of wpa_supplicant log:
------------------------------------------------------
p2p-dev-wlan0: Radio work 'p2p-scan'@0xdce7a0 done in 0.079034 seconds
P2P: Scan results received (7 BSS)
P2P: Parsing WPS IE
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x238c
P2P: Primary Device Type (WPS): 6-0050F204-1
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 2b
P2P: Attribute 8 length 4
P2P: * Extended Listen Timing (period 65535 msec  interval 65535 msec)
P2P: Attribute 13 length 43
P2P: * Device Info: addr 10:9f:a9:2d:db:69 primary device type
7-0050F204-1 device name 'Actiontec DB69' config methods 0x8
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 13 length 33
P2P: * Device Info: addr 7a:40:e4:c3:5b:42 primary device type
10-0050F204-5 device name 'Galaxy Tab A' config methods 0x188
P2P: Do not update peer entry based on old frame (rx_time=88368.380736
last_seen=88372.229589)
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: State SEARCH -> SEARCH
P2P: Starting short listen state (state=SEARCH)
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=25 group=00
P2P: * Device Info
p2p-dev-wlan0: Add radio work 'p2p-listen'@0xdd4520
p2p-dev-wlan0: First radio work item in the queue - schedule start immediately
p2p-dev-wlan0: Starting radio work 'p2p-listen'@0xdd4520 after
0.000050 second wait
nl80211: Enable Probe Request reporting nl_preq=0xdcf440
nl80211: Register frame type=0x40 (WLAN_FC_STYPE_PROBE_REQ)
nl_handle=0xdcf440 match=
nl80211: Remain-on-channel cookie 0xfba7 for freq=2437 MHz duration=307
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=0 freq=2437 channel_type=0
duration=307 cookie=0xfba7 (match))
p2p-dev-wlan0: Event REMAIN_ON_CHANNEL (21) received
Off-channel: Send Action callback (without_roc=0
pending_action_tx=(nil) pending_action_tx_done=1)
P2P: Starting Listen timeout(0,307200) on freq=2437 based on callback
P2P: Set timeout (state=SEARCH): 0.327200 sec
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame sa=7a:40:e4:c3:5b:42 freq=2437 ssi_signal=-24
stype=13 (WLAN_FC_STYPE_ACTION) len=209
p2p-dev-wlan0: Event RX_MGMT (20) received
p2p-dev-wlan0: Received Action frame: SA=7a:40:e4:c3:5b:42 Category=4
DataLen=184 freq=2437 MHz
P2P: RX P2P Public Action from 7a:40:e4:c3:5b:42
P2P: Received GO Negotiation Request from 7a:40:e4:c3:5b:42(freq=2437)
P2P: Parsing the received message
P2P: * Dialog Token: 2
P2P: Parsing WPS IE
P2P: Device Password ID: 1
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 08
P2P: Attribute 4 length 1
P2P: * GO Intent: Intent 14 Tie breaker 1
P2P: Attribute 5 length 2
P2P: * Configuration Timeout
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country US(0x04) Regulatory Class 81 Channel Number 1
P2P: Attribute 9 length 6
P2P: * Intended P2P Interface Address: 7a:40:e4:c3:db:42
P2P: Attribute 11 length 51
P2P: * Channel List: Country String 'US(0x04)'
P2P: Attribute 13 length 33
P2P: * Device Info: addr 7a:40:e4:c3:5b:42 primary device type
10-0050F204-5 device name 'Galaxy Tab A' config methods 0x108
P2P: Attribute 17 length 5
P2P: * Operating Channel: Country US(0x04) Regulatory Class 81 Channel Number 1
P2P: Not ready for GO negotiation with 7a:40:e4:c3:5b:42
P2P-GO-NEG-REQUEST 7a:40:e4:c3:5b:42 dev_passwd_id=1
CTRL_IFACE monitor sent successfully to /tmp/.miracle-wpas-9103-1\x00
[0036.827677] DEBUG: supplicant: GO Negotiation Request from
7a:40:e4:c3:5b:42 (supplicant_event_p2p_go_neg_request() in
wifid-supplicant.c:1057)
CTRL_IFACE monitor sent successfully to /tmp/.miracle-wpas-9103-2\x00
P2P: Building GO Negotiation Response
P2P: * Dialog Token: 2
P2P: * P2P IE header
P2P: * Status: 1
P2P: * Capability dev=25 group=00
P2P: * GO Intent: Intent 0 Tie breaker 0
P2P: * Configuration Timeout: GO 100 (*10ms)  client 20 (*10ms)
P2P: * Operating Channel: Regulatory Class 0 Channel 0
P2P: * Intended P2P Interface Address 00:00:00:00:00:00
P2P: * Channel List - hexdump(len=3): 58 58 04
P2P: * Device Info
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 0
WPS:  * Version2 (0x20)
P2P: Sending GO Negotiation Response
P2P: Use ongoing radio work for Action frame TX
Off-channel: Send action frame: freq=2437 dst=7a:40:e4:c3:5b:42
src=d8:fc:93:e4:e8:e7 bssid=d8:fc:93:e4:e8:e7 len=129
nl80211: Send Action frame (ifindex=0, freq=2437 MHz wait=500 ms no_cck=1)
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) received for p2p-dev-wlan0
nl80211: Frame TX status event
nl80211: Action TX status: cookie=0ffff880153f00700 (match) (ack=1)
p2p-dev-wlan0: Event TX_STATUS (18) received
[0036.829179] DEBUG: supplicant: connect to 7a:40:e4:c3:5b:42 via
display/87757415 (supplicant_peer_connect() in wifid-supplicant.c:734)
p2p-dev-wlan0: EVENT_TX_STATUS dst=7a:40:e4:c3:5b:42 type=0 stype=13
Off-channel: Delete matching pending action frame
Off-channel: TX status result=0 cb=0x43a1e0
P2P: Action frame TX callback (state=3 freq=2437 dst=7a:40:e4:c3:5b:42
src=d8:fc:93:e4:e8:e7 bssid=d8:fc:93:e4:e8:e7 result=0
P2P: GO Negotiation Response (failure) TX callback: success=1
p2p-dev-wlan0: Control interface command 'P2P_CONNECT
7a:40:e4:c3:5b:42 87757415 display'
p2p-dev-wlan0: Determining shared radio frequencies (max len 2)
p2p-dev-wlan0: Shared frequencies (len=0): completed iteration
p2p-dev-wlan0: Shared frequencies (len=0): valid for P2P
p2p-dev-wlan0: Determining shared radio frequencies (max len 2)
p2p-dev-wlan0: Shared frequencies (len=0): completed iteration
p2p-dev-wlan0: P2P: num_unused_channels: 2
P2P: Setup freqs: freq=0 num_MCC=2 shared_freqs=0 num_unused=2
P2P: Current operating channels are not available for P2P. Try to use
another channel
P2P: Own frequency preference: 0 MHz
P2P: Create a new interface p2p-wlan0-0 for the group
nl80211: Create interface iftype 8 (P2P_CLIENT)
nl80211: New interface p2p-wlan0-0 created: ifindex=30
nl80211: Set TX rates failed: ret=-100 (Network is down)
P2P: Created pending virtual interface p2p-wlan0-0 addr d8:fc:93:e4:e8:e8
P2P: Request to start group negotiation - peer=7a:40:e4:c3:5b:42  GO
Intent=7  Intended Interface Address=d8:fc:93:e4:e8:e8 wps_method=1
persistent_group=0 pd_before_go_neg=0 oob_pw_id=0
P2P: Prepare channel - force_freq=0 pref_freq=0 go=0
P2P: Prepare channel best
P2P: Select pre-configured channel as operating channel preference
P2P: prepared channels: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: after go/cli filter/add: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: Own preference for operation channel: Operating Class 81 Channel 11
P2P: Stopping find
P2P: Clear timeout (state=SEARCH)
P2P-FIND-STOPPED
CTRL_IFACE monitor sent successfully to /tmp/.miracle-wpas-9103-1\x00
CTRL_IFACE monitor sent successfully to /tmp/.miracle-wpas-9103-2\x00
P2P: State SEARCH -> IDLE
P2P: Clear timeout (state=IDLE)
P2P: Clear drv_in_listen (2437)
nl80211: Cancel remain-on-channel with cookie 0xfba7
[0036.832487] DEBUG: supplicant: p2p-scanning stopped on wlan0
(supplicant_event_p2p_find_stopped() in wifid-supplicant.c:892)
nl80211: Disable Probe Request reporting nl_preq=0x8888888888547cc9
p2p-dev-wlan0: Radio work 'p2p-listen'@0xdd4520 done in 0.119476 seconds
P2P: * Dialog Token: 1
P2P: * P2P IE header
P2P: * Capability dev=25 group=08
P2P: * GO Intent: Intent 7 Tie breaker 1
P2P: * Configuration Timeout: GO 100 (*10ms)  client 20 (*10ms)
P2P: * Listen Channel: Regulatory Class 81 Channel 6
P2P: * Intended P2P Interface Address d8:fc:93:e4:e8:e8
P2P: * Channel List - hexdump(len=16): 58 58 04 51 0b 01 02 03 04 05
06 07 08 09 0a 0b
P2P: * Device Info
P2P: * Operating Channel: Regulatory Class 81 Channel 11
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * Version2 (0x20)
P2P: Sending GO Negotiation Request
P2P: State IDLE -> CONNECT
P2P: Schedule new radio work for Action frame TX (listen_freq=-1 send_freq=-1)
p2p-dev-wlan0: Add radio work 'p2p-send-action'@0xdd4520
p2p-dev-wlan0: First radio work item in the queue - schedule start immediately
p2p-dev-wlan0: Starting radio work 'p2p-send-action'@0xdd4520 after
0.000081 second wait
Off-channel: Send action frame: freq=2412 dst=7a:40:e4:c3:5b:42
src=d8:fc:93:e4:e8:e7 bssid=7a:40:e4:c3:5b:42 len=146
nl80211: Send Action frame (ifindex=0, freq=2412 MHz wait=500 ms no_cck=1)
nl80211: Ignore RTM_NEWLINK event for foreign ifindex 30
nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=1 freq=2437 channel_type=0
duration=0 cookie=0xfba7 (match))
p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=0 ms
pending_action_tx=0xdd4a90)
P2P: Driver ended Listen state (freq=2437)
nl80211: Ignore RTM_NEWLINK event for foreign ifindex 30
nl80211: Ignore RTM_NEWLINK event for foreign ifindex 30
nl80211: Ignore RTM_NEWLINK event for foreign ifindex 30
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) received for p2p-dev-wlan0
nl80211: Frame TX status event
nl80211: Action TX status: cookie=0ffff8800500fbb00 (match) (ack=1)
p2p-dev-wlan0: Event TX_STATUS (18) received
p2p-dev-wlan0: EVENT_TX_STATUS dst=7a:40:e4:c3:5b:42 type=0 stype=13
Off-channel: Delete matching pending action frame
Off-channel: TX status result=0 cb=0x43a1e0
P2P: Action frame TX callback (state=1 freq=2412 dst=7a:40:e4:c3:5b:42
src=d8:fc:93:e4:e8:e7 bssid=7a:40:e4:c3:5b:42 result=0
P2P: GO Negotiation Request TX callback: success=1
P2P: State CONNECT -> CONNECT
P2P: Set timeout (state=CONNECT): 0.500000 sec
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame sa=7a:40:e4:c3:5b:42 freq=2412 ssi_signal=-27
stype=13 (WLAN_FC_STYPE_ACTION) len=201
p2p-dev-wlan0: Event RX_MGMT (20) received
p2p-dev-wlan0: Received Action frame: SA=7a:40:e4:c3:5b:42 Category=4
DataLen=176 freq=2412 MHz
P2P: RX P2P Public Action from 7a:40:e4:c3:5b:42
P2P: Received GO Negotiation Response from 7a:40:e4:c3:5b:42 (freq=2412)
P2P: Parsing the received message
P2P: * Dialog Token: 1
P2P: Parsing WPS IE
P2P: Device Password ID: 1
P2P: Parsing P2P IE
P2P: Attribute 0 length 1
P2P: * Status: 0
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 08
P2P: Attribute 4 length 1
P2P: * GO Intent: Intent 14 Tie breaker 0
P2P: Attribute 5 length 2
P2P: * Configuration Timeout
P2P: Attribute 17 length 5
P2P: * Operating Channel: Country US(0x04) Regulatory Class 81 Channel Number 1
P2P: Attribute 9 length 6
P2P: * Intended P2P Interface Address: 7a:40:e4:c3:db:42
P2P: Attribute 11 length 16
P2P: * Channel List: Country String 'US(0x04)'
P2P: Attribute 13 length 33
P2P: * Device Info: addr 7a:40:e4:c3:5b:42 primary device type
10-0050F204-5 device name 'Galaxy Tab A' config methods 0x108
P2P: Attribute 15 length 28
P2P: * P2P Group ID: Device Address 7a:40:e4:c3:5b:42
P2P: * P2P Group ID: SSID - hexdump_ascii(len=22):
     44 49 52 45 43 54 2d 47 74 2d 47 61 6c 61 78 79   DIRECT-Gt-Galaxy
     20 54 61 62 20 41                                  Tab A
P2P: Peer country - hexdump_ascii(len=3):
     55 53 04                                          US_
P2P: Own reg_classes 1 peer reg_classes 1 intersection reg_classes 1
P2P: Peer operating channel preference: 2412 MHz
P2P: Peer entered PIN on Keypad
P2P: State CONNECT -> GO_NEG
P2P: Clear timeout (state=GO_NEG)
P2P: GO Negotiation with 7a:40:e4:c3:5b:42
P2P: Building GO Negotiation Confirm
P2P: * Dialog Token: 1
P2P: * P2P IE header
P2P: * Status: 0
P2P: * Capability dev=25 group=00
P2P: * Operating Channel: Regulatory Class 81 Channel 1
P2P: * Channel List - hexdump(len=16): 58 58 04 51 0b 01 02 03 04 05
06 07 08 09 0a 0b
P2P: Sending GO Negotiation Confirm
P2P: Use ongoing radio work for Action frame TX
Off-channel: Send action frame: freq=2412 dst=7a:40:e4:c3:5b:42
src=d8:fc:93:e4:e8:e7 bssid=7a:40:e4:c3:5b:42 len=65
nl80211: Send Action frame (ifindex=0, freq=2412 MHz wait=200 ms no_cck=1)
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) received for p2p-dev-wlan0
nl80211: Frame TX status event
nl80211: Action TX status: cookie=0ffff88007798a300 (match) (ack=1)
p2p-dev-wlan0: Event TX_STATUS (18) received
p2p-dev-wlan0: EVENT_TX_STATUS dst=7a:40:e4:c3:5b:42 type=0 stype=13
Off-channel: Delete matching pending action frame
Off-channel: TX status result=0 cb=0x43a1e0
P2P: Action frame TX callback (state=4 freq=2412 dst=7a:40:e4:c3:5b:42
src=d8:fc:93:e4:e8:e7 bssid=7a:40:e4:c3:5b:42 result=0
P2P: GO Negotiation Confirm TX callback: result=0
p2p-dev-wlan0: Radio work 'p2p-send-action'@0xdd4520 done in 0.339823 seconds
Off-channel: Action frame sequence done notification
nl80211: Cancel TX frame wait: cookie=0xffff88007798a300
P2P: GO Negotiation with 7a:40:e4:c3:5b:42 completed (peer will be GO)
P2P: own channels: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: peer channels: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: Clear timeout (state=GO_NEG)
P2P: State GO_NEG -> PROVISIONING
P2P-GO-NEG-SUCCESS role=client freq=2412 ht40=0
peer_dev=7a:40:e4:c3:5b:42 peer_iface=7a:40:e4:c3:db:42
wps_method=Display
CTRL_IFACE monitor sent successfully to /tmp/.miracle-wpas-9103-1\x00
CTRL_IFACE monitor sent successfully to /tmp/.miracle-wpas-9103-2\x00
Initializing interface 'p2p-wlan0-0' conf 'N/A' driver 'nl80211'
ctrl_interface '/run/miracle/wifi' bridge 'N/A'
rfkill: initial event: idx=0 type=2 op=0 soft=1 hard=0
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
[0037.175385] DEBUG: supplicant: set STA-MAC for 7a:40:e4:c3:5b:42
from <none> to 7a:40:e4:c3:db:42 (via GO-NEG-SUCCESS)
(supplicant_event_p2p_go_neg_success() in wifid-supplicant.c:1187)
nl80211: Supported cipher 00-0f-ac:4
nl80211: Supported cipher 00-0f-ac:10
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:8
nl80211: Supported cipher 00-0f-ac:9
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:6
nl80211: Supported cipher 00-0f-ac:13
nl80211: Supported cipher 00-0f-ac:11
nl80211: Supported cipher 00-0f-ac:12
nl80211: Supported cipher 00-14-72:1
nl80211: Using driver-based off-channel TX
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: Enable multi-channel concurrent (driver advertised support)
nl80211: interface p2p-wlan0-0 in phy phy0
nl80211: Set mode ifindex 30 iftype 2 (STATION)
nl80211: Subscribe to mgmt frames with non-AP handle 0xdcf440
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=040a
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=040b
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=040c
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=040d
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=090a
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=090b
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=090c
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=090d
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=0409506f9a09
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=7f506f9a09
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=0801
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=06
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=0a07
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION)
nl_handle=0xdcf440 match=0a11
Could not set interface p2p-wlan0-0 flags (UP): Device or resource busy
nl80211: Could not set interface 'p2p-wlan0-0' UP
nl80211: Remove monitor interface: refcount=0
netlink: Operstate: ifindex=30 linkmode=0 (kernel-control),
operstate=6 (IF_OPER_UP)
nl80211: Set mode ifindex 30 iftype 2 (STATION)
nl80211: Unsubscribe mgmt frames handle 0x8888888888547cc9 (mode change)
p2p-wlan0-0: Failed to initialize driver interface
CTRL_IFACE monitor sent successfully to /tmp/.miracle-wpas-9103-1\x00
Failed to add interface p2p-wlan0-0
p2p-wlan0-0: Cancelling scan request
p2p-wlan0-0: Cancelling authentication timeout
P2P: Failed to create new wpa_supplicant interface
P2P: Removing pending group interface p2p-wlan0-0
nl80211: wpa_driver_nl80211_if_remove(type=5 ifname=p2p-wlan0-0)
ifindex=30 added_if=0
nl80211: Remove interface ifindex=30
nl80211: if_indices[16]:
nl80211: if_indices[16]:
P2P: Group Formation failed with 7a:40:e4:c3:db:42
P2P: Clear timeout (state=PROVISIONING)
P2P: State PROVISIONING -> IDLE
P2P-GROUP-FORMATION-FAILURE
CTRL_IFACE monitor sent successfully to /tmp/.miracle-wpas-9103-1\x00
P2P: P2P group interface not found
nl80211: Ignore RTM_DELLINK event for foreign ifindex 30
