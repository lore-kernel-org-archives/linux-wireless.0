Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60148 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755985AbdJLXIx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 19:08:53 -0400
Date: Fri, 13 Oct 2017 00:08:45 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: linux-wireless@vger.kernel.org, "Reizer, Eyal" <eyalr@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>
Subject: wl1837: poor performance?
Message-ID: <20171012230845.GA29517@n2100.armlinux.org.uk> (sfid-20171013_010859_084430_8ED8BCCA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 12, 2017 at 10:59:25AM +0100, Russell King - ARM Linux wrote:
> It looks like ti wilink is unmaintained, so I've added some people who
> have touched the driver recently.
> 
> Running wl1837 on a Hummingboard2 (iMX6 Dual core) I've seen one instance
> of the warning below.  Luckily, the recovery worked and connectivity was
> maintained.

I also have a question about seemingly poor performance of this driver,
so starting a new thread.

When running a ping on two clients (and only two clients) connected to
a single AP:

AP: Broadcom brcmfmac bcm4330 Linux machine.

With a ping running on each client machine, the AP reports:
# iw wlan0 station dump
Station a4:xx:xx:xx:xx:xx (on wlan0) <-- rtl8192eu
        inactive time:  0 ms
        rx packets:     6846
        tx packets:     2108
        tx failed:      0
        tx bitrate:     13.0 MBit/s
        rx bitrate:     19.5 MBit/s
        authorized:     yes
        authenticated:  yes
        WMM/WME:        yes
        TDLS peer:      no
Station 00:0f:00:xx:xx:xx (on wlan0) <-- wl1837
        inactive time:  0 ms
        rx packets:     589233
        tx packets:     360969
        tx failed:      737
        tx bitrate:     13.0 MBit/s
        rx bitrate:     19.5 MBit/s
        authorized:     yes
        authenticated:  yes
        WMM/WME:        yes
        TDLS peer:      no

Client 1: wl1837 using mainline driver:
# iw wlan0 link
Connected to xx:xx:xx:xx:xx:xx (on wlan0)
        SSID: XXXX
        freq: 2447
        RX: 223158 bytes (2307 packets)
        TX: 1502828 bytes (1955 packets)
        signal: -78 dBm
        tx bitrate: 19.5 MBit/s MCS 2

        bss flags:      short-preamble short-slot-time
        dtim period:    2
        beacon int:     100

Ping statistics:
64 bytes from 192.168.250.1: icmp_seq=85 ttl=64 time=10.6 ms
64 bytes from 192.168.250.1: icmp_seq=86 ttl=64 time=10.5 ms
64 bytes from 192.168.250.1: icmp_seq=87 ttl=64 time=10.9 ms
64 bytes from 192.168.250.1: icmp_seq=88 ttl=64 time=10.4 ms
64 bytes from 192.168.250.1: icmp_seq=89 ttl=64 time=12.2 ms
64 bytes from 192.168.250.1: icmp_seq=90 ttl=64 time=12.6 ms

90 packets transmitted, 88 received, 2% packet loss, time 89223ms
rtt min/avg/max/mdev = 3.359/58.323/2275.188/273.244 ms, pipe 3


Client 2: rtl8192eu (using vendor driver): 
# iw wlan0 link
Connected to xx:xx:xx:xx:xx:xx (on wlan0)
        SSID: XXXX
        freq: 2447
        signal: -78 dBm
        tx bitrate: 65.0 MBit/s

Ping statistics:

64 bytes from 192.168.250.1: icmp_seq=85 ttl=64 time=6.55 ms
64 bytes from 192.168.250.1: icmp_seq=86 ttl=64 time=3.34 ms
64 bytes from 192.168.250.1: icmp_seq=87 ttl=64 time=3.96 ms
64 bytes from 192.168.250.1: icmp_seq=88 ttl=64 time=3.47 ms
64 bytes from 192.168.250.1: icmp_seq=89 ttl=64 time=3.48 ms
64 bytes from 192.168.250.1: icmp_seq=90 ttl=64 time=3.35 ms
90 packets transmitted, 90 received, 0% packet loss, time 89124ms
rtt min/avg/max/mdev = 3.191/4.902/26.607/3.978 ms

The difference is quite marked: the rtl8192eu seems to perform much
better than the wl1837 even though the wl1837 is located closer to
the AP than the rtl8192eu.

Most of the ping times via the wl1837 look to be around 10ms, vs
3ms for the rtl8192eu, as can be seen above.

Individually, the ping times are very similar to the above.

All wifi interfaces have power save disabled, either via the driver
module options where possible, or via iw wlan0 set power_save 0

So, why does wl1837 appear to be performing not as well than the
rtl8192eu?

Are out of tree vendor drivers in fact better than kernel-merged
drivers? :)

The machines are synchronised via NTP across the wifi link as best
they can manage with the irregularity in the network (the rtl8192eu
syncs /way/ better than the wl1837 - rtl8192eu is always sync'd to
within 250us, the wl1837 keeps reporting milliseconds offset in the
NTP loop stats):

>From the AP:
23:54:18.026441 IP 192.168.250.4 > 192.168.250.1: ICMP echo request, id 1112, seq 110, length 64
23:54:18.026604 IP 192.168.250.1 > 192.168.250.4: ICMP echo reply, id 1112, seq 110, length 64
23:54:19.036396 IP 192.168.250.4 > 192.168.250.1: ICMP echo request, id 1112, seq 111, length 64
23:54:19.036560 IP 192.168.250.1 > 192.168.250.4: ICMP echo reply, id 1112, seq 111, length 64
23:54:20.036874 IP 192.168.250.4 > 192.168.250.1: ICMP echo request, id 1112, seq 112, length 64
23:54:20.037025 IP 192.168.250.1 > 192.168.250.4: ICMP echo reply, id 1112, seq 112, length 64

>From the wl1837 client:
23:54:18.028504 IP 192.168.250.4 > 192.168.250.1: ICMP echo request, id 1112, seq 110, length 64
23:54:18.032074 IP 192.168.250.1 > 192.168.250.4: ICMP echo reply, id 1112, seq 110, length 64
23:54:19.030464 IP 192.168.250.4 > 192.168.250.1: ICMP echo request, id 1112, seq 111, length 64
23:54:19.043282 IP 192.168.250.1 > 192.168.250.4: ICMP echo reply, id 1112, seq 111, length 64
23:54:20.031082 IP 192.168.250.4 > 192.168.250.1: ICMP echo request, id 1112, seq 112, length 64
23:54:20.042887 IP 192.168.250.1 > 192.168.250.4: ICMP echo reply, id 1112, seq 112, length 64


Same for the rtl8192eu - AP:
23:58:35.215467 IP 192.168.250.2 > 192.168.250.1: ICMP echo request, id 23188, seq 6, length 64
23:58:35.215659 IP 192.168.250.1 > 192.168.250.2: ICMP echo reply, id 23188, seq 6, length 64
23:58:36.217136 IP 192.168.250.2 > 192.168.250.1: ICMP echo request, id 23188, seq 7, length 64
23:58:36.217337 IP 192.168.250.1 > 192.168.250.2: ICMP echo reply, id 23188, seq 7, length 64
23:58:37.218105 IP 192.168.250.2 > 192.168.250.1: ICMP echo request, id 23188, seq 8, length 64
23:58:37.218290 IP 192.168.250.1 > 192.168.250.2: ICMP echo reply, id 23188, seq 8, length 64

rtl8192eu:
23:58:35.213928 IP 192.168.250.2 > 192.168.250.1: ICMP echo request, id 23188, seq 6, length 64
23:58:35.219372 IP 192.168.250.1 > 192.168.250.2: ICMP echo reply, id 23188, seq 6, length 64
23:58:36.215656 IP 192.168.250.2 > 192.168.250.1: ICMP echo request, id 23188, seq 7, length 64
23:58:36.219300 IP 192.168.250.1 > 192.168.250.2: ICMP echo reply, id 23188, seq 7, length 64
23:58:37.216558 IP 192.168.250.2 > 192.168.250.1: ICMP echo request, id 23188, seq 8, length 64
23:58:37.223240 IP 192.168.250.1 > 192.168.250.2: ICMP echo reply, id 23188, seq 8, length 64

If you closely look at the results, it appears that the packet at
"seq 112" was received before it was transmitted - presumably because
NTP is not able to synchronise very well because of the poorly
performing driver/hardware.  So, it's not possible to determine if
it's the transmit or the receive which is causing the delay.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
