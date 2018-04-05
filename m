Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46604 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbeDEMXN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 08:23:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] rsi: Free the unaligned pointer
References: <20180405112311.GD4218@mwanda>
        <1522927835.7140.8.camel@sipsolutions.net>
        <20180405113931.n6q6ix47quuvklyp@mwanda>
        <20180405114124.v2cgo36uuniirby2@mwanda>
        <1522928804.7140.10.camel@sipsolutions.net>
Date: Thu, 05 Apr 2018 15:23:06 +0300
In-Reply-To: <1522928804.7140.10.camel@sipsolutions.net> (Johannes Berg's
        message of "Thu, 05 Apr 2018 13:46:44 +0200")
Message-ID: <87woxletat.fsf@kamboji.qca.qualcomm.com> (sfid-20180405_142316_347510_AF3FB7C2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2018-04-05 at 14:41 +0300, Dan Carpenter wrote:
>> On Thu, Apr 05, 2018 at 02:39:31PM +0300, Dan Carpenter wrote:
>> > On Thu, Apr 05, 2018 at 01:30:35PM +0200, Johannes Berg wrote:
>> > > On Thu, 2018-04-05 at 14:23 +0300, Dan Carpenter wrote:
>> > > > The problem here is that we allocate "data".  Then we do
>> > > > "data = PTR_ALIGN(data, 8);" and then we free the aligned pointer and
>> > > > not the one we allocated.
>> > > 
>> > > That seems pretty pointless, since kmalloc guarantees such alignment for
>> > > sure. Better to just remove PTR_ALIGN()?
>> > 
>> > Yeah.  You're probably right.  I was thinking that maybe
>> > ARCH_SLAB_MINALIGN was smaller than 8 somewhere but look it it now, I
>> > think it's always 8 or more.
>> > 
>> 
>> Perhaps on certain xtensa variants?
>> 
>> arch/xtensa/include/asm/processor.h:#define ARCH_SLAB_MINALIGN  XCHAL_DATA_WIDTH
>> arch/xtensa/variants/fsf/include/variant/core.h:#define
>> XCHAL_DATA_WIDTH 4 /* data width in bytes */
>
> That's ... interesting. The comment on the original of this says it's
> supposed to be used for "better alignment" (more zero bits), and I'd
> think that there's lots of code making such assumptions...
>
> I'd argue it's an xtensa bug, if we need to deal with this everywhere
> then it might get messy. Mostly we don't have to care, since pointer
> alignment is sufficient in many cases, but still...
>
> Hmm. Dunno what to do here then.

IMHO let's just get rid of the ugly PTR_ALIGN(), I strongly doubt it was
added because of this xtensa "feature" :) If we ever get a bug report
about this we can then talk with the xtensa folks.

-- 
Kalle Valo
