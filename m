Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:59772 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0KRGeM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 01:34:12 -0500
Message-ID: <4CE4C8DD.6010806@kernel.org>
Date: Thu, 18 Nov 2010 07:34:05 +0100
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com>	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>	 <4CE292F7.4090200@kernel.org>	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>	 <4CE396A9.1050908@kernel.org> <1290020005.3777.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290020005.3777.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 11/17/2010 07:53 PM, Johannes Berg wrote:
>> WQ_NON_REENTRANT doesn't guarantee ordered execution but it guarantees
>> that a single work is not executed concurrently on multiple CPUs.  I'm
>> not sure whether this would be safe for the workqueue used by mac80211
>> but it should let us know whether the workqueue is choked due to a
>> work which is executing for long time.  In the long run, if using non
>> reentrant is safe for mac80211, using it would be much better.
> 
> No, I don't think it's safe for mac80211.

I see.  In the longer run tho, it would be much better to convert to
NRT workqueue.  The behavior would be more robust with much lower
latencies.

Thanks.

-- 
tejun
