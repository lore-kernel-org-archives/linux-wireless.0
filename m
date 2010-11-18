Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55320 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab0KRRzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 12:55:35 -0500
Message-ID: <4CE56892.9090606@candelatech.com>
Date: Thu, 18 Nov 2010 09:55:30 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com>	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>	 <4CE292F7.4090200@kernel.org>	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>	 <4CE396A9.1050908@kernel.org> <1290020005.3777.6.camel@jlt3.sipsolutions.net> <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost> <4CE4D41F.1080005@kernel.org>
In-Reply-To: <4CE4D41F.1080005@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2010 11:22 PM, Tejun Heo wrote:
> Hello, Johannes.
>
> On 11/18/2010 08:07 AM, Johannes Berg wrote:
>>> I see.  In the longer run tho, it would be much better to convert to
>>> NRT workqueue.  The behavior would be more robust with much lower
>>> latencies.
>>
>> I really don't think it's possible without going to some scheme
>> where we use a single work struct and kick off things out of it,
>> or implement our own threading or similar things ...
>
> I see.
>
>> But why is this unreliable and/or high latency anyway?
>
> Oh, no, it's not unreliable or high latency on workqueue side.  It's
> just error prone for its users.  As there is only single executino
> resource by definition, any single work can stall the whole queue and
> it also is easy to create a deadlock by introducing circular
> dependency.  For example, mac80211 uses system wq for restart work and
> that's to avoid grabbing rtnl_lock from a work as that will introduce
> a deadlock, right?  If you use non-ordered workqueues, you don't need
> to worry about those artificial dependencies.
>
>> It used to be just fine .. maybe this is one of the cases where we
>> should actually be using a dedicated thread ...
>
> Oh, trust me, that won't change anything.  If there's a bug in
> workqueue (I don't think this is the case here tho), let's fix it.  If
> mac80211 is somehow tripping a deadlock around single execution
> resource, let's fix the culprit.  Okay?  At this point, all we need is
> a proper task dump to see who's holding what where.

I understand your desire for a stack dump, but it appears that sysrq-t
isn't getting everything you want, for whatever reason.

Does my explanation of the rtnl deadlock that I posted near the beginning
of this thread (with some backtraces to back that up) make sense, or
are my assumptions invalid?

Thanks,
Ben

>
> Thanks.
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

