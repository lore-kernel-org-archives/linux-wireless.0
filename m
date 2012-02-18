Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm35-vm7.bullet.mail.bf1.yahoo.com ([72.30.238.79]:26571 "HELO
	nm35-vm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751636Ab2BRMRN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Feb 2012 07:17:13 -0500
Message-ID: <1329567096.85201.YahooMailClassic@web161603.mail.bf1.yahoo.com> (sfid-20120218_131717_813924_A97935FC)
Date: Sat, 18 Feb 2012 04:11:36 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [rt2x00] rt2800usb and RT3070 issues with 54G AP
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20120216125522.GF25833@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > My rt3070 USB card works flawlessly when connected to
> an 802.11N AP. Excellent throughput, speed and reliability.
> > 
> > When connected to a 54G AP however, there is
> significant packet loss and duplicates.
> > I can confirm this to be happening with two older 54G
> APs, and not with a single N AP.
> >
> > Does anyone else have the same problem?
> 
> Usually we have opposite problem, 11g works, 11n does not.
> 
> Are you using the lates wireless-testing tree? If not, try
> that
> i.e using compat-wireless package there are some pending
> radio chip
> programing fixes, I think they may help with packet lost.
> 
> Stanislaw   

Hi Stanislaw,

This is from an N AP:

PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_req=1 ttl=64 time=1.47 ms
64 bytes from 192.168.1.1: icmp_req=2 ttl=64 time=1.45 ms
64 bytes from 192.168.1.1: icmp_req=3 ttl=64 time=0.952 ms
64 bytes from 192.168.1.1: icmp_req=4 ttl=64 time=11.1 ms
64 bytes from 192.168.1.1: icmp_req=5 ttl=64 time=7.06 ms
64 bytes from 192.168.1.1: icmp_req=6 ttl=64 time=12.8 ms
64 bytes from 192.168.1.1: icmp_req=7 ttl=64 time=13.5 ms
64 bytes from 192.168.1.1: icmp_req=8 ttl=64 time=2.79 ms
64 bytes from 192.168.1.1: icmp_req=9 ttl=64 time=61.7 ms
64 bytes from 192.168.1.1: icmp_req=10 ttl=64 time=13.2 ms
64 bytes from 192.168.1.1: icmp_req=11 ttl=64 time=6.46 ms
64 bytes from 192.168.1.1: icmp_req=12 ttl=64 time=7.03 ms
64 bytes from 192.168.1.1: icmp_req=13 ttl=64 time=8.16 ms
64 bytes from 192.168.1.1: icmp_req=14 ttl=64 time=6.80 ms
64 bytes from 192.168.1.1: icmp_req=15 ttl=64 time=8.15 ms
64 bytes from 192.168.1.1: icmp_req=16 ttl=64 time=6.34 ms
^C
--- 192.168.1.1 ping statistics ---
16 packets transmitted, 16 received, 0% packet loss, time 15023ms
rtt min/avg/max/mdev = 0.952/10.582/61.742/13.795 ms

No problems whatsoever.

And these are from 54G AP:

PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_req=1 ttl=63 time=8.56 ms
64 bytes from 192.168.1.1: icmp_req=2 ttl=63 time=1.67 ms
64 bytes from 192.168.1.1: icmp_req=3 ttl=63 time=2.94 ms
64 bytes from 192.168.1.1: icmp_req=4 ttl=63 time=1.64 ms
64 bytes from 192.168.1.1: icmp_req=5 ttl=63 time=1.67 ms
64 bytes from 192.168.1.1: icmp_req=6 ttl=63 time=3.70 ms
64 bytes from 192.168.1.1: icmp_req=7 ttl=63 time=1.80 ms
64 bytes from 192.168.1.1: icmp_req=7 ttl=63 time=2.22 ms (DUP!)
64 bytes from 192.168.1.1: icmp_req=8 ttl=63 time=9.59 ms
64 bytes from 192.168.1.1: icmp_req=9 ttl=63 time=10.1 ms
64 bytes from 192.168.1.1: icmp_req=10 ttl=63 time=7.02 ms
64 bytes from 192.168.1.1: icmp_req=12 ttl=63 time=7.03 ms
64 bytes from 192.168.1.1: icmp_req=13 ttl=63 time=10.0 ms
64 bytes from 192.168.1.1: icmp_req=14 ttl=63 time=7.22 ms
64 bytes from 192.168.1.1: icmp_req=14 ttl=63 time=7.74 ms (DUP!)
64 bytes from 192.168.1.1: icmp_req=15 ttl=63 time=9.14 ms
64 bytes from 192.168.1.1: icmp_req=16 ttl=63 time=8.16 ms
^C
--- 192.168.1.1 ping statistics ---
16 packets transmitted, 15 received, +2 duplicates, 6% packet loss, time 15029ms
rtt min/avg/max/mdev = 1.640/5.904/10.166/3.228 ms

If I use the STA drivers, no such problem occurres with either N or G APs.
This, for me, has been a long-standing problem.

Walter
