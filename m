Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57888 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab0GVTPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 15:15:16 -0400
Date: Thu, 22 Jul 2010 15:03:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH] zd1211rw: make CR_INTERRUPT cast explicit
Message-ID: <20100722190339.GD2616@tuxdriver.com>
References: <1279724935-16581-1-git-send-email-linville@tuxdriver.com>
 <1279730218.9003.7.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1279730218.9003.7.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 12:36:58PM -0400, Pavel Roskin wrote:
> On Wed, 2010-07-21 at 11:08 -0400, John W. Linville wrote:
> > CHECK   drivers/net/wireless/zd1211rw/zd_usb.c
> > drivers/net/wireless/zd1211rw/zd_usb.c:376:24: warning: implicit cast from nocast type
> > 
> > The value comparison is intentional, so forcing the cast seems warranted
> > in order to silence the sparse warning.
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> >  drivers/net/wireless/zd1211rw/zd_usb.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
> > index 818e148..acbf4d9 100644
> > --- a/drivers/net/wireless/zd1211rw/zd_usb.c
> > +++ b/drivers/net/wireless/zd1211rw/zd_usb.c
> > @@ -373,7 +373,7 @@ static inline void handle_regs_int(struct urb *urb)
> >  	spin_lock(&intr->lock);
> >  
> >  	int_num = le16_to_cpu(*(__le16 *)(urb->transfer_buffer+2));
> > -	if (int_num == CR_INTERRUPT) {
> > +	if (int_num == (u16 __force) CR_INTERRUPT) {
> 
> I think __force should be used sparingly, especially outside headers.  I
> tried other ways to prevent the warning.  I tried declaring int_num as
> zd_addr_t, but sparse keeps complaining about the same comparison.

Actually, it looks like it works w/o the "__force" as well.
Any objection to a version like that?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
