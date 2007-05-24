Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out26.alice.it ([85.33.2.26]:3334 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbXEXVg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2007 17:36:27 -0400
From: Matteo Croce <rootkit85@yahoo.it>
To: linux-wireless@vger.kernel.org
Subject: Re: airo works badly
Date: Thu, 24 May 2007 23:22:18 +0200
References: <200705060231.28480.rootkit85@yahoo.it> <20070514182336.GC6999@tuxdriver.com>
In-Reply-To: <20070514182336.GC6999@tuxdriver.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705242322.18761.rootkit85@yahoo.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 May 2007 20:23:36 you wrote:
> On Sun, May 06, 2007 at 02:31:28AM +0200, Matteo Croce wrote:
> > Now I get another error while ifdown && ifup again:
> >
> > airo(eth0): Max tries exceeded when issueing command
> > airo(eth0): enable_MAC: Cannot enable MAC, err=65535
> > airo(eth0): Max tries exceeded when issueing command
>
> Per our IRC conversation, it seems that this problem emerged for you
> between 2.6.16 and 2.6.17.  Please try using git-bisect to determine
> exactly which patch caused this issue for you.
>
> Thanks,
>
> John

Just before teh network goes down i notice a slowdown, i investigated and i 
discovered
that the card drops big (not _so_ big) packets:

[~]$ ping 192.168.0.2 -c 6 -s 482
PING 192.168.0.2 (192.168.0.2) 482(510) bytes of data.
490 bytes from 192.168.0.2: icmp_seq=1 ttl=127 time=5.65 ms
490 bytes from 192.168.0.2: icmp_seq=2 ttl=127 time=2.66 ms
490 bytes from 192.168.0.2: icmp_seq=3 ttl=127 time=2.69 ms
490 bytes from 192.168.0.2: icmp_seq=4 ttl=127 time=2.67 ms
490 bytes from 192.168.0.2: icmp_seq=5 ttl=127 time=2.66 ms
490 bytes from 192.168.0.2: icmp_seq=6 ttl=127 time=2.66 ms

--- 192.168.0.2 ping statistics ---
6 packets transmitted, 6 received, 0% packet loss, time 5021ms
rtt min/avg/max/mdev = 2.663/3.169/5.659/1.115 ms
[~]$ ping 192.168.0.2 -c 6 -s 483
PING 192.168.0.2 (192.168.0.2) 483(511) bytes of data.

--- 192.168.0.2 ping statistics ---
6 packets transmitted, 0 received, 100% packet loss, time 5001ms

[~]$ 

Note: 192.168.0.2 is the Access point, so it is teh first node in the net.
