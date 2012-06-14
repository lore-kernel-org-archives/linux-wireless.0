Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:63687 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2FNQsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 12:48:15 -0400
Message-ID: <4FDA15CE.9050408@opentechinstitute.org> (sfid-20120614_184818_239679_79C1A8CF)
Date: Thu, 14 Jun 2012 12:48:14 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add support for userspace to handle auth frames
 on adhoc ifaces
References: <4FD8B5D4.8060305@opentechinstitute.org>  <4FD99A24.3020907@lri.fr> <1339673095.4461.2.camel@jlt3.sipsolutions.net> <4FD9DD35.4070709@lri.fr>
In-Reply-To: <4FD9DD35.4070709@lri.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/14/2012 08:46 AM, Nicolas Cavallari wrote:
> On 14/06/2012 13:24, Johannes Berg wrote:
>> On Thu, 2012-06-14 at 10:00 +0200, Nicolas Cavallari wrote:
>>
>>> I just have a question here : when auth frames are not delivered to
>>> userspace, mac80211 will respond to them, and also uses them to detect
>>> node reboot. If you register for auth frames, mac80211 will still send
>>> auth frames as soon as a new station is seen, which might be confusing
>>> for user space. Is that ok to do this ? Or should userspace have more
>>> control over how mac80211 sends auth frames ?
>>
>> Please read the code. If userspace registers for them, mac80211 will
>> never do anything with the frame.
> 
> I didn't say the contrary. But if you read ieee80211_ibss_finish_sta(),
> you see that mac80211 sends auth frames to each discovered station, even
> if userspace want to handle auth frames. This seems strange to be able
> to receive and handle auth frames from userspace while mac80211 sends
> them behind userspace's back.
> 
>>
>>> There is also another thing to consider if you want to send auth frames
>>> from userspace, as CMD_FRAME requires a frequency, which in IBSS mode,
>>> can change anytime without userspace being notified. If you only have to
>>> answer to received auth frames, this is easier as you can reuse the
>>> frequency given by nl80211 when receiving the auth frame. But if you
>>> want to send a auth frame independently, how do you get the frequency to
>>> use ?
>>
>> You check the BSS info, that's trivial.
> 
> There is no GET_BSS from userspace. when merging IBSS, only the new
> BSSID is notified. The only way to get this info from userspace would be
> to dump the scan result and check the "we joined that ibss" flag, and
> this isn't race-free. That, or using fixed_freq.
> 

I've only coded for situations where I am joined to an ibss with a
fixed_freq so I've never encountered this problem.

Will
