Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33117 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab2JCNPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 09:15:38 -0400
Date: Wed, 3 Oct 2012 09:08:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [RFC] rt2x00: check return from dma_map_single
Message-ID: <20121003130803.GA2030@tuxdriver.com> (sfid-20121003_151543_046315_9408DFFA)
References: <1349202079-14115-1-git-send-email-linville@tuxdriver.com>
 <CAOZOX0URb51i=6wko1MJVsi7du2kyYo9W=LLZSpH7Svh9BgAMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOZOX0URb51i=6wko1MJVsi7du2kyYo9W=LLZSpH7Svh9BgAMw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 03, 2012 at 11:33:25AM +0200, Ivo Van Doorn wrote:
> Hi,
> 
> On Tue, Oct 2, 2012 at 8:21 PM, John W. Linville <linville@tuxdriver.com> wrote:
> > From: "John W. Linville" <linville@tuxdriver.com>
> >
> > dma_map_single can fail, so it's return value needs to be checked and
> > handled accordingly.  Failure to do so is akin to failing to check the
> > return from a kmalloc.
> >
> > http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis
> >
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> > ---
> > Compile tested only...can the experts take a look at how the failures
> > are handled?
> 
> <snip>
> 
> > diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> > index 0751b35..50ff18d 100644
> > --- a/drivers/net/wireless/rt2x00/rt2x00.h
> > +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> > @@ -605,8 +605,8 @@ struct rt2x00lib_ops {
> >                                struct txentry_desc *txdesc);
> >         void (*write_tx_data) (struct queue_entry *entry,
> >                                struct txentry_desc *txdesc);
> > -       void (*write_beacon) (struct queue_entry *entry,
> > -                             struct txentry_desc *txdesc);
> > +       int (*write_beacon) (struct queue_entry *entry,
> > +                            struct txentry_desc *txdesc);
> >         void (*clear_beacon) (struct queue_entry *entry);
> >         int (*get_tx_data_len) (struct queue_entry *entry);
> 
> The only thing I am missing in the commit, is the check for
> the return value when write_beacon is being called.

D'oh!!  I got in a hurry...that's a lot of trouble to add a return
value just to not check it! :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
