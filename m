Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45548 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3C0SfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 14:35:17 -0400
Message-ID: <51533BDD.9010700@candelatech.com> (sfid-20130327_193523_547154_B87248C7)
Date: Wed, 27 Mar 2013 11:35:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] mac80211:  Optimize sta lookup for many VIFs
References: <1364259443-22469-1-git-send-email-greearb@candelatech.com>  (sfid-20130326_015732_712534_6202434D) <1364326932.8319.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1364326932.8319.15.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2013 12:42 PM, Johannes Berg wrote:
> On Mon, 2013-03-25 at 17:57 -0700, greearb@candelatech.com wrote:
>
>> v3:  Use rcu_dereference_protected as suggested.
>
> Heh.
>
>> +		some_sta = rcu_dereference_protected(sta->sdata->some_sta, 1);
>
> No no no, you're supposed to give it a proper argument like
> "lockdep_is_held(&local->sta_mtx)"

Before I screw this up again..do you prefer that I line up
method arguments and go over 80 character line length, or
force the argument leftward to meet the 80 char limit?

I see no good way to make it fit in 80 chars and also
line up properly.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

