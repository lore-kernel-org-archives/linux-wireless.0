Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:32838 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbXBSNwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 08:52:18 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HJ8uq-0007V2-Ai
	for linux-wireless@vger.kernel.org; Mon, 19 Feb 2007 08:50:52 -0500
Subject: Re: [PATCH] rt2x00: fix memory corruption caused by eeprom buffer  overflow
From: Pavel Roskin <proski@gnu.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <a32f33a40702190307x2861b654s6233a6b9858e8233@mail.gmail.com>
References: <20070219024654.3480.9392.stgit@dl.roinet.com>
	 <a32f33a40702190307x2861b654s6233a6b9858e8233@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 08:51:39 -0500
Message-Id: <1171893099.8550.23.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-02-19 at 12:07 +0100, Ivo Van Doorn wrote:
> hi
> 
> > diff --git a/drivers/net/wireless/d80211/rt2x00/rt73usb.c b/drivers/net/wireless/d80211/rt2x00/rt73usb.c
> > index be66e2f..6fa5a7e 100644
> > --- a/drivers/net/wireless/d80211/rt2x00/rt73usb.c
> > +++ b/drivers/net/wireless/d80211/rt2x00/rt73usb.c
> > @@ -2705,7 +2705,7 @@ static int rt73usb_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
> >          * Allocate the eeprom memory, check the eeprom width
> >          * and copy the entire eeprom into this allocated memory.
> >          */
> > -       rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
> > +       rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL * sizeof(u16));
> >         if (!rt2x00dev->eeprom)
> >                 return -ENOMEM;
> 
> you might want to change this to EEPROM_SIZE * sizeof(u16). ;)

Shame on me.  I wrote a patch that worked on rt61, and then I discarded
it to make a "clean" fix for all drivers.

But anyway, I'm seeing now that CVS on sourceforge.net is not abandoned,
so I think the best approach would be to integrate it into the kernel.
It would be great if you remove dead code from CVS, all those
"experimental" branches that haven't been touched for months if not
years.  It was hard for me to find the actual sources.  I would have
spent last Sunday evening doing something more interesting than fixing
fixed bugs :)

Finally, I'll appreciate if the driver is fixed to compile against
wireless-dev kernels.  You can take an approach similar to iwlwifi and
even rely on the same d80211 package.

-- 
Regards,
Pavel Roskin

