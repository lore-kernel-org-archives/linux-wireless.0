Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36678 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3GIQcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 12:32:08 -0400
Message-ID: <51DC3B03.3040301@candelatech.com> (sfid-20130709_183213_090891_FE2DA5CB)
Date: Tue, 09 Jul 2013 09:32:03 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Replacement for local->hw.conf.channel
References: <51D4BB56.9070401@candelatech.com>    (sfid-20130704_020129_998241_BE6D0EF6) <1372922870.8235.0.camel@jlt4.sipsolutions.net>   <51DB0302.5050201@candelatech.com>  <1373308289.8312.17.camel@jlt4.sipsolutions.net>  <51DB0937.2020609@candelatech.com> <1373380545.8241.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1373380545.8241.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2013 07:35 AM, Johannes Berg wrote:
>
>>> No, don't use that in any new code. It's purely for compatibility with
>>> drivers that aren't converted to channel contexts (yet).
>>>
>>>> In 3.9, ath9k_htc was giving me a null channel in the code below:
>>>>
>>>> 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
>>>> 	if (chanctx_conf)
>>>> 		channel = chanctx_conf->def.chan;
>>>> 	else
>>>> 		channel = NULL;
>>>
>>> Well that of course happens if the vif isn't bound to a channel context.
>>
>> Any opinions on what to return in ethtool stats for frequency if
>> there is no channel context?
>
> Why even bother doing so? "iw dev" shows the frequency and channel width
> just fine, no?

Ethtool API can be a lot easier to code to than netlink (or parsing
iw text output), but it's a small issue.

If iw does return the results I'd be looking for, then maybe I can
go figure out how it gets that info in the kernel and use that
in the netlink code.

>> If there is a quick way to just return whatever the hardware is
>> currently using, I think that is best, but if there is not
>> a reliable way to do this then, some hard coded default
>> like 0 is probably best.
>
> Well there's no such concept as "what the hardware is currently using"
> in this case, the channel is completely pointless when there's no
> channel context at all. There might be something like the current scan
> channel, but what value would there be in returning that?

Ok, it's not a big deal either way...and I can work around it in user-space
by walking the list of all VIFs on a radio and grab the channel of any
that are actually associated and returning good info...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

