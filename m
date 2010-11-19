Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:40145 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0KSOee (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 09:34:34 -0500
Message-ID: <4CE68AF4.8060507@kernel.org>
Date: Fri, 19 Nov 2010 15:34:28 +0100
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com>	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>	 <4CE292F7.4090200@kernel.org>	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>	 <4CE396A9.1050908@kernel.org>	 <1290020005.3777.6.camel@jlt3.sipsolutions.net>	 <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost>	 <4CE4D41F.1080005@kernel.org> <1290099585.3801.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290099585.3801.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Johannes.

On 11/18/2010 05:59 PM, Johannes Berg wrote:
> Ok, that makes sense then. I thought you were saying there was some
> intrinsic issue with this! I do know about the issues, but we do have to
> process some things in the right order here so I'd rather be aware of
> those issues than have to deal with reordering and/or our own queueing.

Yes, sure.  It all depends on what the specific subsystem wants.
Another option could be putting everything which doesn't require
strict ordering to the default system workqueue (if they aren't
already, that is).

>> Oh, trust me, that won't change anything.  If there's a bug in
>> workqueue (I don't think this is the case here tho), let's fix it.  If
>> mac80211 is somehow tripping a deadlock around single execution
>> resource, let's fix the culprit.  Okay?  At this point, all we need is
>> a proper task dump to see who's holding what where.
> 
> I agree completely -- just misunderstood you there!

Awesome.  :-)

Ben, if you have trouble generating full trace, please let me know if
there's something I can buy which isn't too expensive to reproduce the
problem.  I would be happy to track it down myself.

Thanks.

-- 
tejun
