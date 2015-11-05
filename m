Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43603 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033050AbbKEQBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 11:01:40 -0500
Subject: Re: Configurable scan dwell time?
To: Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>
References: <563A9B8C.3060503@candelatech.com>
 <CA+BoTQnYrFSLkdBgcMgnuJPvPeSjuu9oB68KkU7jRMEH5iFE2A@mail.gmail.com>
 <1446710205.2540.1.camel@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <563B7D63.1010203@candelatech.com> (sfid-20151105_170143_743038_FBC8E408)
Date: Thu, 5 Nov 2015 08:01:39 -0800
MIME-Version: 1.0
In-Reply-To: <1446710205.2540.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2015 11:56 PM, Johannes Berg wrote:
> On Thu, 2015-11-05 at 07:41 +0100, Michal Kazior wrote:
>> On 5 November 2015 at 00:58, Ben Greear <greearb@candelatech.com>
>> wrote:
>>> It looks to me like the channel dwell time when scanning (SW
>>> scanning,
>>> mac80211)
>>> is fixed at 1/9 of a second.  I'd like to make this
>>> configurable...is that
>>> something
>>> that might be welcome upstream?
>>>
>>> My plan is to add to the netlink API around starting a scan and
>>> allow
>>> user-space to
>>> configure a dwell time in milliseconds.
>>
>> I've actually tried doing something like this some time ago:
>>
>>   - http://thread.gmane.org/gmane.linux.kernel.wireless.general/111255
>>   - http://thread.gmane.org/gmane.linux.kernel.wireless.general/111251
>>
>
> And as I said back then, I'm rather opposed to this. We risk adding API
> that either nobody uses, or that ends up getting used in ways that
> weren't intended (say for certain measurements) and then will break
> things when scanning is changed in firmware, etc.
>
> Let the scanning be. It's intended to find networks, not really
> something else. Piggy-backing survey onto it was mostly a mistake. For
> other things, do some more reasonable measurement commands.

My issue is that APs can be set to beacon at longer beacon times, and
then passive scanning at ~110ms intervals is not going to find the APs
very often (and with bad luck, technically it could *never* find the AP
due to scanning at unlucky periodic intervals).

So, when I know that I am doing passive scan, I would like the option
to set the dwell time larger.

And, for active scanning, maybe 33ms is a lot longer that is actually
needed?

I read through some of your comments from before.  I think we could
treat this as a hint to the driver, and it could ignore it as needed.

Firmware implementations I'm aware of are already limited in a million
different ways, and of course if someone cared, they could propagate
the dwell time into the firmware if they cared.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

