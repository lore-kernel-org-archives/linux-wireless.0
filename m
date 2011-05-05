Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33300 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab1EEAG1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 20:06:27 -0400
Received: by bwz15 with SMTP id 15so1423590bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 17:06:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinJK3B_dcX4Qmuo=hC5j654YLLmCA@mail.gmail.com>
References: <BANLkTinJK3B_dcX4Qmuo=hC5j654YLLmCA@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 4 May 2011 17:06:05 -0700
Message-ID: <BANLkTin2+tWPHYJsrfpBzs_guFXjSr9AOg@mail.gmail.com> (sfid-20110505_020630_148239_C46680CC)
Subject: Re: bug: 2 second wireless stall on ath9k link
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 4, 2011 at 4:42 PM, Daniel Halperin
<dhalperi@cs.washington.edu> wrote:
> Hi,
>
> I have two identical Dell Inspiron 530n desktops running latest w-t
> (07e789c5094735747b3df8a7840f61467575ba9e, master 2011-05-04) on
> Ubuntu 10.04.2 LTS. I have uninstalled network-manager from both
> devices and, as far as I can tell, no software processes or daemons
> interfere with my wireless configurations.
>
> The AP machine has an AR9280-based device and an IWL5300 based device.
> I blacklist ath9k and iwlagn modules from loading on boot. It is
> running latest hostap.git, though I've seen the same issue with older
> versions.
>
> The client machine has one AR9380-based NIC, one IWL5300-based NIC,
> and one RT2800pci NIC. I blacklist ath9k, iwlagn, and rt2800pci from
> loading on boot.
>
> When I set up the client to connect (using iwconfig essid) to the AP
> (no encryption, channel 48 with HT40-) and run iperf, I sometimes see
> 2-second drops of the connection. I run iperf to generate elastic TCP
> flows that see ~150 Mbps, and in parallel I run ping <AP> -i 0.2.
> Here's the ping log:
>
> 64 bytes from 192.168.1.2: icmp_seq=622 ttl=64 time=107 ms
> 64 bytes from 192.168.1.2: icmp_seq=623 ttl=64 time=117 ms
> 64 bytes from 192.168.1.2: icmp_seq=624 ttl=64 time=125 ms
> 64 bytes from 192.168.1.2: icmp_seq=625 ttl=64 time=2152 ms
> 64 bytes from 192.168.1.2: icmp_seq=626 ttl=64 time=1989 ms
> 64 bytes from 192.168.1.2: icmp_seq=627 ttl=64 time=1779 ms
> 64 bytes from 192.168.1.2: icmp_seq=628 ttl=64 time=1570 ms
> 64 bytes from 192.168.1.2: icmp_seq=629 ttl=64 time=1360 ms
> 64 bytes from 192.168.1.2: icmp_seq=630 ttl=64 time=1150 ms
> 64 bytes from 192.168.1.2: icmp_seq=631 ttl=64 time=950 ms
> 64 bytes from 192.168.1.2: icmp_seq=632 ttl=64 time=750 ms
> 64 bytes from 192.168.1.2: icmp_seq=633 ttl=64 time=550 ms
> 64 bytes from 192.168.1.2: icmp_seq=634 ttl=64 time=340 ms
> 64 bytes from 192.168.1.2: icmp_seq=635 ttl=64 time=130 ms
> 64 bytes from 192.168.1.2: icmp_seq=636 ttl=64 time=2.73 ms
> 64 bytes from 192.168.1.2: icmp_seq=637 ttl=64 time=1.18 ms
> 64 bytes from 192.168.1.2: icmp_seq=638 ttl=64 time=1.18 ms
> 64 bytes from 192.168.1.2: icmp_seq=639 ttl=64 time=1.18 ms
> 64 bytes from 192.168.1.2: icmp_seq=640 ttl=64 time=1.18 ms
>
> you can see that ping times are large while the TCP flow is active,
> but drop to about 1.18ms after it stops. You can also clearly see the
> pings get backed-up for 2 seconds and then release. This tends to
> happen in the last 5 seconds of a 30s TCP flow, which starts almost
> immediately after association. I wonder if it might be related to some
> event that may get triggered 30s after association in either hostap or
> mac80211 or ath9k.
>
> This is reproducible (albeit infrequently) with the stock w-t kernel;
> I've also generated a version of the code in which I print out
> messages (KERN_INFO priority) inside of minstrel_ht whenever get_rate
> is called and whenever tx_status is called. I verified that there is
> **NO LOSS** measured by either side. Also, the gap in the messages is
> nearly exactly 2 seconds long, e.g., 2.03 seconds.
>
> Any thoughts as to what could be causing this?
>
> A final, but probably wrong, note. This seems to be (qualitatively)
> harder to reproduce if I don't compile in rt2800pci support. But, I
> blacklist the modules and I've verified that none of them are loaded
> on boot, so I don't know why this would be a problem.

I seem to have found a better way to make it reproducible: Once it
triggers once, if I run:

ifconfig wlan1 down
ifconfig wlan1 up 192.168.1.11
iwconfig wlan1 essid csitool
iperf -c 192.168.1.2 -i1

it will trigger again. Here's a representative iperf log:

iperf -c 192.168.1.2 -i1 -t 33
------------------------------------------------------------
Client connecting to 192.168.1.2, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.11 port 54479 connected with 192.168.1.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  13.3 MBytes    111 Mbits/sec
[  3]  1.0- 2.0 sec  18.0 MBytes    151 Mbits/sec
[  3]  2.0- 3.0 sec  16.3 MBytes    137 Mbits/sec
[  3]  3.0- 4.0 sec  15.0 MBytes    126 Mbits/sec
[  3]  4.0- 5.0 sec  15.6 MBytes    131 Mbits/sec
[  3]  5.0- 6.0 sec  14.9 MBytes    125 Mbits/sec
[  3]  6.0- 7.0 sec  13.4 MBytes    112 Mbits/sec
[  3]  7.0- 8.0 sec  15.7 MBytes    132 Mbits/sec
[  3]  8.0- 9.0 sec  15.7 MBytes    131 Mbits/sec
[  3]  9.0-10.0 sec  16.2 MBytes    136 Mbits/sec
[  3] 10.0-11.0 sec  17.6 MBytes    148 Mbits/sec
[  3] 11.0-12.0 sec  16.8 MBytes    141 Mbits/sec
[  3] 12.0-13.0 sec  16.8 MBytes    141 Mbits/sec
[  3] 13.0-14.0 sec  17.6 MBytes    148 Mbits/sec
[  3] 14.0-15.0 sec  10.8 MBytes  90.7 Mbits/sec
[  3] 15.0-16.0 sec  15.8 MBytes    133 Mbits/sec
[  3] 16.0-17.0 sec  16.0 MBytes    134 Mbits/sec
[  3] 17.0-18.0 sec  16.7 MBytes    140 Mbits/sec
[  3] 18.0-19.0 sec  14.7 MBytes    123 Mbits/sec
[  3] 19.0-20.0 sec  15.8 MBytes    133 Mbits/sec
[  3] 20.0-21.0 sec  16.0 MBytes    134 Mbits/sec
[  3] 21.0-22.0 sec  14.9 MBytes    125 Mbits/sec
[  3] 22.0-23.0 sec  15.7 MBytes    132 Mbits/sec
[  3] 23.0-24.0 sec  15.2 MBytes    127 Mbits/sec
[  3] 24.0-25.0 sec  13.9 MBytes    117 Mbits/sec
[  3] 25.0-26.0 sec  14.1 MBytes    118 Mbits/sec
[  3] 26.0-27.0 sec  16.4 MBytes    137 Mbits/sec
[  3] 27.0-28.0 sec  15.0 MBytes    126 Mbits/sec
[  3] 28.0-29.0 sec  9.70 MBytes  81.4 Mbits/sec
[  3] 29.0-30.0 sec  0.00 Bytes  0.00 bits/sec
[  3] 30.0-31.0 sec  1.68 MBytes  14.1 Mbits/sec
[  3] 31.0-32.0 sec  10.2 MBytes  85.7 Mbits/sec
[  3] 32.0-33.0 sec  11.1 MBytes  93.5 Mbits/sec
[  3]  0.0-33.0 sec    467 MBytes    118 Mbits/sec
