Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58453 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640AbYGWTh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 15:37:57 -0400
Date: Wed, 23 Jul 2008 16:37:52 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rfkill: add master_switch_mode functionality
Message-ID: <20080723193752.GG11009@khazad-dum.debian.net> (sfid-20080723_213800_220330_CDE3396E)
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <1216775046-9506-4-git-send-email-hmh@hmh.eng.br> <200807232039.39602.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807232039.39602.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 23 Jul 2008, Ivo van Doorn wrote:
> > +enum rfkill_input_master_mode {
> > +	RFKILL_INPUT_MASTER_DONOTHING = 0,
> > +	RFKILL_INPUT_MASTER_RESTORE = 1,
> > +	RFKILL_INPUT_MASTER_UNBLOCKALL = 2,
> 
> RFKILL_INPUT_MASTER_LAST, /* Internal */
> 
> See below for reason. :)

[...]

> >  static int __init rfkill_handler_init(void)
> >  {
> > +	switch (rfkill_master_switch_mode) {
> > +	case RFKILL_INPUT_MASTER_DONOTHING:
> > +	case RFKILL_INPUT_MASTER_RESTORE:
> > +	case RFKILL_INPUT_MASTER_UNBLOCKALL:
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> 
> if (rfkill_master_switch_mode >= RFKILL_INPUT_MASTER_LAST)
> 	return -EINVAL

It will generate the same code :-)  I can certainly do it that way, but if I
do, every switch() statement will HAVE to handle either default or
RFKILL_INPUT_MASTER_LAST...  which is bad, as you don't get the warning that
you forgot to handle something in other code paths that don't need default:
handling.

That reminds me that I should kill the default: clause in
rfkill_schedule_evsw_rfkillall().  It is there because an earlier version of
the patch would let userspace modify the module paramenter.  That didn't
play out well (if we want to do that, we should do it in some other way),
and I forgot to remove the default handling when I made the attribute
read-only.

> This will make sure new entries in the enum are automatically handled.
> Note that your next patch doesn't update the above switch statement,

My next patch doesn't deal with RFKILL_INPUT_MASTER_* :-) I guess you
misread.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
