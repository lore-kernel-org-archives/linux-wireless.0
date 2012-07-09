Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45794 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2GIW2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 18:28:18 -0400
Received: by pbbrp8 with SMTP id rp8so19897866pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 15:28:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341334067.20124.9.camel@jlt3.sipsolutions.net>
References: <1341322108.20124.3.camel@jlt3.sipsolutions.net>
 <CAB=NE6VvJ+rv4mtYMngVg==tDVZpRM2CrGJ3Yc4u7a7ZLwiGOA@mail.gmail.com>
 <CAB=NE6WDyFS5gK85Lq1uEA5A5HLRhhyVcFT7EQkK0SALG0YF6g@mail.gmail.com>
 <1341332487.20124.7.camel@jlt3.sipsolutions.net> <1341332934.2164.17.camel@joe2Laptop>
 <1341334067.20124.9.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 9 Jul 2012 15:27:57 -0700
Message-ID: <CAB=NE6V3DxmGmqVMkZeGsnjxgTHakd1Z7LB83uF88sBe5JKogw@mail.gmail.com> (sfid-20120710_002822_007995_EFF01936)
Subject: Re: [PATCH] compat-wireless: fix debugging in iwlwifi
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Joe Perches <joe@perches.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 9:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2012-07-03 at 09:28 -0700, Joe Perches wrote:
>> On Tue, 2012-07-03 at 18:21 +0200, Johannes Berg wrote:
>> > On Tue, 2012-07-03 at 09:16 -0700, Luis R. Rodriguez wrote:
>> > > On Tue, Jul 3, 2012 at 8:47 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> > > > On Tue, Jul 3, 2012 at 6:28 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > > >> From: Johannes Berg <johannes.berg@intel.com>
>> > > >>
>> > > >> As compat includes linux/device.h well before iwlwifi, the
>> > > >> definitions from there are used without DEBUG, but iwlwifi
>> > > >> defines DEBUG to get debug output. Use dev_printk instead
>> > > >> of dev_dbg to get debugging back.
>> > > >>
>> > > >> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> > > >
>> > > > Applied and pushed, thanks!
>> > >
>> > > On today's linux-next.git the dev_dbg() changed to dev_err(), I've
>> > > updated the patch to reflect this.
>> >
>> > Huh, sorry. Please drop this for now -- the patch to change it *from*
>> > dev_err *to* dev_dbg is only in my iwlwifi-next tree now.
>>
>> And besides, the concept is wrong.
>>
>> There's no reason to drop dynamic_debug support by
>> forcing output to KERN_DEBUG.
>
> Well, the thing is, "#define DEBUG" doesn't work in compat-wireless ...
> We add it to the Makefile though I guess

What if we add a hunk to iwlwifi to undef DEBUG and redefine it ? Sort
of similar problem as with pr_fmt no? I've merged this patch now.

  Luis
