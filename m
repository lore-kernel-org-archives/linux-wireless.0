Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58946 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2LNSId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 13:08:33 -0500
Message-ID: <50CB6B1D.4050409@candelatech.com> (sfid-20121214_190837_102394_7AAE7782)
Date: Fri, 14 Dec 2012 10:08:29 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Subject: Re: [PATCH 0/5] mac80211: fix station cleanup/destruction
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2012 02:59 PM, Johannes Berg wrote:
> Turns out that not only was flush_workqueue() slow as reported
> by Ben, it was also broken because this is way too late to
> finish the station destruction in AP mode.
>
> Fixing this with keeping the roaming semantics (no RCU barrier
> or synchronize in there) is a bit tricky so the first patch just
> fixes the problem, and the last patch puts back the optimisation.
>
> The patches inbetween are just padding ;-)

I applied this series (as well as the beacon cleanup from Luius)
and so far, the 600-station test case is working fine.

I backported this to 3.7.0, by the way.  It was mostly clean,
but I had to tweak a few things to resolve conflicts.

We will of course let you know if we see anything weird :)

So, you can add:

Tested-by:  Ben Greear <greearb@candelatech.com>


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

