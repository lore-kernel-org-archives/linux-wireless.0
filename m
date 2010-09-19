Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.tomsknet.ru ([217.18.130.13]:56477 "EHLO
	relay.tomsknet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab0ISTeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 15:34:24 -0400
Received: from mx.komplektst.local (130.16.191.95.adsl.tomsknet.ru [95.191.16.130])
	by relay.tomsknet.ru (8.13.8/8.13.1) with ESMTP id o8JJ95G9046144
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 02:09:05 +0700 (NOVST)
	(envelope-from fix@stekloprom.ru)
Received: from [192.168.100.222] (helo=[127.0.0.1])
	by mx.komplektst.local with esmtpa (Exim 4.69)
	(envelope-from <fix@stekloprom.ru>)
	id 1OxPG4-0004Ce-Po
	for linux-wireless@vger.kernel.org; Mon, 20 Sep 2010 02:09:05 +0700
Message-ID: <4C965FDF.1090509@stekloprom.ru>
Date: Mon, 20 Sep 2010 02:09:19 +0700
From: Vladi <fix@stekloprom.ru>
Reply-To: fix@stekloprom.ru
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: dwa-552 in master mode 802.11n
Content-Type: text/plain; charset=KOI8-R; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!
I have an ubuntu 10.04 machine with dwa-552 + ath9k + hostapd. DWA-552 
works in master mode as AP in G mode quite good, transfer rate is 
~21mbit/sec (measured with iperf). But it won't go to 802.11n in master 
mode. I can't understand why, iwconfig on dwa-552 says:
wlan0     IEEE 802.11bgn  Mode:Master  Frequency:2.412 GHz  Tx-Power=27 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Power Management:off

I tried connecting with intel 4965agn from the same notebook but under 
different oses - MS Vista and Backtrack 4 RC1, both connect in G mode 
and give ~21mbit/sec. Under Vista I tried to turn off/on 802.11n mode in 
device manager, nothing changed, only G mode.
version of hostapd 0.6.9, from ubuntu repo, I compiled and ran 0.7.3 
from hostap.epitest.fi/hostapd, same picture - G mode works, N mode 
shows up but does not work.
I've noticed one curious thing when playing with "ht_capab" in 
hostapd.conf - when I have [HT40-] or [HT40+] in that line transfer rate 
is very low, it's around 4-6mbit/sec. When the line is commented out or 
has [HT20] speed rate is 21mbit/sec.

here's some info on the system:

uname -a:
Linux ubuntu 2.6.32-24-generic #43-Ubuntu SMP Thu Sep 16 14:17:33 UTC 
2010 i686 GNU/Linux

lspci -v:
01:07.0 Network controller: Atheros Communications Inc. AR5008 Wireless 
Network Adapter (rev 01)
         Subsystem: D-Link System Inc Device 3a6d
         Flags: bus master, 66MHz, medium devsel, latency 168, IRQ 19
         Memory at dfff0000 (32-bit, non-prefetchable) [size=64K]
         Capabilities: [40] #80 [0000]
         Kernel driver in use: ath9k
         Kernel modules: ath9k

lines from dmesg:
[   16.443999] phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81: 
mem=0xdc9c0000, irq=19
[   16.447697] cfg80211: Calling CRDA for country: CO
[   16.482455] cfg80211: Regulatory domain changed to country: CO
[   16.482460]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
[   16.482464]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[   16.482468]  (5170000 KHz - 5250000 KHz @ 20000 KHz), (300 mBi, 1700 mBm)
[   16.482471]  (5250000 KHz - 5330000 KHz @ 20000 KHz), (300 mBi, 2300 mBm)
[   16.482474]  (5735000 KHz - 5835000 KHz @ 20000 KHz), (300 mBi, 3000 mBm)

/etc/hostapd/hostapd.conf
interface=wlan0
driver=nl80211
ssid=softap-3
hw_mode=g
ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]
channel=7
wpa=3
wpa_key_mgmt=WPA-PSK
wpa_passphrase=pass
wpa_pairwise=CCMP
ieee80211n=1

iw list:
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
                         * 2412 MHz [1] (27.0 dBm)
                         * 2417 MHz [2] (27.0 dBm)
                         * 2422 MHz [3] (27.0 dBm)
                         * 2427 MHz [4] (27.0 dBm)
                         * 2432 MHz [5] (27.0 dBm)
                         * 2437 MHz [6] (27.0 dBm)
                         * 2442 MHz [7] (27.0 dBm)
                         * 2447 MHz [8] (27.0 dBm)
                         * 2452 MHz [9] (27.0 dBm)
                         * 2457 MHz [10] (27.0 dBm)
                         * 2462 MHz [11] (27.0 dBm)
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

iw dev wlan0 station dump:
Station 1c:4b:d6:d6:60:7e (on wlan0)
         inactive time:  8 ms
         rx bytes:       160983
         rx packets:     691
         tx bytes:       59479
         tx packets:     469
         signal:         -74 dBm
         tx bitrate:     54.0 MBit/

Vladi
