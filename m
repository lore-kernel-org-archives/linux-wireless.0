Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdGLGMZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2017 02:12:25 -0400
Date: Wed, 12 Jul 2017 08:12:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rui Teng <rui.teng@linux.vnet.ibm.com>
Cc: devel@driverdev.osuosl.org,
        Aditya Shankar <aditya.shankar@microchip.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ganesh Krishna <ganesh.krishna@microchip.com>
Subject: Re: [PATCH] drivers/staging/wilc1000: fix sparse warning: right
 shift by bigger than source value
Message-ID: <20170712061220.GB11450@kroah.com> (sfid-20170712_081240_291087_0FD50D24)
References: <20170710085731.28397-1-rui.teng@linux.vnet.ibm.com>
 <20170711170449.GA30362@kroah.com>
 <f31c5818-7ba3-4708-3fda-5bfbe0c4c1da@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f31c5818-7ba3-4708-3fda-5bfbe0c4c1da@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 12, 2017 at 10:23:02AM +0800, Rui Teng wrote:
> On 12/07/2017 1:04 AM, Greg Kroah-Hartman wrote:
> > On Mon, Jul 10, 2017 at 04:57:31PM +0800, Rui Teng wrote:
> > > This patch sets memory to zero directly to avoid unnecessary shift and
> > > bitwise operations on bool type, which can fix a sparse warning and also
> > > improve performance.
> > 
> > It does?  How did you measure the performance impact?  What was now
> > faster?
> 
> It can avoid 3 times right shift and 3 times bitwise operations.
> And once memory set should also faster than 4 times copy operations.
> And add number 4 once should also faster than 4 times plus plus.

And did you test this to prove that this does matter and is noticable?
How do you know that gcc doesn't just optimize it all away?  Is this on
a code path that actually matters?

Don't ever say "improve performance" without actually being able to
prove it please.

> > thanks,
> > 
> > greg k-h
> > 
> > 
> > > 
> > > Signed-off-by: Rui Teng <rui.teng@linux.vnet.ibm.com>
> > > ---
> > >  drivers/staging/wilc1000/host_interface.c | 7 +++----
> > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> > > index 2568dfc15181..036c5c19a016 100644
> > > --- a/drivers/staging/wilc1000/host_interface.c
> > > +++ b/drivers/staging/wilc1000/host_interface.c
> > > @@ -2416,10 +2416,9 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
> > >  		goto ERRORHANDLER;
> > > 
> > >  	pu8CurrByte = wid.val;
> > > -	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
> > > -	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);
> > > -	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
> > > -	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 24) & 0xFF);
> > > +	memset(pu8CurrByte, 0, 4);
> > > +	*pu8CurrByte = (strHostIfSetMulti->enabled & 0xFF);
> > > +	pu8CurrByte += 4;
> > 
> > Are you sure enabled isn't larger than 8 bits?
> 
> The size of bool may larger than 8 bits. But when we assign any value
> to bool type, the value of bool type will only be 1 or 0.
> For example, the following output will be 1 other than 0x100.
> 	bool b = 0x100;
> 	printf("b: %d\n", b);
> 
> Or I think it should change 'enabled' type from bool to u32, to make sure
> that the right shift operation can take effect.

I think we should ask the authors of this code what is expected here as
it is quite odd...

thanks,

greg k-h
