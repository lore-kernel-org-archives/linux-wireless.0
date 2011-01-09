Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58688 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1AIRpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 12:45:20 -0500
Message-ID: <4D29F42A.1040300@candelatech.com>
Date: Sun, 09 Jan 2011 09:45:14 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix skb-copy failure debug message.
References: <1294511454-29985-1-git-send-email-greearb@candelatech.com> <1294565540.3469.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1294565540.3469.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2011 01:32 AM, Johannes Berg wrote:
> On Sat, 2011-01-08 at 10:30 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This particular error isn't about multicast.
>
> Actually, it is... only multicast frames should ever be processed by
> multiple interfaces.

Or if the STA interfaces are promisc for some reason..but no big
deal either way.  With the old ath9k code, even arps or dhcp requests
would be an order-1 SKB, so that is probably what I was seeing.

I had a clean overnight run with the ath9k copybreak logic, so
that seems to have been the root problem.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
