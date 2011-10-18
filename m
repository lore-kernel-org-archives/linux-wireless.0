Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58338 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab1JRQDV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 12:03:21 -0400
Message-ID: <4E9DA33E.2000603@candelatech.com> (sfid-20111018_180324_329314_FFC8E6B9)
Date: Tue, 18 Oct 2011 09:03:10 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	reinette chatre <reinette.chatre@intel.com>
Subject: Re: [RFC] mac80211: properly go back to operational channel?
References: <1317121970-3638-1-git-send-email-sgruszka@redhat.com>  <1317123289.4082.12.camel@jlt3.sipsolutions.net>  <20110929150018.GA4554@redhat.com>  <1317740824.6741.22.camel@jlt3.sipsolutions.net>  <20111005111507.GA2184@redhat.com>  <1317813762.4839.7.camel@jlt3.sipsolutions.net>  <20111018141922.GA6204@redhat.com> <1318948251.3958.29.camel@jlt3.sipsolutions.net> <4E9D9306.1060005@openwrt.org>
In-Reply-To: <4E9D9306.1060005@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2011 07:53 AM, Felix Fietkau wrote:
> On 2011-10-18 4:30 PM, Johannes Berg wrote:
>> On Tue, 2011-10-18 at 16:19 +0200, Stanislaw Gruszka wrote:
>>>   For local->tmp_channel == NULL and local->scan_channel == NULL
>>>   ieee80211_cfg_on_oper_channel() will return false if
>>>   local->oper_channel != local->hw.conf.channel,
>>>   hece we do not properly go back to oper_channel from tmp_channel.
>>
>> Huh, good catch.
>>
>>>   Does patch have sense?
>>
>> Let's see what Ben says. It seems a bit like the
>> ieee80211_cfg_on_oper_channel() test there should be inverted instead of
>> removed?
>>
>>>   Could it fixes problems we are talking
>>>   in this thread?
>>
>> Yes, could be related, also some issue Jouni and Reinette have been
>> seeing with P2P might be related as well.
> Just remembered this old patch, also related to this part:
> http://news.gmane.org/find-root.php?message_id=%3c1311607763%2d12603%2d3%2dgit%2dsend%2demail%2deliad%40wizery.com%3e

I thought that patch was going into the kernel.

I'm busy this morning, but I'm hacking on wifi later today if
all goes well, so I can test out this patch.

Thanks,
Ben

>
> - Felix


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

