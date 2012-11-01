Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39704 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458Ab2KAHze (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 03:55:34 -0400
Message-ID: <50922AA9.4030509@ti.com> (sfid-20121101_085545_939909_4A5096F0)
Date: Thu, 1 Nov 2012 09:54:17 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 6/6] mac80211: add ap channel switch command/event
References: <1350226137-13704-1-git-send-email-victorg@ti.com>   <1350226137-13704-7-git-send-email-victorg@ti.com>  <1350414472.10177.17.camel@jlt4.sipsolutions.net> <50842563.4010201@ti.com> <1350910599.10166.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1350910599.10166.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/10/2012 14:56, Johannes Berg wrote:
> On Sun, 2012-10-21 at 18:40 +0200, Victor Goldenshtein wrote:
>> On 16/10/2012 21:07, Johannes Berg wrote:
>>> On Sun, 2012-10-14 at 16:48 +0200, Victor Goldenshtein wrote:
>>>> Add ieee80211_ap_process_chanswitch(), to handle a channel switch
>>>> request for AP.
>>>>
>>>> Add ieee80211_ap_ch_switch_done() which updates oper_channel
>>>> and notifies upper layers about channel switch complete event.
>>>
>>> Given channel contexts, how does this patch need to change?
>>>
>>
>> I guess most of the changes would be in the channel switch complete
>> area, we will need to update the correct vif channel
>> (ieee80211_assign_vif_chanctx) instead of the local->oper_channel.
>
> Yes, maybe, not sure.
>
> Also wrt. channel contexts, how will CAC/radar check work? The AP isn't
> bound to a channel until start_ap(), so somehow you'll have to bind it

As I mentioned in my previous email we do it with __nl80211_set_channel().

> (and keep it on that channel!) while the DFS check is running? And also
> prohibit using multiple channels at this time...?

Why we need to prohibit multiple channels during CAC?
I don't see any problems to start CAC on different channels (once we"ll 
add this support), also lets not forget that CAC is relevant only for 
the AP role. Today for the MR single channel scenarios we have this 
check in the nl80211_start_radar_detection():

+» if·(chan->cac_started)
+» » return·-EBUSY;

which should block concurrent CAC executions on the same channel.

Anyway, the "DFS channel contexts" are not part of this patch series, 
and can be added later.

-- 
Thanks,
Victor.
