Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:46880 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYJFSab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 14:30:31 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2019847fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 11:30:30 -0700 (PDT)
Message-ID: <1ba2fa240810061130w6b1a2282ga80156e7d756c74@mail.gmail.com> (sfid-20081006_203035_694764_5B270507)
Date: Mon, 6 Oct 2008 20:30:29 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] iwlwifi: fix DMA code and bugs
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223312084.15196.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223308831.15196.28.camel@johannes.berg>
	 <1223309405.15196.32.camel@johannes.berg>
	 <1ba2fa240810060949w5404944dud9f7b6b373542981@mail.gmail.com>
	 <1223311876.15196.38.camel@johannes.berg>
	 <1223312084.15196.41.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 6, 2008 at 6:54 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2008-10-06 at 18:51 +0200, Johannes Berg wrote:
>
>> > >  * therefore, all the is_odd junk goes away
>> > >  * fix a bug in iwl_hcmd_queue_reclaim where it would reclaim all the
>> > >   fragments of a descriptor rather than all descriptors (this may be
>> > >   the cause of the dma unmapping problem I reported)
>> > >  * some more cleanups
>> >
>> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> > > --
>> >
>> >
>> > > Tested on 5000 hw, please apply.
>> >
>> > Great job,  however do not apply this before I review it I had strong
>> > feeling this will not
>> > work with aggregation flows.
>>
>> I cannot imagine why you think that, care to explain?

Yep, no connection I thought at the first glance you've thatched more code.
>
> Of course, I would very much appreciate you review the actual bug fix in
> iwl_hcmd_queue_reclaim, which consist of the addition of the line
>
> +               bd = &txq->bd[index];

Okay I found the source of the evil, with your big pointer :)
The bug caused by this memory optimization juggling we've done and
very  bad cut and paste coding
We moved for command buffers from pcI_alloc consitent to kmalloc which
required pci mapping that that was coded wrongly. Now this kmalloc
stuff is not good as well since we have this 36 bit memory limitation
on 64 bit platforms.
This is the issue I'm trying to address recently I'm not sure what yet
what allocation schema would be best yet.
Tomas
