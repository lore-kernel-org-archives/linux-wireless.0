Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm14-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.164]:37986 "HELO
	nm14-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752988Ab2BTQwz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 11:52:55 -0500
Message-ID: <1329756774.86563.YahooMailClassic@web161602.mail.bf1.yahoo.com> (sfid-20120220_175259_432201_F8D0B0F0)
Date: Mon, 20 Feb 2012 08:52:54 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [rt2x00] rt2800usb and RT3070 issues with 54G AP
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20120218165631.GA2922@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



--- On Sat, 2/18/12, Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> From: Stanislaw Gruszka <sgruszka@redhat.com>
> Subject: Re: [rt2x00] rt2800usb and RT3070 issues with 54G AP
> To: "Walter Goldens" <goldenstranger@yahoo.com>
> Cc: linux-wireless@vger.kernel.org, "Ivo van Doorn" <ivdoorn@gmail.com>
> Date: Saturday, February 18, 2012, 6:56 PM
> Hi.
> 
> On Sat, Feb 18, 2012 at 04:11:36AM -0800, Walter Goldens
> wrote:
> > This is from an N AP:
> > 
> > PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
> > 64 bytes from 192.168.1.1: icmp_req=1 ttl=64 time=1.47
> ms
> > 64 bytes from 192.168.1.1: icmp_req=2 ttl=64 time=1.45
> ms
> > 64 bytes from 192.168.1.1: icmp_req=3 ttl=64 time=0.952
> ms
> > 64 bytes from 192.168.1.1: icmp_req=4 ttl=64 time=11.1
> ms
> > 64 bytes from 192.168.1.1: icmp_req=5 ttl=64 time=7.06
> ms
> > 64 bytes from 192.168.1.1: icmp_req=6 ttl=64 time=12.8
> ms
> [snip]
> > And these are from 54G AP:
> > 
> > PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
> > 64 bytes from 192.168.1.1: icmp_req=1 ttl=63 time=8.56
> ms
> > 64 bytes from 192.168.1.1: icmp_req=2 ttl=63 time=1.67
> ms
> > 64 bytes from 192.168.1.1: icmp_req=3 ttl=63 time=2.94
> ms
> > 64 bytes from 192.168.1.1: icmp_req=4 ttl=63 time=1.64
> ms
> > 64 bytes from 192.168.1.1: icmp_req=5 ttl=63 time=1.67
> ms
> > 64 bytes from 192.168.1.1: icmp_req=6 ttl=63 time=3.70
> ms
> > 64 bytes from 192.168.1.1: icmp_req=7 ttl=63 time=1.80
> ms
> > 64 bytes from 192.168.1.1: icmp_req=7 ttl=63 time=2.22
> ms (DUP!)
> [snip]
> > If I use the STA drivers, no such problem occurres with
> either N or G APs.
> > This, for me, has been a long-standing problem.
> 
> Looks like this could be related with Power-Save. Seems APs
> does not
> handle PS well (between each ICMP packed our station is put
> in
> the sleep mode) . Vendor driver has  PS disabled, hence
> problem
> is not observable.
> 
> Try "iwconfig wlan0 power off" and see if it helps. 
> 
> Stanislaw

Hello again,

Unfortunately, disabling PS does not fix the problem:

root@dell:~# iwconfig wlan1 power off
root@dell:~# ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_req=1 ttl=64 time=5.55 ms
64 bytes from 192.168.1.1: icmp_req=2 ttl=64 time=2.09 ms
64 bytes from 192.168.1.1: icmp_req=2 ttl=64 time=4.83 ms (DUP!)
64 bytes from 192.168.1.1: icmp_req=3 ttl=64 time=2.03 ms
64 bytes from 192.168.1.1: icmp_req=5 ttl=64 time=1.71 ms
64 bytes from 192.168.1.1: icmp_req=6 ttl=64 time=1.44 ms
64 bytes from 192.168.1.1: icmp_req=7 ttl=64 time=1.79 ms
64 bytes from 192.168.1.1: icmp_req=8 ttl=64 time=5.15 ms
64 bytes from 192.168.1.1: icmp_req=9 ttl=64 time=2.70 ms
64 bytes from 192.168.1.1: icmp_req=10 ttl=64 time=16.8 ms
64 bytes from 192.168.1.1: icmp_req=10 ttl=64 time=24.1 ms (DUP!)
64 bytes from 192.168.1.1: icmp_req=11 ttl=64 time=13.0 ms
^C
--- 192.168.1.1 ping statistics ---
11 packets transmitted, 10 received, +2 duplicates, 9% packet loss, time 10015ms
rtt min/avg/max/mdev = 1.443/6.786/24.168/7.023 ms

Walter
