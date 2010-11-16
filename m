Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46772 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0KPQvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:51:53 -0500
Message-ID: <4CE2B6A0.8020709@candelatech.com>
Date: Tue, 16 Nov 2010 08:51:44 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com> <1289596096.3736.13.camel@jlt3.sipsolutions.net> <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com> <4CE292F7.4090200@kernel.org>
In-Reply-To: <4CE292F7.4090200@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2010 06:19 AM, Tejun Heo wrote:
> Hello,
>
> On 11/15/2010 10:16 PM, Ben Greear wrote:
>> Here's the full trace of sysrq-t output:
>
> Hmmm... for some reason, the dump is not complete.  Only two kworkers
> are printed out.

> Can you please do the followings?
>
> 1. Try to capture the full dump.  Usually serial console works best.

This was from serial console, and I grabbed everything it printed
to the screen.  I'll look in /var/log/messages in case there is more
there.

If you have a system with an ath5k nic, I should be able to show you
how to reproduce it, if you're interested.

> 2. Does adding WQ_MEM_RECLAIM to alloc_ordered_workqueue() call in
>     ieee80211_register_hw() make any difference?
>
> 3. What if you replace it with the following?
>
>     alloc_workqueue(wiphy_name(local->hw.wiphy), WQ_NON_REENTRANT, 0)

I can try these things..hopefully today.

Can you explain briefly how this is supposed to work?  I'm certain that some
workers can be blocked attempting to get rtnl.  When we call flush_work(),
how is a worker chosen/created to flush that work?

Thanks,
Ben

>
> Thanks.
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
