Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:39823 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757238Ab3BVMe4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 07:34:56 -0500
Message-ID: <512765E3.5040103@neratec.com> (sfid-20130222_133505_023442_3526B6AE)
Date: Fri, 22 Feb 2013 13:34:43 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, antonio@open-mesh.com,
	marek@open-mesh.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
References: <20130215171938.GA4140@pandem0nium> <51274372.9030600@neratec.com> <20130222114340.GA11803@pandem0nium>
In-Reply-To: <20130222114340.GA11803@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/22/2013 12:43 PM, Simon Wunderlich wrote:
> Hello Zefir,
> [...] 
> 
> it is nice to hear that the relayfs approach works well. :)
> 
It does. Before the system was limited to 15k samples/second (with netlink), now
it can handle 50 kS/s.

> Our biggest performance issue is probably the syscall for every packet, so minimizing
> data to be sent to userspace and aggregate it to would benefit to our performance
> problem.
> 
Did not check what happens under the hood when you write to a relay buffer, but
since it is tagged as 'efficient' channel to userspace, I don't expect there is
much of an overhead issue. Needs to be verified.

> I would also agree that this approach is simpler as we don't have to manage lists
> of clients and purge them. And we can evaluation in userspace, just as everyone
> needs for its application (maybe some of these statistics are not of general interest).
> 
Right. Take the MAC address based filtering we need to have for our application.
It is not useful for most, while any statistics without that feature are worthless
to us. And we are not going to bloat kernel based statistics collection to fit
everyone's needs, I guess.

> Issues I see are:
>  * the relayfs has to be regularly polled for new data (maybe multiple times a second),
>    so it can't overflow. I'm just looking at a dump from a running iperf test, it shows
>    ~12000 packets per second (at 70Mbit/s). Assuming we are sending 64 byte of metainfo
>    per packet, this would sum up to 768k every second. Doing the statistics computation
>    in userspace makes no difference to doing it in kernelspace, imho.
See above, 50k spectral samples per second (76 bytes each) on an embedded platform
(600MHz PPC) works fine. Agree, computational overhead remains the same - if you
do it on the device itself. Think of a large installation with low profile APs
that provide this data raw over the backbone.

>  * in-kernel drivers can't use the gathered statistics (that would affect 802.11s)
Agree, if it needs to be evaluated by drivers, that's a different use-case.

Maybe the best take is to start on top of the statistics generated for in kernel
usage and forward it to userspace over the proposed relay channel.

>  * I wonder how debugfs use in mac80211 for this kind of feature is acceptable. This
>    would be a question for Johannes. :)
> 
Sounds already quite application specific to me, so I'd expect debugfs would not
be the worst location to place it ;)

> Thanks for sharing your thoughts!
> 
> Cheers,
> 	Simon
> 

