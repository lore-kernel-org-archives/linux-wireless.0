Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:58005 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbYGZPyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 11:54:53 -0400
Message-ID: <488B48C1.6090506@lwfinger.net> (sfid-20080726_175456_991253_69591B25)
Date: Sat, 26 Jul 2008 10:54:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: =?ISO-8859-1?Q?C=E9dric_Auger?= <cedric@grisbi.org>,
	linux-wireless@vger.kernel.org
Subject: Re: iwl3945 slow for downloading
References: <20080726161140.59041730@grisbi.org> <488B3969.4050405@openwrt.org>
In-Reply-To: <488B3969.4050405@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> I don't know if it helps with debugging this issue, but I've seen the same
> on a laptop from a friend of mine (same card).
> 
> After some searching I found that setting the AP to g-only mode instead of
> b+g mixed made it work at decent speeds. Another symptom of this slowdown is
> that there is typically an unnaturally high number of retransmissions on the
> air, which eats up a lot of airtime.
> 
> I've spent some time looking through the code to find the reason for this
> but couldn't find anything yet (maybe somebody from Intel could help).

Just for comparison, my BCM4312 running b43 from the latest wireless-testing 
gets the following tcpperf throughput:

AP Mode          TX          RX

Mixed b/g    19.8 MB/s   23.0 MB/s
g-only       20.5 MB/s   23.1 MB/s

For these tests, the connecting end was wired to the router. The difference in 
TX speeds was about what I expected - the small difference in RX speeds was not. 
In any case, if you see a large difference with iwl3945, that would be useful 
information.

You can obtain tcpperf from http://wand.cs.waikato.ac.nz/~stj2/nsc/software.html

Larry

