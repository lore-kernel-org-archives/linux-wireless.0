Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42828 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751809AbeDELqu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 07:46:50 -0400
Message-ID: <1522928804.7140.10.camel@sipsolutions.net> (sfid-20180405_134654_449960_71F692B6)
Subject: Re: [PATCH] rsi: Free the unaligned pointer
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 05 Apr 2018 13:46:44 +0200
In-Reply-To: <20180405114124.v2cgo36uuniirby2@mwanda>
References: <20180405112311.GD4218@mwanda>
         <1522927835.7140.8.camel@sipsolutions.net>
         <20180405113931.n6q6ix47quuvklyp@mwanda>
         <20180405114124.v2cgo36uuniirby2@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-04-05 at 14:41 +0300, Dan Carpenter wrote:
> On Thu, Apr 05, 2018 at 02:39:31PM +0300, Dan Carpenter wrote:
> > On Thu, Apr 05, 2018 at 01:30:35PM +0200, Johannes Berg wrote:
> > > On Thu, 2018-04-05 at 14:23 +0300, Dan Carpenter wrote:
> > > > The problem here is that we allocate "data".  Then we do
> > > > "data = PTR_ALIGN(data, 8);" and then we free the aligned pointer and
> > > > not the one we allocated.
> > > 
> > > That seems pretty pointless, since kmalloc guarantees such alignment for
> > > sure. Better to just remove PTR_ALIGN()?
> > 
> > Yeah.  You're probably right.  I was thinking that maybe
> > ARCH_SLAB_MINALIGN was smaller than 8 somewhere but look it it now, I
> > think it's always 8 or more.
> > 
> 
> Perhaps on certain xtensa variants?
> 
> arch/xtensa/include/asm/processor.h:#define ARCH_SLAB_MINALIGN  XCHAL_DATA_WIDTH
> arch/xtensa/variants/fsf/include/variant/core.h:#define XCHAL_DATA_WIDTH                4       /* data width in bytes */

That's ... interesting. The comment on the original of this says it's
supposed to be used for "better alignment" (more zero bits), and I'd
think that there's lots of code making such assumptions...

I'd argue it's an xtensa bug, if we need to deal with this everywhere
then it might get messy. Mostly we don't have to care, since pointer
alignment is sufficient in many cases, but still...

Hmm. Dunno what to do here then.

johannes
