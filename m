Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:51720 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab2FNS04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 14:26:56 -0400
Message-ID: <4FDA2CED.8090303@opentechinstitute.org> (sfid-20120614_202659_531023_FA7A0F57)
Date: Thu, 14 Jun 2012 14:26:53 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add support for userspace to handle auth frames
 on adhoc ifaces
References: <4FD8B5D4.8060305@opentechinstitute.org>    <4FD99A24.3020907@lri.fr> <1339673095.4461.2.camel@jlt3.sipsolutions.net>   <4FD9DD35.4070709@lri.fr> <1339692819.9786.4.camel@jlt3.sipsolutions.net>  <4FDA179F.1020501@opentechinstitute.org> <1339693721.9786.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339693721.9786.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/14/2012 01:08 PM, Johannes Berg wrote:
> On Thu, 2012-06-14 at 12:55 -0400, Will Hawkins wrote:
>>
>> On 06/14/2012 12:53 PM, Johannes Berg wrote:
>>> On Thu, 2012-06-14 at 14:46 +0200, Nicolas Cavallari wrote:
>>>> On 14/06/2012 13:24, Johannes Berg wrote:
>>>>> On Thu, 2012-06-14 at 10:00 +0200, Nicolas Cavallari wrote:
>>>>>
>>>>>> I just have a question here : when auth frames are not delivered to
>>>>>> userspace, mac80211 will respond to them, and also uses them to detect
>>>>>> node reboot. If you register for auth frames, mac80211 will still send
>>>>>> auth frames as soon as a new station is seen, which might be confusing
>>>>>> for user space. Is that ok to do this ? Or should userspace have more
>>>>>> control over how mac80211 sends auth frames ?
>>>>>
>>>>> Please read the code. If userspace registers for them, mac80211 will
>>>>> never do anything with the frame.
>>>>
>>>> I didn't say the contrary. But if you read ieee80211_ibss_finish_sta(),
>>>> you see that mac80211 sends auth frames to each discovered station, even
>>>> if userspace want to handle auth frames. This seems strange to be able
>>>> to receive and handle auth frames from userspace while mac80211 sends
>>>> them behind userspace's back.
>>>
>>> Oops, sorry, yes. I forgot all about that code!
>>>
>>> I suppose we'd have to check whether userspace is handling
>>> authentication?
>>
>> Could use the control_port flag to check for that condition?
> 
> Not really, that's not necessarily the same thing -- I think we might
> want to also allow to offload open auth to userspace.
> 
> I think it wouldn't be difficult to notify mac80211 about frame
> registrations so it can keep track for this purpose?
> 
> johannes

I am happy to code something like this up. I've already taken a look at
it and don't think it will be too big of a problem. I am going to be AFK
until Monday so I won't get to it until then. I hope that's not a problem.

Will

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
