Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48699 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab3CNXMi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 19:12:38 -0400
Message-ID: <51425963.2000904@openwrt.org> (sfid-20130315_001241_710769_C7FF360A)
Date: Fri, 15 Mar 2013 00:12:35 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Optimizing performance for lots of virtual stations.
References: <5142074C.1060708@candelatech.com>
In-Reply-To: <5142074C.1060708@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-14 6:22 PM, Ben Greear wrote:
> I've been doing some performance testing, and having lots of
> stations causes quite a drag:  total throughput with 1 station: 250Mbps TCP throughput,
> total with 50 stations:  225 Mbps, and with 128 stations: 20-40Mbps (it varies a lot..not so sure why).
> 
> I poked around in the rx logic and it seems the rx-data path is fairly
> clean for data packets.  But, from what I can tell, each beacon is going
> to cause an skb_copy() call and a queued work-item for each station interface,
> and there are going to be lots of beacons per second in most scenarios...
> 
> I was wondering if this could be optimized a bit to special case beacons
> and not make a new copy (or possibly move some of the beacon handling
> logic up to the radio object and out of the sdata).
> 
> And of course, it could be there are more important optimizations...I'm curious
> if anyone is aware of any other code that should be optimized to have better
> performance with lots of stations...
How about doing some profiling with lots of stations - that should
hopefully reveal where the real bottleneck is.
By the way, with that many stations and low throughput, is the CPU usage
on your system significantly higher, or could it just be some extra
latency introduced somewhere else in the code?

- Felix

