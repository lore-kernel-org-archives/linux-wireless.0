Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:37736 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbAWLgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 06:36:08 -0500
Received: by mail-lb0-f171.google.com with SMTP id u14so6536122lbd.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 03:36:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422009226.2728.31.camel@sipsolutions.net>
References: <1421962219-6840-1-git-send-email-emmanuel.grumbach@intel.com>
	<1422006994.2728.22.camel@sipsolutions.net>
	<1422008312.13429.5.camel@egrumbacBox>
	<1422009226.2728.31.camel@sipsolutions.net>
Date: Fri, 23 Jan 2015 13:36:06 +0200
Message-ID: <CANUX_P0wvnNKV+-TtGV62ujMxtDDbJ=uEhaxKQF2ePvBcvyOnA@mail.gmail.com> (sfid-20150123_123612_009003_CC8C8C03)
Subject: Re: [PATCH] mac80211: synchronize_net() before flushing the queues
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2015 at 12:33 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2015-01-23 at 10:18 +0000, Grumbach, Emmanuel wrote:
>
>> I don't think it will introduce that much of latency.
>> Note that there is a call to flush() right after that, this means that
>> any driver which implements this call needs to wait there. So you have
>> the latency in either place. The only additional latency it adds is for
>> other RCU sections / packets on other interfaces.
>
> This is correct.
>
>> Also - since we just stopped the netif, there can possibly be only one
>> packet for each vif / ac processing. This is not too much data to
>> process.
>
> But this is the wrong conclusion.
>
> synchronize_rcu() is expensive, no matter what, especially if you have
> multiple cores. The RCU grace periods will practically never line up,
> and it needs to wait for every CPU to go through one.
>

I know.

> It's not actually just "one packet for each vif/ac" - it's a whole tail
> of whatever other RCU usages there are. Back when this was discussed,
> the wizery people measured this to hundreds of ms in many not too
> uncommon cases.
>

That's the part I didn't know. I wasn't aware that this
synchronize_net() was there and that someone removed it.

>> Your call, but to honest, I have been optimizing the roaming as well (as
>> you know). And it was really bad for drivers that implements the flush()
>> callback. Especially in cases where you are already far from the AP you
>> want to roam from. This is why I added the drop parameter and other
>> optimizations (don't flush() after probing etc...)
>
> Well, yes, but that's an upper bound - here with the synchronize_net()
> we're more talking about a lower bound.
>

I also have to admit I was wrong earlier: the flush() call in
set_disassoc has drop set to true, so this call will return
immediately.

I just wonder how we handle the case where we still have packets in
the Tx path and we bring everything down. I can check the code, but
not right now.
