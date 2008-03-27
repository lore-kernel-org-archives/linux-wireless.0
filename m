Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbYC0LfF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 07:35:05 -0400
Subject: Re: [PATCH] libertas: fix spinlock recursion bug
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200803271108.23635.hs4233@mail.mn-solutions.de>
References: <200803191524.21866.hs4233@mail.mn-solutions.de>
	 <200803261637.45549.hs4233@mail.mn-solutions.de>
	 <1206552791.31383.99.camel@localhost.localdomain>
	 <200803271108.23635.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 07:34:06 -0400
Message-Id: <1206617646.6368.31.camel@localhost.localdomain> (sfid-20080327_113511_417257_36C94441)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-03-27 at 11:08 +0100, Holger Schurig wrote:
> > struct lbs_event {
> 
> add "struct list_head list;"
> 
> > 	u32 event;  /* MACREG_INT_CODE_xxxxx */
> > 	u32 len;
> > 	u8 buf[LBS_UPLD_SIZE];
> > };
> 
> Hmm, buf is LBS_UPLD_SIZE (2312 bytes). However, if_cs.c, 
> if_sdio.c and if_usb.c use LBS_CMD_BUFFER_SIZE, which is 2048.
> 
> 
> > void lbs_interrupt(struct lbs_private *priv, u32 event, u8
> > *resp_data, u32 resp_len) {
> 
> With this approach, the driver would have copy the date from the 
> hardware into local buffer. Then it would call lbs_interrupt() 
> with a pointer to this local buffer. Then lbs_interrupt() would 
> memcpy() this. Then something in main.c and/or cmd.c would again 
> memcpy() this.

The USB and SDIO driver have skbs that they currently just memcpy to
priv->upld_buf, in this case lbs_interrupt() would take over that
responsibility, so you'd still have the same # of copies: 1.

It looks like the CF driver uses priv->upld_buf directly, which it can
do because it's holding the spinlock, because it's trying to do so much
work from hw_get_int_status(), which is something it shouldn't be doing.
I'd argue that the CF driver should also have an internal buffer like
the SDIO and USB drivers do, and then there's still only one copy.  

The problem with using upld_buf (and therefore zero-copy in the CF
driver) is that you have no idea how long a read from the card will
really take, and what errors might happen during the read from the card.
And you're holding the spinlock with interrupts disabled while you're
doing that.  That read from the card is going to take a lot more time
than a simple memcpy in lbs_interrupt(), and you want to minimize the
time you're holding the spinlock anyway.  That's the reason the CF
driver has this problem in the first place, because it's trying to do
too much under the spinlock.

Dan

> Let's split lbs_interrupt() into two functions:
> 
> struct lbs_event *lbs_get_free_event(struct lbs_private *priv);
> 
> void lbs_handle_event(struct lbs_private *priv, struct lbs_event 
> *event);
> 
> Then the hardware driver can do:
> 
>   struct lbs_event *event = lbs_get_free_event(priv);
>   if (!event)
>      ...
>   if_cs_receive_cmdres(priv, &event->buf, &event->len);
>   lbs_handle_event(priv, event);

