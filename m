Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54080 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaJVQHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 12:07:43 -0400
Message-ID: <5447D64E.9030301@candelatech.com> (sfid-20141022_180749_804361_E051CD15)
Date: Wed, 22 Oct 2014 09:07:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/6] cfg80211:  support creating wiphy with suggested
 name.
References: <1413845378-27837-1-git-send-email-greearb@candelatech.com> <1413919898.1998.15.camel@jlt4.sipsolutions.net> <5446BD98.3010107@candelatech.com>
In-Reply-To: <5446BD98.3010107@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/21/2014 01:10 PM, Ben Greear wrote:
> On 10/21/2014 12:31 PM, Johannes Berg wrote:
> 
>>>  	/* give it a proper name */
>>> -	dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
>>> +	if (requested_name && requested_name[0]) {
>>> +		struct cfg80211_registered_device *rdev2;
>>> +		int wiphy_idx, taken = -1, result, digits;
>>> +
>>> +		/* Code below is from cfg80211_dev_rename */
>>
>> can you refactor this then please?
> 
> I'll see what I can do on this, as well as take care of
> the rest of the comments.

I was thinking, this could be made simpler if we reduced restrictions on
the naming.  Basically, let user (re)name the wiphy however they want, as
long as it name is not currently in use.

Might require a bit of extra locking and checking instead of just assuming the
atomic-inc and phy%d is unique, but maybe that is worth the tradeoff?

I'll get started on trying to refactor with existing constraints, but
let me know how you feel about relaxing the restrictions...

Thanks,
Ben

> 
> Thanks,
> Ben
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

