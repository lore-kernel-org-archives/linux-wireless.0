Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:52537 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161178Ab2KNMTK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 07:19:10 -0500
Message-ID: <50A38C3A.20908@tieto.com> (sfid-20121114_131914_662658_57F94696)
Date: Wed, 14 Nov 2012 13:19:06 +0100
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Victor Goldenshtein <victorg@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kgiori@qca.qualcomm.com" <kgiori@qca.qualcomm.com>,
	"mcgrof@frijolero.org" <mcgrof@frijolero.org>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"adrian.chadd@gmail.com" <adrian.chadd@gmail.com>,
	"j@w1.fi" <j@w1.fi>, "coelho@ti.com" <coelho@ti.com>,
	"igalc@ti.com" <igalc@ti.com>,
	"adrian@freebsd.org" <adrian@freebsd.org>,
	"nbd@nbd.name" <nbd@nbd.name>,
	"simon.wunderlich@s2003.tu-chemnitz.de"
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 6/6] mac80211: add ap channel switch command/event
References: <1350226137-13704-1-git-send-email-victorg@ti.com>     <1350226137-13704-7-git-send-email-victorg@ti.com>    <1350414472.10177.17.camel@jlt4.sipsolutions.net>   <50842563.4010201@ti.com> <1350910599.10166.4.camel@jlt4.sipsolutions.net>   <50922AA9.4030509@ti.com> <1352128994.9466.19.camel@jlt4.sipsolutions.net>  <50A2617B.3060807@ti.com> <1352892233.9510.26.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352892233.9510.26.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14/11/12 12:23, Johannes Berg wrote:
> On Tue, 2012-11-13 at 17:04 +0200, Victor Goldenshtein wrote:
>
>>> No ... channel contexts are in the kernel now, so you do have to think
>>> about it now.
>>
>> Well thinking is one thing implementing is another ;)
>
> Well ... :)
>
>> This whole DFS implementation initially intended for a single channel
>> mac. I don't might to deal with the channel context stuff but not sure
>> how much available time I"ll have for it, so it might take awhile.
>> I know there are people waiting for this, so I'm thinking would you
>> consider to go first with this single channel DFS support and later to
>> extend it to work with channel context stuff ?
>
> Fair enough, but like I've been telling you, the current code doesn't
> even match the current APIs.
>
> Initially, I thought that for radar detection, you need to reserve the
> channel context (in mac80211), make sure it's the only channel context
> and prohibit other channel contexts from being added, until radar
> detection is done.
>
> However, then I realised that that still doesn't work -- once initial
> radar detection is done, it needs to continue while the AP is active. If
> the channel context was going to be relinquished, or even just the
> channel changed for a few seconds, it would be unsafe. So as a result,
> the radar detect operation has to somehow be coupled to the start AP
> operation and prohibit channel changes and additional channel contexts
> during the entire operation time.

Hmm.. cfg80211 doesn't really know about channel contexts.

The problem I see is that cfg80211 may be in a combination with 
`num_different_channels = 1` and mac80211 can have 2 channel contexts 
due to channel type incompatibilities.

We'd need to tell cfg80211 that multi-interface is not possible when DFS 
is active if we want to at least consider single-channel only DFS.


-- Pozdrawiam / Best regards, Michal Kazior.
