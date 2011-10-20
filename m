Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42321 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1JTQND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 12:13:03 -0400
Message-ID: <4EA04883.6010805@candelatech.com> (sfid-20111020_181309_167018_F2A18592)
Date: Thu, 20 Oct 2011 09:12:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211:  Fix off-channel problem in work task.
References: <1319049876-16243-1-git-send-email-greearb@candelatech.com> <20111020145852.GB2293@redhat.com> <4EA03CCF.6090604@candelatech.com> <20111020160859.GC2293@redhat.com>
In-Reply-To: <20111020160859.GC2293@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/20/2011 09:09 AM, Stanislaw Gruszka wrote:
> On Thu, Oct 20, 2011 at 08:22:55AM -0700, Ben Greear wrote:
>> On 10/20/2011 07:58 AM, Stanislaw Gruszka wrote:
>>> On Wed, Oct 19, 2011 at 11:44:36AM -0700, greearb@candelatech.com wrote:
>>>> From: Ben Greear<greearb@candelatech.com>
>>>>
>>>> The ieee80211_cfg_on_oper_channel method compared the
>>>> current hardware config as well as the desired hardware
>>>> config.  In most cases, this is proper, but when deciding
>>>> whether to go back on-channel, if the hardware is not
>>>> configured on-channel, but logically it *should* be
>>>> on-channel, then we must go on-channel.
>>>>
>>>> This patch adds a flag to the ieee80211_cfg_on_oper_channel
>>>> logic to disable comparing the actual hardware so we do not
>>>> have to create another tricky method with similar logic.
>>>>
>>>> Reported-by: Eliad Peller<eliad@wizery.com>
>>>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>>>
>>> I much more prefer previous one-line patch from Eliad
>>> http://news.gmane.org/find-root.php?message_id=%3c1311607763%2d12603%2d3%2dgit%2dsend%2demail%2deliad%40wizery.com%3e
>>>
>>> this one seems to provide unneeded code complexity, but
>>> behaviour i.e. number of channel switches in hardware
>>> is the same.
>>
>> I believe it's possible to set tmp_channel to NULL and not actually
>> change the on/off channel configuration, and my patch should allow us to
>> skip a hardware config in that case.
>>
>> However, this might only be possible if we are in this code while
>> scanning, and currently, I don't believe we can be in this work
>> code while scanning.
>
> So you want to optimize a case that is not even possible at present.
> Do you know that "premature optimization is the root of all evil" ? :-)

I was trying to clean out some of the sloppiness in the on/off channel
logic, but in this case, I don't think the extra parania helped much,
and my attempt at cleverness obviously introduced some bugs...

> I'm not quite against by that change, but I would like to have -stable
> fixes, since bug we are talking about not only annoys people by warning,
> but also disallow to associate to wireless network. I prefer that we
> apply Eliad patches and cc -stable and do possible further optimization
> on top of that (ideally if some measurement will be available that show
> optimization really works).

That is fine with me.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

