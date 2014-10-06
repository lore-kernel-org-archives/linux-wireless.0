Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58100 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaJFS0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 14:26:25 -0400
Message-ID: <5432DEEB.8020107@candelatech.com> (sfid-20141006_202629_550801_58D5C7FE)
Date: Mon, 06 Oct 2014 11:26:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/4] wireless:  expose set-wiphy-name method to other
 modules.
References: <1411773856-25042-1-git-send-email-greearb@candelatech.com>	 (sfid-20140927_012441_483840_20B8643D) <1412605634.3098.18.camel@jlt4.sipsolutions.net>
In-Reply-To: <1412605634.3098.18.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/06/2014 07:27 AM, Johannes Berg wrote:
> On Fri, 2014-09-26 at 16:24 -0700, greearb@candelatech.com wrote:
>
>> +/*
>> + * Attempt to rename a device.  Acquire RTNL before calling.
>> + */
>
> please add kernel-doc
>
>> +int cfg80211_dev_rename_wiphy(struct wiphy *wiphy, char *newname);
>
> Should also be const char *
>
> And should probably be called cfg80211_rename_wiphy() only? What's the
> dev doing there?
>>
>> +int cfg80211_dev_rename_wiphy(struct wiphy *wiphy, char *newname)
>> +{
>> +	struct cfg80211_registered_device *rdev;
>> +
>> +	rdev = wiphy_to_rdev(wiphy);
>> +	return cfg80211_dev_rename(rdev, newname);
>
> You could just inlin ethe wiphy_to_rdev() and get rid of the variable.
>
> Anyhow - if the intent is to do this at creation, why do you do it after
> the fact? Couldn't you just specify the name when creating it?

That would be fine with me..I thought it might be more invasive
and thus less welcome.  I'll see what it takes to implement it
like that when I get a chance.  On the road this week, so might
be a bit...

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

