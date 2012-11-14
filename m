Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38515 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab2KNRNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 12:13:34 -0500
Message-ID: <50A3D138.7010906@candelatech.com> (sfid-20121114_181337_703775_34445992)
Date: Wed, 14 Nov 2012 09:13:28 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 'ip' blocking for long time trying to down station
References: <5091ADDD.4050407@candelatech.com>  (sfid-20121101_000206_244719_62ADC7A2) <1352884491.9510.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352884491.9510.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/14/2012 01:14 AM, Johannes Berg wrote:
> Hi Ben,
>
> Sorry for the late reply.
>
>> This is on the 400 station test machine.  No more crashes, but I'm seeing long
>> pauses (10+ seconds) when trying to down station interfaces (and sometimes other
>> commands as well).  The system cannot stabilize (my user-space app times out
>> after a while due to blocking on system() calls such as the one below,
>> and gives up, causing endless loops of up/down, associate, dhcp, etc)
>> I'm going to tweak the user-space code more to try to bring up stations
>> in smaller batches, but it still seems like there is room for improvement
>> in the OS.
>>
>> Using sysrq, I got this trace of the command.  I'm not sure it was blocked
>> in the same place the whole time, but it seems likely.  Any ideas for how
>> to speed this sort of thing up?
>>
>> ./local/sbin/ip link set sta140 down
>>
>
>>    [<ffffffff81070e2e>] flush_work+0x2b/0x34
>>    [<ffffffff8106f857>] ? cwq_dec_nr_in_flight+0x76/0x76
>>    [<ffffffffa026a673>] ieee80211_do_stop+0x379/0x544 [mac80211]
>
> I'm guessing that the other interfaces are actually re-scheduling work
> items while this is trying to flush ... I'm not really sure how to
> improve this behaviour though.

That seems very likely, as other stations would be trying to associate
in this scenario....

Can we just purge all of this interface's work items from the list w/out flushing
everyone else's work?

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

