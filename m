Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47528 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab2KMPFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 10:05:41 -0500
Message-ID: <50A2617B.3060807@ti.com> (sfid-20121113_160544_210065_322353FF)
Date: Tue, 13 Nov 2012 17:04:27 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 6/6] mac80211: add ap channel switch command/event
References: <1350226137-13704-1-git-send-email-victorg@ti.com>    <1350226137-13704-7-git-send-email-victorg@ti.com>   <1350414472.10177.17.camel@jlt4.sipsolutions.net>  <50842563.4010201@ti.com> <1350910599.10166.4.camel@jlt4.sipsolutions.net>  <50922AA9.4030509@ti.com> <1352128994.9466.19.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352128994.9466.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2012 17:23, Johannes Berg wrote:
> On Thu, 2012-11-01 at 09:54 +0200, Victor Goldenshtein wrote:
>
>>> Also wrt. channel contexts, how will CAC/radar check work? The AP isn't
>>> bound to a channel until start_ap(), so somehow you'll have to bind it
>>
>> As I mentioned in my previous email we do it with __nl80211_set_channel().
>
> Yeah but that probably should change anyway, for channel contexts?
>
>>> (and keep it on that channel!) while the DFS check is running? And also
>>> prohibit using multiple channels at this time...?
>>
>> Why we need to prohibit multiple channels during CAC?
>
> Because you can't do CAC properly while you're channel-hopping?
>
>> I don't see any problems to start CAC on different channels (once we"ll
>> add this support)
>
> I do see issues with that, but let's not worry about it for now.
>
>> also lets not forget that CAC is relevant only for
>> the AP role. Today for the MR single channel scenarios we have this
>> check in the nl80211_start_radar_detection():
>
> MR?
>
>> +» if·(chan->cac_started)
>> +» » return·-EBUSY;
>>
>> which should block concurrent CAC executions on the same channel.
>
> Yes.
>
>> Anyway, the "DFS channel contexts" are not part of this patch series,
>> and can be added later.
>
> No ... channel contexts are in the kernel now, so you do have to think
> about it now.
>

Well thinking is one thing implementing is another ;)

This whole DFS implementation initially intended for a single channel 
mac. I don't might to deal with the channel context stuff but not sure 
how much available time I"ll have for it, so it might take awhile.
I know there are people waiting for this, so I'm thinking would you 
consider to go first with this single channel DFS support and later to 
extend it to work with channel context stuff ?

-- 
Thanks,
Victor.
