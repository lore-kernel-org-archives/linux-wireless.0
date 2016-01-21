Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46256 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061AbcAUKFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 05:05:07 -0500
Date: Thu, 21 Jan 2016 13:04:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	devel@driverdev.osuosl.org, Chris Park <chris.park@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	"tony.cho" <tony.cho@atmel.com>, leo.kim@atmel.com
Subject: Re: [PATCH 25/27] staging: wilc1000: fix coding style of kmalloc
 usage
Message-ID: <20160121100456.GD6421@mwanda> (sfid-20160121_110513_636564_85758F94)
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
 <1453339230-1377-25-git-send-email-chaehyun.lim@gmail.com>
 <20160121081816.GA10063@sudip-pc>
 <20160121085508.GD6370@mwanda>
 <CAKV=isvj-RbzMCOS+UyXkXyuyX2_SLhDyVTNaJy4kQbfN+bxSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKV=isvj-RbzMCOS+UyXkXyuyX2_SLhDyVTNaJy4kQbfN+bxSg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2016 at 07:01:45PM +0900, Chaehyun Lim wrote:
> On Thu, Jan 21, 2016 at 5:55 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Thu, Jan 21, 2016 at 01:48:16PM +0530, Sudip Mukherjee wrote:
> >> On Thu, Jan 21, 2016 at 10:20:28AM +0900, Chaehyun Lim wrote:
> >> > This patch fixes coding style of kmalloc usage found by checkpatch.
> >> > CHECK: Prefer kmalloc(sizeof(*new_msg)...) over kmalloc(sizeof(struct message)...)
> >> >
> >> > Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> >> > ---
> >> >  drivers/staging/wilc1000/wilc_msgqueue.c | 2 +-
> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >
> >> > diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> >> > index 7107715..c7a60f4 100644
> >> > --- a/drivers/staging/wilc1000/wilc_msgqueue.c
> >> > +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> >> > @@ -70,7 +70,7 @@ int wilc_mq_send(struct message_queue *mq,
> >> >     }
> >> >
> >> >     /* construct a new message */
> >> > -   new_msg = kmalloc(sizeof(struct message), GFP_ATOMIC);
> >> > +   new_msg = kmalloc(sizeof(*new_msg), GFP_ATOMIC);
> >>
> >> This checkpatch error was introduced by 1/27 patch of this series. Maybe
> >> it will be better to fix it in that one.
> >
> > The warning was introduced there but the issue went back further it's
> > just that checkpatch didn't detect it because of other issues.  This
> > seems fine.
> 
> I appreciate for all comment. I will resend it after applying Sudip's review.
> 

That's fine too, but the original way is more correct because it only
fixes one thing at a time and is easier to review.

regards,
dan carpenter

