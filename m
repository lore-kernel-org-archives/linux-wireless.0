Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59518 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933488Ab3CVP74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 11:59:56 -0400
Message-ID: <514C7FF6.6070301@candelatech.com> (sfid-20130322_170000_715928_0442ECD1)
Date: Fri, 22 Mar 2013 08:59:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211:  Make un-found-rate splat a warn-once.
References: <1363727997-1554-1-git-send-email-greearb@candelatech.com>  <1363727997-1554-2-git-send-email-greearb@candelatech.com>  (sfid-20130319_222017_355151_860485B7) <1363948082.8238.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1363948082.8238.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/22/2013 03:28 AM, Johannes Berg wrote:
> On Tue, 2013-03-19 at 14:19 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> After that, print it out with net_ratelimit.  We saw a system
>> continually hit this warning, for reasons unknown, and it
>> seems it bogged the system down enough to make it go OOM.
>
> I'm not really sure I like this ... that points to a deeper problem, and
> this just papers over it while causing more cost in the TX path for all
> the different checks.

If I add an 'unlikely' to the initial check, that gets back to the original
TX path cost, or are you worried about something else?

I think in most cases we should be using some variation of WARN_ONCE
in all the places that splat a warning...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

