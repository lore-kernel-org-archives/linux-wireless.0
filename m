Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49554 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab2CLQ1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 12:27:34 -0400
Message-ID: <4F5E23F1.1010501@candelatech.com> (sfid-20120312_172744_232347_1618976A)
Date: Mon, 12 Mar 2012 09:27:29 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bss_info_change_notify warning (hacked 3.3.0-rc5+)
References: <4F57B7E6.1050103@candelatech.com>  (sfid-20120307_203301_816701_DF7D4715) <1331189709.3446.1.camel@jlt3.sipsolutions.net>  <4F5A4C83.50009@candelatech.com> <1331536233.3496.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331536233.3496.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2012 12:10 AM, Johannes Berg wrote:
> On Fri, 2012-03-09 at 10:31 -0800, Ben Greear wrote:
>> On 03/07/2012 10:55 PM, Johannes Berg wrote:
>>> On Wed, 2012-03-07 at 11:32 -0800, Ben Greear wrote:
>>>> This is with a somewhat hacked 3.3.0-rc5+.  Just
>>>> curious if this is a known problem.
>>>>
>>>>
>>>> Seems very reproducible on my system.
>>>>
>>>>
>>>> WARNING: at /home/greearb/git/linux-3.3.dev.y/net/mac80211/driver-ops.h:10 ieee80211_bss_info_change_noti)
>>>
>>> The warning means you're modifying an interface the driver doesn't (yet)
>>> know about.
>>>
>>> It's odd that you should be running into this on config_beacon() though
>>> since that can only execute when the interface is up ... can you print
>>> out the interface name in the warning?
>>
>> This is still reproducible in 3.3.0-rc6+ from yesterday.
>>
>>
>> I create the VAP with this command:
>>
>> ./local/sbin/iw phy wiphy0 interface add vap0 type __ap
>>
>>
>> vap0:  Failed check-sdata-in-driver check, flags: 0x0
>
> That's it? That doesn't create a warning here, and somehow you're
> running into nl80211_set_wiphy() which isn't called if you execute just
> that iw command.

Well, there's a lot of other stuff going on too.  Power is set, for one
thing, hostapd is started, etc.

I will see if I can come up with a easy way to reproduce this, but
it might be a few days as I'm stacked up with work at the moment.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

