Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41759 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3GHSU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 14:20:58 -0400
Message-ID: <51DB0302.5050201@candelatech.com> (sfid-20130708_202115_968241_2169528B)
Date: Mon, 08 Jul 2013 11:20:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Replacement for local->hw.conf.channel
References: <51D4BB56.9070401@candelatech.com>  (sfid-20130704_020129_998241_BE6D0EF6) <1372922870.8235.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1372922870.8235.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/04/2013 12:27 AM, Johannes Berg wrote:
> On Wed, 2013-07-03 at 17:01 -0700, Ben Greear wrote:
>> I'm trying to port some patches forward to 3.10....
>>
>> I am trying to find the current channel for a radio.  Since
>> hw.conf.channel no longer exists, what is the best way to
>> go about this?
>
> Well there's hw.conf.chandef.chan now I think, but that can be NULL and
> generic mac80211 code must not use it. There's no single current channel
> any more, you want vif->chanctx or so.

 From looking at the scanning code (line 542 or so), it appears

local->_oper_chandef.chan

might work?

In 3.9, ath9k_htc was giving me a null channel in the code below:

	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
	if (chanctx_conf)
		channel = chanctx_conf->def.chan;
	else
		channel = NULL;


I haven't tried that yet in 3.10 or later, so maybe I don't need the
hw.conf.channel in new code anyway.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

