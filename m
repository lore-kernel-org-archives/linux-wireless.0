Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34565 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbbHJPaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 11:30:09 -0400
Date: Mon, 10 Aug 2015 20:59:43 +0530
From: Chandra Gorentla <csgorentla@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org,
	sudipm.mukherjee@gmail.com
Subject: Re: [PATCH] staging: wilc100: Remove pointer and integer comparision
Message-ID: <20150810152943.GA12993@gcs-HP-Compaq-nx6320> (sfid-20150810_173014_290770_B243B8EF)
References: <1439133602-9654-1-git-send-email-csgorentla@gmail.com>
 <20150810093943.GI5180@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150810093943.GI5180@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 10, 2015 at 12:39:43PM +0300, Dan Carpenter wrote:
> On Sun, Aug 09, 2015 at 08:50:02PM +0530, Chandra S Gorentla wrote:
> > Removed pointer check with integer; this fixes 'sparse' error -
> > error: incompatible types for operation (>)
> >    left side has type unsigned char [usertype] *[usertype] pu8Tail
> >    right side has type int
> > 
> > Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
> > ---
> >  drivers/staging/wilc1000/host_interface.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> > index cc549c2..4ba1ad7 100644
> > --- a/drivers/staging/wilc1000/host_interface.c
> > +++ b/drivers/staging/wilc1000/host_interface.c
> > @@ -3471,7 +3471,7 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
> >  	*pu8CurrByte++ = ((pstrSetBeaconParam->u32TailLen >> 24) & 0xFF);
> >  
> >  	/* Bug 4599 : if tail length = 0 skip copying */
> > -	if (pstrSetBeaconParam->pu8Tail > 0)
> > +	if (pstrSetBeaconParam->pu8Tail != NULL)
> >  		memcpy(pu8CurrByte, pstrSetBeaconParam->pu8Tail, pstrSetBeaconParam->u32TailLen);
> >  	pu8CurrByte += pstrSetBeaconParam->u32TailLen;
> 
> Warnings are a precious thing, because they show you where people are
> lost.  It's better to take a broader look at the code instead of *just*
> silencing the warning.
> 
> For example, the comment is nonsense.  memcpy(anything, anything, 0);
> is a no-op so it already would skip copying in that case.  I wonder what
> bug 4599 actually means...
> 
> Also the next line is quite suspect.  Even though we don't copy then we
> are still incrementing the pu8CurrByte count?  That seems wrong.
> 
> So now let's consider if the memcpy() is correct.  pu8CurrByte is
> allocated at the start of the function.  It should have space for
> ->u32TailLen bytes, except for they seem to have forgotten about integer
> overflow.  I think ->u32TailLen is not trusted data so this could be a
> security bug.  Maybe you could exploit it by setting ->u32HeadLen to the
> amount of memory you want to corrupt.  Set ->u32TailLen to a high
> number so it triggers an integer overflow.  Set >pu8Tail to NULL so it
> is doesn't just corrupt everything (DoS attack instead of privilege
> escalation).
> 
> I have just looked at the code so I don't know if this is true, but this
> is how I read that warning.
> 
> regards,
> dan carpenter
Hello Dan and Sudip,

Thank you for reviewing the patch.

At the outset - two points that happened outside this mail chain.

1. I sent a Version 2 of this Patch before I received your comments.  I
   corrected subject line word wilc100 -> wilc1000.

2. Sudip Mucherjee (sudipm.mukherjee@gmail.com) replied to the V2
   of this patch and suggested to remove the '!=NULL'.

In the current patch, I tried to fix (or silence) a 'sparse' error,
it is not a warning.  As you pointed out there may be some more
problems in the function but can you explain why the error thrown
by the 'sparse' should not be fixed?  I agree with your suggestion
that we need to take a broader look.  Please help in understanding
how does that broader look is suggesting that the patch is not
addressing a right problem.  The gcc version I am using is - 4.8.2.

In the later part of your reply - you felt that there may be a
case in which more than the allocated number of bytes may be
copied in to the memory pointed to by 'pu8CurrByte' and memory
may get corrupted.  From the code in the function I am not seeing
that happening.  In the beginning of the function, this pointer
variable is assigned a block of memory whose size is
'->u32HeadLen' + '->u32TailLen' + 16.

The function is copying 16 individual bytes to this memory;
a smaller block of memory of size '->u32HeadLen' is being copied;
and an another smaller block of memory of size '->u32TailLen' may
be copied based on a condition.  After this last copy, the
function increments the pointer by '->u32TailLen' irrespective
of last copy takes place or not.  Hence I am not seeing any
corruption of the memory.

It looks like that the last increment is just an operation that
does no harm.  In addition to this the pointer variable
'pu8CurrByte' is just a local variable and it is not being used
after the last increment operation of the pointer.

After making the change in this patch I just did a 'make'.
I do not have the hardware which this driver supports.  So at
this point of time, I cannot test your suggestions on wilc1000
hardware.  Is there any way I can test this driver code on a
old notebook computer?

Thank you,
chandra
