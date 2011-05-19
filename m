Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40338 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab1ESEOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 00:14:24 -0400
To: Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH] mac80211: fix and simplify mesh locking
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Thu, 19 May 2011 06:14:20 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTi=0RMrBKVFFC7UUnVPyZpZvfGvK6g@mail.gmail.com>
 (sfid-20110519_034116_480982_F4415B84)
References: <1305363652.3437.8.camel@jlt3.sipsolutions.net>
 <1305364803.3437.10.camel@jlt3.sipsolutions.net>
 <BANLkTikyymbnXHANmB3N0ecJWdkY9xCG=Q@mail.gmail.com>
 <1305758752.8827.1.camel@jlt3.sipsolutions.net>
 <BANLkTi=0RMrBKVFFC7UUnVPyZpZvfGvK6g@mail.gmail.com>
 (sfid-20110519_034116_480982_F4415B84)
Message-ID: <336458d50895bb0b63e77ad24ce54c82@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 18 May 2011 18:40:33 -0700, Javier Cardona wrote:
>>> I'm seeing this after trying your patch, probably because the
>>> allocations mesh_table_alloc() can block.  In the past I had tried 
>>> to
>>> allocate the table before entering the critical section.  If that 
>>> is
>>> not possible for the race condition you mention,  then I guess 
>>> we'll
>>> have to make those allocations GFP_ATOMIC?
>>
>> Err, now I'm confused, how could the code have done non-atomic
>> allocations while under rcu_read_lock()? I guess there was just no
>> verification there?
>
> I'm not sure.  I can tell you that the bug message is only triggered
> after your patch was applied, same .config.
> Maybe i have an rcu configuration that does not check that.
>
> Is making the allocations atomic an acceptable solution?

It looks like it's the only solution :-)
Anyway they should've been atomic even before already, not sure why RCU 
didn't complain but it was definitely not right to do GFP_KERNEL 
allocations under RCU lock, but now that I think about it ISTR that 
whether it warns or not might depend on the RCU implementation you 
selected in the config.

johannes
