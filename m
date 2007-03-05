Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:33976 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933426AbXCENAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 08:00:09 -0500
Message-ID: <45EC1454.4080605@warmcat.com>
Date: Mon, 05 Mar 2007 13:00:04 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Filtering in Monitor Mode (was Question about PRISM2 header rate  field)
References: <45EA9E39.6080706@warmcat.com>	 <1173053744.6131.40.camel@johannes.berg> <45EB6C3B.2060408@warmcat.com>	 <200703042210.52534.flamingice@sourmilk.net> <1173094447.6131.56.camel@johannes.berg>
In-Reply-To: <1173094447.6131.56.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2007-03-04 at 22:10 -0500, Michael Wu wrote:
>> Note that modifying the management interface to do this is possible, but it 
>> would break hostap (and probably wpa_supplicant w/ MLME). Doing packet 
>> injection on monitor interfaces instead is safer in that regard.
> 
> But if you want to do injection over monitor interfaces we'll need to
> have the stupid mgmt interface hack around forever for the userspace
> MLME so it can receive only management traffic (even the non-promisc
> monitor iface we should have gets *far* too much traffic for a userspace
> MLME)

I used the libpcap filter stuff to limit what I saw to just the packets 
of interest.  This is the filtering that tcpdump uses to do the 
conditional filters like "port 22" or "host 192.168.0.1".  The filter 
uses something called BPF (Berkeley Packet Filter) which is done 
kernelside (at least libpcap is doing the filter install with ioctls in 
pcap-bpf.c).  So the cost of drinking from a Monitor firehose is much 
less than it sounds.

> Besides, to userspace, this is almost identical. In both cases it opens
> a socket, binds to something (either raw socket bound to netdev or
> netlink socket bound to nl80211) and then stuffs frames into that socket
> with some fixed header format (for most apps anyway)

I'm guessing the concern is to leave the crufty scary 
not-very-well-known Management Interface monster asleep lest it wake up 
while being edited and eat everyone :-)

-Andy
