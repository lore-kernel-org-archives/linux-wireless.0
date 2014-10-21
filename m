Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45234 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041AbaJUUKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 16:10:01 -0400
Message-ID: <5446BD98.3010107@candelatech.com> (sfid-20141021_221007_143118_FF6362FA)
Date: Tue, 21 Oct 2014 13:10:00 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/6] cfg80211:  support creating wiphy with suggested
 name.
References: <1413845378-27837-1-git-send-email-greearb@candelatech.com> <1413919898.1998.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1413919898.1998.15.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/21/2014 12:31 PM, Johannes Berg wrote:

>>  	/* give it a proper name */
>> -	dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
>> +	if (requested_name && requested_name[0]) {
>> +		struct cfg80211_registered_device *rdev2;
>> +		int wiphy_idx, taken = -1, result, digits;
>> +
>> +		/* Code below is from cfg80211_dev_rename */
> 
> can you refactor this then please?

I'll see what I can do on this, as well as take care of
the rest of the comments.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

