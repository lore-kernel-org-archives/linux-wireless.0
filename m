Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:57356 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbA3NTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:19:38 -0500
Message-ID: <1422623975.21689.77.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150130_141943_852062_335C19FB)
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	eyalpe@dev.mellanox.co.il
Date: Fri, 30 Jan 2015 05:19:35 -0800
In-Reply-To: <54CB5D08.2070906@broadcom.com>
References: <CA+BoTQkVu23P3EOmY_Q3E1GJnWsyF==Pawz4iPOS_Bq5dvfO5Q@mail.gmail.com>
	 <1422537297.21689.15.camel@edumazet-glaptop2.roam.corp.google.com>
	 <54CB5D08.2070906@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 11:29 +0100, Arend van Spriel wrote:

> Hi Eric,
> 
> Your suggestions are still based on the fact that you consider wireless 
> networking to be similar to ethernet, but as Michal indicated there are 
> some fundamental differences starting with CSMA/CD versus CSMA/CA. Also 
> the medium conditions are far from comparable. There is no shielding so 
> it needs to deal with interference and dynamically drops the link rate 
> so transmission of packets can take several milliseconds. Then with 11n 
> they came up with aggregation with sends up to 64 packets in a single 
> transmit over the air at worst case 6.5 Mbps (if I am not mistaken). The 
> parameter value for tcp_limit_output_bytes of 131072 means that it 
> allows queuing for about 1ms on a 1Gbps link, but I hope you can see 
> this is not realistic for dealing with all variances of the wireless 
> medium/standard. I suggested this as topic for the wireless workshop in 
> Otawa [1], but I can not attend there. Still hope that there will be 
> some discussions to get more awareness.

Ever heard about bufferbloat ?

Have you read my suggestions and tried them ?

You can adjust the limit per flow to pretty much you want. If you need
64 packets, just do the math. If in 2018 you need 128 packets, do the
math again.

I am very well aware that wireless wants aggregation, thank you.

131072 bytes of queue on 40Gbit is not 1ms, but 26 usec of queueing, and
we get line rate nevertheless.

We need this level of shallow queues (BQL, TSQ), to get very precise rtt
estimations so that TCP has good entropy for its pacing, even in the 50
usec rtt ranges.

If we allowed 1ms of queueing, then a 40Gbit flow would queue 5 MBytes.

This was terrible, because it increased cwnd and all sender queues to
insane levels.


