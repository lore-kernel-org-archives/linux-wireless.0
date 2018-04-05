Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50932 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751262AbeDELln (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 07:41:43 -0400
Date: Thu, 5 Apr 2018 14:41:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] rsi: Free the unaligned pointer
Message-ID: <20180405114124.v2cgo36uuniirby2@mwanda> (sfid-20180405_134147_724141_43446064)
References: <20180405112311.GD4218@mwanda>
 <1522927835.7140.8.camel@sipsolutions.net>
 <20180405113931.n6q6ix47quuvklyp@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180405113931.n6q6ix47quuvklyp@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 05, 2018 at 02:39:31PM +0300, Dan Carpenter wrote:
> On Thu, Apr 05, 2018 at 01:30:35PM +0200, Johannes Berg wrote:
> > On Thu, 2018-04-05 at 14:23 +0300, Dan Carpenter wrote:
> > > The problem here is that we allocate "data".  Then we do
> > > "data = PTR_ALIGN(data, 8);" and then we free the aligned pointer and
> > > not the one we allocated.
> > 
> > That seems pretty pointless, since kmalloc guarantees such alignment for
> > sure. Better to just remove PTR_ALIGN()?
> 
> Yeah.  You're probably right.  I was thinking that maybe
> ARCH_SLAB_MINALIGN was smaller than 8 somewhere but look it it now, I
> think it's always 8 or more.
> 

Perhaps on certain xtensa variants?

arch/xtensa/include/asm/processor.h:#define ARCH_SLAB_MINALIGN  XCHAL_DATA_WIDTH
arch/xtensa/variants/fsf/include/variant/core.h:#define XCHAL_DATA_WIDTH                4       /* data width in bytes */

regards,
dan carpenter
