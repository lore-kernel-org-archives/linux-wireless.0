Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45054 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab1EDXnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 19:43:16 -0400
Received: by bwz15 with SMTP id 15so1413246bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 16:43:15 -0700 (PDT)
MIME-Version: 1.0
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 4 May 2011 16:42:55 -0700
Message-ID: <BANLkTinJK3B_dcX4Qmuo=hC5j654YLLmCA@mail.gmail.com> (sfid-20110505_014320_332770_E1276724)
Subject: bug: 2 second wireless stall on ath9k link
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have two identical Dell Inspiron 530n desktops running latest w-t
(07e789c5094735747b3df8a7840f61467575ba9e, master 2011-05-04) on
Ubuntu 10.04.2 LTS. I have uninstalled network-manager from both
devices and, as far as I can tell, no software processes or daemons
interfere with my wireless configurations.

The AP machine has an AR9280-based device and an IWL5300 based device.
I blacklist ath9k and iwlagn modules from loading on boot. It is
running latest hostap.git, though I've seen the same issue with older
versions.

The client machine has one AR9380-based NIC, one IWL5300-based NIC,
and one RT2800pci NIC. I blacklist ath9k, iwlagn, and rt2800pci from
loading on boot.

When I set up the client to connect (using iwconfig essid) to the AP
(no encryption, channel 48 with HT40-) and run iperf, I sometimes see
2-second drops of the connection. I run iperf to generate elastic TCP
flows that see ~150 Mbps, and in parallel I run ping <AP> -i 0.2.
Here's the ping log:

64 bytes from 192.168.1.2: icmp_seq=622 ttl=64 time=107 ms
64 bytes from 192.168.1.2: icmp_seq=623 ttl=64 time=117 ms
64 bytes from 192.168.1.2: icmp_seq=624 ttl=64 time=125 ms
64 bytes from 192.168.1.2: icmp_seq=625 ttl=64 time=2152 ms
64 bytes from 192.168.1.2: icmp_seq=626 ttl=64 time=1989 ms
64 bytes from 192.168.1.2: icmp_seq=627 ttl=64 time=1779 ms
64 bytes from 192.168.1.2: icmp_seq=628 ttl=64 time=1570 ms
64 bytes from 192.168.1.2: icmp_seq=629 ttl=64 time=1360 ms
64 bytes from 192.168.1.2: icmp_seq=630 ttl=64 time=1150 ms
64 bytes from 192.168.1.2: icmp_seq=631 ttl=64 time=950 ms
64 bytes from 192.168.1.2: icmp_seq=632 ttl=64 time=750 ms
64 bytes from 192.168.1.2: icmp_seq=633 ttl=64 time=550 ms
64 bytes from 192.168.1.2: icmp_seq=634 ttl=64 time=340 ms
64 bytes from 192.168.1.2: icmp_seq=635 ttl=64 time=130 ms
64 bytes from 192.168.1.2: icmp_seq=636 ttl=64 time=2.73 ms
64 bytes from 192.168.1.2: icmp_seq=637 ttl=64 time=1.18 ms
64 bytes from 192.168.1.2: icmp_seq=638 ttl=64 time=1.18 ms
64 bytes from 192.168.1.2: icmp_seq=639 ttl=64 time=1.18 ms
64 bytes from 192.168.1.2: icmp_seq=640 ttl=64 time=1.18 ms

you can see that ping times are large while the TCP flow is active,
but drop to about 1.18ms after it stops. You can also clearly see the
pings get backed-up for 2 seconds and then release. This tends to
happen in the last 5 seconds of a 30s TCP flow, which starts almost
immediately after association. I wonder if it might be related to some
event that may get triggered 30s after association in either hostap or
mac80211 or ath9k.

This is reproducible (albeit infrequently) with the stock w-t kernel;
I've also generated a version of the code in which I print out
messages (KERN_INFO priority) inside of minstrel_ht whenever get_rate
is called and whenever tx_status is called. I verified that there is
**NO LOSS** measured by either side. Also, the gap in the messages is
nearly exactly 2 seconds long, e.g., 2.03 seconds.

Any thoughts as to what could be causing this?

A final, but probably wrong, note. This seems to be (qualitatively)
harder to reproduce if I don't compile in rt2800pci support. But, I
blacklist the modules and I've verified that none of them are loaded
on boot, so I don't know why this would be a problem.

Thanks,
Dan
