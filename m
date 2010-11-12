Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43911 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab0KLQdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 11:33:16 -0500
Message-ID: <4CDD6C39.9070400@candelatech.com>
Date: Fri, 12 Nov 2010 08:32:57 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Tejun Heo <tj@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
References: <4CDB2488.4040802@candelatech.com>	 <1289437356.3748.25.camel@jlt3.sipsolutions.net>	 <4CDBB716.7020802@kernel.org> <4CDC2016.8020200@candelatech.com>	 <4CDC8EED.60602@candelatech.com> <1289529427.3695.9.camel@jlt3.sipsolutions.net>
In-Reply-To: <1289529427.3695.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/2010 06:37 PM, Johannes Berg wrote:
> On Thu, 2010-11-11 at 16:48 -0800, Ben Greear wrote:
>> I have a potential scenario:
>>
>> The ieee80211_do_stop logic is called under RTNL, and it
>> then calls flush_work().
>>
>> What if the worker thread is currently blocked on something like
>> wireless_nlevent_process which tries to acquire rtnl?
>>
>> Wouldn't that cause a deadlock?
>
> Only if Tejun's deadlock avoidance doesn't work -- we used to have a
> separate kernel thread for mac80211 work including sdata->work which
> never acquired the RTNL. Also, we have lockdep annotations for exactly
> this kind of thing ("events" and "(linkwatch_work).work" in your held
> locks output) that should catch this.

There is a warning early in the boot from lockdep, not related to wifi.
I fear that is disabling all further lockdep warnings.

Thanks,
Ben


>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
