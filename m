Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39392 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab2E2VOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 17:14:34 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q4TLEYLF018082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 14:14:34 -0700
Message-ID: <4FC53C3A.1080001@candelatech.com> (sfid-20120529_231438_421874_8495B5A3)
Date: Tue, 29 May 2012 14:14:34 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Is there no upper limit on mac80211 pending xmit queue size?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tx pending queues doesn't seem to be limitted, allowing
run-away memory usage when something like pktgen is
sending packets faster than the system can actually
send them.

[root@ct520-2011 ~]# cat /debug/ieee80211/wiphy0/queues
00: 0x00000000/0
01: 0x00000000/0
02: 0x00000001/40076
03: 0x00000000/0
[root@ct520-2011 ~]# cat /debug/ieee80211/wiphy0/queues
00: 0x00000000/0
01: 0x00000000/0
02: 0x00000001/52649
03: 0x00000000/0
[root@ct520-2011 ~]# cat /debug/ieee80211/wiphy0/queues
00: 0x00000000/0
01: 0x00000000/0
02: 0x00000001/107939
03: 0x00000000/0

I think this is what is causing my OOM issues when sending
with (my hacked version of) pktgen.

Shouldn't there be an upper limit on the number of pending frames
that mac80211 will queue?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

