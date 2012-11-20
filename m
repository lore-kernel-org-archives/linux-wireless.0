Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56958 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab2KTPQy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 10:16:54 -0500
Message-ID: <50AB9E91.50903@ti.com> (sfid-20121120_161715_812580_85064162)
Date: Tue, 20 Nov 2012 17:15:29 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>, <victorgld@gmail.com>
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection command/event
References: <1350226137-13704-1-git-send-email-victorg@ti.com>     <1350226137-13704-2-git-send-email-victorg@ti.com>    <1350414099.10177.13.camel@jlt4.sipsolutions.net>   <50842569.5000602@ti.com> <1350910543.10166.3.camel@jlt4.sipsolutions.net>   <50922A9D.2060409@ti.com> <1352128887.9466.17.camel@jlt4.sipsolutions.net>  <50A26163.10300@ti.com> <1352891985.9510.22.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352891985.9510.22.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14/11/2012 13:19, Johannes Berg wrote:
> On Tue, 2012-11-13 at 17:04 +0200, Victor Goldenshtein wrote:
>
>>> Hmm. Maybe then the channel should be passed to the radar detection
>>> command instead? That way, it can be passed through, you can allocate a
>>> channel context, etc. Much easier?
>>
>> We already pass the frequency in the radar detection command, the set
>> channel operation comes during hostapd init flow regardless DFS
>> implementation.
>
> Ok, but it doesn't seem to be passed through to the driver, nor
> considered as a channel that's currently in use. cfg80211 is now
> tracking which channels are used for multi-channel purposes, and this
> needs to be integrated here.
>

right, we should consider currently used channel and somehow make sure 
that we use a single channel context.


-- 
Thanks,
Victor.
