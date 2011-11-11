Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47040 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab1KKI7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 03:59:49 -0500
Received: by wwe5 with SMTP id 5so999557wwe.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Nov 2011 00:59:47 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 11 Nov 2011 10:59:47 +0200
Message-ID: <CAApCBGyo=+L_pY=xLeBnwPbY+Q-cNpRPw85SvCDKLfqu=vJ2+w@mail.gmail.com> (sfid-20111111_095958_889180_514302F6)
Subject: ar9390 Support for master mode?
From: wireless newbie <wnewbie72@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Has any one used ar9390 based devices as an AP? I'm trying, but all
fails when I load hostapd:

ath9k 0000:01:00.0: mon.wlan0: Features changed: 0x00004800 -> 0x00004000
ath: Unable to reset hardware; reset status -5 (freq 2412 MHz)
Could not set interface mon.wlan0 flags: Input/output error
nl80211: Failed to set interface wlan0 into AP mode
nl80211 driver initialization failed.
ELOOP: remaining socket: sock=8 eloop_data=0x10219770
user_data=0x10219d18 handler=0x1002b8c0
ELOOP: remaining socket: sock=10 eloop_data=0x1021c0b8 user_data=(nil)
handler=0x100353e0

With iw, it seems that AP is part of the capabilities:

iw phy phy0 info

Wiphy phy0
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
                HT TX/RX MCS rate indexes supported: 0-23
                Frequencies:
                        * 2412 MHz [1] (17.0 dBm)
                        * 2417 MHz [2] (17.0 dBm)
                        * 2422 MHz [3] (17.0 dBm)
                        * 2427 MHz [4] (17.0 dBm)
                        * 2432 MHz [5] (17.0 dBm)
                        * 2437 MHz [6] (17.0 dBm)
                        * 2442 MHz [7] (17.0 dBm)
                        * 2447 MHz [8] (17.0 dBm)
                        * 2452 MHz [9] (17.0 dBm)
                        * 2457 MHz [10] (17.0 dBm)
                        * 2462 MHz [11] (17.0 dBm)
                        * 2467 MHz [12] (disabled)
                        * 2472 MHz [13] (disabled)
                        * 2484 MHz [14] (disabled)
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
                HT TX/RX MCS rate indexes supported: 0-23
                Frequencies:
                        * 5180 MHz [36] (18.0 dBm) (passive scanning, no IBSS)
                        * 5200 MHz [40] (18.0 dBm) (passive scanning, no IBSS)
                        * 5220 MHz [44] (18.0 dBm) (passive scanning, no IBSS)
                        * 5240 MHz [48] (18.0 dBm) (passive scanning, no IBSS)
                        * 5260 MHz [52] (disabled)
                        * 5280 MHz [56] (disabled)
                        * 5300 MHz [60] (disabled)
                        * 5320 MHz [64] (disabled)
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
                        * 5745 MHz [149] (18.0 dBm) (passive scanning, no IBSS)
                        * 5765 MHz [153] (18.0 dBm) (passive scanning, no IBSS)
                        * 5785 MHz [157] (18.0 dBm) (passive scanning, no IBSS)
                        * 5805 MHz [161] (18.0 dBm) (passive scanning, no IBSS)
                        * 5825 MHz [165] (18.0 dBm) (passive scanning, no IBSS)
                Bitrates (non-HT):
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        max scan IEs length: 2257 bytes
        Coverage class: 0 (up to 0m)
        Available Antennas: TX 0 RX 0
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * WDS
                 * monitor
                 * mesh point
                 * P2P-client
                 * P2P-GO
        Supported commands:
                 * new_interface
                 * set_interface
                 * new_key
                 * new_beacon
                 * new_station
                 * new_mpath
                 * set_mesh_params
                 * set_bss
                 * authenticate
                 * associate
                 * deauthenticate
                 * disassociate
                 * join_ibss
                 * join_mesh
                 * remain_on_channel
                 * set_tx_bitrate_mask
                 * action
                 * frame_wait_cancel
                 * set_wiphy_netns
                 * set_channel
                 * set_wds_peer
                 * connect
                 * disconnect
        Supported TX frame types:
                 * IBSS: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * managed: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * AP: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * AP/VLAN: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * mesh point: 0x0000 0x0010 0x0020 0x0030 0x0040
0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0
0x00f0
                 * P2P-client: 0x0000 0x0010 0x0020 0x0030 0x0040
0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0
0x00f0
                 * P2P-GO: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
        Supported RX frame types:
                 * IBSS: 0x00d0
                 * managed: 0x0040 0x00d0
                 * AP: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
                 * AP/VLAN: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
                 * mesh point: 0x00b0 0x00c0 0x00d0
                 * P2P-client: 0x0040 0x00d0
                 * P2P-GO: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0

Has anyone experienced something like this? Can this be related to my
hostapd config, or is this driver issue?

br, Sami
