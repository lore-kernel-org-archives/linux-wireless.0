Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36777 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbbHJRkz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 13:40:55 -0400
Date: Mon, 10 Aug 2015 23:10:34 +0530
From: Chandra Gorentla <csgorentla@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org,
	sudipm.mukherjee@gmail.com, csgorentla@gmail.com
Subject: Re: [PATCH] staging: wilc100: Remove pointer and integer comparision
Message-ID: <20150810174034.GA14776@gcs-HP-Compaq-nx6320> (sfid-20150810_194111_813782_CB71BF7A)
References: <1439133602-9654-1-git-send-email-csgorentla@gmail.com>
 <20150810093943.GI5180@mwanda>
 <20150810152943.GA12993@gcs-HP-Compaq-nx6320>
 <20150810155614.GK5096@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150810155614.GK5096@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 10, 2015 at 07:27:13PM +0300, Dan Carpenter wrote:
> On Mon, Aug 10, 2015 at 08:59:43PM +0530, Chandra Gorentla wrote:
> > I agree with your suggestion
> > that we need to take a broader look.  Please help in understanding
> > how does that broader look is suggesting that the patch is not
> > addressing a right problem.  The gcc version I am using is - 4.8.2.
> > 
> > In the later part of your reply - you felt that there may be a
> > case in which more than the allocated number of bytes may be
> > copied in to the memory pointed to by 'pu8CurrByte' and memory
> > may get corrupted.  From the code in the function I am not seeing
> > that happening.  In the beginning of the function, this pointer
> > variable is assigned a block of memory whose size is
> > '->u32HeadLen' + '->u32TailLen' + 16.
> > 
> > The function is copying 16 individual bytes to this memory;
> > a smaller block of memory of size '->u32HeadLen' is being copied;
> > and an another smaller block of memory of size '->u32TailLen' may
> > be copied based on a condition.  After this last copy, the
> > function increments the pointer by '->u32TailLen' irrespective
> > of last copy takes place or not.  Hence I am not seeing any
> > corruption of the memory.
> 
> It is an integer overflow.  Try the test.c file I'll include below.
> 
> > 
> > It looks like that the last increment is just an operation that
> > does no harm.  In addition to this the pointer variable
> > 'pu8CurrByte' is just a local variable and it is not being used
> > after the last increment operation of the pointer.
> 
> It's a pointer to allocated memory.  We call WILC_MALLOC().
> 
> This function allocates a buffer, then it copies memory over with the
> memcpy().  The "*pu8CurrByte++ = " statements are copying memory but
> doing endian conversion as well.  (This is not the correct way to do
> endian conversion).
> 
> > 
> > After making the change in this patch I just did a 'make'.
> > I do not have the hardware which this driver supports.  So at
> > this point of time, I cannot test your suggestions on wilc1000
> > hardware.  Is there any way I can test this driver code on a
> > old notebook computer?
> 
> Don't worry too much about testing this.  Just write small test programs
> to help you understand as much as possible.  We are good at reviewing so
> you aren't going to break the code.
> 
> #include <stdio.h>
> 
> int main(void)
> {
> 	unsigned int u32HeadLen;
> 	unsigned int u32TailLen;
> 	int s32ValueSize;
> 
> 	u32HeadLen = 1000;
> 	u32TailLen = -1U - 500 - 16 + 1;
> 	s32ValueSize = u32HeadLen + u32TailLen + 16;
> 
> 	printf("Allocating %d bytes.\n", s32ValueSize);
> 	printf("Copying %u bytes into a %d byte buffer will corrupt memory.\n",
> 		u32HeadLen, s32ValueSize);
> 
> 	return 0;
> }
> 
> regards,
> dan carpenter

If the incoming parameters '->u32HeadLen' and '->u32TailLen' are not correct,
they can cause corruption of memory.  Is it not a different problem what the
patch trying to fix?

Thanks,
chandra
