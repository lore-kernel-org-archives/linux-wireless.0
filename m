Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:8146 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab3JCSvB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 14:51:01 -0400
Message-ID: <524DBC93.1070400@hp.com> (sfid-20131003_205110_494876_0F30923A)
Date: Thu, 03 Oct 2013 11:50:59 -0700
From: Rick Jones <rick.jones2@hp.com>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>,
	netdev <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Ideas on why using WPA2 encryption speeds up many TCP connections?
References: <524DB6F6.6020405@candelatech.com>
In-Reply-To: <524DB6F6.6020405@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2013 11:27 AM, Ben Greear wrote:
> I'm seeing something a bit strange and wondering if anyone had an
> opinion on why...
>
> I am testing up to 200 wifi station systems, each with a TCP connection
> running on them (download only, from VAP to stations).
>
> Without encryption (ie, open network), I see total throughput go from
> about 108Mbps down to 69Mbps as I add more stations (I add 25 at a time,
> so the 108Mbps is with 25 active, and 69Mbps is with 200 active).
>
> However, if I enable encryption, the throughput is actually higher
> (111Mbps to 71Mbps).  I'm doing encryption in software, so it adds a fair
> bit of CPU load in this test.  The numbers bounce around since this is
> wifi after all, but in general encryption tends to win reliably in this
> test.
>
> When testing with a single station (and 5 tcp streams with jacked up
> snd/rcv buffers) the open networks perform significantly better at total throughput:
> 263Mbps vs 246Mbps.
>
> Maybe the extra delay for decryption increases odds that GRO will take
> affect for the many, slower streams (and maybe that will decrease ACK
> traffic?)
>
> Any other ideas?

Fewer times two or more stations step on one another?  The recievers 
will only try to transmit when they receive data.  Modulo timing, if the 
individual downloads are a bit slower, less chance of the receivers 
looking to send ACKs back through at the same time?  Got any low-level 
stats for the health and well being of the wireless network?

rick jones

