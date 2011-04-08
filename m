Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm30.bullet.mail.bf1.yahoo.com ([98.139.212.189]:39488 "HELO
	nm30.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754591Ab1DHJcy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 05:32:54 -0400
Message-ID: <179432.26955.qm@web161615.mail.bf1.yahoo.com>
Date: Fri, 8 Apr 2011 02:32:53 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Questions about rt2800usb
To: Steev Klimaszewski <steev@genesi-usa.com>
Cc: Jett Chen <jett_chen@ralinktech.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTikRMATHAUmsQa8T4LD4_C9T76asAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Here's my vote against removing the rt2870sta from
> staging. Some longstanding issues with latency and duplicate
> packets (rt307x) are persistent with rt2800usb, whereas
> rt2870sta works fine.
> >
> > my two cents
> >
> > Walter
> 
> Personally, I've had the opposite (since the patch to
> disable power
> management on rt2800usb.)  rt2870sta hasn't been
> noticeably more
> stable, and in fact, I tend to see div0 bugs quite often
> when using
> it.  That said, I'm using Azurewave rt3070s.

My vote went against only because of this: 
(rt3070 - 148f:3070)

Ping gateway with staging:

PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_req=1 ttl=64 time=4.34 ms
64 bytes from 192.168.1.1: icmp_req=2 ttl=64 time=4.70 ms
64 bytes from 192.168.1.1: icmp_req=3 ttl=64 time=1.61 ms
64 bytes from 192.168.1.1: icmp_req=4 ttl=64 time=1.68 ms
64 bytes from 192.168.1.1: icmp_req=5 ttl=64 time=1.33 ms
64 bytes from 192.168.1.1: icmp_req=6 ttl=64 time=6.57 ms
64 bytes from 192.168.1.1: icmp_req=7 ttl=64 time=4.45 ms
^C
--- 192.168.1.1 ping statistics ---
7 packets transmitted, 7 received, 0% packet loss, time 6009ms


Now pinging gateway with rt2800usb:
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_req=2 ttl=64 time=647 ms
64 bytes from 192.168.1.1: icmp_req=3 ttl=64 time=1590 ms
64 bytes from 192.168.1.1: icmp_req=4 ttl=64 time=583 ms
64 bytes from 192.168.1.1: icmp_req=5 ttl=64 time=29.2 ms
64 bytes from 192.168.1.1: icmp_req=6 ttl=64 time=1674 ms
64 bytes from 192.168.1.1: icmp_req=7 ttl=64 time=667 ms
64 bytes from 192.168.1.1: icmp_req=7 ttl=64 time=668 ms (DUP!)
64 bytes from 192.168.1.1: icmp_req=8 ttl=64 time=1645 ms
64 bytes from 192.168.1.1: icmp_req=9 ttl=64 time=637 ms
64 bytes from 192.168.1.1: icmp_req=10 ttl=64 time=1.38 ms
^C
--- 192.168.1.1 ping statistics ---
10 packets transmitted, 9 received, +1 duplicates, 10% packet loss, time 9032ms
rtt min/avg/max/mdev = 1.384/814.547/1674.284/588.666 ms, pipe 2


Steev, you mentioned there was a fix? Could you please point which patch resolves this?

I'll be glad to drop the staging driver if rt2800usb does not lag anymore.

Walter
