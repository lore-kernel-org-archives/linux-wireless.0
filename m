Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:48791 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaFWUzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 16:55:49 -0400
Received: by mail-yh0-f49.google.com with SMTP id f73so5505095yha.22
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 13:55:48 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 Jun 2014 22:55:48 +0200
Message-ID: <CAAnNoB_8MSR3S+VmFJUKKU4bO5zfeu1N_4-vQULqBf1_UbAqkg@mail.gmail.com> (sfid-20140623_225553_523356_B6B69C32)
Subject: No channels available (no IR) in 5Ghz band for intel 7260-ac
From: Victor <silentworks@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, first of all i'm not sure if this is the proper place to ask
since it seems mostly dev-related, but i have been looking everywhere
trying to find a solution without luck, so i'm not sure if i
encountered some kind of bug.

Context: Setup of wireless AP using an intel 7260-ac on 5Ghz+ band, linux 3.15.1

Problem found: the system shows all channels for Ghz band as (no IR),
so they can't be used

I have tried using "iw reg set" with several country codes, the only
change is which channels are set as "disabled", but on all the other
the (no IR) will remain anyways.
Also on the logs always appears the following:  "cfg80211:  DFS Master
region: unset"

Examples:

***********************
iw reg set US

iw reg get
country US: DFS-UNSET
        (2402 - 2472 @ 40), (N/A, 30)
        (5170 - 5250 @ 80), (N/A, 17)
        (5250 - 5330 @ 80), (N/A, 23), DFS
        (5735 - 5835 @ 80), (N/A, 30)
        (57240 - 63720 @ 2160), (N/A, 40)

                Frequencies:
                        * 5180 MHz [36] (16.0 dBm) (no IR)
                        * 5200 MHz [40] (16.0 dBm) (no IR)
                        * 5220 MHz [44] (16.0 dBm) (no IR)
                        * 5240 MHz [48] (16.0 dBm) (no IR)
                        * 5260 MHz [52] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 1 sec)
                        * 5280 MHz [56] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 1 sec)
                        * 5300 MHz [60] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 1 sec)
                        * 5320 MHz [64] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 1 sec)
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
                        * 5720 MHz [144] (disabled)
                        * 5745 MHz [149] (16.0 dBm) (no IR)
                        * 5765 MHz [153] (16.0 dBm) (no IR)
                        * 5785 MHz [157] (16.0 dBm) (no IR)
                        * 5805 MHz [161] (16.0 dBm) (no IR)
                        * 5825 MHz [165] (16.0 dBm) (no IR)
***********************************************

iw reg set FR

iw reg get
country FR: DFS-UNSET
        (2402 - 2482 @ 40), (N/A, 20)
        (5170 - 5250 @ 80), (N/A, 20)
        (5250 - 5330 @ 80), (N/A, 20), DFS
        (5490 - 5710 @ 80), (N/A, 27), DFS
        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR

 Frequencies:
                        * 5180 MHz [36] (16.0 dBm) (no IR)
                        * 5200 MHz [40] (16.0 dBm) (no IR)
                        * 5220 MHz [44] (16.0 dBm) (no IR)
                        * 5240 MHz [48] (16.0 dBm) (no IR)
                        * 5260 MHz [52] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5280 MHz [56] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5300 MHz [60] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5320 MHz [64] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5500 MHz [100] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5520 MHz [104] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5540 MHz [108] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5560 MHz [112] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5580 MHz [116] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5600 MHz [120] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5620 MHz [124] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5640 MHz [128] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5660 MHz [132] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5680 MHz [136] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5700 MHz [140] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 27 sec)
                        * 5720 MHz [144] (disabled)
                        * 5745 MHz [149] (disabled)
                        * 5765 MHz [153] (disabled)
                        * 5785 MHz [157] (disabled)
                        * 5805 MHz [161] (disabled)
                        * 5825 MHz [165] (disabled)
******************************************
System & device info:

********************
lspci -k
04:00.0 Network controller: Intel Corporation Wireless 7260 (rev 73)
        Subsystem: Intel Corporation Dual Band Wireless-AC 7260
        Kernel driver in use: iwlwifi
        Kernel modules: iwlwifi

************************
dmesg | grep 7260
[    1.473288] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
Wireless AC 7260, REV=0x144

***********************

dmesg | grep firmware
[    1.430175] iwlwifi 0000:04:00.0: loaded firmware version
23.214.9.0 op_mode iwlmvm

***************************
uname -a
Linux 3.15.1 #1 SMP PREEMPT Mon Jun 23 12:48:38 CEST 2014 x86_64

******************

iw phy (previously used ES reg code)

Wiphy phy0
        max # scan SSIDs: 20
        max scan IEs length: 393 bytes
        Coverage class: 0 (up to 0m)
        Device supports RSN-IBSS.
        Device supports AP-side u-APSD.
        Supported Ciphers:
                * CCMP (00-0f-ac:4)
                * TKIP (00-0f-ac:2)
                * WEP40 (00-0f-ac:1)
                * WEP104 (00-0f-ac:5)
                * CMAC (00-0f-ac:6)
                * WPI-SMS4 (00-14-72:1)
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
                Capabilities: 0x11e2
                        HT20/HT40
                        Static SM Power Save
                        RX HT20 SGI
                        RX HT40 SGI
                        TX STBC
                        RX STBC 1-stream
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
                        * 2467 MHz [12] (16.0 dBm) (no IR)
                        * 2472 MHz [13] (16.0 dBm) (no IR)
        Band 2:
                Capabilities: 0x11e2
                        HT20/HT40
                        Static SM Power Save
                        RX HT20 SGI
                        RX HT40 SGI
                        TX STBC
                        RX STBC 1-stream
                        Max AMSDU length: 3839 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 4 usec (0x05)
                HT TX/RX MCS rate indexes supported: 0-15, 32
                VHT Capabilities (0x038071a0):
                        Max MPDU length: 3895
                        Supported Channel Width: neither 160 nor 80+80
                        short GI (80 MHz)
                        TX STBC
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
                        * 5180 MHz [36] (16.0 dBm) (no IR)
                        * 5200 MHz [40] (16.0 dBm) (no IR)
                        * 5220 MHz [44] (16.0 dBm) (no IR)
                        * 5240 MHz [48] (16.0 dBm) (no IR)
                        * 5260 MHz [52] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5280 MHz [56] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5300 MHz [60] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5320 MHz [64] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5500 MHz [100] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5520 MHz [104] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5540 MHz [108] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5560 MHz [112] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5580 MHz [116] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5600 MHz [120] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5620 MHz [124] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5640 MHz [128] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5660 MHz [132] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5680 MHz [136] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5700 MHz [140] (16.0 dBm) (no IR, radar detection)
                          DFS state: usable (for 2 sec)
                        * 5720 MHz [144] (disabled)
                        * 5745 MHz [149] (disabled)
                        * 5765 MHz [153] (disabled)
                        * 5785 MHz [157] (disabled)
                        * 5805 MHz [161] (disabled)
                        * 5825 MHz [165] (disabled)
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
                 * start_sched_scan
                 * probe_client
                 * set_noack_map
                 * register_beacons
                 * start_p2p_device
                 * set_mcast_rate
                 * Unknown command (104)
                 * connect
                 * disconnect
        Supported TX frame types:
                 * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-device: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
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
                 * #{ managed } <= 1, #{ AP, P2P-client, P2P-GO } <=
1, #{ P2P-device } <= 1,
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
****************************

There isn't any error in dmesg or logs.


What can i do? If a try to create an AP with, for example, hostapd, on
802.11ac mode, it won't work at all saying "Configured channel (36)
not found from the channel list of current mode (2) IEEE 802.11a" etc,
the device works fine on 2.4Ghz band.


Thanks!
