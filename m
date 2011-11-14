Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49096 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1KNHEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 02:04:11 -0500
Received: by wwe5 with SMTP id 5so3947548wwe.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Nov 2011 23:04:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAApCBGyo=+L_pY=xLeBnwPbY+Q-cNpRPw85SvCDKLfqu=vJ2+w@mail.gmail.com>
References: <CAApCBGyo=+L_pY=xLeBnwPbY+Q-cNpRPw85SvCDKLfqu=vJ2+w@mail.gmail.com>
Date: Mon, 14 Nov 2011 09:04:09 +0200
Message-ID: <CAApCBGzE3G-uReWtJ+BjyQoJOKjJDA8=N0cd6X+9aY-tROf-KA@mail.gmail.com> (sfid-20111114_080416_252595_65726FF9)
Subject: Fwd: ar9390 Support for master mode?
From: wireless newbie <wnewbie72@gmail.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, this doesn't seem to interest anyone in the wireless list.
Hopefully someone cares to respond from the ath9k list..

I experience this problem with station mode too. I get

ath: Unable to reset hardware; reset status -5 (freq 2412 MHz)
Could not set interface wlan0 flags: Input/output error
Could not set interface 'wlan0' UP

when starting wpa_supplicant. Could it be that ar9390 isn't really
supported by ath9k driver? I have quite recent compat wireless drivers
in use:

Compat-wireless backport release: compat-wireless-v3.1-rc8-1
Backport based on linux-2.6-allstable.git v3.1-rc8

Has anyone managed to use ar9390 in linux?



---------- Forwarded message ----------
From: wireless newbie <wnewbie72@gmail.com>
Date: 2011/11/11
Subject: ar9390 Support for master mode?
To: linux-wireless@vger.kernel.org


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
