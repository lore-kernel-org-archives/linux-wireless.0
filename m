Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:34169 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaDXHtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 03:49:52 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: iwlmvm: High latencies and low RX rate with firmware version 22.24.8.0 but not with 22.1.7.0
Date: Thu, 24 Apr 2014 09:49:36 +0200
Message-ID: <87sip3b20f.fsf@nemi.mork.no> (sfid-20140424_094956_885901_C7CBD498)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Emmanuel,

I hope it's OK that I send you this directly. It's mostly for
information in case the problem isn't yet known. I haven't debugged the
issue properly.  Please let me know if you want more details.

I have been using my

  iwlwifi 0000:03:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144

module successfully with the 22.24.8.0 firware and the v3.14 driver ever
since v3.14 was out (and before, if you count the latest -rc's). This
has worked perfectly with all access points I've used, including a
802.11ac Linksys EA6700.

But yesterday I got another 802.11ac access point, a Linksys WRT1900AC,
and that gave me major problems. The problem is the same on both 2.4 and
5 GHz, so it doesn't look like it's really AC related: A few seconds
after associating, the RX rate drops to minimum (1 or 6 MBit/s
respectively), and the latency increases to high values.  After a while
frames are also being dropped, and the link becomes completely unusable.

Googling a bit brought me this: https://bbs.archlinux.org/viewtopic.php?id=180558
and I thought that I might as well try reverting to the older firmware.
And to my surprise: That made the problem go away.

I realize that icmp echos don't necessarily tell the whole truth, but
the same latency difference is noticable on e.g interactive ssh sessions
as well.  So I believe pinging illustrates the difference pretty well.
The *only* thing changed between these sessions is the iwl
firmware. Position, channel, driver, hardware is the same. This was
captured on 2.4GHz.


*** With "iwlwifi 0000:03:00.0: loaded firmware version 22.24.8.0 op_mode iwlmvm" *** :

This is captured immedieately after association, showing the threshold
where latency and rx rate goes bad:

nemi:/usr/local/src/git# ping6 -c 30 fe80::215:17ff:fe1e:5e35%wlan0
PING fe80::215:17ff:fe1e:5e35%wlan0(fe80::215:17ff:fe1e:5e35) 56 data bytes
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=1 ttl=64 time=6.11 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=2 ttl=64 time=3.51 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=3 ttl=64 time=2.07 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=4 ttl=64 time=1.63 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=5 ttl=64 time=1.81 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=6 ttl=64 time=2.53 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=7 ttl=64 time=1.32 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=8 ttl=64 time=1.45 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=9 ttl=64 time=1.52 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=10 ttl=64 time=145 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=11 ttl=64 time=168 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=12 ttl=64 time=190 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=13 ttl=64 time=115 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=14 ttl=64 time=132 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=15 ttl=64 time=154 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=16 ttl=64 time=178 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=17 ttl=64 time=200 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=18 ttl=64 time=120 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=19 ttl=64 time=143 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=20 ttl=64 time=165 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=21 ttl=64 time=188 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=22 ttl=64 time=113 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=23 ttl=64 time=130 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=24 ttl=64 time=55.4 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=25 ttl=64 time=175 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=26 ttl=64 time=198 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=27 ttl=64 time=118 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=28 ttl=64 time=145 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=29 ttl=64 time=164 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=30 ttl=64 time=187 ms

--- fe80::215:17ff:fe1e:5e35%wlan0 ping statistics ---
30 packets transmitted, 30 received, 0% packet loss, time 29044ms
rtt min/avg/max/mdev = 1.326/107.209/200.702/74.548 ms


nemi:/lib/firmware# iw wlan0 station dump;sleep 10; iw wlan0 station dump
Station b4:75:0e:60:b7:e6 (on wlan0)
        inactive time:  136 ms
        rx bytes:       3842
        rx packets:     26
        tx bytes:       2775
        tx packets:     21
        tx retries:     0
        tx failed:      0
        signal:         -54 [-57, -54] dBm
        signal avg:     -56 [-59, -56] dBm
        tx bitrate:     5.5 MBit/s
        rx bitrate:     300.0 MBit/s MCS 15 40MHz short GI
        authorized:     yes
        authenticated:  yes
        preamble:       long
        WMM/WME:        yes
        MFP:            no
        TDLS peer:      no
Station b4:75:0e:60:b7:e6 (on wlan0)
        inactive time:  132 ms
        rx bytes:       7630
        rx packets:     64
        tx bytes:       4891
        tx packets:     39
        tx retries:     1
        tx failed:      0
        signal:         -75 [-75] dBm
        signal avg:     -61 [-61] dBm
        tx bitrate:     12.0 MBit/s
        rx bitrate:     1.0 MBit/s
        authorized:     yes
        authenticated:  yes
        preamble:       long
        WMM/WME:        yes
        MFP:            no
        TDLS peer:      no


A couple of minutes later:

nemi:/usr/local/src/git# ping6 -c10 -W5 fe80::215:17ff:fe1e:5e35%wlan0
PING fe80::215:17ff:fe1e:5e35%wlan0(fe80::215:17ff:fe1e:5e35) 56 data bytes
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=1 ttl=64 time=112 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=2 ttl=64 time=133 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=3 ttl=64 time=156 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=4 ttl=64 time=178 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=6 ttl=64 time=123 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=7 ttl=64 time=144 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=9 ttl=64 time=185 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=10 ttl=64 time=207 ms

--- fe80::215:17ff:fe1e:5e35%wlan0 ping statistics ---
10 packets transmitted, 8 received, 20% packet loss, time 9017ms
rtt min/avg/max/mdev = 112.678/155.340/207.601/30.777 ms




*** With "iwlwifi 0000:03:00.0: loaded firmware version 22.1.7.0 op_mode iwlmvm" *** :

There is no degredation, and values similar to these are observed
indefinitely:

nemi:/usr/local/src/git# ping6 -c 20 fe80::215:17ff:fe1e:5e35%wlan0
PING fe80::215:17ff:fe1e:5e35%wlan0(fe80::215:17ff:fe1e:5e35) 56 data bytes
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=1 ttl=64 time=1.64 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=2 ttl=64 time=1.63 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=3 ttl=64 time=1.21 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=4 ttl=64 time=1.17 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=5 ttl=64 time=1.13 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=6 ttl=64 time=3.56 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=7 ttl=64 time=1.22 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=8 ttl=64 time=1.56 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=9 ttl=64 time=1.35 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=10 ttl=64 time=17.3 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=11 ttl=64 time=15.2 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=12 ttl=64 time=1.45 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=13 ttl=64 time=1.47 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=14 ttl=64 time=3.96 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=15 ttl=64 time=1.66 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=16 ttl=64 time=1.46 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=17 ttl=64 time=1.41 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=18 ttl=64 time=2.81 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=19 ttl=64 time=1.41 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=20 ttl=64 time=1.44 ms

--- fe80::215:17ff:fe1e:5e35%wlan0 ping statistics ---
20 packets transmitted, 20 received, 0% packet loss, time 19029ms
rtt min/avg/max/mdev = 1.137/3.210/17.317/4.440 ms


nemi:/lib/firmware# iw wlan0 station dump
Station b4:75:0e:60:b7:e6 (on wlan0)
        inactive time:  4324 ms
        rx bytes:       7077727
        rx packets:     44372
        tx bytes:       100337
        tx packets:     1138
        tx retries:     88
        tx failed:      0
        signal:         -56 [-56] dBm
        signal avg:     -56 [-56] dBm
        tx bitrate:     180.0 MBit/s MCS 12 40MHz short GI
        rx bitrate:     270.0 MBit/s MCS 15 40MHz
        authorized:     yes
        authenticated:  yes
        preamble:       long
        WMM/WME:        yes
        MFP:            no
        TDLS peer:      no




*** with "firmware version 22.24.8.0", but connected to the EA6700, also on 2.4GHz *** :

With more walls and a couple of floors inbetween, so latency and rates
are expected to be a bit worse. But the link still works fine. There are
no drops, and the RX rate stays well above minimum. Values similar to
these are observed indefinitely:

nemi:/usr/local/src/git# ping6 -c 30 fe80::215:17ff:fe1e:5e35%wlan0
PING fe80::215:17ff:fe1e:5e35%wlan0(fe80::215:17ff:fe1e:5e35) 56 data bytes
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=1 ttl=64 time=33.7 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=2 ttl=64 time=158 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=3 ttl=64 time=78.6 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=4 ttl=64 time=100 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=5 ttl=64 time=20.2 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=6 ttl=64 time=42.8 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=7 ttl=64 time=64.7 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=8 ttl=64 time=86.8 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=9 ttl=64 time=50.8 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=10 ttl=64 time=29.3 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=11 ttl=64 time=17.0 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=12 ttl=64 time=76.3 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=13 ttl=64 time=97.0 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=14 ttl=64 time=17.3 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=15 ttl=64 time=40.3 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=16 ttl=64 time=62.9 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=17 ttl=64 time=85.8 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=18 ttl=64 time=107 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=19 ttl=64 time=44.4 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=20 ttl=64 time=49.7 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=21 ttl=64 time=71.8 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=22 ttl=64 time=94.9 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=23 ttl=64 time=15.3 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=24 ttl=64 time=37.9 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=25 ttl=64 time=60.8 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=26 ttl=64 time=84.7 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=27 ttl=64 time=107 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=28 ttl=64 time=26.5 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=29 ttl=64 time=49.1 ms
64 bytes from fe80::215:17ff:fe1e:5e35: icmp_seq=30 ttl=64 time=72.7 ms

--- fe80::215:17ff:fe1e:5e35%wlan0 ping statistics ---
30 packets transmitted, 30 received, 0% packet loss, time 29043ms
rtt min/avg/max/mdev = 15.309/62.925/158.631/33.149 ms

nemi:/lib/firmware# iw wlan0 station dump
Station c8:d7:19:37:f5:94 (on wlan0)
        inactive time:  128 ms
        rx bytes:       50974
        rx packets:     345
        tx bytes:       14833
        tx packets:     130
        tx retries:     31
        tx failed:      0
        signal:         -77 [-77] dBm
        signal avg:     -77 [-77] dBm
        tx bitrate:     54.0 MBit/s
        rx bitrate:     39.0 MBit/s MCS 10
        authorized:     yes
        authenticated:  yes
        preamble:       long
        WMM/WME:        yes
        MFP:            no
        TDLS peer:      no



So what is the problem with the WRT1900AC and the  22.24.8.0 firmware?
I realize that I probably should ask this question to Belkin instead,
but the different behaviour based on iwl firmware versions puzzles me.
And also the fact that none of my other clients seem to have similar
problems with the WRT1900AC.


Bjørn
