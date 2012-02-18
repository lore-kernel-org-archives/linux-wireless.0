Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab2BRQ4g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Feb 2012 11:56:36 -0500
Date: Sat, 18 Feb 2012 17:56:32 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [rt2x00] rt2800usb and RT3070 issues with 54G AP
Message-ID: <20120218165631.GA2922@redhat.com> (sfid-20120218_175641_161895_AA734D8D)
References: <20120216125522.GF25833@redhat.com>
 <1329567096.85201.YahooMailClassic@web161603.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1329567096.85201.YahooMailClassic@web161603.mail.bf1.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

On Sat, Feb 18, 2012 at 04:11:36AM -0800, Walter Goldens wrote:
> This is from an N AP:
> 
> PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
> 64 bytes from 192.168.1.1: icmp_req=1 ttl=64 time=1.47 ms
> 64 bytes from 192.168.1.1: icmp_req=2 ttl=64 time=1.45 ms
> 64 bytes from 192.168.1.1: icmp_req=3 ttl=64 time=0.952 ms
> 64 bytes from 192.168.1.1: icmp_req=4 ttl=64 time=11.1 ms
> 64 bytes from 192.168.1.1: icmp_req=5 ttl=64 time=7.06 ms
> 64 bytes from 192.168.1.1: icmp_req=6 ttl=64 time=12.8 ms
[snip]
> And these are from 54G AP:
> 
> PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
> 64 bytes from 192.168.1.1: icmp_req=1 ttl=63 time=8.56 ms
> 64 bytes from 192.168.1.1: icmp_req=2 ttl=63 time=1.67 ms
> 64 bytes from 192.168.1.1: icmp_req=3 ttl=63 time=2.94 ms
> 64 bytes from 192.168.1.1: icmp_req=4 ttl=63 time=1.64 ms
> 64 bytes from 192.168.1.1: icmp_req=5 ttl=63 time=1.67 ms
> 64 bytes from 192.168.1.1: icmp_req=6 ttl=63 time=3.70 ms
> 64 bytes from 192.168.1.1: icmp_req=7 ttl=63 time=1.80 ms
> 64 bytes from 192.168.1.1: icmp_req=7 ttl=63 time=2.22 ms (DUP!)
[snip]
> If I use the STA drivers, no such problem occurres with either N or G APs.
> This, for me, has been a long-standing problem.

Looks like this could be related with Power-Save. Seems APs does not
handle PS well (between each ICMP packed our station is put in
the sleep mode) . Vendor driver has  PS disabled, hence problem
is not observable.

Try "iwconfig wlan0 power off" and see if it helps. 

Stanislaw
