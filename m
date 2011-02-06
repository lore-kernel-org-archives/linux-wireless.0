Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36859 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab1BFS7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 13:59:11 -0500
Received: from [71.112.48.101] (pool-71-112-48-101.sttlwa.dsl-w.verizon.net [71.112.48.101])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p16Ix9lG026986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Feb 2011 10:59:10 -0800
Message-ID: <4D4EEF7D.9020502@candelatech.com>
Date: Sun, 06 Feb 2011 10:59:09 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mac80211 work and channel type
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Much of the work items currently do not explicitly set a channel-type,
and so default to NO_HT (which is zero).

This currently means that we have to do a channel (type)
change for each work item if we are running HT20 or HT40
on the operating channel.  This happens, for instance, during
authentication for stations.

Based on my limited understanding, it seems that it is perfectly
legal to send NO_HT pkts on any channel-type.  It seems that you
can also send HT20 on HT40 channel-types.  So, would there be any
problem to optimizing the work logic to not change the channel type
if the work channel type fit within the bounds of the current
channel type?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
