Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36072 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab2COS42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:56:28 -0400
Message-ID: <4F623B58.1070106@candelatech.com> (sfid-20120315_195631_916314_AE02E2B6)
Date: Thu, 15 Mar 2012 11:56:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211:  Support getting sta_info stats via ethtool.
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com>  <1331833159-12694-2-git-send-email-greearb@candelatech.com>  (sfid-20120315_183942_222982_FD61EFBD) <1331837531.3432.36.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331837531.3432.36.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2012 11:52 AM, Johannes Berg wrote:
> On Thu, 2012-03-15 at 10:39 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This lets ethtool print out stats related to station
>> interfaces.  Does not yet get stats from the underlying
>> driver.
>
> Hmm. What's the advantage of using ethtool over iw, which already has a
> bunch of these numbers?

Well, ethtool api might be easier for some apps to use,
and perhaps easier for users to read if all they want
are stats.

But, I also plan to add stats from the underlying
driver with and additional (optional) call down
to the driver, and I think we would not ever want to
add that to netlink API.

That way, we can add internal ath9k counters and
such instead of having to use debugfs.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

