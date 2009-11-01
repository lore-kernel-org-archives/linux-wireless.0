Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48303 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZKAKeQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 05:34:16 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k AP issues
Date: Sun, 1 Nov 2009 11:34:14 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>
References: <200910291330.26172.mb@bu3sch.de> <200910291431.48388.mb@bu3sch.de> <20091031202156.GA29825@hash.localnet>
In-Reply-To: <20091031202156.GA29825@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911011134.16313.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 31 October 2009 21:21:56 Bob Copeland wrote:
> On Thu, Oct 29, 2009 at 02:31:46PM +0100, Michael Buesch wrote:
> > Ok, to sum up some discussion from IRC:
> > 
> > The initial packets that fail are not pings, but ARPs. Which are broadcast
> > frames.  The access point simply fails to notify the station via DTIM for the
> > pending multicast frames, so it stays in PS. Unicast and the corresponding
> > TIM bitmap works properly, which also explains why it works once we got a
> > successful ARP (and it didn't expire, yet).
> 
> I don't think this fixes everything (I'm still seeing some mishandled
> PS-poll frames) but this seemed to help pinging the PS client from the AP
> side.

Yeah this helps it a little bit.
It's able to get an ARP out and it's able to receive _some_ pongs now.

mb@homer:~$ ping 192.168.2.12 # ping the PS device
PING 192.168.2.12 (192.168.2.12) 56(84) bytes of data.
64 bytes from 192.168.2.12: icmp_seq=1 ttl=64 time=86.8 ms
64 bytes from 192.168.2.12: icmp_seq=2 ttl=64 time=4090 ms
64 bytes from 192.168.2.12: icmp_seq=3 ttl=64 time=3092 ms
64 bytes from 192.168.2.12: icmp_seq=4 ttl=64 time=2094 ms
64 bytes from 192.168.2.12: icmp_seq=5 ttl=64 time=1100 ms
64 bytes from 192.168.2.12: icmp_seq=6 ttl=64 time=101 ms
^C
--- 192.168.2.12 ping statistics ---
30 packets transmitted, 6 received, 80% packet loss, time 29002ms
rtt min/avg/max/mdev = 86.898/1760.979/4090.333/1489.080 ms, pipe 5

-- 
Greetings, Michael.
