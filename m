Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43353 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab0KSUzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 15:55:18 -0500
Message-ID: <4CE6E430.6080804@candelatech.com>
Date: Fri, 19 Nov 2010 12:55:12 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Tejun Heo <tj@kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com>	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>	 <4CE292F7.4090200@kernel.org>	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>	 <4CE396A9.1050908@kernel.org>	 <1290020005.3777.6.camel@jlt3.sipsolutions.net>	 <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost>	 <4CE4D41F.1080005@kernel.org>	 <1290099585.3801.1.camel@jlt3.sipsolutions.net>	 <4CE68AF4.8060507@kernel.org> <1290189452.3768.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290189452.3768.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2010 09:57 AM, Johannes Berg wrote:
> On Fri, 2010-11-19 at 15:34 +0100, Tejun Heo wrote:
>
>> Awesome.  :-)
>>
>> Ben, if you have trouble generating full trace, please let me know if
>> there's something I can buy which isn't too expensive to reproduce the
>> problem.  I would be happy to track it down myself.
>
> Maybe you can try Ben's setup in kvm (or directly on your box if you
> like) with mac80211_hwsim. From a mac80211 POV it should be almost
> equivalent, although it'll do different memory allocation patterns etc.

I tried manually backing out my patch, and now I can no longer reproduce
the problem.  Maybe something in -rc2 fixed it, or maybe some changes
to my environment just made it harder to hit.

If you see no logical reason why calling flush_work with RTNL held
would cause trouble, then I guess we can just leave the code as is
for now.

If you do want to play with this yourself, I think any ath5k type adapter
with 64+ virtual stations configured would be a valid test case.  My
application calls ifdown/ifup on them a few times after being created
and then generates traffic (and gathers stats, calls 'iwconfig', etc).
As configured in the original scenario that reproduced the problem,
the STAs had no encryption and were all associating with a single AP.
wpa_supplicant was not being used.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

