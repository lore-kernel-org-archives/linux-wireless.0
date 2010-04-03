Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:24050 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab0DCN4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 09:56:53 -0400
Received: by qw-out-2122.google.com with SMTP id 8so951984qwh.37
        for <linux-wireless@vger.kernel.org>; Sat, 03 Apr 2010 06:56:52 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 3 Apr 2010 10:56:50 -0300
Message-ID: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com>
Subject: RTL 8187b - naughty behaviour
From: Rogerio Luz Coelho <rogluz.news@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, sorry for posting this in a DEV list, but I tried elsewhere and
people are generally kind, but unhelpfull. I am NOT a kernel
programer, so I will impose on the list´s good will somewhat ;)

I have a Laptop witch uses the Realtek rtl8187b chip in a USB internal
conection.

The chip WORKS in kernel Debian 2.6.32-3 , but is has an odd behavior:

It works, connects and gives me ADSL speed as long as I am no more
than 3 meters from the router. Beyond that I get a "wrong password"
message in NetworkManager or Wicd (tried them both with similar
results)

The bug is reproductible in Debian 2.6.32 Kernels i386 and amd64 and
in Ubuntu 9.10 64bit too, I had it working successfully on a Mandriva
2010.0 with the -12 kernel, but did not test it to it´s fullest. If
needed I  can do this.

logs:

This is when it works:

# dmesg | grep -e rtl -e wlan -e DEV -eth  --- (if you want I can post
the hole thing ... just ask)

[    0.000000]   AMD AuthenticAMD

[    0.022299] using mwait in idle threads.
[    0.022317] ... bit width:              40
[    0.427181] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    0.429174] Write protecting the kernel read-only data: 4096k
[    0.611824] thermal LNXTHERM:01: registered as thermal_zone0
[    1.468372] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.336632] EXT4-fs (sda1): mounted filesystem with ordered data mode
[    5.132551]  (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    5.153072] sis190 Gigabit Ethernet driver 1.3 loaded.
[    5.767461] phy0: Selected rate control algorithm 'minstrel'
[    5.768058] phy0: hwaddr 00:25:d3:8d:c0:c9, RTL8187BvE V0 +
rtl8225z2, rfkill mask 2
[    5.789720] rtl8187: Customer ID is 0x00
[    5.789768] Registered led device: rtl8187-phy0::tx
[    5.789794] Registered led device: rtl8187-phy0::rx
[    5.790585] rtl8187: wireless switch is on
[    5.790627] usbcore: registered new interface driver rtl8187
[    5.796669] 0000:00:04.0: SiS 191 PCI Gigabit Ethernet adapter at
ffffc9000067c000 (IRQ: 19), 00:90:f5:7f:c5:fa
[    5.796672] eth0: GMII mode.
[    5.796677] eth0: Enabling Auto-negotiation.
[    7.184634] EXT4-fs (sda4): mounted filesystem with ordered data
mode
[    7.272950] EXT4-fs (sda3): mounted filesystem with ordered data
mode
[    8.155997] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.176032] eth0: auto-negotiating...
[   25.895222] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   28.200040] eth0: auto-negotiating...
[   33.591014] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   33.753871] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   37.743070] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   42.301501] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 1)
[   42.500045] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 2)
[   42.503133] wlan0: direct probe responded
[   42.503138] wlan0: authenticate with AP 00:21:04:1a:21:f6 (try 1)
[   42.504765] wlan0: authenticated
[   42.504796] wlan0: associate with AP 00:21:04:1a:21:f6 (try 1)
[   42.704049] wlan0: associate with AP 00:21:04:1a:21:f6 (try 2)
[   42.710391] wlan0: RX AssocResp from 00:21:04:1a:21:f6 (capab=0x431
status=0 aid=2)
[   42.710397] wlan0: associated
[   42.716805] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   43.776030] eth0: auto-negotiating...
[   53.132025] wlan0: no IPv6 routers present
[   53.800034] eth0: auto-negotiating...

#iwconfig
lo        no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:"ascencao"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:21:04:1A:21:F6
          Bit Rate=11 Mb/s   Tx-Power=27 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=70/70  Signal level=-24 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

eth0      no wireless extensions.

------------------------------
------------------------

After I lose my connection :


[  986.760041] wlan0: deauthenticating from 00:21:04:1a:21:f6 by local
choice (reason=3)
[  990.634925] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  990.709238] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 1)
[  990.709283] wlan0: deauthenticating from 00:21:04:1a:21:f6 by local
choice (reason=3)
[  990.709336] wlan0: deauthenticating from 00:21:04:1a:21:f6 by local
choice (reason=3)
[  996.231091] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  996.252218] eth0: auto-negotiating...
[ 1000.138939] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1000.281959] ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 1004.258965] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1006.393244] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 1)
[ 1006.393291] wlan0: deauthenticating from 00:21:04:1a:21:f6 by local
choice (reason=3)
[ 1006.394229] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 1)
[ 1006.421352] wlan0: deauthenticating from 00:21:04:1a:21:f6 by local
choice (reason=3)
[ 1006.490373] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 1)
[ 1006.688038] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 2)
[ 1006.888040] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 3)
[ 1007.088036] wlan0: direct probe to AP 00:21:04:1a:21:f6 timed out
[ 1010.304034] eth0: auto-negotiating...
[ 1018.321348] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 1)
[ 1018.324471] wlan0: direct probe responded
[ 1018.324475] wlan0: authenticate with AP 00:21:04:1a:21:f6 (try 1)
[ 1018.524034] wlan0: authenticate with AP 00:21:04:1a:21:f6 (try 2)
[ 1018.724051] wlan0: authenticate with AP 00:21:04:1a:21:f6 (try 3)
[ 1018.924046] wlan0: authentication with AP 00:21:04:1a:21:f6 timed out
[ 1020.328034] eth0: auto-negotiating...
[ 1030.085319] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 1)
[ 1030.284047] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 2)
[ 1030.352032] eth0: auto-negotiating...
[ 1030.484045] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 3)
[ 1030.684045] wlan0: direct probe to AP 00:21:04:1a:21:f6 timed out
[ 1040.376032] eth0: auto-negotiating...
[ 1041.853285] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 1)
[ 1041.962037] wlan0: deauthenticating from 00:21:04:1a:21:f6 by local
choice (reason=3)
[ 1045.847791] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1045.917326] wlan0: direct probe to AP 00:21:04:1a:21:f6 (try 1)
[ 1045.917369] wlan0: deauthenticating from 00:21:04:1a:21:f6 by local
choice (reason=3)
[ 1045.917419] wlan0: deauthenticating from 00:21:04:1a:21:f6 by local
choice (reason=3)
[ 1046.034116] ADDRCONF(NETDEV_UP): eth0: link is not ready


# iwconfig
lo        no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:off/any
          Mode:Managed  Frequency:2.437 GHz  Access Point: Not-Associated
          Tx-Power=27 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off

eth0      no wireless extensions.


Here are some observations:

1) eth0 keeps auto-negotiating forever, as long as the box is powered
it still tries to negotiate even though no cable is connected.
2) see that when the deect occurs the probe was SUCCESSFULL the
authentication that failed

Anybody got a clue?

Thanks in advance

Rogerio
