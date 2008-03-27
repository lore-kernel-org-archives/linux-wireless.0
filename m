Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:8060 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbYC0MAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 08:00:33 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: fix spinlock recursion bug
Date: Thu, 27 Mar 2008 12:57:26 +0100
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
References: <200803191524.21866.hs4233@mail.mn-solutions.de> <200803271108.23635.hs4233@mail.mn-solutions.de> <1206617646.6368.31.camel@localhost.localdomain>
In-Reply-To: <1206617646.6368.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803271257.26820.hs4233@mail.mn-solutions.de> (sfid-20080327_120049_283444_2D6B1AD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The problem with using upld_buf (and therefore zero-copy in
> the CF driver) is that you have no idea how long a read from
> the card will really take, and what errors might happen during
> the read from the card.

Yes, this can take a long time. And, BTW, I don't want to use 
upld_buf.


My idea is this:

> > struct lbs_event *lbs_get_free_event(struct lbs_private
> > *priv);

This will take out an lbs_event from the event_free_list and 
return it.
Taking out has to be done under spinlock, but this is very fast.

Once the lbs_event is no longer in any of the two event list, 
we "own" it and can handle it as long as we want, without the 
need of an additional spinlock.

Then

> > void lbs_handle_event(struct lbs_private *priv, struct
> > lbs_event *event);

would again take the spinlock, insert the event in the 
event_list, and release the spinlock. Which again takes only a 
short time.

This approach can make receiption of command responses from card 
zero-copy like, at least insofar the event processing is 
considered. 



> I'd argue that the CF driver should also have an internal
> buffer like the SDIO and USB drivers do, and then there's still
> only one copy.

Yeah, but I can reduce easily to a 0-copy-scheme.


I hope all of this sounds sane.

