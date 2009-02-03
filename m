Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173017pub.verizon.net ([206.46.173.17]:58485 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZBCEYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 23:24:13 -0500
Received: from depotrd.localnet ([96.237.24.216]) by vms173017.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-2.01 (built Jun 13 2007; 32bit))
 with ESMTPA id <0KEG00MBHXVSCDY8@vms173017.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Mon, 02 Feb 2009 20:35:53 -0600 (CST)
From: Glenn Burkhardt <gbburkhardt@verizon.net>
To: Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: poor performance with ath5k; reverting to ath_pci
Date: Mon, 02 Feb 2009 21:36:00 -0500
References: <200901140003.31693.gbburkhardt@verizon.net>
 <200901212158.13854.gbburkhardt@verizon.net>
 <40f31dec0901222331l2d55b732ua50089aef8a42ccf@mail.gmail.com>
In-reply-to: <40f31dec0901222331l2d55b732ua50089aef8a42ccf@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Message-id: <200902022136.00606.gbburkhardt@verizon.net> (sfid-20090203_052417_963344_FB67FFCB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> O.K. so both algorithms have overestimated the rate, madwifi with
> minstrel sets it to 36M and both pid an minstrel on ath5k/mac80211 set
> it to 54M. This results packet corruption and packet loss. Please try
> locking the rate to 18M - 36M and check the performance again (also an
> iperf udp test would be very usefull) to see if this is only a problem
> with the algorithm or a more generic problem.

It doesn't seem to be the rate selection.  I switched to channel 2 again, and 
the version of ath5k that came with Suse 11.1 didn't connect to my router at 
all.  The ath_pci driver I built did, with roughly millisecond ping round 
trips.  The ath_pci driver changed the bit rate to 18 Mb/s; ath5k reported 
using 5.5 Mb/s, but ping was never successful.

I also built a kernel from the wireless testing repository ( 2.6.29-rc3-wl-9-
pae), and that driver was able to connect initially, although with a slow 
response rate:

PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=3086 ms
64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=2925 ms
64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=3293 ms
64 bytes from 192.168.2.1: icmp_seq=4 ttl=64 time=3986 ms
64 bytes from 192.168.2.1: icmp_seq=6 ttl=64 time=4018 ms
64 bytes from 192.168.2.1: icmp_seq=7 ttl=64 time=3030 ms
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable

It reported the bit rate to be 54 Mb/s; I tried turning it down to as low as 6 
Mb/s, but then it didn't work at all.

This last test was using 'minstrel' rate control; it doesn't seem that 'pid' 
is a selectable option in the kernel configuration for 'wireless testing'.

I'll try to get some more data with 'iperf'.  I have a couple of other 
machines in the house that I can use.
