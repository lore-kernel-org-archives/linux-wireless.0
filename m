Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62680 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423904Ab2LGETj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 23:19:39 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so1279685wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 20:19:37 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 6 Dec 2012 23:19:37 -0500
Message-ID: <CABqz=9K5tLt2=zKiPKBM7dz7G2yfkFKdQDX6NeJKy2S52MJdpQ@mail.gmail.com> (sfid-20121207_051943_604761_7C1D42AF)
Subject: "Failed to add BSS" with multiple SSID's on ath5k (AR2425)
From: Will McCutcheon <will.mccutcheon@controlgroup.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm attempting to configure two (and I hope eventually four) SSID's on
my Atheros AR2425-based card, but am getting an error. Some system
details first, then the output (and error) I'm getting from hostapd:

# uname -a
Linux demo-01 3.2.0-0.bpo.4-686-pae #1 SMP Debian 3.2.32-1~bpo60+1
i686 GNU/Linux

# dmesg |grep "ath5.*chip"
[    3.076088] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)

# hostapd -v
hostapd v0.6.10

# cat /etc/hostapd/hostapd.conf
interface=wlan0
driver=nl80211
ssid=demo1
channel=1
hw_mode=g
auth_algs=1

bss=wlan0_0
ssid=demo2

# hostapd -dd /etc/hostapd/hostapd.conf
Configuration file: /etc/hostapd/hostapd.conf
Opening raw packet socket for ifindex -1216462906
BSS count 2, BSSID mask ff:ff:ff:ff:ff:fe (1 bits)
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
RATE[2] rate=55 flags=0x6
RATE[3] rate=110 flags=0x6
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Passive scanning not supported
Mode: IEEE 802.11g  Channel: 1  Frequency: 2412 MHz
Flushing old station entries
Deauthenticate all stations
Using interface wlan0 with hwaddr 00:25:56:22:bf:04 and ssid 'demo1'
Could not set DTIM period for kernel driver
Failed to add BSS (BSSID=00:25:56:22:bf:05)
wlan0: Unable to setup interface.
Failed to remove interface.

That "Failed to add BSS" bit is where I'm stumped. I've seen several
people on mailing lists discussing the MAC address mask, and while I
haven't found an explanation of that idea that I fully understand, it
seems relevant so I've tried a few variations on my configuration
following their lead. My card's actual MAC address is
00:25:56:22:bf:04, but I've tried changing my card's MAC address using
the following commands:

ifconfig wlan0 down
ifconfig wlan0 hw ether 02:25:56:22:bf:04
ifconfig wlan0 up

I tried that particular address since one person said the first two
digits being "02" would make it locally-administered, which they
seemed to think was desireable. I also tried:

00:25:56:22:bf:00 (since another said the last digit should be 0)
02:25:56:22:bf:00 (trying both of those ideas at once)

I tried each of those MAC addresses both with and without a "bssid="
line appended to hostapd.conf followed by a wide array of
likely-seeming, neighboring MAC addresses (the last digit incremented
or decremented by 1 or more). Every time though, I get that error
message.

Does anyone have an idea of what I might be doing wrong? I'm at the
end of my rope! Thanks for your time.
