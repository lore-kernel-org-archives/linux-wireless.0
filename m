Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48403 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab3CNRWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 13:22:21 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r2EHMKJw018385
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2013 10:22:20 -0700
Message-ID: <5142074C.1060708@candelatech.com> (sfid-20130314_182224_868828_9869CF72)
Date: Thu, 14 Mar 2013 10:22:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Optimizing performance for lots of virtual stations.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been doing some performance testing, and having lots of
stations causes quite a drag:  total throughput with 1 station: 250Mbps TCP throughput,
total with 50 stations:  225 Mbps, and with 128 stations: 20-40Mbps (it varies a lot..not so sure why).

I poked around in the rx logic and it seems the rx-data path is fairly
clean for data packets.  But, from what I can tell, each beacon is going
to cause an skb_copy() call and a queued work-item for each station interface,
and there are going to be lots of beacons per second in most scenarios...

I was wondering if this could be optimized a bit to special case beacons
and not make a new copy (or possibly move some of the beacon handling
logic up to the radio object and out of the sdata).

And of course, it could be there are more important optimizations...I'm curious
if anyone is aware of any other code that should be optimized to have better
performance with lots of stations...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

