Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35484 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbbGCAuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 20:50:03 -0400
Received: by wiga1 with SMTP id a1so165628205wig.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 17:50:01 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Jul 2015 10:50:01 +1000
Message-ID: <CAJNdBeAg-5dBz=3raiq8RfwF0jnJpAZhA+vGBHPGQ0gu514GFw@mail.gmail.com> (sfid-20150703_025011_992632_FCD271E4)
Subject: Incorrect reg domain set and locked on insertion of Proxim 8494 USB
 adapter with carl9170 driver
From: Ben Carbery <ben@bgcit.com.au>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the subject says..

I noticed that UNII-2E band was disabled on my laptop after inserting
a USB adapter. This appears to be due to the reg domain being updated
incorrectly as described below.

# System specs
Fully patched fedora 20, or
Fully patch kali linux (latest)
HP Spectre XT 13-2113TU


# Adapter specs
Branded as EKAHAU-NIC-USB 802.11n USB adapater
Probably Proxim 8494
FCC-ID NKR-DNUA81


# before insertion of usb adapter
# note DFS enabled in the regulatory domain
# AU is the correct domain
$ iw reg get
country AU: DFS-UNSET
(2402 - 2482 @ 40), (N/A, 20)
(5170 - 5250 @ 80), (N/A, 17)
(5250 - 5330 @ 80), (N/A, 24), DFS
(5490 - 5710 @ 160), (N/A, 24), DFS
(5735 - 5835 @ 80), (N/A, 30)


# after insertion of usb adapter
$ dmesg
[  418.392595] usb 1-2: new high-speed USB device number 2 using xhci_hcd
[  418.608456] usb 1-2: New USB device found, idVendor=0cf3, idProduct=9170
[  418.608467] usb 1-2: New USB device strings: Mfr=16, Product=32,
SerialNumber=48
[  418.608473] usb 1-2: Product: USB2.0 WLAN
[  418.608477] usb 1-2: Manufacturer: ATHER
[  418.608481] usb 1-2: SerialNumber: 12345
[  419.785321] usb 1-2: reset high-speed USB device number 2 using xhci_hcd
[  419.989396] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036451400
[  419.989406] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036451448
[  419.989411] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036451490
[  419.989416] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff8800364514d8
[  419.990430] usbcore: registered new interface driver carl9170
[  419.991523] usb 1-2: driver   API: 1.9.7 2012-12-15 [1-1]
[  419.991529] usb 1-2: firmware API: 1.9.6 2012-07-07
[  420.335058] ath: EEPROM regdomain: 0x0
[  420.335066] ath: EEPROM indicates default country code should be used
[  420.335069] ath: doing EEPROM country->regdmn map search
[  420.335073] ath: country maps to regdmn code: 0x3a
[  420.335077] ath: Country alpha2 being used: US
[  420.335079] ath: Regpair used: 0x3a
[  420.336136] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
[  420.336861] cfg80211: Calling CRDA for country: US
[  420.337919] usb 1-2: Atheros AR9170 is registered as 'phy1'
[  420.342581] carl9170 1-2:1.0 wlp0s20u2: renamed from wlan0
[  420.357781] cfg80211: Current regulatory domain intersected:
[  420.357785] systemd-udevd[1674]: renamed network interface wlan0 to wlp0s20u2
[  420.357788] cfg80211:  DFS Master region: unset
[  420.357789] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[  420.357792] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[  420.357795] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 1700 mBm), (N/A)
[  420.357798] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2300 mBm), (0 s)
[  420.357800] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 3000 mBm), (N/A)
[  420.548151] IPv6: ADDRCONF(NETDEV_UP): wlp0s20u2: link is not ready


# after insertion reg domain has changed..
$ iw reg get
country 98: DFS-UNSET
        (2402 - 2472 @ 40), (N/A, 20)
        (5170 - 5250 @ 80), (N/A, 17)
        (5250 - 5330 @ 80), (N/A, 23), DFS
        (5735 - 5835 @ 80), (N/A, 30)


# ..and cannot be changed back
# this also overrides the inbuilt adapter of course which now loses
connection to channel 100 for example
$ iw reg set AU
$ iw reg get
country 98: DFS-UNSET
        (2402 - 2472 @ 40), (N/A, 20)
        (5170 - 5250 @ 80), (N/A, 17)
        (5250 - 5330 @ 80), (N/A, 23), DFS
        (5735 - 5835 @ 80), (N/A, 30)


# in this state the UNII-2E band is disabled
$ iw phy1 info
Wiphy phy1
max # scan SSIDs: 4
max scan IEs length: 2257 bytes
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
 * mesh point
 * P2P-client
 * P2P-GO
Band 1:
Capabilities: 0x184e
HT20/HT40
SM Power Save disabled
RX HT40 SGI
No RX STBC
Max AMSDU length: 7935 bytes
DSSS/CCK HT40
Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
Minimum RX AMPDU time spacing: 8 usec (0x06)
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
* 2412 MHz [1] (30.0 dBm)
* 2417 MHz [2] (30.0 dBm)
* 2422 MHz [3] (30.0 dBm)
* 2427 MHz [4] (30.0 dBm)
* 2432 MHz [5] (30.0 dBm)
* 2437 MHz [6] (30.0 dBm)
* 2442 MHz [7] (30.0 dBm)
* 2447 MHz [8] (30.0 dBm)
* 2452 MHz [9] (30.0 dBm)
* 2457 MHz [10] (30.0 dBm)
* 2462 MHz [11] (30.0 dBm)
* 2467 MHz [12] (disabled)
* 2472 MHz [13] (disabled)
* 2484 MHz [14] (disabled)
Band 2:
Capabilities: 0x184e
HT20/HT40
SM Power Save disabled
RX HT40 SGI
No RX STBC
Max AMSDU length: 7935 bytes
DSSS/CCK HT40
Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
Minimum RX AMPDU time spacing: 8 usec (0x06)
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
* 4920 MHz [-16] (disabled)
* 4940 MHz [-12] (disabled)
* 4960 MHz [-8] (disabled)
* 4980 MHz [-4] (disabled)
* 5040 MHz [8] (disabled)
* 5060 MHz [12] (disabled)
* 5080 MHz [16] (disabled)
* 5180 MHz [36] (17.0 dBm)
* 5200 MHz [40] (17.0 dBm)
* 5220 MHz [44] (17.0 dBm)
* 5240 MHz [48] (17.0 dBm)
* 5260 MHz [52] (23.0 dBm) (passive scanning, no IBSS, radar detection)
  DFS state: usable (for 330 sec)
* 5280 MHz [56] (23.0 dBm) (passive scanning, no IBSS, radar detection)
  DFS state: usable (for 330 sec)
* 5300 MHz [60] (23.0 dBm) (passive scanning, no IBSS, radar detection)
  DFS state: usable (for 330 sec)
* 5320 MHz [64] (23.0 dBm) (passive scanning, no IBSS, radar detection)
  DFS state: usable (for 330 sec)
* 5500 MHz [100] (disabled)
* 5520 MHz [104] (disabled)
* 5540 MHz [108] (disabled)
* 5560 MHz [112] (disabled)
* 5580 MHz [116] (disabled)
* 5600 MHz [120] (disabled)
* 5620 MHz [124] (disabled)
* 5640 MHz [128] (disabled)
* 5660 MHz [132] (disabled)
* 5680 MHz [136] (disabled)
* 5700 MHz [140] (disabled)
* 5745 MHz [149] (30.0 dBm)
* 5765 MHz [153] (30.0 dBm)
* 5785 MHz [157] (30.0 dBm)
* 5805 MHz [161] (30.0 dBm)
* 5825 MHz [165] (30.0 dBm)
* 5170 MHz [34] (disabled)
* 5190 MHz [38] (17.0 dBm)
* 5210 MHz [42] (17.0 dBm)
* 5230 MHz [46] (17.0 dBm)
Supported commands:
 * new_interface
 * set_interface
 * new_key
 * start_ap
 * new_station
 * new_mpath
 * set_mesh_config
 * set_bss
 * authenticate
 * associate
 * deauthenticate
 * disassociate
 * join_ibss
 * join_mesh
 * remain_on_channel
 * set_tx_bitrate_mask
 * frame
 * frame_wait_cancel
 * set_wiphy_netns
 * set_channel
 * set_wds_peer
 * tdls_mgmt
 * tdls_oper
 * probe_client
 * set_noack_map
 * register_beacons
 * start_p2p_device
 * set_mcast_rate
 * Unknown command (104)
 * connect
 * disconnect
Supported TX frame types:
 * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
 * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
 * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
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
software interface modes (can always be added):
 * AP/VLAN
 * monitor
valid interface combinations:
 * #{ managed, AP, mesh point, P2P-client, P2P-GO } <= 2,
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
Device supports low priority scan.
Device supports scan flush.
Device supports AP scan.


# usb adapter is now removed
$ dmesg
[  804.819236] usb 1-2: USB disconnect, device number 2

# But reg domain stays at '98' and still cannot be set
$ iw reg get
country 98: DFS-UNSET
        (2402 - 2472 @ 40), (N/A, 20)
        (5170 - 5250 @ 80), (N/A, 17)
        (5250 - 5330 @ 80), (N/A, 23), DFS
        (5735 - 5835 @ 80), (N/A, 30)
$ iw reg set AU
$ iw reg get
country 98: DFS-UNSET
        (2402 - 2472 @ 40), (N/A, 20)
        (5170 - 5250 @ 80), (N/A, 17)
        (5250 - 5330 @ 80), (N/A, 23), DFS
        (5735 - 5835 @ 80), (N/A, 30)

I do not know enough to tell if this a driver or kernel issue. If
there's some other info that should be collected please provide
details.

B
