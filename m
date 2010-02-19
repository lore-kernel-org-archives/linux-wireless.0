Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64753 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab0BSPts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 10:49:48 -0500
Received: by bwz1 with SMTP id 1so174394bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 07:49:47 -0800 (PST)
Message-ID: <4B7EB318.3010707@googlemail.com>
Date: Fri, 19 Feb 2010 16:49:44 +0100
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Subject: ath9k+hostapd = "Could not set DTIM period for kernel driver"
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi hostapd-list!
Hi linux-wireless-list!

I have successfully installed kernel 2.6.32.8 using a debian system on a
flash card. In a small ALIX-board from PC-engines I am using
MiniPCI-WLAN Cards Model Senao EMP-7605 - those are 802.11n-cards and I
would like to test them regarding their speed. Therefore I compiled the
new kernel with ath9k enabled.

Ok, now I get the card running, iw can access it (see below for output
of iw list). I tried to make it become an accesspoint by using hostapd
in version 0.6.10(self-compiled for this sole purpose). Therefore I just
set up a very simple config for hostapd (seen below as well). The
problem is, that after starting hostapd I get this message:

:~# hostapd /etc/hostapd/hostapd.conf -ddd
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
Opening raw packet socket for ifindex 158188640
BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=20 dBm
RATE[0] rate=10 flags=0x2
RATE[1] rate=20 flags=0x6
RATE[2] rate=55 flags=0x4
RATE[3] rate=110 flags=0x4
Passive scanning not supported
Mode: IEEE 802.11b  Channel: 11  Frequency: 2462 MHz
Flushing old station entries
Deauthenticate all stations
Using interface wlan0 with hwaddr 00:0e:8e:24:52:2f and ssid 'hostapd_test'
Could not set DTIM period for kernel driver
wlan0: Unable to setup interface.
rmdir[ctrl_interface]: No such file or directory

What am I doing wrong? Could this be a bug? Any help would be appreciated.

Kind regards from Germany,
Dennis

output of comands mentioned before:
iw list:

:~# iw list
Wiphy phy0
    Band 1:
        Capabilities: 0x104e
            HT20/HT40
            SM Power Save disabled
            RX HT40 SGI
            No RX STBC
            Max AMSDU length: 7935 bytes
            DSSS/CCK HT40
        Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
        Minimum RX AMPDU time spacing: 8 usec (0x06)
        HT TX/RX MCS rate indexes supported: 0-15
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
        Capabilities: 0x104e
            HT20/HT40
            SM Power Save disabled
            RX HT40 SGI
            No RX STBC
            Max AMSDU length: 7935 bytes
            DSSS/CCK HT40
        Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
        Minimum RX AMPDU time spacing: 8 usec (0x06)
        HT TX/RX MCS rate indexes supported: 0-15
        Frequencies:
            * 5180 MHz [36] (20.0 dBm) (passive scanning, no IBSS)
            * 5200 MHz [40] (20.0 dBm) (passive scanning, no IBSS)
            * 5220 MHz [44] (20.0 dBm) (passive scanning, no IBSS)
            * 5240 MHz [48] (20.0 dBm) (passive scanning, no IBSS)
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
            * 5745 MHz [149] (20.0 dBm) (passive scanning, no IBSS)
            * 5765 MHz [153] (20.0 dBm) (passive scanning, no IBSS)
            * 5785 MHz [157] (20.0 dBm) (passive scanning, no IBSS)
            * 5805 MHz [161] (20.0 dBm) (passive scanning, no IBSS)
            * 5825 MHz [165] (20.0 dBm) (passive scanning, no IBSS)
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
    Supported interface modes:
         * IBSS
         * managed
         * AP
         * AP/VLAN
         * monitor
         * mesh point
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
         * set_wiphy_netns
         * connect
         * disconnect


hostapd.conf:
:~# cat /etc/hostapd/hostapd.conf
interface=wlan0
driver=nl80211
dump_file=/tmp/hostapd.dump
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=hostapd_test
channel=11
