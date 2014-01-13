Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42373 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaAMURP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:17:15 -0500
Received: by mail-ie0-f181.google.com with SMTP id at1so963298iec.12
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:17:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A0333565A8@HASMSX106.ger.corp.intel.com>
References: <CANq1E4Rhja6XZPq9sXfycK_wWNB3nsjpQFr2XnzOXLHUnm__mw@mail.gmail.com>
	<CANq1E4STKqci55ZbGP9Siorf3ABptHHTAuOg_4-bbbEiw93w+A@mail.gmail.com>
	<CB3B3D4774441E42AA3EA0E1BA8230A0333565A8@HASMSX106.ger.corp.intel.com>
Date: Mon, 13 Jan 2014 21:17:14 +0100
Message-ID: <CANq1E4TxWwJOdE4BQT9N=Uu4iZS-uuOizB1Yr5Y17HzOMkY7=w@mail.gmail.com> (sfid-20140113_211719_569289_7FA828BC)
Subject: Re: iwlwifi: P2P group-formation timeout
From: David Herrmann <dh.herrmann@gmail.com>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Jan 13, 2014 at 8:58 PM, Peer, Ilan <ilan.peer@intel.com> wrote:
> Hi David,
>
> My guess is that the root cause of the failure is the fact that the GoN ended with the local side trying to instantiate a GO on freq=5180 which probably not supported by your SKU. To verify this can u please send me the output of 'iw phy0 info'? Also can you please send the full log of the wpa_supplicant?

Full log is attached to the first message.

> One way to avoid this is to call  'wpa_cli set disallow_freq 5180-5800' before the GoN. Another way is to force the operating channel in the configuration file or in the p2p_connect command. You could also try to set a low go_intent so that the otherside would become a GO.

Ok, will try that later.

> Thanks in advance,
>
> Ilan.
>
>> > I run wpa_supplicant as:
>> >   wpa_supplicant -d -Dnl80211 -c wpa.conf -i wlan0 -p
>> > p2p_device=1,use_p2p_group_interface=1
>> >
>
> You can probably remove the use_p2p_group_interface=1 (although I need to see iw phy0 info output to make sure).

Yepp, only the p2p_device=1 is needed, indeed.

>> > My wpa.conf is:
>> >   ctrl_interface=/run/wpa_supplicant
>> >   ap_scan=1
>> >   p2p_go_ht40=1
>> >   device_name=david-ub
>> >   device_type=1-0050F204-1
>> >
>> > In wpa_cli I run:
>> >   p2p_find
>> >   p2p_connect 12:68:3f:4e:39:f2 pbc
>> >
>
> To start with, can you please verify that setting up a standalone GO works? You can do that using: wpa_cli p2p_group_add.

This works just fine.

>> >
>> > Lemme know if iwlwifi-debug options should be enabled and I can
>> > provide a full debug log.
>> > There are a bunch of errors in the wpa_supplicant log during startup,
>> > but I think they're related to nl80211+P2P_DEVICE and expected?
>
> No. Using the latest wpa_supplicant I do not see these warnings.
>
>> > These include:
>> >   Could not read interface p2p-dev-wlan0 flags: No such device
>> >   nl80211: Use separate P2P group interface (driver advertised support)
>> >   nl80211: interface p2p-dev-wlan0 in phy phy0
>> >   nl80211: Set mode ifindex 0 iftype 10 (P2P_DEVICE)
>> >   nl80211: Failed to set interface 0 to mode 10: -22 (Invalid
>> > argument)
>> >
>> > The GO-negotiation itself succeeds. However, the following
>> > group-formation fails, the relevant part of the log is probably this:
>> >
>> > P2P-GO-NEG-SUCCESS role=GO freq=5180 ht40=0
>> peer_dev=12:68:3f:4e:39:f2
>
> Here you can see that there is an attempt to start the GO on 5180.
>
>> >
>> > Any hints are welcome. If there's any debug-option I should enable to
>> > provide more logs, lemme know. I can also give iwlwifi-next a try if
>> > there're any important patches pending. The p2p-dev-wlan0 related
>> > errors are quite confusing, but I think they're caused by the fact
>
> Need to see the full log, to try and get a better grasp of these warinings.
>
>> > that there's no netdev for the device. At least I only have wlan0 and
>> > p2p-wlan0-0 during runtime, a p2p-dev-wlan0 never shows up.
>> >
>
> P2p-dev-wlan0 should not show up. It is an internal interface in the wpa_supplicant that is not associated to a network interface (and it shouldn't). The proper way to trigger P2P device flows is to do so using the global control interface of the wpa_supplicant.

ok, that's what I thought, thanks.

"iw list" is appended below. I'm not sure whether the suffix for phy?
and wlan? are the same. At least the device in question is "wlan0",
but I attached both, phy0 and phy1.

Thanks!
David

Wiphy phy1
max # scan SSIDs: 20
max scan IEs length: 195 bytes
Coverage class: 0 (up to 0m)
Device supports RSN-IBSS.
Supported Ciphers:
* WEP40 (00-0f-ac:1)
* WEP104 (00-0f-ac:5)
* TKIP (00-0f-ac:2)
* CCMP (00-0f-ac:4)
Available Antennas: TX 0 RX 0
Supported interface modes:
* IBSS
* managed
* AP
* AP/VLAN
* monitor
Band 1:
Capabilities: 0x1072
HT20/HT40
Static SM Power Save
RX Greenfield
RX HT20 SGI
RX HT40 SGI
No RX STBC
Max AMSDU length: 3839 bytes
DSSS/CCK HT40
Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
Minimum RX AMPDU time spacing: 4 usec (0x05)
HT TX/RX MCS rate indexes supported: 0-15, 32
Bitrates (non-HT):
* 1.0 Mbps
* 2.0 Mbps (short preamble supported)
* 5.5 Mbps (short preamble supported)
* 11.0 Mbps (short preamble supported)
* 6.0 Mbps
* 9.0 Mbps
* 12.0 Mbps
* 18.0 Mbps
* 24.0 Mbps
* 36.0 Mbps
* 48.0 Mbps
* 54.0 Mbps
Frequencies:
* 2412 MHz [1] (15.0 dBm)
* 2417 MHz [2] (15.0 dBm)
* 2422 MHz [3] (15.0 dBm)
* 2427 MHz [4] (15.0 dBm)
* 2432 MHz [5] (15.0 dBm)
* 2437 MHz [6] (15.0 dBm)
* 2442 MHz [7] (15.0 dBm)
* 2447 MHz [8] (15.0 dBm)
* 2452 MHz [9] (15.0 dBm)
* 2457 MHz [10] (15.0 dBm)
* 2462 MHz [11] (15.0 dBm)
* 2467 MHz [12] (15.0 dBm) (passive scanning, no IBSS)
* 2472 MHz [13] (15.0 dBm) (passive scanning, no IBSS)
Band 2:
Capabilities: 0x1072
HT20/HT40
Static SM Power Save
RX Greenfield
RX HT20 SGI
RX HT40 SGI
No RX STBC
Max AMSDU length: 3839 bytes
DSSS/CCK HT40
Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
Minimum RX AMPDU time spacing: 4 usec (0x05)
HT TX/RX MCS rate indexes supported: 0-15, 32
Bitrates (non-HT):
* 6.0 Mbps
* 9.0 Mbps
* 12.0 Mbps
* 18.0 Mbps
* 24.0 Mbps
* 36.0 Mbps
* 48.0 Mbps
* 54.0 Mbps
Frequencies:
* 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)
* 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)
* 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)
* 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)
* 5260 MHz [52] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5280 MHz [56] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5300 MHz [60] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5320 MHz [64] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5500 MHz [100] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5520 MHz [104] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5540 MHz [108] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5560 MHz [112] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5580 MHz [116] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5600 MHz [120] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5620 MHz [124] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5640 MHz [128] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5660 MHz [132] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5680 MHz [136] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5700 MHz [140] (15.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5745 MHz [149] (15.0 dBm) (passive scanning, no IBSS)
* 5765 MHz [153] (15.0 dBm) (passive scanning, no IBSS)
* 5785 MHz [157] (15.0 dBm) (passive scanning, no IBSS)
* 5805 MHz [161] (15.0 dBm) (passive scanning, no IBSS)
* 5825 MHz [165] (15.0 dBm) (passive scanning, no IBSS)
Supported commands:
* new_interface
* set_interface
* new_key
* start_ap
* new_station
* set_bss
* authenticate
* associate
* deauthenticate
* disassociate
* join_ibss
* set_tx_bitrate_mask
* frame
* frame_wait_cancel
* set_wiphy_netns
* set_channel
* set_wds_peer
* probe_client
* set_noack_map
* register_beacons
* start_p2p_device
* set_mcast_rate
* connect
* disconnect
Supported TX frame types:
* IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
* managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
* AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0
0xd0 0xe0 0xf0
* AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
* mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
* P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
* P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
* P2P-device: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
Supported RX frame types:
* IBSS: 0x40 0xb0 0xc0 0xd0
* managed: 0x40 0xd0
* AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
* AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
* mesh point: 0xb0 0xc0 0xd0
* P2P-client: 0x40 0xd0
* P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
* P2P-device: 0x40 0xd0
WoWLAN support:
* wake up on disconnect
* wake up on magic packet
* wake up on pattern match, up to 20 patterns of 16-128 bytes,
  maximum packet offset 0 bytes
* can do GTK rekeying
* wake up on GTK rekey failure
* wake up on EAP identity request
* wake up on rfkill release
software interface modes (can always be added):
* AP/VLAN
* monitor
valid interface combinations:
* #{ managed } <= 1, #{ AP } <= 1,
  total <= 2, #channels <= 1, STA/AP BI must match
* #{ managed } <= 2,
  total <= 2, #channels <= 1
HT Capability overrides:
* MCS: ff ff ff ff ff ff ff ff ff ff
* maximum A-MSDU length
* supported channel width
* short GI for 40 MHz
* max A-MPDU length exponent
* min MPDU start spacing
Device supports TX status socket option.
Device supports HT-IBSS.
Device supports scan flush.



Wiphy phy0
max # scan SSIDs: 20
max scan IEs length: 393 bytes
Coverage class: 0 (up to 0m)
Device supports RSN-IBSS.
Supported Ciphers:
* WEP40 (00-0f-ac:1)
* WEP104 (00-0f-ac:5)
* TKIP (00-0f-ac:2)
* CCMP (00-0f-ac:4)
* CMAC (00-0f-ac:6)
Available Antennas: TX 0 RX 0
Supported interface modes:
* IBSS
* managed
* AP
* AP/VLAN
* monitor
* P2P-client
* P2P-GO
* P2P-device
Band 1:
Capabilities: 0x1062
HT20/HT40
Static SM Power Save
RX HT20 SGI
RX HT40 SGI
No RX STBC
Max AMSDU length: 3839 bytes
DSSS/CCK HT40
Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
Minimum RX AMPDU time spacing: 4 usec (0x05)
HT TX/RX MCS rate indexes supported: 0-15, 32
Bitrates (non-HT):
* 1.0 Mbps
* 2.0 Mbps (short preamble supported)
* 5.5 Mbps (short preamble supported)
* 11.0 Mbps (short preamble supported)
* 6.0 Mbps
* 9.0 Mbps
* 12.0 Mbps
* 18.0 Mbps
* 24.0 Mbps
* 36.0 Mbps
* 48.0 Mbps
* 54.0 Mbps
Frequencies:
* 2412 MHz [1] (16.0 dBm)
* 2417 MHz [2] (16.0 dBm)
* 2422 MHz [3] (16.0 dBm)
* 2427 MHz [4] (16.0 dBm)
* 2432 MHz [5] (16.0 dBm)
* 2437 MHz [6] (16.0 dBm)
* 2442 MHz [7] (16.0 dBm)
* 2447 MHz [8] (16.0 dBm)
* 2452 MHz [9] (16.0 dBm)
* 2457 MHz [10] (16.0 dBm)
* 2462 MHz [11] (16.0 dBm)
* 2467 MHz [12] (16.0 dBm) (passive scanning, no IBSS)
* 2472 MHz [13] (16.0 dBm) (passive scanning, no IBSS)
Band 2:
Capabilities: 0x1062
HT20/HT40
Static SM Power Save
RX HT20 SGI
RX HT40 SGI
No RX STBC
Max AMSDU length: 3839 bytes
DSSS/CCK HT40
Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
Minimum RX AMPDU time spacing: 4 usec (0x05)
HT TX/RX MCS rate indexes supported: 0-15, 32
VHT Capabilities (0x03801120):
Max MPDU length: 3895
Supported Channel Width: neither 160 nor 80+80
short GI (80 MHz)
SU Beamformee
VHT RX MCS set:
1 streams: MCS 0-9
2 streams: MCS 0-9
3 streams: not supported
4 streams: not supported
5 streams: not supported
6 streams: not supported
7 streams: not supported
8 streams: not supported
VHT RX highest supported: 0 Mbps
VHT TX MCS set:
1 streams: MCS 0-9
2 streams: MCS 0-9
3 streams: not supported
4 streams: not supported
5 streams: not supported
6 streams: not supported
7 streams: not supported
8 streams: not supported
VHT TX highest supported: 0 Mbps
Bitrates (non-HT):
* 6.0 Mbps
* 9.0 Mbps
* 12.0 Mbps
* 18.0 Mbps
* 24.0 Mbps
* 36.0 Mbps
* 48.0 Mbps
* 54.0 Mbps
Frequencies:
* 5180 MHz [36] (16.0 dBm) (passive scanning, no IBSS)
* 5200 MHz [40] (16.0 dBm) (passive scanning, no IBSS)
* 5220 MHz [44] (16.0 dBm) (passive scanning, no IBSS)
* 5240 MHz [48] (16.0 dBm) (passive scanning, no IBSS)
* 5260 MHz [52] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5280 MHz [56] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5300 MHz [60] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5320 MHz [64] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5500 MHz [100] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5520 MHz [104] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5540 MHz [108] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5560 MHz [112] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5580 MHz [116] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5600 MHz [120] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5620 MHz [124] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5640 MHz [128] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5660 MHz [132] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5680 MHz [136] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5700 MHz [140] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5720 MHz [144] (16.0 dBm) (passive scanning, no IBSS, radar detection)
 DFS state: usable (for 507452 sec)
* 5745 MHz [149] (16.0 dBm) (passive scanning, no IBSS)
* 5765 MHz [153] (16.0 dBm) (passive scanning, no IBSS)
* 5785 MHz [157] (16.0 dBm) (passive scanning, no IBSS)
* 5805 MHz [161] (16.0 dBm) (passive scanning, no IBSS)
* 5825 MHz [165] (16.0 dBm) (passive scanning, no IBSS)
Supported commands:
* new_interface
* set_interface
* new_key
* start_ap
* new_station
* set_bss
* authenticate
* associate
* deauthenticate
* disassociate
* join_ibss
* remain_on_channel
* set_tx_bitrate_mask
* frame
* frame_wait_cancel
* set_wiphy_netns
* set_channel
* set_wds_peer
* start_sched_scan
* probe_client
* set_noack_map
* register_beacons
* start_p2p_device
* set_mcast_rate
* connect
* disconnect
Supported TX frame types:
* IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
* managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
* AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0
0xd0 0xe0 0xf0
* AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
* mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
* P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
* P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
* P2P-device: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
Supported RX frame types:
* IBSS: 0x40 0xb0 0xc0 0xd0
* managed: 0x40 0xd0
* AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
* AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
* mesh point: 0xb0 0xc0 0xd0
* P2P-client: 0x40 0xd0
* P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
* P2P-device: 0x40 0xd0
WoWLAN support:
* wake up on disconnect
* wake up on magic packet
* wake up on pattern match, up to 20 patterns of 16-128 bytes,
  maximum packet offset 0 bytes
* can do GTK rekeying
* wake up on GTK rekey failure
* wake up on EAP identity request
* wake up on 4-way handshake
* wake up on rfkill release
* wake up on TCP connection
software interface modes (can always be added):
* AP/VLAN
* monitor
valid interface combinations:
* #{ managed } <= 1, #{ AP, P2P-client, P2P-GO } <= 1, #{ P2P-device } <= 1,
  total <= 3, #channels <= 1
HT Capability overrides:
* MCS: ff ff ff ff ff ff ff ff ff ff
* maximum A-MSDU length
* supported channel width
* short GI for 40 MHz
* max A-MPDU length exponent
* min MPDU start spacing
Device supports TX status socket option.
Device supports HT-IBSS.
Device supports scan flush.
