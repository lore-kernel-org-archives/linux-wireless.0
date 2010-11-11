Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52840 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab0KKFvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 00:51:32 -0500
Message-ID: <4CDB845E.5040906@candelatech.com>
Date: Wed, 10 Nov 2010 21:51:26 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
References: <4CDB2488.4040802@candelatech.com>	 <4CDB3F7E.1000107@candelatech.com> <1289437415.3748.26.camel@jlt3.sipsolutions.net>
In-Reply-To: <1289437415.3748.26.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2010 05:03 PM, Johannes Berg wrote:
> On Wed, 2010-11-10 at 16:57 -0800, Ben Greear wrote:
>
>> I think the attached trace might be more useful.  It shows
>> the blocked tasks spammage that we saw in an earlier
>> run.
>
> Yeah but we already knew that these tasks were blocking, and where ...
> nothing really new here. I don't see it, yet anyway.

I think at least one of the 'ip' processes has RTNL held, according to
it's stack trace, and then it went and did something in mac80211.
I haven't tried to track everything down in the code yet, however.

The system starts being very sluggish, and then locks hard.  It's possible
that those particular processes might eventually recover or get a bit
farther, perhaps the hard-lock is elsewhere.

We have lockdep enabled, and it never spits anything out, for what
that's worth.

I'll get some more traces tomorrow to see if I can find any similarities.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
