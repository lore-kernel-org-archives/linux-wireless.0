Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:35077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab0KRHWC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 02:22:02 -0500
Message-ID: <4CE4D41F.1080005@kernel.org>
Date: Thu, 18 Nov 2010 08:22:07 +0100
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com>	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>	 <4CE292F7.4090200@kernel.org>	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>	 <4CE396A9.1050908@kernel.org> <1290020005.3777.6.camel@jlt3.sipsolutions.net> <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost>
In-Reply-To: <51f5dd53c39a77fff4efc1a99b189725@localhost>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Johannes.

On 11/18/2010 08:07 AM, Johannes Berg wrote:
>> I see.  In the longer run tho, it would be much better to convert to
>> NRT workqueue.  The behavior would be more robust with much lower
>> latencies.
> 
> I really don't think it's possible without going to some scheme
> where we use a single work struct and kick off things out of it,
> or implement our own threading or similar things ...

I see.

> But why is this unreliable and/or high latency anyway?

Oh, no, it's not unreliable or high latency on workqueue side.  It's
just error prone for its users.  As there is only single executino
resource by definition, any single work can stall the whole queue and
it also is easy to create a deadlock by introducing circular
dependency.  For example, mac80211 uses system wq for restart work and
that's to avoid grabbing rtnl_lock from a work as that will introduce
a deadlock, right?  If you use non-ordered workqueues, you don't need
to worry about those artificial dependencies.

> It used to be just fine .. maybe this is one of the cases where we
> should actually be using a dedicated thread ...

Oh, trust me, that won't change anything.  If there's a bug in
workqueue (I don't think this is the case here tho), let's fix it.  If
mac80211 is somehow tripping a deadlock around single execution
resource, let's fix the culprit.  Okay?  At this point, all we need is
a proper task dump to see who's holding what where.

Thanks.

-- 
tejun
