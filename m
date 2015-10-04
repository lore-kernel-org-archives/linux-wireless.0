Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbbJDKTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 06:19:22 -0400
Date: Sun, 4 Oct 2015 11:19:18 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Chandra Gorentla <csgorentla@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org,
	dan.carpenter@oracle.com
Subject: Re: [PATCH 1/2] drivers: staging: wilc1000: Move spin lock to the
 start of critical section
Message-ID: <20151004101918.GA13898@kroah.com> (sfid-20151004_122015_712782_ABDB986D)
References: <1443864450-18167-1-git-send-email-csgorentla@gmail.com>
 <20151004084335.GA24589@kroah.com>
 <20151004100713.GA27051@gcs-HP-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151004100713.GA27051@gcs-HP-Notebook>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 04, 2015 at 03:37:13PM +0530, Chandra Gorentla wrote:
> On Sun, Oct 04, 2015 at 09:43:35AM +0100, Greg KH wrote:
> > On Sat, Oct 03, 2015 at 02:57:29PM +0530, Chandra S Gorentla wrote:
> > > The spin_lock_irqsave is moved to just beginning of critical section.
> > > This change moves a couple of return statements out of the lock.
> > > 
> > > Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
> > > ---
> > >  drivers/staging/wilc1000/wilc_msgqueue.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> > > index d5ebd6d..284a3f5 100644
> > > --- a/drivers/staging/wilc1000/wilc_msgqueue.c
> > > +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> > > @@ -72,8 +72,6 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
> > >  		goto ERRORHANDLER;
> > >  	}
> > >  
> > > -	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
> > > -
> > >  	/* construct a new message */
> > >  	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
> > 
> > As you have moved the lock, can you also change this to GFP_KERNEL as
> > well because we do not have a lock held?
> Can 'the change to GFP_KERNEL' be done in a separate patch?

Yes.

> The lock is to protect linked list manipulations; in this function items
> are added to the list.

Ok, please add that description to the patch so we know what is going
on, and that you know what is going on as well :)

thanks,

greg k-h
