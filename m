Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:45030 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab0BIVQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 16:16:49 -0500
Received: by bwz23 with SMTP id 23so676435bwz.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 13:16:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B6B69AB42555546BF8AEBDA21196517C5E0F1@ihq-app01.keywcorp.com>
References: <4B6B69AB42555546BF8AEBDA21196517C5E0F1@ihq-app01.keywcorp.com>
Date: Tue, 9 Feb 2010 22:16:46 +0100
Message-ID: <22ee4e771002091316x6812b57dg344384dcca07ad76@mail.gmail.com>
Subject: Re: hostapd using carl9270 doesn't send beacons
From: Christian Lamparter <chunkeey@googlemail.com>
To: Greg Munroe <gmunroe@keywcorp.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 9, 2010 at 8:15 PM, Greg Munroe <gmunroe@keywcorp.com> wrote:
> Hi,

Hello,

> Previously, I have used the AR9170 driver in AP mode. It works OK, but loses
> data often (even with power savings off).
Ermm, ar9170 never supported AP mode and carl9170 only
allows the most basic implementation.

> I heard about the new carl9170 driver and decided to give it a try. When I
> started hostapd, the following debug messages appears:
>
> Configuration file: /etc/hostapd.conf
>
> Opening raw packet socket for ifindex 128682944
> BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
> SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
> nl80211: Added 802.11b mode based on 802.11g information

WEXT?
the README has a "SYSTEM REQUIREMENTS" section:
" * hostapd 0.7.1+ fresh from git (only necessary for AP-Mode)"

> Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=20 dBm
> Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=20 dBm
[...]

> Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=20 dBm
> Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=20 dBm
[...]

> RATE[0] rate=10 flags=0x2
> RATE[1] rate=20 flags=0x6
> RATE[2] rate=55 flags=0x6
> RATE[3] rate=110 flags=0x6
> RATE[4] rate=60 flags=0x0
> RATE[5] rate=90 flags=0x0
> RATE[6] rate=120 flags=0x0
[...]
(OT: no 11g basic rates?)

> Passive scanning not supported
> Flushing old station entries
> Deauthenticate all stations
> Mode: IEEE 802.11g  Channel: 11  Frequency: 2462 MHz
> Using interface wlan0 with hwaddr 00:1f:33:f0:d3:14 and ssid 'M1000'
> SSID - hexdump_ascii(len=5):
[...]
> WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
> GMK - hexdump(len=32): [REMOVED]
> GTK - hexdump(len=32): [REMOVED]
> WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
> wlan0: Setup of interface done.
> MGMT (TX callback) ACK
>
> The beacons are never sent and I cannot see the AP from my laptop.
> Any help will be appreciated!
no word about carl9170 Version?

The latest carl9170 1.0.1.1 (together with hostap_0_7_1 and 2.6.33-rc6-wl)
should produce something like:

Configuration file: /etc/hostapd/hostapd-test-11g.conf
ctrl_interface_group=0
nl80211: Add own interface ifindex 52
nl80211: New interface mon.wlan2_renam created: ifindex=54
nl80211: Add own interface ifindex 54
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=27 dBm
[...]
RATE[0] rate=10 flags=0x1
RATE[1] rate=20 flags=0x0
RATE[2] rate=55 flags=0x0
RATE[3] rate=110 flags=0x1
RATE[4] rate=60 flags=0x1
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x1
[...]
Completing interface initialization
Mode: IEEE 802.11g  Channel: 1  Frequency: 2412 MHz
Flushing old station entries
Deauthenticate all stations
wpa_driver_nl80211_set_key: ifindex=52 alg=0 addr=(nil) key_idx=0
set_tx=1 seq_len=0 key_len=0
[...]
Using interface wlan2_rename with hwaddr 00:1f:33:e8:ff:ff and ssid 'EINFACH-G'
nl80211: Set beacon (beacon_set=0)
wlan2_rename: Setup of interface done.
Ignore event for foreign ifindex 54
Ignore event for foreign ifindex 54
Ignore event for foreign ifindex 54
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2_rename' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan2_rename' added
Unknown event 5
STA 00:22:43:0a:b8:f7 sent probe request for broadcast SSID
mgmt::proberesp cb
STA 00:22:43:0a:b8:f7 sent probe request for broadcast SSID
mgmt::proberesp cb
[...] and so on [...]

BTW: Neither carl9170, nor ar9170 support the crypto engine when AP/IBSS
is enabled. If you have a weak CPU (e.g.: ARM Atmel at91SAM9263 200mhz),
you should run openssl's algo benchmark to determine if the system can
actually handle WPA without dropping/delaying too many packages under
pressure.

Regards,
    Chr
