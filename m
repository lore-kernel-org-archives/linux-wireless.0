Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:60256 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaAMUxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:53:36 -0500
Received: by mail-ie0-f172.google.com with SMTP id u16so8055460iet.3
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:53:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A0333565A8@HASMSX106.ger.corp.intel.com>
References: <CANq1E4Rhja6XZPq9sXfycK_wWNB3nsjpQFr2XnzOXLHUnm__mw@mail.gmail.com>
	<CANq1E4STKqci55ZbGP9Siorf3ABptHHTAuOg_4-bbbEiw93w+A@mail.gmail.com>
	<CB3B3D4774441E42AA3EA0E1BA8230A0333565A8@HASMSX106.ger.corp.intel.com>
Date: Mon, 13 Jan 2014 21:53:34 +0100
Message-ID: <CANq1E4QmdmMsvXFonAmMYQ5X-r-GQDrPAsU9rYk49GgWMbF2bQ@mail.gmail.com> (sfid-20140113_215347_758409_46A8A997)
Subject: Re: iwlwifi: P2P group-formation timeout
From: David Herrmann <dh.herrmann@gmail.com>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Content-Type: multipart/mixed; boundary=089e0111e270f0617d04efe044d8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--089e0111e270f0617d04efe044d8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi

On Mon, Jan 13, 2014 at 8:58 PM, Peer, Ilan <ilan.peer@intel.com> wrote:
> Hi David,
>
> My guess is that the root cause of the failure is the fact that the GoN e=
nded with the local side trying to instantiate a GO on freq=3D5180 which pr=
obably not supported by your SKU. To verify this can u please send me the o=
utput of 'iw phy0 info'? Also can you please send the full log of the wpa_s=
upplicant?
>
> One way to avoid this is to call  'wpa_cli set disallow_freq 5180-5800' b=
efore the GoN. Another way is to force the operating channel in the configu=
ration file or in the p2p_connect command. You could also try to set a low =
go_intent so that the otherside would become a GO.
>
> Thanks in advance,

I tried again and masked the 5ghz channels (via "p2p_set", not "set" I
guess?), however, still almost exactly the same log but on a 2.4ghz
channel. I attached the full log to the email, I cut down all the
"p2p-scan" log messages and inlined most parts of the log below.

Another thing that I noticed is that I don't get any "P2P-XY" status
messages to wpa_cli. I need to run "tail -f wpa.log | grep ^P2P-" in a
separate session to actually see messages like P2P-DEVICE-FOUND,
P2P-GO-NEG-SUCCESS, .. I only got "P2P-GROUP-" related messages
directly forwarded to my wpa_cli. I really think this is all somehow
related to the bunch of errors I get during p2p-dev-wlan0 setup, which
you said you cannot reproduce.

Anyhow, thanks for the help. If I can provide any more information,
please let me know.
David


wpa_supplicant v2.1-devel
Successfully initialized wpa_supplicant
Initializing interface 'wlan0' conf '../wpa.conf' driver 'nl80211'
ctrl_interface 'N/A' bridge 'N/A'
Configuration file '../wpa.conf' -> '/home/david/dev/openwfd/../wpa.conf'
Reading configuration file '/home/david/dev/openwfd/../wpa.conf'
ctrl_interface=3D'/var/run/wpa_supplicant'
ap_scan=3D1
p2p_go_ht40=3D1
device_name=3D'david-ub'
nl80211: Could not add multicast membership for vendor events: -2 (No
such file or directory)
rfkill: initial event: idx=3D2 type=3D1 op=3D0 soft=3D0 hard=3D0
rfkill: initial event: idx=3D3 type=3D1 op=3D0 soft=3D0 hard=3D0
rfkill: initial event: idx=3D4 type=3D2 op=3D0 soft=3D0 hard=3D0
rfkill: initial event: idx=3D5 type=3D2 op=3D0 soft=3D0 hard=3D0
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:4
nl80211: Supported cipher 00-0f-ac:6
nl80211: Using driver-based off-channel TX
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: interface wlan0 in phy phy0
nl80211: Set mode ifindex 3 iftype 2 (STATION)
nl80211: Subscribe to mgmt frames with non-AP handle 0x2665bf0
nl80211: Register frame type=3D0xd0 nl_handle=3D0x2665bf0 match=3D040a
nl80211: Register frame type=3D0xd0 nl_handle=3D0x2665bf0 match=3D040b
nl80211: Register frame type=3D0xd0 nl_handle=3D0x2665bf0 match=3D040c
nl80211: Register frame type=3D0xd0 nl_handle=3D0x2665bf0 match=3D040d
nl80211: Register frame type=3D0xd0 nl_handle=3D0x2665bf0 match=3D0409506f9=
a09
nl80211: Register frame type=3D0xd0 nl_handle=3D0x2665bf0 match=3D7f506f9a0=
9
nl80211: Register frame type=3D0xd0 nl_handle=3D0x2665bf0 match=3D06
nl80211: Register frame type=3D0xd0 nl_handle=3D0x2665bf0 match=3D0a07
nl80211: Register frame type=3D0xd0 nl_handle=3D0x2665bf0 match=3D0a11
netlink: Operstate: ifindex=3D3 linkmode=3D1 (userspace-control),
operstate=3D5 (IF_OPER_DORMANT)
nl80211: driver param=3D'p2p_device=3D1'
Add interface wlan0 to a new radio phy0
nl80211: Regulatory information - country=3D00
nl80211: 2402-2472 @ 40 MHz 20 mBm
nl80211: 2457-2482 @ 40 MHz 20 mBm
nl80211: 2474-2494 @ 20 MHz 20 mBm
nl80211: 5170-5250 @ 160 MHz 20 mBm
nl80211: 5250-5330 @ 160 MHz 20 mBm
nl80211: 5490-5730 @ 160 MHz 20 mBm
nl80211: Added 802.11b mode based on 802.11g information
wlan0: Own MAC address: fc:f8:ae:69:8a:61
wpa_driver_nl80211_set_key: ifindex=3D3 (wlan0) alg=3D0 addr=3D(nil)
key_idx=3D0 set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D3 (wlan0) alg=3D0 addr=3D(nil)
key_idx=3D1 set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D3 (wlan0) alg=3D0 addr=3D(nil)
key_idx=3D2 set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D3 (wlan0) alg=3D0 addr=3D(nil)
key_idx=3D3 set_tx=3D0 seq_len=3D0 key_len=3D0
wlan0: RSN: flushing PMKID list in the driver
nl80211: Flush PMKIDs
wlan0: State: DISCONNECTED -> INACTIVE
wlan0: WPS: UUID based on MAC address: 4a7cf8c2-3c3b-5238-b16f-7273f4bb4fda
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
netlink: Operstate: ifindex=3D3 linkmode=3D-1 (no change), operstate=3D5
(IF_OPER_DORMANT)
nl80211: Create interface iftype 10 (P2P_DEVICE)
nl80211: New P2P Device interface p2p-dev-wlan0 (0x13) created
Initializing interface 'p2p-dev-wlan0' conf
'/home/david/dev/openwfd/../wpa.conf' driver 'nl80211' ctrl_interface
'N/A' bridge 'N/A'
Configuration file '/home/david/dev/openwfd/../wpa.conf' ->
'/home/david/dev/openwfd/../wpa.conf'
Reading configuration file '/home/david/dev/openwfd/../wpa.conf'
ctrl_interface=3D'/var/run/wpa_supplicant'
ap_scan=3D1
p2p_go_ht40=3D1
device_name=3D'david-ub'
rfkill: initial event: idx=3D2 type=3D1 op=3D0 soft=3D0 hard=3D0
rfkill: initial event: idx=3D3 type=3D1 op=3D0 soft=3D0 hard=3D0
rfkill: initial event: idx=3D4 type=3D2 op=3D0 soft=3D0 hard=3D0
rfkill: initial event: idx=3D5 type=3D2 op=3D0 soft=3D0 hard=3D0
Could not read interface p2p-dev-wlan0 flags: No such device
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:4
nl80211: Supported cipher 00-0f-ac:6
nl80211: Using driver-based off-channel TX
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: interface p2p-dev-wlan0 in phy phy0
nl80211: Set mode ifindex 0 iftype 10 (P2P_DEVICE)
nl80211: Failed to set interface 0 to mode 10: -22 (Invalid argument)
nl80211: Subscribe to mgmt frames with non-AP handle 0x26823f0
nl80211: Register frame type=3D0xd0 nl_handle=3D0x26823f0 match=3D040a
nl80211: Register frame type=3D0xd0 nl_handle=3D0x26823f0 match=3D040b
nl80211: Register frame type=3D0xd0 nl_handle=3D0x26823f0 match=3D040c
nl80211: Register frame type=3D0xd0 nl_handle=3D0x26823f0 match=3D040d
nl80211: Register frame type=3D0xd0 nl_handle=3D0x26823f0 match=3D0409506f9=
a09
nl80211: Register frame type=3D0xd0 nl_handle=3D0x26823f0 match=3D7f506f9a0=
9
nl80211: Register frame type=3D0xd0 nl_handle=3D0x26823f0 match=3D06
nl80211: Register frame type=3D0xd0 nl_handle=3D0x26823f0 match=3D0a07
nl80211: Register frame type=3D0xd0 nl_handle=3D0x26823f0 match=3D0a11
nl80211: Start P2P Device p2p-dev-wlan0 (0x13): Success
nl80211: driver param=3D'p2p_device=3D1'
Add interface p2p-dev-wlan0 to existing radio phy0
nl80211: Regulatory information - country=3D00
nl80211: 2402-2472 @ 40 MHz 20 mBm
nl80211: 2457-2482 @ 40 MHz 20 mBm
nl80211: 2474-2494 @ 20 MHz 20 mBm
nl80211: 5170-5250 @ 160 MHz 20 mBm
nl80211: 5250-5330 @ 160 MHz 20 mBm
nl80211: 5490-5730 @ 160 MHz 20 mBm
p2p-dev-wlan0: Own MAC address: fc:f8:ae:69:8a:62
p2p-dev-wlan0: RSN: flushing PMKID list in the driver
nl80211: Flush PMKIDs
p2p-dev-wlan0: State: DISCONNECTED -> INACTIVE
p2p-dev-wlan0: WPS: UUID from the first interface:
4a7cf8c2-3c3b-5238-b16f-7273f4bb4fda
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
nl80211: Skip set_supp_port(unauthorized) while not associated
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
P2P: Own listen channel: 6
P2P: Random operating channel: 81:6
P2P: Driver did not support fetching of all supported channels; assume
dualband support
P2P: Enable operating classes for 2.4 GHz band
P2P: Enable operating classes for lower 5 GHz band
P2P: Enable operating classes for higher 5 GHz band
P2P: initialized
P2P: channels: 81:1,2,3,4,5,6,7,8,9,10,11 115:36,40,44,48 124:149,153,157,1=
61
P2P: cli_channels:
p2p-dev-wlan0: Added interface p2p-dev-wlan0
p2p-dev-wlan0: State: INACTIVE -> DISCONNECTED
nl80211: Set p2p-dev-wlan0 operstate 0->0 (DORMANT)
netlink: Operstate: ifindex=3D0 linkmode=3D-1 (no change), operstate=3D5
(IF_OPER_DORMANT)
EAPOL: disable timer tick
EAPOL: disable timer tick
CTRL_IFACE monitor attached /tmp/wpa_ctrl_330-101164\x00
CTRL_IFACE monitor attached /tmp/wpa_ctrl_13689-2\x00
wlan0: Control interface command 'BSS RANGE=3DALL MASK=3D0x2'
wlan0: Control interface command 'P2P_SET disallow_freq 5180-5800'
P2P: Disallowed frequency range 5180-5800
P2P: Add operating class 81
P2P: Channels - hexdump(len=3D11): 01 02 03 04 05 06 07 08 09 0a 0b
P2P: Update channel list
P2P: channels: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: cli_channels:
wlan0: Control interface command 'P2P_FIND'
P2P: Starting find (type=3D0)
P2P: Clear timeout (state=3DIDLE)
P2P: State IDLE -> SEARCH
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (148)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Device Name
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Listen Channel: Regulatory Class 81 Channel 6
p2p-dev-wlan0: Add radio work 'p2p-scan'@0x2688e10
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
P2P: Running p2p_scan
p2p-dev-wlan0: Starting radio work 'p2p-scan'@0x2688e10 after 0.000027
second wait
p2p-dev-wlan0: nl80211: scan request
nl80211: P2P probe - mask SuppRates
Scan requested (ret=3D0) - scan timeout 10 seconds
nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for p2p-dev-wlan0
p2p-dev-wlan0: nl80211: Scan trigger
p2p-dev-wlan0: Event SCAN_STARTED (49) received
p2p-dev-wlan0: Own scan request started a scan in 0.000054 seconds
p2p-dev-wlan0: CTRL-EVENT-SCAN-STARTED
nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for p2p-dev-w=
lan0
p2p-dev-wlan0: nl80211: New scan results available
nl80211: Scan probed for SSID 'DIRECT-'
nl80211: Scan included frequencies: 2412 2417 2422 2427 2432 2437 2442
2447 2452 2457 2462 2467 2472 5180 5200 5220 5240 5260 5280 5300 5320
5500 5520 5540 5560 5580 5600 5620 5640 5660 5680 5700 5720 5745 5765
5785 5805 5825
p2p-dev-wlan0: Event SCAN_RESULTS (3) received
p2p-dev-wlan0: Scan completed in 3.621109 seconds
nl80211: Received scan results (2 BSSes)
p2p-dev-wlan0: BSS: Start scan result update 1
p2p-dev-wlan0: BSS: Add new id 0 BSSID 00:18:39:0a:8e:23 SSID 'blockfloete'
p2p-dev-wlan0: BSS: Add new id 1 BSSID 20:2b:c1:4b:8f:a4 SSID 'WLAN-8FA406'
BSS: last_scan_res_used=3D2/32
p2p-dev-wlan0: Radio work 'p2p-scan'@0x2688e10 done in 3.624243 seconds
P2P: Scan results received (2 BSS)
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: State SEARCH -> SEARCH
P2P: Starting short listen state (state=3DSEARCH)
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
p2p-dev-wlan0: Add radio work 'p2p-listen'@0x2688d70
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
p2p-dev-wlan0: Starting radio work 'p2p-listen'@0x2688d70 after
0.000013 second wait
nl80211: Enable Probe Request reporting nl_preq=3D0x26884b0
nl80211: Register frame type=3D0x40 nl_handle=3D0x26884b0 match=3D
nl80211: Remain-on-channel cookie 0x1f7 for freq=3D2437 MHz duration=3D307
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for p2p-dev-=
wlan0
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2437 channel_type=3D0
duration=3D307 cookie=3D0x1f7 (match))
p2p-dev-wlan0: Event REMAIN_ON_CHANNEL (21) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(nil=
))
P2P: Starting Listen timeout(0,307200) on freq=3D2437 based on callback
P2P: Set timeout (state=3DSEARCH): 0.327200 sec
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame freq=3D2437 ssi_signal=3D-26 stype=3D4 len=3D217
p2p-dev-wlan0: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Created device entry based on Probe Req: 12:68:3f:4e:39:f2
dev_capab=3D0x25 group_capab=3D0x0 name=3D'dvdhrm-nx' listen_freq=3D2437
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: send_mlme - noack=3D1 freq=3D0 no_cck=3D0 offchanok=3D0 wait_time=
=3D0
fc=3D0x50 nlmode=3D10
nl80211: Use last_mgmt_freq=3D2437
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame freq=3D2437 ssi_signal=3D-26 stype=3D4 len=3D217
p2p-dev-wlan0: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: send_mlme - noack=3D1 freq=3D0 no_cck=3D0 offchanok=3D0 wait_time=
=3D0
fc=3D0x50 nlmode=3D10
nl80211: Use last_mgmt_freq=3D2437
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame freq=3D2437 ssi_signal=3D-26 stype=3D4 len=3D217
p2p-dev-wlan0: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: send_mlme - noack=3D1 freq=3D0 no_cck=3D0 offchanok=3D0 wait_time=
=3D0
fc=3D0x50 nlmode=3D10
nl80211: Use last_mgmt_freq=3D2437
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame freq=3D2437 ssi_signal=3D-26 stype=3D4 len=3D217
p2p-dev-wlan0: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: send_mlme - noack=3D1 freq=3D0 no_cck=3D0 offchanok=3D0 wait_time=
=3D0
fc=3D0x50 nlmode=3D10
nl80211: Use last_mgmt_freq=3D2437
nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2437 channel_type=3D0
duration=3D0 cookie=3D0x1f7 (match))
p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms
pending_action_tx=3D(nil))
p2p-dev-wlan0: Radio work 'p2p-listen'@0x2688d70 done in 0.307052 seconds
P2P: Driver ended Listen state (freq=3D2437)
P2P: Skip stop_listen since not in listen_only state.
P2P: Timeout (state=3DSEARCH)
nl80211: Disable Probe Request reporting nl_preq=3D0x888888888ae00c39
P2P: Starting search
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (148)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Device Name
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Listen Channel: Regulatory Class 81 Channel 6
p2p-dev-wlan0: Add radio work 'p2p-scan'@0x2688480
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
P2P: Running p2p_scan
p2p-dev-wlan0: Starting radio work 'p2p-scan'@0x2688480 after 0.000010
second wait
p2p-dev-wlan0: nl80211: scan request
nl80211: P2P probe - mask SuppRates
Scan requested (ret=3D0) - scan timeout 30 seconds
nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for p2p-dev-wlan0
p2p-dev-wlan0: nl80211: Scan trigger
p2p-dev-wlan0: Event SCAN_STARTED (49) received
p2p-dev-wlan0: Own scan request started a scan in 0.000024 seconds
p2p-dev-wlan0: CTRL-EVENT-SCAN-STARTED
nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for p2p-dev-w=
lan0
p2p-dev-wlan0: nl80211: New scan results available
nl80211: Scan probed for SSID 'DIRECT-'
nl80211: Scan included frequencies: 2412 2437 2462
p2p-dev-wlan0: Event SCAN_RESULTS (3) received
p2p-dev-wlan0: Scan completed in 0.120549 seconds
nl80211: Received scan results (3 BSSes)
p2p-dev-wlan0: BSS: Start scan result update 2
BSS: last_scan_res_used=3D2/32
p2p-dev-wlan0: Radio work 'p2p-scan'@0x2688480 done in 0.123633 seconds
P2P: Scan results received (3 BSS)
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 13 length 30
P2P: * Device Info: addr 12:68:3f:4e:39:f2 primary device type
10-0050F204-5 device name 'dvdhrm-nx' config methods 0x188
P2P: Update peer 12:68:3f:4e:39:f2 config_methods 0x0 -> 0x188
P2P: Peer found with Listen frequency 2437 MHz (rx_time=3D543995.014134)
P2P-DEVICE-FOUND 12:68:3f:4e:39:f2 p2p_dev_addr=3D12:68:3f:4e:39:f2
pri_dev_type=3D10-0050F204-5 name=3D'dvdhrm-nx' config_methods=3D0x188
dev_capab=3D0x25 group_capab=3D0x0
P2P: State SEARCH -> SEARCH
P2P: Starting short listen state (state=3DSEARCH)
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
p2p-dev-wlan0: Add radio work 'p2p-listen'@0x2684460
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
p2p-dev-wlan0: Starting radio work 'p2p-listen'@0x2684460 after
0.000013 second wait
nl80211: Enable Probe Request reporting nl_preq=3D0x2688500
nl80211: Register frame type=3D0x40 nl_handle=3D0x2688500 match=3D
nl80211: Remain-on-channel cookie 0x1f8 for freq=3D2437 MHz duration=3D204
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for p2p-dev-=
wlan0
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2437 channel_type=3D0
duration=3D204 cookie=3D0x1f8 (match))
p2p-dev-wlan0: Event REMAIN_ON_CHANNEL (21) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(nil=
))
P2P: Starting Listen timeout(0,204800) on freq=3D2437 based on callback
P2P: Set timeout (state=3DSEARCH): 0.224800 sec
nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2437 channel_type=3D0
duration=3D0 cookie=3D0x1f8 (match))
p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms
pending_action_tx=3D(nil))
p2p-dev-wlan0: Radio work 'p2p-listen'@0x2684460 done in 0.204294 seconds
P2P: Driver ended Listen state (freq=3D2437)
P2P: Skip stop_listen since not in listen_only state.
P2P: Timeout (state=3DSEARCH)
nl80211: Disable Probe Request reporting nl_preq=3D0x888888888ae00d89
P2P: Starting search
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (148)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Device Name
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Listen Channel: Regulatory Class 81 Channel 6
p2p-dev-wlan0: Add radio work 'p2p-scan'@0x2688480
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
P2P: Running p2p_scan
p2p-dev-wlan0: Starting radio work 'p2p-scan'@0x2688480 after 0.000011
second wait
p2p-dev-wlan0: nl80211: scan request
nl80211: P2P probe - mask SuppRates
Scan requested (ret=3D0) - scan timeout 30 seconds
nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for p2p-dev-wlan0
p2p-dev-wlan0: nl80211: Scan trigger
p2p-dev-wlan0: Event SCAN_STARTED (49) received
p2p-dev-wlan0: Own scan request started a scan in 0.000035 seconds
p2p-dev-wlan0: CTRL-EVENT-SCAN-STARTED
nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for p2p-dev-w=
lan0
p2p-dev-wlan0: nl80211: New scan results available
nl80211: Scan probed for SSID 'DIRECT-'
nl80211: Scan included frequencies: 2412 2437 2462
p2p-dev-wlan0: Event SCAN_RESULTS (3) received
p2p-dev-wlan0: Scan completed in 0.120551 seconds
nl80211: Received scan results (3 BSSes)
p2p-dev-wlan0: BSS: Start scan result update 3
BSS: last_scan_res_used=3D2/32
p2p-dev-wlan0: Radio work 'p2p-scan'@0x2688480 done in 0.123661 seconds
P2P: Scan results received (3 BSS)
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 13 length 30
P2P: * Device Info: addr 12:68:3f:4e:39:f2 primary device type
10-0050F204-5 device name 'dvdhrm-nx' config methods 0x188
P2P: State SEARCH -> SEARCH
P2P: Starting short listen state (state=3DSEARCH)
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
p2p-dev-wlan0: Add radio work 'p2p-listen'@0x2684460
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
p2p-dev-wlan0: Starting radio work 'p2p-listen'@0x2684460 after
0.000013 second wait
nl80211: Enable Probe Request reporting nl_preq=3D0x2688500
nl80211: Register frame type=3D0x40 nl_handle=3D0x2688500 match=3D
nl80211: Remain-on-channel cookie 0x1f9 for freq=3D2437 MHz duration=3D307
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for p2p-dev-=
wlan0
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2437 channel_type=3D0
duration=3D307 cookie=3D0x1f9 (match))
p2p-dev-wlan0: Event REMAIN_ON_CHANNEL (21) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(nil=
))
P2P: Starting Listen timeout(0,307200) on freq=3D2437 based on callback
P2P: Set timeout (state=3DSEARCH): 0.327200 sec
nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2437 channel_type=3D0
duration=3D0 cookie=3D0x1f9 (match))
p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms
pending_action_tx=3D(nil))
p2p-dev-wlan0: Radio work 'p2p-listen'@0x2684460 done in 0.306672 seconds
P2P: Driver ended Listen state (freq=3D2437)
P2P: Skip stop_listen since not in listen_only state.
P2P: Timeout (state=3DSEARCH)
nl80211: Disable Probe Request reporting nl_preq=3D0x888888888ae00d89
P2P: Starting search
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (148)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Device Name
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Listen Channel: Regulatory Class 81 Channel 6
p2p-dev-wlan0: Add radio work 'p2p-scan'@0x2688480
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
P2P: Running p2p_scan
p2p-dev-wlan0: Starting radio work 'p2p-scan'@0x2688480 after 0.000021
second wait
p2p-dev-wlan0: nl80211: scan request
nl80211: P2P probe - mask SuppRates
Scan requested (ret=3D0) - scan timeout 30 seconds
nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for p2p-dev-wlan0
p2p-dev-wlan0: nl80211: Scan trigger
p2p-dev-wlan0: Event SCAN_STARTED (49) received
p2p-dev-wlan0: Own scan request started a scan in 0.000022 seconds
p2p-dev-wlan0: CTRL-EVENT-SCAN-STARTED
nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for p2p-dev-w=
lan0
p2p-dev-wlan0: nl80211: New scan results available
nl80211: Scan probed for SSID 'DIRECT-'
nl80211: Scan included frequencies: 2412 2437 2462
p2p-dev-wlan0: Event SCAN_RESULTS (3) received
p2p-dev-wlan0: Scan completed in 0.120602 seconds
nl80211: Received scan results (3 BSSes)
p2p-dev-wlan0: BSS: Start scan result update 4
BSS: last_scan_res_used=3D2/32
p2p-dev-wlan0: Radio work 'p2p-scan'@0x2688480 done in 0.123529 seconds
P2P: Scan results received (3 BSS)
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 13 length 30
P2P: * Device Info: addr 12:68:3f:4e:39:f2 primary device type
10-0050F204-5 device name 'dvdhrm-nx' config methods 0x188
P2P: State SEARCH -> SEARCH
P2P: Starting short listen state (state=3DSEARCH)
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
p2p-dev-wlan0: Add radio work 'p2p-listen'@0x2684460
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
p2p-dev-wlan0: Starting radio work 'p2p-listen'@0x2684460 after
0.000011 second wait
nl80211: Enable Probe Request reporting nl_preq=3D0x2688500
nl80211: Register frame type=3D0x40 nl_handle=3D0x2688500 match=3D
nl80211: Remain-on-channel cookie 0x1fa for freq=3D2437 MHz duration=3D102
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for p2p-dev-=
wlan0
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2437 channel_type=3D0
duration=3D102 cookie=3D0x1fa (match))
p2p-dev-wlan0: Event REMAIN_ON_CHANNEL (21) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(nil=
))
P2P: Starting Listen timeout(0,102400) on freq=3D2437 based on callback
P2P: Set timeout (state=3DSEARCH): 0.122400 sec
nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2437 channel_type=3D0
duration=3D0 cookie=3D0x1fa (match))
p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms
pending_action_tx=3D(nil))
p2p-dev-wlan0: Radio work 'p2p-listen'@0x2684460 done in 0.101841 seconds
P2P: Driver ended Listen state (freq=3D2437)
P2P: Skip stop_listen since not in listen_only state.
P2P: Timeout (state=3DSEARCH)
nl80211: Disable Probe Request reporting nl_preq=3D0x888888888ae00d89
P2P: Starting search
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (148)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Device Name
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Listen Channel: Regulatory Class 81 Channel 6
p2p-dev-wlan0: Add radio work 'p2p-scan'@0x2688480
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
P2P: Running p2p_scan
p2p-dev-wlan0: Starting radio work 'p2p-scan'@0x2688480 after 0.000010
second wait
p2p-dev-wlan0: nl80211: scan request
nl80211: P2P probe - mask SuppRates
Scan requested (ret=3D0) - scan timeout 30 seconds
nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for p2p-dev-wlan0
p2p-dev-wlan0: nl80211: Scan trigger
p2p-dev-wlan0: Event SCAN_STARTED (49) received
p2p-dev-wlan0: Own scan request started a scan in 0.000022 seconds
p2p-dev-wlan0: CTRL-EVENT-SCAN-STARTED
nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for p2p-dev-w=
lan0
p2p-dev-wlan0: nl80211: New scan results available
nl80211: Scan probed for SSID 'DIRECT-'
nl80211: Scan included frequencies: 2412 2437 2462
p2p-dev-wlan0: Event SCAN_RESULTS (3) received
p2p-dev-wlan0: Scan completed in 0.120486 seconds
nl80211: Received scan results (3 BSSes)
p2p-dev-wlan0: BSS: Start scan result update 5
BSS: last_scan_res_used=3D2/32
p2p-dev-wlan0: Radio work 'p2p-scan'@0x2688480 done in 0.123480 seconds
P2P: Scan results received (3 BSS)
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 13 length 30
P2P: * Device Info: addr 12:68:3f:4e:39:f2 primary device type
10-0050F204-5 device name 'dvdhrm-nx' config methods 0x188
P2P: State SEARCH -> SEARCH
P2P: Starting short listen state (state=3DSEARCH)
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
p2p-dev-wlan0: Add radio work 'p2p-listen'@0x2684460
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
p2p-dev-wlan0: Starting radio work 'p2p-listen'@0x2684460 after
0.000011 second wait
nl80211: Enable Probe Request reporting nl_preq=3D0x2688500
nl80211: Register frame type=3D0x40 nl_handle=3D0x2688500 match=3D
nl80211: Remain-on-channel cookie 0x1fb for freq=3D2437 MHz duration=3D102
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for p2p-dev-=
wlan0
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2437 channel_type=3D0
duration=3D102 cookie=3D0x1fb (match))
p2p-dev-wlan0: Event REMAIN_ON_CHANNEL (21) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(nil=
))
P2P: Starting Listen timeout(0,102400) on freq=3D2437 based on callback
P2P: Set timeout (state=3DSEARCH): 0.122400 sec
nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2437 channel_type=3D0
duration=3D0 cookie=3D0x1fb (match))
p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms
pending_action_tx=3D(nil))
p2p-dev-wlan0: Radio work 'p2p-listen'@0x2684460 done in 0.101838 seconds
P2P: Driver ended Listen state (freq=3D2437)
P2P: Skip stop_listen since not in listen_only state.
P2P: Timeout (state=3DSEARCH)
nl80211: Disable Probe Request reporting nl_preq=3D0x888888888ae00d89
P2P: Starting search
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (148)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Device Name
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Listen Channel: Regulatory Class 81 Channel 6
p2p-dev-wlan0: Add radio work 'p2p-scan'@0x2688480
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
P2P: Running p2p_scan
p2p-dev-wlan0: Starting radio work 'p2p-scan'@0x2688480 after 0.000010
second wait
p2p-dev-wlan0: nl80211: scan request
nl80211: P2P probe - mask SuppRates
Scan requested (ret=3D0) - scan timeout 30 seconds
nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for p2p-dev-wlan0
p2p-dev-wlan0: nl80211: Scan trigger
p2p-dev-wlan0: Event SCAN_STARTED (49) received
p2p-dev-wlan0: Own scan request started a scan in 0.000034 seconds
p2p-dev-wlan0: CTRL-EVENT-SCAN-STARTED
nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for p2p-dev-w=
lan0
p2p-dev-wlan0: nl80211: New scan results available
nl80211: Scan probed for SSID 'DIRECT-'
nl80211: Scan included frequencies: 2412 2437 2462
p2p-dev-wlan0: Event SCAN_RESULTS (3) received
p2p-dev-wlan0: Scan completed in 0.120458 seconds
nl80211: Received scan results (3 BSSes)
p2p-dev-wlan0: BSS: Start scan result update 6
BSS: last_scan_res_used=3D2/32
p2p-dev-wlan0: Radio work 'p2p-scan'@0x2688480 done in 0.123409 seconds
P2P: Scan results received (3 BSS)
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 13 length 30
P2P: * Device Info: addr 12:68:3f:4e:39:f2 primary device type
10-0050F204-5 device name 'dvdhrm-nx' config methods 0x188
P2P: State SEARCH -> SEARCH
P2P: Starting short listen state (state=3DSEARCH)
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
p2p-dev-wlan0: Add radio work 'p2p-listen'@0x2684460
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
p2p-dev-wlan0: Starting radio work 'p2p-listen'@0x2684460 after
0.000011 second wait
nl80211: Enable Probe Request reporting nl_preq=3D0x2688500
nl80211: Register frame type=3D0x40 nl_handle=3D0x2688500 match=3D
nl80211: Remain-on-channel cookie 0x1fc for freq=3D2437 MHz duration=3D102
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for p2p-dev-=
wlan0
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2437 channel_type=3D0
duration=3D102 cookie=3D0x1fc (match))
p2p-dev-wlan0: Event REMAIN_ON_CHANNEL (21) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(nil=
))
P2P: Starting Listen timeout(0,102400) on freq=3D2437 based on callback
P2P: Set timeout (state=3DSEARCH): 0.122400 sec
nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2437 channel_type=3D0
duration=3D0 cookie=3D0x1fc (match))
p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms
pending_action_tx=3D(nil))
p2p-dev-wlan0: Radio work 'p2p-listen'@0x2684460 done in 0.101805 seconds
P2P: Driver ended Listen state (freq=3D2437)
P2P: Skip stop_listen since not in listen_only state.
P2P: Timeout (state=3DSEARCH)
nl80211: Disable Probe Request reporting nl_preq=3D0x888888888ae00d89





[cut 6000 lines of "P2P: Starting search"+log]





P2P: Starting search
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (148)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Device Name
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Listen Channel: Regulatory Class 81 Channel 6
p2p-dev-wlan0: Add radio work 'p2p-scan'@0x2688480
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
P2P: Running p2p_scan
p2p-dev-wlan0: Starting radio work 'p2p-scan'@0x2688480 after 0.000011
second wait
p2p-dev-wlan0: nl80211: scan request
nl80211: P2P probe - mask SuppRates
Scan requested (ret=3D0) - scan timeout 30 seconds
nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for p2p-dev-wlan0
p2p-dev-wlan0: nl80211: Scan trigger
p2p-dev-wlan0: Event SCAN_STARTED (49) received
p2p-dev-wlan0: Own scan request started a scan in 0.000034 seconds
p2p-dev-wlan0: CTRL-EVENT-SCAN-STARTED
nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for p2p-dev-w=
lan0
p2p-dev-wlan0: nl80211: New scan results available
nl80211: Scan probed for SSID 'DIRECT-'
nl80211: Scan included frequencies: 2412 2437 2462
p2p-dev-wlan0: Event SCAN_RESULTS (3) received
p2p-dev-wlan0: Scan completed in 0.120480 seconds
nl80211: Received scan results (4 BSSes)
p2p-dev-wlan0: BSS: Start scan result update 38
BSS: last_scan_res_used=3D3/32
p2p-dev-wlan0: Radio work 'p2p-scan'@0x2688480 done in 0.123429 seconds
P2P: Scan results received (4 BSS)
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Ignore scan data without P2P Device Info or P2P Device Id
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 13 length 30
P2P: * Device Info: addr 12:68:3f:4e:39:f2 primary device type
10-0050F204-5 device name 'dvdhrm-nx' config methods 0x188
P2P: State SEARCH -> SEARCH
P2P: Starting short listen state (state=3DSEARCH)
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
p2p-dev-wlan0: Add radio work 'p2p-listen'@0x2684460
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
p2p-dev-wlan0: Starting radio work 'p2p-listen'@0x2684460 after
0.000011 second wait
nl80211: Enable Probe Request reporting nl_preq=3D0x2688500
nl80211: Register frame type=3D0x40 nl_handle=3D0x2688500 match=3D
nl80211: Remain-on-channel cookie 0x21c for freq=3D2437 MHz duration=3D204
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for p2p-dev-=
wlan0
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2437 channel_type=3D0
duration=3D204 cookie=3D0x21c (match))
p2p-dev-wlan0: Event REMAIN_ON_CHANNEL (21) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(nil=
))
P2P: Starting Listen timeout(0,204800) on freq=3D2437 based on callback
P2P: Set timeout (state=3DSEARCH): 0.224800 sec
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame freq=3D2437 ssi_signal=3D-27 stype=3D4 len=3D217
p2p-dev-wlan0: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: send_mlme - noack=3D1 freq=3D0 no_cck=3D0 offchanok=3D0 wait_time=
=3D0
fc=3D0x50 nlmode=3D10
nl80211: Use last_mgmt_freq=3D2437
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame freq=3D2437 ssi_signal=3D-27 stype=3D4 len=3D217
p2p-dev-wlan0: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: send_mlme - noack=3D1 freq=3D0 no_cck=3D0 offchanok=3D0 wait_time=
=3D0
fc=3D0x50 nlmode=3D10
nl80211: Use last_mgmt_freq=3D2437
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame freq=3D2437 ssi_signal=3D-27 stype=3D4 len=3D217
p2p-dev-wlan0: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: send_mlme - noack=3D1 freq=3D0 no_cck=3D0 offchanok=3D0 wait_time=
=3D0
fc=3D0x50 nlmode=3D10
nl80211: Use last_mgmt_freq=3D2437
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame freq=3D2437 ssi_signal=3D-27 stype=3D4 len=3D217
p2p-dev-wlan0: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x4388
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: send_mlme - noack=3D1 freq=3D0 no_cck=3D0 offchanok=3D0 wait_time=
=3D0
fc=3D0x50 nlmode=3D10
nl80211: Use last_mgmt_freq=3D2437
wlan0: Control interface command 'P2P_CONNECT 12:68:3f:4e:39:f2 pbc'
wlan0: Determining shared radio frequencies (max len 1)
wlan0: Shared frequencies (len=3D0): completed iteration
P2P: Setup freqs: freq=3D0 num_MCC=3D1 shared_freqs=3D0
P2P: No current operating channels - try to use a new channel
P2P: Own frequency preference: 0 MHz
P2P: Create a new interface p2p-wlan0-0 for the group
nl80211: Create interface iftype 8 (P2P_CLIENT)
nl80211: New interface p2p-wlan0-0 created: ifindex=3D14
nl80211: Add own interface ifindex 14
nl80211: Set TX rates failed: ret=3D-100 (Network is down)
P2P: Created pending virtual interface p2p-wlan0-0 addr fc:f8:ae:69:8a:63
P2P: Request to start group negotiation - peer=3D12:68:3f:4e:39:f2  GO
Intent=3D7  Intended Interface Address=3Dfc:f8:ae:69:8a:63 wps_method=3D3
persistent_group=3D0 pd_before_go_neg=3D0
P2P: Prepare channel - force_freq=3D0 pref_freq=3D0 go=3D0
P2P: Prepare channel best
P2P: Select pre-configured channel as operating channel preference
P2P: prepared channels: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: after go/cli filter/add: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: Own preference for operation channel: Operating Class 81 Channel 6
P2P: Stopping find
P2P: Clear timeout (state=3DSEARCH)
P2P-FIND-STOPPED
P2P: State SEARCH -> IDLE
P2P: Clear timeout (state=3DIDLE)
P2P: Clear drv_in_listen (2437)
nl80211: Cancel remain-on-channel with cookie 0x21c
nl80211: Disable Probe Request reporting nl_preq=3D0x888888888ae00d89
p2p-dev-wlan0: Radio work 'p2p-listen'@0x2684460 done in 0.182411 seconds
P2P: * Dialog Token: 1
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D08
P2P: * GO Intent: Intent 7 Tie breaker 1
P2P: * Configuration Timeout: GO 255 (*10ms)  client 20 (*10ms)
P2P: * Listen Channel: Regulatory Class 81 Channel 6
P2P: * Intended P2P Interface Address fc:f8:ae:69:8a:63
P2P: * Channel List - hexdump(len=3D16): 58 58 04 51 0b 01 02 03 04 05
06 07 08 09 0a 0b
P2P: * Device Info
P2P: * Operating Channel: Regulatory Class 81 Channel 6
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 4
P2P: Sending GO Negotiation Request
P2P: State IDLE -> CONNECT
P2P: Schedule new radio work for Action frame TX (listen_freq=3D-1 send_fre=
q=3D-1)
p2p-dev-wlan0: Add radio work 'p2p-send-action'@0x26884b0
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
p2p-dev-wlan0: Starting radio work 'p2p-send-action'@0x26884b0 after
0.000024 second wait
Off-channel: Send action frame: freq=3D2437 dst=3D12:68:3f:4e:39:f2
src=3Dfc:f8:ae:69:8a:62 bssid=3D12:68:3f:4e:39:f2 len=3D121
nl80211: Send Action frame (ifindex=3D0, freq=3D2437 MHz wait=3D500 ms no_c=
ck=3D1)
RTM_NEWLINK: ifi_index=3D14 ifname=3Dp2p-wlan0-0 operstate=3D2 linkmode=3D0
ifi_flags=3D0x1002 ()
nl80211: Ignore interface down event since interface p2p-wlan0-0 is up
nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2437 channel_type=3D0
duration=3D0 cookie=3D0x21c (match))
p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms
pending_action_tx=3D0x2684390)
P2P: Driver ended Listen state (freq=3D2437)
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) received for p2p-dev-wl=
an0
nl80211: Frame TX status event
nl80211: Action TX status: cookie=3D0ffff8800a7cb1900 (match) (ack=3D1)
p2p-dev-wlan0: Event TX_STATUS (18) received
p2p-dev-wlan0: EVENT_TX_STATUS dst=3D12:68:3f:4e:39:f2 type=3D0 stype=3D13
Off-channel: Delete matching pending action frame
Off-channel: TX status result=3D0 cb=3D0x42fbc0
P2P: Action frame TX callback (state=3D1 freq=3D2437 dst=3D12:68:3f:4e:39:f=
2
src=3Dfc:f8:ae:69:8a:62 bssid=3D12:68:3f:4e:39:f2 result=3D0
P2P: GO Negotiation Request TX callback: success=3D1
P2P: State CONNECT -> CONNECT
P2P: Set timeout (state=3DCONNECT): 0.500000 sec
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame freq=3D2437 ssi_signal=3D-27 stype=3D13 len=3D160
p2p-dev-wlan0: Event RX_MGMT (20) received
p2p-dev-wlan0: Received Action frame: SA=3D12:68:3f:4e:39:f2 Category=3D4
DataLen=3D135 freq=3D2437 MHz
P2P: RX P2P Public Action from 12:68:3f:4e:39:f2
P2P: Received GO Negotiation Response from 12:68:3f:4e:39:f2 (freq=3D2437)
P2P: Parsing the received message
P2P: * Dialog Token: 1
P2P: Parsing WPS IE
P2P: Device Password ID: 0
P2P: Parsing P2P IE
P2P: Attribute 0 length 1
P2P: * Status: 1
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 4 length 1
P2P: * GO Intent: Intent 6 Tie breaker 0
P2P: Attribute 5 length 2
P2P: * Configuration Timeout
P2P: Attribute 17 length 5
P2P: * Operating Channel: Country DE(0x04) Regulatory Class 81 Channel Numb=
er 9
P2P: Attribute 9 length 6
P2P: * Intended P2P Interface Address: 12:68:3f:4e:b9:f2
P2P: Attribute 11 length 24
P2P: * Channel List: Country String 'DE(0x04)'
P2P: Attribute 13 length 30
P2P: * Device Info: addr 12:68:3f:4e:39:f2 primary device type
10-0050F204-5 device name 'dvdhrm-nx' config methods 0x188
P2P: GO Negotiation rejected: status 1
P2P: Wait for the peer to become ready for GO Negotiation
P2P: State CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.000000 sec
p2p-dev-wlan0: Radio work 'p2p-send-action'@0x26884b0 done in 0.006611 seco=
nds
Off-channel: Action frame sequence done notification
nl80211: Cancel TX frame wait: cookie=3D0xffff8800a7cb1900
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for
GO Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 4
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
p2p-dev-wlan0: Add radio work 'p2p-listen'@0x2684450
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
p2p-dev-wlan0: Starting radio work 'p2p-listen'@0x2684450 after
0.000008 second wait
nl80211: Enable Probe Request reporting nl_preq=3D0x2688400
nl80211: Register frame type=3D0x40 nl_handle=3D0x2688400 match=3D
nl80211: Remain-on-channel cookie 0x21d for freq=3D2437 MHz duration=3D102
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for p2p-dev-=
wlan0
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2437 channel_type=3D0
duration=3D102 cookie=3D0x21d (match))
p2p-dev-wlan0: Event REMAIN_ON_CHANNEL (21) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(nil=
))
P2P: Starting Listen timeout(0,102400) on freq=3D2437 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.122400 sec
nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2437 channel_type=3D0
duration=3D0 cookie=3D0x21d (match))
p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms
pending_action_tx=3D(nil))
p2p-dev-wlan0: Radio work 'p2p-listen'@0x2684450 done in 0.108517 seconds
P2P: Driver ended Listen state (freq=3D2437)
P2P: Skip stop_listen since not in listen_only state.
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for
GO Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 4
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
p2p-dev-wlan0: Add radio work 'p2p-listen'@0x2684390
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
p2p-dev-wlan0: Starting radio work 'p2p-listen'@0x2684390 after
0.000011 second wait
nl80211: Probe Request reporting already on! nl_preq=3D0x888888888ae00c89
nl80211: Remain-on-channel cookie 0x21e for freq=3D2437 MHz duration=3D204
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for p2p-dev-=
wlan0
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2437 channel_type=3D0
duration=3D204 cookie=3D0x21e (match))
p2p-dev-wlan0: Event REMAIN_ON_CHANNEL (21) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(nil=
))
P2P: Starting Listen timeout(0,204800) on freq=3D2437 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.224800 sec
nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2437 channel_type=3D0
duration=3D0 cookie=3D0x21e (match))
p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms
pending_action_tx=3D(nil))
p2p-dev-wlan0: Radio work 'p2p-listen'@0x2684390 done in 0.204276 seconds
P2P: Driver ended Listen state (freq=3D2437)
P2P: Skip stop_listen since not in listen_only state.
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for
GO Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 4
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
p2p-dev-wlan0: Add radio work 'p2p-listen'@0x2684390
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
p2p-dev-wlan0: Starting radio work 'p2p-listen'@0x2684390 after
0.000008 second wait
nl80211: Probe Request reporting already on! nl_preq=3D0x888888888ae00c89
nl80211: Remain-on-channel cookie 0x21f for freq=3D2437 MHz duration=3D307
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for p2p-dev-=
wlan0
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2437 channel_type=3D0
duration=3D307 cookie=3D0x21f (match))
p2p-dev-wlan0: Event REMAIN_ON_CHANNEL (21) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(nil=
))
P2P: Starting Listen timeout(0,307200) on freq=3D2437 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.327200 sec
nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2437 channel_type=3D0
duration=3D0 cookie=3D0x21f (match))
p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms
pending_action_tx=3D(nil))
p2p-dev-wlan0: Radio work 'p2p-listen'@0x2684390 done in 0.306637 seconds
P2P: Driver ended Listen state (freq=3D2437)
P2P: Skip stop_listen since not in listen_only state.
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for
GO Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 4
WPS:  * UUID-E
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
p2p-dev-wlan0: Add radio work 'p2p-listen'@0x2684390
p2p-dev-wlan0: First radio work item in the queue - schedule start immediat=
ely
p2p-dev-wlan0: Starting radio work 'p2p-listen'@0x2684390 after
0.000009 second wait
nl80211: Probe Request reporting already on! nl_preq=3D0x888888888ae00c89
nl80211: Remain-on-channel cookie 0x220 for freq=3D2437 MHz duration=3D102
nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for p2p-dev-=
wlan0
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2437 channel_type=3D0
duration=3D102 cookie=3D0x220 (match))
p2p-dev-wlan0: Event REMAIN_ON_CHANNEL (21) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(nil=
))
P2P: Starting Listen timeout(0,102400) on freq=3D2437 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.122400 sec
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame freq=3D2437 ssi_signal=3D-26 stype=3D13 len=3D164
p2p-dev-wlan0: Event RX_MGMT (20) received
p2p-dev-wlan0: Received Action frame: SA=3D12:68:3f:4e:39:f2 Category=3D4
DataLen=3D139 freq=3D2437 MHz
P2P: RX P2P Public Action from 12:68:3f:4e:39:f2
P2P: Received GO Negotiation Request from 12:68:3f:4e:39:f2(freq=3D2437)
P2P: Parsing the received message
P2P: * Dialog Token: 1
P2P: Parsing WPS IE
P2P: Device Password ID: 4
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 2a
P2P: Attribute 4 length 1
P2P: * GO Intent: Intent 6 Tie breaker 0
P2P: Attribute 5 length 2
P2P: * Configuration Timeout
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country DE(0x04) Regulatory Class 81 Channel Number =
6
P2P: Attribute 9 length 6
P2P: * Intended P2P Interface Address: 12:68:3f:4e:b9:f2
P2P: Attribute 11 length 24
P2P: * Channel List: Country String 'DE(0x04)'
P2P: Attribute 13 length 30
P2P: * Device Info: addr 12:68:3f:4e:39:f2 primary device type
10-0050F204-5 device name 'dvdhrm-nx' config methods 0x80
P2P: Attribute 17 length 5
P2P: * Operating Channel: Country DE(0x04) Regulatory Class 81 Channel Numb=
er 9
P2P: Peer country - hexdump_ascii(len=3D3):
     44 45 04                                          DE_
P2P: Own reg_classes 1 peer reg_classes 2 intersection reg_classes 1
P2P: Peer using pushbutton
P2P: own channels: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: peer channels: 81:1,2,3,4,5,6,7,8,9,10,11,12,13 115:36,40,44,48
P2P: intersection: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: intersection after no-GO removal: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: intersection with local channel list: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: Try to optimize channel selection with peer information received;
previously selected op_class 81 channel 6
P2P: Using original operating class and channel (op_class 81 channel
6) from intersection
P2P: Peer operating channel preference: 2452 MHz
P2P: GO Negotiation with 12:68:3f:4e:39:f2
P2P: Stopping find
P2P: Clear timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> IDLE
P2P: Skip stop_listen since we are on correct channel for response
P2P: State IDLE -> GO_NEG
P2P: Clear timeout (state=3DGO_NEG)
P2P: Building GO Negotiation Response
P2P: * Dialog Token: 1
P2P: * P2P IE header
P2P: * Status: 0
P2P: * Capability dev=3D25 group=3D08
P2P: * GO Intent: Intent 7 Tie breaker 1
P2P: * Configuration Timeout: GO 255 (*10ms)  client 20 (*10ms)
P2P: * Operating Channel: Regulatory Class 81 Channel 6
P2P: * Intended P2P Interface Address fc:f8:ae:69:8a:63
P2P: * Channel List - hexdump(len=3D16): 58 58 04 51 0b 01 02 03 04 05
06 07 08 09 0a 0b
P2P: * Device Info
P2P: * P2P Group ID fc:f8:ae:69:8a:62
P2P: P2P Group ID SSID - hexdump_ascii(len=3D9):
     44 49 52 45 43 54 2d 65 6c                        DIRECT-el
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 4
P2P: Sending GO Negotiation Response
P2P: Use ongoing radio work for Action frame TX
Off-channel: Send action frame: freq=3D2437 dst=3D12:68:3f:4e:39:f2
src=3Dfc:f8:ae:69:8a:62 bssid=3Dfc:f8:ae:69:8a:62 len=3D135
nl80211: Send Action frame (ifindex=3D0, freq=3D2437 MHz wait=3D500 ms no_c=
ck=3D1)
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) received for p2p-dev-wl=
an0
nl80211: Frame TX status event
nl80211: Action TX status: cookie=3D0ffff8801495d4b00 (match) (ack=3D1)
p2p-dev-wlan0: Event TX_STATUS (18) received
p2p-dev-wlan0: EVENT_TX_STATUS dst=3D12:68:3f:4e:39:f2 type=3D0 stype=3D13
Off-channel: Delete matching pending action frame
Off-channel: TX status result=3D0 cb=3D0x42fbc0
P2P: Action frame TX callback (state=3D2 freq=3D2437 dst=3D12:68:3f:4e:39:f=
2
src=3Dfc:f8:ae:69:8a:62 bssid=3Dfc:f8:ae:69:8a:62 result=3D0
P2P: GO Negotiation Response TX callback: success=3D1
P2P: State GO_NEG -> CONNECT
P2P: Set timeout (state=3DCONNECT): 0.500000 sec
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for p2p-dev-wlan0
nl80211: RX frame freq=3D2437 ssi_signal=3D-26 stype=3D13 len=3D74
p2p-dev-wlan0: Event RX_MGMT (20) received
p2p-dev-wlan0: Received Action frame: SA=3D12:68:3f:4e:39:f2 Category=3D4
DataLen=3D49 freq=3D2437 MHz
P2P: RX P2P Public Action from 12:68:3f:4e:39:f2
P2P: Received GO Negotiation Confirm from 12:68:3f:4e:39:f2
P2P: Parsing the received message
P2P: * Dialog Token: 1
P2P: Parsing P2P IE
P2P: Attribute 0 length 1
P2P: * Status: 0
P2P: Attribute 2 length 2
P2P: * Device Capability 25 Group Capability 00
P2P: Attribute 17 length 5
P2P: * Operating Channel: Country XX(0x04) Regulatory Class 81 Channel Numb=
er 6
P2P: Attribute 11 length 16
P2P: * Channel List: Country String 'DE(0x04)'
P2P: 20 ms wait on current channel before starting group
P2P: GO Negotiation with 12:68:3f:4e:39:f2 completed (local end will be GO)
P2P: own channels: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: peer channels: 81:1,2,3,4,5,6,7,8,9,10,11,12,13 115:36,40,44,48
P2P: intersection after no-GO removal: 81:1,2,3,4,5,6,7,8,9,10,11
P2P: Clear timeout (state=3DCONNECT)
P2P: State CONNECT -> PROVISIONING
nl80211: Cancel remain-on-channel with cookie 0x220
P2P-GO-NEG-SUCCESS role=3DGO freq=3D2437 ht40=3D0 peer_dev=3D12:68:3f:4e:39=
:f2
peer_iface=3D12:68:3f:4e:b9:f2 wps_method=3DPBC
p2p-dev-wlan0: P2P: Starting GO
p2p-dev-wlan0: P2P: Request scan (that will be skipped) to start GO)
p2p-dev-wlan0: Setting scan request: 0.000000 sec
p2p-dev-wlan0: State: DISCONNECTED -> SCANNING
Start a pre-selected network without scan step
Setting up AP (SSID=3D'DIRECT-el')
nl80211: Setup AP operations for P2P group (GO)
nl80211: Set mode ifindex 0 iftype 9 (P2P_GO)
nl80211: Failed to set interface 0 to mode 9: -22 (Invalid argument)
nl80211: Try mode change after setting interface down
nl80211: Stop P2P Device p2p-dev-wlan0 (0x13): Success
nl80211: Set mode ifindex 0 iftype 9 (P2P_GO)
nl80211: Failed to set interface 0 to mode 9: -22 (Invalid argument)
nl80211: Start P2P Device p2p-dev-wlan0 (0x13): Success
nl80211: Interface mode change to 9 from 10 failed
nl80211: Remove monitor interface: refcount=3D0
p2p-dev-wlan0: Failed to start AP functionality
p2p-dev-wlan0: State: SCANNING -> DISCONNECTED
nl80211: Set p2p-dev-wlan0 operstate 0->0 (DORMANT)
netlink: Operstate: ifindex=3D0 linkmode=3D-1 (no change), operstate=3D5
(IF_OPER_DORMANT)
nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
for p2p-dev-wlan0
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2437 channel_type=3D0
duration=3D0 cookie=3D0x220 (match))
p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms
pending_action_tx=3D(nil))
p2p-dev-wlan0: Radio work 'p2p-listen'@0x2684390 done in 0.058077 seconds
P2P: Driver ended Listen state (freq=3D2437)
P2P: Skip stop_listen since not in listen_only state.
P2P: Group Formation timed out
P2P: Group Formation failed with 12:68:3f:4e:b9:f2
P2P: Clear timeout (state=3DPROVISIONING)
P2P: State PROVISIONING -> IDLE
P2P-GROUP-FORMATION-FAILURE
CTRL_IFACE monitor sent successfully to /tmp/wpa_ctrl_13689-2\x00
CTRL_IFACE monitor sent successfully to /tmp/wpa_ctrl_330-101164\x00
P2P-GROUP-REMOVED p2p-dev-wlan0 GO reason=3DFORMATION_FAILED
CTRL_IFACE monitor sent successfully to /tmp/wpa_ctrl_13689-2\x00
CTRL_IFACE monitor sent successfully to /tmp/wpa_ctrl_330-101164\x00
P2P: Remove temporary group network
p2p-dev-wlan0: State: DISCONNECTED -> DISCONNECTED
nl80211: Set p2p-dev-wlan0 operstate 0->0 (DORMANT)
netlink: Operstate: ifindex=3D0 linkmode=3D-1 (no change), operstate=3D5
(IF_OPER_DORMANT)
p2p-dev-wlan0: Removing interface p2p-dev-wlan0
p2p-dev-wlan0: Request to deauthenticate - bssid=3D00:00:00:00:00:00
pending_bssid=3D00:00:00:00:00:00 reason=3D3 state=3DDISCONNECTED
p2p-dev-wlan0: State: DISCONNECTED -> DISCONNECTED
nl80211: Set p2p-dev-wlan0 operstate 0->0 (DORMANT)
netlink: Operstate: ifindex=3D0 linkmode=3D-1 (no change), operstate=3D5
(IF_OPER_DORMANT)
EAPOL: External notification - portEnabled=3D0
EAPOL: External notification - portValid=3D0
p2p-dev-wlan0: BSS: Remove id 0 BSSID 00:18:39:0a:8e:23 SSID
'blockfloete' due to wpa_bss_flush
p2p-dev-wlan0: BSS: Remove id 1 BSSID 20:2b:c1:4b:8f:a4 SSID
'WLAN-8FA406' due to wpa_bss_flush
p2p-dev-wlan0: BSS: Remove id 2 BSSID 10:fe:ed:56:76:9c SSID 'wlan-n'
due to wpa_bss_flush
p2p-dev-wlan0: Cancelling delayed sched scan
p2p-dev-wlan0: Cancelling scan request
p2p-dev-wlan0: Cancelling authentication timeout
nl80211: Disable Probe Request reporting nl_preq=3D0x888888888ae00c89
p2p-dev-wlan0: P2P: Disable P2P since removing the management
interface is being removed
P2P: Stopping find
P2P: Clear timeout (state=3DIDLE)
P2P: State IDLE -> IDLE
P2P: Clear timeout (state=3DIDLE)
P2P-DEVICE-LOST p2p_dev_addr=3D12:68:3f:4e:39:f2
Remove interface p2p-dev-wlan0 from radio phy0
nl80211: Remove monitor interface: refcount=3D0
netlink: Operstate: ifindex=3D0 linkmode=3D0 (kernel-control), operstate=3D=
6
(IF_OPER_UP)
nl80211: Stop P2P Device p2p-dev-wlan0 (0x13): Success
nl80211: Unsubscribe mgmt frames handle 0x888888888ae0ab79 (deinit)
nl80211: Delete P2P Device p2p-dev-wlan0 (0x13): Success
p2p-dev-wlan0: CTRL-EVENT-TERMINATING
wlan0: Removing interface wlan0
wlan0: Request to deauthenticate - bssid=3D00:00:00:00:00:00
pending_bssid=3D00:00:00:00:00:00 reason=3D3 state=3DDISCONNECTED
wlan0: State: DISCONNECTED -> DISCONNECTED
nl80211: Set wlan0 operstate 0->0 (DORMANT)
netlink: Operstate: ifindex=3D3 linkmode=3D-1 (no change), operstate=3D5
(IF_OPER_DORMANT)
EAPOL: External notification - portEnabled=3D0
EAPOL: External notification - portValid=3D0
wlan0: Cancelling delayed sched scan
wlan0: Cancelling scan request
wlan0: Cancelling authentication timeout
P2P: Removing pending group interface p2p-wlan0-0
nl80211: wpa_driver_nl80211_if_remove(type=3D5 ifname=3Dp2p-wlan0-0)
ifindex=3D14 added_if=3D0
nl80211: Remove interface ifindex=3D14
Remove interface wlan0 from radio phy0
Remove radio phy0
nl80211: Remove monitor interface: refcount=3D0
netlink: Operstate: ifindex=3D3 linkmode=3D0 (kernel-control), operstate=3D=
6
(IF_OPER_UP)
nl80211: Set mode ifindex 3 iftype 2 (STATION)
nl80211: Unsubscribe mgmt frames handle 0x888888888aeed379 (mode change)
wlan0: CTRL-EVENT-TERMINATING
CTRL_IFACE monitor sent successfully to /tmp/wpa_ctrl_13689-2\x00
CTRL_IFACE monitor sent successfully to /tmp/wpa_ctrl_330-101164\x00
CTRL_IFACE wait for attached monitors to receive messages
Control interface directory not empty - leaving it behind

--089e0111e270f0617d04efe044d8
Content-Type: text/x-log; charset=US-ASCII; name="wpa.log"
Content-Disposition: attachment; filename="wpa.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqe7dxyv0

d3BhX3N1cHBsaWNhbnQgdjIuMS1kZXZlbApTdWNjZXNzZnVsbHkgaW5pdGlhbGl6ZWQgd3BhX3N1
cHBsaWNhbnQKSW5pdGlhbGl6aW5nIGludGVyZmFjZSAnd2xhbjAnIGNvbmYgJy4uL3dwYS5jb25m
JyBkcml2ZXIgJ25sODAyMTEnIGN0cmxfaW50ZXJmYWNlICdOL0EnIGJyaWRnZSAnTi9BJwpDb25m
aWd1cmF0aW9uIGZpbGUgJy4uL3dwYS5jb25mJyAtPiAnL2hvbWUvZGF2aWQvZGV2L29wZW53ZmQv
Li4vd3BhLmNvbmYnClJlYWRpbmcgY29uZmlndXJhdGlvbiBmaWxlICcvaG9tZS9kYXZpZC9kZXYv
b3BlbndmZC8uLi93cGEuY29uZicKY3RybF9pbnRlcmZhY2U9Jy92YXIvcnVuL3dwYV9zdXBwbGlj
YW50JwphcF9zY2FuPTEKcDJwX2dvX2h0NDA9MQpkZXZpY2VfbmFtZT0nZGF2aWQtdWInCm5sODAy
MTE6IENvdWxkIG5vdCBhZGQgbXVsdGljYXN0IG1lbWJlcnNoaXAgZm9yIHZlbmRvciBldmVudHM6
IC0yIChObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5KQpyZmtpbGw6IGluaXRpYWwgZXZlbnQ6IGlk
eD0yIHR5cGU9MSBvcD0wIHNvZnQ9MCBoYXJkPTAKcmZraWxsOiBpbml0aWFsIGV2ZW50OiBpZHg9
MyB0eXBlPTEgb3A9MCBzb2Z0PTAgaGFyZD0wCnJma2lsbDogaW5pdGlhbCBldmVudDogaWR4PTQg
dHlwZT0yIG9wPTAgc29mdD0wIGhhcmQ9MApyZmtpbGw6IGluaXRpYWwgZXZlbnQ6IGlkeD01IHR5
cGU9MiBvcD0wIHNvZnQ9MCBoYXJkPTAKbmw4MDIxMTogU3VwcG9ydGVkIGNpcGhlciAwMC0wZi1h
YzoxCm5sODAyMTE6IFN1cHBvcnRlZCBjaXBoZXIgMDAtMGYtYWM6NQpubDgwMjExOiBTdXBwb3J0
ZWQgY2lwaGVyIDAwLTBmLWFjOjIKbmw4MDIxMTogU3VwcG9ydGVkIGNpcGhlciAwMC0wZi1hYzo0
Cm5sODAyMTE6IFN1cHBvcnRlZCBjaXBoZXIgMDAtMGYtYWM6NgpubDgwMjExOiBVc2luZyBkcml2
ZXItYmFzZWQgb2ZmLWNoYW5uZWwgVFgKbmw4MDIxMTogVXNlIHNlcGFyYXRlIFAyUCBncm91cCBp
bnRlcmZhY2UgKGRyaXZlciBhZHZlcnRpc2VkIHN1cHBvcnQpCm5sODAyMTE6IGludGVyZmFjZSB3
bGFuMCBpbiBwaHkgcGh5MApubDgwMjExOiBTZXQgbW9kZSBpZmluZGV4IDMgaWZ0eXBlIDIgKFNU
QVRJT04pCm5sODAyMTE6IFN1YnNjcmliZSB0byBtZ210IGZyYW1lcyB3aXRoIG5vbi1BUCBoYW5k
bGUgMHgyNjY1YmYwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHhkMCBubF9oYW5kbGU9
MHgyNjY1YmYwIG1hdGNoPTA0MGEKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUgdHlwZT0weGQwIG5s
X2hhbmRsZT0weDI2NjViZjAgbWF0Y2g9MDQwYgpubDgwMjExOiBSZWdpc3RlciBmcmFtZSB0eXBl
PTB4ZDAgbmxfaGFuZGxlPTB4MjY2NWJmMCBtYXRjaD0wNDBjCm5sODAyMTE6IFJlZ2lzdGVyIGZy
YW1lIHR5cGU9MHhkMCBubF9oYW5kbGU9MHgyNjY1YmYwIG1hdGNoPTA0MGQKbmw4MDIxMTogUmVn
aXN0ZXIgZnJhbWUgdHlwZT0weGQwIG5sX2hhbmRsZT0weDI2NjViZjAgbWF0Y2g9MDQwOTUwNmY5
YTA5Cm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHhkMCBubF9oYW5kbGU9MHgyNjY1YmYw
IG1hdGNoPTdmNTA2ZjlhMDkKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUgdHlwZT0weGQwIG5sX2hh
bmRsZT0weDI2NjViZjAgbWF0Y2g9MDYKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUgdHlwZT0weGQw
IG5sX2hhbmRsZT0weDI2NjViZjAgbWF0Y2g9MGEwNwpubDgwMjExOiBSZWdpc3RlciBmcmFtZSB0
eXBlPTB4ZDAgbmxfaGFuZGxlPTB4MjY2NWJmMCBtYXRjaD0wYTExCm5ldGxpbms6IE9wZXJzdGF0
ZTogaWZpbmRleD0zIGxpbmttb2RlPTEgKHVzZXJzcGFjZS1jb250cm9sKSwgb3BlcnN0YXRlPTUg
KElGX09QRVJfRE9STUFOVCkKbmw4MDIxMTogZHJpdmVyIHBhcmFtPSdwMnBfZGV2aWNlPTEnCkFk
ZCBpbnRlcmZhY2Ugd2xhbjAgdG8gYSBuZXcgcmFkaW8gcGh5MApubDgwMjExOiBSZWd1bGF0b3J5
IGluZm9ybWF0aW9uIC0gY291bnRyeT0wMApubDgwMjExOiAyNDAyLTI0NzIgQCA0MCBNSHogMjAg
bUJtCm5sODAyMTE6IDI0NTctMjQ4MiBAIDQwIE1IeiAyMCBtQm0Kbmw4MDIxMTogMjQ3NC0yNDk0
IEAgMjAgTUh6IDIwIG1CbQpubDgwMjExOiA1MTcwLTUyNTAgQCAxNjAgTUh6IDIwIG1CbQpubDgw
MjExOiA1MjUwLTUzMzAgQCAxNjAgTUh6IDIwIG1CbQpubDgwMjExOiA1NDkwLTU3MzAgQCAxNjAg
TUh6IDIwIG1CbQpubDgwMjExOiBBZGRlZCA4MDIuMTFiIG1vZGUgYmFzZWQgb24gODAyLjExZyBp
bmZvcm1hdGlvbgp3bGFuMDogT3duIE1BQyBhZGRyZXNzOiBmYzpmODphZTo2OTo4YTo2MQp3cGFf
ZHJpdmVyX25sODAyMTFfc2V0X2tleTogaWZpbmRleD0zICh3bGFuMCkgYWxnPTAgYWRkcj0obmls
KSBrZXlfaWR4PTAgc2V0X3R4PTAgc2VxX2xlbj0wIGtleV9sZW49MAp3cGFfZHJpdmVyX25sODAy
MTFfc2V0X2tleTogaWZpbmRleD0zICh3bGFuMCkgYWxnPTAgYWRkcj0obmlsKSBrZXlfaWR4PTEg
c2V0X3R4PTAgc2VxX2xlbj0wIGtleV9sZW49MAp3cGFfZHJpdmVyX25sODAyMTFfc2V0X2tleTog
aWZpbmRleD0zICh3bGFuMCkgYWxnPTAgYWRkcj0obmlsKSBrZXlfaWR4PTIgc2V0X3R4PTAgc2Vx
X2xlbj0wIGtleV9sZW49MAp3cGFfZHJpdmVyX25sODAyMTFfc2V0X2tleTogaWZpbmRleD0zICh3
bGFuMCkgYWxnPTAgYWRkcj0obmlsKSBrZXlfaWR4PTMgc2V0X3R4PTAgc2VxX2xlbj0wIGtleV9s
ZW49MAp3bGFuMDogUlNOOiBmbHVzaGluZyBQTUtJRCBsaXN0IGluIHRoZSBkcml2ZXIKbmw4MDIx
MTogRmx1c2ggUE1LSURzCndsYW4wOiBTdGF0ZTogRElTQ09OTkVDVEVEIC0+IElOQUNUSVZFCnds
YW4wOiBXUFM6IFVVSUQgYmFzZWQgb24gTUFDIGFkZHJlc3M6IDRhN2NmOGMyLTNjM2ItNTIzOC1i
MTZmLTcyNzNmNGJiNGZkYQpFQVBPTDogU1VQUF9QQUUgZW50ZXJpbmcgc3RhdGUgRElTQ09OTkVD
VEVECkVBUE9MOiBTdXBwbGljYW50IHBvcnQgc3RhdHVzOiBVbmF1dGhvcml6ZWQKbmw4MDIxMTog
U2tpcCBzZXRfc3VwcF9wb3J0KHVuYXV0aG9yaXplZCkgd2hpbGUgbm90IGFzc29jaWF0ZWQKRUFQ
T0w6IEtFWV9SWCBlbnRlcmluZyBzdGF0ZSBOT19LRVlfUkVDRUlWRQpFQVBPTDogU1VQUF9CRSBl
bnRlcmluZyBzdGF0ZSBJTklUSUFMSVpFCkVBUDogRUFQIGVudGVyaW5nIHN0YXRlIERJU0FCTEVE
ClVzaW5nIGV4aXN0aW5nIGNvbnRyb2wgaW50ZXJmYWNlIGRpcmVjdG9yeS4Kd2xhbjA6IEFkZGVk
IGludGVyZmFjZSB3bGFuMAp3bGFuMDogU3RhdGU6IElOQUNUSVZFIC0+IERJU0NPTk5FQ1RFRApu
bDgwMjExOiBTZXQgd2xhbjAgb3BlcnN0YXRlIDAtPjAgKERPUk1BTlQpCm5ldGxpbms6IE9wZXJz
dGF0ZTogaWZpbmRleD0zIGxpbmttb2RlPS0xIChubyBjaGFuZ2UpLCBvcGVyc3RhdGU9NSAoSUZf
T1BFUl9ET1JNQU5UKQpubDgwMjExOiBDcmVhdGUgaW50ZXJmYWNlIGlmdHlwZSAxMCAoUDJQX0RF
VklDRSkKbmw4MDIxMTogTmV3IFAyUCBEZXZpY2UgaW50ZXJmYWNlIHAycC1kZXYtd2xhbjAgKDB4
MTMpIGNyZWF0ZWQKSW5pdGlhbGl6aW5nIGludGVyZmFjZSAncDJwLWRldi13bGFuMCcgY29uZiAn
L2hvbWUvZGF2aWQvZGV2L29wZW53ZmQvLi4vd3BhLmNvbmYnIGRyaXZlciAnbmw4MDIxMScgY3Ry
bF9pbnRlcmZhY2UgJ04vQScgYnJpZGdlICdOL0EnCkNvbmZpZ3VyYXRpb24gZmlsZSAnL2hvbWUv
ZGF2aWQvZGV2L29wZW53ZmQvLi4vd3BhLmNvbmYnIC0+ICcvaG9tZS9kYXZpZC9kZXYvb3Blbndm
ZC8uLi93cGEuY29uZicKUmVhZGluZyBjb25maWd1cmF0aW9uIGZpbGUgJy9ob21lL2RhdmlkL2Rl
di9vcGVud2ZkLy4uL3dwYS5jb25mJwpjdHJsX2ludGVyZmFjZT0nL3Zhci9ydW4vd3BhX3N1cHBs
aWNhbnQnCmFwX3NjYW49MQpwMnBfZ29faHQ0MD0xCmRldmljZV9uYW1lPSdkYXZpZC11YicKcmZr
aWxsOiBpbml0aWFsIGV2ZW50OiBpZHg9MiB0eXBlPTEgb3A9MCBzb2Z0PTAgaGFyZD0wCnJma2ls
bDogaW5pdGlhbCBldmVudDogaWR4PTMgdHlwZT0xIG9wPTAgc29mdD0wIGhhcmQ9MApyZmtpbGw6
IGluaXRpYWwgZXZlbnQ6IGlkeD00IHR5cGU9MiBvcD0wIHNvZnQ9MCBoYXJkPTAKcmZraWxsOiBp
bml0aWFsIGV2ZW50OiBpZHg9NSB0eXBlPTIgb3A9MCBzb2Z0PTAgaGFyZD0wCkNvdWxkIG5vdCBy
ZWFkIGludGVyZmFjZSBwMnAtZGV2LXdsYW4wIGZsYWdzOiBObyBzdWNoIGRldmljZQpubDgwMjEx
OiBTdXBwb3J0ZWQgY2lwaGVyIDAwLTBmLWFjOjEKbmw4MDIxMTogU3VwcG9ydGVkIGNpcGhlciAw
MC0wZi1hYzo1Cm5sODAyMTE6IFN1cHBvcnRlZCBjaXBoZXIgMDAtMGYtYWM6MgpubDgwMjExOiBT
dXBwb3J0ZWQgY2lwaGVyIDAwLTBmLWFjOjQKbmw4MDIxMTogU3VwcG9ydGVkIGNpcGhlciAwMC0w
Zi1hYzo2Cm5sODAyMTE6IFVzaW5nIGRyaXZlci1iYXNlZCBvZmYtY2hhbm5lbCBUWApubDgwMjEx
OiBVc2Ugc2VwYXJhdGUgUDJQIGdyb3VwIGludGVyZmFjZSAoZHJpdmVyIGFkdmVydGlzZWQgc3Vw
cG9ydCkKbmw4MDIxMTogaW50ZXJmYWNlIHAycC1kZXYtd2xhbjAgaW4gcGh5IHBoeTAKbmw4MDIx
MTogU2V0IG1vZGUgaWZpbmRleCAwIGlmdHlwZSAxMCAoUDJQX0RFVklDRSkKbmw4MDIxMTogRmFp
bGVkIHRvIHNldCBpbnRlcmZhY2UgMCB0byBtb2RlIDEwOiAtMjIgKEludmFsaWQgYXJndW1lbnQp
Cm5sODAyMTE6IFN1YnNjcmliZSB0byBtZ210IGZyYW1lcyB3aXRoIG5vbi1BUCBoYW5kbGUgMHgy
NjgyM2YwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHhkMCBubF9oYW5kbGU9MHgyNjgy
M2YwIG1hdGNoPTA0MGEKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUgdHlwZT0weGQwIG5sX2hhbmRs
ZT0weDI2ODIzZjAgbWF0Y2g9MDQwYgpubDgwMjExOiBSZWdpc3RlciBmcmFtZSB0eXBlPTB4ZDAg
bmxfaGFuZGxlPTB4MjY4MjNmMCBtYXRjaD0wNDBjCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5
cGU9MHhkMCBubF9oYW5kbGU9MHgyNjgyM2YwIG1hdGNoPTA0MGQKbmw4MDIxMTogUmVnaXN0ZXIg
ZnJhbWUgdHlwZT0weGQwIG5sX2hhbmRsZT0weDI2ODIzZjAgbWF0Y2g9MDQwOTUwNmY5YTA5Cm5s
ODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHhkMCBubF9oYW5kbGU9MHgyNjgyM2YwIG1hdGNo
PTdmNTA2ZjlhMDkKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUgdHlwZT0weGQwIG5sX2hhbmRsZT0w
eDI2ODIzZjAgbWF0Y2g9MDYKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUgdHlwZT0weGQwIG5sX2hh
bmRsZT0weDI2ODIzZjAgbWF0Y2g9MGEwNwpubDgwMjExOiBSZWdpc3RlciBmcmFtZSB0eXBlPTB4
ZDAgbmxfaGFuZGxlPTB4MjY4MjNmMCBtYXRjaD0wYTExCm5sODAyMTE6IFN0YXJ0IFAyUCBEZXZp
Y2UgcDJwLWRldi13bGFuMCAoMHgxMyk6IFN1Y2Nlc3MKbmw4MDIxMTogZHJpdmVyIHBhcmFtPSdw
MnBfZGV2aWNlPTEnCkFkZCBpbnRlcmZhY2UgcDJwLWRldi13bGFuMCB0byBleGlzdGluZyByYWRp
byBwaHkwCm5sODAyMTE6IFJlZ3VsYXRvcnkgaW5mb3JtYXRpb24gLSBjb3VudHJ5PTAwCm5sODAy
MTE6IDI0MDItMjQ3MiBAIDQwIE1IeiAyMCBtQm0Kbmw4MDIxMTogMjQ1Ny0yNDgyIEAgNDAgTUh6
IDIwIG1CbQpubDgwMjExOiAyNDc0LTI0OTQgQCAyMCBNSHogMjAgbUJtCm5sODAyMTE6IDUxNzAt
NTI1MCBAIDE2MCBNSHogMjAgbUJtCm5sODAyMTE6IDUyNTAtNTMzMCBAIDE2MCBNSHogMjAgbUJt
Cm5sODAyMTE6IDU0OTAtNTczMCBAIDE2MCBNSHogMjAgbUJtCnAycC1kZXYtd2xhbjA6IE93biBN
QUMgYWRkcmVzczogZmM6Zjg6YWU6Njk6OGE6NjIKcDJwLWRldi13bGFuMDogUlNOOiBmbHVzaGlu
ZyBQTUtJRCBsaXN0IGluIHRoZSBkcml2ZXIKbmw4MDIxMTogRmx1c2ggUE1LSURzCnAycC1kZXYt
d2xhbjA6IFN0YXRlOiBESVNDT05ORUNURUQgLT4gSU5BQ1RJVkUKcDJwLWRldi13bGFuMDogV1BT
OiBVVUlEIGZyb20gdGhlIGZpcnN0IGludGVyZmFjZTogNGE3Y2Y4YzItM2MzYi01MjM4LWIxNmYt
NzI3M2Y0YmI0ZmRhCkVBUE9MOiBTVVBQX1BBRSBlbnRlcmluZyBzdGF0ZSBESVNDT05ORUNURUQK
RUFQT0w6IFN1cHBsaWNhbnQgcG9ydCBzdGF0dXM6IFVuYXV0aG9yaXplZApubDgwMjExOiBTa2lw
IHNldF9zdXBwX3BvcnQodW5hdXRob3JpemVkKSB3aGlsZSBub3QgYXNzb2NpYXRlZApFQVBPTDog
S0VZX1JYIGVudGVyaW5nIHN0YXRlIE5PX0tFWV9SRUNFSVZFCkVBUE9MOiBTVVBQX0JFIGVudGVy
aW5nIHN0YXRlIElOSVRJQUxJWkUKRUFQOiBFQVAgZW50ZXJpbmcgc3RhdGUgRElTQUJMRUQKUDJQ
OiBPd24gbGlzdGVuIGNoYW5uZWw6IDYKUDJQOiBSYW5kb20gb3BlcmF0aW5nIGNoYW5uZWw6IDgx
OjYKUDJQOiBEcml2ZXIgZGlkIG5vdCBzdXBwb3J0IGZldGNoaW5nIG9mIGFsbCBzdXBwb3J0ZWQg
Y2hhbm5lbHM7IGFzc3VtZSBkdWFsYmFuZCBzdXBwb3J0ClAyUDogRW5hYmxlIG9wZXJhdGluZyBj
bGFzc2VzIGZvciAyLjQgR0h6IGJhbmQKUDJQOiBFbmFibGUgb3BlcmF0aW5nIGNsYXNzZXMgZm9y
IGxvd2VyIDUgR0h6IGJhbmQKUDJQOiBFbmFibGUgb3BlcmF0aW5nIGNsYXNzZXMgZm9yIGhpZ2hl
ciA1IEdIeiBiYW5kClAyUDogaW5pdGlhbGl6ZWQKUDJQOiBjaGFubmVsczogODE6MSwyLDMsNCw1
LDYsNyw4LDksMTAsMTEgMTE1OjM2LDQwLDQ0LDQ4IDEyNDoxNDksMTUzLDE1NywxNjEKUDJQOiBj
bGlfY2hhbm5lbHM6CnAycC1kZXYtd2xhbjA6IEFkZGVkIGludGVyZmFjZSBwMnAtZGV2LXdsYW4w
CnAycC1kZXYtd2xhbjA6IFN0YXRlOiBJTkFDVElWRSAtPiBESVNDT05ORUNURUQKbmw4MDIxMTog
U2V0IHAycC1kZXYtd2xhbjAgb3BlcnN0YXRlIDAtPjAgKERPUk1BTlQpCm5ldGxpbms6IE9wZXJz
dGF0ZTogaWZpbmRleD0wIGxpbmttb2RlPS0xIChubyBjaGFuZ2UpLCBvcGVyc3RhdGU9NSAoSUZf
T1BFUl9ET1JNQU5UKQpFQVBPTDogZGlzYWJsZSB0aW1lciB0aWNrCkVBUE9MOiBkaXNhYmxlIHRp
bWVyIHRpY2sKQ1RSTF9JRkFDRSBtb25pdG9yIGF0dGFjaGVkIC90bXAvd3BhX2N0cmxfMzMwLTEw
MTE2NFx4MDAKQ1RSTF9JRkFDRSBtb25pdG9yIGF0dGFjaGVkIC90bXAvd3BhX2N0cmxfMTM2ODkt
Mlx4MDAKd2xhbjA6IENvbnRyb2wgaW50ZXJmYWNlIGNvbW1hbmQgJ0JTUyBSQU5HRT1BTEwgTUFT
Sz0weDInCndsYW4wOiBDb250cm9sIGludGVyZmFjZSBjb21tYW5kICdQMlBfU0VUIGRpc2FsbG93
X2ZyZXEgNTE4MC01ODAwJwpQMlA6IERpc2FsbG93ZWQgZnJlcXVlbmN5IHJhbmdlIDUxODAtNTgw
MApQMlA6IEFkZCBvcGVyYXRpbmcgY2xhc3MgODEKUDJQOiBDaGFubmVscyAtIGhleGR1bXAobGVu
PTExKTogMDEgMDIgMDMgMDQgMDUgMDYgMDcgMDggMDkgMGEgMGIKUDJQOiBVcGRhdGUgY2hhbm5l
bCBsaXN0ClAyUDogY2hhbm5lbHM6IDgxOjEsMiwzLDQsNSw2LDcsOCw5LDEwLDExClAyUDogY2xp
X2NoYW5uZWxzOgp3bGFuMDogQ29udHJvbCBpbnRlcmZhY2UgY29tbWFuZCAnUDJQX0ZJTkQnClAy
UDogU3RhcnRpbmcgZmluZCAodHlwZT0wKQpQMlA6IENsZWFyIHRpbWVvdXQgKHN0YXRlPUlETEUp
ClAyUDogU3RhdGUgSURMRSAtPiBTRUFSQ0gKV1BTOiBCdWlsZGluZyBXUFMgSUUgZm9yIFByb2Jl
IFJlcXVlc3QKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBSZXF1ZXN0
IFR5cGUKV1BTOiAgKiBDb25maWcgTWV0aG9kcyAoMTQ4KQpXUFM6ICAqIFVVSUQtRQpXUFM6ICAq
IFByaW1hcnkgRGV2aWNlIFR5cGUKV1BTOiAgKiBSRiBCYW5kcyAoMykKV1BTOiAgKiBBc3NvY2lh
dGlvbiBTdGF0ZQpXUFM6ICAqIENvbmZpZ3VyYXRpb24gRXJyb3IgKDApCldQUzogICogRGV2aWNl
IFBhc3N3b3JkIElEICgwKQpXUFM6ICAqIERldmljZSBOYW1lClAyUDogKiBQMlAgSUUgaGVhZGVy
ClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogTGlzdGVuIENoYW5uZWw6
IFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCA2CnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3
b3JrICdwMnAtc2NhbidAMHgyNjg4ZTEwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsg
aXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpQMlA6IFJ1bm5p
bmcgcDJwX3NjYW4KcDJwLWRldi13bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAncDJwLXNjYW4n
QDB4MjY4OGUxMCBhZnRlciAwLjAwMDAyNyBzZWNvbmQgd2FpdApwMnAtZGV2LXdsYW4wOiBubDgw
MjExOiBzY2FuIHJlcXVlc3QKbmw4MDIxMTogUDJQIHByb2JlIC0gbWFzayBTdXBwUmF0ZXMKU2Nh
biByZXF1ZXN0ZWQgKHJldD0wKSAtIHNjYW4gdGltZW91dCAxMCBzZWNvbmRzCm5sODAyMTE6IERy
diBFdmVudCAzMyAoTkw4MDIxMV9DTURfVFJJR0dFUl9TQ0FOKSByZWNlaXZlZCBmb3IgcDJwLWRl
di13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBTY2FuIHRyaWdnZXIKcDJwLWRldi13bGFu
MDogRXZlbnQgU0NBTl9TVEFSVEVEICg0OSkgcmVjZWl2ZWQKcDJwLWRldi13bGFuMDogT3duIHNj
YW4gcmVxdWVzdCBzdGFydGVkIGEgc2NhbiBpbiAwLjAwMDA1NCBzZWNvbmRzCnAycC1kZXYtd2xh
bjA6IENUUkwtRVZFTlQtU0NBTi1TVEFSVEVEIApubDgwMjExOiBEcnYgRXZlbnQgMzQgKE5MODAy
MTFfQ01EX05FV19TQ0FOX1JFU1VMVFMpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1k
ZXYtd2xhbjA6IG5sODAyMTE6IE5ldyBzY2FuIHJlc3VsdHMgYXZhaWxhYmxlCm5sODAyMTE6IFNj
YW4gcHJvYmVkIGZvciBTU0lEICdESVJFQ1QtJwpubDgwMjExOiBTY2FuIGluY2x1ZGVkIGZyZXF1
ZW5jaWVzOiAyNDEyIDI0MTcgMjQyMiAyNDI3IDI0MzIgMjQzNyAyNDQyIDI0NDcgMjQ1MiAyNDU3
IDI0NjIgMjQ2NyAyNDcyIDUxODAgNTIwMCA1MjIwIDUyNDAgNTI2MCA1MjgwIDUzMDAgNTMyMCA1
NTAwIDU1MjAgNTU0MCA1NTYwIDU1ODAgNTYwMCA1NjIwIDU2NDAgNTY2MCA1NjgwIDU3MDAgNTcy
MCA1NzQ1IDU3NjUgNTc4NSA1ODA1IDU4MjUKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9SRVNV
TFRTICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAzLjYyMTEw
OSBzZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoMiBCU1NlcykKcDJwLWRl
di13bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgMQpwMnAtZGV2LXdsYW4wOiBC
U1M6IEFkZCBuZXcgaWQgMCBCU1NJRCAwMDoxODozOTowYTo4ZToyMyBTU0lEICdibG9ja2Zsb2V0
ZScKcDJwLWRldi13bGFuMDogQlNTOiBBZGQgbmV3IGlkIDEgQlNTSUQgMjA6MmI6YzE6NGI6OGY6
YTQgU1NJRCAnV0xBTi04RkE0MDYnCkJTUzogbGFzdF9zY2FuX3Jlc191c2VkPTIvMzIKcDJwLWRl
di13bGFuMDogUmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4OGUxMCBkb25lIGluIDMuNjI0MjQz
IHNlY29uZHMKUDJQOiBTY2FuIHJlc3VsdHMgcmVjZWl2ZWQgKDIgQlNTKQpQMlA6IElnbm9yZSBz
Y2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBh
cnNpbmcgV1BTIElFClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5m
byBvciBQMlAgRGV2aWNlIElkClAyUDogU3RhdGUgU0VBUkNIIC0+IFNFQVJDSApQMlA6IFN0YXJ0
aW5nIHNob3J0IGxpc3RlbiBzdGF0ZSAoc3RhdGU9U0VBUkNIKQpXUFM6ICAqIFZlcnNpb24gKGhh
cmRjb2RlZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICog
Q2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCnAycC1kZXYtd2xh
bjA6IEFkZCByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODhkNzAKcDJwLWRldi13bGFuMDog
Rmlyc3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVk
aWF0ZWx5CnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4
MjY4OGQ3MCBhZnRlciAwLjAwMDAxMyBzZWNvbmQgd2FpdApubDgwMjExOiBFbmFibGUgUHJvYmUg
UmVxdWVzdCByZXBvcnRpbmcgbmxfcHJlcT0weDI2ODg0YjAKbmw4MDIxMTogUmVnaXN0ZXIgZnJh
bWUgdHlwZT0weDQwIG5sX2hhbmRsZT0weDI2ODg0YjAgbWF0Y2g9Cm5sODAyMTE6IFJlbWFpbi1v
bi1jaGFubmVsIGNvb2tpZSAweDFmNyBmb3IgZnJlcT0yNDM3IE1IeiBkdXJhdGlvbj0zMDcKbmw4
MDIxMTogRHJ2IEV2ZW50IDU1IChOTDgwMjExX0NNRF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2
ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNh
bmNlbD0wIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0zMDcgY29va2llPTB4MWY3
IChtYXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50IFJFTUFJTl9PTl9DSEFOTkVMICgyMSkgcmVj
ZWl2ZWQKT2ZmLWNoYW5uZWw6IFNlbmQgQWN0aW9uIGNhbGxiYWNrICh3aXRob3V0X3JvYz0wIHBl
bmRpbmdfYWN0aW9uX3R4PShuaWwpKQpQMlA6IFN0YXJ0aW5nIExpc3RlbiB0aW1lb3V0KDAsMzA3
MjAwKSBvbiBmcmVxPTI0MzcgYmFzZWQgb24gY2FsbGJhY2sKUDJQOiBTZXQgdGltZW91dCAoc3Rh
dGU9U0VBUkNIKTogMC4zMjcyMDAgc2VjCm5sODAyMTE6IEJTUyBFdmVudCA1OSAoTkw4MDIxMV9D
TURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJYIGZyYW1lIGZy
ZXE9MjQzNyBzc2lfc2lnbmFsPS0yNiBzdHlwZT00IGxlbj0yMTcKcDJwLWRldi13bGFuMDogRXZl
bnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcg
TWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJp
bWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElF
ClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdy
b3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVu
IENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51
bWJlciA2ClAyUDogQ3JlYXRlZCBkZXZpY2UgZW50cnkgYmFzZWQgb24gUHJvYmUgUmVxOiAxMjo2
ODozZjo0ZTozOTpmMiBkZXZfY2FwYWI9MHgyNSBncm91cF9jYXBhYj0weDAgbmFtZT0nZHZkaHJt
LW54JyBsaXN0ZW5fZnJlcT0yNDM3ClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0
aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFy
eSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAy
UDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3Vw
IENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENo
YW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJl
ciA2ClAyUDogUmVwbHkgdG8gUDJQIFByb2JlIFJlcXVlc3QgaW4gTGlzdGVuIHN0YXRlCldQUzog
ICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAgSUUg
aGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNlIElu
Zm8Kbmw4MDIxMTogc2VuZF9tbG1lIC0gbm9hY2s9MSBmcmVxPTAgbm9fY2NrPTAgb2ZmY2hhbm9r
PTAgd2FpdF90aW1lPTAgZmM9MHg1MCBubG1vZGU9MTAKbmw4MDIxMTogVXNlIGxhc3RfbWdtdF9m
cmVxPTI0MzcKbmw4MDIxMTogQlNTIEV2ZW50IDU5IChOTDgwMjExX0NNRF9GUkFNRSkgcmVjZWl2
ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUlggZnJhbWUgZnJlcT0yNDM3IHNzaV9zaWdu
YWw9LTI2IHN0eXBlPTQgbGVuPTIxNwpwMnAtZGV2LXdsYW4wOiBFdmVudCBSWF9NR01UICgyMCkg
cmVjZWl2ZWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAw
eDQzODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBl
IChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUg
MiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAw
MApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRy
eSBERSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBQYXJz
aW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZpY2Ug
UGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIw
NC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICog
RGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2
IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1bGF0
b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBSZXBseSB0byBQMlAgUHJvYmUgUmVx
dWVzdCBpbiBMaXN0ZW4gc3RhdGUKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BT
OiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1
IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpubDgwMjExOiBzZW5kX21sbWUgLSBub2Fjaz0x
IGZyZXE9MCBub19jY2s9MCBvZmZjaGFub2s9MCB3YWl0X3RpbWU9MCBmYz0weDUwIG5sbW9kZT0x
MApubDgwMjExOiBVc2UgbGFzdF9tZ210X2ZyZXE9MjQzNwpubDgwMjExOiBCU1MgRXZlbnQgNTkg
KE5MODAyMTFfQ01EX0ZSQU1FKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBS
WCBmcmFtZSBmcmVxPTI0Mzcgc3NpX3NpZ25hbD0tMjYgc3R5cGU9NCBsZW49MjE3CnAycC1kZXYt
d2xhbjA6IEV2ZW50IFJYX01HTVQgKDIwKSByZWNlaXZlZApQMlA6IFBhcnNpbmcgV1BTIElFClAy
UDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJRDog
MApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJz
aW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJp
bGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQ
OiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEg
Q2hhbm5lbCBOdW1iZXIgNgpQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMg
KFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2
aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0
dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBh
YmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVs
OiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQ
MlA6IFJlcGx5IHRvIFAyUCBQcm9iZSBSZXF1ZXN0IGluIExpc3RlbiBzdGF0ZQpXUFM6ICAqIFZl
cnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRl
cgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCm5s
ODAyMTE6IHNlbmRfbWxtZSAtIG5vYWNrPTEgZnJlcT0wIG5vX2Njaz0wIG9mZmNoYW5vaz0wIHdh
aXRfdGltZT0wIGZjPTB4NTAgbmxtb2RlPTEwCm5sODAyMTE6IFVzZSBsYXN0X21nbXRfZnJlcT0y
NDM3Cm5sODAyMTE6IEJTUyBFdmVudCA1OSAoTkw4MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVkIGZv
ciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJYIGZyYW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFsPS0y
NiBzdHlwZT00IGxlbj0yMTcKcDJwLWRldi13bGFuMDogRXZlbnQgUlhfTUdNVCAoMjApIHJlY2Vp
dmVkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4
ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BT
KTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVu
Z3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQ
OiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUo
MHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUGFyc2luZyBX
UFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3
b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQ
MlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmlj
ZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5n
dGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBD
bGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUmVwbHkgdG8gUDJQIFByb2JlIFJlcXVlc3Qg
aW4gTGlzdGVuIHN0YXRlCldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICog
VVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91
cD0wMApQMlA6ICogRGV2aWNlIEluZm8Kbmw4MDIxMTogc2VuZF9tbG1lIC0gbm9hY2s9MSBmcmVx
PTAgbm9fY2NrPTAgb2ZmY2hhbm9rPTAgd2FpdF90aW1lPTAgZmM9MHg1MCBubG1vZGU9MTAKbmw4
MDIxMTogVXNlIGxhc3RfbWdtdF9mcmVxPTI0MzcKbmw4MDIxMTogRHJ2IEV2ZW50IDU2IChOTDgw
MjExX0NNRF9DQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXds
YW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MSBmcmVxPTI0Mzcg
Y2hhbm5lbF90eXBlPTAgZHVyYXRpb249MCBjb29raWU9MHgxZjcgKG1hdGNoKSkKcDJwLWRldi13
bGFuMDogRXZlbnQgQ0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMICgyMikgcmVjZWl2ZWQKUDJQOiBD
YW5jZWwgcmVtYWluLW9uLWNoYW5uZWwgY2FsbGJhY2sgKHAycF9sb25nX2xpc3Rlbj0wIG1zIHBl
bmRpbmdfYWN0aW9uX3R4PShuaWwpKQpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtbGlz
dGVuJ0AweDI2ODhkNzAgZG9uZSBpbiAwLjMwNzA1MiBzZWNvbmRzClAyUDogRHJpdmVyIGVuZGVk
IExpc3RlbiBzdGF0ZSAoZnJlcT0yNDM3KQpQMlA6IFNraXAgc3RvcF9saXN0ZW4gc2luY2Ugbm90
IGluIGxpc3Rlbl9vbmx5IHN0YXRlLgpQMlA6IFRpbWVvdXQgKHN0YXRlPVNFQVJDSCkKbmw4MDIx
MTogRGlzYWJsZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBubF9wcmVxPTB4ODg4ODg4ODg4YWUw
MGMzOQpQMlA6IFN0YXJ0aW5nIHNlYXJjaApXUFM6IEJ1aWxkaW5nIFdQUyBJRSBmb3IgUHJvYmUg
UmVxdWVzdApXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFJlcXVlc3Qg
VHlwZQpXUFM6ICAqIENvbmZpZyBNZXRob2RzICgxNDgpCldQUzogICogVVVJRC1FCldQUzogICog
UHJpbWFyeSBEZXZpY2UgVHlwZQpXUFM6ICAqIFJGIEJhbmRzICgzKQpXUFM6ICAqIEFzc29jaWF0
aW9uIFN0YXRlCldQUzogICogQ29uZmlndXJhdGlvbiBFcnJvciAoMCkKV1BTOiAgKiBEZXZpY2Ug
UGFzc3dvcmQgSUQgKDApCldQUzogICogRGV2aWNlIE5hbWUKUDJQOiAqIFAyUCBJRSBoZWFkZXIK
UDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDog
UmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIDYKcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdv
cmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29yayBp
dGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5ClAyUDogUnVubmlu
ZyBwMnBfc2NhbgpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtc2NhbidA
MHgyNjg4NDgwIGFmdGVyIDAuMDAwMDEwIHNlY29uZCB3YWl0CnAycC1kZXYtd2xhbjA6IG5sODAy
MTE6IHNjYW4gcmVxdWVzdApubDgwMjExOiBQMlAgcHJvYmUgLSBtYXNrIFN1cHBSYXRlcwpTY2Fu
IHJlcXVlc3RlZCAocmV0PTApIC0gc2NhbiB0aW1lb3V0IDMwIHNlY29uZHMKbmw4MDIxMTogRHJ2
IEV2ZW50IDMzIChOTDgwMjExX0NNRF9UUklHR0VSX1NDQU4pIHJlY2VpdmVkIGZvciBwMnAtZGV2
LXdsYW4wCnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IFNjYW4gdHJpZ2dlcgpwMnAtZGV2LXdsYW4w
OiBFdmVudCBTQ0FOX1NUQVJURUQgKDQ5KSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBPd24gc2Nh
biByZXF1ZXN0IHN0YXJ0ZWQgYSBzY2FuIGluIDAuMDAwMDI0IHNlY29uZHMKcDJwLWRldi13bGFu
MDogQ1RSTC1FVkVOVC1TQ0FOLVNUQVJURUQgCm5sODAyMTE6IERydiBFdmVudCAzNCAoTkw4MDIx
MV9DTURfTkVXX1NDQU5fUkVTVUxUUykgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRl
di13bGFuMDogbmw4MDIxMTogTmV3IHNjYW4gcmVzdWx0cyBhdmFpbGFibGUKbmw4MDIxMTogU2Nh
biBwcm9iZWQgZm9yIFNTSUQgJ0RJUkVDVC0nCm5sODAyMTE6IFNjYW4gaW5jbHVkZWQgZnJlcXVl
bmNpZXM6IDI0MTIgMjQzNyAyNDYyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fUkVTVUxUUyAo
MykgcmVjZWl2ZWQKcDJwLWRldi13bGFuMDogU2NhbiBjb21wbGV0ZWQgaW4gMC4xMjA1NDkgc2Vj
b25kcwpubDgwMjExOiBSZWNlaXZlZCBzY2FuIHJlc3VsdHMgKDMgQlNTZXMpCnAycC1kZXYtd2xh
bjA6IEJTUzogU3RhcnQgc2NhbiByZXN1bHQgdXBkYXRlIDIKQlNTOiBsYXN0X3NjYW5fcmVzX3Vz
ZWQ9Mi8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGRv
bmUgaW4gMC4xMjM2MzMgc2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNlaXZlZCAoMyBCU1Mp
ClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2
aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQg
UDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6
IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChX
UFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBs
ZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQ
MlA6IEF0dHJpYnV0ZSAxMyBsZW5ndGggMzAKUDJQOiAqIERldmljZSBJbmZvOiBhZGRyIDEyOjY4
OjNmOjRlOjM5OmYyIHByaW1hcnkgZGV2aWNlIHR5cGUgMTAtMDA1MEYyMDQtNSBkZXZpY2UgbmFt
ZSAnZHZkaHJtLW54JyBjb25maWcgbWV0aG9kcyAweDE4OApQMlA6IFVwZGF0ZSBwZWVyIDEyOjY4
OjNmOjRlOjM5OmYyIGNvbmZpZ19tZXRob2RzIDB4MCAtPiAweDE4OApQMlA6IFBlZXIgZm91bmQg
d2l0aCBMaXN0ZW4gZnJlcXVlbmN5IDI0MzcgTUh6IChyeF90aW1lPTU0Mzk5NS4wMTQxMzQpClAy
UC1ERVZJQ0UtRk9VTkQgMTI6Njg6M2Y6NGU6Mzk6ZjIgcDJwX2Rldl9hZGRyPTEyOjY4OjNmOjRl
OjM5OmYyIHByaV9kZXZfdHlwZT0xMC0wMDUwRjIwNC01IG5hbWU9J2R2ZGhybS1ueCcgY29uZmln
X21ldGhvZHM9MHgxODggZGV2X2NhcGFiPTB4MjUgZ3JvdXBfY2FwYWI9MHgwClAyUDogU3RhdGUg
U0VBUkNIIC0+IFNFQVJDSApQMlA6IFN0YXJ0aW5nIHNob3J0IGxpc3RlbiBzdGF0ZSAoc3RhdGU9
U0VBUkNIKQpXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQ
MlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQ
OiAqIERldmljZSBJbmZvCnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3JrICdwMnAtbGlzdGVu
J0AweDI2ODQ0NjAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBx
dWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5CnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5n
IHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBhZnRlciAwLjAwMDAxMyBzZWNvbmQg
d2FpdApubDgwMjExOiBFbmFibGUgUHJvYmUgUmVxdWVzdCByZXBvcnRpbmcgbmxfcHJlcT0weDI2
ODg1MDAKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUgdHlwZT0weDQwIG5sX2hhbmRsZT0weDI2ODg1
MDAgbWF0Y2g9Cm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGNvb2tpZSAweDFmOCBmb3IgZnJl
cT0yNDM3IE1IeiBkdXJhdGlvbj0yMDQKbmw4MDIxMTogRHJ2IEV2ZW50IDU1IChOTDgwMjExX0NN
RF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTog
UmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0wIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9
MCBkdXJhdGlvbj0yMDQgY29va2llPTB4MWY4IChtYXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50
IFJFTUFJTl9PTl9DSEFOTkVMICgyMSkgcmVjZWl2ZWQKT2ZmLWNoYW5uZWw6IFNlbmQgQWN0aW9u
IGNhbGxiYWNrICh3aXRob3V0X3JvYz0wIHBlbmRpbmdfYWN0aW9uX3R4PShuaWwpKQpQMlA6IFN0
YXJ0aW5nIExpc3RlbiB0aW1lb3V0KDAsMjA0ODAwKSBvbiBmcmVxPTI0MzcgYmFzZWQgb24gY2Fs
bGJhY2sKUDJQOiBTZXQgdGltZW91dCAoc3RhdGU9U0VBUkNIKTogMC4yMjQ4MDAgc2VjCm5sODAy
MTE6IERydiBFdmVudCA1NiAoTkw4MDIxMV9DTURfQ0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMKSBy
ZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVu
dCAoY2FuY2VsPTEgZnJlcT0yNDM3IGNoYW5uZWxfdHlwZT0wIGR1cmF0aW9uPTAgY29va2llPTB4
MWY4IChtYXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50IENBTkNFTF9SRU1BSU5fT05fQ0hBTk5F
TCAoMjIpIHJlY2VpdmVkClAyUDogQ2FuY2VsIHJlbWFpbi1vbi1jaGFubmVsIGNhbGxiYWNrIChw
MnBfbG9uZ19saXN0ZW49MCBtcyBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKcDJwLWRldi13bGFu
MDogUmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwIGRvbmUgaW4gMC4yMDQyOTQgc2Vj
b25kcwpQMlA6IERyaXZlciBlbmRlZCBMaXN0ZW4gc3RhdGUgKGZyZXE9MjQzNykKUDJQOiBTa2lw
IHN0b3BfbGlzdGVuIHNpbmNlIG5vdCBpbiBsaXN0ZW5fb25seSBzdGF0ZS4KUDJQOiBUaW1lb3V0
IChzdGF0ZT1TRUFSQ0gpCm5sODAyMTE6IERpc2FibGUgUHJvYmUgUmVxdWVzdCByZXBvcnRpbmcg
bmxfcHJlcT0weDg4ODg4ODg4OGFlMDBkODkKUDJQOiBTdGFydGluZyBzZWFyY2gKV1BTOiBCdWls
ZGluZyBXUFMgSUUgZm9yIFByb2JlIFJlcXVlc3QKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQg
MHgxMCkKV1BTOiAgKiBSZXF1ZXN0IFR5cGUKV1BTOiAgKiBDb25maWcgTWV0aG9kcyAoMTQ4KQpX
UFM6ICAqIFVVSUQtRQpXUFM6ICAqIFByaW1hcnkgRGV2aWNlIFR5cGUKV1BTOiAgKiBSRiBCYW5k
cyAoMykKV1BTOiAgKiBBc3NvY2lhdGlvbiBTdGF0ZQpXUFM6ICAqIENvbmZpZ3VyYXRpb24gRXJy
b3IgKDApCldQUzogICogRGV2aWNlIFBhc3N3b3JkIElEICgwKQpXUFM6ICAqIERldmljZSBOYW1l
ClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQ
MlA6ICogTGlzdGVuIENoYW5uZWw6IFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCA2CnAycC1k
ZXYtd2xhbjA6IEFkZCByYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwCnAycC1kZXYtd2xh
bjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBp
bW1lZGlhdGVseQpQMlA6IFJ1bm5pbmcgcDJwX3NjYW4KcDJwLWRldi13bGFuMDogU3RhcnRpbmcg
cmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MCBhZnRlciAwLjAwMDAxMSBzZWNvbmQgd2Fp
dApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBzY2FuIHJlcXVlc3QKbmw4MDIxMTogUDJQIHByb2Jl
IC0gbWFzayBTdXBwUmF0ZXMKU2NhbiByZXF1ZXN0ZWQgKHJldD0wKSAtIHNjYW4gdGltZW91dCAz
MCBzZWNvbmRzCm5sODAyMTE6IERydiBFdmVudCAzMyAoTkw4MDIxMV9DTURfVFJJR0dFUl9TQ0FO
KSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBTY2Fu
IHRyaWdnZXIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9TVEFSVEVEICg0OSkgcmVjZWl2ZWQK
cDJwLWRldi13bGFuMDogT3duIHNjYW4gcmVxdWVzdCBzdGFydGVkIGEgc2NhbiBpbiAwLjAwMDAz
NSBzZWNvbmRzCnAycC1kZXYtd2xhbjA6IENUUkwtRVZFTlQtU0NBTi1TVEFSVEVEIApubDgwMjEx
OiBEcnYgRXZlbnQgMzQgKE5MODAyMTFfQ01EX05FV19TQ0FOX1JFU1VMVFMpIHJlY2VpdmVkIGZv
ciBwMnAtZGV2LXdsYW4wCnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IE5ldyBzY2FuIHJlc3VsdHMg
YXZhaWxhYmxlCm5sODAyMTE6IFNjYW4gcHJvYmVkIGZvciBTU0lEICdESVJFQ1QtJwpubDgwMjEx
OiBTY2FuIGluY2x1ZGVkIGZyZXF1ZW5jaWVzOiAyNDEyIDI0MzcgMjQ2MgpwMnAtZGV2LXdsYW4w
OiBFdmVudCBTQ0FOX1JFU1VMVFMgKDMpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IFNjYW4gY29t
cGxldGVkIGluIDAuMTIwNTUxIHNlY29uZHMKbmw4MDIxMTogUmVjZWl2ZWQgc2NhbiByZXN1bHRz
ICgzIEJTU2VzKQpwMnAtZGV2LXdsYW4wOiBCU1M6IFN0YXJ0IHNjYW4gcmVzdWx0IHVwZGF0ZSAz
CkJTUzogbGFzdF9zY2FuX3Jlc191c2VkPTIvMzIKcDJwLWRldi13bGFuMDogUmFkaW8gd29yayAn
cDJwLXNjYW4nQDB4MjY4ODQ4MCBkb25lIGluIDAuMTIzNjYxIHNlY29uZHMKUDJQOiBTY2FuIHJl
c3VsdHMgcmVjZWl2ZWQgKDMgQlNTKQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAg
RGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogSWdu
b3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAy
UDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDog
UHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQ
IElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1
IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgMTMgbGVuZ3RoIDMwClAyUDogKiBE
ZXZpY2UgSW5mbzogYWRkciAxMjo2ODozZjo0ZTozOTpmMiBwcmltYXJ5IGRldmljZSB0eXBlIDEw
LTAwNTBGMjA0LTUgZGV2aWNlIG5hbWUgJ2R2ZGhybS1ueCcgY29uZmlnIG1ldGhvZHMgMHgxODgK
UDJQOiBTdGF0ZSBTRUFSQ0ggLT4gU0VBUkNIClAyUDogU3RhcnRpbmcgc2hvcnQgbGlzdGVuIHN0
YXRlIChzdGF0ZT1TRUFSQ0gpCldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzog
ICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBn
cm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8KcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdvcmsg
J3AycC1saXN0ZW4nQDB4MjY4NDQ2MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0
ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKcDJwLWRldi13bGFu
MDogU3RhcnRpbmcgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwIGFmdGVyIDAuMDAw
MDEzIHNlY29uZCB3YWl0Cm5sODAyMTE6IEVuYWJsZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBu
bF9wcmVxPTB4MjY4ODUwMApubDgwMjExOiBSZWdpc3RlciBmcmFtZSB0eXBlPTB4NDAgbmxfaGFu
ZGxlPTB4MjY4ODUwMCBtYXRjaD0Kbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgY29va2llIDB4
MWY5IGZvciBmcmVxPTI0MzcgTUh6IGR1cmF0aW9uPTMwNwpubDgwMjExOiBEcnYgRXZlbnQgNTUg
KE5MODAyMTFfQ01EX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFu
MApubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTAgZnJlcT0yNDM3IGNo
YW5uZWxfdHlwZT0wIGR1cmF0aW9uPTMwNyBjb29raWU9MHgxZjkgKG1hdGNoKSkKcDJwLWRldi13
bGFuMDogRXZlbnQgUkVNQUlOX09OX0NIQU5ORUwgKDIxKSByZWNlaXZlZApPZmYtY2hhbm5lbDog
U2VuZCBBY3Rpb24gY2FsbGJhY2sgKHdpdGhvdXRfcm9jPTAgcGVuZGluZ19hY3Rpb25fdHg9KG5p
bCkpClAyUDogU3RhcnRpbmcgTGlzdGVuIHRpbWVvdXQoMCwzMDcyMDApIG9uIGZyZXE9MjQzNyBi
YXNlZCBvbiBjYWxsYmFjawpQMlA6IFNldCB0aW1lb3V0IChzdGF0ZT1TRUFSQ0gpOiAwLjMyNzIw
MCBzZWMKbmw4MDIxMTogRHJ2IEV2ZW50IDU2IChOTDgwMjExX0NNRF9DQU5DRUxfUkVNQUlOX09O
X0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1j
aGFubmVsIGV2ZW50IChjYW5jZWw9MSBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249
MCBjb29raWU9MHgxZjkgKG1hdGNoKSkKcDJwLWRldi13bGFuMDogRXZlbnQgQ0FOQ0VMX1JFTUFJ
Tl9PTl9DSEFOTkVMICgyMikgcmVjZWl2ZWQKUDJQOiBDYW5jZWwgcmVtYWluLW9uLWNoYW5uZWwg
Y2FsbGJhY2sgKHAycF9sb25nX2xpc3Rlbj0wIG1zIHBlbmRpbmdfYWN0aW9uX3R4PShuaWwpKQpw
MnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgZG9uZSBpbiAw
LjMwNjY3MiBzZWNvbmRzClAyUDogRHJpdmVyIGVuZGVkIExpc3RlbiBzdGF0ZSAoZnJlcT0yNDM3
KQpQMlA6IFNraXAgc3RvcF9saXN0ZW4gc2luY2Ugbm90IGluIGxpc3Rlbl9vbmx5IHN0YXRlLgpQ
MlA6IFRpbWVvdXQgKHN0YXRlPVNFQVJDSCkKbmw4MDIxMTogRGlzYWJsZSBQcm9iZSBSZXF1ZXN0
IHJlcG9ydGluZyBubF9wcmVxPTB4ODg4ODg4ODg4YWUwMGQ4OQpQMlA6IFN0YXJ0aW5nIHNlYXJj
aApXUFM6IEJ1aWxkaW5nIFdQUyBJRSBmb3IgUHJvYmUgUmVxdWVzdApXUFM6ICAqIFZlcnNpb24g
KGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFJlcXVlc3QgVHlwZQpXUFM6ICAqIENvbmZpZyBNZXRo
b2RzICgxNDgpCldQUzogICogVVVJRC1FCldQUzogICogUHJpbWFyeSBEZXZpY2UgVHlwZQpXUFM6
ICAqIFJGIEJhbmRzICgzKQpXUFM6ICAqIEFzc29jaWF0aW9uIFN0YXRlCldQUzogICogQ29uZmln
dXJhdGlvbiBFcnJvciAoMCkKV1BTOiAgKiBEZXZpY2UgUGFzc3dvcmQgSUQgKDApCldQUzogICog
RGV2aWNlIE5hbWUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1
IGdyb3VwPTAwClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFu
bmVsIDYKcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAK
cDJwLWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVk
dWxlIHN0YXJ0IGltbWVkaWF0ZWx5ClAyUDogUnVubmluZyBwMnBfc2NhbgpwMnAtZGV2LXdsYW4w
OiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGFmdGVyIDAuMDAwMDIx
IHNlY29uZCB3YWl0CnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IHNjYW4gcmVxdWVzdApubDgwMjEx
OiBQMlAgcHJvYmUgLSBtYXNrIFN1cHBSYXRlcwpTY2FuIHJlcXVlc3RlZCAocmV0PTApIC0gc2Nh
biB0aW1lb3V0IDMwIHNlY29uZHMKbmw4MDIxMTogRHJ2IEV2ZW50IDMzIChOTDgwMjExX0NNRF9U
UklHR0VSX1NDQU4pIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1kZXYtd2xhbjA6IG5s
ODAyMTE6IFNjYW4gdHJpZ2dlcgpwMnAtZGV2LXdsYW4wOiBFdmVudCBTQ0FOX1NUQVJURUQgKDQ5
KSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBPd24gc2NhbiByZXF1ZXN0IHN0YXJ0ZWQgYSBzY2Fu
IGluIDAuMDAwMDIyIHNlY29uZHMKcDJwLWRldi13bGFuMDogQ1RSTC1FVkVOVC1TQ0FOLVNUQVJU
RUQgCm5sODAyMTE6IERydiBFdmVudCAzNCAoTkw4MDIxMV9DTURfTkVXX1NDQU5fUkVTVUxUUykg
cmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogTmV3IHNj
YW4gcmVzdWx0cyBhdmFpbGFibGUKbmw4MDIxMTogU2NhbiBwcm9iZWQgZm9yIFNTSUQgJ0RJUkVD
VC0nCm5sODAyMTE6IFNjYW4gaW5jbHVkZWQgZnJlcXVlbmNpZXM6IDI0MTIgMjQzNyAyNDYyCnAy
cC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fUkVTVUxUUyAoMykgcmVjZWl2ZWQKcDJwLWRldi13bGFu
MDogU2NhbiBjb21wbGV0ZWQgaW4gMC4xMjA2MDIgc2Vjb25kcwpubDgwMjExOiBSZWNlaXZlZCBz
Y2FuIHJlc3VsdHMgKDMgQlNTZXMpCnAycC1kZXYtd2xhbjA6IEJTUzogU3RhcnQgc2NhbiByZXN1
bHQgdXBkYXRlIDQKQlNTOiBsYXN0X3NjYW5fcmVzX3VzZWQ9Mi8zMgpwMnAtZGV2LXdsYW4wOiBS
YWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGRvbmUgaW4gMC4xMjM1Mjkgc2Vjb25kcwpQ
MlA6IFNjYW4gcmVzdWx0cyByZWNlaXZlZCAoMyBCU1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3
aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMg
SUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBE
ZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAw
eDQzODgKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDog
UGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENh
cGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSAxMyBsZW5ndGgg
MzAKUDJQOiAqIERldmljZSBJbmZvOiBhZGRyIDEyOjY4OjNmOjRlOjM5OmYyIHByaW1hcnkgZGV2
aWNlIHR5cGUgMTAtMDA1MEYyMDQtNSBkZXZpY2UgbmFtZSAnZHZkaHJtLW54JyBjb25maWcgbWV0
aG9kcyAweDE4OApQMlA6IFN0YXRlIFNFQVJDSCAtPiBTRUFSQ0gKUDJQOiBTdGFydGluZyBzaG9y
dCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQg
MHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxp
dHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQg
cmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJh
ZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpw
MnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAg
YWZ0ZXIgMC4wMDAwMTEgc2Vjb25kIHdhaXQKbmw4MDIxMTogRW5hYmxlIFByb2JlIFJlcXVlc3Qg
cmVwb3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9
MHg0MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNoPQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5l
bCBjb29raWUgMHgxZmEgZm9yIGZyZXE9MjQzNyBNSHogZHVyYXRpb249MTAyCm5sODAyMTE6IERy
diBFdmVudCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBw
MnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBm
cmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MTAyIGNvb2tpZT0weDFmYSAobWF0Y2gp
KQpwMnAtZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9m
Zi1jaGFubmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2Fj
dGlvbl90eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0ZW4gdGltZW91dCgwLDEwMjQwMCkgb24g
ZnJlcT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJD
SCk6IDAuMTIyNDAwIHNlYwpubDgwMjExOiBEcnYgRXZlbnQgNTYgKE5MODAyMTFfQ01EX0NBTkNF
TF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTog
UmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0xIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9
MCBkdXJhdGlvbj0wIGNvb2tpZT0weDFmYSAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBD
QU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNlaXZlZApQMlA6IENhbmNlbCByZW1haW4t
b24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlzdGVuPTAgbXMgcGVuZGluZ19hY3Rpb25f
dHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2
MCBkb25lIGluIDAuMTAxODQxIHNlY29uZHMKUDJQOiBEcml2ZXIgZW5kZWQgTGlzdGVuIHN0YXRl
IChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3RlbiBzaW5jZSBub3QgaW4gbGlzdGVuX29u
bHkgc3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9U0VBUkNIKQpubDgwMjExOiBEaXNhYmxlIFBy
b2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHg4ODg4ODg4ODhhZTAwZDg5ClAyUDogU3Rh
cnRpbmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BTIElFIGZvciBQcm9iZSBSZXF1ZXN0CldQUzog
ICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogUmVxdWVzdCBUeXBlCldQUzogICog
Q29uZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBVVUlELUUKV1BTOiAgKiBQcmltYXJ5IERldmlj
ZSBUeXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQUzogICogQXNzb2NpYXRpb24gU3RhdGUKV1BT
OiAgKiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpXUFM6ICAqIERldmljZSBQYXNzd29yZCBJRCAo
MCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJp
bGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBSZWd1bGF0b3J5IENs
YXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLXNjYW4n
QDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1
ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKUDJQOiBSdW5uaW5nIHAycF9zY2FuCnAy
cC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgYWZ0
ZXIgMC4wMDAwMTAgc2Vjb25kIHdhaXQKcDJwLWRldi13bGFuMDogbmw4MDIxMTogc2NhbiByZXF1
ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sgU3VwcFJhdGVzClNjYW4gcmVxdWVzdGVkIChy
ZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25kcwpubDgwMjExOiBEcnYgRXZlbnQgMzMgKE5M
ODAyMTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRl
di13bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2VyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5f
U1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IE93biBzY2FuIHJlcXVlc3Qgc3Rh
cnRlZCBhIHNjYW4gaW4gMC4wMDAwMjIgc2Vjb25kcwpwMnAtZGV2LXdsYW4wOiBDVFJMLUVWRU5U
LVNDQU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2ZW50IDM0IChOTDgwMjExX0NNRF9ORVdfU0NB
Tl9SRVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgw
MjExOiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJsZQpubDgwMjExOiBTY2FuIHByb2JlZCBmb3Ig
U1NJRCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBpbmNsdWRlZCBmcmVxdWVuY2llczogMjQxMiAy
NDM3IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9SRVNVTFRTICgzKSByZWNlaXZlZApw
MnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAwLjEyMDQ4NiBzZWNvbmRzCm5sODAyMTE6
IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoMyBCU1NlcykKcDJwLWRldi13bGFuMDogQlNTOiBTdGFy
dCBzY2FuIHJlc3VsdCB1cGRhdGUgNQpCU1M6IGxhc3Rfc2Nhbl9yZXNfdXNlZD0yLzMyCnAycC1k
ZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgZG9uZSBpbiAwLjEyMzQ4
MCBzZWNvbmRzClAyUDogU2NhbiByZXN1bHRzIHJlY2VpdmVkICgzIEJTUykKUDJQOiBJZ25vcmUg
c2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQ
YXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIElu
Zm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhv
ZHMgKFdQUyk6IDB4NDM4OApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBG
MjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDog
KiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRl
IDEzIGxlbmd0aCAzMApQMlA6ICogRGV2aWNlIEluZm86IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6ZjIg
cHJpbWFyeSBkZXZpY2UgdHlwZSAxMC0wMDUwRjIwNC01IGRldmljZSBuYW1lICdkdmRocm0tbngn
IGNvbmZpZyBtZXRob2RzIDB4MTg4ClAyUDogU3RhdGUgU0VBUkNIIC0+IFNFQVJDSApQMlA6IFN0
YXJ0aW5nIHNob3J0IGxpc3RlbiBzdGF0ZSAoc3RhdGU9U0VBUkNIKQpXUFM6ICAqIFZlcnNpb24g
KGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6
ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCnAycC1kZXYt
d2xhbjA6IEFkZCByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAKcDJwLWRldi13bGFu
MDogRmlyc3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGlt
bWVkaWF0ZWx5CnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4n
QDB4MjY4NDQ2MCBhZnRlciAwLjAwMDAxMSBzZWNvbmQgd2FpdApubDgwMjExOiBFbmFibGUgUHJv
YmUgUmVxdWVzdCByZXBvcnRpbmcgbmxfcHJlcT0weDI2ODg1MDAKbmw4MDIxMTogUmVnaXN0ZXIg
ZnJhbWUgdHlwZT0weDQwIG5sX2hhbmRsZT0weDI2ODg1MDAgbWF0Y2g9Cm5sODAyMTE6IFJlbWFp
bi1vbi1jaGFubmVsIGNvb2tpZSAweDFmYiBmb3IgZnJlcT0yNDM3IE1IeiBkdXJhdGlvbj0xMDIK
bmw4MDIxMTogRHJ2IEV2ZW50IDU1IChOTDgwMjExX0NNRF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVj
ZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQg
KGNhbmNlbD0wIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0xMDIgY29va2llPTB4
MWZiIChtYXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50IFJFTUFJTl9PTl9DSEFOTkVMICgyMSkg
cmVjZWl2ZWQKT2ZmLWNoYW5uZWw6IFNlbmQgQWN0aW9uIGNhbGxiYWNrICh3aXRob3V0X3JvYz0w
IHBlbmRpbmdfYWN0aW9uX3R4PShuaWwpKQpQMlA6IFN0YXJ0aW5nIExpc3RlbiB0aW1lb3V0KDAs
MTAyNDAwKSBvbiBmcmVxPTI0MzcgYmFzZWQgb24gY2FsbGJhY2sKUDJQOiBTZXQgdGltZW91dCAo
c3RhdGU9U0VBUkNIKTogMC4xMjI0MDAgc2VjCm5sODAyMTE6IERydiBFdmVudCA1NiAoTkw4MDIx
MV9DTURfQ0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFu
MApubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTEgZnJlcT0yNDM3IGNo
YW5uZWxfdHlwZT0wIGR1cmF0aW9uPTAgY29va2llPTB4MWZiIChtYXRjaCkpCnAycC1kZXYtd2xh
bjA6IEV2ZW50IENBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCAoMjIpIHJlY2VpdmVkClAyUDogQ2Fu
Y2VsIHJlbWFpbi1vbi1jaGFubmVsIGNhbGxiYWNrIChwMnBfbG9uZ19saXN0ZW49MCBtcyBwZW5k
aW5nX2FjdGlvbl90eD0obmlsKSkKcDJwLWRldi13bGFuMDogUmFkaW8gd29yayAncDJwLWxpc3Rl
bidAMHgyNjg0NDYwIGRvbmUgaW4gMC4xMDE4Mzggc2Vjb25kcwpQMlA6IERyaXZlciBlbmRlZCBM
aXN0ZW4gc3RhdGUgKGZyZXE9MjQzNykKUDJQOiBTa2lwIHN0b3BfbGlzdGVuIHNpbmNlIG5vdCBp
biBsaXN0ZW5fb25seSBzdGF0ZS4KUDJQOiBUaW1lb3V0IChzdGF0ZT1TRUFSQ0gpCm5sODAyMTE6
IERpc2FibGUgUHJvYmUgUmVxdWVzdCByZXBvcnRpbmcgbmxfcHJlcT0weDg4ODg4ODg4OGFlMDBk
ODkKUDJQOiBTdGFydGluZyBzZWFyY2gKV1BTOiBCdWlsZGluZyBXUFMgSUUgZm9yIFByb2JlIFJl
cXVlc3QKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBSZXF1ZXN0IFR5
cGUKV1BTOiAgKiBDb25maWcgTWV0aG9kcyAoMTQ4KQpXUFM6ICAqIFVVSUQtRQpXUFM6ICAqIFBy
aW1hcnkgRGV2aWNlIFR5cGUKV1BTOiAgKiBSRiBCYW5kcyAoMykKV1BTOiAgKiBBc3NvY2lhdGlv
biBTdGF0ZQpXUFM6ICAqIENvbmZpZ3VyYXRpb24gRXJyb3IgKDApCldQUzogICogRGV2aWNlIFBh
c3N3b3JkIElEICgwKQpXUFM6ICAqIERldmljZSBOYW1lClAyUDogKiBQMlAgSUUgaGVhZGVyClAy
UDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogTGlzdGVuIENoYW5uZWw6IFJl
Z3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCA2CnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3Jr
ICdwMnAtc2NhbidAMHgyNjg4NDgwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRl
bSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpQMlA6IFJ1bm5pbmcg
cDJwX3NjYW4KcDJwLWRldi13bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4
MjY4ODQ4MCBhZnRlciAwLjAwMDAxMCBzZWNvbmQgd2FpdApwMnAtZGV2LXdsYW4wOiBubDgwMjEx
OiBzY2FuIHJlcXVlc3QKbmw4MDIxMTogUDJQIHByb2JlIC0gbWFzayBTdXBwUmF0ZXMKU2NhbiBy
ZXF1ZXN0ZWQgKHJldD0wKSAtIHNjYW4gdGltZW91dCAzMCBzZWNvbmRzCm5sODAyMTE6IERydiBF
dmVudCAzMyAoTkw4MDIxMV9DTURfVFJJR0dFUl9TQ0FOKSByZWNlaXZlZCBmb3IgcDJwLWRldi13
bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBTY2FuIHRyaWdnZXIKcDJwLWRldi13bGFuMDog
RXZlbnQgU0NBTl9TVEFSVEVEICg0OSkgcmVjZWl2ZWQKcDJwLWRldi13bGFuMDogT3duIHNjYW4g
cmVxdWVzdCBzdGFydGVkIGEgc2NhbiBpbiAwLjAwMDAzNCBzZWNvbmRzCnAycC1kZXYtd2xhbjA6
IENUUkwtRVZFTlQtU0NBTi1TVEFSVEVEIApubDgwMjExOiBEcnYgRXZlbnQgMzQgKE5MODAyMTFf
Q01EX05FV19TQ0FOX1JFU1VMVFMpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1kZXYt
d2xhbjA6IG5sODAyMTE6IE5ldyBzY2FuIHJlc3VsdHMgYXZhaWxhYmxlCm5sODAyMTE6IFNjYW4g
cHJvYmVkIGZvciBTU0lEICdESVJFQ1QtJwpubDgwMjExOiBTY2FuIGluY2x1ZGVkIGZyZXF1ZW5j
aWVzOiAyNDEyIDI0MzcgMjQ2MgpwMnAtZGV2LXdsYW4wOiBFdmVudCBTQ0FOX1JFU1VMVFMgKDMp
IHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IFNjYW4gY29tcGxldGVkIGluIDAuMTIwNDU4IHNlY29u
ZHMKbmw4MDIxMTogUmVjZWl2ZWQgc2NhbiByZXN1bHRzICgzIEJTU2VzKQpwMnAtZGV2LXdsYW4w
OiBCU1M6IFN0YXJ0IHNjYW4gcmVzdWx0IHVwZGF0ZSA2CkJTUzogbGFzdF9zY2FuX3Jlc191c2Vk
PTIvMzIKcDJwLWRldi13bGFuMDogUmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MCBkb25l
IGluIDAuMTIzNDA5IHNlY29uZHMKUDJQOiBTY2FuIHJlc3VsdHMgcmVjZWl2ZWQgKDMgQlNTKQpQ
MlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmlj
ZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAy
UCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBD
b25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BT
KTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVu
Z3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQ
OiBBdHRyaWJ1dGUgMTMgbGVuZ3RoIDMwClAyUDogKiBEZXZpY2UgSW5mbzogYWRkciAxMjo2ODoz
Zjo0ZTozOTpmMiBwcmltYXJ5IGRldmljZSB0eXBlIDEwLTAwNTBGMjA0LTUgZGV2aWNlIG5hbWUg
J2R2ZGhybS1ueCcgY29uZmlnIG1ldGhvZHMgMHgxODgKUDJQOiBTdGF0ZSBTRUFSQ0ggLT4gU0VB
UkNIClAyUDogU3RhcnRpbmcgc2hvcnQgbGlzdGVuIHN0YXRlIChzdGF0ZT1TRUFSQ0gpCldQUzog
ICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAgSUUg
aGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNlIElu
Zm8KcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MApw
MnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1
bGUgc3RhcnQgaW1tZWRpYXRlbHkKcDJwLWRldi13bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAn
cDJwLWxpc3RlbidAMHgyNjg0NDYwIGFmdGVyIDAuMDAwMDExIHNlY29uZCB3YWl0Cm5sODAyMTE6
IEVuYWJsZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBubF9wcmVxPTB4MjY4ODUwMApubDgwMjEx
OiBSZWdpc3RlciBmcmFtZSB0eXBlPTB4NDAgbmxfaGFuZGxlPTB4MjY4ODUwMCBtYXRjaD0Kbmw4
MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgY29va2llIDB4MWZjIGZvciBmcmVxPTI0MzcgTUh6IGR1
cmF0aW9uPTEwMgpubDgwMjExOiBEcnYgRXZlbnQgNTUgKE5MODAyMTFfQ01EX1JFTUFJTl9PTl9D
SEFOTkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSZW1haW4tb24tY2hh
bm5lbCBldmVudCAoY2FuY2VsPTAgZnJlcT0yNDM3IGNoYW5uZWxfdHlwZT0wIGR1cmF0aW9uPTEw
MiBjb29raWU9MHgxZmMgKG1hdGNoKSkKcDJwLWRldi13bGFuMDogRXZlbnQgUkVNQUlOX09OX0NI
QU5ORUwgKDIxKSByZWNlaXZlZApPZmYtY2hhbm5lbDogU2VuZCBBY3Rpb24gY2FsbGJhY2sgKHdp
dGhvdXRfcm9jPTAgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpClAyUDogU3RhcnRpbmcgTGlzdGVu
IHRpbWVvdXQoMCwxMDI0MDApIG9uIGZyZXE9MjQzNyBiYXNlZCBvbiBjYWxsYmFjawpQMlA6IFNl
dCB0aW1lb3V0IChzdGF0ZT1TRUFSQ0gpOiAwLjEyMjQwMCBzZWMKbmw4MDIxMTogRHJ2IEV2ZW50
IDU2IChOTDgwMjExX0NNRF9DQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBw
MnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MSBm
cmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MCBjb29raWU9MHgxZmMgKG1hdGNoKSkK
cDJwLWRldi13bGFuMDogRXZlbnQgQ0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMICgyMikgcmVjZWl2
ZWQKUDJQOiBDYW5jZWwgcmVtYWluLW9uLWNoYW5uZWwgY2FsbGJhY2sgKHAycF9sb25nX2xpc3Rl
bj0wIG1zIHBlbmRpbmdfYWN0aW9uX3R4PShuaWwpKQpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3Jr
ICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgZG9uZSBpbiAwLjEwMTgwNSBzZWNvbmRzClAyUDogRHJp
dmVyIGVuZGVkIExpc3RlbiBzdGF0ZSAoZnJlcT0yNDM3KQpQMlA6IFNraXAgc3RvcF9saXN0ZW4g
c2luY2Ugbm90IGluIGxpc3Rlbl9vbmx5IHN0YXRlLgpQMlA6IFRpbWVvdXQgKHN0YXRlPVNFQVJD
SCkKbmw4MDIxMTogRGlzYWJsZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBubF9wcmVxPTB4ODg4
ODg4ODg4YWUwMGQ4OQpQMlA6IFN0YXJ0aW5nIHNlYXJjaApXUFM6IEJ1aWxkaW5nIFdQUyBJRSBm
b3IgUHJvYmUgUmVxdWVzdApXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAq
IFJlcXVlc3QgVHlwZQpXUFM6ICAqIENvbmZpZyBNZXRob2RzICgxNDgpCldQUzogICogVVVJRC1F
CldQUzogICogUHJpbWFyeSBEZXZpY2UgVHlwZQpXUFM6ICAqIFJGIEJhbmRzICgzKQpXUFM6ICAq
IEFzc29jaWF0aW9uIFN0YXRlCldQUzogICogQ29uZmlndXJhdGlvbiBFcnJvciAoMCkKV1BTOiAg
KiBEZXZpY2UgUGFzc3dvcmQgSUQgKDApCldQUzogICogRGV2aWNlIE5hbWUKUDJQOiAqIFAyUCBJ
RSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBMaXN0ZW4g
Q2hhbm5lbDogUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIDYKcDJwLWRldi13bGFuMDogQWRk
IHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFk
aW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5ClAy
UDogUnVubmluZyBwMnBfc2NhbgpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdw
MnAtc2NhbidAMHgyNjg4NDgwIGFmdGVyIDAuMDAwMDA5IHNlY29uZCB3YWl0CnAycC1kZXYtd2xh
bjA6IG5sODAyMTE6IHNjYW4gcmVxdWVzdApubDgwMjExOiBQMlAgcHJvYmUgLSBtYXNrIFN1cHBS
YXRlcwpTY2FuIHJlcXVlc3RlZCAocmV0PTApIC0gc2NhbiB0aW1lb3V0IDMwIHNlY29uZHMKbmw4
MDIxMTogRHJ2IEV2ZW50IDMzIChOTDgwMjExX0NNRF9UUklHR0VSX1NDQU4pIHJlY2VpdmVkIGZv
ciBwMnAtZGV2LXdsYW4wCnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IFNjYW4gdHJpZ2dlcgpwMnAt
ZGV2LXdsYW4wOiBFdmVudCBTQ0FOX1NUQVJURUQgKDQ5KSByZWNlaXZlZApwMnAtZGV2LXdsYW4w
OiBPd24gc2NhbiByZXF1ZXN0IHN0YXJ0ZWQgYSBzY2FuIGluIDAuMDAwMDIxIHNlY29uZHMKcDJw
LWRldi13bGFuMDogQ1RSTC1FVkVOVC1TQ0FOLVNUQVJURUQgCm5sODAyMTE6IERydiBFdmVudCAz
NCAoTkw4MDIxMV9DTURfTkVXX1NDQU5fUkVTVUxUUykgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xh
bjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogTmV3IHNjYW4gcmVzdWx0cyBhdmFpbGFibGUKbmw4
MDIxMTogU2NhbiBwcm9iZWQgZm9yIFNTSUQgJ0RJUkVDVC0nCm5sODAyMTE6IFNjYW4gaW5jbHVk
ZWQgZnJlcXVlbmNpZXM6IDI0MTIgMjQzNyAyNDYyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5f
UkVTVUxUUyAoMykgcmVjZWl2ZWQKcDJwLWRldi13bGFuMDogU2NhbiBjb21wbGV0ZWQgaW4gMC4x
MjA1OTUgc2Vjb25kcwpubDgwMjExOiBSZWNlaXZlZCBzY2FuIHJlc3VsdHMgKDMgQlNTZXMpCnAy
cC1kZXYtd2xhbjA6IEJTUzogU3RhcnQgc2NhbiByZXN1bHQgdXBkYXRlIDcKQlNTOiBsYXN0X3Nj
YW5fcmVzX3VzZWQ9Mi8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidAMHgy
Njg4NDgwIGRvbmUgaW4gMC4xMjM2MzAgc2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNlaXZl
ZCAoMyBCU1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBv
ciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRh
IHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQ
UyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBQcmltYXJ5IERldmlj
ZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRy
aWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJp
bGl0eSAwMApQMlA6IEF0dHJpYnV0ZSAxMyBsZW5ndGggMzAKUDJQOiAqIERldmljZSBJbmZvOiBh
ZGRyIDEyOjY4OjNmOjRlOjM5OmYyIHByaW1hcnkgZGV2aWNlIHR5cGUgMTAtMDA1MEYyMDQtNSBk
ZXZpY2UgbmFtZSAnZHZkaHJtLW54JyBjb25maWcgbWV0aG9kcyAweDE4OApQMlA6IERvIG5vdCB1
cGRhdGUgcGVlciBlbnRyeSBiYXNlZCBvbiBvbGQgZnJhbWUgKHJ4X3RpbWU9NTQzOTk2LjA2NTI1
MiBsYXN0X3NlZW49NTQzOTk2LjA2NTYxMikKUDJQOiBTdGF0ZSBTRUFSQ0ggLT4gU0VBUkNIClAy
UDogU3RhcnRpbmcgc2hvcnQgbGlzdGVuIHN0YXRlIChzdGF0ZT1TRUFSQ0gpCldQUzogICogVmVy
c2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVy
ClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8KcDJw
LWRldi13bGFuMDogQWRkIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MApwMnAtZGV2
LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3Rh
cnQgaW1tZWRpYXRlbHkKcDJwLWRldi13bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAncDJwLWxp
c3RlbidAMHgyNjg0NDYwIGFmdGVyIDAuMDAwMDEyIHNlY29uZCB3YWl0Cm5sODAyMTE6IEVuYWJs
ZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBubF9wcmVxPTB4MjY4ODUwMApubDgwMjExOiBSZWdp
c3RlciBmcmFtZSB0eXBlPTB4NDAgbmxfaGFuZGxlPTB4MjY4ODUwMCBtYXRjaD0Kbmw4MDIxMTog
UmVtYWluLW9uLWNoYW5uZWwgY29va2llIDB4MWZkIGZvciBmcmVxPTI0MzcgTUh6IGR1cmF0aW9u
PTEwMgpubDgwMjExOiBEcnYgRXZlbnQgNTUgKE5MODAyMTFfQ01EX1JFTUFJTl9PTl9DSEFOTkVM
KSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBl
dmVudCAoY2FuY2VsPTAgZnJlcT0yNDM3IGNoYW5uZWxfdHlwZT0wIGR1cmF0aW9uPTEwMiBjb29r
aWU9MHgxZmQgKG1hdGNoKSkKcDJwLWRldi13bGFuMDogRXZlbnQgUkVNQUlOX09OX0NIQU5ORUwg
KDIxKSByZWNlaXZlZApPZmYtY2hhbm5lbDogU2VuZCBBY3Rpb24gY2FsbGJhY2sgKHdpdGhvdXRf
cm9jPTAgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpClAyUDogU3RhcnRpbmcgTGlzdGVuIHRpbWVv
dXQoMCwxMDI0MDApIG9uIGZyZXE9MjQzNyBiYXNlZCBvbiBjYWxsYmFjawpQMlA6IFNldCB0aW1l
b3V0IChzdGF0ZT1TRUFSQ0gpOiAwLjEyMjQwMCBzZWMKbmw4MDIxMTogRHJ2IEV2ZW50IDU2IChO
TDgwMjExX0NNRF9DQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2
LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MSBmcmVxPTI0
MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MCBjb29raWU9MHgxZmQgKG1hdGNoKSkKcDJwLWRl
di13bGFuMDogRXZlbnQgQ0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMICgyMikgcmVjZWl2ZWQKUDJQ
OiBDYW5jZWwgcmVtYWluLW9uLWNoYW5uZWwgY2FsbGJhY2sgKHAycF9sb25nX2xpc3Rlbj0wIG1z
IHBlbmRpbmdfYWN0aW9uX3R4PShuaWwpKQpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAt
bGlzdGVuJ0AweDI2ODQ0NjAgZG9uZSBpbiAwLjEwMTgyOCBzZWNvbmRzClAyUDogRHJpdmVyIGVu
ZGVkIExpc3RlbiBzdGF0ZSAoZnJlcT0yNDM3KQpQMlA6IFNraXAgc3RvcF9saXN0ZW4gc2luY2Ug
bm90IGluIGxpc3Rlbl9vbmx5IHN0YXRlLgpQMlA6IFRpbWVvdXQgKHN0YXRlPVNFQVJDSCkKbmw4
MDIxMTogRGlzYWJsZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBubF9wcmVxPTB4ODg4ODg4ODg4
YWUwMGQ4OQpQMlA6IFN0YXJ0aW5nIHNlYXJjaApXUFM6IEJ1aWxkaW5nIFdQUyBJRSBmb3IgUHJv
YmUgUmVxdWVzdApXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFJlcXVl
c3QgVHlwZQpXUFM6ICAqIENvbmZpZyBNZXRob2RzICgxNDgpCldQUzogICogVVVJRC1FCldQUzog
ICogUHJpbWFyeSBEZXZpY2UgVHlwZQpXUFM6ICAqIFJGIEJhbmRzICgzKQpXUFM6ICAqIEFzc29j
aWF0aW9uIFN0YXRlCldQUzogICogQ29uZmlndXJhdGlvbiBFcnJvciAoMCkKV1BTOiAgKiBEZXZp
Y2UgUGFzc3dvcmQgSUQgKDApCldQUzogICogRGV2aWNlIE5hbWUKUDJQOiAqIFAyUCBJRSBoZWFk
ZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBMaXN0ZW4gQ2hhbm5l
bDogUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIDYKcDJwLWRldi13bGFuMDogQWRkIHJhZGlv
IHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29y
ayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5ClAyUDogUnVu
bmluZyBwMnBfc2NhbgpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtc2Nh
bidAMHgyNjg4NDgwIGFmdGVyIDAuMDAwMDA4IHNlY29uZCB3YWl0CnAycC1kZXYtd2xhbjA6IG5s
ODAyMTE6IHNjYW4gcmVxdWVzdApubDgwMjExOiBQMlAgcHJvYmUgLSBtYXNrIFN1cHBSYXRlcwpT
Y2FuIHJlcXVlc3RlZCAocmV0PTApIC0gc2NhbiB0aW1lb3V0IDMwIHNlY29uZHMKbmw4MDIxMTog
RHJ2IEV2ZW50IDMzIChOTDgwMjExX0NNRF9UUklHR0VSX1NDQU4pIHJlY2VpdmVkIGZvciBwMnAt
ZGV2LXdsYW4wCnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IFNjYW4gdHJpZ2dlcgpwMnAtZGV2LXds
YW4wOiBFdmVudCBTQ0FOX1NUQVJURUQgKDQ5KSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBPd24g
c2NhbiByZXF1ZXN0IHN0YXJ0ZWQgYSBzY2FuIGluIDAuMDAwMDIwIHNlY29uZHMKcDJwLWRldi13
bGFuMDogQ1RSTC1FVkVOVC1TQ0FOLVNUQVJURUQgCm5sODAyMTE6IERydiBFdmVudCAzNCAoTkw4
MDIxMV9DTURfTkVXX1NDQU5fUkVTVUxUUykgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJw
LWRldi13bGFuMDogbmw4MDIxMTogTmV3IHNjYW4gcmVzdWx0cyBhdmFpbGFibGUKbmw4MDIxMTog
U2NhbiBwcm9iZWQgZm9yIFNTSUQgJ0RJUkVDVC0nCm5sODAyMTE6IFNjYW4gaW5jbHVkZWQgZnJl
cXVlbmNpZXM6IDI0MTIgMjQzNyAyNDYyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fUkVTVUxU
UyAoMykgcmVjZWl2ZWQKcDJwLWRldi13bGFuMDogU2NhbiBjb21wbGV0ZWQgaW4gMC4xMjA1MDcg
c2Vjb25kcwpubDgwMjExOiBSZWNlaXZlZCBzY2FuIHJlc3VsdHMgKDMgQlNTZXMpCnAycC1kZXYt
d2xhbjA6IEJTUzogU3RhcnQgc2NhbiByZXN1bHQgdXBkYXRlIDgKQlNTOiBsYXN0X3NjYW5fcmVz
X3VzZWQ9Mi8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgw
IGRvbmUgaW4gMC4xMjM0NTYgc2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNlaXZlZCAoMyBC
U1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAg
RGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhv
dXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQ
MlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBQcmltYXJ5IERldmljZSBUeXBl
IChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUg
MiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAw
MApQMlA6IEF0dHJpYnV0ZSAxMyBsZW5ndGggMzAKUDJQOiAqIERldmljZSBJbmZvOiBhZGRyIDEy
OjY4OjNmOjRlOjM5OmYyIHByaW1hcnkgZGV2aWNlIHR5cGUgMTAtMDA1MEYyMDQtNSBkZXZpY2Ug
bmFtZSAnZHZkaHJtLW54JyBjb25maWcgbWV0aG9kcyAweDE4OApQMlA6IFN0YXRlIFNFQVJDSCAt
PiBTRUFSQ0gKUDJQOiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkK
V1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAy
UCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZp
Y2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0
NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBz
Y2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3
b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTEgc2Vjb25kIHdhaXQKbmw4
MDIxMTogRW5hYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5s
ODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNo
PQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgxZmUgZm9yIGZyZXE9MjQzNyBN
SHogZHVyYXRpb249MjA0Cm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIxMV9DTURfUkVNQUlO
X09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1v
bi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRp
b249MjA0IGNvb2tpZT0weDFmZSAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5f
T05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFj
ayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQOiBTdGFydGluZyBM
aXN0ZW4gdGltZW91dCgwLDIwNDgwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNrClAy
UDogU2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAuMjI0ODAwIHNlYwpubDgwMjExOiBEcnYg
RXZlbnQgNTYgKE5MODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQg
Zm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNl
bD0xIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDFmZSAobWF0
Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSBy
ZWNlaXZlZApQMlA6IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdf
bGlzdGVuPTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlv
IHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMjA0Mjc3IHNlY29uZHMKUDJQ
OiBEcml2ZXIgZW5kZWQgTGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xp
c3RlbiBzaW5jZSBub3QgaW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9
U0VBUkNIKQpubDgwMjExOiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9
MHg4ODg4ODg4ODhhZTAwZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BT
IElFIGZvciBQcm9iZSBSZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQ
UzogICogUmVxdWVzdCBUeXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBV
VUlELUUKV1BTOiAgKiBQcmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQ
UzogICogQXNzb2NpYXRpb24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpX
UFM6ICAqIERldmljZSBQYXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICog
UDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExp
c3RlbiBDaGFubmVsOiBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4w
OiBBZGQgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJz
dCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRl
bHkKUDJQOiBSdW5uaW5nIHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdv
cmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMTAgc2Vjb25kIHdhaXQKcDJwLWRl
di13bGFuMDogbmw4MDIxMTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sg
U3VwcFJhdGVzClNjYW4gcmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25k
cwpubDgwMjExOiBEcnYgRXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2
ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2Vy
CnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYt
d2xhbjA6IE93biBzY2FuIHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAwMjIgc2Vjb25k
cwpwMnAtZGV2LXdsYW4wOiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2
ZW50IDM0IChOTDgwMjExX0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRl
di13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJs
ZQpubDgwMjExOiBTY2FuIHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBp
bmNsdWRlZCBmcmVxdWVuY2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQg
U0NBTl9SRVNVTFRTICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBp
biAwLjEyMDUwMyBzZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoMyBCU1Nl
cykKcDJwLWRldi13bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgOQpCU1M6IGxh
c3Rfc2Nhbl9yZXNfdXNlZD0yLzMyCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1zY2Fu
J0AweDI2ODg0ODAgZG9uZSBpbiAwLjEyMzQyNyBzZWNvbmRzClAyUDogU2NhbiByZXN1bHRzIHJl
Y2VpdmVkICgzIEJTUykKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJ
bmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2Fu
IGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNp
bmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IFByaW1hcnkg
RGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6
IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBD
YXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDEzIGxlbmd0aCAzMApQMlA6ICogRGV2aWNlIElu
Zm86IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6ZjIgcHJpbWFyeSBkZXZpY2UgdHlwZSAxMC0wMDUwRjIw
NC01IGRldmljZSBuYW1lICdkdmRocm0tbngnIGNvbmZpZyBtZXRob2RzIDB4MTg4ClAyUDogRG8g
bm90IHVwZGF0ZSBwZWVyIGVudHJ5IGJhc2VkIG9uIG9sZCBmcmFtZSAocnhfdGltZT01NDM5OTYu
MDY1NTAxIGxhc3Rfc2Vlbj01NDM5OTYuMDY1NjI1KQpQMlA6IFN0YXRlIFNFQVJDSCAtPiBTRUFS
Q0gKUDJQOiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkKV1BTOiAg
KiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBo
ZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5m
bwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwCnAy
cC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVs
ZSBzdGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdw
MnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTIgc2Vjb25kIHdhaXQKbmw4MDIxMTog
RW5hYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5sODAyMTE6
IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNoPQpubDgw
MjExOiBSZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgxZmYgZm9yIGZyZXE9MjQzNyBNSHogZHVy
YXRpb249MjA0Cm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09OX0NI
QU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFu
bmVsIGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MjA0
IGNvb2tpZT0weDFmZiAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05fQ0hB
Tk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAod2l0
aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0ZW4g
dGltZW91dCgwLDIwNDgwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDogU2V0
IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAuMjI0ODAwIHNlYwpubDgwMjExOiBEcnYgRXZlbnQg
NTYgKE5MODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAy
cC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0xIGZy
ZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDFmZiAobWF0Y2gpKQpw
MnAtZGV2LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNlaXZl
ZApQMlA6IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlzdGVu
PTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsg
J3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMjA0MjA5IHNlY29uZHMKUDJQOiBEcml2
ZXIgZW5kZWQgTGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3RlbiBz
aW5jZSBub3QgaW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9U0VBUkNI
KQpubDgwMjExOiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHg4ODg4
ODg4ODhhZTAwZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BTIElFIGZv
ciBQcm9iZSBSZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICog
UmVxdWVzdCBUeXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBVVUlELUUK
V1BTOiAgKiBQcmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQUzogICog
QXNzb2NpYXRpb24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpXUFM6ICAq
IERldmljZSBQYXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICogUDJQIElF
IGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExpc3RlbiBD
aGFubmVsOiBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4wOiBBZGQg
cmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRp
byB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKUDJQ
OiBSdW5uaW5nIHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3Ay
cC1zY2FuJ0AweDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMDkgc2Vjb25kIHdhaXQKcDJwLWRldi13bGFu
MDogbmw4MDIxMTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sgU3VwcFJh
dGVzClNjYW4gcmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25kcwpubDgw
MjExOiBEcnYgRXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2ZWQgZm9y
IHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2VyCnAycC1k
ZXYtd2xhbjA6IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6
IE93biBzY2FuIHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAwMzIgc2Vjb25kcwpwMnAt
ZGV2LXdsYW4wOiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2ZW50IDM0
IChOTDgwMjExX0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFu
MApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJsZQpubDgw
MjExOiBTY2FuIHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBpbmNsdWRl
ZCBmcmVxdWVuY2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9S
RVNVTFRTICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAwLjEy
MDUyNyBzZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoMyBCU1NlcykKcDJw
LWRldi13bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgMTAKQlNTOiBsYXN0X3Nj
YW5fcmVzX3VzZWQ9Mi8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidAMHgy
Njg4NDgwIGRvbmUgaW4gMC4xMjM0MzIgc2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNlaXZl
ZCAoMyBCU1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBv
ciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRh
IHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQ
UyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBQcmltYXJ5IERldmlj
ZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRy
aWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJp
bGl0eSAwMApQMlA6IEF0dHJpYnV0ZSAxMyBsZW5ndGggMzAKUDJQOiAqIERldmljZSBJbmZvOiBh
ZGRyIDEyOjY4OjNmOjRlOjM5OmYyIHByaW1hcnkgZGV2aWNlIHR5cGUgMTAtMDA1MEYyMDQtNSBk
ZXZpY2UgbmFtZSAnZHZkaHJtLW54JyBjb25maWcgbWV0aG9kcyAweDE4OApQMlA6IERvIG5vdCB1
cGRhdGUgcGVlciBlbnRyeSBiYXNlZCBvbiBvbGQgZnJhbWUgKHJ4X3RpbWU9NTQzOTk2LjA2NTMw
MyBsYXN0X3NlZW49NTQzOTk2LjA2NTYyNSkKUDJQOiBTdGF0ZSBTRUFSQ0ggLT4gU0VBUkNIClAy
UDogU3RhcnRpbmcgc2hvcnQgbGlzdGVuIHN0YXRlIChzdGF0ZT1TRUFSQ0gpCldQUzogICogVmVy
c2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVy
ClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8KcDJw
LWRldi13bGFuMDogQWRkIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MApwMnAtZGV2
LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3Rh
cnQgaW1tZWRpYXRlbHkKcDJwLWRldi13bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAncDJwLWxp
c3RlbidAMHgyNjg0NDYwIGFmdGVyIDAuMDAwMDExIHNlY29uZCB3YWl0Cm5sODAyMTE6IEVuYWJs
ZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBubF9wcmVxPTB4MjY4ODUwMApubDgwMjExOiBSZWdp
c3RlciBmcmFtZSB0eXBlPTB4NDAgbmxfaGFuZGxlPTB4MjY4ODUwMCBtYXRjaD0Kbmw4MDIxMTog
UmVtYWluLW9uLWNoYW5uZWwgY29va2llIDB4MjAwIGZvciBmcmVxPTI0MzcgTUh6IGR1cmF0aW9u
PTMwNwpubDgwMjExOiBEcnYgRXZlbnQgNTUgKE5MODAyMTFfQ01EX1JFTUFJTl9PTl9DSEFOTkVM
KSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBl
dmVudCAoY2FuY2VsPTAgZnJlcT0yNDM3IGNoYW5uZWxfdHlwZT0wIGR1cmF0aW9uPTMwNyBjb29r
aWU9MHgyMDAgKG1hdGNoKSkKcDJwLWRldi13bGFuMDogRXZlbnQgUkVNQUlOX09OX0NIQU5ORUwg
KDIxKSByZWNlaXZlZApPZmYtY2hhbm5lbDogU2VuZCBBY3Rpb24gY2FsbGJhY2sgKHdpdGhvdXRf
cm9jPTAgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpClAyUDogU3RhcnRpbmcgTGlzdGVuIHRpbWVv
dXQoMCwzMDcyMDApIG9uIGZyZXE9MjQzNyBiYXNlZCBvbiBjYWxsYmFjawpQMlA6IFNldCB0aW1l
b3V0IChzdGF0ZT1TRUFSQ0gpOiAwLjMyNzIwMCBzZWMKbmw4MDIxMTogQlNTIEV2ZW50IDU5IChO
TDgwMjExX0NNRF9GUkFNRSkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUlgg
ZnJhbWUgZnJlcT0yNDM3IHNzaV9zaWduYWw9LTI4IHN0eXBlPTQgbGVuPTIxNwpwMnAtZGV2LXds
YW4wOiBFdmVudCBSWF9NR01UICgyMCkgcmVjZWl2ZWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6
IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAK
UDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2lu
ZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxp
dHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDog
KiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENo
YW5uZWwgTnVtYmVyIDYKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChX
UFMpOiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmlj
ZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRy
aWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJp
bGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDog
Q291bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQ
OiBSZXBseSB0byBQMlAgUHJvYmUgUmVxdWVzdCBpbiBMaXN0ZW4gc3RhdGUKV1BTOiAgKiBWZXJz
aW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIK
UDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpubDgw
MjExOiBzZW5kX21sbWUgLSBub2Fjaz0xIGZyZXE9MCBub19jY2s9MCBvZmZjaGFub2s9MCB3YWl0
X3RpbWU9MCBmYz0weDUwIG5sbW9kZT0xMApubDgwMjExOiBVc2UgbGFzdF9tZ210X2ZyZXE9MjQz
NwpubDgwMjExOiBCU1MgRXZlbnQgNTkgKE5MODAyMTFfQ01EX0ZSQU1FKSByZWNlaXZlZCBmb3Ig
cDJwLWRldi13bGFuMApubDgwMjExOiBSWCBmcmFtZSBmcmVxPTI0Mzcgc3NpX3NpZ25hbD0tMjgg
c3R5cGU9NCBsZW49MjE3CnAycC1kZXYtd2xhbjA6IEV2ZW50IFJYX01HTVQgKDIwKSByZWNlaXZl
ZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQ
MlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6
IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0
aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDog
QXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4
MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFBhcnNpbmcgV1BT
IElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29y
ZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQ
OiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2Ug
Q2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3Ro
IDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xh
c3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFJlcGx5IHRvIFAyUCBQcm9iZSBSZXF1ZXN0IGlu
IExpc3RlbiBzdGF0ZQpXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVV
SUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9
MDAKUDJQOiAqIERldmljZSBJbmZvCm5sODAyMTE6IHNlbmRfbWxtZSAtIG5vYWNrPTEgZnJlcT0w
IG5vX2Njaz0wIG9mZmNoYW5vaz0wIHdhaXRfdGltZT0wIGZjPTB4NTAgbmxtb2RlPTEwCm5sODAy
MTE6IFVzZSBsYXN0X21nbXRfZnJlcT0yNDM3Cm5sODAyMTE6IEJTUyBFdmVudCA1OSAoTkw4MDIx
MV9DTURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJYIGZyYW1l
IGZyZXE9MjQzNyBzc2lfc2lnbmFsPS0yOCBzdHlwZT00IGxlbj0yMTcKcDJwLWRldi13bGFuMDog
RXZlbnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25m
aWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDog
UHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQ
IElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1
IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlz
dGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVs
IE51bWJlciA2ClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTog
MHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlw
ZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRl
IDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkg
MDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50
cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUmVw
bHkgdG8gUDJQIFByb2JlIFJlcXVlc3QgaW4gTGlzdGVuIHN0YXRlCldQUzogICogVmVyc2lvbiAo
aGFyZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDog
KiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8Kbmw4MDIxMTog
c2VuZF9tbG1lIC0gbm9hY2s9MSBmcmVxPTAgbm9fY2NrPTAgb2ZmY2hhbm9rPTAgd2FpdF90aW1l
PTAgZmM9MHg1MCBubG1vZGU9MTAKbmw4MDIxMTogVXNlIGxhc3RfbWdtdF9mcmVxPTI0MzcKbmw4
MDIxMTogQlNTIEV2ZW50IDU5IChOTDgwMjExX0NNRF9GUkFNRSkgcmVjZWl2ZWQgZm9yIHAycC1k
ZXYtd2xhbjAKbmw4MDIxMTogUlggZnJhbWUgZnJlcT0yNDM3IHNzaV9zaWduYWw9LTI4IHN0eXBl
PTQgbGVuPTIxNwpwMnAtZGV2LXdsYW4wOiBFdmVudCBSWF9NR01UICgyMCkgcmVjZWl2ZWQKUDJQ
OiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBE
ZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0w
MDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQ
MlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJp
YnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBS
ZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBQYXJzaW5nIFdQUyBJRQpQ
MlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6
IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFy
c2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFi
aWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAy
UDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgx
IENoYW5uZWwgTnVtYmVyIDYKUDJQOiBSZXBseSB0byBQMlAgUHJvYmUgUmVxdWVzdCBpbiBMaXN0
ZW4gc3RhdGUKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUK
UDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAy
UDogKiBEZXZpY2UgSW5mbwpubDgwMjExOiBzZW5kX21sbWUgLSBub2Fjaz0xIGZyZXE9MCBub19j
Y2s9MCBvZmZjaGFub2s9MCB3YWl0X3RpbWU9MCBmYz0weDUwIG5sbW9kZT0xMApubDgwMjExOiBV
c2UgbGFzdF9tZ210X2ZyZXE9MjQzNwpubDgwMjExOiBEcnYgRXZlbnQgNTYgKE5MODAyMTFfQ01E
X0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4
MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0xIGZyZXE9MjQzNyBjaGFubmVs
X3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIwMCAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBF
dmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNlaXZlZApQMlA6IENhbmNlbCBy
ZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlzdGVuPTAgbXMgcGVuZGluZ19h
Y3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4
MjY4NDQ2MCBkb25lIGluIDAuMzA2NjE3IHNlY29uZHMKUDJQOiBEcml2ZXIgZW5kZWQgTGlzdGVu
IHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3RlbiBzaW5jZSBub3QgaW4gbGlz
dGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9U0VBUkNIKQpubDgwMjExOiBEaXNh
YmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHg4ODg4ODg4ODhhZTAwZDg5ClAy
UDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BTIElFIGZvciBQcm9iZSBSZXF1ZXN0
CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogUmVxdWVzdCBUeXBlCldQ
UzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBVVUlELUUKV1BTOiAgKiBQcmltYXJ5
IERldmljZSBUeXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQUzogICogQXNzb2NpYXRpb24gU3Rh
dGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpXUFM6ICAqIERldmljZSBQYXNzd29y
ZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICog
Q2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBSZWd1bGF0
b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJw
LXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4g
dGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKUDJQOiBSdW5uaW5nIHAycF9z
Y2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0
ODAgYWZ0ZXIgMC4wMDAwMDkgc2Vjb25kIHdhaXQKcDJwLWRldi13bGFuMDogbmw4MDIxMTogc2Nh
biByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sgU3VwcFJhdGVzClNjYW4gcmVxdWVz
dGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25kcwpubDgwMjExOiBEcnYgRXZlbnQg
MzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAK
cDJwLWRldi13bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2VyCnAycC1kZXYtd2xhbjA6IEV2ZW50
IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IE93biBzY2FuIHJlcXVl
c3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAwNDcgc2Vjb25kcwpwMnAtZGV2LXdsYW4wOiBDVFJM
LUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2ZW50IDM0IChOTDgwMjExX0NNRF9O
RVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4w
OiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJsZQpubDgwMjExOiBTY2FuIHByb2Jl
ZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBpbmNsdWRlZCBmcmVxdWVuY2llczog
MjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9SRVNVTFRTICgzKSByZWNl
aXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAwLjEyMDUwMyBzZWNvbmRzCm5s
ODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoNCBCU1NlcykKcDJwLWRldi13bGFuMDogQlNT
OiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgMTEKcDJwLWRldi13bGFuMDogQlNTOiBBZGQgbmV3
IGlkIDIgQlNTSUQgMTA6ZmU6ZWQ6NTY6NzY6OWMgU1NJRCAnd2xhbi1uJwpCU1M6IGxhc3Rfc2Nh
bl9yZXNfdXNlZD0zLzMyCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2
ODg0ODAgZG9uZSBpbiAwLjEyMzUwMSBzZWNvbmRzClAyUDogU2NhbiByZXN1bHRzIHJlY2VpdmVk
ICg0IEJTUykKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9y
IFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEg
d2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BT
IElFClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAg
RGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTog
MHg0Mzg4ClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6
IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBD
YXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgMTMgbGVuZ3Ro
IDMwClAyUDogKiBEZXZpY2UgSW5mbzogYWRkciAxMjo2ODozZjo0ZTozOTpmMiBwcmltYXJ5IGRl
dmljZSB0eXBlIDEwLTAwNTBGMjA0LTUgZGV2aWNlIG5hbWUgJ2R2ZGhybS1ueCcgY29uZmlnIG1l
dGhvZHMgMHgxODgKUDJQOiBTdGF0ZSBTRUFSQ0ggLT4gU0VBUkNIClAyUDogU3RhcnRpbmcgc2hv
cnQgbGlzdGVuIHN0YXRlIChzdGF0ZT1TRUFSQ0gpCldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVk
IDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmls
aXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8KcDJwLWRldi13bGFuMDogQWRk
IHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MApwMnAtZGV2LXdsYW4wOiBGaXJzdCBy
YWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkK
cDJwLWRldi13bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYw
IGFmdGVyIDAuMDAwMDEyIHNlY29uZCB3YWl0Cm5sODAyMTE6IEVuYWJsZSBQcm9iZSBSZXF1ZXN0
IHJlcG9ydGluZyBubF9wcmVxPTB4MjY4ODUwMApubDgwMjExOiBSZWdpc3RlciBmcmFtZSB0eXBl
PTB4NDAgbmxfaGFuZGxlPTB4MjY4ODUwMCBtYXRjaD0Kbmw4MDIxMTogUmVtYWluLW9uLWNoYW5u
ZWwgY29va2llIDB4MjAxIGZvciBmcmVxPTI0MzcgTUh6IGR1cmF0aW9uPTMwNwpubDgwMjExOiBE
cnYgRXZlbnQgNTUgKE5MODAyMTFfQ01EX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3Ig
cDJwLWRldi13bGFuMApubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTAg
ZnJlcT0yNDM3IGNoYW5uZWxfdHlwZT0wIGR1cmF0aW9uPTMwNyBjb29raWU9MHgyMDEgKG1hdGNo
KSkKcDJwLWRldi13bGFuMDogRXZlbnQgUkVNQUlOX09OX0NIQU5ORUwgKDIxKSByZWNlaXZlZApP
ZmYtY2hhbm5lbDogU2VuZCBBY3Rpb24gY2FsbGJhY2sgKHdpdGhvdXRfcm9jPTAgcGVuZGluZ19h
Y3Rpb25fdHg9KG5pbCkpClAyUDogU3RhcnRpbmcgTGlzdGVuIHRpbWVvdXQoMCwzMDcyMDApIG9u
IGZyZXE9MjQzNyBiYXNlZCBvbiBjYWxsYmFjawpQMlA6IFNldCB0aW1lb3V0IChzdGF0ZT1TRUFS
Q0gpOiAwLjMyNzIwMCBzZWMKbmw4MDIxMTogRHJ2IEV2ZW50IDU2IChOTDgwMjExX0NNRF9DQU5D
RUxfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6
IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MSBmcmVxPTI0MzcgY2hhbm5lbF90eXBl
PTAgZHVyYXRpb249MCBjb29raWU9MHgyMDEgKG1hdGNoKSkKcDJwLWRldi13bGFuMDogRXZlbnQg
Q0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMICgyMikgcmVjZWl2ZWQKUDJQOiBDYW5jZWwgcmVtYWlu
LW9uLWNoYW5uZWwgY2FsbGJhY2sgKHAycF9sb25nX2xpc3Rlbj0wIG1zIHBlbmRpbmdfYWN0aW9u
X3R4PShuaWwpKQpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0
NjAgZG9uZSBpbiAwLjMwNjY2MCBzZWNvbmRzClAyUDogRHJpdmVyIGVuZGVkIExpc3RlbiBzdGF0
ZSAoZnJlcT0yNDM3KQpQMlA6IFNraXAgc3RvcF9saXN0ZW4gc2luY2Ugbm90IGluIGxpc3Rlbl9v
bmx5IHN0YXRlLgpQMlA6IFRpbWVvdXQgKHN0YXRlPVNFQVJDSCkKbmw4MDIxMTogRGlzYWJsZSBQ
cm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBubF9wcmVxPTB4ODg4ODg4ODg4YWUwMGQ4OQpQMlA6IFN0
YXJ0aW5nIHNlYXJjaApXUFM6IEJ1aWxkaW5nIFdQUyBJRSBmb3IgUHJvYmUgUmVxdWVzdApXUFM6
ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFJlcXVlc3QgVHlwZQpXUFM6ICAq
IENvbmZpZyBNZXRob2RzICgxNDgpCldQUzogICogVVVJRC1FCldQUzogICogUHJpbWFyeSBEZXZp
Y2UgVHlwZQpXUFM6ICAqIFJGIEJhbmRzICgzKQpXUFM6ICAqIEFzc29jaWF0aW9uIFN0YXRlCldQ
UzogICogQ29uZmlndXJhdGlvbiBFcnJvciAoMCkKV1BTOiAgKiBEZXZpY2UgUGFzc3dvcmQgSUQg
KDApCldQUzogICogRGV2aWNlIE5hbWUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFi
aWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogUmVndWxhdG9yeSBD
bGFzcyA4MSBDaGFubmVsIDYKcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdvcmsgJ3AycC1zY2Fu
J0AweDI2ODg0ODAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBx
dWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5ClAyUDogUnVubmluZyBwMnBfc2Nhbgpw
MnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGFm
dGVyIDAuMDAwMDA5IHNlY29uZCB3YWl0CnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IHNjYW4gcmVx
dWVzdApubDgwMjExOiBQMlAgcHJvYmUgLSBtYXNrIFN1cHBSYXRlcwpTY2FuIHJlcXVlc3RlZCAo
cmV0PTApIC0gc2NhbiB0aW1lb3V0IDMwIHNlY29uZHMKbmw4MDIxMTogRHJ2IEV2ZW50IDMzIChO
TDgwMjExX0NNRF9UUklHR0VSX1NDQU4pIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1k
ZXYtd2xhbjA6IG5sODAyMTE6IFNjYW4gdHJpZ2dlcgpwMnAtZGV2LXdsYW4wOiBFdmVudCBTQ0FO
X1NUQVJURUQgKDQ5KSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBPd24gc2NhbiByZXF1ZXN0IHN0
YXJ0ZWQgYSBzY2FuIGluIDAuMDAwMDIwIHNlY29uZHMKcDJwLWRldi13bGFuMDogQ1RSTC1FVkVO
VC1TQ0FOLVNUQVJURUQgCm5sODAyMTE6IERydiBFdmVudCAzNCAoTkw4MDIxMV9DTURfTkVXX1ND
QU5fUkVTVUxUUykgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4
MDIxMTogTmV3IHNjYW4gcmVzdWx0cyBhdmFpbGFibGUKbmw4MDIxMTogU2NhbiBwcm9iZWQgZm9y
IFNTSUQgJ0RJUkVDVC0nCm5sODAyMTE6IFNjYW4gaW5jbHVkZWQgZnJlcXVlbmNpZXM6IDI0MTIg
MjQzNyAyNDYyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fUkVTVUxUUyAoMykgcmVjZWl2ZWQK
cDJwLWRldi13bGFuMDogU2NhbiBjb21wbGV0ZWQgaW4gMC4xMjA1NDEgc2Vjb25kcwpubDgwMjEx
OiBSZWNlaXZlZCBzY2FuIHJlc3VsdHMgKDQgQlNTZXMpCnAycC1kZXYtd2xhbjA6IEJTUzogU3Rh
cnQgc2NhbiByZXN1bHQgdXBkYXRlIDEyCkJTUzogbGFzdF9zY2FuX3Jlc191c2VkPTMvMzIKcDJw
LWRldi13bGFuMDogUmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MCBkb25lIGluIDAuMTIz
NDgyIHNlY29uZHMKUDJQOiBTY2FuIHJlc3VsdHMgcmVjZWl2ZWQgKDQgQlNTKQpQMlA6IElnbm9y
ZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6
IFBhcnNpbmcgV1BTIElFClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2Ug
SW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2Nh
biBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJz
aW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBQcmltYXJ5
IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQ
OiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAg
Q2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSAxMyBsZW5ndGggMzAKUDJQOiAqIERldmljZSBJ
bmZvOiBhZGRyIDEyOjY4OjNmOjRlOjM5OmYyIHByaW1hcnkgZGV2aWNlIHR5cGUgMTAtMDA1MEYy
MDQtNSBkZXZpY2UgbmFtZSAnZHZkaHJtLW54JyBjb25maWcgbWV0aG9kcyAweDE4OApQMlA6IFN0
YXRlIFNFQVJDSCAtPiBTRUFSQ0gKUDJQOiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0
YXRlPVNFQVJDSCkKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlE
LUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAw
ClAyUDogKiBEZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxp
c3RlbidAMHgyNjg0NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0
aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFy
dGluZyByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTIgc2Vj
b25kIHdhaXQKbmw4MDIxMTogRW5hYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9
MHgyNjg4NTAwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgy
Njg4NTAwIG1hdGNoPQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgyMDIgZm9y
IGZyZXE9MjQzNyBNSHogZHVyYXRpb249MjA0Cm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIx
MV9DTURfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAy
MTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90
eXBlPTAgZHVyYXRpb249MjA0IGNvb2tpZT0weDIwMiAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBF
dmVudCBSRU1BSU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFj
dGlvbiBjYWxsYmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQ
OiBTdGFydGluZyBMaXN0ZW4gdGltZW91dCgwLDIwNDgwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9u
IGNhbGxiYWNrClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAuMjI0ODAwIHNlYwpu
bDgwMjExOiBCU1MgRXZlbnQgNTkgKE5MODAyMTFfQ01EX0ZSQU1FKSByZWNlaXZlZCBmb3IgcDJw
LWRldi13bGFuMApubDgwMjExOiBSWCBmcmFtZSBmcmVxPTI0Mzcgc3NpX3NpZ25hbD0tMjcgc3R5
cGU9NCBsZW49MjE3CnAycC1kZXYtd2xhbjA6IEV2ZW50IFJYX01HTVQgKDIwKSByZWNlaXZlZApQ
MlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6
IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEw
LTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAy
ClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0
cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQp
IFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFBhcnNpbmcgV1BTIElF
ClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJ
RDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQ
YXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2Fw
YWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUK
UDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3Mg
ODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFJlcGx5IHRvIFAyUCBQcm9iZSBSZXF1ZXN0IGluIExp
c3RlbiBzdGF0ZQpXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVVSUQt
RQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAK
UDJQOiAqIERldmljZSBJbmZvCm5sODAyMTE6IHNlbmRfbWxtZSAtIG5vYWNrPTEgZnJlcT0wIG5v
X2Njaz0wIG9mZmNoYW5vaz0wIHdhaXRfdGltZT0wIGZjPTB4NTAgbmxtb2RlPTEwCm5sODAyMTE6
IFVzZSBsYXN0X21nbXRfZnJlcT0yNDM3Cm5sODAyMTE6IEJTUyBFdmVudCA1OSAoTkw4MDIxMV9D
TURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJYIGZyYW1lIGZy
ZXE9MjQzNyBzc2lfc2lnbmFsPS0yOCBzdHlwZT00IGxlbj0yMTcKcDJwLWRldi13bGFuMDogRXZl
bnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcg
TWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJp
bWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElF
ClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdy
b3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVu
IENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51
bWJlciA2ClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0
Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAo
V1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIg
bGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAK
UDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkg
REUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUmVwbHkg
dG8gUDJQIFByb2JlIFJlcXVlc3QgaW4gTGlzdGVuIHN0YXRlCldQUzogICogVmVyc2lvbiAoaGFy
ZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBD
YXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8Kbmw4MDIxMTogc2Vu
ZF9tbG1lIC0gbm9hY2s9MSBmcmVxPTAgbm9fY2NrPTAgb2ZmY2hhbm9rPTAgd2FpdF90aW1lPTAg
ZmM9MHg1MCBubG1vZGU9MTAKbmw4MDIxMTogVXNlIGxhc3RfbWdtdF9mcmVxPTI0MzcKbmw4MDIx
MTogQlNTIEV2ZW50IDU5IChOTDgwMjExX0NNRF9GUkFNRSkgcmVjZWl2ZWQgZm9yIHAycC1kZXYt
d2xhbjAKbmw4MDIxMTogUlggZnJhbWUgZnJlcT0yNDM3IHNzaV9zaWduYWw9LTI3IHN0eXBlPTQg
bGVuPTIxNwpwMnAtZGV2LXdsYW4wOiBFdmVudCBSWF9NR01UICgyMCkgcmVjZWl2ZWQKUDJQOiBQ
YXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZp
Y2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUw
RjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6
ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0
ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1
bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6
IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAK
UDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2lu
ZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxp
dHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDog
KiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENo
YW5uZWwgTnVtYmVyIDYKUDJQOiBSZXBseSB0byBQMlAgUHJvYmUgUmVxdWVzdCBpbiBMaXN0ZW4g
c3RhdGUKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQ
OiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDog
KiBEZXZpY2UgSW5mbwpubDgwMjExOiBzZW5kX21sbWUgLSBub2Fjaz0xIGZyZXE9MCBub19jY2s9
MCBvZmZjaGFub2s9MCB3YWl0X3RpbWU9MCBmYz0weDUwIG5sbW9kZT0xMApubDgwMjExOiBVc2Ug
bGFzdF9tZ210X2ZyZXE9MjQzNwpubDgwMjExOiBCU1MgRXZlbnQgNTkgKE5MODAyMTFfQ01EX0ZS
QU1FKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSWCBmcmFtZSBmcmVxPTI0
Mzcgc3NpX3NpZ25hbD0tMjggc3R5cGU9NCBsZW49MjE3CnAycC1kZXYtd2xhbjA6IEV2ZW50IFJY
X01HTVQgKDIwKSByZWNlaXZlZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhv
ZHMgKFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkg
RGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6
IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBD
YXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFu
bmVsOiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIg
NgpQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQ
MlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6
IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0
aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDog
QXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4
MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFJlcGx5IHRvIFAy
UCBQcm9iZSBSZXF1ZXN0IGluIExpc3RlbiBzdGF0ZQpXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2Rl
ZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJp
bGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCm5sODAyMTE6IHNlbmRfbWxt
ZSAtIG5vYWNrPTEgZnJlcT0wIG5vX2Njaz0wIG9mZmNoYW5vaz0wIHdhaXRfdGltZT0wIGZjPTB4
NTAgbmxtb2RlPTEwCm5sODAyMTE6IFVzZSBsYXN0X21nbXRfZnJlcT0yNDM3Cm5sODAyMTE6IEJT
UyBFdmVudCA1OSAoTkw4MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4w
Cm5sODAyMTE6IFJYIGZyYW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFsPS0yOCBzdHlwZT00IGxlbj0y
MTcKcDJwLWRldi13bGFuMDogRXZlbnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkClAyUDogUGFyc2lu
ZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBh
c3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQt
NQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERl
dmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBs
ZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9y
eSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25m
aWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDog
UHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQ
IElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1
IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlz
dGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVs
IE51bWJlciA2ClAyUDogUmVwbHkgdG8gUDJQIFByb2JlIFJlcXVlc3QgaW4gTGlzdGVuIHN0YXRl
CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQ
MlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2
aWNlIEluZm8Kbmw4MDIxMTogc2VuZF9tbG1lIC0gbm9hY2s9MSBmcmVxPTAgbm9fY2NrPTAgb2Zm
Y2hhbm9rPTAgd2FpdF90aW1lPTAgZmM9MHg1MCBubG1vZGU9MTAKbmw4MDIxMTogVXNlIGxhc3Rf
bWdtdF9mcmVxPTI0MzcKbmw4MDIxMTogRHJ2IEV2ZW50IDU2IChOTDgwMjExX0NNRF9DQU5DRUxf
UkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJl
bWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MSBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAg
ZHVyYXRpb249MCBjb29raWU9MHgyMDIgKG1hdGNoKSkKcDJwLWRldi13bGFuMDogRXZlbnQgQ0FO
Q0VMX1JFTUFJTl9PTl9DSEFOTkVMICgyMikgcmVjZWl2ZWQKUDJQOiBDYW5jZWwgcmVtYWluLW9u
LWNoYW5uZWwgY2FsbGJhY2sgKHAycF9sb25nX2xpc3Rlbj0wIG1zIHBlbmRpbmdfYWN0aW9uX3R4
PShuaWwpKQpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAg
ZG9uZSBpbiAwLjIwNDI5OCBzZWNvbmRzClAyUDogRHJpdmVyIGVuZGVkIExpc3RlbiBzdGF0ZSAo
ZnJlcT0yNDM3KQpQMlA6IFNraXAgc3RvcF9saXN0ZW4gc2luY2Ugbm90IGluIGxpc3Rlbl9vbmx5
IHN0YXRlLgpQMlA6IFRpbWVvdXQgKHN0YXRlPVNFQVJDSCkKbmw4MDIxMTogRGlzYWJsZSBQcm9i
ZSBSZXF1ZXN0IHJlcG9ydGluZyBubF9wcmVxPTB4ODg4ODg4ODg4YWUwMGQ4OQpQMlA6IFN0YXJ0
aW5nIHNlYXJjaApXUFM6IEJ1aWxkaW5nIFdQUyBJRSBmb3IgUHJvYmUgUmVxdWVzdApXUFM6ICAq
IFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFJlcXVlc3QgVHlwZQpXUFM6ICAqIENv
bmZpZyBNZXRob2RzICgxNDgpCldQUzogICogVVVJRC1FCldQUzogICogUHJpbWFyeSBEZXZpY2Ug
VHlwZQpXUFM6ICAqIFJGIEJhbmRzICgzKQpXUFM6ICAqIEFzc29jaWF0aW9uIFN0YXRlCldQUzog
ICogQ29uZmlndXJhdGlvbiBFcnJvciAoMCkKV1BTOiAgKiBEZXZpY2UgUGFzc3dvcmQgSUQgKDAp
CldQUzogICogRGV2aWNlIE5hbWUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxp
dHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogUmVndWxhdG9yeSBDbGFz
cyA4MSBDaGFubmVsIDYKcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0Aw
eDI2ODg0ODAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBxdWV1
ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5ClAyUDogUnVubmluZyBwMnBfc2NhbgpwMnAt
ZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGFmdGVy
IDAuMDAwMDExIHNlY29uZCB3YWl0CnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IHNjYW4gcmVxdWVz
dApubDgwMjExOiBQMlAgcHJvYmUgLSBtYXNrIFN1cHBSYXRlcwpTY2FuIHJlcXVlc3RlZCAocmV0
PTApIC0gc2NhbiB0aW1lb3V0IDMwIHNlY29uZHMKbmw4MDIxMTogRHJ2IEV2ZW50IDMzIChOTDgw
MjExX0NNRF9UUklHR0VSX1NDQU4pIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1kZXYt
d2xhbjA6IG5sODAyMTE6IFNjYW4gdHJpZ2dlcgpwMnAtZGV2LXdsYW4wOiBFdmVudCBTQ0FOX1NU
QVJURUQgKDQ5KSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBPd24gc2NhbiByZXF1ZXN0IHN0YXJ0
ZWQgYSBzY2FuIGluIDAuMDAwMDI5IHNlY29uZHMKcDJwLWRldi13bGFuMDogQ1RSTC1FVkVOVC1T
Q0FOLVNUQVJURUQgCm5sODAyMTE6IERydiBFdmVudCAzNCAoTkw4MDIxMV9DTURfTkVXX1NDQU5f
UkVTVUxUUykgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIx
MTogTmV3IHNjYW4gcmVzdWx0cyBhdmFpbGFibGUKbmw4MDIxMTogU2NhbiBwcm9iZWQgZm9yIFNT
SUQgJ0RJUkVDVC0nCm5sODAyMTE6IFNjYW4gaW5jbHVkZWQgZnJlcXVlbmNpZXM6IDI0MTIgMjQz
NyAyNDYyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fUkVTVUxUUyAoMykgcmVjZWl2ZWQKcDJw
LWRldi13bGFuMDogU2NhbiBjb21wbGV0ZWQgaW4gMC4xMjA1MzEgc2Vjb25kcwpubDgwMjExOiBS
ZWNlaXZlZCBzY2FuIHJlc3VsdHMgKDQgQlNTZXMpCnAycC1kZXYtd2xhbjA6IEJTUzogU3RhcnQg
c2NhbiByZXN1bHQgdXBkYXRlIDEzCkJTUzogbGFzdF9zY2FuX3Jlc191c2VkPTMvMzIKcDJwLWRl
di13bGFuMDogUmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MCBkb25lIGluIDAuMTIzNjA5
IHNlY29uZHMKUDJQOiBTY2FuIHJlc3VsdHMgcmVjZWl2ZWQgKDQgQlNTKQpQMlA6IElnbm9yZSBz
Y2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBh
cnNpbmcgV1BTIElFClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5m
byBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBk
YXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5n
IFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBQcmltYXJ5IERl
dmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBB
dHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2Fw
YWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSAxMyBsZW5ndGggMzAKUDJQOiAqIERldmljZSBJbmZv
OiBhZGRyIDEyOjY4OjNmOjRlOjM5OmYyIHByaW1hcnkgZGV2aWNlIHR5cGUgMTAtMDA1MEYyMDQt
NSBkZXZpY2UgbmFtZSAnZHZkaHJtLW54JyBjb25maWcgbWV0aG9kcyAweDE4OApQMlA6IFN0YXRl
IFNFQVJDSCAtPiBTRUFSQ0gKUDJQOiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0YXRl
PVNFQVJDSCkKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUK
UDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAy
UDogKiBEZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxpc3Rl
bidAMHgyNjg0NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUg
cXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFydGlu
ZyByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTIgc2Vjb25k
IHdhaXQKbmw4MDIxMTogRW5hYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHgy
Njg4NTAwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgyNjg4
NTAwIG1hdGNoPQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgyMDMgZm9yIGZy
ZXE9MjQzNyBNSHogZHVyYXRpb249MTAyCm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIxMV9D
TURfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6
IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90eXBl
PTAgZHVyYXRpb249MTAyIGNvb2tpZT0weDIwMyAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVu
dCBSRU1BSU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFjdGlv
biBjYWxsYmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQOiBT
dGFydGluZyBMaXN0ZW4gdGltZW91dCgwLDEwMjQwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9uIGNh
bGxiYWNrClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAuMTIyNDAwIHNlYwpubDgw
MjExOiBEcnYgRXZlbnQgNTYgKE5MODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkg
cmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZl
bnQgKGNhbmNlbD0xIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0w
eDIwMyAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5O
RUwgKDIyKSByZWNlaXZlZApQMlA6IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAo
cDJwX2xvbmdfbGlzdGVuPTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xh
bjA6IFJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMTAxODMzIHNl
Y29uZHMKUDJQOiBEcml2ZXIgZW5kZWQgTGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tp
cCBzdG9wX2xpc3RlbiBzaW5jZSBub3QgaW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91
dCAoc3RhdGU9U0VBUkNIKQpubDgwMjExOiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5n
IG5sX3ByZXE9MHg4ODg4ODg4ODhhZTAwZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVp
bGRpbmcgV1BTIElFIGZvciBQcm9iZSBSZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVk
IDB4MTApCldQUzogICogUmVxdWVzdCBUeXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkK
V1BTOiAgKiBVVUlELUUKV1BTOiAgKiBQcmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYgQmFu
ZHMgKDMpCldQUzogICogQXNzb2NpYXRpb24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVy
cm9yICgwKQpXUFM6ICAqIERldmljZSBQYXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFt
ZQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAK
UDJQOiAqIExpc3RlbiBDaGFubmVsOiBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAt
ZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXds
YW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQg
aW1tZWRpYXRlbHkKUDJQOiBSdW5uaW5nIHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5n
IHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMTEgc2Vjb25kIHdh
aXQKcDJwLWRldi13bGFuMDogbmw4MDIxMTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9i
ZSAtIG1hc2sgU3VwcFJhdGVzClNjYW4gcmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQg
MzAgc2Vjb25kcwpubDgwMjExOiBEcnYgRXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NB
TikgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogU2Nh
biB0cmlnZ2VyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVk
CnAycC1kZXYtd2xhbjA6IE93biBzY2FuIHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAw
MjQgc2Vjb25kcwpwMnAtZGV2LXdsYW4wOiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIx
MTogRHJ2IEV2ZW50IDM0IChOTDgwMjExX0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBm
b3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRz
IGF2YWlsYWJsZQpubDgwMjExOiBTY2FuIHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIx
MTogU2NhbiBpbmNsdWRlZCBmcmVxdWVuY2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFu
MDogRXZlbnQgU0NBTl9SRVNVTFRTICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNv
bXBsZXRlZCBpbiAwLjEyMDQ4MiBzZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0
cyAoNCBCU1NlcykKcDJwLWRldi13bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUg
MTQKQlNTOiBsYXN0X3NjYW5fcmVzX3VzZWQ9My8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3Jr
ICdwMnAtc2NhbidAMHgyNjg4NDgwIGRvbmUgaW4gMC4xMjM0NTYgc2Vjb25kcwpQMlA6IFNjYW4g
cmVzdWx0cyByZWNlaXZlZCAoNCBCU1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAy
UCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJ
Z25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQK
UDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2
aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmln
IE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEw
LTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAy
ClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0
cmlidXRlIDEzIGxlbmd0aCAzMApQMlA6ICogRGV2aWNlIEluZm86IGFkZHIgMTI6Njg6M2Y6NGU6
Mzk6ZjIgcHJpbWFyeSBkZXZpY2UgdHlwZSAxMC0wMDUwRjIwNC01IGRldmljZSBuYW1lICdkdmRo
cm0tbngnIGNvbmZpZyBtZXRob2RzIDB4MTg4ClAyUDogRG8gbm90IHVwZGF0ZSBwZWVyIGVudHJ5
IGJhc2VkIG9uIG9sZCBmcmFtZSAocnhfdGltZT01NDM5OTguNzYyNTM5IGxhc3Rfc2Vlbj01NDM5
OTguNzYyOTgwKQpQMlA6IFN0YXRlIFNFQVJDSCAtPiBTRUFSQ0gKUDJQOiBTdGFydGluZyBzaG9y
dCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQg
MHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxp
dHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQg
cmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJh
ZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpw
MnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAg
YWZ0ZXIgMC4wMDAwMTMgc2Vjb25kIHdhaXQKbmw4MDIxMTogRW5hYmxlIFByb2JlIFJlcXVlc3Qg
cmVwb3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9
MHg0MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNoPQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5l
bCBjb29raWUgMHgyMDQgZm9yIGZyZXE9MjQzNyBNSHogZHVyYXRpb249MTAyCm5sODAyMTE6IERy
diBFdmVudCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBw
MnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBm
cmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MTAyIGNvb2tpZT0weDIwNCAobWF0Y2gp
KQpwMnAtZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9m
Zi1jaGFubmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2Fj
dGlvbl90eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0ZW4gdGltZW91dCgwLDEwMjQwMCkgb24g
ZnJlcT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJD
SCk6IDAuMTIyNDAwIHNlYwpubDgwMjExOiBEcnYgRXZlbnQgNTYgKE5MODAyMTFfQ01EX0NBTkNF
TF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTog
UmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0xIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9
MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIwNCAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBD
QU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNlaXZlZApQMlA6IENhbmNlbCByZW1haW4t
b24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlzdGVuPTAgbXMgcGVuZGluZ19hY3Rpb25f
dHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2
MCBkb25lIGluIDAuMTAxODU1IHNlY29uZHMKUDJQOiBEcml2ZXIgZW5kZWQgTGlzdGVuIHN0YXRl
IChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3RlbiBzaW5jZSBub3QgaW4gbGlzdGVuX29u
bHkgc3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9U0VBUkNIKQpubDgwMjExOiBEaXNhYmxlIFBy
b2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHg4ODg4ODg4ODhhZTAwZDg5ClAyUDogU3Rh
cnRpbmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BTIElFIGZvciBQcm9iZSBSZXF1ZXN0CldQUzog
ICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogUmVxdWVzdCBUeXBlCldQUzogICog
Q29uZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBVVUlELUUKV1BTOiAgKiBQcmltYXJ5IERldmlj
ZSBUeXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQUzogICogQXNzb2NpYXRpb24gU3RhdGUKV1BT
OiAgKiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpXUFM6ICAqIERldmljZSBQYXNzd29yZCBJRCAo
MCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJp
bGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBSZWd1bGF0b3J5IENs
YXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLXNjYW4n
QDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1
ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKUDJQOiBSdW5uaW5nIHAycF9zY2FuCnAy
cC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgYWZ0
ZXIgMC4wMDAwMTAgc2Vjb25kIHdhaXQKcDJwLWRldi13bGFuMDogbmw4MDIxMTogc2NhbiByZXF1
ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sgU3VwcFJhdGVzClNjYW4gcmVxdWVzdGVkIChy
ZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25kcwpubDgwMjExOiBEcnYgRXZlbnQgMzMgKE5M
ODAyMTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRl
di13bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2VyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5f
U1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IE93biBzY2FuIHJlcXVlc3Qgc3Rh
cnRlZCBhIHNjYW4gaW4gMC4wMDAwMjQgc2Vjb25kcwpwMnAtZGV2LXdsYW4wOiBDVFJMLUVWRU5U
LVNDQU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2ZW50IDM0IChOTDgwMjExX0NNRF9ORVdfU0NB
Tl9SRVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgw
MjExOiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJsZQpubDgwMjExOiBTY2FuIHByb2JlZCBmb3Ig
U1NJRCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBpbmNsdWRlZCBmcmVxdWVuY2llczogMjQxMiAy
NDM3IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9SRVNVTFRTICgzKSByZWNlaXZlZApw
MnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAwLjEyMDUzMCBzZWNvbmRzCm5sODAyMTE6
IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoNCBCU1NlcykKcDJwLWRldi13bGFuMDogQlNTOiBTdGFy
dCBzY2FuIHJlc3VsdCB1cGRhdGUgMTUKQlNTOiBsYXN0X3NjYW5fcmVzX3VzZWQ9My8zMgpwMnAt
ZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGRvbmUgaW4gMC4xMjM1
MDMgc2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNlaXZlZCAoNCBCU1MpClAyUDogSWdub3Jl
IHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDog
UGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJ
bmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2Fu
IGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNp
bmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IFByaW1hcnkg
RGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6
IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBD
YXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDEzIGxlbmd0aCAzMApQMlA6ICogRGV2aWNlIElu
Zm86IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6ZjIgcHJpbWFyeSBkZXZpY2UgdHlwZSAxMC0wMDUwRjIw
NC01IGRldmljZSBuYW1lICdkdmRocm0tbngnIGNvbmZpZyBtZXRob2RzIDB4MTg4ClAyUDogRG8g
bm90IHVwZGF0ZSBwZWVyIGVudHJ5IGJhc2VkIG9uIG9sZCBmcmFtZSAocnhfdGltZT01NDM5OTgu
NzYyMTQ5IGxhc3Rfc2Vlbj01NDM5OTguNzYyOTgwKQpQMlA6IFN0YXRlIFNFQVJDSCAtPiBTRUFS
Q0gKUDJQOiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkKV1BTOiAg
KiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBo
ZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5m
bwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwCnAy
cC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVs
ZSBzdGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdw
MnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTIgc2Vjb25kIHdhaXQKbmw4MDIxMTog
RW5hYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5sODAyMTE6
IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNoPQpubDgw
MjExOiBSZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgyMDUgZm9yIGZyZXE9MjQzNyBNSHogZHVy
YXRpb249MjA0Cm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09OX0NI
QU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFu
bmVsIGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MjA0
IGNvb2tpZT0weDIwNSAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05fQ0hB
Tk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAod2l0
aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0ZW4g
dGltZW91dCgwLDIwNDgwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDogU2V0
IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAuMjI0ODAwIHNlYwpubDgwMjExOiBCU1MgRXZlbnQg
NTkgKE5MODAyMTFfQ01EX0ZSQU1FKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjEx
OiBSWCBmcmFtZSBmcmVxPTI0Mzcgc3NpX3NpZ25hbD0tMjYgc3R5cGU9NCBsZW49MjE3CnAycC1k
ZXYtd2xhbjA6IEV2ZW50IFJYX01HTVQgKDIwKSByZWNlaXZlZApQMlA6IFBhcnNpbmcgV1BTIElF
ClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJ
RDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQ
YXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2Fw
YWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUK
UDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3Mg
ODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhv
ZHMgKFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkg
RGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6
IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBD
YXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFu
bmVsOiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIg
NgpQMlA6IFJlcGx5IHRvIFAyUCBQcm9iZSBSZXF1ZXN0IGluIExpc3RlbiBzdGF0ZQpXUFM6ICAq
IFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhl
YWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZv
Cm5sODAyMTE6IHNlbmRfbWxtZSAtIG5vYWNrPTEgZnJlcT0wIG5vX2Njaz0wIG9mZmNoYW5vaz0w
IHdhaXRfdGltZT0wIGZjPTB4NTAgbmxtb2RlPTEwCm5sODAyMTE6IFVzZSBsYXN0X21nbXRfZnJl
cT0yNDM3Cm5sODAyMTE6IEJTUyBFdmVudCA1OSAoTkw4MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVk
IGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJYIGZyYW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFs
PS0yNiBzdHlwZT00IGxlbj0yMTcKcDJwLWRldi13bGFuMDogRXZlbnQgUlhfTUdNVCAoMjApIHJl
Y2VpdmVkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0
Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAo
V1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIg
bGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAK
UDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkg
REUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUGFyc2lu
ZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBh
c3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQt
NQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERl
dmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBs
ZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9y
eSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUmVwbHkgdG8gUDJQIFByb2JlIFJlcXVl
c3QgaW4gTGlzdGVuIHN0YXRlCldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzog
ICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBn
cm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8Kbmw4MDIxMTogc2VuZF9tbG1lIC0gbm9hY2s9MSBm
cmVxPTAgbm9fY2NrPTAgb2ZmY2hhbm9rPTAgd2FpdF90aW1lPTAgZmM9MHg1MCBubG1vZGU9MTAK
bmw4MDIxMTogVXNlIGxhc3RfbWdtdF9mcmVxPTI0MzcKbmw4MDIxMTogQlNTIEV2ZW50IDU5IChO
TDgwMjExX0NNRF9GUkFNRSkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUlgg
ZnJhbWUgZnJlcT0yNDM3IHNzaV9zaWduYWw9LTI2IHN0eXBlPTQgbGVuPTIxNwpwMnAtZGV2LXds
YW4wOiBFdmVudCBSWF9NR01UICgyMCkgcmVjZWl2ZWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6
IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAK
UDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2lu
ZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxp
dHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDog
KiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENo
YW5uZWwgTnVtYmVyIDYKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChX
UFMpOiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmlj
ZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRy
aWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJp
bGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDog
Q291bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQ
OiBSZXBseSB0byBQMlAgUHJvYmUgUmVxdWVzdCBpbiBMaXN0ZW4gc3RhdGUKV1BTOiAgKiBWZXJz
aW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIK
UDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpubDgw
MjExOiBzZW5kX21sbWUgLSBub2Fjaz0xIGZyZXE9MCBub19jY2s9MCBvZmZjaGFub2s9MCB3YWl0
X3RpbWU9MCBmYz0weDUwIG5sbW9kZT0xMApubDgwMjExOiBVc2UgbGFzdF9tZ210X2ZyZXE9MjQz
NwpubDgwMjExOiBCU1MgRXZlbnQgNTkgKE5MODAyMTFfQ01EX0ZSQU1FKSByZWNlaXZlZCBmb3Ig
cDJwLWRldi13bGFuMApubDgwMjExOiBSWCBmcmFtZSBmcmVxPTI0Mzcgc3NpX3NpZ25hbD0tMjYg
c3R5cGU9NCBsZW49MjE3CnAycC1kZXYtd2xhbjA6IEV2ZW50IFJYX01HTVQgKDIwKSByZWNlaXZl
ZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQ
MlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6
IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0
aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDog
QXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4
MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFBhcnNpbmcgV1BT
IElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29y
ZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQ
OiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2Ug
Q2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3Ro
IDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xh
c3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFJlcGx5IHRvIFAyUCBQcm9iZSBSZXF1ZXN0IGlu
IExpc3RlbiBzdGF0ZQpXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVV
SUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9
MDAKUDJQOiAqIERldmljZSBJbmZvCm5sODAyMTE6IHNlbmRfbWxtZSAtIG5vYWNrPTEgZnJlcT0w
IG5vX2Njaz0wIG9mZmNoYW5vaz0wIHdhaXRfdGltZT0wIGZjPTB4NTAgbmxtb2RlPTEwCm5sODAy
MTE6IFVzZSBsYXN0X21nbXRfZnJlcT0yNDM3Cm5sODAyMTE6IERydiBFdmVudCA1NiAoTkw4MDIx
MV9DTURfQ0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFu
MApubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTEgZnJlcT0yNDM3IGNo
YW5uZWxfdHlwZT0wIGR1cmF0aW9uPTAgY29va2llPTB4MjA1IChtYXRjaCkpCnAycC1kZXYtd2xh
bjA6IEV2ZW50IENBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCAoMjIpIHJlY2VpdmVkClAyUDogQ2Fu
Y2VsIHJlbWFpbi1vbi1jaGFubmVsIGNhbGxiYWNrIChwMnBfbG9uZ19saXN0ZW49MCBtcyBwZW5k
aW5nX2FjdGlvbl90eD0obmlsKSkKcDJwLWRldi13bGFuMDogUmFkaW8gd29yayAncDJwLWxpc3Rl
bidAMHgyNjg0NDYwIGRvbmUgaW4gMC4yMDU1MDQgc2Vjb25kcwpQMlA6IERyaXZlciBlbmRlZCBM
aXN0ZW4gc3RhdGUgKGZyZXE9MjQzNykKUDJQOiBTa2lwIHN0b3BfbGlzdGVuIHNpbmNlIG5vdCBp
biBsaXN0ZW5fb25seSBzdGF0ZS4KUDJQOiBUaW1lb3V0IChzdGF0ZT1TRUFSQ0gpCm5sODAyMTE6
IERpc2FibGUgUHJvYmUgUmVxdWVzdCByZXBvcnRpbmcgbmxfcHJlcT0weDg4ODg4ODg4OGFlMDBk
ODkKUDJQOiBTdGFydGluZyBzZWFyY2gKV1BTOiBCdWlsZGluZyBXUFMgSUUgZm9yIFByb2JlIFJl
cXVlc3QKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBSZXF1ZXN0IFR5
cGUKV1BTOiAgKiBDb25maWcgTWV0aG9kcyAoMTQ4KQpXUFM6ICAqIFVVSUQtRQpXUFM6ICAqIFBy
aW1hcnkgRGV2aWNlIFR5cGUKV1BTOiAgKiBSRiBCYW5kcyAoMykKV1BTOiAgKiBBc3NvY2lhdGlv
biBTdGF0ZQpXUFM6ICAqIENvbmZpZ3VyYXRpb24gRXJyb3IgKDApCldQUzogICogRGV2aWNlIFBh
c3N3b3JkIElEICgwKQpXUFM6ICAqIERldmljZSBOYW1lClAyUDogKiBQMlAgSUUgaGVhZGVyClAy
UDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogTGlzdGVuIENoYW5uZWw6IFJl
Z3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCA2CnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3Jr
ICdwMnAtc2NhbidAMHgyNjg4NDgwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRl
bSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpQMlA6IFJ1bm5pbmcg
cDJwX3NjYW4KcDJwLWRldi13bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4
MjY4ODQ4MCBhZnRlciAwLjAwMDAxMSBzZWNvbmQgd2FpdApwMnAtZGV2LXdsYW4wOiBubDgwMjEx
OiBzY2FuIHJlcXVlc3QKbmw4MDIxMTogUDJQIHByb2JlIC0gbWFzayBTdXBwUmF0ZXMKU2NhbiBy
ZXF1ZXN0ZWQgKHJldD0wKSAtIHNjYW4gdGltZW91dCAzMCBzZWNvbmRzCm5sODAyMTE6IERydiBF
dmVudCAzMyAoTkw4MDIxMV9DTURfVFJJR0dFUl9TQ0FOKSByZWNlaXZlZCBmb3IgcDJwLWRldi13
bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBTY2FuIHRyaWdnZXIKcDJwLWRldi13bGFuMDog
RXZlbnQgU0NBTl9TVEFSVEVEICg0OSkgcmVjZWl2ZWQKcDJwLWRldi13bGFuMDogT3duIHNjYW4g
cmVxdWVzdCBzdGFydGVkIGEgc2NhbiBpbiAwLjAwMDAyNCBzZWNvbmRzCnAycC1kZXYtd2xhbjA6
IENUUkwtRVZFTlQtU0NBTi1TVEFSVEVEIApubDgwMjExOiBEcnYgRXZlbnQgMzQgKE5MODAyMTFf
Q01EX05FV19TQ0FOX1JFU1VMVFMpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1kZXYt
d2xhbjA6IG5sODAyMTE6IE5ldyBzY2FuIHJlc3VsdHMgYXZhaWxhYmxlCm5sODAyMTE6IFNjYW4g
cHJvYmVkIGZvciBTU0lEICdESVJFQ1QtJwpubDgwMjExOiBTY2FuIGluY2x1ZGVkIGZyZXF1ZW5j
aWVzOiAyNDEyIDI0MzcgMjQ2MgpwMnAtZGV2LXdsYW4wOiBFdmVudCBTQ0FOX1JFU1VMVFMgKDMp
IHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IFNjYW4gY29tcGxldGVkIGluIDAuMTIwNDc5IHNlY29u
ZHMKbmw4MDIxMTogUmVjZWl2ZWQgc2NhbiByZXN1bHRzICg0IEJTU2VzKQpwMnAtZGV2LXdsYW4w
OiBCU1M6IFN0YXJ0IHNjYW4gcmVzdWx0IHVwZGF0ZSAxNgpCU1M6IGxhc3Rfc2Nhbl9yZXNfdXNl
ZD0zLzMyCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgZG9u
ZSBpbiAwLjEyMzQ1MCBzZWNvbmRzClAyUDogU2NhbiByZXN1bHRzIHJlY2VpdmVkICg0IEJTUykK
UDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZp
Y2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQ
MlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDog
SWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElk
ClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAy
UDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcg
UDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5
IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgMTMgbGVuZ3RoIDMwClAyUDog
KiBEZXZpY2UgSW5mbzogYWRkciAxMjo2ODozZjo0ZTozOTpmMiBwcmltYXJ5IGRldmljZSB0eXBl
IDEwLTAwNTBGMjA0LTUgZGV2aWNlIG5hbWUgJ2R2ZGhybS1ueCcgY29uZmlnIG1ldGhvZHMgMHgx
ODgKUDJQOiBTdGF0ZSBTRUFSQ0ggLT4gU0VBUkNIClAyUDogU3RhcnRpbmcgc2hvcnQgbGlzdGVu
IHN0YXRlIChzdGF0ZT1TRUFSQ0gpCldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQ
UzogICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0y
NSBncm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8KcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdv
cmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3Jr
IGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKcDJwLWRldi13
bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwIGFmdGVyIDAu
MDAwMDEyIHNlY29uZCB3YWl0Cm5sODAyMTE6IEVuYWJsZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGlu
ZyBubF9wcmVxPTB4MjY4ODUwMApubDgwMjExOiBSZWdpc3RlciBmcmFtZSB0eXBlPTB4NDAgbmxf
aGFuZGxlPTB4MjY4ODUwMCBtYXRjaD0Kbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgY29va2ll
IDB4MjA2IGZvciBmcmVxPTI0MzcgTUh6IGR1cmF0aW9uPTEwMgpubDgwMjExOiBEcnYgRXZlbnQg
NTUgKE5MODAyMTFfQ01EX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13
bGFuMApubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTAgZnJlcT0yNDM3
IGNoYW5uZWxfdHlwZT0wIGR1cmF0aW9uPTEwMiBjb29raWU9MHgyMDYgKG1hdGNoKSkKcDJwLWRl
di13bGFuMDogRXZlbnQgUkVNQUlOX09OX0NIQU5ORUwgKDIxKSByZWNlaXZlZApPZmYtY2hhbm5l
bDogU2VuZCBBY3Rpb24gY2FsbGJhY2sgKHdpdGhvdXRfcm9jPTAgcGVuZGluZ19hY3Rpb25fdHg9
KG5pbCkpClAyUDogU3RhcnRpbmcgTGlzdGVuIHRpbWVvdXQoMCwxMDI0MDApIG9uIGZyZXE9MjQz
NyBiYXNlZCBvbiBjYWxsYmFjawpQMlA6IFNldCB0aW1lb3V0IChzdGF0ZT1TRUFSQ0gpOiAwLjEy
MjQwMCBzZWMKbmw4MDIxMTogRHJ2IEV2ZW50IDU2IChOTDgwMjExX0NNRF9DQU5DRUxfUkVNQUlO
X09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1v
bi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MSBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRp
b249MCBjb29raWU9MHgyMDYgKG1hdGNoKSkKcDJwLWRldi13bGFuMDogRXZlbnQgQ0FOQ0VMX1JF
TUFJTl9PTl9DSEFOTkVMICgyMikgcmVjZWl2ZWQKUDJQOiBDYW5jZWwgcmVtYWluLW9uLWNoYW5u
ZWwgY2FsbGJhY2sgKHAycF9sb25nX2xpc3Rlbj0wIG1zIHBlbmRpbmdfYWN0aW9uX3R4PShuaWwp
KQpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgZG9uZSBp
biAwLjEwMTkwNSBzZWNvbmRzClAyUDogRHJpdmVyIGVuZGVkIExpc3RlbiBzdGF0ZSAoZnJlcT0y
NDM3KQpQMlA6IFNraXAgc3RvcF9saXN0ZW4gc2luY2Ugbm90IGluIGxpc3Rlbl9vbmx5IHN0YXRl
LgpQMlA6IFRpbWVvdXQgKHN0YXRlPVNFQVJDSCkKbmw4MDIxMTogRGlzYWJsZSBQcm9iZSBSZXF1
ZXN0IHJlcG9ydGluZyBubF9wcmVxPTB4ODg4ODg4ODg4YWUwMGQ4OQpQMlA6IFN0YXJ0aW5nIHNl
YXJjaApXUFM6IEJ1aWxkaW5nIFdQUyBJRSBmb3IgUHJvYmUgUmVxdWVzdApXUFM6ICAqIFZlcnNp
b24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFJlcXVlc3QgVHlwZQpXUFM6ICAqIENvbmZpZyBN
ZXRob2RzICgxNDgpCldQUzogICogVVVJRC1FCldQUzogICogUHJpbWFyeSBEZXZpY2UgVHlwZQpX
UFM6ICAqIFJGIEJhbmRzICgzKQpXUFM6ICAqIEFzc29jaWF0aW9uIFN0YXRlCldQUzogICogQ29u
ZmlndXJhdGlvbiBFcnJvciAoMCkKV1BTOiAgKiBEZXZpY2UgUGFzc3dvcmQgSUQgKDApCldQUzog
ICogRGV2aWNlIE5hbWUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2
PTI1IGdyb3VwPTAwClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogUmVndWxhdG9yeSBDbGFzcyA4MSBD
aGFubmVsIDYKcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0
ODAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNj
aGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5ClAyUDogUnVubmluZyBwMnBfc2NhbgpwMnAtZGV2LXds
YW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGFmdGVyIDAuMDAw
MDEwIHNlY29uZCB3YWl0CnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IHNjYW4gcmVxdWVzdApubDgw
MjExOiBQMlAgcHJvYmUgLSBtYXNrIFN1cHBSYXRlcwpTY2FuIHJlcXVlc3RlZCAocmV0PTApIC0g
c2NhbiB0aW1lb3V0IDMwIHNlY29uZHMKbmw4MDIxMTogRHJ2IEV2ZW50IDMzIChOTDgwMjExX0NN
RF9UUklHR0VSX1NDQU4pIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1kZXYtd2xhbjA6
IG5sODAyMTE6IFNjYW4gdHJpZ2dlcgpwMnAtZGV2LXdsYW4wOiBFdmVudCBTQ0FOX1NUQVJURUQg
KDQ5KSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBPd24gc2NhbiByZXF1ZXN0IHN0YXJ0ZWQgYSBz
Y2FuIGluIDAuMDAwMDIyIHNlY29uZHMKcDJwLWRldi13bGFuMDogQ1RSTC1FVkVOVC1TQ0FOLVNU
QVJURUQgCm5sODAyMTE6IERydiBFdmVudCAzNCAoTkw4MDIxMV9DTURfTkVXX1NDQU5fUkVTVUxU
UykgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogTmV3
IHNjYW4gcmVzdWx0cyBhdmFpbGFibGUKbmw4MDIxMTogU2NhbiBwcm9iZWQgZm9yIFNTSUQgJ0RJ
UkVDVC0nCm5sODAyMTE6IFNjYW4gaW5jbHVkZWQgZnJlcXVlbmNpZXM6IDI0MTIgMjQzNyAyNDYy
CnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fUkVTVUxUUyAoMykgcmVjZWl2ZWQKcDJwLWRldi13
bGFuMDogU2NhbiBjb21wbGV0ZWQgaW4gMC4xMjA1NzEgc2Vjb25kcwpubDgwMjExOiBSZWNlaXZl
ZCBzY2FuIHJlc3VsdHMgKDQgQlNTZXMpCnAycC1kZXYtd2xhbjA6IEJTUzogU3RhcnQgc2NhbiBy
ZXN1bHQgdXBkYXRlIDE3CkJTUzogbGFzdF9zY2FuX3Jlc191c2VkPTMvMzIKcDJwLWRldi13bGFu
MDogUmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MCBkb25lIGluIDAuMTIzNDc0IHNlY29u
ZHMKUDJQOiBTY2FuIHJlc3VsdHMgcmVjZWl2ZWQgKDQgQlNTKQpQMlA6IElnbm9yZSBzY2FuIGRh
dGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcg
V1BTIElFClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQ
MlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdp
dGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJ
RQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBQcmltYXJ5IERldmljZSBU
eXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1
dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0
eSAwMApQMlA6IEF0dHJpYnV0ZSAxMyBsZW5ndGggMzAKUDJQOiAqIERldmljZSBJbmZvOiBhZGRy
IDEyOjY4OjNmOjRlOjM5OmYyIHByaW1hcnkgZGV2aWNlIHR5cGUgMTAtMDA1MEYyMDQtNSBkZXZp
Y2UgbmFtZSAnZHZkaHJtLW54JyBjb25maWcgbWV0aG9kcyAweDE4OApQMlA6IFN0YXRlIFNFQVJD
SCAtPiBTRUFSQ0gKUDJQOiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJD
SCkKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAq
IFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBE
ZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgy
Njg0NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUg
LSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRp
byB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTIgc2Vjb25kIHdhaXQK
bmw4MDIxMTogRW5hYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAw
Cm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1h
dGNoPQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgyMDcgZm9yIGZyZXE9MjQz
NyBNSHogZHVyYXRpb249MjA0Cm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIxMV9DTURfUkVN
QUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFp
bi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVy
YXRpb249MjA0IGNvb2tpZT0weDIwNyAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBSRU1B
SU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFjdGlvbiBjYWxs
YmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQOiBTdGFydGlu
ZyBMaXN0ZW4gdGltZW91dCgwLDIwNDgwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNr
ClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAuMjI0ODAwIHNlYwpubDgwMjExOiBE
cnYgRXZlbnQgNTYgKE5MODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2
ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNh
bmNlbD0xIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIwNyAo
bWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIy
KSByZWNlaXZlZApQMlA6IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xv
bmdfbGlzdGVuPTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJh
ZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMjA0MjkyIHNlY29uZHMK
UDJQOiBEcml2ZXIgZW5kZWQgTGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9w
X2xpc3RlbiBzaW5jZSBub3QgaW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91dCAoc3Rh
dGU9U0VBUkNIKQpubDgwMjExOiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3By
ZXE9MHg4ODg4ODg4ODhhZTAwZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVpbGRpbmcg
V1BTIElFIGZvciBQcm9iZSBSZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTAp
CldQUzogICogUmVxdWVzdCBUeXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAg
KiBVVUlELUUKV1BTOiAgKiBQcmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYgQmFuZHMgKDMp
CldQUzogICogQXNzb2NpYXRpb24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVycm9yICgw
KQpXUFM6ICAqIERldmljZSBQYXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6
ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAq
IExpc3RlbiBDaGFubmVsOiBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2LXds
YW4wOiBBZGQgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBG
aXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRp
YXRlbHkKUDJQOiBSdW5uaW5nIHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlv
IHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMjAgc2Vjb25kIHdhaXQKcDJw
LWRldi13bGFuMDogbmw4MDIxMTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1h
c2sgU3VwcFJhdGVzClNjYW4gcmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vj
b25kcwpubDgwMjExOiBEcnYgRXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTikgcmVj
ZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogU2NhbiB0cmln
Z2VyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAycC1k
ZXYtd2xhbjA6IE93biBzY2FuIHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAwMzQgc2Vj
b25kcwpwMnAtZGV2LXdsYW4wOiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2
IEV2ZW50IDM0IChOTDgwMjExX0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBmb3IgcDJw
LWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRzIGF2YWls
YWJsZQpubDgwMjExOiBTY2FuIHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIxMTogU2Nh
biBpbmNsdWRlZCBmcmVxdWVuY2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFuMDogRXZl
bnQgU0NBTl9SRVNVTFRTICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRl
ZCBpbiAwLjEyMDQ0NiBzZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoNCBC
U1NlcykKcDJwLWRldi13bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgMTgKQlNT
OiBsYXN0X3NjYW5fcmVzX3VzZWQ9My8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAt
c2NhbidAMHgyNjg4NDgwIGRvbmUgaW4gMC4xMjM0NDQgc2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0
cyByZWNlaXZlZCAoNCBCU1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZp
Y2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUg
c2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQ
YXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIElu
Zm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhv
ZHMgKFdQUyk6IDB4NDM4OApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBG
MjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDog
KiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRl
IDEzIGxlbmd0aCAzMApQMlA6ICogRGV2aWNlIEluZm86IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6ZjIg
cHJpbWFyeSBkZXZpY2UgdHlwZSAxMC0wMDUwRjIwNC01IGRldmljZSBuYW1lICdkdmRocm0tbngn
IGNvbmZpZyBtZXRob2RzIDB4MTg4ClAyUDogRG8gbm90IHVwZGF0ZSBwZWVyIGVudHJ5IGJhc2Vk
IG9uIG9sZCBmcmFtZSAocnhfdGltZT01NDM5OTkuNjA3NjAxIGxhc3Rfc2Vlbj01NDM5OTkuNjA3
NzI3KQpQMlA6IFN0YXRlIFNFQVJDSCAtPiBTRUFSQ0gKUDJQOiBTdGFydGluZyBzaG9ydCBsaXN0
ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkK
V1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2
PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8g
d29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdv
cmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpwMnAtZGV2
LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIg
MC4wMDAwMTIgc2Vjb25kIHdhaXQKbmw4MDIxMTogRW5hYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0
aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBu
bF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNoPQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBjb29r
aWUgMHgyMDggZm9yIGZyZXE9MjQzNyBNSHogZHVyYXRpb249MjA0Cm5sODAyMTE6IERydiBFdmVu
dCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2
LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0
MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MjA0IGNvb2tpZT0weDIwOCAobWF0Y2gpKQpwMnAt
ZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFu
bmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90
eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0ZW4gdGltZW91dCgwLDIwNDgwMCkgb24gZnJlcT0y
NDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAu
MjI0ODAwIHNlYwpubDgwMjExOiBCU1MgRXZlbnQgNTkgKE5MODAyMTFfQ01EX0ZSQU1FKSByZWNl
aXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSWCBmcmFtZSBmcmVxPTI0Mzcgc3NpX3Np
Z25hbD0tMjcgc3R5cGU9NCBsZW49MjE3CnAycC1kZXYtd2xhbjA6IEV2ZW50IFJYX01HTVQgKDIw
KSByZWNlaXZlZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6
IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5
cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0
ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5
IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3Vu
dHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFBh
cnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IERldmlj
ZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBG
MjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDog
KiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRl
IDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQpIFJlZ3Vs
YXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFJlcGx5IHRvIFAyUCBQcm9iZSBS
ZXF1ZXN0IGluIExpc3RlbiBzdGF0ZQpXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpX
UFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9
MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCm5sODAyMTE6IHNlbmRfbWxtZSAtIG5vYWNr
PTEgZnJlcT0wIG5vX2Njaz0wIG9mZmNoYW5vaz0wIHdhaXRfdGltZT0wIGZjPTB4NTAgbmxtb2Rl
PTEwCm5sODAyMTE6IFVzZSBsYXN0X21nbXRfZnJlcT0yNDM3Cm5sODAyMTE6IEJTUyBFdmVudCA1
OSAoTkw4MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6
IFJYIGZyYW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFsPS0yNyBzdHlwZT00IGxlbj0yMTcKcDJwLWRl
di13bGFuMDogRXZlbnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkClAyUDogUGFyc2luZyBXUFMgSUUK
UDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElE
OiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBh
cnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBh
YmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQ
MlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4
MSBDaGFubmVsIE51bWJlciA2ClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9k
cyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBE
ZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDog
QXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENh
cGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5u
ZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2
ClAyUDogUmVwbHkgdG8gUDJQIFByb2JlIFJlcXVlc3QgaW4gTGlzdGVuIHN0YXRlCldQUzogICog
VmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVh
ZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8K
bmw4MDIxMTogc2VuZF9tbG1lIC0gbm9hY2s9MSBmcmVxPTAgbm9fY2NrPTAgb2ZmY2hhbm9rPTAg
d2FpdF90aW1lPTAgZmM9MHg1MCBubG1vZGU9MTAKbmw4MDIxMTogVXNlIGxhc3RfbWdtdF9mcmVx
PTI0MzcKbmw4MDIxMTogQlNTIEV2ZW50IDU5IChOTDgwMjExX0NNRF9GUkFNRSkgcmVjZWl2ZWQg
Zm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUlggZnJhbWUgZnJlcT0yNDM3IHNzaV9zaWduYWw9
LTI3IHN0eXBlPTQgbGVuPTIxNwpwMnAtZGV2LXdsYW4wOiBFdmVudCBSWF9NR01UICgyMCkgcmVj
ZWl2ZWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQz
ODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChX
UFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBs
ZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQ
MlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBE
RSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBQYXJzaW5n
IFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZpY2UgUGFz
c3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01
ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2
aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxl
bmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5
IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBSZXBseSB0byBQMlAgUHJvYmUgUmVxdWVz
dCBpbiBMaXN0ZW4gc3RhdGUKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAg
KiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdy
b3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpubDgwMjExOiBzZW5kX21sbWUgLSBub2Fjaz0xIGZy
ZXE9MCBub19jY2s9MCBvZmZjaGFub2s9MCB3YWl0X3RpbWU9MCBmYz0weDUwIG5sbW9kZT0xMApu
bDgwMjExOiBVc2UgbGFzdF9tZ210X2ZyZXE9MjQzNwpubDgwMjExOiBCU1MgRXZlbnQgNTkgKE5M
ODAyMTFfQ01EX0ZSQU1FKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSWCBm
cmFtZSBmcmVxPTI0Mzcgc3NpX3NpZ25hbD0tMjcgc3R5cGU9NCBsZW49MjE3CnAycC1kZXYtd2xh
bjA6IEV2ZW50IFJYX01HTVQgKDIwKSByZWNlaXZlZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDog
Q29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJRDogMApQ
MlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5n
IFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0
eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAq
IExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hh
bm5lbCBOdW1iZXIgNgpQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQ
Uyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNl
IFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJp
YnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmls
aXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBD
b3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6
IFJlcGx5IHRvIFAyUCBQcm9iZSBSZXF1ZXN0IGluIExpc3RlbiBzdGF0ZQpXUFM6ICAqIFZlcnNp
b24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQ
MlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCm5sODAy
MTE6IHNlbmRfbWxtZSAtIG5vYWNrPTEgZnJlcT0wIG5vX2Njaz0wIG9mZmNoYW5vaz0wIHdhaXRf
dGltZT0wIGZjPTB4NTAgbmxtb2RlPTEwCm5sODAyMTE6IFVzZSBsYXN0X21nbXRfZnJlcT0yNDM3
Cm5sODAyMTE6IERydiBFdmVudCA1NiAoTkw4MDIxMV9DTURfQ0FOQ0VMX1JFTUFJTl9PTl9DSEFO
TkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSZW1haW4tb24tY2hhbm5l
bCBldmVudCAoY2FuY2VsPTEgZnJlcT0yNDM3IGNoYW5uZWxfdHlwZT0wIGR1cmF0aW9uPTAgY29v
a2llPTB4MjA4IChtYXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50IENBTkNFTF9SRU1BSU5fT05f
Q0hBTk5FTCAoMjIpIHJlY2VpdmVkClAyUDogQ2FuY2VsIHJlbWFpbi1vbi1jaGFubmVsIGNhbGxi
YWNrIChwMnBfbG9uZ19saXN0ZW49MCBtcyBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKcDJwLWRl
di13bGFuMDogUmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwIGRvbmUgaW4gMC4yMDQy
Mjggc2Vjb25kcwpQMlA6IERyaXZlciBlbmRlZCBMaXN0ZW4gc3RhdGUgKGZyZXE9MjQzNykKUDJQ
OiBTa2lwIHN0b3BfbGlzdGVuIHNpbmNlIG5vdCBpbiBsaXN0ZW5fb25seSBzdGF0ZS4KUDJQOiBU
aW1lb3V0IChzdGF0ZT1TRUFSQ0gpCm5sODAyMTE6IERpc2FibGUgUHJvYmUgUmVxdWVzdCByZXBv
cnRpbmcgbmxfcHJlcT0weDg4ODg4ODg4OGFlMDBkODkKUDJQOiBTdGFydGluZyBzZWFyY2gKV1BT
OiBCdWlsZGluZyBXUFMgSUUgZm9yIFByb2JlIFJlcXVlc3QKV1BTOiAgKiBWZXJzaW9uIChoYXJk
Y29kZWQgMHgxMCkKV1BTOiAgKiBSZXF1ZXN0IFR5cGUKV1BTOiAgKiBDb25maWcgTWV0aG9kcyAo
MTQ4KQpXUFM6ICAqIFVVSUQtRQpXUFM6ICAqIFByaW1hcnkgRGV2aWNlIFR5cGUKV1BTOiAgKiBS
RiBCYW5kcyAoMykKV1BTOiAgKiBBc3NvY2lhdGlvbiBTdGF0ZQpXUFM6ICAqIENvbmZpZ3VyYXRp
b24gRXJyb3IgKDApCldQUzogICogRGV2aWNlIFBhc3N3b3JkIElEICgwKQpXUFM6ICAqIERldmlj
ZSBOYW1lClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91
cD0wMApQMlA6ICogTGlzdGVuIENoYW5uZWw6IFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCA2
CnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwCnAycC1k
ZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBz
dGFydCBpbW1lZGlhdGVseQpQMlA6IFJ1bm5pbmcgcDJwX3NjYW4KcDJwLWRldi13bGFuMDogU3Rh
cnRpbmcgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MCBhZnRlciAwLjAwMDAxMCBzZWNv
bmQgd2FpdApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBzY2FuIHJlcXVlc3QKbmw4MDIxMTogUDJQ
IHByb2JlIC0gbWFzayBTdXBwUmF0ZXMKU2NhbiByZXF1ZXN0ZWQgKHJldD0wKSAtIHNjYW4gdGlt
ZW91dCAzMCBzZWNvbmRzCm5sODAyMTE6IERydiBFdmVudCAzMyAoTkw4MDIxMV9DTURfVFJJR0dF
Ul9TQ0FOKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjEx
OiBTY2FuIHRyaWdnZXIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9TVEFSVEVEICg0OSkgcmVj
ZWl2ZWQKcDJwLWRldi13bGFuMDogT3duIHNjYW4gcmVxdWVzdCBzdGFydGVkIGEgc2NhbiBpbiAw
LjAwMDAyMiBzZWNvbmRzCnAycC1kZXYtd2xhbjA6IENUUkwtRVZFTlQtU0NBTi1TVEFSVEVEIApu
bDgwMjExOiBEcnYgRXZlbnQgMzQgKE5MODAyMTFfQ01EX05FV19TQ0FOX1JFU1VMVFMpIHJlY2Vp
dmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IE5ldyBzY2FuIHJl
c3VsdHMgYXZhaWxhYmxlCm5sODAyMTE6IFNjYW4gcHJvYmVkIGZvciBTU0lEICdESVJFQ1QtJwpu
bDgwMjExOiBTY2FuIGluY2x1ZGVkIGZyZXF1ZW5jaWVzOiAyNDEyIDI0MzcgMjQ2MgpwMnAtZGV2
LXdsYW4wOiBFdmVudCBTQ0FOX1JFU1VMVFMgKDMpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IFNj
YW4gY29tcGxldGVkIGluIDAuMTIwNDY1IHNlY29uZHMKbmw4MDIxMTogUmVjZWl2ZWQgc2NhbiBy
ZXN1bHRzICg0IEJTU2VzKQpwMnAtZGV2LXdsYW4wOiBCU1M6IFN0YXJ0IHNjYW4gcmVzdWx0IHVw
ZGF0ZSAxOQpCU1M6IGxhc3Rfc2Nhbl9yZXNfdXNlZD0zLzMyCnAycC1kZXYtd2xhbjA6IFJhZGlv
IHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgZG9uZSBpbiAwLjEyMzQ2NyBzZWNvbmRzClAyUDog
U2NhbiByZXN1bHRzIHJlY2VpdmVkICg0IEJTUykKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhv
dXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQ
MlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmlj
ZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAy
UCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBD
b25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BT
KTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVu
Z3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQ
OiBBdHRyaWJ1dGUgMTMgbGVuZ3RoIDMwClAyUDogKiBEZXZpY2UgSW5mbzogYWRkciAxMjo2ODoz
Zjo0ZTozOTpmMiBwcmltYXJ5IGRldmljZSB0eXBlIDEwLTAwNTBGMjA0LTUgZGV2aWNlIG5hbWUg
J2R2ZGhybS1ueCcgY29uZmlnIG1ldGhvZHMgMHgxODgKUDJQOiBTdGF0ZSBTRUFSQ0ggLT4gU0VB
UkNIClAyUDogU3RhcnRpbmcgc2hvcnQgbGlzdGVuIHN0YXRlIChzdGF0ZT1TRUFSQ0gpCldQUzog
ICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAgSUUg
aGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNlIElu
Zm8KcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MApw
MnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1
bGUgc3RhcnQgaW1tZWRpYXRlbHkKcDJwLWRldi13bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAn
cDJwLWxpc3RlbidAMHgyNjg0NDYwIGFmdGVyIDAuMDAwMDE0IHNlY29uZCB3YWl0Cm5sODAyMTE6
IEVuYWJsZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBubF9wcmVxPTB4MjY4ODUwMApubDgwMjEx
OiBSZWdpc3RlciBmcmFtZSB0eXBlPTB4NDAgbmxfaGFuZGxlPTB4MjY4ODUwMCBtYXRjaD0Kbmw4
MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgY29va2llIDB4MjA5IGZvciBmcmVxPTI0MzcgTUh6IGR1
cmF0aW9uPTMwNwpubDgwMjExOiBEcnYgRXZlbnQgNTUgKE5MODAyMTFfQ01EX1JFTUFJTl9PTl9D
SEFOTkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSZW1haW4tb24tY2hh
bm5lbCBldmVudCAoY2FuY2VsPTAgZnJlcT0yNDM3IGNoYW5uZWxfdHlwZT0wIGR1cmF0aW9uPTMw
NyBjb29raWU9MHgyMDkgKG1hdGNoKSkKcDJwLWRldi13bGFuMDogRXZlbnQgUkVNQUlOX09OX0NI
QU5ORUwgKDIxKSByZWNlaXZlZApPZmYtY2hhbm5lbDogU2VuZCBBY3Rpb24gY2FsbGJhY2sgKHdp
dGhvdXRfcm9jPTAgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpClAyUDogU3RhcnRpbmcgTGlzdGVu
IHRpbWVvdXQoMCwzMDcyMDApIG9uIGZyZXE9MjQzNyBiYXNlZCBvbiBjYWxsYmFjawpQMlA6IFNl
dCB0aW1lb3V0IChzdGF0ZT1TRUFSQ0gpOiAwLjMyNzIwMCBzZWMKbmw4MDIxMTogRHJ2IEV2ZW50
IDU2IChOTDgwMjExX0NNRF9DQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBw
MnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MSBm
cmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MCBjb29raWU9MHgyMDkgKG1hdGNoKSkK
cDJwLWRldi13bGFuMDogRXZlbnQgQ0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMICgyMikgcmVjZWl2
ZWQKUDJQOiBDYW5jZWwgcmVtYWluLW9uLWNoYW5uZWwgY2FsbGJhY2sgKHAycF9sb25nX2xpc3Rl
bj0wIG1zIHBlbmRpbmdfYWN0aW9uX3R4PShuaWwpKQpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3Jr
ICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgZG9uZSBpbiAwLjMwNjYzNSBzZWNvbmRzClAyUDogRHJp
dmVyIGVuZGVkIExpc3RlbiBzdGF0ZSAoZnJlcT0yNDM3KQpQMlA6IFNraXAgc3RvcF9saXN0ZW4g
c2luY2Ugbm90IGluIGxpc3Rlbl9vbmx5IHN0YXRlLgpQMlA6IFRpbWVvdXQgKHN0YXRlPVNFQVJD
SCkKbmw4MDIxMTogRGlzYWJsZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBubF9wcmVxPTB4ODg4
ODg4ODg4YWUwMGQ4OQpQMlA6IFN0YXJ0aW5nIHNlYXJjaApXUFM6IEJ1aWxkaW5nIFdQUyBJRSBm
b3IgUHJvYmUgUmVxdWVzdApXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAq
IFJlcXVlc3QgVHlwZQpXUFM6ICAqIENvbmZpZyBNZXRob2RzICgxNDgpCldQUzogICogVVVJRC1F
CldQUzogICogUHJpbWFyeSBEZXZpY2UgVHlwZQpXUFM6ICAqIFJGIEJhbmRzICgzKQpXUFM6ICAq
IEFzc29jaWF0aW9uIFN0YXRlCldQUzogICogQ29uZmlndXJhdGlvbiBFcnJvciAoMCkKV1BTOiAg
KiBEZXZpY2UgUGFzc3dvcmQgSUQgKDApCldQUzogICogRGV2aWNlIE5hbWUKUDJQOiAqIFAyUCBJ
RSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBMaXN0ZW4g
Q2hhbm5lbDogUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIDYKcDJwLWRldi13bGFuMDogQWRk
IHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFk
aW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5ClAy
UDogUnVubmluZyBwMnBfc2NhbgpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdw
MnAtc2NhbidAMHgyNjg4NDgwIGFmdGVyIDAuMDAwMDIyIHNlY29uZCB3YWl0CnAycC1kZXYtd2xh
bjA6IG5sODAyMTE6IHNjYW4gcmVxdWVzdApubDgwMjExOiBQMlAgcHJvYmUgLSBtYXNrIFN1cHBS
YXRlcwpTY2FuIHJlcXVlc3RlZCAocmV0PTApIC0gc2NhbiB0aW1lb3V0IDMwIHNlY29uZHMKbmw4
MDIxMTogRHJ2IEV2ZW50IDMzIChOTDgwMjExX0NNRF9UUklHR0VSX1NDQU4pIHJlY2VpdmVkIGZv
ciBwMnAtZGV2LXdsYW4wCnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IFNjYW4gdHJpZ2dlcgpwMnAt
ZGV2LXdsYW4wOiBFdmVudCBTQ0FOX1NUQVJURUQgKDQ5KSByZWNlaXZlZApwMnAtZGV2LXdsYW4w
OiBPd24gc2NhbiByZXF1ZXN0IHN0YXJ0ZWQgYSBzY2FuIGluIDAuMDAwMDM3IHNlY29uZHMKcDJw
LWRldi13bGFuMDogQ1RSTC1FVkVOVC1TQ0FOLVNUQVJURUQgCm5sODAyMTE6IERydiBFdmVudCAz
NCAoTkw4MDIxMV9DTURfTkVXX1NDQU5fUkVTVUxUUykgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xh
bjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogTmV3IHNjYW4gcmVzdWx0cyBhdmFpbGFibGUKbmw4
MDIxMTogU2NhbiBwcm9iZWQgZm9yIFNTSUQgJ0RJUkVDVC0nCm5sODAyMTE6IFNjYW4gaW5jbHVk
ZWQgZnJlcXVlbmNpZXM6IDI0MTIgMjQzNyAyNDYyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5f
UkVTVUxUUyAoMykgcmVjZWl2ZWQKcDJwLWRldi13bGFuMDogU2NhbiBjb21wbGV0ZWQgaW4gMC4x
MjA0Njcgc2Vjb25kcwpubDgwMjExOiBSZWNlaXZlZCBzY2FuIHJlc3VsdHMgKDQgQlNTZXMpCnAy
cC1kZXYtd2xhbjA6IEJTUzogU3RhcnQgc2NhbiByZXN1bHQgdXBkYXRlIDIwCkJTUzogbGFzdF9z
Y2FuX3Jlc191c2VkPTMvMzIKcDJwLWRldi13bGFuMDogUmFkaW8gd29yayAncDJwLXNjYW4nQDB4
MjY4ODQ4MCBkb25lIGluIDAuMTIzNjEwIHNlY29uZHMKUDJQOiBTY2FuIHJlc3VsdHMgcmVjZWl2
ZWQgKDQgQlNTKQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8g
b3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogSWdub3JlIHNjYW4gZGF0
YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBX
UFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAy
UCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMp
OiAweDQzODgKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAy
UDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNl
IENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSAxMyBsZW5n
dGggMzAKUDJQOiAqIERldmljZSBJbmZvOiBhZGRyIDEyOjY4OjNmOjRlOjM5OmYyIHByaW1hcnkg
ZGV2aWNlIHR5cGUgMTAtMDA1MEYyMDQtNSBkZXZpY2UgbmFtZSAnZHZkaHJtLW54JyBjb25maWcg
bWV0aG9kcyAweDE4OApQMlA6IERvIG5vdCB1cGRhdGUgcGVlciBlbnRyeSBiYXNlZCBvbiBvbGQg
ZnJhbWUgKHJ4X3RpbWU9NTQ0MDAwLjU1NDIzNSBsYXN0X3NlZW49NTQ0MDAwLjU1NDYxOSkKUDJQ
OiBTdGF0ZSBTRUFSQ0ggLT4gU0VBUkNIClAyUDogU3RhcnRpbmcgc2hvcnQgbGlzdGVuIHN0YXRl
IChzdGF0ZT1TRUFSQ0gpCldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICog
VVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91
cD0wMApQMlA6ICogRGV2aWNlIEluZm8KcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdvcmsgJ3Ay
cC1saXN0ZW4nQDB4MjY4NDQ2MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0g
aW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKcDJwLWRldi13bGFuMDog
U3RhcnRpbmcgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwIGFmdGVyIDAuMDAwMDEy
IHNlY29uZCB3YWl0Cm5sODAyMTE6IEVuYWJsZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBubF9w
cmVxPTB4MjY4ODUwMApubDgwMjExOiBSZWdpc3RlciBmcmFtZSB0eXBlPTB4NDAgbmxfaGFuZGxl
PTB4MjY4ODUwMCBtYXRjaD0Kbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgY29va2llIDB4MjBh
IGZvciBmcmVxPTI0MzcgTUh6IGR1cmF0aW9uPTEwMgpubDgwMjExOiBEcnYgRXZlbnQgNTUgKE5M
ODAyMTFfQ01EX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApu
bDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTAgZnJlcT0yNDM3IGNoYW5u
ZWxfdHlwZT0wIGR1cmF0aW9uPTEwMiBjb29raWU9MHgyMGEgKG1hdGNoKSkKcDJwLWRldi13bGFu
MDogRXZlbnQgUkVNQUlOX09OX0NIQU5ORUwgKDIxKSByZWNlaXZlZApPZmYtY2hhbm5lbDogU2Vu
ZCBBY3Rpb24gY2FsbGJhY2sgKHdpdGhvdXRfcm9jPTAgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkp
ClAyUDogU3RhcnRpbmcgTGlzdGVuIHRpbWVvdXQoMCwxMDI0MDApIG9uIGZyZXE9MjQzNyBiYXNl
ZCBvbiBjYWxsYmFjawpQMlA6IFNldCB0aW1lb3V0IChzdGF0ZT1TRUFSQ0gpOiAwLjEyMjQwMCBz
ZWMKbmw4MDIxMTogRHJ2IEV2ZW50IDU2IChOTDgwMjExX0NNRF9DQU5DRUxfUkVNQUlOX09OX0NI
QU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFu
bmVsIGV2ZW50IChjYW5jZWw9MSBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MCBj
b29raWU9MHgyMGEgKG1hdGNoKSkKcDJwLWRldi13bGFuMDogRXZlbnQgQ0FOQ0VMX1JFTUFJTl9P
Tl9DSEFOTkVMICgyMikgcmVjZWl2ZWQKUDJQOiBDYW5jZWwgcmVtYWluLW9uLWNoYW5uZWwgY2Fs
bGJhY2sgKHAycF9sb25nX2xpc3Rlbj0wIG1zIHBlbmRpbmdfYWN0aW9uX3R4PShuaWwpKQpwMnAt
ZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgZG9uZSBpbiAwLjEw
MTkyNiBzZWNvbmRzClAyUDogRHJpdmVyIGVuZGVkIExpc3RlbiBzdGF0ZSAoZnJlcT0yNDM3KQpQ
MlA6IFNraXAgc3RvcF9saXN0ZW4gc2luY2Ugbm90IGluIGxpc3Rlbl9vbmx5IHN0YXRlLgpQMlA6
IFRpbWVvdXQgKHN0YXRlPVNFQVJDSCkKbmw4MDIxMTogRGlzYWJsZSBQcm9iZSBSZXF1ZXN0IHJl
cG9ydGluZyBubF9wcmVxPTB4ODg4ODg4ODg4YWUwMGQ4OQpQMlA6IFN0YXJ0aW5nIHNlYXJjaApX
UFM6IEJ1aWxkaW5nIFdQUyBJRSBmb3IgUHJvYmUgUmVxdWVzdApXUFM6ICAqIFZlcnNpb24gKGhh
cmRjb2RlZCAweDEwKQpXUFM6ICAqIFJlcXVlc3QgVHlwZQpXUFM6ICAqIENvbmZpZyBNZXRob2Rz
ICgxNDgpCldQUzogICogVVVJRC1FCldQUzogICogUHJpbWFyeSBEZXZpY2UgVHlwZQpXUFM6ICAq
IFJGIEJhbmRzICgzKQpXUFM6ICAqIEFzc29jaWF0aW9uIFN0YXRlCldQUzogICogQ29uZmlndXJh
dGlvbiBFcnJvciAoMCkKV1BTOiAgKiBEZXZpY2UgUGFzc3dvcmQgSUQgKDApCldQUzogICogRGV2
aWNlIE5hbWUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdy
b3VwPTAwClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVs
IDYKcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAKcDJw
LWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxl
IHN0YXJ0IGltbWVkaWF0ZWx5ClAyUDogUnVubmluZyBwMnBfc2NhbgpwMnAtZGV2LXdsYW4wOiBT
dGFydGluZyByYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGFmdGVyIDAuMDAwMDA5IHNl
Y29uZCB3YWl0CnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IHNjYW4gcmVxdWVzdApubDgwMjExOiBQ
MlAgcHJvYmUgLSBtYXNrIFN1cHBSYXRlcwpTY2FuIHJlcXVlc3RlZCAocmV0PTApIC0gc2NhbiB0
aW1lb3V0IDMwIHNlY29uZHMKbmw4MDIxMTogRHJ2IEV2ZW50IDMzIChOTDgwMjExX0NNRF9UUklH
R0VSX1NDQU4pIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1kZXYtd2xhbjA6IG5sODAy
MTE6IFNjYW4gdHJpZ2dlcgpwMnAtZGV2LXdsYW4wOiBFdmVudCBTQ0FOX1NUQVJURUQgKDQ5KSBy
ZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBPd24gc2NhbiByZXF1ZXN0IHN0YXJ0ZWQgYSBzY2FuIGlu
IDAuMDAwMDI3IHNlY29uZHMKcDJwLWRldi13bGFuMDogQ1RSTC1FVkVOVC1TQ0FOLVNUQVJURUQg
Cm5sODAyMTE6IERydiBFdmVudCAzNCAoTkw4MDIxMV9DTURfTkVXX1NDQU5fUkVTVUxUUykgcmVj
ZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogTmV3IHNjYW4g
cmVzdWx0cyBhdmFpbGFibGUKbmw4MDIxMTogU2NhbiBwcm9iZWQgZm9yIFNTSUQgJ0RJUkVDVC0n
Cm5sODAyMTE6IFNjYW4gaW5jbHVkZWQgZnJlcXVlbmNpZXM6IDI0MTIgMjQzNyAyNDYyCnAycC1k
ZXYtd2xhbjA6IEV2ZW50IFNDQU5fUkVTVUxUUyAoMykgcmVjZWl2ZWQKcDJwLWRldi13bGFuMDog
U2NhbiBjb21wbGV0ZWQgaW4gMC4xMjA1MjYgc2Vjb25kcwpubDgwMjExOiBSZWNlaXZlZCBzY2Fu
IHJlc3VsdHMgKDQgQlNTZXMpCnAycC1kZXYtd2xhbjA6IEJTUzogU3RhcnQgc2NhbiByZXN1bHQg
dXBkYXRlIDIxCkJTUzogbGFzdF9zY2FuX3Jlc191c2VkPTMvMzIKcDJwLWRldi13bGFuMDogUmFk
aW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MCBkb25lIGluIDAuMTIzNDk5IHNlY29uZHMKUDJQ
OiBTY2FuIHJlc3VsdHMgcmVjZWl2ZWQgKDQgQlNTKQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0
aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElF
ClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2
aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQg
UDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6
IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChX
UFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBs
ZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQ
MlA6IEF0dHJpYnV0ZSAxMyBsZW5ndGggMzAKUDJQOiAqIERldmljZSBJbmZvOiBhZGRyIDEyOjY4
OjNmOjRlOjM5OmYyIHByaW1hcnkgZGV2aWNlIHR5cGUgMTAtMDA1MEYyMDQtNSBkZXZpY2UgbmFt
ZSAnZHZkaHJtLW54JyBjb25maWcgbWV0aG9kcyAweDE4OApQMlA6IFN0YXRlIFNFQVJDSCAtPiBT
RUFSQ0gKUDJQOiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkKV1BT
OiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJ
RSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2Ug
SW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYw
CnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hl
ZHVsZSBzdGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3Jr
ICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTIgc2Vjb25kIHdhaXQKbmw4MDIx
MTogRW5hYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5sODAy
MTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNoPQpu
bDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgyMGIgZm9yIGZyZXE9MjQzNyBNSHog
ZHVyYXRpb249MTAyCm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09O
X0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1j
aGFubmVsIGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249
MTAyIGNvb2tpZT0weDIwYiAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05f
Q0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAo
d2l0aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0
ZW4gdGltZW91dCgwLDEwMjQwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDog
U2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAuMTIyNDAwIHNlYwpubDgwMjExOiBEcnYgRXZl
bnQgNTYgKE5MODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9y
IHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0x
IGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIwYiAobWF0Y2gp
KQpwMnAtZGV2LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNl
aXZlZApQMlA6IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlz
dGVuPTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdv
cmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMTAxODgyIHNlY29uZHMKUDJQOiBE
cml2ZXIgZW5kZWQgTGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3Rl
biBzaW5jZSBub3QgaW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9U0VB
UkNIKQpubDgwMjExOiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHg4
ODg4ODg4ODhhZTAwZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BTIElF
IGZvciBQcm9iZSBSZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzog
ICogUmVxdWVzdCBUeXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBVVUlE
LUUKV1BTOiAgKiBQcmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQUzog
ICogQXNzb2NpYXRpb24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpXUFM6
ICAqIERldmljZSBQYXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICogUDJQ
IElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExpc3Rl
biBDaGFubmVsOiBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4wOiBB
ZGQgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJzdCBy
YWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkK
UDJQOiBSdW5uaW5nIHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsg
J3AycC1zY2FuJ0AweDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMTAgc2Vjb25kIHdhaXQKcDJwLWRldi13
bGFuMDogbmw4MDIxMTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sgU3Vw
cFJhdGVzClNjYW4gcmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25kcwpu
bDgwMjExOiBEcnYgRXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2ZWQg
Zm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2VyCnAy
cC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYtd2xh
bjA6IE93biBzY2FuIHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAwMjYgc2Vjb25kcwpw
MnAtZGV2LXdsYW4wOiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2ZW50
IDM0IChOTDgwMjExX0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRldi13
bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJsZQpu
bDgwMjExOiBTY2FuIHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBpbmNs
dWRlZCBmcmVxdWVuY2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NB
Tl9SRVNVTFRTICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAw
LjEyMDUwNyBzZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoNCBCU1NlcykK
cDJwLWRldi13bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgMjIKQlNTOiBsYXN0
X3NjYW5fcmVzX3VzZWQ9My8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidA
MHgyNjg4NDgwIGRvbmUgaW4gMC4xMjM0ODMgc2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNl
aXZlZCAoNCBCU1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5m
byBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBk
YXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5n
IFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3Ig
UDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQ
Uyk6IDB4NDM4OApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUK
UDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZp
Y2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDEzIGxl
bmd0aCAzMApQMlA6ICogRGV2aWNlIEluZm86IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6ZjIgcHJpbWFy
eSBkZXZpY2UgdHlwZSAxMC0wMDUwRjIwNC01IGRldmljZSBuYW1lICdkdmRocm0tbngnIGNvbmZp
ZyBtZXRob2RzIDB4MTg4ClAyUDogU3RhdGUgU0VBUkNIIC0+IFNFQVJDSApQMlA6IFN0YXJ0aW5n
IHNob3J0IGxpc3RlbiBzdGF0ZSAoc3RhdGU9U0VBUkNIKQpXUFM6ICAqIFZlcnNpb24gKGhhcmRj
b2RlZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2Fw
YWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCnAycC1kZXYtd2xhbjA6
IEFkZCByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAKcDJwLWRldi13bGFuMDogRmly
c3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0
ZWx5CnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4
NDQ2MCBhZnRlciAwLjAwMDAxMyBzZWNvbmQgd2FpdApubDgwMjExOiBFbmFibGUgUHJvYmUgUmVx
dWVzdCByZXBvcnRpbmcgbmxfcHJlcT0weDI2ODg1MDAKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUg
dHlwZT0weDQwIG5sX2hhbmRsZT0weDI2ODg1MDAgbWF0Y2g9Cm5sODAyMTE6IFJlbWFpbi1vbi1j
aGFubmVsIGNvb2tpZSAweDIwYyBmb3IgZnJlcT0yNDM3IE1IeiBkdXJhdGlvbj0yMDQKbmw4MDIx
MTogRHJ2IEV2ZW50IDU1IChOTDgwMjExX0NNRF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQg
Zm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNl
bD0wIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0yMDQgY29va2llPTB4MjBjICht
YXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50IFJFTUFJTl9PTl9DSEFOTkVMICgyMSkgcmVjZWl2
ZWQKT2ZmLWNoYW5uZWw6IFNlbmQgQWN0aW9uIGNhbGxiYWNrICh3aXRob3V0X3JvYz0wIHBlbmRp
bmdfYWN0aW9uX3R4PShuaWwpKQpQMlA6IFN0YXJ0aW5nIExpc3RlbiB0aW1lb3V0KDAsMjA0ODAw
KSBvbiBmcmVxPTI0MzcgYmFzZWQgb24gY2FsbGJhY2sKUDJQOiBTZXQgdGltZW91dCAoc3RhdGU9
U0VBUkNIKTogMC4yMjQ4MDAgc2VjCm5sODAyMTE6IERydiBFdmVudCA1NiAoTkw4MDIxMV9DTURf
Q0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgw
MjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTEgZnJlcT0yNDM3IGNoYW5uZWxf
dHlwZT0wIGR1cmF0aW9uPTAgY29va2llPTB4MjBjIChtYXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2
ZW50IENBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCAoMjIpIHJlY2VpdmVkClAyUDogQ2FuY2VsIHJl
bWFpbi1vbi1jaGFubmVsIGNhbGxiYWNrIChwMnBfbG9uZ19saXN0ZW49MCBtcyBwZW5kaW5nX2Fj
dGlvbl90eD0obmlsKSkKcDJwLWRldi13bGFuMDogUmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgy
Njg0NDYwIGRvbmUgaW4gMC4yMDQyNzAgc2Vjb25kcwpQMlA6IERyaXZlciBlbmRlZCBMaXN0ZW4g
c3RhdGUgKGZyZXE9MjQzNykKUDJQOiBTa2lwIHN0b3BfbGlzdGVuIHNpbmNlIG5vdCBpbiBsaXN0
ZW5fb25seSBzdGF0ZS4KUDJQOiBUaW1lb3V0IChzdGF0ZT1TRUFSQ0gpCm5sODAyMTE6IERpc2Fi
bGUgUHJvYmUgUmVxdWVzdCByZXBvcnRpbmcgbmxfcHJlcT0weDg4ODg4ODg4OGFlMDBkODkKUDJQ
OiBTdGFydGluZyBzZWFyY2gKV1BTOiBCdWlsZGluZyBXUFMgSUUgZm9yIFByb2JlIFJlcXVlc3QK
V1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBSZXF1ZXN0IFR5cGUKV1BT
OiAgKiBDb25maWcgTWV0aG9kcyAoMTQ4KQpXUFM6ICAqIFVVSUQtRQpXUFM6ICAqIFByaW1hcnkg
RGV2aWNlIFR5cGUKV1BTOiAgKiBSRiBCYW5kcyAoMykKV1BTOiAgKiBBc3NvY2lhdGlvbiBTdGF0
ZQpXUFM6ICAqIENvbmZpZ3VyYXRpb24gRXJyb3IgKDApCldQUzogICogRGV2aWNlIFBhc3N3b3Jk
IElEICgwKQpXUFM6ICAqIERldmljZSBOYW1lClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBD
YXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogTGlzdGVuIENoYW5uZWw6IFJlZ3VsYXRv
cnkgQ2xhc3MgODEgQ2hhbm5lbCA2CnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3JrICdwMnAt
c2NhbidAMHgyNjg4NDgwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0
aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpQMlA6IFJ1bm5pbmcgcDJwX3Nj
YW4KcDJwLWRldi13bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4
MCBhZnRlciAwLjAwMDAwOSBzZWNvbmQgd2FpdApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBzY2Fu
IHJlcXVlc3QKbmw4MDIxMTogUDJQIHByb2JlIC0gbWFzayBTdXBwUmF0ZXMKU2NhbiByZXF1ZXN0
ZWQgKHJldD0wKSAtIHNjYW4gdGltZW91dCAzMCBzZWNvbmRzCm5sODAyMTE6IERydiBFdmVudCAz
MyAoTkw4MDIxMV9DTURfVFJJR0dFUl9TQ0FOKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApw
MnAtZGV2LXdsYW4wOiBubDgwMjExOiBTY2FuIHRyaWdnZXIKcDJwLWRldi13bGFuMDogRXZlbnQg
U0NBTl9TVEFSVEVEICg0OSkgcmVjZWl2ZWQKcDJwLWRldi13bGFuMDogT3duIHNjYW4gcmVxdWVz
dCBzdGFydGVkIGEgc2NhbiBpbiAwLjAwMDAyOCBzZWNvbmRzCnAycC1kZXYtd2xhbjA6IENUUkwt
RVZFTlQtU0NBTi1TVEFSVEVEIApubDgwMjExOiBEcnYgRXZlbnQgMzQgKE5MODAyMTFfQ01EX05F
V19TQ0FOX1JFU1VMVFMpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1kZXYtd2xhbjA6
IG5sODAyMTE6IE5ldyBzY2FuIHJlc3VsdHMgYXZhaWxhYmxlCm5sODAyMTE6IFNjYW4gcHJvYmVk
IGZvciBTU0lEICdESVJFQ1QtJwpubDgwMjExOiBTY2FuIGluY2x1ZGVkIGZyZXF1ZW5jaWVzOiAy
NDEyIDI0MzcgMjQ2MgpwMnAtZGV2LXdsYW4wOiBFdmVudCBTQ0FOX1JFU1VMVFMgKDMpIHJlY2Vp
dmVkCnAycC1kZXYtd2xhbjA6IFNjYW4gY29tcGxldGVkIGluIDAuMTIwNDczIHNlY29uZHMKbmw4
MDIxMTogUmVjZWl2ZWQgc2NhbiByZXN1bHRzICg0IEJTU2VzKQpwMnAtZGV2LXdsYW4wOiBCU1M6
IFN0YXJ0IHNjYW4gcmVzdWx0IHVwZGF0ZSAyMwpCU1M6IGxhc3Rfc2Nhbl9yZXNfdXNlZD0zLzMy
CnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgZG9uZSBpbiAw
LjEyMzUwMCBzZWNvbmRzClAyUDogU2NhbiByZXN1bHRzIHJlY2VpdmVkICg0IEJTUykKUDJQOiBJ
Z25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQK
UDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2
aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogSWdub3Jl
IHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDog
UGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogUHJp
bWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElF
ClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdy
b3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgMTMgbGVuZ3RoIDMwClAyUDogKiBEZXZp
Y2UgSW5mbzogYWRkciAxMjo2ODozZjo0ZTozOTpmMiBwcmltYXJ5IGRldmljZSB0eXBlIDEwLTAw
NTBGMjA0LTUgZGV2aWNlIG5hbWUgJ2R2ZGhybS1ueCcgY29uZmlnIG1ldGhvZHMgMHgxODgKUDJQ
OiBTdGF0ZSBTRUFSQ0ggLT4gU0VBUkNIClAyUDogU3RhcnRpbmcgc2hvcnQgbGlzdGVuIHN0YXRl
IChzdGF0ZT1TRUFSQ0gpCldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICog
VVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91
cD0wMApQMlA6ICogRGV2aWNlIEluZm8KcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdvcmsgJ3Ay
cC1saXN0ZW4nQDB4MjY4NDQ2MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0g
aW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKcDJwLWRldi13bGFuMDog
U3RhcnRpbmcgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwIGFmdGVyIDAuMDAwMDE0
IHNlY29uZCB3YWl0Cm5sODAyMTE6IEVuYWJsZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBubF9w
cmVxPTB4MjY4ODUwMApubDgwMjExOiBSZWdpc3RlciBmcmFtZSB0eXBlPTB4NDAgbmxfaGFuZGxl
PTB4MjY4ODUwMCBtYXRjaD0Kbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgY29va2llIDB4MjBk
IGZvciBmcmVxPTI0MzcgTUh6IGR1cmF0aW9uPTMwNwpubDgwMjExOiBEcnYgRXZlbnQgNTUgKE5M
ODAyMTFfQ01EX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApu
bDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTAgZnJlcT0yNDM3IGNoYW5u
ZWxfdHlwZT0wIGR1cmF0aW9uPTMwNyBjb29raWU9MHgyMGQgKG1hdGNoKSkKcDJwLWRldi13bGFu
MDogRXZlbnQgUkVNQUlOX09OX0NIQU5ORUwgKDIxKSByZWNlaXZlZApPZmYtY2hhbm5lbDogU2Vu
ZCBBY3Rpb24gY2FsbGJhY2sgKHdpdGhvdXRfcm9jPTAgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkp
ClAyUDogU3RhcnRpbmcgTGlzdGVuIHRpbWVvdXQoMCwzMDcyMDApIG9uIGZyZXE9MjQzNyBiYXNl
ZCBvbiBjYWxsYmFjawpQMlA6IFNldCB0aW1lb3V0IChzdGF0ZT1TRUFSQ0gpOiAwLjMyNzIwMCBz
ZWMKbmw4MDIxMTogQlNTIEV2ZW50IDU5IChOTDgwMjExX0NNRF9GUkFNRSkgcmVjZWl2ZWQgZm9y
IHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUlggZnJhbWUgZnJlcT0yNDM3IHNzaV9zaWduYWw9LTI3
IHN0eXBlPTQgbGVuPTIxNwpwMnAtZGV2LXdsYW4wOiBFdmVudCBSWF9NR01UICgyMCkgcmVjZWl2
ZWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgK
UDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMp
OiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5n
dGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6
IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgw
eDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBQYXJzaW5nIFdQ
UyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dv
cmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAy
UDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNl
IENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0
aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENs
YXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBSZXBseSB0byBQMlAgUHJvYmUgUmVxdWVzdCBp
biBMaXN0ZW4gc3RhdGUKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBV
VUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3Vw
PTAwClAyUDogKiBEZXZpY2UgSW5mbwpubDgwMjExOiBzZW5kX21sbWUgLSBub2Fjaz0xIGZyZXE9
MCBub19jY2s9MCBvZmZjaGFub2s9MCB3YWl0X3RpbWU9MCBmYz0weDUwIG5sbW9kZT0xMApubDgw
MjExOiBVc2UgbGFzdF9tZ210X2ZyZXE9MjQzNwpubDgwMjExOiBCU1MgRXZlbnQgNTkgKE5MODAy
MTFfQ01EX0ZSQU1FKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSWCBmcmFt
ZSBmcmVxPTI0Mzcgc3NpX3NpZ25hbD0tMjcgc3R5cGU9NCBsZW49MjE3CnAycC1kZXYtd2xhbjA6
IEV2ZW50IFJYX01HTVQgKDIwKSByZWNlaXZlZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29u
ZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6
IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAy
UCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAy
NSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExp
c3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5l
bCBOdW1iZXIgNgpQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6
IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5
cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0
ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5
IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3Vu
dHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFJl
cGx5IHRvIFAyUCBQcm9iZSBSZXF1ZXN0IGluIExpc3RlbiBzdGF0ZQpXUFM6ICAqIFZlcnNpb24g
KGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6
ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCm5sODAyMTE6
IHNlbmRfbWxtZSAtIG5vYWNrPTEgZnJlcT0wIG5vX2Njaz0wIG9mZmNoYW5vaz0wIHdhaXRfdGlt
ZT0wIGZjPTB4NTAgbmxtb2RlPTEwCm5sODAyMTE6IFVzZSBsYXN0X21nbXRfZnJlcT0yNDM3Cm5s
ODAyMTE6IEJTUyBFdmVudCA1OSAoTkw4MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAt
ZGV2LXdsYW4wCm5sODAyMTE6IFJYIGZyYW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFsPS0yNyBzdHlw
ZT00IGxlbj0yMTcKcDJwLWRldi13bGFuMDogRXZlbnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkClAy
UDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDog
RGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAt
MDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIK
UDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRy
aWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkg
UmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUGFyc2luZyBXUFMgSUUK
UDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElE
OiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBh
cnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBh
YmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQ
MlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4
MSBDaGFubmVsIE51bWJlciA2ClAyUDogUmVwbHkgdG8gUDJQIFByb2JlIFJlcXVlc3QgaW4gTGlz
dGVuIHN0YXRlCldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1F
ClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQ
MlA6ICogRGV2aWNlIEluZm8Kbmw4MDIxMTogc2VuZF9tbG1lIC0gbm9hY2s9MSBmcmVxPTAgbm9f
Y2NrPTAgb2ZmY2hhbm9rPTAgd2FpdF90aW1lPTAgZmM9MHg1MCBubG1vZGU9MTAKbmw4MDIxMTog
VXNlIGxhc3RfbWdtdF9mcmVxPTI0MzcKbmw4MDIxMTogQlNTIEV2ZW50IDU5IChOTDgwMjExX0NN
RF9GUkFNRSkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUlggZnJhbWUgZnJl
cT0yNDM3IHNzaV9zaWduYWw9LTI3IHN0eXBlPTQgbGVuPTIxNwpwMnAtZGV2LXdsYW4wOiBFdmVu
dCBSWF9NR01UICgyMCkgcmVjZWl2ZWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBN
ZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmlt
YXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUK
UDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3Jv
dXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4g
Q2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVt
YmVyIDYKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQz
ODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChX
UFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBs
ZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQ
MlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBE
RSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBSZXBseSB0
byBQMlAgUHJvYmUgUmVxdWVzdCBpbiBMaXN0ZW4gc3RhdGUKV1BTOiAgKiBWZXJzaW9uIChoYXJk
Y29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENh
cGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpubDgwMjExOiBzZW5k
X21sbWUgLSBub2Fjaz0xIGZyZXE9MCBub19jY2s9MCBvZmZjaGFub2s9MCB3YWl0X3RpbWU9MCBm
Yz0weDUwIG5sbW9kZT0xMApubDgwMjExOiBVc2UgbGFzdF9tZ210X2ZyZXE9MjQzNwpubDgwMjEx
OiBEcnYgRXZlbnQgNTYgKE5MODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVj
ZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQg
KGNhbmNlbD0xIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIw
ZCAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwg
KDIyKSByZWNlaXZlZApQMlA6IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJw
X2xvbmdfbGlzdGVuPTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6
IFJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMzA2NjQwIHNlY29u
ZHMKUDJQOiBEcml2ZXIgZW5kZWQgTGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBz
dG9wX2xpc3RlbiBzaW5jZSBub3QgaW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91dCAo
c3RhdGU9U0VBUkNIKQpubDgwMjExOiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5s
X3ByZXE9MHg4ODg4ODg4ODhhZTAwZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVpbGRp
bmcgV1BTIElFIGZvciBQcm9iZSBSZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4
MTApCldQUzogICogUmVxdWVzdCBUeXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkKV1BT
OiAgKiBVVUlELUUKV1BTOiAgKiBQcmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYgQmFuZHMg
KDMpCldQUzogICogQXNzb2NpYXRpb24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVycm9y
ICgwKQpXUFM6ICAqIERldmljZSBQYXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQ
MlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQ
OiAqIExpc3RlbiBDaGFubmVsOiBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2
LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4w
OiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1t
ZWRpYXRlbHkKUDJQOiBSdW5uaW5nIHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJh
ZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMTUgc2Vjb25kIHdhaXQK
cDJwLWRldi13bGFuMDogbmw4MDIxMTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAt
IG1hc2sgU3VwcFJhdGVzClNjYW4gcmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAg
c2Vjb25kcwpubDgwMjExOiBEcnYgRXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTikg
cmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogU2NhbiB0
cmlnZ2VyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAy
cC1kZXYtd2xhbjA6IE93biBzY2FuIHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAwMzcg
c2Vjb25kcwpwMnAtZGV2LXdsYW4wOiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIxMTog
RHJ2IEV2ZW50IDM0IChOTDgwMjExX0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBmb3Ig
cDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRzIGF2
YWlsYWJsZQpubDgwMjExOiBTY2FuIHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIxMTog
U2NhbiBpbmNsdWRlZCBmcmVxdWVuY2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFuMDog
RXZlbnQgU0NBTl9SRVNVTFRTICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBs
ZXRlZCBpbiAwLjEyMDUwMCBzZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAo
NCBCU1NlcykKcDJwLWRldi13bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgMjQK
QlNTOiBsYXN0X3NjYW5fcmVzX3VzZWQ9My8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdw
MnAtc2NhbidAMHgyNjg4NDgwIGRvbmUgaW4gMC4xMjM0ODYgc2Vjb25kcwpQMlA6IFNjYW4gcmVz
dWx0cyByZWNlaXZlZCAoNCBCU1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBE
ZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25v
cmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQ
OiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNl
IEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1l
dGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAw
NTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAy
UDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmli
dXRlIDEzIGxlbmd0aCAzMApQMlA6ICogRGV2aWNlIEluZm86IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6
ZjIgcHJpbWFyeSBkZXZpY2UgdHlwZSAxMC0wMDUwRjIwNC01IGRldmljZSBuYW1lICdkdmRocm0t
bngnIGNvbmZpZyBtZXRob2RzIDB4MTg4ClAyUDogRG8gbm90IHVwZGF0ZSBwZWVyIGVudHJ5IGJh
c2VkIG9uIG9sZCBmcmFtZSAocnhfdGltZT01NDQwMDEuNTAyNzg1IGxhc3Rfc2Vlbj01NDQwMDIu
MTkwMDc0KQpQMlA6IFN0YXRlIFNFQVJDSCAtPiBTRUFSQ0gKUDJQOiBTdGFydGluZyBzaG9ydCBs
aXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgx
MCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkg
ZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFk
aW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlv
IHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpwMnAt
ZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0
ZXIgMC4wMDAwMTIgc2Vjb25kIHdhaXQKbmw4MDIxMTogRW5hYmxlIFByb2JlIFJlcXVlc3QgcmVw
b3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0
MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNoPQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBj
b29raWUgMHgyMGUgZm9yIGZyZXE9MjQzNyBNSHogZHVyYXRpb249MTAyCm5sODAyMTE6IERydiBF
dmVudCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAt
ZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBmcmVx
PTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MTAyIGNvb2tpZT0weDIwZSAobWF0Y2gpKQpw
MnAtZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1j
aGFubmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlv
bl90eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0ZW4gdGltZW91dCgwLDEwMjQwMCkgb24gZnJl
cT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6
IDAuMTIyNDAwIHNlYwpubDgwMjExOiBEcnYgRXZlbnQgNTYgKE5MODAyMTFfQ01EX0NBTkNFTF9S
RU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVt
YWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0xIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBk
dXJhdGlvbj0wIGNvb2tpZT0weDIwZSAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBDQU5D
RUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNlaXZlZApQMlA6IENhbmNlbCByZW1haW4tb24t
Y2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlzdGVuPTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9
KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBk
b25lIGluIDAuMTAxODQzIHNlY29uZHMKUDJQOiBEcml2ZXIgZW5kZWQgTGlzdGVuIHN0YXRlIChm
cmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3RlbiBzaW5jZSBub3QgaW4gbGlzdGVuX29ubHkg
c3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9U0VBUkNIKQpubDgwMjExOiBEaXNhYmxlIFByb2Jl
IFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHg4ODg4ODg4ODhhZTAwZDg5ClAyUDogU3RhcnRp
bmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BTIElFIGZvciBQcm9iZSBSZXF1ZXN0CldQUzogICog
VmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogUmVxdWVzdCBUeXBlCldQUzogICogQ29u
ZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBVVUlELUUKV1BTOiAgKiBQcmltYXJ5IERldmljZSBU
eXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQUzogICogQXNzb2NpYXRpb24gU3RhdGUKV1BTOiAg
KiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpXUFM6ICAqIERldmljZSBQYXNzd29yZCBJRCAoMCkK
V1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0
eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBSZWd1bGF0b3J5IENsYXNz
IDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4
MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVl
IC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKUDJQOiBSdW5uaW5nIHAycF9zY2FuCnAycC1k
ZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgYWZ0ZXIg
MC4wMDAwMTEgc2Vjb25kIHdhaXQKcDJwLWRldi13bGFuMDogbmw4MDIxMTogc2NhbiByZXF1ZXN0
Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sgU3VwcFJhdGVzClNjYW4gcmVxdWVzdGVkIChyZXQ9
MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25kcwpubDgwMjExOiBEcnYgRXZlbnQgMzMgKE5MODAy
MTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13
bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2VyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fU1RB
UlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IE93biBzY2FuIHJlcXVlc3Qgc3RhcnRl
ZCBhIHNjYW4gaW4gMC4wMDAwMjQgc2Vjb25kcwpwMnAtZGV2LXdsYW4wOiBDVFJMLUVWRU5ULVND
QU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2ZW50IDM0IChOTDgwMjExX0NNRF9ORVdfU0NBTl9S
RVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjEx
OiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJsZQpubDgwMjExOiBTY2FuIHByb2JlZCBmb3IgU1NJ
RCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBpbmNsdWRlZCBmcmVxdWVuY2llczogMjQxMiAyNDM3
IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9SRVNVTFRTICgzKSByZWNlaXZlZApwMnAt
ZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAwLjEyMDUzNSBzZWNvbmRzCm5sODAyMTE6IFJl
Y2VpdmVkIHNjYW4gcmVzdWx0cyAoNCBCU1NlcykKcDJwLWRldi13bGFuMDogQlNTOiBTdGFydCBz
Y2FuIHJlc3VsdCB1cGRhdGUgMjUKQlNTOiBsYXN0X3NjYW5fcmVzX3VzZWQ9My8zMgpwMnAtZGV2
LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGRvbmUgaW4gMC4xMjM0ODgg
c2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNlaXZlZCAoNCBCU1MpClAyUDogSWdub3JlIHNj
YW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFy
c2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZv
IG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRh
dGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcg
V1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IFByaW1hcnkgRGV2
aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0
dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBh
YmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDEzIGxlbmd0aCAzMApQMlA6ICogRGV2aWNlIEluZm86
IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6ZjIgcHJpbWFyeSBkZXZpY2UgdHlwZSAxMC0wMDUwRjIwNC01
IGRldmljZSBuYW1lICdkdmRocm0tbngnIGNvbmZpZyBtZXRob2RzIDB4MTg4ClAyUDogRG8gbm90
IHVwZGF0ZSBwZWVyIGVudHJ5IGJhc2VkIG9uIG9sZCBmcmFtZSAocnhfdGltZT01NDQwMDEuNTAy
MzIxIGxhc3Rfc2Vlbj01NDQwMDIuMTkwMDc0KQpQMlA6IFN0YXRlIFNFQVJDSCAtPiBTRUFSQ0gK
UDJQOiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkKV1BTOiAgKiBW
ZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFk
ZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpw
MnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwCnAycC1k
ZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBz
dGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAt
bGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTIgc2Vjb25kIHdhaXQKbmw4MDIxMTogRW5h
YmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5sODAyMTE6IFJl
Z2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNoPQpubDgwMjEx
OiBSZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgyMGYgZm9yIGZyZXE9MjQzNyBNSHogZHVyYXRp
b249MjA0Cm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09OX0NIQU5O
RUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVs
IGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MjA0IGNv
b2tpZT0weDIwZiAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05fQ0hBTk5F
TCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAod2l0aG91
dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0ZW4gdGlt
ZW91dCgwLDIwNDgwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDogU2V0IHRp
bWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAuMjI0ODAwIHNlYwpubDgwMjExOiBCU1MgRXZlbnQgNTkg
KE5MODAyMTFfQ01EX0ZSQU1FKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBS
WCBmcmFtZSBmcmVxPTI0Mzcgc3NpX3NpZ25hbD0tNjggc3R5cGU9NCBsZW49NjYKcDJwLWRldi13
bGFuMDogRXZlbnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkCm5sODAyMTE6IEJTUyBFdmVudCA1OSAo
Tkw4MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJY
IGZyYW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFsPS02NyBzdHlwZT00IGxlbj02NgpwMnAtZGV2LXds
YW4wOiBFdmVudCBSWF9NR01UICgyMCkgcmVjZWl2ZWQKbmw4MDIxMTogQlNTIEV2ZW50IDU5IChO
TDgwMjExX0NNRF9GUkFNRSkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUlgg
ZnJhbWUgZnJlcT0yNDM3IHNzaV9zaWduYWw9LTY0IHN0eXBlPTQgbGVuPTY2CnAycC1kZXYtd2xh
bjA6IEV2ZW50IFJYX01HTVQgKDIwKSByZWNlaXZlZApubDgwMjExOiBCU1MgRXZlbnQgNTkgKE5M
ODAyMTFfQ01EX0ZSQU1FKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSWCBm
cmFtZSBmcmVxPTI0Mzcgc3NpX3NpZ25hbD0tNjUgc3R5cGU9NCBsZW49NjYKcDJwLWRldi13bGFu
MDogRXZlbnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkCm5sODAyMTE6IEJTUyBFdmVudCA1OSAoTkw4
MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJYIGZy
YW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFsPS02NyBzdHlwZT00IGxlbj02NgpwMnAtZGV2LXdsYW4w
OiBFdmVudCBSWF9NR01UICgyMCkgcmVjZWl2ZWQKbmw4MDIxMTogQlNTIEV2ZW50IDU5IChOTDgw
MjExX0NNRF9GUkFNRSkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUlggZnJh
bWUgZnJlcT0yNDM3IHNzaV9zaWduYWw9LTY2IHN0eXBlPTQgbGVuPTY2CnAycC1kZXYtd2xhbjA6
IEV2ZW50IFJYX01HTVQgKDIwKSByZWNlaXZlZApubDgwMjExOiBEcnYgRXZlbnQgNTYgKE5MODAy
MTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xh
bjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0xIGZyZXE9MjQzNyBj
aGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIwZiAobWF0Y2gpKQpwMnAtZGV2LXds
YW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNlaXZlZApQMlA6IENh
bmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlzdGVuPTAgbXMgcGVu
ZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1saXN0
ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMjA0MjA3IHNlY29uZHMKUDJQOiBEcml2ZXIgZW5kZWQg
TGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3RlbiBzaW5jZSBub3Qg
aW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9U0VBUkNIKQpubDgwMjEx
OiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHg4ODg4ODg4ODhhZTAw
ZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BTIElFIGZvciBQcm9iZSBS
ZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogUmVxdWVzdCBU
eXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBVVUlELUUKV1BTOiAgKiBQ
cmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQUzogICogQXNzb2NpYXRp
b24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpXUFM6ICAqIERldmljZSBQ
YXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICogUDJQIElFIGhlYWRlcgpQ
MlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBS
ZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29y
ayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0
ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKUDJQOiBSdW5uaW5n
IHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0Aw
eDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMTAgc2Vjb25kIHdhaXQKcDJwLWRldi13bGFuMDogbmw4MDIx
MTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sgU3VwcFJhdGVzClNjYW4g
cmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25kcwpubDgwMjExOiBEcnYg
RXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2ZWQgZm9yIHAycC1kZXYt
d2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2VyCnAycC1kZXYtd2xhbjA6
IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IE93biBzY2Fu
IHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAwMzUgc2Vjb25kcwpwMnAtZGV2LXdsYW4w
OiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2ZW50IDM0IChOTDgwMjEx
X0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApwMnAtZGV2
LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJsZQpubDgwMjExOiBTY2Fu
IHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBpbmNsdWRlZCBmcmVxdWVu
Y2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9SRVNVTFRTICgz
KSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAwLjEyMDc1MiBzZWNv
bmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoNCBCU1NlcykKcDJwLWRldi13bGFu
MDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgMjYKQlNTOiBsYXN0X3NjYW5fcmVzX3Vz
ZWQ9My8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGRv
bmUgaW4gMC4xMjM3MTAgc2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNlaXZlZCAoNCBCU1Mp
ClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2
aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQg
UDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6
IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJ
ZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQ
MlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5n
IFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0
eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDEzIGxlbmd0aCAzMApQMlA6
ICogRGV2aWNlIEluZm86IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6ZjIgcHJpbWFyeSBkZXZpY2UgdHlw
ZSAxMC0wMDUwRjIwNC01IGRldmljZSBuYW1lICdkdmRocm0tbngnIGNvbmZpZyBtZXRob2RzIDB4
MTg4ClAyUDogRG8gbm90IHVwZGF0ZSBwZWVyIGVudHJ5IGJhc2VkIG9uIG9sZCBmcmFtZSAocnhf
dGltZT01NDQwMDEuNTAyNDg3IGxhc3Rfc2Vlbj01NDQwMDIuMTkwMDc0KQpQMlA6IFN0YXRlIFNF
QVJDSCAtPiBTRUFSQ0gKUDJQOiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVNF
QVJDSCkKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQ
OiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDog
KiBEZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxpc3RlbidA
MHgyNjg0NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVl
dWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyBy
YWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTEgc2Vjb25kIHdh
aXQKbmw4MDIxMTogRW5hYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHgyNjg4
NTAwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgyNjg4NTAw
IG1hdGNoPQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgyMTAgZm9yIGZyZXE9
MjQzNyBNSHogZHVyYXRpb249MTAyCm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIxMV9DTURf
UkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJl
bWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAg
ZHVyYXRpb249MTAyIGNvb2tpZT0weDIxMCAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBS
RU1BSU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFjdGlvbiBj
YWxsYmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQOiBTdGFy
dGluZyBMaXN0ZW4gdGltZW91dCgwLDEwMjQwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9uIGNhbGxi
YWNrClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAuMTIyNDAwIHNlYwpubDgwMjEx
OiBEcnYgRXZlbnQgNTYgKE5MODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVj
ZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQg
KGNhbmNlbD0xIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIx
MCAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwg
KDIyKSByZWNlaXZlZApQMlA6IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJw
X2xvbmdfbGlzdGVuPTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6
IFJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMTAxODYwIHNlY29u
ZHMKUDJQOiBEcml2ZXIgZW5kZWQgTGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBz
dG9wX2xpc3RlbiBzaW5jZSBub3QgaW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91dCAo
c3RhdGU9U0VBUkNIKQpubDgwMjExOiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5s
X3ByZXE9MHg4ODg4ODg4ODhhZTAwZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVpbGRp
bmcgV1BTIElFIGZvciBQcm9iZSBSZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4
MTApCldQUzogICogUmVxdWVzdCBUeXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkKV1BT
OiAgKiBVVUlELUUKV1BTOiAgKiBQcmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYgQmFuZHMg
KDMpCldQUzogICogQXNzb2NpYXRpb24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVycm9y
ICgwKQpXUFM6ICAqIERldmljZSBQYXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQ
MlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQ
OiAqIExpc3RlbiBDaGFubmVsOiBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2
LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4w
OiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1t
ZWRpYXRlbHkKUDJQOiBSdW5uaW5nIHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJh
ZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMTAgc2Vjb25kIHdhaXQK
cDJwLWRldi13bGFuMDogbmw4MDIxMTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAt
IG1hc2sgU3VwcFJhdGVzClNjYW4gcmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAg
c2Vjb25kcwpubDgwMjExOiBEcnYgRXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTikg
cmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogU2NhbiB0
cmlnZ2VyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAy
cC1kZXYtd2xhbjA6IE93biBzY2FuIHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAwMjIg
c2Vjb25kcwpwMnAtZGV2LXdsYW4wOiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIxMTog
RHJ2IEV2ZW50IDM0IChOTDgwMjExX0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBmb3Ig
cDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRzIGF2
YWlsYWJsZQpubDgwMjExOiBTY2FuIHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIxMTog
U2NhbiBpbmNsdWRlZCBmcmVxdWVuY2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFuMDog
RXZlbnQgU0NBTl9SRVNVTFRTICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBs
ZXRlZCBpbiAwLjEyMDQ4NyBzZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAo
NCBCU1NlcykKcDJwLWRldi13bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgMjcK
QlNTOiBsYXN0X3NjYW5fcmVzX3VzZWQ9My8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdw
MnAtc2NhbidAMHgyNjg4NDgwIGRvbmUgaW4gMC4xMjM0Nzcgc2Vjb25kcwpQMlA6IFNjYW4gcmVz
dWx0cyByZWNlaXZlZCAoNCBCU1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBE
ZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25v
cmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQ
OiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNl
IEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1l
dGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAw
NTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAy
UDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmli
dXRlIDEzIGxlbmd0aCAzMApQMlA6ICogRGV2aWNlIEluZm86IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6
ZjIgcHJpbWFyeSBkZXZpY2UgdHlwZSAxMC0wMDUwRjIwNC01IGRldmljZSBuYW1lICdkdmRocm0t
bngnIGNvbmZpZyBtZXRob2RzIDB4MTg4ClAyUDogRG8gbm90IHVwZGF0ZSBwZWVyIGVudHJ5IGJh
c2VkIG9uIG9sZCBmcmFtZSAocnhfdGltZT01NDQwMDEuNTAzMDIwIGxhc3Rfc2Vlbj01NDQwMDIu
MTkwMDc0KQpQMlA6IFN0YXRlIFNFQVJDSCAtPiBTRUFSQ0gKUDJQOiBTdGFydGluZyBzaG9ydCBs
aXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgx
MCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkg
ZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFk
aW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlv
IHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpwMnAt
ZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0
ZXIgMC4wMDAwMTIgc2Vjb25kIHdhaXQKbmw4MDIxMTogRW5hYmxlIFByb2JlIFJlcXVlc3QgcmVw
b3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0
MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNoPQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBj
b29raWUgMHgyMTEgZm9yIGZyZXE9MjQzNyBNSHogZHVyYXRpb249MjA0Cm5sODAyMTE6IERydiBF
dmVudCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAt
ZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBmcmVx
PTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MjA0IGNvb2tpZT0weDIxMSAobWF0Y2gpKQpw
MnAtZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1j
aGFubmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlv
bl90eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0ZW4gdGltZW91dCgwLDIwNDgwMCkgb24gZnJl
cT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6
IDAuMjI0ODAwIHNlYwpubDgwMjExOiBEcnYgRXZlbnQgNTYgKE5MODAyMTFfQ01EX0NBTkNFTF9S
RU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVt
YWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0xIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBk
dXJhdGlvbj0wIGNvb2tpZT0weDIxMSAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBDQU5D
RUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNlaXZlZApQMlA6IENhbmNlbCByZW1haW4tb24t
Y2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlzdGVuPTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9
KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBk
b25lIGluIDAuMjA0MjYxIHNlY29uZHMKUDJQOiBEcml2ZXIgZW5kZWQgTGlzdGVuIHN0YXRlIChm
cmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3RlbiBzaW5jZSBub3QgaW4gbGlzdGVuX29ubHkg
c3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9U0VBUkNIKQpubDgwMjExOiBEaXNhYmxlIFByb2Jl
IFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHg4ODg4ODg4ODhhZTAwZDg5ClAyUDogU3RhcnRp
bmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BTIElFIGZvciBQcm9iZSBSZXF1ZXN0CldQUzogICog
VmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogUmVxdWVzdCBUeXBlCldQUzogICogQ29u
ZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBVVUlELUUKV1BTOiAgKiBQcmltYXJ5IERldmljZSBU
eXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQUzogICogQXNzb2NpYXRpb24gU3RhdGUKV1BTOiAg
KiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpXUFM6ICAqIERldmljZSBQYXNzd29yZCBJRCAoMCkK
V1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0
eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBSZWd1bGF0b3J5IENsYXNz
IDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4
MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVl
IC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKUDJQOiBSdW5uaW5nIHAycF9zY2FuCnAycC1k
ZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgYWZ0ZXIg
MC4wMDAwMjEgc2Vjb25kIHdhaXQKcDJwLWRldi13bGFuMDogbmw4MDIxMTogc2NhbiByZXF1ZXN0
Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sgU3VwcFJhdGVzClNjYW4gcmVxdWVzdGVkIChyZXQ9
MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25kcwpubDgwMjExOiBEcnYgRXZlbnQgMzMgKE5MODAy
MTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13
bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2VyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fU1RB
UlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IE93biBzY2FuIHJlcXVlc3Qgc3RhcnRl
ZCBhIHNjYW4gaW4gMC4wMDAwMzYgc2Vjb25kcwpwMnAtZGV2LXdsYW4wOiBDVFJMLUVWRU5ULVND
QU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2ZW50IDM0IChOTDgwMjExX0NNRF9ORVdfU0NBTl9S
RVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjEx
OiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJsZQpubDgwMjExOiBTY2FuIHByb2JlZCBmb3IgU1NJ
RCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBpbmNsdWRlZCBmcmVxdWVuY2llczogMjQxMiAyNDM3
IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9SRVNVTFRTICgzKSByZWNlaXZlZApwMnAt
ZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAwLjEyMDQyNCBzZWNvbmRzCm5sODAyMTE6IFJl
Y2VpdmVkIHNjYW4gcmVzdWx0cyAoNCBCU1NlcykKcDJwLWRldi13bGFuMDogQlNTOiBTdGFydCBz
Y2FuIHJlc3VsdCB1cGRhdGUgMjgKQlNTOiBsYXN0X3NjYW5fcmVzX3VzZWQ9My8zMgpwMnAtZGV2
LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGRvbmUgaW4gMC4xMjM0NjEg
c2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNlaXZlZCAoNCBCU1MpClAyUDogSWdub3JlIHNj
YW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFy
c2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZv
IG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRh
dGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcg
V1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IFByaW1hcnkgRGV2
aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0
dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBh
YmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDEzIGxlbmd0aCAzMApQMlA6ICogRGV2aWNlIEluZm86
IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6ZjIgcHJpbWFyeSBkZXZpY2UgdHlwZSAxMC0wMDUwRjIwNC01
IGRldmljZSBuYW1lICdkdmRocm0tbngnIGNvbmZpZyBtZXRob2RzIDB4MTg4ClAyUDogRG8gbm90
IHVwZGF0ZSBwZWVyIGVudHJ5IGJhc2VkIG9uIG9sZCBmcmFtZSAocnhfdGltZT01NDQwMDEuNTAy
OTI3IGxhc3Rfc2Vlbj01NDQwMDIuMTkwMDc0KQpQMlA6IFN0YXRlIFNFQVJDSCAtPiBTRUFSQ0gK
UDJQOiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkKV1BTOiAgKiBW
ZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFk
ZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpw
MnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwCnAycC1k
ZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBz
dGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAt
bGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTEgc2Vjb25kIHdhaXQKbmw4MDIxMTogRW5h
YmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5sODAyMTE6IFJl
Z2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNoPQpubDgwMjEx
OiBSZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgyMTIgZm9yIGZyZXE9MjQzNyBNSHogZHVyYXRp
b249MTAyCm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09OX0NIQU5O
RUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVs
IGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MTAyIGNv
b2tpZT0weDIxMiAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05fQ0hBTk5F
TCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAod2l0aG91
dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0ZW4gdGlt
ZW91dCgwLDEwMjQwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDogU2V0IHRp
bWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAuMTIyNDAwIHNlYwpubDgwMjExOiBEcnYgRXZlbnQgNTYg
KE5MODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1k
ZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0xIGZyZXE9
MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIxMiAobWF0Y2gpKQpwMnAt
ZGV2LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNlaXZlZApQ
MlA6IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlzdGVuPTAg
bXMgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3Ay
cC1saXN0ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMTAxODMzIHNlY29uZHMKUDJQOiBEcml2ZXIg
ZW5kZWQgTGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3RlbiBzaW5j
ZSBub3QgaW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9U0VBUkNIKQpu
bDgwMjExOiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHg4ODg4ODg4
ODhhZTAwZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BTIElFIGZvciBQ
cm9iZSBSZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogUmVx
dWVzdCBUeXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBVVUlELUUKV1BT
OiAgKiBQcmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQUzogICogQXNz
b2NpYXRpb24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpXUFM6ICAqIERl
dmljZSBQYXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICogUDJQIElFIGhl
YWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExpc3RlbiBDaGFu
bmVsOiBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4wOiBBZGQgcmFk
aW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3
b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKUDJQOiBS
dW5uaW5nIHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1z
Y2FuJ0AweDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMTAgc2Vjb25kIHdhaXQKcDJwLWRldi13bGFuMDog
bmw4MDIxMTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sgU3VwcFJhdGVz
ClNjYW4gcmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25kcwpubDgwMjEx
OiBEcnYgRXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2ZWQgZm9yIHAy
cC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2VyCnAycC1kZXYt
d2xhbjA6IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IE93
biBzY2FuIHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAwMjUgc2Vjb25kcwpwMnAtZGV2
LXdsYW4wOiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2ZW50IDM0IChO
TDgwMjExX0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApw
MnAtZGV2LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJsZQpubDgwMjEx
OiBTY2FuIHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBpbmNsdWRlZCBm
cmVxdWVuY2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9SRVNV
TFRTICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAwLjEyMDQ3
NCBzZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoNCBCU1NlcykKcDJwLWRl
di13bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgMjkKQlNTOiBsYXN0X3NjYW5f
cmVzX3VzZWQ9My8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4
NDgwIGRvbmUgaW4gMC4xMjM0NDAgc2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNlaXZlZCAo
NCBCU1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQ
MlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdp
dGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJ
RQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERl
dmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4
NDM4OApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQ
YXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2Fw
YWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDEzIGxlbmd0aCAz
MApQMlA6ICogRGV2aWNlIEluZm86IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6ZjIgcHJpbWFyeSBkZXZp
Y2UgdHlwZSAxMC0wMDUwRjIwNC01IGRldmljZSBuYW1lICdkdmRocm0tbngnIGNvbmZpZyBtZXRo
b2RzIDB4MTg4ClAyUDogRG8gbm90IHVwZGF0ZSBwZWVyIGVudHJ5IGJhc2VkIG9uIG9sZCBmcmFt
ZSAocnhfdGltZT01NDQwMDEuNTAyMzIzIGxhc3Rfc2Vlbj01NDQwMDIuMTkwMDc0KQpQMlA6IFN0
YXRlIFNFQVJDSCAtPiBTRUFSQ0gKUDJQOiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0
YXRlPVNFQVJDSCkKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlE
LUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAw
ClAyUDogKiBEZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxp
c3RlbidAMHgyNjg0NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0
aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFy
dGluZyByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTEgc2Vj
b25kIHdhaXQKbmw4MDIxMTogRW5hYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9
MHgyNjg4NTAwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgy
Njg4NTAwIG1hdGNoPQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgyMTMgZm9y
IGZyZXE9MjQzNyBNSHogZHVyYXRpb249MjA0Cm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIx
MV9DTURfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAy
MTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90
eXBlPTAgZHVyYXRpb249MjA0IGNvb2tpZT0weDIxMyAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBF
dmVudCBSRU1BSU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFj
dGlvbiBjYWxsYmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQ
OiBTdGFydGluZyBMaXN0ZW4gdGltZW91dCgwLDIwNDgwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9u
IGNhbGxiYWNrClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAuMjI0ODAwIHNlYwpu
bDgwMjExOiBEcnYgRXZlbnQgNTYgKE5MODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5F
TCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwg
ZXZlbnQgKGNhbmNlbD0xIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tp
ZT0weDIxMyAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NI
QU5ORUwgKDIyKSByZWNlaXZlZApQMlA6IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFj
ayAocDJwX2xvbmdfbGlzdGVuPTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYt
d2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMjA0MjM0
IHNlY29uZHMKUDJQOiBEcml2ZXIgZW5kZWQgTGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDog
U2tpcCBzdG9wX2xpc3RlbiBzaW5jZSBub3QgaW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGlt
ZW91dCAoc3RhdGU9U0VBUkNIKQpubDgwMjExOiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0
aW5nIG5sX3ByZXE9MHg4ODg4ODg4ODhhZTAwZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzog
QnVpbGRpbmcgV1BTIElFIGZvciBQcm9iZSBSZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNv
ZGVkIDB4MTApCldQUzogICogUmVxdWVzdCBUeXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0
OCkKV1BTOiAgKiBVVUlELUUKV1BTOiAgKiBQcmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYg
QmFuZHMgKDMpCldQUzogICogQXNzb2NpYXRpb24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9u
IEVycm9yICgwKQpXUFM6ICAqIERldmljZSBQYXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2Ug
TmFtZQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9
MDAKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpw
MnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2
LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3Rh
cnQgaW1tZWRpYXRlbHkKUDJQOiBSdW5uaW5nIHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0
aW5nIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMTQgc2Vjb25k
IHdhaXQKcDJwLWRldi13bGFuMDogbmw4MDIxMTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBw
cm9iZSAtIG1hc2sgU3VwcFJhdGVzClNjYW4gcmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVv
dXQgMzAgc2Vjb25kcwpubDgwMjExOiBEcnYgRXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJf
U0NBTikgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTog
U2NhbiB0cmlnZ2VyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2Vp
dmVkCnAycC1kZXYtd2xhbjA6IE93biBzY2FuIHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4w
MDAwMjYgc2Vjb25kcwpwMnAtZGV2LXdsYW4wOiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4
MDIxMTogRHJ2IEV2ZW50IDM0IChOTDgwMjExX0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZl
ZCBmb3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1
bHRzIGF2YWlsYWJsZQpubDgwMjExOiBTY2FuIHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4
MDIxMTogU2NhbiBpbmNsdWRlZCBmcmVxdWVuY2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13
bGFuMDogRXZlbnQgU0NBTl9SRVNVTFRTICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2Fu
IGNvbXBsZXRlZCBpbiAwLjEyMDU0NiBzZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVz
dWx0cyAoNCBCU1NlcykKcDJwLWRldi13bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRh
dGUgMzAKQlNTOiBsYXN0X3NjYW5fcmVzX3VzZWQ9My8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3
b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGRvbmUgaW4gMC4xMjM0OTMgc2Vjb25kcwpQMlA6IFNj
YW4gcmVzdWx0cyByZWNlaXZlZCAoNCBCU1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0
IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQ
OiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2Ug
SWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAg
RGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29u
ZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6
IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0
aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDog
QXR0cmlidXRlIDEzIGxlbmd0aCAzMApQMlA6ICogRGV2aWNlIEluZm86IGFkZHIgMTI6Njg6M2Y6
NGU6Mzk6ZjIgcHJpbWFyeSBkZXZpY2UgdHlwZSAxMC0wMDUwRjIwNC01IGRldmljZSBuYW1lICdk
dmRocm0tbngnIGNvbmZpZyBtZXRob2RzIDB4MTg4ClAyUDogRG8gbm90IHVwZGF0ZSBwZWVyIGVu
dHJ5IGJhc2VkIG9uIG9sZCBmcmFtZSAocnhfdGltZT01NDQwMDEuNTAyMjQ4IGxhc3Rfc2Vlbj01
NDQwMDIuMTkwMDc0KQpQMlA6IFN0YXRlIFNFQVJDSCAtPiBTRUFSQ0gKUDJQOiBTdGFydGluZyBz
aG9ydCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29k
ZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFi
aWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBB
ZGQgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0
IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVs
eQpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0
NjAgYWZ0ZXIgMC4wMDAwMTIgc2Vjb25kIHdhaXQKbmw4MDIxMTogRW5hYmxlIFByb2JlIFJlcXVl
c3QgcmVwb3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5
cGU9MHg0MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNoPQpubDgwMjExOiBSZW1haW4tb24tY2hh
bm5lbCBjb29raWUgMHgyMTQgZm9yIGZyZXE9MjQzNyBNSHogZHVyYXRpb249MTAyCm5sODAyMTE6
IERydiBFdmVudCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZv
ciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9
MCBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MTAyIGNvb2tpZT0weDIxNCAobWF0
Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVk
Ck9mZi1jaGFubmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5n
X2FjdGlvbl90eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0ZW4gdGltZW91dCgwLDEwMjQwMCkg
b24gZnJlcT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVNF
QVJDSCk6IDAuMTIyNDAwIHNlYwpubDgwMjExOiBEcnYgRXZlbnQgNTYgKE5MODAyMTFfQ01EX0NB
TkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIx
MTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0xIGZyZXE9MjQzNyBjaGFubmVsX3R5
cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIxNCAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVu
dCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNlaXZlZApQMlA6IENhbmNlbCByZW1h
aW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlzdGVuPTAgbXMgcGVuZGluZ19hY3Rp
b25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4
NDQ2MCBkb25lIGluIDAuMTAxODUxIHNlY29uZHMKUDJQOiBEcml2ZXIgZW5kZWQgTGlzdGVuIHN0
YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3RlbiBzaW5jZSBub3QgaW4gbGlzdGVu
X29ubHkgc3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9U0VBUkNIKQpubDgwMjExOiBEaXNhYmxl
IFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHg4ODg4ODg4ODhhZTAwZDg5ClAyUDog
U3RhcnRpbmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BTIElFIGZvciBQcm9iZSBSZXF1ZXN0CldQ
UzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogUmVxdWVzdCBUeXBlCldQUzog
ICogQ29uZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBVVUlELUUKV1BTOiAgKiBQcmltYXJ5IERl
dmljZSBUeXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQUzogICogQXNzb2NpYXRpb24gU3RhdGUK
V1BTOiAgKiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpXUFM6ICAqIERldmljZSBQYXNzd29yZCBJ
RCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2Fw
YWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBSZWd1bGF0b3J5
IENsYXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLXNj
YW4nQDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhl
IHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKUDJQOiBSdW5uaW5nIHAycF9zY2Fu
CnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAg
YWZ0ZXIgMC4wMDAwMTEgc2Vjb25kIHdhaXQKcDJwLWRldi13bGFuMDogbmw4MDIxMTogc2NhbiBy
ZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sgU3VwcFJhdGVzClNjYW4gcmVxdWVzdGVk
IChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25kcwpubDgwMjExOiBEcnYgRXZlbnQgMzMg
KE5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJw
LWRldi13bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2VyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFND
QU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IE93biBzY2FuIHJlcXVlc3Qg
c3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAwMjQgc2Vjb25kcwpwMnAtZGV2LXdsYW4wOiBDVFJMLUVW
RU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2ZW50IDM0IChOTDgwMjExX0NNRF9ORVdf
U0NBTl9SRVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBu
bDgwMjExOiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJsZQpubDgwMjExOiBTY2FuIHByb2JlZCBm
b3IgU1NJRCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBpbmNsdWRlZCBmcmVxdWVuY2llczogMjQx
MiAyNDM3IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9SRVNVTFRTICgzKSByZWNlaXZl
ZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAwLjEyMDU1NiBzZWNvbmRzCm5sODAy
MTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoNCBCU1NlcykKcDJwLWRldi13bGFuMDogQlNTOiBT
dGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgMzEKQlNTOiBsYXN0X3NjYW5fcmVzX3VzZWQ9My8zMgpw
MnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGRvbmUgaW4gMC4x
MjM0NDMgc2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNlaXZlZCAoNCBCU1MpClAyUDogSWdu
b3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAy
UDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmlj
ZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBz
Y2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBh
cnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IFByaW1h
cnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQ
MlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91
cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDEzIGxlbmd0aCAzMApQMlA6ICogRGV2aWNl
IEluZm86IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6ZjIgcHJpbWFyeSBkZXZpY2UgdHlwZSAxMC0wMDUw
RjIwNC01IGRldmljZSBuYW1lICdkdmRocm0tbngnIGNvbmZpZyBtZXRob2RzIDB4MTg4ClAyUDog
U3RhdGUgU0VBUkNIIC0+IFNFQVJDSApQMlA6IFN0YXJ0aW5nIHNob3J0IGxpc3RlbiBzdGF0ZSAo
c3RhdGU9U0VBUkNIKQpXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVV
SUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9
MDAKUDJQOiAqIERldmljZSBJbmZvCnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3JrICdwMnAt
bGlzdGVuJ0AweDI2ODQ0NjAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29yayBpdGVtIGlu
IHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5CnAycC1kZXYtd2xhbjA6IFN0
YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBhZnRlciAwLjAwMDAxMiBz
ZWNvbmQgd2FpdApubDgwMjExOiBFbmFibGUgUHJvYmUgUmVxdWVzdCByZXBvcnRpbmcgbmxfcHJl
cT0weDI2ODg1MDAKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUgdHlwZT0weDQwIG5sX2hhbmRsZT0w
eDI2ODg1MDAgbWF0Y2g9Cm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGNvb2tpZSAweDIxNSBm
b3IgZnJlcT0yNDM3IE1IeiBkdXJhdGlvbj0yMDQKbmw4MDIxMTogRHJ2IEV2ZW50IDU1IChOTDgw
MjExX0NNRF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4
MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0wIGZyZXE9MjQzNyBjaGFubmVs
X3R5cGU9MCBkdXJhdGlvbj0yMDQgY29va2llPTB4MjE1IChtYXRjaCkpCnAycC1kZXYtd2xhbjA6
IEV2ZW50IFJFTUFJTl9PTl9DSEFOTkVMICgyMSkgcmVjZWl2ZWQKT2ZmLWNoYW5uZWw6IFNlbmQg
QWN0aW9uIGNhbGxiYWNrICh3aXRob3V0X3JvYz0wIHBlbmRpbmdfYWN0aW9uX3R4PShuaWwpKQpQ
MlA6IFN0YXJ0aW5nIExpc3RlbiB0aW1lb3V0KDAsMjA0ODAwKSBvbiBmcmVxPTI0MzcgYmFzZWQg
b24gY2FsbGJhY2sKUDJQOiBTZXQgdGltZW91dCAoc3RhdGU9U0VBUkNIKTogMC4yMjQ4MDAgc2Vj
Cm5sODAyMTE6IERydiBFdmVudCA1NiAoTkw4MDIxMV9DTURfQ0FOQ0VMX1JFTUFJTl9PTl9DSEFO
TkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSZW1haW4tb24tY2hhbm5l
bCBldmVudCAoY2FuY2VsPTEgZnJlcT0yNDM3IGNoYW5uZWxfdHlwZT0wIGR1cmF0aW9uPTAgY29v
a2llPTB4MjE1IChtYXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50IENBTkNFTF9SRU1BSU5fT05f
Q0hBTk5FTCAoMjIpIHJlY2VpdmVkClAyUDogQ2FuY2VsIHJlbWFpbi1vbi1jaGFubmVsIGNhbGxi
YWNrIChwMnBfbG9uZ19saXN0ZW49MCBtcyBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKcDJwLWRl
di13bGFuMDogUmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwIGRvbmUgaW4gMC4yMDQy
NzAgc2Vjb25kcwpQMlA6IERyaXZlciBlbmRlZCBMaXN0ZW4gc3RhdGUgKGZyZXE9MjQzNykKUDJQ
OiBTa2lwIHN0b3BfbGlzdGVuIHNpbmNlIG5vdCBpbiBsaXN0ZW5fb25seSBzdGF0ZS4KUDJQOiBU
aW1lb3V0IChzdGF0ZT1TRUFSQ0gpCm5sODAyMTE6IERpc2FibGUgUHJvYmUgUmVxdWVzdCByZXBv
cnRpbmcgbmxfcHJlcT0weDg4ODg4ODg4OGFlMDBkODkKUDJQOiBTdGFydGluZyBzZWFyY2gKV1BT
OiBCdWlsZGluZyBXUFMgSUUgZm9yIFByb2JlIFJlcXVlc3QKV1BTOiAgKiBWZXJzaW9uIChoYXJk
Y29kZWQgMHgxMCkKV1BTOiAgKiBSZXF1ZXN0IFR5cGUKV1BTOiAgKiBDb25maWcgTWV0aG9kcyAo
MTQ4KQpXUFM6ICAqIFVVSUQtRQpXUFM6ICAqIFByaW1hcnkgRGV2aWNlIFR5cGUKV1BTOiAgKiBS
RiBCYW5kcyAoMykKV1BTOiAgKiBBc3NvY2lhdGlvbiBTdGF0ZQpXUFM6ICAqIENvbmZpZ3VyYXRp
b24gRXJyb3IgKDApCldQUzogICogRGV2aWNlIFBhc3N3b3JkIElEICgwKQpXUFM6ICAqIERldmlj
ZSBOYW1lClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91
cD0wMApQMlA6ICogTGlzdGVuIENoYW5uZWw6IFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCA2
CnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwCnAycC1k
ZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBz
dGFydCBpbW1lZGlhdGVseQpQMlA6IFJ1bm5pbmcgcDJwX3NjYW4KcDJwLWRldi13bGFuMDogU3Rh
cnRpbmcgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MCBhZnRlciAwLjAwMDAxMCBzZWNv
bmQgd2FpdApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBzY2FuIHJlcXVlc3QKbmw4MDIxMTogUDJQ
IHByb2JlIC0gbWFzayBTdXBwUmF0ZXMKU2NhbiByZXF1ZXN0ZWQgKHJldD0wKSAtIHNjYW4gdGlt
ZW91dCAzMCBzZWNvbmRzCm5sODAyMTE6IERydiBFdmVudCAzMyAoTkw4MDIxMV9DTURfVFJJR0dF
Ul9TQ0FOKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjEx
OiBTY2FuIHRyaWdnZXIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9TVEFSVEVEICg0OSkgcmVj
ZWl2ZWQKcDJwLWRldi13bGFuMDogT3duIHNjYW4gcmVxdWVzdCBzdGFydGVkIGEgc2NhbiBpbiAw
LjAwMDAyMyBzZWNvbmRzCnAycC1kZXYtd2xhbjA6IENUUkwtRVZFTlQtU0NBTi1TVEFSVEVEIApu
bDgwMjExOiBEcnYgRXZlbnQgMzQgKE5MODAyMTFfQ01EX05FV19TQ0FOX1JFU1VMVFMpIHJlY2Vp
dmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IE5ldyBzY2FuIHJl
c3VsdHMgYXZhaWxhYmxlCm5sODAyMTE6IFNjYW4gcHJvYmVkIGZvciBTU0lEICdESVJFQ1QtJwpu
bDgwMjExOiBTY2FuIGluY2x1ZGVkIGZyZXF1ZW5jaWVzOiAyNDEyIDI0MzcgMjQ2MgpwMnAtZGV2
LXdsYW4wOiBFdmVudCBTQ0FOX1JFU1VMVFMgKDMpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IFNj
YW4gY29tcGxldGVkIGluIDAuMTIwNTM3IHNlY29uZHMKbmw4MDIxMTogUmVjZWl2ZWQgc2NhbiBy
ZXN1bHRzICg0IEJTU2VzKQpwMnAtZGV2LXdsYW4wOiBCU1M6IFN0YXJ0IHNjYW4gcmVzdWx0IHVw
ZGF0ZSAzMgpCU1M6IGxhc3Rfc2Nhbl9yZXNfdXNlZD0zLzMyCnAycC1kZXYtd2xhbjA6IFJhZGlv
IHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgZG9uZSBpbiAwLjEyMzQ3NyBzZWNvbmRzClAyUDog
U2NhbiByZXN1bHRzIHJlY2VpdmVkICg0IEJTUykKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhv
dXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQ
MlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmlj
ZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAy
UCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBD
b25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BT
KTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVu
Z3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQ
OiBBdHRyaWJ1dGUgMTMgbGVuZ3RoIDMwClAyUDogKiBEZXZpY2UgSW5mbzogYWRkciAxMjo2ODoz
Zjo0ZTozOTpmMiBwcmltYXJ5IGRldmljZSB0eXBlIDEwLTAwNTBGMjA0LTUgZGV2aWNlIG5hbWUg
J2R2ZGhybS1ueCcgY29uZmlnIG1ldGhvZHMgMHgxODgKUDJQOiBEbyBub3QgdXBkYXRlIHBlZXIg
ZW50cnkgYmFzZWQgb24gb2xkIGZyYW1lIChyeF90aW1lPTU0NDAwNC4zNDY2NTMgbGFzdF9zZWVu
PTU0NDAwNC4zNDY3NzMpClAyUDogU3RhdGUgU0VBUkNIIC0+IFNFQVJDSApQMlA6IFN0YXJ0aW5n
IHNob3J0IGxpc3RlbiBzdGF0ZSAoc3RhdGU9U0VBUkNIKQpXUFM6ICAqIFZlcnNpb24gKGhhcmRj
b2RlZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2Fw
YWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCnAycC1kZXYtd2xhbjA6
IEFkZCByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAKcDJwLWRldi13bGFuMDogRmly
c3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0
ZWx5CnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4
NDQ2MCBhZnRlciAwLjAwMDAxMiBzZWNvbmQgd2FpdApubDgwMjExOiBFbmFibGUgUHJvYmUgUmVx
dWVzdCByZXBvcnRpbmcgbmxfcHJlcT0weDI2ODg1MDAKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUg
dHlwZT0weDQwIG5sX2hhbmRsZT0weDI2ODg1MDAgbWF0Y2g9Cm5sODAyMTE6IFJlbWFpbi1vbi1j
aGFubmVsIGNvb2tpZSAweDIxNiBmb3IgZnJlcT0yNDM3IE1IeiBkdXJhdGlvbj0zMDcKbmw4MDIx
MTogRHJ2IEV2ZW50IDU1IChOTDgwMjExX0NNRF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQg
Zm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNl
bD0wIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0zMDcgY29va2llPTB4MjE2ICht
YXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50IFJFTUFJTl9PTl9DSEFOTkVMICgyMSkgcmVjZWl2
ZWQKT2ZmLWNoYW5uZWw6IFNlbmQgQWN0aW9uIGNhbGxiYWNrICh3aXRob3V0X3JvYz0wIHBlbmRp
bmdfYWN0aW9uX3R4PShuaWwpKQpQMlA6IFN0YXJ0aW5nIExpc3RlbiB0aW1lb3V0KDAsMzA3MjAw
KSBvbiBmcmVxPTI0MzcgYmFzZWQgb24gY2FsbGJhY2sKUDJQOiBTZXQgdGltZW91dCAoc3RhdGU9
U0VBUkNIKTogMC4zMjcyMDAgc2VjCm5sODAyMTE6IEJTUyBFdmVudCA1OSAoTkw4MDIxMV9DTURf
RlJBTUUpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJYIGZyYW1lIGZyZXE9
MjQzNyBzc2lfc2lnbmFsPS0yNyBzdHlwZT00IGxlbj0yMTcKcDJwLWRldi13bGFuMDogRXZlbnQg
UlhfTUdNVCAoMjApIHJlY2VpdmVkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0
aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFy
eSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAy
UDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3Vw
IENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENo
YW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJl
ciA2ClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4
ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BT
KTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVu
Z3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQ
OiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUo
MHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUmVwbHkgdG8g
UDJQIFByb2JlIFJlcXVlc3QgaW4gTGlzdGVuIHN0YXRlCldQUzogICogVmVyc2lvbiAoaGFyZGNv
ZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBh
YmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8Kbmw4MDIxMTogc2VuZF9t
bG1lIC0gbm9hY2s9MSBmcmVxPTAgbm9fY2NrPTAgb2ZmY2hhbm9rPTAgd2FpdF90aW1lPTAgZmM9
MHg1MCBubG1vZGU9MTAKbmw4MDIxMTogVXNlIGxhc3RfbWdtdF9mcmVxPTI0MzcKbmw4MDIxMTog
QlNTIEV2ZW50IDU5IChOTDgwMjExX0NNRF9GUkFNRSkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xh
bjAKbmw4MDIxMTogUlggZnJhbWUgZnJlcT0yNDM3IHNzaV9zaWduYWw9LTI3IHN0eXBlPTQgbGVu
PTIxNwpwMnAtZGV2LXdsYW4wOiBFdmVudCBSWF9NR01UICgyMCkgcmVjZWl2ZWQKUDJQOiBQYXJz
aW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZpY2Ug
UGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIw
NC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICog
RGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2
IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1bGF0
b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENv
bmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQ
OiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQ
MlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkg
MjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBM
aXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5u
ZWwgTnVtYmVyIDYKUDJQOiBSZXBseSB0byBQMlAgUHJvYmUgUmVxdWVzdCBpbiBMaXN0ZW4gc3Rh
dGUKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAq
IFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBE
ZXZpY2UgSW5mbwpubDgwMjExOiBzZW5kX21sbWUgLSBub2Fjaz0xIGZyZXE9MCBub19jY2s9MCBv
ZmZjaGFub2s9MCB3YWl0X3RpbWU9MCBmYz0weDUwIG5sbW9kZT0xMApubDgwMjExOiBVc2UgbGFz
dF9tZ210X2ZyZXE9MjQzNwpubDgwMjExOiBCU1MgRXZlbnQgNTkgKE5MODAyMTFfQ01EX0ZSQU1F
KSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSWCBmcmFtZSBmcmVxPTI0Mzcg
c3NpX3NpZ25hbD0tMjcgc3R5cGU9NCBsZW49MjE3CnAycC1kZXYtd2xhbjA6IEV2ZW50IFJYX01H
TVQgKDIwKSByZWNlaXZlZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMg
KFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2
aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0
dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBh
YmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVs
OiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQ
MlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6
IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEw
LTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAy
ClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0
cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQp
IFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFJlcGx5IHRvIFAyUCBQ
cm9iZSBSZXF1ZXN0IGluIExpc3RlbiBzdGF0ZQpXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAw
eDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0
eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCm5sODAyMTE6IHNlbmRfbWxtZSAt
IG5vYWNrPTEgZnJlcT0wIG5vX2Njaz0wIG9mZmNoYW5vaz0wIHdhaXRfdGltZT0wIGZjPTB4NTAg
bmxtb2RlPTEwCm5sODAyMTE6IFVzZSBsYXN0X21nbXRfZnJlcT0yNDM3Cm5sODAyMTE6IEJTUyBF
dmVudCA1OSAoTkw4MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5s
ODAyMTE6IFJYIGZyYW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFsPS0yNyBzdHlwZT00IGxlbj0yMTcK
cDJwLWRldi13bGFuMDogRXZlbnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkClAyUDogUGFyc2luZyBX
UFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3
b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQ
MlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmlj
ZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5n
dGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBD
bGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcg
TWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJp
bWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElF
ClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdy
b3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVu
IENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51
bWJlciA2ClAyUDogUmVwbHkgdG8gUDJQIFByb2JlIFJlcXVlc3QgaW4gTGlzdGVuIHN0YXRlCldQ
UzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAg
SUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNl
IEluZm8Kbmw4MDIxMTogc2VuZF9tbG1lIC0gbm9hY2s9MSBmcmVxPTAgbm9fY2NrPTAgb2ZmY2hh
bm9rPTAgd2FpdF90aW1lPTAgZmM9MHg1MCBubG1vZGU9MTAKbmw4MDIxMTogVXNlIGxhc3RfbWdt
dF9mcmVxPTI0MzcKbmw4MDIxMTogQlNTIEV2ZW50IDU5IChOTDgwMjExX0NNRF9GUkFNRSkgcmVj
ZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUlggZnJhbWUgZnJlcT0yNDM3IHNzaV9z
aWduYWw9LTI3IHN0eXBlPTQgbGVuPTIxNwpwMnAtZGV2LXdsYW4wOiBFdmVudCBSWF9NR01UICgy
MCkgcmVjZWl2ZWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMp
OiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBU
eXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1
dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0
eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291
bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBQ
YXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZp
Y2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUw
RjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6
ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0
ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1
bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBSZXBseSB0byBQMlAgUHJvYmUg
UmVxdWVzdCBpbiBMaXN0ZW4gc3RhdGUKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkK
V1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2
PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpubDgwMjExOiBzZW5kX21sbWUgLSBub2Fj
az0xIGZyZXE9MCBub19jY2s9MCBvZmZjaGFub2s9MCB3YWl0X3RpbWU9MCBmYz0weDUwIG5sbW9k
ZT0xMApubDgwMjExOiBVc2UgbGFzdF9tZ210X2ZyZXE9MjQzNwpubDgwMjExOiBEcnYgRXZlbnQg
NTYgKE5MODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAy
cC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0xIGZy
ZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIxNiAobWF0Y2gpKQpw
MnAtZGV2LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNlaXZl
ZApQMlA6IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlzdGVu
PTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsg
J3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMzA2NjE2IHNlY29uZHMKUDJQOiBEcml2
ZXIgZW5kZWQgTGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3RlbiBz
aW5jZSBub3QgaW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9U0VBUkNI
KQpubDgwMjExOiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHg4ODg4
ODg4ODhhZTAwZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BTIElFIGZv
ciBQcm9iZSBSZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICog
UmVxdWVzdCBUeXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBVVUlELUUK
V1BTOiAgKiBQcmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQUzogICog
QXNzb2NpYXRpb24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpXUFM6ICAq
IERldmljZSBQYXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICogUDJQIElF
IGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExpc3RlbiBD
aGFubmVsOiBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4wOiBBZGQg
cmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRp
byB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKUDJQ
OiBSdW5uaW5nIHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3Ay
cC1zY2FuJ0AweDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMTAgc2Vjb25kIHdhaXQKcDJwLWRldi13bGFu
MDogbmw4MDIxMTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sgU3VwcFJh
dGVzClNjYW4gcmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25kcwpubDgw
MjExOiBEcnYgRXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2ZWQgZm9y
IHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2VyCnAycC1k
ZXYtd2xhbjA6IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6
IE93biBzY2FuIHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAwMjQgc2Vjb25kcwpwMnAt
ZGV2LXdsYW4wOiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2ZW50IDM0
IChOTDgwMjExX0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFu
MApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJsZQpubDgw
MjExOiBTY2FuIHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBpbmNsdWRl
ZCBmcmVxdWVuY2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9S
RVNVTFRTICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAwLjEy
MDUzMCBzZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoNCBCU1NlcykKcDJw
LWRldi13bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgMzMKQlNTOiBsYXN0X3Nj
YW5fcmVzX3VzZWQ9My8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidAMHgy
Njg4NDgwIGRvbmUgaW4gMC4xMjM1MDYgc2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNlaXZl
ZCAoNCBCU1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBv
ciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRh
IHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQ
UyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQ
IERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6
IDB4NDM4OApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQ
OiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2Ug
Q2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDEzIGxlbmd0
aCAzMApQMlA6ICogRGV2aWNlIEluZm86IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6ZjIgcHJpbWFyeSBk
ZXZpY2UgdHlwZSAxMC0wMDUwRjIwNC01IGRldmljZSBuYW1lICdkdmRocm0tbngnIGNvbmZpZyBt
ZXRob2RzIDB4MTg4ClAyUDogU3RhdGUgU0VBUkNIIC0+IFNFQVJDSApQMlA6IFN0YXJ0aW5nIHNo
b3J0IGxpc3RlbiBzdGF0ZSAoc3RhdGU9U0VBUkNIKQpXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2Rl
ZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJp
bGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCnAycC1kZXYtd2xhbjA6IEFk
ZCByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAKcDJwLWRldi13bGFuMDogRmlyc3Qg
cmFkaW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5
CnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2
MCBhZnRlciAwLjAwMDAxMiBzZWNvbmQgd2FpdApubDgwMjExOiBFbmFibGUgUHJvYmUgUmVxdWVz
dCByZXBvcnRpbmcgbmxfcHJlcT0weDI2ODg1MDAKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUgdHlw
ZT0weDQwIG5sX2hhbmRsZT0weDI2ODg1MDAgbWF0Y2g9Cm5sODAyMTE6IFJlbWFpbi1vbi1jaGFu
bmVsIGNvb2tpZSAweDIxNyBmb3IgZnJlcT0yNDM3IE1IeiBkdXJhdGlvbj0yMDQKbmw4MDIxMTog
RHJ2IEV2ZW50IDU1IChOTDgwMjExX0NNRF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9y
IHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0w
IGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0yMDQgY29va2llPTB4MjE3IChtYXRj
aCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50IFJFTUFJTl9PTl9DSEFOTkVMICgyMSkgcmVjZWl2ZWQK
T2ZmLWNoYW5uZWw6IFNlbmQgQWN0aW9uIGNhbGxiYWNrICh3aXRob3V0X3JvYz0wIHBlbmRpbmdf
YWN0aW9uX3R4PShuaWwpKQpQMlA6IFN0YXJ0aW5nIExpc3RlbiB0aW1lb3V0KDAsMjA0ODAwKSBv
biBmcmVxPTI0MzcgYmFzZWQgb24gY2FsbGJhY2sKUDJQOiBTZXQgdGltZW91dCAoc3RhdGU9U0VB
UkNIKTogMC4yMjQ4MDAgc2VjCm5sODAyMTE6IERydiBFdmVudCA1NiAoTkw4MDIxMV9DTURfQ0FO
Q0VMX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjEx
OiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTEgZnJlcT0yNDM3IGNoYW5uZWxfdHlw
ZT0wIGR1cmF0aW9uPTAgY29va2llPTB4MjE3IChtYXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50
IENBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCAoMjIpIHJlY2VpdmVkClAyUDogQ2FuY2VsIHJlbWFp
bi1vbi1jaGFubmVsIGNhbGxiYWNrIChwMnBfbG9uZ19saXN0ZW49MCBtcyBwZW5kaW5nX2FjdGlv
bl90eD0obmlsKSkKcDJwLWRldi13bGFuMDogUmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0
NDYwIGRvbmUgaW4gMC4yMDQyNTEgc2Vjb25kcwpQMlA6IERyaXZlciBlbmRlZCBMaXN0ZW4gc3Rh
dGUgKGZyZXE9MjQzNykKUDJQOiBTa2lwIHN0b3BfbGlzdGVuIHNpbmNlIG5vdCBpbiBsaXN0ZW5f
b25seSBzdGF0ZS4KUDJQOiBUaW1lb3V0IChzdGF0ZT1TRUFSQ0gpCm5sODAyMTE6IERpc2FibGUg
UHJvYmUgUmVxdWVzdCByZXBvcnRpbmcgbmxfcHJlcT0weDg4ODg4ODg4OGFlMDBkODkKUDJQOiBT
dGFydGluZyBzZWFyY2gKV1BTOiBCdWlsZGluZyBXUFMgSUUgZm9yIFByb2JlIFJlcXVlc3QKV1BT
OiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBSZXF1ZXN0IFR5cGUKV1BTOiAg
KiBDb25maWcgTWV0aG9kcyAoMTQ4KQpXUFM6ICAqIFVVSUQtRQpXUFM6ICAqIFByaW1hcnkgRGV2
aWNlIFR5cGUKV1BTOiAgKiBSRiBCYW5kcyAoMykKV1BTOiAgKiBBc3NvY2lhdGlvbiBTdGF0ZQpX
UFM6ICAqIENvbmZpZ3VyYXRpb24gRXJyb3IgKDApCldQUzogICogRGV2aWNlIFBhc3N3b3JkIElE
ICgwKQpXUFM6ICAqIERldmljZSBOYW1lClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBh
YmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogTGlzdGVuIENoYW5uZWw6IFJlZ3VsYXRvcnkg
Q2xhc3MgODEgQ2hhbm5lbCA2CnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3JrICdwMnAtc2Nh
bidAMHgyNjg4NDgwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUg
cXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpQMlA6IFJ1bm5pbmcgcDJwX3NjYW4K
cDJwLWRldi13bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MCBh
ZnRlciAwLjAwMDAxMCBzZWNvbmQgd2FpdApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBzY2FuIHJl
cXVlc3QKbmw4MDIxMTogUDJQIHByb2JlIC0gbWFzayBTdXBwUmF0ZXMKU2NhbiByZXF1ZXN0ZWQg
KHJldD0wKSAtIHNjYW4gdGltZW91dCAzMCBzZWNvbmRzCm5sODAyMTE6IERydiBFdmVudCAzMyAo
Tkw4MDIxMV9DTURfVFJJR0dFUl9TQ0FOKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApwMnAt
ZGV2LXdsYW4wOiBubDgwMjExOiBTY2FuIHRyaWdnZXIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NB
Tl9TVEFSVEVEICg0OSkgcmVjZWl2ZWQKcDJwLWRldi13bGFuMDogT3duIHNjYW4gcmVxdWVzdCBz
dGFydGVkIGEgc2NhbiBpbiAwLjAwMDAyMiBzZWNvbmRzCnAycC1kZXYtd2xhbjA6IENUUkwtRVZF
TlQtU0NBTi1TVEFSVEVEIApubDgwMjExOiBEcnYgRXZlbnQgMzQgKE5MODAyMTFfQ01EX05FV19T
Q0FOX1JFU1VMVFMpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1kZXYtd2xhbjA6IG5s
ODAyMTE6IE5ldyBzY2FuIHJlc3VsdHMgYXZhaWxhYmxlCm5sODAyMTE6IFNjYW4gcHJvYmVkIGZv
ciBTU0lEICdESVJFQ1QtJwpubDgwMjExOiBTY2FuIGluY2x1ZGVkIGZyZXF1ZW5jaWVzOiAyNDEy
IDI0MzcgMjQ2MgpwMnAtZGV2LXdsYW4wOiBFdmVudCBTQ0FOX1JFU1VMVFMgKDMpIHJlY2VpdmVk
CnAycC1kZXYtd2xhbjA6IFNjYW4gY29tcGxldGVkIGluIDAuMTIwNTA3IHNlY29uZHMKbmw4MDIx
MTogUmVjZWl2ZWQgc2NhbiByZXN1bHRzICg0IEJTU2VzKQpwMnAtZGV2LXdsYW4wOiBCU1M6IFN0
YXJ0IHNjYW4gcmVzdWx0IHVwZGF0ZSAzNApCU1M6IGxhc3Rfc2Nhbl9yZXNfdXNlZD0zLzMyCnAy
cC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgZG9uZSBpbiAwLjEy
MzQ4OCBzZWNvbmRzClAyUDogU2NhbiByZXN1bHRzIHJlY2VpdmVkICg0IEJTUykKUDJQOiBJZ25v
cmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQ
OiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNl
IEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogSWdub3JlIHNj
YW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFy
c2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogUHJpbWFy
eSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAy
UDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3Vw
IENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgMTMgbGVuZ3RoIDMwClAyUDogKiBEZXZpY2Ug
SW5mbzogYWRkciAxMjo2ODozZjo0ZTozOTpmMiBwcmltYXJ5IGRldmljZSB0eXBlIDEwLTAwNTBG
MjA0LTUgZGV2aWNlIG5hbWUgJ2R2ZGhybS1ueCcgY29uZmlnIG1ldGhvZHMgMHgxODgKUDJQOiBE
byBub3QgdXBkYXRlIHBlZXIgZW50cnkgYmFzZWQgb24gb2xkIGZyYW1lIChyeF90aW1lPTU0NDAw
NS4xNDc5NzcgbGFzdF9zZWVuPTU0NDAwNS4xNDgwMjMpClAyUDogU3RhdGUgU0VBUkNIIC0+IFNF
QVJDSApQMlA6IFN0YXJ0aW5nIHNob3J0IGxpc3RlbiBzdGF0ZSAoc3RhdGU9U0VBUkNIKQpXUFM6
ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElF
IGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJ
bmZvCnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAK
cDJwLWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVk
dWxlIHN0YXJ0IGltbWVkaWF0ZWx5CnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsg
J3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBhZnRlciAwLjAwMDAxMiBzZWNvbmQgd2FpdApubDgwMjEx
OiBFbmFibGUgUHJvYmUgUmVxdWVzdCByZXBvcnRpbmcgbmxfcHJlcT0weDI2ODg1MDAKbmw4MDIx
MTogUmVnaXN0ZXIgZnJhbWUgdHlwZT0weDQwIG5sX2hhbmRsZT0weDI2ODg1MDAgbWF0Y2g9Cm5s
ODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGNvb2tpZSAweDIxOCBmb3IgZnJlcT0yNDM3IE1IeiBk
dXJhdGlvbj0yMDQKbmw4MDIxMTogRHJ2IEV2ZW50IDU1IChOTDgwMjExX0NNRF9SRU1BSU5fT05f
Q0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNo
YW5uZWwgZXZlbnQgKGNhbmNlbD0wIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0y
MDQgY29va2llPTB4MjE4IChtYXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50IFJFTUFJTl9PTl9D
SEFOTkVMICgyMSkgcmVjZWl2ZWQKT2ZmLWNoYW5uZWw6IFNlbmQgQWN0aW9uIGNhbGxiYWNrICh3
aXRob3V0X3JvYz0wIHBlbmRpbmdfYWN0aW9uX3R4PShuaWwpKQpQMlA6IFN0YXJ0aW5nIExpc3Rl
biB0aW1lb3V0KDAsMjA0ODAwKSBvbiBmcmVxPTI0MzcgYmFzZWQgb24gY2FsbGJhY2sKUDJQOiBT
ZXQgdGltZW91dCAoc3RhdGU9U0VBUkNIKTogMC4yMjQ4MDAgc2VjCm5sODAyMTE6IERydiBFdmVu
dCA1NiAoTkw4MDIxMV9DTURfQ0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3Ig
cDJwLWRldi13bGFuMApubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTEg
ZnJlcT0yNDM3IGNoYW5uZWxfdHlwZT0wIGR1cmF0aW9uPTAgY29va2llPTB4MjE4IChtYXRjaCkp
CnAycC1kZXYtd2xhbjA6IEV2ZW50IENBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCAoMjIpIHJlY2Vp
dmVkClAyUDogQ2FuY2VsIHJlbWFpbi1vbi1jaGFubmVsIGNhbGxiYWNrIChwMnBfbG9uZ19saXN0
ZW49MCBtcyBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKcDJwLWRldi13bGFuMDogUmFkaW8gd29y
ayAncDJwLWxpc3RlbidAMHgyNjg0NDYwIGRvbmUgaW4gMC4yMDQyODkgc2Vjb25kcwpQMlA6IERy
aXZlciBlbmRlZCBMaXN0ZW4gc3RhdGUgKGZyZXE9MjQzNykKUDJQOiBTa2lwIHN0b3BfbGlzdGVu
IHNpbmNlIG5vdCBpbiBsaXN0ZW5fb25seSBzdGF0ZS4KUDJQOiBUaW1lb3V0IChzdGF0ZT1TRUFS
Q0gpCm5sODAyMTE6IERpc2FibGUgUHJvYmUgUmVxdWVzdCByZXBvcnRpbmcgbmxfcHJlcT0weDg4
ODg4ODg4OGFlMDBkODkKUDJQOiBTdGFydGluZyBzZWFyY2gKV1BTOiBCdWlsZGluZyBXUFMgSUUg
Zm9yIFByb2JlIFJlcXVlc3QKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAg
KiBSZXF1ZXN0IFR5cGUKV1BTOiAgKiBDb25maWcgTWV0aG9kcyAoMTQ4KQpXUFM6ICAqIFVVSUQt
RQpXUFM6ICAqIFByaW1hcnkgRGV2aWNlIFR5cGUKV1BTOiAgKiBSRiBCYW5kcyAoMykKV1BTOiAg
KiBBc3NvY2lhdGlvbiBTdGF0ZQpXUFM6ICAqIENvbmZpZ3VyYXRpb24gRXJyb3IgKDApCldQUzog
ICogRGV2aWNlIFBhc3N3b3JkIElEICgwKQpXUFM6ICAqIERldmljZSBOYW1lClAyUDogKiBQMlAg
SUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogTGlzdGVu
IENoYW5uZWw6IFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCA2CnAycC1kZXYtd2xhbjA6IEFk
ZCByYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJh
ZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpQ
MlA6IFJ1bm5pbmcgcDJwX3NjYW4KcDJwLWRldi13bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAn
cDJwLXNjYW4nQDB4MjY4ODQ4MCBhZnRlciAwLjAwMDAxMSBzZWNvbmQgd2FpdApwMnAtZGV2LXds
YW4wOiBubDgwMjExOiBzY2FuIHJlcXVlc3QKbmw4MDIxMTogUDJQIHByb2JlIC0gbWFzayBTdXBw
UmF0ZXMKU2NhbiByZXF1ZXN0ZWQgKHJldD0wKSAtIHNjYW4gdGltZW91dCAzMCBzZWNvbmRzCm5s
ODAyMTE6IERydiBFdmVudCAzMyAoTkw4MDIxMV9DTURfVFJJR0dFUl9TQ0FOKSByZWNlaXZlZCBm
b3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBTY2FuIHRyaWdnZXIKcDJw
LWRldi13bGFuMDogRXZlbnQgU0NBTl9TVEFSVEVEICg0OSkgcmVjZWl2ZWQKcDJwLWRldi13bGFu
MDogT3duIHNjYW4gcmVxdWVzdCBzdGFydGVkIGEgc2NhbiBpbiAwLjAwMDAyNCBzZWNvbmRzCnAy
cC1kZXYtd2xhbjA6IENUUkwtRVZFTlQtU0NBTi1TVEFSVEVEIApubDgwMjExOiBEcnYgRXZlbnQg
MzQgKE5MODAyMTFfQ01EX05FV19TQ0FOX1JFU1VMVFMpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXds
YW4wCnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IE5ldyBzY2FuIHJlc3VsdHMgYXZhaWxhYmxlCm5s
ODAyMTE6IFNjYW4gcHJvYmVkIGZvciBTU0lEICdESVJFQ1QtJwpubDgwMjExOiBTY2FuIGluY2x1
ZGVkIGZyZXF1ZW5jaWVzOiAyNDEyIDI0MzcgMjQ2MgpwMnAtZGV2LXdsYW4wOiBFdmVudCBTQ0FO
X1JFU1VMVFMgKDMpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IFNjYW4gY29tcGxldGVkIGluIDAu
MTIwNDg5IHNlY29uZHMKbmw4MDIxMTogUmVjZWl2ZWQgc2NhbiByZXN1bHRzICg0IEJTU2VzKQpw
MnAtZGV2LXdsYW4wOiBCU1M6IFN0YXJ0IHNjYW4gcmVzdWx0IHVwZGF0ZSAzNQpCU1M6IGxhc3Rf
c2Nhbl9yZXNfdXNlZD0zLzMyCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1zY2FuJ0Aw
eDI2ODg0ODAgZG9uZSBpbiAwLjEyMzU4NyBzZWNvbmRzClAyUDogU2NhbiByZXN1bHRzIHJlY2Vp
dmVkICg0IEJTUykKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZv
IG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRh
dGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcg
V1BTIElFClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQ
MlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BT
KTogMHg0Mzg4ClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQ
MlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmlj
ZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgMTMgbGVu
Z3RoIDMwClAyUDogKiBEZXZpY2UgSW5mbzogYWRkciAxMjo2ODozZjo0ZTozOTpmMiBwcmltYXJ5
IGRldmljZSB0eXBlIDEwLTAwNTBGMjA0LTUgZGV2aWNlIG5hbWUgJ2R2ZGhybS1ueCcgY29uZmln
IG1ldGhvZHMgMHgxODgKUDJQOiBEbyBub3QgdXBkYXRlIHBlZXIgZW50cnkgYmFzZWQgb24gb2xk
IGZyYW1lIChyeF90aW1lPTU0NDAwNS4xNDc5OTAgbGFzdF9zZWVuPTU0NDAwNS4xNDgwMjMpClAy
UDogU3RhdGUgU0VBUkNIIC0+IFNFQVJDSApQMlA6IFN0YXJ0aW5nIHNob3J0IGxpc3RlbiBzdGF0
ZSAoc3RhdGU9U0VBUkNIKQpXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAq
IFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3Jv
dXA9MDAKUDJQOiAqIERldmljZSBJbmZvCnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3JrICdw
MnAtbGlzdGVuJ0AweDI2ODQ0NjAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29yayBpdGVt
IGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5CnAycC1kZXYtd2xhbjA6
IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBhZnRlciAwLjAwMDAx
NCBzZWNvbmQgd2FpdApubDgwMjExOiBFbmFibGUgUHJvYmUgUmVxdWVzdCByZXBvcnRpbmcgbmxf
cHJlcT0weDI2ODg1MDAKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUgdHlwZT0weDQwIG5sX2hhbmRs
ZT0weDI2ODg1MDAgbWF0Y2g9Cm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGNvb2tpZSAweDIx
OSBmb3IgZnJlcT0yNDM3IE1IeiBkdXJhdGlvbj0zMDcKbmw4MDIxMTogRHJ2IEV2ZW50IDU1IChO
TDgwMjExX0NNRF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAK
bmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0wIGZyZXE9MjQzNyBjaGFu
bmVsX3R5cGU9MCBkdXJhdGlvbj0zMDcgY29va2llPTB4MjE5IChtYXRjaCkpCnAycC1kZXYtd2xh
bjA6IEV2ZW50IFJFTUFJTl9PTl9DSEFOTkVMICgyMSkgcmVjZWl2ZWQKT2ZmLWNoYW5uZWw6IFNl
bmQgQWN0aW9uIGNhbGxiYWNrICh3aXRob3V0X3JvYz0wIHBlbmRpbmdfYWN0aW9uX3R4PShuaWwp
KQpQMlA6IFN0YXJ0aW5nIExpc3RlbiB0aW1lb3V0KDAsMzA3MjAwKSBvbiBmcmVxPTI0MzcgYmFz
ZWQgb24gY2FsbGJhY2sKUDJQOiBTZXQgdGltZW91dCAoc3RhdGU9U0VBUkNIKTogMC4zMjcyMDAg
c2VjCm5sODAyMTE6IEJTUyBFdmVudCA1OSAoTkw4MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVkIGZv
ciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJYIGZyYW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFsPS0y
NyBzdHlwZT00IGxlbj0yMTcKcDJwLWRldi13bGFuMDogRXZlbnQgUlhfTUdNVCAoMjApIHJlY2Vp
dmVkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4
ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BT
KTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVu
Z3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQ
OiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUo
MHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUGFyc2luZyBX
UFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3
b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQ
MlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmlj
ZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5n
dGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBD
bGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUmVwbHkgdG8gUDJQIFByb2JlIFJlcXVlc3Qg
aW4gTGlzdGVuIHN0YXRlCldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICog
VVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91
cD0wMApQMlA6ICogRGV2aWNlIEluZm8Kbmw4MDIxMTogc2VuZF9tbG1lIC0gbm9hY2s9MSBmcmVx
PTAgbm9fY2NrPTAgb2ZmY2hhbm9rPTAgd2FpdF90aW1lPTAgZmM9MHg1MCBubG1vZGU9MTAKbmw4
MDIxMTogVXNlIGxhc3RfbWdtdF9mcmVxPTI0MzcKbmw4MDIxMTogQlNTIEV2ZW50IDU5IChOTDgw
MjExX0NNRF9GUkFNRSkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUlggZnJh
bWUgZnJlcT0yNDM3IHNzaV9zaWduYWw9LTI3IHN0eXBlPTQgbGVuPTIxNwpwMnAtZGV2LXdsYW4w
OiBFdmVudCBSWF9NR01UICgyMCkgcmVjZWl2ZWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENv
bmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQ
OiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQ
MlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkg
MjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBM
aXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5u
ZWwgTnVtYmVyIDYKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMp
OiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBU
eXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1
dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0
eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291
bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBS
ZXBseSB0byBQMlAgUHJvYmUgUmVxdWVzdCBpbiBMaXN0ZW4gc3RhdGUKV1BTOiAgKiBWZXJzaW9u
IChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQ
OiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpubDgwMjEx
OiBzZW5kX21sbWUgLSBub2Fjaz0xIGZyZXE9MCBub19jY2s9MCBvZmZjaGFub2s9MCB3YWl0X3Rp
bWU9MCBmYz0weDUwIG5sbW9kZT0xMApubDgwMjExOiBVc2UgbGFzdF9tZ210X2ZyZXE9MjQzNwpu
bDgwMjExOiBCU1MgRXZlbnQgNTkgKE5MODAyMTFfQ01EX0ZSQU1FKSByZWNlaXZlZCBmb3IgcDJw
LWRldi13bGFuMApubDgwMjExOiBSWCBmcmFtZSBmcmVxPTI0Mzcgc3NpX3NpZ25hbD0tMjcgc3R5
cGU9NCBsZW49MjE3CnAycC1kZXYtd2xhbjA6IEV2ZW50IFJYX01HTVQgKDIwKSByZWNlaXZlZApQ
MlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6
IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEw
LTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAy
ClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0
cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQp
IFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFBhcnNpbmcgV1BTIElF
ClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJ
RDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQ
YXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2Fw
YWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUK
UDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3Mg
ODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFJlcGx5IHRvIFAyUCBQcm9iZSBSZXF1ZXN0IGluIExp
c3RlbiBzdGF0ZQpXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVVSUQt
RQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAK
UDJQOiAqIERldmljZSBJbmZvCm5sODAyMTE6IHNlbmRfbWxtZSAtIG5vYWNrPTEgZnJlcT0wIG5v
X2Njaz0wIG9mZmNoYW5vaz0wIHdhaXRfdGltZT0wIGZjPTB4NTAgbmxtb2RlPTEwCm5sODAyMTE6
IFVzZSBsYXN0X21nbXRfZnJlcT0yNDM3Cm5sODAyMTE6IEJTUyBFdmVudCA1OSAoTkw4MDIxMV9D
TURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJYIGZyYW1lIGZy
ZXE9MjQzNyBzc2lfc2lnbmFsPS0yNyBzdHlwZT00IGxlbj0yMTcKcDJwLWRldi13bGFuMDogRXZl
bnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcg
TWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJp
bWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElF
ClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdy
b3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVu
IENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51
bWJlciA2ClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0
Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAo
V1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIg
bGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAK
UDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkg
REUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUmVwbHkg
dG8gUDJQIFByb2JlIFJlcXVlc3QgaW4gTGlzdGVuIHN0YXRlCldQUzogICogVmVyc2lvbiAoaGFy
ZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBD
YXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8Kbmw4MDIxMTogc2Vu
ZF9tbG1lIC0gbm9hY2s9MSBmcmVxPTAgbm9fY2NrPTAgb2ZmY2hhbm9rPTAgd2FpdF90aW1lPTAg
ZmM9MHg1MCBubG1vZGU9MTAKbmw4MDIxMTogVXNlIGxhc3RfbWdtdF9mcmVxPTI0MzcKbmw4MDIx
MTogRHJ2IEV2ZW50IDU2IChOTDgwMjExX0NNRF9DQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwpIHJl
Y2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50
IChjYW5jZWw9MSBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MCBjb29raWU9MHgy
MTkgKG1hdGNoKSkKcDJwLWRldi13bGFuMDogRXZlbnQgQ0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVM
ICgyMikgcmVjZWl2ZWQKUDJQOiBDYW5jZWwgcmVtYWluLW9uLWNoYW5uZWwgY2FsbGJhY2sgKHAy
cF9sb25nX2xpc3Rlbj0wIG1zIHBlbmRpbmdfYWN0aW9uX3R4PShuaWwpKQpwMnAtZGV2LXdsYW4w
OiBSYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgZG9uZSBpbiAwLjMwNjY0OCBzZWNv
bmRzClAyUDogRHJpdmVyIGVuZGVkIExpc3RlbiBzdGF0ZSAoZnJlcT0yNDM3KQpQMlA6IFNraXAg
c3RvcF9saXN0ZW4gc2luY2Ugbm90IGluIGxpc3Rlbl9vbmx5IHN0YXRlLgpQMlA6IFRpbWVvdXQg
KHN0YXRlPVNFQVJDSCkKbmw4MDIxMTogRGlzYWJsZSBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBu
bF9wcmVxPTB4ODg4ODg4ODg4YWUwMGQ4OQpQMlA6IFN0YXJ0aW5nIHNlYXJjaApXUFM6IEJ1aWxk
aW5nIFdQUyBJRSBmb3IgUHJvYmUgUmVxdWVzdApXUFM6ICAqIFZlcnNpb24gKGhhcmRjb2RlZCAw
eDEwKQpXUFM6ICAqIFJlcXVlc3QgVHlwZQpXUFM6ICAqIENvbmZpZyBNZXRob2RzICgxNDgpCldQ
UzogICogVVVJRC1FCldQUzogICogUHJpbWFyeSBEZXZpY2UgVHlwZQpXUFM6ICAqIFJGIEJhbmRz
ICgzKQpXUFM6ICAqIEFzc29jaWF0aW9uIFN0YXRlCldQUzogICogQ29uZmlndXJhdGlvbiBFcnJv
ciAoMCkKV1BTOiAgKiBEZXZpY2UgUGFzc3dvcmQgSUQgKDApCldQUzogICogRGV2aWNlIE5hbWUK
UDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAy
UDogKiBMaXN0ZW4gQ2hhbm5lbDogUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIDYKcDJwLWRl
di13bGFuMDogQWRkIHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAKcDJwLWRldi13bGFu
MDogRmlyc3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGlt
bWVkaWF0ZWx5ClAyUDogUnVubmluZyBwMnBfc2NhbgpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyBy
YWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgwIGFmdGVyIDAuMDAwMDIyIHNlY29uZCB3YWl0
CnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IHNjYW4gcmVxdWVzdApubDgwMjExOiBQMlAgcHJvYmUg
LSBtYXNrIFN1cHBSYXRlcwpTY2FuIHJlcXVlc3RlZCAocmV0PTApIC0gc2NhbiB0aW1lb3V0IDMw
IHNlY29uZHMKbmw4MDIxMTogRHJ2IEV2ZW50IDMzIChOTDgwMjExX0NNRF9UUklHR0VSX1NDQU4p
IHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCnAycC1kZXYtd2xhbjA6IG5sODAyMTE6IFNjYW4g
dHJpZ2dlcgpwMnAtZGV2LXdsYW4wOiBFdmVudCBTQ0FOX1NUQVJURUQgKDQ5KSByZWNlaXZlZApw
MnAtZGV2LXdsYW4wOiBPd24gc2NhbiByZXF1ZXN0IHN0YXJ0ZWQgYSBzY2FuIGluIDAuMDAwMDM3
IHNlY29uZHMKcDJwLWRldi13bGFuMDogQ1RSTC1FVkVOVC1TQ0FOLVNUQVJURUQgCm5sODAyMTE6
IERydiBFdmVudCAzNCAoTkw4MDIxMV9DTURfTkVXX1NDQU5fUkVTVUxUUykgcmVjZWl2ZWQgZm9y
IHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogTmV3IHNjYW4gcmVzdWx0cyBh
dmFpbGFibGUKbmw4MDIxMTogU2NhbiBwcm9iZWQgZm9yIFNTSUQgJ0RJUkVDVC0nCm5sODAyMTE6
IFNjYW4gaW5jbHVkZWQgZnJlcXVlbmNpZXM6IDI0MTIgMjQzNyAyNDYyCnAycC1kZXYtd2xhbjA6
IEV2ZW50IFNDQU5fUkVTVUxUUyAoMykgcmVjZWl2ZWQKcDJwLWRldi13bGFuMDogU2NhbiBjb21w
bGV0ZWQgaW4gMC4xMjA0OTQgc2Vjb25kcwpubDgwMjExOiBSZWNlaXZlZCBzY2FuIHJlc3VsdHMg
KDQgQlNTZXMpCnAycC1kZXYtd2xhbjA6IEJTUzogU3RhcnQgc2NhbiByZXN1bHQgdXBkYXRlIDM2
CkJTUzogbGFzdF9zY2FuX3Jlc191c2VkPTMvMzIKcDJwLWRldi13bGFuMDogUmFkaW8gd29yayAn
cDJwLXNjYW4nQDB4MjY4ODQ4MCBkb25lIGluIDAuMTIzNDk1IHNlY29uZHMKUDJQOiBTY2FuIHJl
c3VsdHMgcmVjZWl2ZWQgKDQgQlNTKQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAg
RGV2aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogSWdu
b3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAy
UDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmlj
ZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBN
ZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0w
MDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQ
MlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJp
YnV0ZSAxMyBsZW5ndGggMzAKUDJQOiAqIERldmljZSBJbmZvOiBhZGRyIDEyOjY4OjNmOjRlOjM5
OmYyIHByaW1hcnkgZGV2aWNlIHR5cGUgMTAtMDA1MEYyMDQtNSBkZXZpY2UgbmFtZSAnZHZkaHJt
LW54JyBjb25maWcgbWV0aG9kcyAweDE4OApQMlA6IFN0YXRlIFNFQVJDSCAtPiBTRUFSQ0gKUDJQ
OiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVNFQVJDSCkKV1BTOiAgKiBWZXJz
aW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIK
UDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpwMnAt
ZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwCnAycC1kZXYt
d2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFy
dCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtbGlz
dGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTMgc2Vjb25kIHdhaXQKbmw4MDIxMTogRW5hYmxl
IFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHgyNjg4NTAwCm5sODAyMTE6IFJlZ2lz
dGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgyNjg4NTAwIG1hdGNoPQpubDgwMjExOiBS
ZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgyMWEgZm9yIGZyZXE9MjQzNyBNSHogZHVyYXRpb249
MTAyCm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09OX0NIQU5ORUwp
IHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2
ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MTAyIGNvb2tp
ZT0weDIxYSAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05fQ0hBTk5FTCAo
MjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAod2l0aG91dF9y
b2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0ZW4gdGltZW91
dCgwLDEwMjQwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDogU2V0IHRpbWVv
dXQgKHN0YXRlPVNFQVJDSCk6IDAuMTIyNDAwIHNlYwpubDgwMjExOiBEcnYgRXZlbnQgNTYgKE5M
ODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYt
d2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0xIGZyZXE9MjQz
NyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIxYSAobWF0Y2gpKQpwMnAtZGV2
LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNlaXZlZApQMlA6
IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlzdGVuPTAgbXMg
cGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1s
aXN0ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMTAxODUwIHNlY29uZHMKUDJQOiBEcml2ZXIgZW5k
ZWQgTGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3RlbiBzaW5jZSBu
b3QgaW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9U0VBUkNIKQpubDgw
MjExOiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHg4ODg4ODg4ODhh
ZTAwZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVpbGRpbmcgV1BTIElFIGZvciBQcm9i
ZSBSZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogUmVxdWVz
dCBUeXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkKV1BTOiAgKiBVVUlELUUKV1BTOiAg
KiBQcmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYgQmFuZHMgKDMpCldQUzogICogQXNzb2Np
YXRpb24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVycm9yICgwKQpXUFM6ICAqIERldmlj
ZSBQYXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFtZQpQMlA6ICogUDJQIElFIGhlYWRl
cgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIExpc3RlbiBDaGFubmVs
OiBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8g
d29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3Jr
IGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKUDJQOiBSdW5u
aW5nIHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1zY2Fu
J0AweDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMTAgc2Vjb25kIHdhaXQKcDJwLWRldi13bGFuMDogbmw4
MDIxMTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9iZSAtIG1hc2sgU3VwcFJhdGVzClNj
YW4gcmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQgMzAgc2Vjb25kcwpubDgwMjExOiBE
cnYgRXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NBTikgcmVjZWl2ZWQgZm9yIHAycC1k
ZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogU2NhbiB0cmlnZ2VyCnAycC1kZXYtd2xh
bjA6IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IE93biBz
Y2FuIHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAwMjQgc2Vjb25kcwpwMnAtZGV2LXds
YW4wOiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIxMTogRHJ2IEV2ZW50IDM0IChOTDgw
MjExX0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApwMnAt
ZGV2LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRzIGF2YWlsYWJsZQpubDgwMjExOiBT
Y2FuIHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIxMTogU2NhbiBpbmNsdWRlZCBmcmVx
dWVuY2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFuMDogRXZlbnQgU0NBTl9SRVNVTFRT
ICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNvbXBsZXRlZCBpbiAwLjEyMDU0NyBz
ZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0cyAoNCBCU1NlcykKcDJwLWRldi13
bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUgMzcKQlNTOiBsYXN0X3NjYW5fcmVz
X3VzZWQ9My8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtc2NhbidAMHgyNjg4NDgw
IGRvbmUgaW4gMC4xMjM1MTEgc2Vjb25kcwpQMlA6IFNjYW4gcmVzdWx0cyByZWNlaXZlZCAoNCBC
U1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAyUCBEZXZpY2UgSW5mbyBvciBQMlAg
RGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJZ25vcmUgc2NhbiBkYXRhIHdpdGhv
dXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQ
MlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2aWNlIEluZm8gb3IgUDJQIERldmlj
ZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4
OApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJz
aW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJp
bGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDEzIGxlbmd0aCAzMApQ
MlA6ICogRGV2aWNlIEluZm86IGFkZHIgMTI6Njg6M2Y6NGU6Mzk6ZjIgcHJpbWFyeSBkZXZpY2Ug
dHlwZSAxMC0wMDUwRjIwNC01IGRldmljZSBuYW1lICdkdmRocm0tbngnIGNvbmZpZyBtZXRob2Rz
IDB4MTg4ClAyUDogRG8gbm90IHVwZGF0ZSBwZWVyIGVudHJ5IGJhc2VkIG9uIG9sZCBmcmFtZSAo
cnhfdGltZT01NDQwMDYuMzAyMDc2IGxhc3Rfc2Vlbj01NDQwMDYuMzAyNDA4KQpQMlA6IFN0YXRl
IFNFQVJDSCAtPiBTRUFSQ0gKUDJQOiBTdGFydGluZyBzaG9ydCBsaXN0ZW4gc3RhdGUgKHN0YXRl
PVNFQVJDSCkKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBVVUlELUUK
UDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3VwPTAwClAy
UDogKiBEZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLWxpc3Rl
bidAMHgyNjg0NDYwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRlbSBpbiB0aGUg
cXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4wOiBTdGFydGlu
ZyByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAgYWZ0ZXIgMC4wMDAwMTEgc2Vjb25k
IHdhaXQKbmw4MDIxMTogRW5hYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIG5sX3ByZXE9MHgy
Njg4NTAwCm5sODAyMTE6IFJlZ2lzdGVyIGZyYW1lIHR5cGU9MHg0MCBubF9oYW5kbGU9MHgyNjg4
NTAwIG1hdGNoPQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBjb29raWUgMHgyMWIgZm9yIGZy
ZXE9MjQzNyBNSHogZHVyYXRpb249MTAyCm5sODAyMTE6IERydiBFdmVudCA1NSAoTkw4MDIxMV9D
TURfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6
IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0MzcgY2hhbm5lbF90eXBl
PTAgZHVyYXRpb249MTAyIGNvb2tpZT0weDIxYiAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVu
dCBSRU1BSU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFubmVsOiBTZW5kIEFjdGlv
biBjYWxsYmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90eD0obmlsKSkKUDJQOiBT
dGFydGluZyBMaXN0ZW4gdGltZW91dCgwLDEwMjQwMCkgb24gZnJlcT0yNDM3IGJhc2VkIG9uIGNh
bGxiYWNrClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVNFQVJDSCk6IDAuMTIyNDAwIHNlYwpubDgw
MjExOiBEcnYgRXZlbnQgNTYgKE5MODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkg
cmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZl
bnQgKGNhbmNlbD0xIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0w
eDIxYiAobWF0Y2gpKQpwMnAtZGV2LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5O
RUwgKDIyKSByZWNlaXZlZApQMlA6IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAo
cDJwX2xvbmdfbGlzdGVuPTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xh
bjA6IFJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ2MCBkb25lIGluIDAuMTAxODUzIHNl
Y29uZHMKUDJQOiBEcml2ZXIgZW5kZWQgTGlzdGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tp
cCBzdG9wX2xpc3RlbiBzaW5jZSBub3QgaW4gbGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91
dCAoc3RhdGU9U0VBUkNIKQpubDgwMjExOiBEaXNhYmxlIFByb2JlIFJlcXVlc3QgcmVwb3J0aW5n
IG5sX3ByZXE9MHg4ODg4ODg4ODhhZTAwZDg5ClAyUDogU3RhcnRpbmcgc2VhcmNoCldQUzogQnVp
bGRpbmcgV1BTIElFIGZvciBQcm9iZSBSZXF1ZXN0CldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVk
IDB4MTApCldQUzogICogUmVxdWVzdCBUeXBlCldQUzogICogQ29uZmlnIE1ldGhvZHMgKDE0OCkK
V1BTOiAgKiBVVUlELUUKV1BTOiAgKiBQcmltYXJ5IERldmljZSBUeXBlCldQUzogICogUkYgQmFu
ZHMgKDMpCldQUzogICogQXNzb2NpYXRpb24gU3RhdGUKV1BTOiAgKiBDb25maWd1cmF0aW9uIEVy
cm9yICgwKQpXUFM6ICAqIERldmljZSBQYXNzd29yZCBJRCAoMCkKV1BTOiAgKiBEZXZpY2UgTmFt
ZQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAK
UDJQOiAqIExpc3RlbiBDaGFubmVsOiBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgNgpwMnAt
ZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAncDJwLXNjYW4nQDB4MjY4ODQ4MApwMnAtZGV2LXds
YW4wOiBGaXJzdCByYWRpbyB3b3JrIGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQg
aW1tZWRpYXRlbHkKUDJQOiBSdW5uaW5nIHAycF9zY2FuCnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5n
IHJhZGlvIHdvcmsgJ3AycC1zY2FuJ0AweDI2ODg0ODAgYWZ0ZXIgMC4wMDAwMTEgc2Vjb25kIHdh
aXQKcDJwLWRldi13bGFuMDogbmw4MDIxMTogc2NhbiByZXF1ZXN0Cm5sODAyMTE6IFAyUCBwcm9i
ZSAtIG1hc2sgU3VwcFJhdGVzClNjYW4gcmVxdWVzdGVkIChyZXQ9MCkgLSBzY2FuIHRpbWVvdXQg
MzAgc2Vjb25kcwpubDgwMjExOiBEcnYgRXZlbnQgMzMgKE5MODAyMTFfQ01EX1RSSUdHRVJfU0NB
TikgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKcDJwLWRldi13bGFuMDogbmw4MDIxMTogU2Nh
biB0cmlnZ2VyCnAycC1kZXYtd2xhbjA6IEV2ZW50IFNDQU5fU1RBUlRFRCAoNDkpIHJlY2VpdmVk
CnAycC1kZXYtd2xhbjA6IE93biBzY2FuIHJlcXVlc3Qgc3RhcnRlZCBhIHNjYW4gaW4gMC4wMDAw
MzQgc2Vjb25kcwpwMnAtZGV2LXdsYW4wOiBDVFJMLUVWRU5ULVNDQU4tU1RBUlRFRCAKbmw4MDIx
MTogRHJ2IEV2ZW50IDM0IChOTDgwMjExX0NNRF9ORVdfU0NBTl9SRVNVTFRTKSByZWNlaXZlZCBm
b3IgcDJwLWRldi13bGFuMApwMnAtZGV2LXdsYW4wOiBubDgwMjExOiBOZXcgc2NhbiByZXN1bHRz
IGF2YWlsYWJsZQpubDgwMjExOiBTY2FuIHByb2JlZCBmb3IgU1NJRCAnRElSRUNULScKbmw4MDIx
MTogU2NhbiBpbmNsdWRlZCBmcmVxdWVuY2llczogMjQxMiAyNDM3IDI0NjIKcDJwLWRldi13bGFu
MDogRXZlbnQgU0NBTl9SRVNVTFRTICgzKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBTY2FuIGNv
bXBsZXRlZCBpbiAwLjEyMDQ4MCBzZWNvbmRzCm5sODAyMTE6IFJlY2VpdmVkIHNjYW4gcmVzdWx0
cyAoNCBCU1NlcykKcDJwLWRldi13bGFuMDogQlNTOiBTdGFydCBzY2FuIHJlc3VsdCB1cGRhdGUg
MzgKQlNTOiBsYXN0X3NjYW5fcmVzX3VzZWQ9My8zMgpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3Jr
ICdwMnAtc2NhbidAMHgyNjg4NDgwIGRvbmUgaW4gMC4xMjM0Mjkgc2Vjb25kcwpQMlA6IFNjYW4g
cmVzdWx0cyByZWNlaXZlZCAoNCBCU1MpClAyUDogSWdub3JlIHNjYW4gZGF0YSB3aXRob3V0IFAy
UCBEZXZpY2UgSW5mbyBvciBQMlAgRGV2aWNlIElkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBJ
Z25vcmUgc2NhbiBkYXRhIHdpdGhvdXQgUDJQIERldmljZSBJbmZvIG9yIFAyUCBEZXZpY2UgSWQK
UDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IElnbm9yZSBzY2FuIGRhdGEgd2l0aG91dCBQMlAgRGV2
aWNlIEluZm8gb3IgUDJQIERldmljZSBJZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmln
IE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEw
LTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAy
ClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0
cmlidXRlIDEzIGxlbmd0aCAzMApQMlA6ICogRGV2aWNlIEluZm86IGFkZHIgMTI6Njg6M2Y6NGU6
Mzk6ZjIgcHJpbWFyeSBkZXZpY2UgdHlwZSAxMC0wMDUwRjIwNC01IGRldmljZSBuYW1lICdkdmRo
cm0tbngnIGNvbmZpZyBtZXRob2RzIDB4MTg4ClAyUDogU3RhdGUgU0VBUkNIIC0+IFNFQVJDSApQ
MlA6IFN0YXJ0aW5nIHNob3J0IGxpc3RlbiBzdGF0ZSAoc3RhdGU9U0VBUkNIKQpXUFM6ICAqIFZl
cnNpb24gKGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRl
cgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCnAy
cC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0NjAKcDJwLWRl
di13bGFuMDogRmlyc3QgcmFkaW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0
YXJ0IGltbWVkaWF0ZWx5CnAycC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1s
aXN0ZW4nQDB4MjY4NDQ2MCBhZnRlciAwLjAwMDAxMSBzZWNvbmQgd2FpdApubDgwMjExOiBFbmFi
bGUgUHJvYmUgUmVxdWVzdCByZXBvcnRpbmcgbmxfcHJlcT0weDI2ODg1MDAKbmw4MDIxMTogUmVn
aXN0ZXIgZnJhbWUgdHlwZT0weDQwIG5sX2hhbmRsZT0weDI2ODg1MDAgbWF0Y2g9Cm5sODAyMTE6
IFJlbWFpbi1vbi1jaGFubmVsIGNvb2tpZSAweDIxYyBmb3IgZnJlcT0yNDM3IE1IeiBkdXJhdGlv
bj0yMDQKbmw4MDIxMTogRHJ2IEV2ZW50IDU1IChOTDgwMjExX0NNRF9SRU1BSU5fT05fQ0hBTk5F
TCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwg
ZXZlbnQgKGNhbmNlbD0wIGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0yMDQgY29v
a2llPTB4MjFjIChtYXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50IFJFTUFJTl9PTl9DSEFOTkVM
ICgyMSkgcmVjZWl2ZWQKT2ZmLWNoYW5uZWw6IFNlbmQgQWN0aW9uIGNhbGxiYWNrICh3aXRob3V0
X3JvYz0wIHBlbmRpbmdfYWN0aW9uX3R4PShuaWwpKQpQMlA6IFN0YXJ0aW5nIExpc3RlbiB0aW1l
b3V0KDAsMjA0ODAwKSBvbiBmcmVxPTI0MzcgYmFzZWQgb24gY2FsbGJhY2sKUDJQOiBTZXQgdGlt
ZW91dCAoc3RhdGU9U0VBUkNIKTogMC4yMjQ4MDAgc2VjCm5sODAyMTE6IEJTUyBFdmVudCA1OSAo
Tkw4MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJY
IGZyYW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFsPS0yNyBzdHlwZT00IGxlbj0yMTcKcDJwLWRldi13
bGFuMDogRXZlbnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkClAyUDogUGFyc2luZyBXUFMgSUUKUDJQ
OiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAw
ClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNp
bmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmls
aXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6
ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBD
aGFubmVsIE51bWJlciA2ClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAo
V1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZp
Y2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0
cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFi
aWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6
IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAy
UDogUmVwbHkgdG8gUDJQIFByb2JlIFJlcXVlc3QgaW4gTGlzdGVuIHN0YXRlCldQUzogICogVmVy
c2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVy
ClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8Kbmw4
MDIxMTogc2VuZF9tbG1lIC0gbm9hY2s9MSBmcmVxPTAgbm9fY2NrPTAgb2ZmY2hhbm9rPTAgd2Fp
dF90aW1lPTAgZmM9MHg1MCBubG1vZGU9MTAKbmw4MDIxMTogVXNlIGxhc3RfbWdtdF9mcmVxPTI0
MzcKbmw4MDIxMTogQlNTIEV2ZW50IDU5IChOTDgwMjExX0NNRF9GUkFNRSkgcmVjZWl2ZWQgZm9y
IHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUlggZnJhbWUgZnJlcT0yNDM3IHNzaV9zaWduYWw9LTI3
IHN0eXBlPTQgbGVuPTIxNwpwMnAtZGV2LXdsYW4wOiBFdmVudCBSWF9NR01UICgyMCkgcmVjZWl2
ZWQKUDJQOiBQYXJzaW5nIFdQUyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgK
UDJQOiBEZXZpY2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMp
OiAxMC0wMDUwRjIwNC01ClAyUDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5n
dGggMgpQMlA6ICogRGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6
IEF0dHJpYnV0ZSA2IGxlbmd0aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgw
eDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBQYXJzaW5nIFdQ
UyBJRQpQMlA6IENvbmZpZyBNZXRob2RzIChXUFMpOiAweDQzODgKUDJQOiBEZXZpY2UgUGFzc3dv
cmQgSUQ6IDAKUDJQOiBQcmltYXJ5IERldmljZSBUeXBlIChXUFMpOiAxMC0wMDUwRjIwNC01ClAy
UDogUGFyc2luZyBQMlAgSUUKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICogRGV2aWNl
IENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA2IGxlbmd0
aCA1ClAyUDogKiBMaXN0ZW4gQ2hhbm5lbDogQ291bnRyeSBERSgweDA0KSBSZWd1bGF0b3J5IENs
YXNzIDgxIENoYW5uZWwgTnVtYmVyIDYKUDJQOiBSZXBseSB0byBQMlAgUHJvYmUgUmVxdWVzdCBp
biBMaXN0ZW4gc3RhdGUKV1BTOiAgKiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKV1BTOiAgKiBV
VUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdyb3Vw
PTAwClAyUDogKiBEZXZpY2UgSW5mbwpubDgwMjExOiBzZW5kX21sbWUgLSBub2Fjaz0xIGZyZXE9
MCBub19jY2s9MCBvZmZjaGFub2s9MCB3YWl0X3RpbWU9MCBmYz0weDUwIG5sbW9kZT0xMApubDgw
MjExOiBVc2UgbGFzdF9tZ210X2ZyZXE9MjQzNwpubDgwMjExOiBCU1MgRXZlbnQgNTkgKE5MODAy
MTFfQ01EX0ZSQU1FKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgwMjExOiBSWCBmcmFt
ZSBmcmVxPTI0Mzcgc3NpX3NpZ25hbD0tMjcgc3R5cGU9NCBsZW49MjE3CnAycC1kZXYtd2xhbjA6
IEV2ZW50IFJYX01HTVQgKDIwKSByZWNlaXZlZApQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29u
ZmlnIE1ldGhvZHMgKFdQUyk6IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6
IFByaW1hcnkgRGV2aWNlIFR5cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAy
UCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAy
NSBHcm91cCBDYXBhYmlsaXR5IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExp
c3RlbiBDaGFubmVsOiBDb3VudHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5l
bCBOdW1iZXIgNgpQMlA6IFBhcnNpbmcgV1BTIElFClAyUDogQ29uZmlnIE1ldGhvZHMgKFdQUyk6
IDB4NDM4OApQMlA6IERldmljZSBQYXNzd29yZCBJRDogMApQMlA6IFByaW1hcnkgRGV2aWNlIFR5
cGUgKFdQUyk6IDEwLTAwNTBGMjA0LTUKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0
ZSAyIGxlbmd0aCAyClAyUDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5
IDAwClAyUDogQXR0cmlidXRlIDYgbGVuZ3RoIDUKUDJQOiAqIExpc3RlbiBDaGFubmVsOiBDb3Vu
dHJ5IERFKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQMlA6IFJl
cGx5IHRvIFAyUCBQcm9iZSBSZXF1ZXN0IGluIExpc3RlbiBzdGF0ZQpXUFM6ICAqIFZlcnNpb24g
KGhhcmRjb2RlZCAweDEwKQpXUFM6ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6
ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCm5sODAyMTE6
IHNlbmRfbWxtZSAtIG5vYWNrPTEgZnJlcT0wIG5vX2Njaz0wIG9mZmNoYW5vaz0wIHdhaXRfdGlt
ZT0wIGZjPTB4NTAgbmxtb2RlPTEwCm5sODAyMTE6IFVzZSBsYXN0X21nbXRfZnJlcT0yNDM3Cm5s
ODAyMTE6IEJTUyBFdmVudCA1OSAoTkw4MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAt
ZGV2LXdsYW4wCm5sODAyMTE6IFJYIGZyYW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFsPS0yNyBzdHlw
ZT00IGxlbj0yMTcKcDJwLWRldi13bGFuMDogRXZlbnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkClAy
UDogUGFyc2luZyBXUFMgSUUKUDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDog
RGV2aWNlIFBhc3N3b3JkIElEOiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAt
MDA1MEYyMDQtNQpQMlA6IFBhcnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIK
UDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRy
aWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkg
UmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogUGFyc2luZyBXUFMgSUUK
UDJQOiBDb25maWcgTWV0aG9kcyAoV1BTKTogMHg0Mzg4ClAyUDogRGV2aWNlIFBhc3N3b3JkIElE
OiAwClAyUDogUHJpbWFyeSBEZXZpY2UgVHlwZSAoV1BTKTogMTAtMDA1MEYyMDQtNQpQMlA6IFBh
cnNpbmcgUDJQIElFClAyUDogQXR0cmlidXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBh
YmlsaXR5IDI1IEdyb3VwIENhcGFiaWxpdHkgMDAKUDJQOiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQ
MlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4
MSBDaGFubmVsIE51bWJlciA2ClAyUDogUmVwbHkgdG8gUDJQIFByb2JlIFJlcXVlc3QgaW4gTGlz
dGVuIHN0YXRlCldQUzogICogVmVyc2lvbiAoaGFyZGNvZGVkIDB4MTApCldQUzogICogVVVJRC1F
ClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0yNSBncm91cD0wMApQ
MlA6ICogRGV2aWNlIEluZm8Kbmw4MDIxMTogc2VuZF9tbG1lIC0gbm9hY2s9MSBmcmVxPTAgbm9f
Y2NrPTAgb2ZmY2hhbm9rPTAgd2FpdF90aW1lPTAgZmM9MHg1MCBubG1vZGU9MTAKbmw4MDIxMTog
VXNlIGxhc3RfbWdtdF9mcmVxPTI0MzcKd2xhbjA6IENvbnRyb2wgaW50ZXJmYWNlIGNvbW1hbmQg
J1AyUF9DT05ORUNUIDEyOjY4OjNmOjRlOjM5OmYyIHBiYycKd2xhbjA6IERldGVybWluaW5nIHNo
YXJlZCByYWRpbyBmcmVxdWVuY2llcyAobWF4IGxlbiAxKQp3bGFuMDogU2hhcmVkIGZyZXF1ZW5j
aWVzIChsZW49MCk6IGNvbXBsZXRlZCBpdGVyYXRpb24KUDJQOiBTZXR1cCBmcmVxczogZnJlcT0w
IG51bV9NQ0M9MSBzaGFyZWRfZnJlcXM9MApQMlA6IE5vIGN1cnJlbnQgb3BlcmF0aW5nIGNoYW5u
ZWxzIC0gdHJ5IHRvIHVzZSBhIG5ldyBjaGFubmVsClAyUDogT3duIGZyZXF1ZW5jeSBwcmVmZXJl
bmNlOiAwIE1IegpQMlA6IENyZWF0ZSBhIG5ldyBpbnRlcmZhY2UgcDJwLXdsYW4wLTAgZm9yIHRo
ZSBncm91cApubDgwMjExOiBDcmVhdGUgaW50ZXJmYWNlIGlmdHlwZSA4IChQMlBfQ0xJRU5UKQpu
bDgwMjExOiBOZXcgaW50ZXJmYWNlIHAycC13bGFuMC0wIGNyZWF0ZWQ6IGlmaW5kZXg9MTQKbmw4
MDIxMTogQWRkIG93biBpbnRlcmZhY2UgaWZpbmRleCAxNApubDgwMjExOiBTZXQgVFggcmF0ZXMg
ZmFpbGVkOiByZXQ9LTEwMCAoTmV0d29yayBpcyBkb3duKQpQMlA6IENyZWF0ZWQgcGVuZGluZyB2
aXJ0dWFsIGludGVyZmFjZSBwMnAtd2xhbjAtMCBhZGRyIGZjOmY4OmFlOjY5OjhhOjYzClAyUDog
UmVxdWVzdCB0byBzdGFydCBncm91cCBuZWdvdGlhdGlvbiAtIHBlZXI9MTI6Njg6M2Y6NGU6Mzk6
ZjIgIEdPIEludGVudD03ICBJbnRlbmRlZCBJbnRlcmZhY2UgQWRkcmVzcz1mYzpmODphZTo2OTo4
YTo2MyB3cHNfbWV0aG9kPTMgcGVyc2lzdGVudF9ncm91cD0wIHBkX2JlZm9yZV9nb19uZWc9MApQ
MlA6IFByZXBhcmUgY2hhbm5lbCAtIGZvcmNlX2ZyZXE9MCBwcmVmX2ZyZXE9MCBnbz0wClAyUDog
UHJlcGFyZSBjaGFubmVsIGJlc3QKUDJQOiBTZWxlY3QgcHJlLWNvbmZpZ3VyZWQgY2hhbm5lbCBh
cyBvcGVyYXRpbmcgY2hhbm5lbCBwcmVmZXJlbmNlClAyUDogcHJlcGFyZWQgY2hhbm5lbHM6IDgx
OjEsMiwzLDQsNSw2LDcsOCw5LDEwLDExClAyUDogYWZ0ZXIgZ28vY2xpIGZpbHRlci9hZGQ6IDgx
OjEsMiwzLDQsNSw2LDcsOCw5LDEwLDExClAyUDogT3duIHByZWZlcmVuY2UgZm9yIG9wZXJhdGlv
biBjaGFubmVsOiBPcGVyYXRpbmcgQ2xhc3MgODEgQ2hhbm5lbCA2ClAyUDogU3RvcHBpbmcgZmlu
ZApQMlA6IENsZWFyIHRpbWVvdXQgKHN0YXRlPVNFQVJDSCkKUDJQLUZJTkQtU1RPUFBFRCAKUDJQ
OiBTdGF0ZSBTRUFSQ0ggLT4gSURMRQpQMlA6IENsZWFyIHRpbWVvdXQgKHN0YXRlPUlETEUpClAy
UDogQ2xlYXIgZHJ2X2luX2xpc3RlbiAoMjQzNykKbmw4MDIxMTogQ2FuY2VsIHJlbWFpbi1vbi1j
aGFubmVsIHdpdGggY29va2llIDB4MjFjCm5sODAyMTE6IERpc2FibGUgUHJvYmUgUmVxdWVzdCBy
ZXBvcnRpbmcgbmxfcHJlcT0weDg4ODg4ODg4OGFlMDBkODkKcDJwLWRldi13bGFuMDogUmFkaW8g
d29yayAncDJwLWxpc3RlbidAMHgyNjg0NDYwIGRvbmUgaW4gMC4xODI0MTEgc2Vjb25kcwpQMlA6
ICogRGlhbG9nIFRva2VuOiAxClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5
IGRldj0yNSBncm91cD0wOApQMlA6ICogR08gSW50ZW50OiBJbnRlbnQgNyBUaWUgYnJlYWtlciAx
ClAyUDogKiBDb25maWd1cmF0aW9uIFRpbWVvdXQ6IEdPIDI1NSAoKjEwbXMpICBjbGllbnQgMjAg
KCoxMG1zKQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5l
bCA2ClAyUDogKiBJbnRlbmRlZCBQMlAgSW50ZXJmYWNlIEFkZHJlc3MgZmM6Zjg6YWU6Njk6OGE6
NjMKUDJQOiAqIENoYW5uZWwgTGlzdCAtIGhleGR1bXAobGVuPTE2KTogNTggNTggMDQgNTEgMGIg
MDEgMDIgMDMgMDQgMDUgMDYgMDcgMDggMDkgMGEgMGIKUDJQOiAqIERldmljZSBJbmZvClAyUDog
KiBPcGVyYXRpbmcgQ2hhbm5lbDogUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIDYKV1BTOiAg
KiBWZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKUDJQOiBXUFMgSUUgRGV2aWNlIFBhc3N3b3JkIElE
OiA0ClAyUDogU2VuZGluZyBHTyBOZWdvdGlhdGlvbiBSZXF1ZXN0ClAyUDogU3RhdGUgSURMRSAt
PiBDT05ORUNUClAyUDogU2NoZWR1bGUgbmV3IHJhZGlvIHdvcmsgZm9yIEFjdGlvbiBmcmFtZSBU
WCAobGlzdGVuX2ZyZXE9LTEgc2VuZF9mcmVxPS0xKQpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8g
d29yayAncDJwLXNlbmQtYWN0aW9uJ0AweDI2ODg0YjAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFk
aW8gd29yayBpdGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5CnAy
cC1kZXYtd2xhbjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1zZW5kLWFjdGlvbidAMHgyNjg4
NGIwIGFmdGVyIDAuMDAwMDI0IHNlY29uZCB3YWl0Ck9mZi1jaGFubmVsOiBTZW5kIGFjdGlvbiBm
cmFtZTogZnJlcT0yNDM3IGRzdD0xMjo2ODozZjo0ZTozOTpmMiBzcmM9ZmM6Zjg6YWU6Njk6OGE6
NjIgYnNzaWQ9MTI6Njg6M2Y6NGU6Mzk6ZjIgbGVuPTEyMQpubDgwMjExOiBTZW5kIEFjdGlvbiBm
cmFtZSAoaWZpbmRleD0wLCBmcmVxPTI0MzcgTUh6IHdhaXQ9NTAwIG1zIG5vX2Njaz0xKQpSVE1f
TkVXTElOSzogaWZpX2luZGV4PTE0IGlmbmFtZT1wMnAtd2xhbjAtMCBvcGVyc3RhdGU9MiBsaW5r
bW9kZT0wIGlmaV9mbGFncz0weDEwMDIgKCkKbmw4MDIxMTogSWdub3JlIGludGVyZmFjZSBkb3du
IGV2ZW50IHNpbmNlIGludGVyZmFjZSBwMnAtd2xhbjAtMCBpcyB1cApubDgwMjExOiBEcnYgRXZl
bnQgNTYgKE5MODAyMTFfQ01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9y
IHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0x
IGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIxYyAobWF0Y2gp
KQpwMnAtZGV2LXdsYW4wOiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNl
aXZlZApQMlA6IENhbmNlbCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlz
dGVuPTAgbXMgcGVuZGluZ19hY3Rpb25fdHg9MHgyNjg0MzkwKQpQMlA6IERyaXZlciBlbmRlZCBM
aXN0ZW4gc3RhdGUgKGZyZXE9MjQzNykKbmw4MDIxMTogRHJ2IEV2ZW50IDYwIChOTDgwMjExX0NN
RF9GUkFNRV9UWF9TVEFUVVMpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IEZy
YW1lIFRYIHN0YXR1cyBldmVudApubDgwMjExOiBBY3Rpb24gVFggc3RhdHVzOiBjb29raWU9MGZm
ZmY4ODAwYTdjYjE5MDAgKG1hdGNoKSAoYWNrPTEpCnAycC1kZXYtd2xhbjA6IEV2ZW50IFRYX1NU
QVRVUyAoMTgpIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IEVWRU5UX1RYX1NUQVRVUyBkc3Q9MTI6
Njg6M2Y6NGU6Mzk6ZjIgdHlwZT0wIHN0eXBlPTEzCk9mZi1jaGFubmVsOiBEZWxldGUgbWF0Y2hp
bmcgcGVuZGluZyBhY3Rpb24gZnJhbWUKT2ZmLWNoYW5uZWw6IFRYIHN0YXR1cyByZXN1bHQ9MCBj
Yj0weDQyZmJjMApQMlA6IEFjdGlvbiBmcmFtZSBUWCBjYWxsYmFjayAoc3RhdGU9MSBmcmVxPTI0
MzcgZHN0PTEyOjY4OjNmOjRlOjM5OmYyIHNyYz1mYzpmODphZTo2OTo4YTo2MiBic3NpZD0xMjo2
ODozZjo0ZTozOTpmMiByZXN1bHQ9MApQMlA6IEdPIE5lZ290aWF0aW9uIFJlcXVlc3QgVFggY2Fs
bGJhY2s6IHN1Y2Nlc3M9MQpQMlA6IFN0YXRlIENPTk5FQ1QgLT4gQ09OTkVDVApQMlA6IFNldCB0
aW1lb3V0IChzdGF0ZT1DT05ORUNUKTogMC41MDAwMDAgc2VjCm5sODAyMTE6IEJTUyBFdmVudCA1
OSAoTkw4MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6
IFJYIGZyYW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFsPS0yNyBzdHlwZT0xMyBsZW49MTYwCnAycC1k
ZXYtd2xhbjA6IEV2ZW50IFJYX01HTVQgKDIwKSByZWNlaXZlZApwMnAtZGV2LXdsYW4wOiBSZWNl
aXZlZCBBY3Rpb24gZnJhbWU6IFNBPTEyOjY4OjNmOjRlOjM5OmYyIENhdGVnb3J5PTQgRGF0YUxl
bj0xMzUgZnJlcT0yNDM3IE1IegpQMlA6IFJYIFAyUCBQdWJsaWMgQWN0aW9uIGZyb20gMTI6Njg6
M2Y6NGU6Mzk6ZjIKUDJQOiBSZWNlaXZlZCBHTyBOZWdvdGlhdGlvbiBSZXNwb25zZSBmcm9tIDEy
OjY4OjNmOjRlOjM5OmYyIChmcmVxPTI0MzcpClAyUDogUGFyc2luZyB0aGUgcmVjZWl2ZWQgbWVz
c2FnZQpQMlA6ICogRGlhbG9nIFRva2VuOiAxClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBEZXZp
Y2UgUGFzc3dvcmQgSUQ6IDAKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAwIGxl
bmd0aCAxClAyUDogKiBTdGF0dXM6IDEKUDJQOiBBdHRyaWJ1dGUgMiBsZW5ndGggMgpQMlA6ICog
RGV2aWNlIENhcGFiaWxpdHkgMjUgR3JvdXAgQ2FwYWJpbGl0eSAwMApQMlA6IEF0dHJpYnV0ZSA0
IGxlbmd0aCAxClAyUDogKiBHTyBJbnRlbnQ6IEludGVudCA2IFRpZSBicmVha2VyIDAKUDJQOiBB
dHRyaWJ1dGUgNSBsZW5ndGggMgpQMlA6ICogQ29uZmlndXJhdGlvbiBUaW1lb3V0ClAyUDogQXR0
cmlidXRlIDE3IGxlbmd0aCA1ClAyUDogKiBPcGVyYXRpbmcgQ2hhbm5lbDogQ291bnRyeSBERSgw
eDA0KSBSZWd1bGF0b3J5IENsYXNzIDgxIENoYW5uZWwgTnVtYmVyIDkKUDJQOiBBdHRyaWJ1dGUg
OSBsZW5ndGggNgpQMlA6ICogSW50ZW5kZWQgUDJQIEludGVyZmFjZSBBZGRyZXNzOiAxMjo2ODoz
Zjo0ZTpiOTpmMgpQMlA6IEF0dHJpYnV0ZSAxMSBsZW5ndGggMjQKUDJQOiAqIENoYW5uZWwgTGlz
dDogQ291bnRyeSBTdHJpbmcgJ0RFKDB4MDQpJwpQMlA6IEF0dHJpYnV0ZSAxMyBsZW5ndGggMzAK
UDJQOiAqIERldmljZSBJbmZvOiBhZGRyIDEyOjY4OjNmOjRlOjM5OmYyIHByaW1hcnkgZGV2aWNl
IHR5cGUgMTAtMDA1MEYyMDQtNSBkZXZpY2UgbmFtZSAnZHZkaHJtLW54JyBjb25maWcgbWV0aG9k
cyAweDE4OApQMlA6IEdPIE5lZ290aWF0aW9uIHJlamVjdGVkOiBzdGF0dXMgMQpQMlA6IFdhaXQg
Zm9yIHRoZSBwZWVyIHRvIGJlY29tZSByZWFkeSBmb3IgR08gTmVnb3RpYXRpb24KUDJQOiBTdGF0
ZSBDT05ORUNUIC0+IFdBSVRfUEVFUl9JRExFClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVdBSVRf
UEVFUl9JRExFKTogMC4wMDAwMDAgc2VjCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1z
ZW5kLWFjdGlvbidAMHgyNjg4NGIwIGRvbmUgaW4gMC4wMDY2MTEgc2Vjb25kcwpPZmYtY2hhbm5l
bDogQWN0aW9uIGZyYW1lIHNlcXVlbmNlIGRvbmUgbm90aWZpY2F0aW9uCm5sODAyMTE6IENhbmNl
bCBUWCBmcmFtZSB3YWl0OiBjb29raWU9MHhmZmZmODgwMGE3Y2IxOTAwClAyUDogVGltZW91dCAo
c3RhdGU9V0FJVF9QRUVSX0lETEUpClAyUDogR28gdG8gTGlzdGVuIHN0YXRlIHdoaWxlIHdhaXRp
bmcgZm9yIHRoZSBwZWVyIHRvIGJlY29tZSByZWFkeSBmb3IgR08gTmVnb3RpYXRpb24KUDJQOiBT
dGF0ZSBXQUlUX1BFRVJfSURMRSAtPiBXQUlUX1BFRVJfQ09OTkVDVApQMlA6IFN0YXJ0aW5nIHNo
b3J0IGxpc3RlbiBzdGF0ZSAoc3RhdGU9V0FJVF9QRUVSX0NPTk5FQ1QpCldQUzogICogVmVyc2lv
biAoaGFyZGNvZGVkIDB4MTApClAyUDogV1BTIElFIERldmljZSBQYXNzd29yZCBJRDogNApXUFM6
ICAqIFVVSUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUg
Z3JvdXA9MDAKUDJQOiAqIERldmljZSBJbmZvCnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3Jr
ICdwMnAtbGlzdGVuJ0AweDI2ODQ0NTAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29yayBp
dGVtIGluIHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5CnAycC1kZXYtd2xh
bjA6IFN0YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDQ1MCBhZnRlciAwLjAw
MDAwOCBzZWNvbmQgd2FpdApubDgwMjExOiBFbmFibGUgUHJvYmUgUmVxdWVzdCByZXBvcnRpbmcg
bmxfcHJlcT0weDI2ODg0MDAKbmw4MDIxMTogUmVnaXN0ZXIgZnJhbWUgdHlwZT0weDQwIG5sX2hh
bmRsZT0weDI2ODg0MDAgbWF0Y2g9Cm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGNvb2tpZSAw
eDIxZCBmb3IgZnJlcT0yNDM3IE1IeiBkdXJhdGlvbj0xMDIKbmw4MDIxMTogRHJ2IEV2ZW50IDU1
IChOTDgwMjExX0NNRF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xh
bjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0wIGZyZXE9MjQzNyBj
aGFubmVsX3R5cGU9MCBkdXJhdGlvbj0xMDIgY29va2llPTB4MjFkIChtYXRjaCkpCnAycC1kZXYt
d2xhbjA6IEV2ZW50IFJFTUFJTl9PTl9DSEFOTkVMICgyMSkgcmVjZWl2ZWQKT2ZmLWNoYW5uZWw6
IFNlbmQgQWN0aW9uIGNhbGxiYWNrICh3aXRob3V0X3JvYz0wIHBlbmRpbmdfYWN0aW9uX3R4PShu
aWwpKQpQMlA6IFN0YXJ0aW5nIExpc3RlbiB0aW1lb3V0KDAsMTAyNDAwKSBvbiBmcmVxPTI0Mzcg
YmFzZWQgb24gY2FsbGJhY2sKUDJQOiBTZXQgdGltZW91dCAoc3RhdGU9V0FJVF9QRUVSX0NPTk5F
Q1QpOiAwLjEyMjQwMCBzZWMKbmw4MDIxMTogRHJ2IEV2ZW50IDU2IChOTDgwMjExX0NNRF9DQU5D
RUxfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6
IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MSBmcmVxPTI0MzcgY2hhbm5lbF90eXBl
PTAgZHVyYXRpb249MCBjb29raWU9MHgyMWQgKG1hdGNoKSkKcDJwLWRldi13bGFuMDogRXZlbnQg
Q0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMICgyMikgcmVjZWl2ZWQKUDJQOiBDYW5jZWwgcmVtYWlu
LW9uLWNoYW5uZWwgY2FsbGJhY2sgKHAycF9sb25nX2xpc3Rlbj0wIG1zIHBlbmRpbmdfYWN0aW9u
X3R4PShuaWwpKQpwMnAtZGV2LXdsYW4wOiBSYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQ0
NTAgZG9uZSBpbiAwLjEwODUxNyBzZWNvbmRzClAyUDogRHJpdmVyIGVuZGVkIExpc3RlbiBzdGF0
ZSAoZnJlcT0yNDM3KQpQMlA6IFNraXAgc3RvcF9saXN0ZW4gc2luY2Ugbm90IGluIGxpc3Rlbl9v
bmx5IHN0YXRlLgpQMlA6IFRpbWVvdXQgKHN0YXRlPVdBSVRfUEVFUl9DT05ORUNUKQpQMlA6IFN0
YXRlIFdBSVRfUEVFUl9DT05ORUNUIC0+IFdBSVRfUEVFUl9JRExFClAyUDogU2V0IHRpbWVvdXQg
KHN0YXRlPVdBSVRfUEVFUl9JRExFKTogMC41MDAwMDAgc2VjClAyUDogVGltZW91dCAoc3RhdGU9
V0FJVF9QRUVSX0lETEUpClAyUDogR28gdG8gTGlzdGVuIHN0YXRlIHdoaWxlIHdhaXRpbmcgZm9y
IHRoZSBwZWVyIHRvIGJlY29tZSByZWFkeSBmb3IgR08gTmVnb3RpYXRpb24KUDJQOiBTdGF0ZSBX
QUlUX1BFRVJfSURMRSAtPiBXQUlUX1BFRVJfQ09OTkVDVApQMlA6IFN0YXJ0aW5nIHNob3J0IGxp
c3RlbiBzdGF0ZSAoc3RhdGU9V0FJVF9QRUVSX0NPTk5FQ1QpCldQUzogICogVmVyc2lvbiAoaGFy
ZGNvZGVkIDB4MTApClAyUDogV1BTIElFIERldmljZSBQYXNzd29yZCBJRDogNApXUFM6ICAqIFVV
SUQtRQpQMlA6ICogUDJQIElFIGhlYWRlcgpQMlA6ICogQ2FwYWJpbGl0eSBkZXY9MjUgZ3JvdXA9
MDAKUDJQOiAqIERldmljZSBJbmZvCnAycC1kZXYtd2xhbjA6IEFkZCByYWRpbyB3b3JrICdwMnAt
bGlzdGVuJ0AweDI2ODQzOTAKcDJwLWRldi13bGFuMDogRmlyc3QgcmFkaW8gd29yayBpdGVtIGlu
IHRoZSBxdWV1ZSAtIHNjaGVkdWxlIHN0YXJ0IGltbWVkaWF0ZWx5CnAycC1kZXYtd2xhbjA6IFN0
YXJ0aW5nIHJhZGlvIHdvcmsgJ3AycC1saXN0ZW4nQDB4MjY4NDM5MCBhZnRlciAwLjAwMDAxMSBz
ZWNvbmQgd2FpdApubDgwMjExOiBQcm9iZSBSZXF1ZXN0IHJlcG9ydGluZyBhbHJlYWR5IG9uISBu
bF9wcmVxPTB4ODg4ODg4ODg4YWUwMGM4OQpubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBjb29r
aWUgMHgyMWUgZm9yIGZyZXE9MjQzNyBNSHogZHVyYXRpb249MjA0Cm5sODAyMTE6IERydiBFdmVu
dCA1NSAoTkw4MDIxMV9DTURfUkVNQUlOX09OX0NIQU5ORUwpIHJlY2VpdmVkIGZvciBwMnAtZGV2
LXdsYW4wCm5sODAyMTE6IFJlbWFpbi1vbi1jaGFubmVsIGV2ZW50IChjYW5jZWw9MCBmcmVxPTI0
MzcgY2hhbm5lbF90eXBlPTAgZHVyYXRpb249MjA0IGNvb2tpZT0weDIxZSAobWF0Y2gpKQpwMnAt
ZGV2LXdsYW4wOiBFdmVudCBSRU1BSU5fT05fQ0hBTk5FTCAoMjEpIHJlY2VpdmVkCk9mZi1jaGFu
bmVsOiBTZW5kIEFjdGlvbiBjYWxsYmFjayAod2l0aG91dF9yb2M9MCBwZW5kaW5nX2FjdGlvbl90
eD0obmlsKSkKUDJQOiBTdGFydGluZyBMaXN0ZW4gdGltZW91dCgwLDIwNDgwMCkgb24gZnJlcT0y
NDM3IGJhc2VkIG9uIGNhbGxiYWNrClAyUDogU2V0IHRpbWVvdXQgKHN0YXRlPVdBSVRfUEVFUl9D
T05ORUNUKTogMC4yMjQ4MDAgc2VjCm5sODAyMTE6IERydiBFdmVudCA1NiAoTkw4MDIxMV9DTURf
Q0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgw
MjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTEgZnJlcT0yNDM3IGNoYW5uZWxf
dHlwZT0wIGR1cmF0aW9uPTAgY29va2llPTB4MjFlIChtYXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2
ZW50IENBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCAoMjIpIHJlY2VpdmVkClAyUDogQ2FuY2VsIHJl
bWFpbi1vbi1jaGFubmVsIGNhbGxiYWNrIChwMnBfbG9uZ19saXN0ZW49MCBtcyBwZW5kaW5nX2Fj
dGlvbl90eD0obmlsKSkKcDJwLWRldi13bGFuMDogUmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgy
Njg0MzkwIGRvbmUgaW4gMC4yMDQyNzYgc2Vjb25kcwpQMlA6IERyaXZlciBlbmRlZCBMaXN0ZW4g
c3RhdGUgKGZyZXE9MjQzNykKUDJQOiBTa2lwIHN0b3BfbGlzdGVuIHNpbmNlIG5vdCBpbiBsaXN0
ZW5fb25seSBzdGF0ZS4KUDJQOiBUaW1lb3V0IChzdGF0ZT1XQUlUX1BFRVJfQ09OTkVDVCkKUDJQ
OiBTdGF0ZSBXQUlUX1BFRVJfQ09OTkVDVCAtPiBXQUlUX1BFRVJfSURMRQpQMlA6IFNldCB0aW1l
b3V0IChzdGF0ZT1XQUlUX1BFRVJfSURMRSk6IDAuNTAwMDAwIHNlYwpQMlA6IFRpbWVvdXQgKHN0
YXRlPVdBSVRfUEVFUl9JRExFKQpQMlA6IEdvIHRvIExpc3RlbiBzdGF0ZSB3aGlsZSB3YWl0aW5n
IGZvciB0aGUgcGVlciB0byBiZWNvbWUgcmVhZHkgZm9yIEdPIE5lZ290aWF0aW9uClAyUDogU3Rh
dGUgV0FJVF9QRUVSX0lETEUgLT4gV0FJVF9QRUVSX0NPTk5FQ1QKUDJQOiBTdGFydGluZyBzaG9y
dCBsaXN0ZW4gc3RhdGUgKHN0YXRlPVdBSVRfUEVFUl9DT05ORUNUKQpXUFM6ICAqIFZlcnNpb24g
KGhhcmRjb2RlZCAweDEwKQpQMlA6IFdQUyBJRSBEZXZpY2UgUGFzc3dvcmQgSUQ6IDQKV1BTOiAg
KiBVVUlELUUKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIENhcGFiaWxpdHkgZGV2PTI1IGdy
b3VwPTAwClAyUDogKiBEZXZpY2UgSW5mbwpwMnAtZGV2LXdsYW4wOiBBZGQgcmFkaW8gd29yayAn
cDJwLWxpc3RlbidAMHgyNjg0MzkwCnAycC1kZXYtd2xhbjA6IEZpcnN0IHJhZGlvIHdvcmsgaXRl
bSBpbiB0aGUgcXVldWUgLSBzY2hlZHVsZSBzdGFydCBpbW1lZGlhdGVseQpwMnAtZGV2LXdsYW4w
OiBTdGFydGluZyByYWRpbyB3b3JrICdwMnAtbGlzdGVuJ0AweDI2ODQzOTAgYWZ0ZXIgMC4wMDAw
MDggc2Vjb25kIHdhaXQKbmw4MDIxMTogUHJvYmUgUmVxdWVzdCByZXBvcnRpbmcgYWxyZWFkeSBv
biEgbmxfcHJlcT0weDg4ODg4ODg4OGFlMDBjODkKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwg
Y29va2llIDB4MjFmIGZvciBmcmVxPTI0MzcgTUh6IGR1cmF0aW9uPTMwNwpubDgwMjExOiBEcnYg
RXZlbnQgNTUgKE5MODAyMTFfQ01EX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3IgcDJw
LWRldi13bGFuMApubDgwMjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTAgZnJl
cT0yNDM3IGNoYW5uZWxfdHlwZT0wIGR1cmF0aW9uPTMwNyBjb29raWU9MHgyMWYgKG1hdGNoKSkK
cDJwLWRldi13bGFuMDogRXZlbnQgUkVNQUlOX09OX0NIQU5ORUwgKDIxKSByZWNlaXZlZApPZmYt
Y2hhbm5lbDogU2VuZCBBY3Rpb24gY2FsbGJhY2sgKHdpdGhvdXRfcm9jPTAgcGVuZGluZ19hY3Rp
b25fdHg9KG5pbCkpClAyUDogU3RhcnRpbmcgTGlzdGVuIHRpbWVvdXQoMCwzMDcyMDApIG9uIGZy
ZXE9MjQzNyBiYXNlZCBvbiBjYWxsYmFjawpQMlA6IFNldCB0aW1lb3V0IChzdGF0ZT1XQUlUX1BF
RVJfQ09OTkVDVCk6IDAuMzI3MjAwIHNlYwpubDgwMjExOiBEcnYgRXZlbnQgNTYgKE5MODAyMTFf
Q01EX0NBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAK
bmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0xIGZyZXE9MjQzNyBjaGFu
bmVsX3R5cGU9MCBkdXJhdGlvbj0wIGNvb2tpZT0weDIxZiAobWF0Y2gpKQpwMnAtZGV2LXdsYW4w
OiBFdmVudCBDQU5DRUxfUkVNQUlOX09OX0NIQU5ORUwgKDIyKSByZWNlaXZlZApQMlA6IENhbmNl
bCByZW1haW4tb24tY2hhbm5lbCBjYWxsYmFjayAocDJwX2xvbmdfbGlzdGVuPTAgbXMgcGVuZGlu
Z19hY3Rpb25fdHg9KG5pbCkpCnAycC1kZXYtd2xhbjA6IFJhZGlvIHdvcmsgJ3AycC1saXN0ZW4n
QDB4MjY4NDM5MCBkb25lIGluIDAuMzA2NjM3IHNlY29uZHMKUDJQOiBEcml2ZXIgZW5kZWQgTGlz
dGVuIHN0YXRlIChmcmVxPTI0MzcpClAyUDogU2tpcCBzdG9wX2xpc3RlbiBzaW5jZSBub3QgaW4g
bGlzdGVuX29ubHkgc3RhdGUuClAyUDogVGltZW91dCAoc3RhdGU9V0FJVF9QRUVSX0NPTk5FQ1Qp
ClAyUDogU3RhdGUgV0FJVF9QRUVSX0NPTk5FQ1QgLT4gV0FJVF9QRUVSX0lETEUKUDJQOiBTZXQg
dGltZW91dCAoc3RhdGU9V0FJVF9QRUVSX0lETEUpOiAwLjUwMDAwMCBzZWMKUDJQOiBUaW1lb3V0
IChzdGF0ZT1XQUlUX1BFRVJfSURMRSkKUDJQOiBHbyB0byBMaXN0ZW4gc3RhdGUgd2hpbGUgd2Fp
dGluZyBmb3IgdGhlIHBlZXIgdG8gYmVjb21lIHJlYWR5IGZvciBHTyBOZWdvdGlhdGlvbgpQMlA6
IFN0YXRlIFdBSVRfUEVFUl9JRExFIC0+IFdBSVRfUEVFUl9DT05ORUNUClAyUDogU3RhcnRpbmcg
c2hvcnQgbGlzdGVuIHN0YXRlIChzdGF0ZT1XQUlUX1BFRVJfQ09OTkVDVCkKV1BTOiAgKiBWZXJz
aW9uIChoYXJkY29kZWQgMHgxMCkKUDJQOiBXUFMgSUUgRGV2aWNlIFBhc3N3b3JkIElEOiA0CldQ
UzogICogVVVJRC1FClAyUDogKiBQMlAgSUUgaGVhZGVyClAyUDogKiBDYXBhYmlsaXR5IGRldj0y
NSBncm91cD0wMApQMlA6ICogRGV2aWNlIEluZm8KcDJwLWRldi13bGFuMDogQWRkIHJhZGlvIHdv
cmsgJ3AycC1saXN0ZW4nQDB4MjY4NDM5MApwMnAtZGV2LXdsYW4wOiBGaXJzdCByYWRpbyB3b3Jr
IGl0ZW0gaW4gdGhlIHF1ZXVlIC0gc2NoZWR1bGUgc3RhcnQgaW1tZWRpYXRlbHkKcDJwLWRldi13
bGFuMDogU3RhcnRpbmcgcmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgyNjg0MzkwIGFmdGVyIDAu
MDAwMDA5IHNlY29uZCB3YWl0Cm5sODAyMTE6IFByb2JlIFJlcXVlc3QgcmVwb3J0aW5nIGFscmVh
ZHkgb24hIG5sX3ByZXE9MHg4ODg4ODg4ODhhZTAwYzg5Cm5sODAyMTE6IFJlbWFpbi1vbi1jaGFu
bmVsIGNvb2tpZSAweDIyMCBmb3IgZnJlcT0yNDM3IE1IeiBkdXJhdGlvbj0xMDIKbmw4MDIxMTog
RHJ2IEV2ZW50IDU1IChOTDgwMjExX0NNRF9SRU1BSU5fT05fQ0hBTk5FTCkgcmVjZWl2ZWQgZm9y
IHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUmVtYWluLW9uLWNoYW5uZWwgZXZlbnQgKGNhbmNlbD0w
IGZyZXE9MjQzNyBjaGFubmVsX3R5cGU9MCBkdXJhdGlvbj0xMDIgY29va2llPTB4MjIwIChtYXRj
aCkpCnAycC1kZXYtd2xhbjA6IEV2ZW50IFJFTUFJTl9PTl9DSEFOTkVMICgyMSkgcmVjZWl2ZWQK
T2ZmLWNoYW5uZWw6IFNlbmQgQWN0aW9uIGNhbGxiYWNrICh3aXRob3V0X3JvYz0wIHBlbmRpbmdf
YWN0aW9uX3R4PShuaWwpKQpQMlA6IFN0YXJ0aW5nIExpc3RlbiB0aW1lb3V0KDAsMTAyNDAwKSBv
biBmcmVxPTI0MzcgYmFzZWQgb24gY2FsbGJhY2sKUDJQOiBTZXQgdGltZW91dCAoc3RhdGU9V0FJ
VF9QRUVSX0NPTk5FQ1QpOiAwLjEyMjQwMCBzZWMKbmw4MDIxMTogQlNTIEV2ZW50IDU5IChOTDgw
MjExX0NNRF9GUkFNRSkgcmVjZWl2ZWQgZm9yIHAycC1kZXYtd2xhbjAKbmw4MDIxMTogUlggZnJh
bWUgZnJlcT0yNDM3IHNzaV9zaWduYWw9LTI2IHN0eXBlPTEzIGxlbj0xNjQKcDJwLWRldi13bGFu
MDogRXZlbnQgUlhfTUdNVCAoMjApIHJlY2VpdmVkCnAycC1kZXYtd2xhbjA6IFJlY2VpdmVkIEFj
dGlvbiBmcmFtZTogU0E9MTI6Njg6M2Y6NGU6Mzk6ZjIgQ2F0ZWdvcnk9NCBEYXRhTGVuPTEzOSBm
cmVxPTI0MzcgTUh6ClAyUDogUlggUDJQIFB1YmxpYyBBY3Rpb24gZnJvbSAxMjo2ODozZjo0ZToz
OTpmMgpQMlA6IFJlY2VpdmVkIEdPIE5lZ290aWF0aW9uIFJlcXVlc3QgZnJvbSAxMjo2ODozZjo0
ZTozOTpmMihmcmVxPTI0MzcpClAyUDogUGFyc2luZyB0aGUgcmVjZWl2ZWQgbWVzc2FnZQpQMlA6
ICogRGlhbG9nIFRva2VuOiAxClAyUDogUGFyc2luZyBXUFMgSUUKUDJQOiBEZXZpY2UgUGFzc3dv
cmQgSUQ6IDQKUDJQOiBQYXJzaW5nIFAyUCBJRQpQMlA6IEF0dHJpYnV0ZSAyIGxlbmd0aCAyClAy
UDogKiBEZXZpY2UgQ2FwYWJpbGl0eSAyNSBHcm91cCBDYXBhYmlsaXR5IDJhClAyUDogQXR0cmli
dXRlIDQgbGVuZ3RoIDEKUDJQOiAqIEdPIEludGVudDogSW50ZW50IDYgVGllIGJyZWFrZXIgMApQ
MlA6IEF0dHJpYnV0ZSA1IGxlbmd0aCAyClAyUDogKiBDb25maWd1cmF0aW9uIFRpbWVvdXQKUDJQ
OiBBdHRyaWJ1dGUgNiBsZW5ndGggNQpQMlA6ICogTGlzdGVuIENoYW5uZWw6IENvdW50cnkgREUo
MHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA2ClAyUDogQXR0cmlidXRl
IDkgbGVuZ3RoIDYKUDJQOiAqIEludGVuZGVkIFAyUCBJbnRlcmZhY2UgQWRkcmVzczogMTI6Njg6
M2Y6NGU6Yjk6ZjIKUDJQOiBBdHRyaWJ1dGUgMTEgbGVuZ3RoIDI0ClAyUDogKiBDaGFubmVsIExp
c3Q6IENvdW50cnkgU3RyaW5nICdERSgweDA0KScKUDJQOiBBdHRyaWJ1dGUgMTMgbGVuZ3RoIDMw
ClAyUDogKiBEZXZpY2UgSW5mbzogYWRkciAxMjo2ODozZjo0ZTozOTpmMiBwcmltYXJ5IGRldmlj
ZSB0eXBlIDEwLTAwNTBGMjA0LTUgZGV2aWNlIG5hbWUgJ2R2ZGhybS1ueCcgY29uZmlnIG1ldGhv
ZHMgMHg4MApQMlA6IEF0dHJpYnV0ZSAxNyBsZW5ndGggNQpQMlA6ICogT3BlcmF0aW5nIENoYW5u
ZWw6IENvdW50cnkgREUoMHgwNCkgUmVndWxhdG9yeSBDbGFzcyA4MSBDaGFubmVsIE51bWJlciA5
ClAyUDogUGVlciBjb3VudHJ5IC0gaGV4ZHVtcF9hc2NpaShsZW49Myk6CiAgICAgNDQgNDUgMDQg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBERV8gICAgICAgICAgICAg
ClAyUDogT3duIHJlZ19jbGFzc2VzIDEgcGVlciByZWdfY2xhc3NlcyAyIGludGVyc2VjdGlvbiBy
ZWdfY2xhc3NlcyAxClAyUDogUGVlciB1c2luZyBwdXNoYnV0dG9uClAyUDogb3duIGNoYW5uZWxz
OiA4MToxLDIsMyw0LDUsNiw3LDgsOSwxMCwxMQpQMlA6IHBlZXIgY2hhbm5lbHM6IDgxOjEsMiwz
LDQsNSw2LDcsOCw5LDEwLDExLDEyLDEzIDExNTozNiw0MCw0NCw0OApQMlA6IGludGVyc2VjdGlv
bjogODE6MSwyLDMsNCw1LDYsNyw4LDksMTAsMTEKUDJQOiBpbnRlcnNlY3Rpb24gYWZ0ZXIgbm8t
R08gcmVtb3ZhbDogODE6MSwyLDMsNCw1LDYsNyw4LDksMTAsMTEKUDJQOiBpbnRlcnNlY3Rpb24g
d2l0aCBsb2NhbCBjaGFubmVsIGxpc3Q6IDgxOjEsMiwzLDQsNSw2LDcsOCw5LDEwLDExClAyUDog
VHJ5IHRvIG9wdGltaXplIGNoYW5uZWwgc2VsZWN0aW9uIHdpdGggcGVlciBpbmZvcm1hdGlvbiBy
ZWNlaXZlZDsgcHJldmlvdXNseSBzZWxlY3RlZCBvcF9jbGFzcyA4MSBjaGFubmVsIDYKUDJQOiBV
c2luZyBvcmlnaW5hbCBvcGVyYXRpbmcgY2xhc3MgYW5kIGNoYW5uZWwgKG9wX2NsYXNzIDgxIGNo
YW5uZWwgNikgZnJvbSBpbnRlcnNlY3Rpb24KUDJQOiBQZWVyIG9wZXJhdGluZyBjaGFubmVsIHBy
ZWZlcmVuY2U6IDI0NTIgTUh6ClAyUDogR08gTmVnb3RpYXRpb24gd2l0aCAxMjo2ODozZjo0ZToz
OTpmMgpQMlA6IFN0b3BwaW5nIGZpbmQKUDJQOiBDbGVhciB0aW1lb3V0IChzdGF0ZT1XQUlUX1BF
RVJfQ09OTkVDVCkKUDJQOiBTdGF0ZSBXQUlUX1BFRVJfQ09OTkVDVCAtPiBJRExFClAyUDogU2tp
cCBzdG9wX2xpc3RlbiBzaW5jZSB3ZSBhcmUgb24gY29ycmVjdCBjaGFubmVsIGZvciByZXNwb25z
ZQpQMlA6IFN0YXRlIElETEUgLT4gR09fTkVHClAyUDogQ2xlYXIgdGltZW91dCAoc3RhdGU9R09f
TkVHKQpQMlA6IEJ1aWxkaW5nIEdPIE5lZ290aWF0aW9uIFJlc3BvbnNlClAyUDogKiBEaWFsb2cg
VG9rZW46IDEKUDJQOiAqIFAyUCBJRSBoZWFkZXIKUDJQOiAqIFN0YXR1czogMApQMlA6ICogQ2Fw
YWJpbGl0eSBkZXY9MjUgZ3JvdXA9MDgKUDJQOiAqIEdPIEludGVudDogSW50ZW50IDcgVGllIGJy
ZWFrZXIgMQpQMlA6ICogQ29uZmlndXJhdGlvbiBUaW1lb3V0OiBHTyAyNTUgKCoxMG1zKSAgY2xp
ZW50IDIwICgqMTBtcykKUDJQOiAqIE9wZXJhdGluZyBDaGFubmVsOiBSZWd1bGF0b3J5IENsYXNz
IDgxIENoYW5uZWwgNgpQMlA6ICogSW50ZW5kZWQgUDJQIEludGVyZmFjZSBBZGRyZXNzIGZjOmY4
OmFlOjY5OjhhOjYzClAyUDogKiBDaGFubmVsIExpc3QgLSBoZXhkdW1wKGxlbj0xNik6IDU4IDU4
IDA0IDUxIDBiIDAxIDAyIDAzIDA0IDA1IDA2IDA3IDA4IDA5IDBhIDBiClAyUDogKiBEZXZpY2Ug
SW5mbwpQMlA6ICogUDJQIEdyb3VwIElEIGZjOmY4OmFlOjY5OjhhOjYyClAyUDogUDJQIEdyb3Vw
IElEIFNTSUQgLSBoZXhkdW1wX2FzY2lpKGxlbj05KToKICAgICA0NCA0OSA1MiA0NSA0MyA1NCAy
ZCA2NSA2YyAgICAgICAgICAgICAgICAgICAgICAgIERJUkVDVC1lbCAgICAgICAKV1BTOiAgKiBW
ZXJzaW9uIChoYXJkY29kZWQgMHgxMCkKUDJQOiBXUFMgSUUgRGV2aWNlIFBhc3N3b3JkIElEOiA0
ClAyUDogU2VuZGluZyBHTyBOZWdvdGlhdGlvbiBSZXNwb25zZQpQMlA6IFVzZSBvbmdvaW5nIHJh
ZGlvIHdvcmsgZm9yIEFjdGlvbiBmcmFtZSBUWApPZmYtY2hhbm5lbDogU2VuZCBhY3Rpb24gZnJh
bWU6IGZyZXE9MjQzNyBkc3Q9MTI6Njg6M2Y6NGU6Mzk6ZjIgc3JjPWZjOmY4OmFlOjY5OjhhOjYy
IGJzc2lkPWZjOmY4OmFlOjY5OjhhOjYyIGxlbj0xMzUKbmw4MDIxMTogU2VuZCBBY3Rpb24gZnJh
bWUgKGlmaW5kZXg9MCwgZnJlcT0yNDM3IE1IeiB3YWl0PTUwMCBtcyBub19jY2s9MSkKbmw4MDIx
MTogRHJ2IEV2ZW50IDYwIChOTDgwMjExX0NNRF9GUkFNRV9UWF9TVEFUVVMpIHJlY2VpdmVkIGZv
ciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IEZyYW1lIFRYIHN0YXR1cyBldmVudApubDgwMjExOiBB
Y3Rpb24gVFggc3RhdHVzOiBjb29raWU9MGZmZmY4ODAxNDk1ZDRiMDAgKG1hdGNoKSAoYWNrPTEp
CnAycC1kZXYtd2xhbjA6IEV2ZW50IFRYX1NUQVRVUyAoMTgpIHJlY2VpdmVkCnAycC1kZXYtd2xh
bjA6IEVWRU5UX1RYX1NUQVRVUyBkc3Q9MTI6Njg6M2Y6NGU6Mzk6ZjIgdHlwZT0wIHN0eXBlPTEz
Ck9mZi1jaGFubmVsOiBEZWxldGUgbWF0Y2hpbmcgcGVuZGluZyBhY3Rpb24gZnJhbWUKT2ZmLWNo
YW5uZWw6IFRYIHN0YXR1cyByZXN1bHQ9MCBjYj0weDQyZmJjMApQMlA6IEFjdGlvbiBmcmFtZSBU
WCBjYWxsYmFjayAoc3RhdGU9MiBmcmVxPTI0MzcgZHN0PTEyOjY4OjNmOjRlOjM5OmYyIHNyYz1m
YzpmODphZTo2OTo4YTo2MiBic3NpZD1mYzpmODphZTo2OTo4YTo2MiByZXN1bHQ9MApQMlA6IEdP
IE5lZ290aWF0aW9uIFJlc3BvbnNlIFRYIGNhbGxiYWNrOiBzdWNjZXNzPTEKUDJQOiBTdGF0ZSBH
T19ORUcgLT4gQ09OTkVDVApQMlA6IFNldCB0aW1lb3V0IChzdGF0ZT1DT05ORUNUKTogMC41MDAw
MDAgc2VjCm5sODAyMTE6IEJTUyBFdmVudCA1OSAoTkw4MDIxMV9DTURfRlJBTUUpIHJlY2VpdmVk
IGZvciBwMnAtZGV2LXdsYW4wCm5sODAyMTE6IFJYIGZyYW1lIGZyZXE9MjQzNyBzc2lfc2lnbmFs
PS0yNiBzdHlwZT0xMyBsZW49NzQKcDJwLWRldi13bGFuMDogRXZlbnQgUlhfTUdNVCAoMjApIHJl
Y2VpdmVkCnAycC1kZXYtd2xhbjA6IFJlY2VpdmVkIEFjdGlvbiBmcmFtZTogU0E9MTI6Njg6M2Y6
NGU6Mzk6ZjIgQ2F0ZWdvcnk9NCBEYXRhTGVuPTQ5IGZyZXE9MjQzNyBNSHoKUDJQOiBSWCBQMlAg
UHVibGljIEFjdGlvbiBmcm9tIDEyOjY4OjNmOjRlOjM5OmYyClAyUDogUmVjZWl2ZWQgR08gTmVn
b3RpYXRpb24gQ29uZmlybSBmcm9tIDEyOjY4OjNmOjRlOjM5OmYyClAyUDogUGFyc2luZyB0aGUg
cmVjZWl2ZWQgbWVzc2FnZQpQMlA6ICogRGlhbG9nIFRva2VuOiAxClAyUDogUGFyc2luZyBQMlAg
SUUKUDJQOiBBdHRyaWJ1dGUgMCBsZW5ndGggMQpQMlA6ICogU3RhdHVzOiAwClAyUDogQXR0cmli
dXRlIDIgbGVuZ3RoIDIKUDJQOiAqIERldmljZSBDYXBhYmlsaXR5IDI1IEdyb3VwIENhcGFiaWxp
dHkgMDAKUDJQOiBBdHRyaWJ1dGUgMTcgbGVuZ3RoIDUKUDJQOiAqIE9wZXJhdGluZyBDaGFubmVs
OiBDb3VudHJ5IFhYKDB4MDQpIFJlZ3VsYXRvcnkgQ2xhc3MgODEgQ2hhbm5lbCBOdW1iZXIgNgpQ
MlA6IEF0dHJpYnV0ZSAxMSBsZW5ndGggMTYKUDJQOiAqIENoYW5uZWwgTGlzdDogQ291bnRyeSBT
dHJpbmcgJ0RFKDB4MDQpJwpQMlA6IDIwIG1zIHdhaXQgb24gY3VycmVudCBjaGFubmVsIGJlZm9y
ZSBzdGFydGluZyBncm91cApQMlA6IEdPIE5lZ290aWF0aW9uIHdpdGggMTI6Njg6M2Y6NGU6Mzk6
ZjIgY29tcGxldGVkIChsb2NhbCBlbmQgd2lsbCBiZSBHTykKUDJQOiBvd24gY2hhbm5lbHM6IDgx
OjEsMiwzLDQsNSw2LDcsOCw5LDEwLDExClAyUDogcGVlciBjaGFubmVsczogODE6MSwyLDMsNCw1
LDYsNyw4LDksMTAsMTEsMTIsMTMgMTE1OjM2LDQwLDQ0LDQ4ClAyUDogaW50ZXJzZWN0aW9uIGFm
dGVyIG5vLUdPIHJlbW92YWw6IDgxOjEsMiwzLDQsNSw2LDcsOCw5LDEwLDExClAyUDogQ2xlYXIg
dGltZW91dCAoc3RhdGU9Q09OTkVDVCkKUDJQOiBTdGF0ZSBDT05ORUNUIC0+IFBST1ZJU0lPTklO
RwpubDgwMjExOiBDYW5jZWwgcmVtYWluLW9uLWNoYW5uZWwgd2l0aCBjb29raWUgMHgyMjAKUDJQ
LUdPLU5FRy1TVUNDRVNTIHJvbGU9R08gZnJlcT0yNDM3IGh0NDA9MCBwZWVyX2Rldj0xMjo2ODoz
Zjo0ZTozOTpmMiBwZWVyX2lmYWNlPTEyOjY4OjNmOjRlOmI5OmYyIHdwc19tZXRob2Q9UEJDCnAy
cC1kZXYtd2xhbjA6IFAyUDogU3RhcnRpbmcgR08KcDJwLWRldi13bGFuMDogUDJQOiBSZXF1ZXN0
IHNjYW4gKHRoYXQgd2lsbCBiZSBza2lwcGVkKSB0byBzdGFydCBHTykKcDJwLWRldi13bGFuMDog
U2V0dGluZyBzY2FuIHJlcXVlc3Q6IDAuMDAwMDAwIHNlYwpwMnAtZGV2LXdsYW4wOiBTdGF0ZTog
RElTQ09OTkVDVEVEIC0+IFNDQU5OSU5HClN0YXJ0IGEgcHJlLXNlbGVjdGVkIG5ldHdvcmsgd2l0
aG91dCBzY2FuIHN0ZXAKU2V0dGluZyB1cCBBUCAoU1NJRD0nRElSRUNULWVsJykKbmw4MDIxMTog
U2V0dXAgQVAgb3BlcmF0aW9ucyBmb3IgUDJQIGdyb3VwIChHTykKbmw4MDIxMTogU2V0IG1vZGUg
aWZpbmRleCAwIGlmdHlwZSA5IChQMlBfR08pCm5sODAyMTE6IEZhaWxlZCB0byBzZXQgaW50ZXJm
YWNlIDAgdG8gbW9kZSA5OiAtMjIgKEludmFsaWQgYXJndW1lbnQpCm5sODAyMTE6IFRyeSBtb2Rl
IGNoYW5nZSBhZnRlciBzZXR0aW5nIGludGVyZmFjZSBkb3duCm5sODAyMTE6IFN0b3AgUDJQIERl
dmljZSBwMnAtZGV2LXdsYW4wICgweDEzKTogU3VjY2VzcwpubDgwMjExOiBTZXQgbW9kZSBpZmlu
ZGV4IDAgaWZ0eXBlIDkgKFAyUF9HTykKbmw4MDIxMTogRmFpbGVkIHRvIHNldCBpbnRlcmZhY2Ug
MCB0byBtb2RlIDk6IC0yMiAoSW52YWxpZCBhcmd1bWVudCkKbmw4MDIxMTogU3RhcnQgUDJQIERl
dmljZSBwMnAtZGV2LXdsYW4wICgweDEzKTogU3VjY2VzcwpubDgwMjExOiBJbnRlcmZhY2UgbW9k
ZSBjaGFuZ2UgdG8gOSBmcm9tIDEwIGZhaWxlZApubDgwMjExOiBSZW1vdmUgbW9uaXRvciBpbnRl
cmZhY2U6IHJlZmNvdW50PTAKcDJwLWRldi13bGFuMDogRmFpbGVkIHRvIHN0YXJ0IEFQIGZ1bmN0
aW9uYWxpdHkKcDJwLWRldi13bGFuMDogU3RhdGU6IFNDQU5OSU5HIC0+IERJU0NPTk5FQ1RFRApu
bDgwMjExOiBTZXQgcDJwLWRldi13bGFuMCBvcGVyc3RhdGUgMC0+MCAoRE9STUFOVCkKbmV0bGlu
azogT3BlcnN0YXRlOiBpZmluZGV4PTAgbGlua21vZGU9LTEgKG5vIGNoYW5nZSksIG9wZXJzdGF0
ZT01IChJRl9PUEVSX0RPUk1BTlQpCm5sODAyMTE6IERydiBFdmVudCA1NiAoTkw4MDIxMV9DTURf
Q0FOQ0VMX1JFTUFJTl9PTl9DSEFOTkVMKSByZWNlaXZlZCBmb3IgcDJwLWRldi13bGFuMApubDgw
MjExOiBSZW1haW4tb24tY2hhbm5lbCBldmVudCAoY2FuY2VsPTEgZnJlcT0yNDM3IGNoYW5uZWxf
dHlwZT0wIGR1cmF0aW9uPTAgY29va2llPTB4MjIwIChtYXRjaCkpCnAycC1kZXYtd2xhbjA6IEV2
ZW50IENBTkNFTF9SRU1BSU5fT05fQ0hBTk5FTCAoMjIpIHJlY2VpdmVkClAyUDogQ2FuY2VsIHJl
bWFpbi1vbi1jaGFubmVsIGNhbGxiYWNrIChwMnBfbG9uZ19saXN0ZW49MCBtcyBwZW5kaW5nX2Fj
dGlvbl90eD0obmlsKSkKcDJwLWRldi13bGFuMDogUmFkaW8gd29yayAncDJwLWxpc3RlbidAMHgy
Njg0MzkwIGRvbmUgaW4gMC4wNTgwNzcgc2Vjb25kcwpQMlA6IERyaXZlciBlbmRlZCBMaXN0ZW4g
c3RhdGUgKGZyZXE9MjQzNykKUDJQOiBTa2lwIHN0b3BfbGlzdGVuIHNpbmNlIG5vdCBpbiBsaXN0
ZW5fb25seSBzdGF0ZS4KUDJQOiBHcm91cCBGb3JtYXRpb24gdGltZWQgb3V0ClAyUDogR3JvdXAg
Rm9ybWF0aW9uIGZhaWxlZCB3aXRoIDEyOjY4OjNmOjRlOmI5OmYyClAyUDogQ2xlYXIgdGltZW91
dCAoc3RhdGU9UFJPVklTSU9OSU5HKQpQMlA6IFN0YXRlIFBST1ZJU0lPTklORyAtPiBJRExFClAy
UC1HUk9VUC1GT1JNQVRJT04tRkFJTFVSRSAKQ1RSTF9JRkFDRSBtb25pdG9yIHNlbnQgc3VjY2Vz
c2Z1bGx5IHRvIC90bXAvd3BhX2N0cmxfMTM2ODktMlx4MDAKQ1RSTF9JRkFDRSBtb25pdG9yIHNl
bnQgc3VjY2Vzc2Z1bGx5IHRvIC90bXAvd3BhX2N0cmxfMzMwLTEwMTE2NFx4MDAKUDJQLUdST1VQ
LVJFTU9WRUQgcDJwLWRldi13bGFuMCBHTyByZWFzb249Rk9STUFUSU9OX0ZBSUxFRApDVFJMX0lG
QUNFIG1vbml0b3Igc2VudCBzdWNjZXNzZnVsbHkgdG8gL3RtcC93cGFfY3RybF8xMzY4OS0yXHgw
MApDVFJMX0lGQUNFIG1vbml0b3Igc2VudCBzdWNjZXNzZnVsbHkgdG8gL3RtcC93cGFfY3RybF8z
MzAtMTAxMTY0XHgwMApQMlA6IFJlbW92ZSB0ZW1wb3JhcnkgZ3JvdXAgbmV0d29yawpwMnAtZGV2
LXdsYW4wOiBTdGF0ZTogRElTQ09OTkVDVEVEIC0+IERJU0NPTk5FQ1RFRApubDgwMjExOiBTZXQg
cDJwLWRldi13bGFuMCBvcGVyc3RhdGUgMC0+MCAoRE9STUFOVCkKbmV0bGluazogT3BlcnN0YXRl
OiBpZmluZGV4PTAgbGlua21vZGU9LTEgKG5vIGNoYW5nZSksIG9wZXJzdGF0ZT01IChJRl9PUEVS
X0RPUk1BTlQpCnAycC1kZXYtd2xhbjA6IFJlbW92aW5nIGludGVyZmFjZSBwMnAtZGV2LXdsYW4w
CnAycC1kZXYtd2xhbjA6IFJlcXVlc3QgdG8gZGVhdXRoZW50aWNhdGUgLSBic3NpZD0wMDowMDow
MDowMDowMDowMCBwZW5kaW5nX2Jzc2lkPTAwOjAwOjAwOjAwOjAwOjAwIHJlYXNvbj0zIHN0YXRl
PURJU0NPTk5FQ1RFRApwMnAtZGV2LXdsYW4wOiBTdGF0ZTogRElTQ09OTkVDVEVEIC0+IERJU0NP
Tk5FQ1RFRApubDgwMjExOiBTZXQgcDJwLWRldi13bGFuMCBvcGVyc3RhdGUgMC0+MCAoRE9STUFO
VCkKbmV0bGluazogT3BlcnN0YXRlOiBpZmluZGV4PTAgbGlua21vZGU9LTEgKG5vIGNoYW5nZSks
IG9wZXJzdGF0ZT01IChJRl9PUEVSX0RPUk1BTlQpCkVBUE9MOiBFeHRlcm5hbCBub3RpZmljYXRp
b24gLSBwb3J0RW5hYmxlZD0wCkVBUE9MOiBFeHRlcm5hbCBub3RpZmljYXRpb24gLSBwb3J0VmFs
aWQ9MApwMnAtZGV2LXdsYW4wOiBCU1M6IFJlbW92ZSBpZCAwIEJTU0lEIDAwOjE4OjM5OjBhOjhl
OjIzIFNTSUQgJ2Jsb2NrZmxvZXRlJyBkdWUgdG8gd3BhX2Jzc19mbHVzaApwMnAtZGV2LXdsYW4w
OiBCU1M6IFJlbW92ZSBpZCAxIEJTU0lEIDIwOjJiOmMxOjRiOjhmOmE0IFNTSUQgJ1dMQU4tOEZB
NDA2JyBkdWUgdG8gd3BhX2Jzc19mbHVzaApwMnAtZGV2LXdsYW4wOiBCU1M6IFJlbW92ZSBpZCAy
IEJTU0lEIDEwOmZlOmVkOjU2Ojc2OjljIFNTSUQgJ3dsYW4tbicgZHVlIHRvIHdwYV9ic3NfZmx1
c2gKcDJwLWRldi13bGFuMDogQ2FuY2VsbGluZyBkZWxheWVkIHNjaGVkIHNjYW4KcDJwLWRldi13
bGFuMDogQ2FuY2VsbGluZyBzY2FuIHJlcXVlc3QKcDJwLWRldi13bGFuMDogQ2FuY2VsbGluZyBh
dXRoZW50aWNhdGlvbiB0aW1lb3V0Cm5sODAyMTE6IERpc2FibGUgUHJvYmUgUmVxdWVzdCByZXBv
cnRpbmcgbmxfcHJlcT0weDg4ODg4ODg4OGFlMDBjODkKcDJwLWRldi13bGFuMDogUDJQOiBEaXNh
YmxlIFAyUCBzaW5jZSByZW1vdmluZyB0aGUgbWFuYWdlbWVudCBpbnRlcmZhY2UgaXMgYmVpbmcg
cmVtb3ZlZApQMlA6IFN0b3BwaW5nIGZpbmQKUDJQOiBDbGVhciB0aW1lb3V0IChzdGF0ZT1JRExF
KQpQMlA6IFN0YXRlIElETEUgLT4gSURMRQpQMlA6IENsZWFyIHRpbWVvdXQgKHN0YXRlPUlETEUp
ClAyUC1ERVZJQ0UtTE9TVCBwMnBfZGV2X2FkZHI9MTI6Njg6M2Y6NGU6Mzk6ZjIKUmVtb3ZlIGlu
dGVyZmFjZSBwMnAtZGV2LXdsYW4wIGZyb20gcmFkaW8gcGh5MApubDgwMjExOiBSZW1vdmUgbW9u
aXRvciBpbnRlcmZhY2U6IHJlZmNvdW50PTAKbmV0bGluazogT3BlcnN0YXRlOiBpZmluZGV4PTAg
bGlua21vZGU9MCAoa2VybmVsLWNvbnRyb2wpLCBvcGVyc3RhdGU9NiAoSUZfT1BFUl9VUCkKbmw4
MDIxMTogU3RvcCBQMlAgRGV2aWNlIHAycC1kZXYtd2xhbjAgKDB4MTMpOiBTdWNjZXNzCm5sODAy
MTE6IFVuc3Vic2NyaWJlIG1nbXQgZnJhbWVzIGhhbmRsZSAweDg4ODg4ODg4OGFlMGFiNzkgKGRl
aW5pdCkKbmw4MDIxMTogRGVsZXRlIFAyUCBEZXZpY2UgcDJwLWRldi13bGFuMCAoMHgxMyk6IFN1
Y2Nlc3MKcDJwLWRldi13bGFuMDogQ1RSTC1FVkVOVC1URVJNSU5BVElORyAKd2xhbjA6IFJlbW92
aW5nIGludGVyZmFjZSB3bGFuMAp3bGFuMDogUmVxdWVzdCB0byBkZWF1dGhlbnRpY2F0ZSAtIGJz
c2lkPTAwOjAwOjAwOjAwOjAwOjAwIHBlbmRpbmdfYnNzaWQ9MDA6MDA6MDA6MDA6MDA6MDAgcmVh
c29uPTMgc3RhdGU9RElTQ09OTkVDVEVECndsYW4wOiBTdGF0ZTogRElTQ09OTkVDVEVEIC0+IERJ
U0NPTk5FQ1RFRApubDgwMjExOiBTZXQgd2xhbjAgb3BlcnN0YXRlIDAtPjAgKERPUk1BTlQpCm5l
dGxpbms6IE9wZXJzdGF0ZTogaWZpbmRleD0zIGxpbmttb2RlPS0xIChubyBjaGFuZ2UpLCBvcGVy
c3RhdGU9NSAoSUZfT1BFUl9ET1JNQU5UKQpFQVBPTDogRXh0ZXJuYWwgbm90aWZpY2F0aW9uIC0g
cG9ydEVuYWJsZWQ9MApFQVBPTDogRXh0ZXJuYWwgbm90aWZpY2F0aW9uIC0gcG9ydFZhbGlkPTAK
d2xhbjA6IENhbmNlbGxpbmcgZGVsYXllZCBzY2hlZCBzY2FuCndsYW4wOiBDYW5jZWxsaW5nIHNj
YW4gcmVxdWVzdAp3bGFuMDogQ2FuY2VsbGluZyBhdXRoZW50aWNhdGlvbiB0aW1lb3V0ClAyUDog
UmVtb3ZpbmcgcGVuZGluZyBncm91cCBpbnRlcmZhY2UgcDJwLXdsYW4wLTAKbmw4MDIxMTogd3Bh
X2RyaXZlcl9ubDgwMjExX2lmX3JlbW92ZSh0eXBlPTUgaWZuYW1lPXAycC13bGFuMC0wKSBpZmlu
ZGV4PTE0IGFkZGVkX2lmPTAKbmw4MDIxMTogUmVtb3ZlIGludGVyZmFjZSBpZmluZGV4PTE0ClJl
bW92ZSBpbnRlcmZhY2Ugd2xhbjAgZnJvbSByYWRpbyBwaHkwClJlbW92ZSByYWRpbyBwaHkwCm5s
ODAyMTE6IFJlbW92ZSBtb25pdG9yIGludGVyZmFjZTogcmVmY291bnQ9MApuZXRsaW5rOiBPcGVy
c3RhdGU6IGlmaW5kZXg9MyBsaW5rbW9kZT0wIChrZXJuZWwtY29udHJvbCksIG9wZXJzdGF0ZT02
IChJRl9PUEVSX1VQKQpubDgwMjExOiBTZXQgbW9kZSBpZmluZGV4IDMgaWZ0eXBlIDIgKFNUQVRJ
T04pCm5sODAyMTE6IFVuc3Vic2NyaWJlIG1nbXQgZnJhbWVzIGhhbmRsZSAweDg4ODg4ODg4OGFl
ZWQzNzkgKG1vZGUgY2hhbmdlKQp3bGFuMDogQ1RSTC1FVkVOVC1URVJNSU5BVElORyAKQ1RSTF9J
RkFDRSBtb25pdG9yIHNlbnQgc3VjY2Vzc2Z1bGx5IHRvIC90bXAvd3BhX2N0cmxfMTM2ODktMlx4
MDAKQ1RSTF9JRkFDRSBtb25pdG9yIHNlbnQgc3VjY2Vzc2Z1bGx5IHRvIC90bXAvd3BhX2N0cmxf
MzMwLTEwMTE2NFx4MDAKQ1RSTF9JRkFDRSB3YWl0IGZvciBhdHRhY2hlZCBtb25pdG9ycyB0byBy
ZWNlaXZlIG1lc3NhZ2VzCkNvbnRyb2wgaW50ZXJmYWNlIGRpcmVjdG9yeSBub3QgZW1wdHkgLSBs
ZWF2aW5nIGl0IGJlaGluZAo=
--089e0111e270f0617d04efe044d8--
