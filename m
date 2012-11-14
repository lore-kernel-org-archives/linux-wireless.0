Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateout03.mbox.net ([165.212.64.25]:53914 "EHLO gwo3.mbox.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161166Ab2KNLUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 06:20:33 -0500
Received: from gwo3.mbox.net (localhost [127.0.0.1])
	by gwo3.mbox.net (Postfix) with ESMTP id 630A3E001D2E
	for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2012 11:09:33 +0000 (UTC)
Message-ID: <50A37BE6.1010600@ok-labs.com> (sfid-20121114_122040_993611_1D26934F)
Date: Wed, 14 Nov 2012 22:09:26 +1100
From: Jonathan Gordon <jdgordon@ok-labs.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: nl80211 notification when scanning is finished?
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm writing a fake wifi driver (basically a proxy between two devices) 
which uses nl80211 to talk to a real wifi device, and it mostly works, 
but I have a problem with the scanning interface.

 From userland, after sending the NL80211_CMD_GET_SCAN the results come 
in as a single netlink read (split up and the handler gets called once 
for each) and I know it is finished after that read, but I'm triggering 
the scan from a different kernel driver (so driverA -> driverB -> genl 
to userland -> nl80211 -> userland -> driverB -> driverA). I don't want 
to modify the nl80211 message (with the theory that i could go driverB 
-> nl80211 directly later) but I have no way to know when scanning 
results have been fully sent. (Or even how many results to expect so I 
can finally call cfg80211_scan_done() in driverA when that many stations 
have been reported from nl80211).

Is there any way to do what I want? Is it possible to know when we get 
the NLMSG_DONE type from the post_doit?
Is it possible to figure it out using a combination of the pre_doit() 
and post_doit() callbacks?

The really nasty hack I'm using currently is having a timeout of 1s 
after I receive a NL80211_CMD_GET_SCAN (resetting the timeout for each 
one) but I'm praying there is a nicer way?

Thanks.
Jonathan Gordon

P.S yes, the design is convoluted, but there is no other way to do what 
we want. :)
