Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:52890 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaKZLO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 06:14:26 -0500
Received: by mail-la0-f48.google.com with SMTP id s18so2229894lam.21
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 03:14:25 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 26 Nov 2014 12:14:24 +0100
Message-ID: <CAOFH_kFLoErQYjR26NyjT7ooorQxFR-9ygGEJ8T6uCoX9mJV5Q@mail.gmail.com> (sfid-20141126_121429_369835_6C0B599A)
Subject: Regulatory domain issue with countrycode 00
From: Mathieu Slabbinck <matty.slabbinck@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a buildroot system with following versions:
- kernel 3.14.4
- iw 3.15
- ath9k vermagic 3.14.4
- cfg80211 vermagic 3.14.4
- wireless-regdb 2014.06.13

I see issues with the 00 countrycode.
Setting with "iw reg set 00" gives no errors.
iw reg get reports:
country 00: DFS-UNSET
    (2402 - 2472 @ 40), (N/A, 20), (N/A)
    (2457 - 2482 @ 40), (N/A, 20), (N/A), NO-IR
    (2474 - 2494 @ 20), (N/A, 20), (N/A), NO-OFDM, NO-IR
    (5170 - 5250 @ 160), (N/A, 20), (N/A), NO-IR
    (5250 - 5330 @ 160), (N/A, 20), (N/A), DFS, NO-IR
    (5490 - 5730 @ 160), (N/A, 20), (N/A), DFS, NO-IR
    (5735 - 5835 @ 80), (N/A, 20), (N/A), NO-IR
    (57240 - 63720 @ 2160), (N/A, 0), (N/A)

but iw list reports:
Wiphy phy0
    max # scan SSIDs: 4
    max scan IEs length: 2257 bytes
    Retry short limit: 7
    Retry long limit: 4
    Coverage class: 0 (up to 0m)
    Device supports RSN-IBSS.
    Device supports T-DLS.
    Supported Ciphers:
        * WEP40 (00-0f-ac:1)
        * WEP104 (00-0f-ac:5)
        * TKIP (00-0f-ac:2)
        * CCMP (00-0f-ac:4)
        * CMAC (00-0f-ac:6)
    Available Antennas: TX 0x3 RX 0x3
    Configured Antennas: TX 0x3 RX 0x3
    Supported interface modes:
         * IBSS
         * managed
         * AP
         * AP/VLAN
         * WDS
         * monitor
         * P2P-client
         * P2P-GO
    Band 1:
        Capabilities: 0x11ef
            RX LDPC
            HT20/HT40
            SM Power Save disabled
            RX HT20 SGI
            RX HT40 SGI
            TX STBC
            RX STBC 1-stream
            Max AMSDU length: 3839 bytes
            DSSS/CCK HT40
        Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
        Minimum RX AMPDU time spacing: 8 usec (0x06)
        HT TX/RX MCS rate indexes supported: 0-15
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
            * 2412 MHz [1] (20.0 dBm)
            * 2417 MHz [2] (20.0 dBm)
            * 2422 MHz [3] (20.0 dBm)
            * 2427 MHz [4] (20.0 dBm)
            * 2432 MHz [5] (20.0 dBm)
            * 2437 MHz [6] (20.0 dBm)
            * 2442 MHz [7] (20.0 dBm)
            * 2447 MHz [8] (20.0 dBm)
            * 2452 MHz [9] (20.0 dBm)
            * 2457 MHz [10] (20.0 dBm)
            * 2462 MHz [11] (20.0 dBm)
            * 2467 MHz [12] (20.0 dBm)
            * 2472 MHz [13] (20.0 dBm)
            * 2484 MHz [14] (disabled)
    Band 2:
        Capabilities: 0x11ef
            RX LDPC
            HT20/HT40
            SM Power Save disabled
            RX HT20 SGI
            RX HT40 SGI
            TX STBC
            RX STBC 1-stream
            Max AMSDU length: 3839 bytes
            DSSS/CCK HT40
        Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
        Minimum RX AMPDU time spacing: 8 usec (0x06)
        HT TX/RX MCS rate indexes supported: 0-15
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
            * 5180 MHz [36] (20.0 dBm)
            * 5200 MHz [40] (20.0 dBm)
            * 5220 MHz [44] (20.0 dBm)
            * 5240 MHz [48] (20.0 dBm)
            * 5260 MHz [52] (20.0 dBm) (no IR, radar detection)
              DFS state: usable (for 3029 sec)
            * 5280 MHz [56] (20.0 dBm) (no IR, radar detection)
              DFS state: usable (for 3029 sec)
            * 5300 MHz [60] (20.0 dBm) (no IR, radar detection)
              DFS state: usable (for 3029 sec)
            * 5320 MHz [64] (20.0 dBm) (no IR, radar detection)
              DFS state: usable (for 3029 sec)
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
            * 5745 MHz [149] (20.0 dBm)
            * 5765 MHz [153] (20.0 dBm)
            * 5785 MHz [157] (20.0 dBm)
            * 5805 MHz [161] (20.0 dBm)
            * 5825 MHz [165] (20.0 dBm)
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
         * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
         * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
         * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
         * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
         * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
         * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
         * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
         * P2P-device: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
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
         * #{ managed, WDS, P2P-client } <= 2048, #{ AP, P2P-GO } <= 8,
           total <= 2048, #channels <= 1, STA/AP BI must match
         * #{ IBSS, AP } <= 1,
           total <= 1, #channels <= 1, STA/AP BI must match, radar
detect widths: { 20 MHz (no HT), 20 MHz }

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

Of which the frequencies does not seem to be correct for 00.
Any ideas where this issue can be located and how this can be resolved?

Kr

Mathieu
