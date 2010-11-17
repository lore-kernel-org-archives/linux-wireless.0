Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42417 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935040Ab0KQS7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 13:59:34 -0500
Message-ID: <4CE4260F.80603@candelatech.com>
Date: Wed, 17 Nov 2010 10:59:27 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Tejun Heo <tj@kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com>	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>	 <4CE292F7.4090200@kernel.org>	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>	 <4CE396A9.1050908@kernel.org> <1290020005.3777.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290020005.3777.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2010 10:53 AM, Johannes Berg wrote:
> On Wed, 2010-11-17 at 09:47 +0100, Tejun Heo wrote:
>
>> WQ_NON_REENTRANT doesn't guarantee ordered execution but it guarantees
>> that a single work is not executed concurrently on multiple CPUs.  I'm
>> not sure whether this would be safe for the workqueue used by mac80211
>> but it should let us know whether the workqueue is choked due to a
>> work which is executing for long time.  In the long run, if using non
>> reentrant is safe for mac80211, using it would be much better.
>
> No, I don't think it's safe for mac80211.

So maybe my patch is a good enough way to fix this?

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

