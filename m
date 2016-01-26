Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49884 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965321AbcAZP3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 10:29:31 -0500
Message-ID: <56A790DA.4050409@candelatech.com> (sfid-20160126_162934_923132_EE38CCB8)
Date: Tue, 26 Jan 2016 07:29:30 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] mac80211: fix txq queue related crashes
References: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>	<56A66298.1000607@candelatech.com> <CA+BoTQmha9HveqrKE9qLKLHu8vWfv+V=Sbkd7rhWyk7ALoJOmg@mail.gmail.com>
In-Reply-To: <CA+BoTQmha9HveqrKE9qLKLHu8vWfv+V=Sbkd7rhWyk7ALoJOmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/25/2016 10:35 PM, Michal Kazior wrote:
> On 25 January 2016 at 18:59, Ben Greear <greearb@candelatech.com> wrote:
>> On 01/21/2016 05:23 AM, Michal Kazior wrote:
>>>
>>> The driver can access the queue simultanously
>>> while mac80211 tears down the interface. Without
>>> spinlock protection this could lead to corrupting
>>> sk_buff_head and subsequently to an invalid
>>> pointer dereference.
>>
>> Hard to know for certain, but this *appears* to fix the unexpectedly large
>> amount of CE/AXI ath10k firmware crashes that we saw in the 4.2 kernel (4.0
>> previously
>> ran much better han 4.2 for us).
>
> That's impossible.
>
> Without wake_tx_queue() txqs aren't even allocated (sdata->vif.txq is NULL).

You are right.  But while testing, one of my guys did find a way to reproduce the
crash very quickly in 4.2.  Happens fastest when I use the HTT-MGT variant
of my firmware, but same firmware works good-ish in 4.0.  Seems I have something
to bisect now if I can get a minimal patch to apply each time to enable my
htt-mgt firmware feature...

The latest test case is to just to change the channel of the AP while station
is connected.  Station sends some null-funcs, firmware resets it's low-level
stuff a bunch because it doesn't get AKCs, then CE/AXI crashes.  Could be
my firmware or kernel modifications of course, though similar crash scenarios have been seen forever
in all sorts of firmwares and kernels.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
