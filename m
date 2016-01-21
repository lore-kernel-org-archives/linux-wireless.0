Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27372 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbcAUIz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 03:55:29 -0500
Date: Thu, 21 Jan 2016 11:55:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Chaehyun Lim <chaehyun.lim@gmail.com>, devel@driverdev.osuosl.org,
	chris.park@atmel.com, austin.shin@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 25/27] staging: wilc1000: fix coding style of kmalloc
 usage
Message-ID: <20160121085508.GD6370@mwanda> (sfid-20160121_095532_554481_71AE4DB1)
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
 <1453339230-1377-25-git-send-email-chaehyun.lim@gmail.com>
 <20160121081816.GA10063@sudip-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160121081816.GA10063@sudip-pc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2016 at 01:48:16PM +0530, Sudip Mukherjee wrote:
> On Thu, Jan 21, 2016 at 10:20:28AM +0900, Chaehyun Lim wrote:
> > This patch fixes coding style of kmalloc usage found by checkpatch.
> > CHECK: Prefer kmalloc(sizeof(*new_msg)...) over kmalloc(sizeof(struct message)...)
> > 
> > Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> > ---
> >  drivers/staging/wilc1000/wilc_msgqueue.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> > index 7107715..c7a60f4 100644
> > --- a/drivers/staging/wilc1000/wilc_msgqueue.c
> > +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> > @@ -70,7 +70,7 @@ int wilc_mq_send(struct message_queue *mq,
> >  	}
> >  
> >  	/* construct a new message */
> > -	new_msg = kmalloc(sizeof(struct message), GFP_ATOMIC);
> > +	new_msg = kmalloc(sizeof(*new_msg), GFP_ATOMIC);
> 
> This checkpatch error was introduced by 1/27 patch of this series. Maybe
> it will be better to fix it in that one.

The warning was introduced there but the issue went back further it's
just that checkpatch didn't detect it because of other issues.  This
seems fine.

regards,
dan carpenter

