Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46904 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab0KLUQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 15:16:08 -0500
Message-ID: <4CDDA086.2010803@candelatech.com>
Date: Fri, 12 Nov 2010 12:16:06 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com> <AANLkTin_qaMO+3Zm3qnqZ2WDjLoujvCa0W2eLO1BT_Ti@mail.gmail.com>
In-Reply-To: <AANLkTin_qaMO+3Zm3qnqZ2WDjLoujvCa0W2eLO1BT_Ti@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2010 12:08 PM, Luis R. Rodriguez wrote:
> On Fri, Nov 12, 2010 at 12:07 PM,<greearb@candelatech.com>  wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> We cannot call flush_work here because we are holding
>> RTNL and the worker thread(s) that will be called upon to
>> do the flushing might already be running a piece of work
>> that is blocking on RTNL.  That leads to deadlock and/or
>> OOM.
>>
>> The ieee80211_iface_work method does nothing when sdata
>> is stopped (as it would be when the flush_work was called)
>> so it shouldn't be any big change to just cancel the work
>> entirely.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>
> Is this a stable fix?

We didn't see this when testing against .36-ish
wireless-testing...

I can't do any useful testing against official .36 since it
doesn't have the ath5k multi-vif support.

I'm also not sure this patch 100% right, though
it does fix a very reproducible bug for me.  I might be
missing some side-affect of cancelling instead of attempting
to flush the work queue, however, so we should wait for
input from whoever wrote that code in the first place...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

