Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:51525 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936315Ab3DJMR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 08:17:29 -0400
Received: by mail-qc0-f180.google.com with SMTP id b40so155192qcq.39
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 05:17:28 -0700 (PDT)
MIME-Version: 1.0
From: Axel Kittenberger <axkibe@gmail.com>
Date: Wed, 10 Apr 2013 14:17:07 +0200
Message-ID: <CABg07ftwCjMZrHM5U64zwnxRgDu_LmQ9hy-QXxmANgA4mvCpiw@mail.gmail.com> (sfid-20130410_141732_727499_814DCFD9)
Subject: Stumbled about network stalls
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear list,

I'm at the end of my wits on this as in I don't know what else to try,
so I'm getting at you as last resort. Tried IRC before as well.

I'm using a MacBook-Air.
WiFi generally works quite well for a year now (at home, various free
wifi places, workplace).
However, at two universities I recently tried, I get hugh stalls
(aprox 10 seconds) with only a few seconds working in between.
Running OSX instead of Linux "solves" the issue and I'm as far I know
I'm the only one here having this problem (as compared to windows
users, other notebooks.running linux etc.).

My idea is it may have to do with 802.11n or some other high tech
since the other networks I used as far I know were all rather
classical. I tried to rate limit with iwconfig but that is ignored by
the driver, and with iw I get at best a -22 invalid argument trying to
set a rate limit.

For example also pings run fine until I open some random webpage where
also pinging will stall while it tries to load. The problem persits in
both their networks encyrpted and open, so I don't think supplicant
has anything to do with it.

Heres all info I think that might be relevant.

Any ideas how to fix this welcomed

Thanks! Axel

$ lsmod | grep brc
brcmsmac              473905  0
cordic                 12352  1 brcmsmac
crc8                   12426  1 brcmsmac
brcmutil               12905  1 brcmsmac
mac80211              192806  1 brcmsmac
cfg80211              137243  2 mac80211,brcmsmac

$ iwconfig wlan0
wlan0     IEEE 802.11abgn  ESSID:"eduroam"
          Mode:Managed  Frequency:2.412 GHz  Access Point: XX:XX:XX:XX:XX:XX
          Bit Rate=58.5 Mb/s   Tx-Power=19 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=58/70  Signal level=-52 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:5   Missed beacon:0

$ iwconfig wlan0
wlan0     IEEE 802.11abgn  ESSID:"eduroam"
          Mode:Managed  Frequency:2.412 GHz  Access Point: XX:XX:XX:XX:XX:XX
          Bit Rate=72.2 Mb/s   Tx-Power=19 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=52/70  Signal level=-58 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:6   Missed beacon:0

$ iw wlan0 info
Interface wlan0
ifindex 2
type managed
wiphy 0

$ iw wlan0 station dump
Station b8:62:1f:78:c1:41 (on wlan0)
inactive time: 1600 ms
rx bytes: 3179141
rx packets: 13448
tx bytes: 105420
tx packets: 921
tx retries: 53
tx failed: 0
signal:   -53 dBm
signal avg: -53 dBm
tx bitrate: 72.2 MBit/s MCS 7 short GI
authorized: yes
authenticated: yes
preamble: long
WMM/WME: yes
MFP: no

$ cat /proc/version
Linux version 3.2.0-4-amd64 (debian-kernel@lists.debian.org) (gcc
version 4.6.3 (Debian 4.6.3-15) ) #1 SMP Debian 3.2.41-2

$ modinfo mac80211
filename:       /lib/modules/3.2.0-4-amd64/kernel/net/mac80211/mac80211.ko
license:        GPL
description:    IEEE 802.11 subsystem
depends:        cfg80211
intree:         Y
vermagic:       3.2.0-4-amd64 SMP mod_unload modversions
parm:           ieee80211_default_rc_algo:Default rate control
algorithm for mac80211 to use (charp)
parm:           max_nullfunc_tries:Maximum nullfunc tx tries before
disconnecting (reason 4). (int)
parm:           max_probe_tries:Maximum probe tries before
disconnecting (reason 4). (int)
parm:           probe_wait_ms:Maximum time(ms) to wait for probe
response before disconnecting (reason 4). (int)

$ modinfo brcmsmac
filename:
/lib/modules/3.2.0-4-amd64/kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
license:        Dual BSD/GPL
description:    Broadcom 802.11n wireless LAN driver.
author:         Broadcom Corporation
alias:          pci:v000014E4d00000576sv*sd*bc*sc*i*
alias:          pci:v000014E4d00004727sv*sd*bc*sc*i*
alias:          pci:v000014E4d00004353sv*sd*bc*sc*i*
alias:          pci:v000014E4d00004357sv*sd*bc*sc*i*
depends:        mac80211,brcmutil,cfg80211,cordic,crc8
intree:         Y
vermagic:       3.2.0-4-amd64 SMP mod_unload modversions

$ iw list
Wiphy phy0
Band 1:
Capabilities: 0x4070
HT20
Static SM Power Save
RX Greenfield
RX HT20 SGI
RX HT40 SGI
No RX STBC
Max AMSDU length: 3839 bytes
No DSSS/CCK HT40
40 MHz Intolerant
Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
Minimum RX AMPDU time spacing: 8 usec (0x06)
HT TX/RX MCS rate indexes supported: 0-15
Frequencies:
* 2412 MHz [1] (19.0 dBm)
* 2417 MHz [2] (19.0 dBm)
* 2422 MHz [3] (19.0 dBm)
* 2427 MHz [4] (19.0 dBm)
* 2432 MHz [5] (19.0 dBm)
* 2437 MHz [6] (19.0 dBm)
* 2442 MHz [7] (19.0 dBm)
* 2447 MHz [8] (19.0 dBm)
* 2452 MHz [9] (19.0 dBm)
* 2457 MHz [10] (19.0 dBm)
* 2462 MHz [11] (19.0 dBm)
* 2467 MHz [12] (19.0 dBm) (passive scanning, no IBSS)
* 2472 MHz [13] (19.0 dBm) (passive scanning, no IBSS)
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
Capabilities: 0x4070
HT20
Static SM Power Save
RX Greenfield
RX HT20 SGI
RX HT40 SGI
No RX STBC
Max AMSDU length: 3839 bytes
No DSSS/CCK HT40
40 MHz Intolerant
Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
Minimum RX AMPDU time spacing: 8 usec (0x06)
HT TX/RX MCS rate indexes supported: 0-15
Frequencies:
* 5180 MHz [36] (20.0 dBm)
* 5200 MHz [40] (20.0 dBm)
* 5220 MHz [44] (20.0 dBm)
* 5240 MHz [48] (20.0 dBm)
* 5260 MHz [52] (20.0 dBm) (passive scanning, no IBSS, radar detection)
* 5280 MHz [56] (20.0 dBm) (passive scanning, no IBSS, radar detection)
* 5300 MHz [60] (20.0 dBm) (passive scanning, no IBSS, radar detection)
* 5320 MHz [64] (20.0 dBm) (passive scanning, no IBSS, radar detection)
* 5500 MHz [100] (21.0 dBm) (passive scanning, no IBSS, radar detection)
* 5520 MHz [104] (21.0 dBm) (passive scanning, no IBSS, radar detection)
* 5540 MHz [108] (21.0 dBm) (passive scanning, no IBSS, radar detection)
* 5560 MHz [112] (21.0 dBm) (passive scanning, no IBSS, radar detection)
* 5580 MHz [116] (21.0 dBm) (passive scanning, no IBSS, radar detection)
* 5600 MHz [120] (21.0 dBm) (passive scanning, no IBSS, radar detection)
* 5620 MHz [124] (21.0 dBm) (passive scanning, no IBSS, radar detection)
* 5640 MHz [128] (21.0 dBm) (passive scanning, no IBSS, radar detection)
* 5660 MHz [132] (21.0 dBm) (passive scanning, no IBSS, radar detection)
* 5680 MHz [136] (21.0 dBm) (passive scanning, no IBSS, radar detection)
* 5700 MHz [140] (21.0 dBm) (passive scanning, no IBSS, radar detection)
* 5745 MHz [149] (disabled)
* 5765 MHz [153] (disabled)
* 5785 MHz [157] (disabled)
* 5805 MHz [161] (disabled)
* 5825 MHz [165] (disabled)
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
Supported Ciphers:
* WEP40 (00-0f-ac:1)
* WEP104 (00-0f-ac:5)
* TKIP (00-0f-ac:2)
* CCMP (00-0f-ac:4)
Available Antennas: TX 0 RX 0
Supported interface modes:
 * managed
 * monitor
software interface modes (can always be added):
 * monitor
interface combinations are not supported
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
Supported RX frame types:
 * IBSS: 0xd0
 * managed: 0x40 0xd0
 * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
 * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
 * mesh point: 0xb0 0xc0 0xd0
 * P2P-client: 0x40 0xd0
 * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
Device supports RSN-IBSS.
