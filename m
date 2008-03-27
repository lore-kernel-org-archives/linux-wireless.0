Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbYC0Ocz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 10:32:55 -0400
Subject: Re: [PATCH] libertas: fix spinlock recursion bug
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200803271257.26820.hs4233@mail.mn-solutions.de>
References: <200803191524.21866.hs4233@mail.mn-solutions.de>
	 <200803271108.23635.hs4233@mail.mn-solutions.de>
	 <1206617646.6368.31.camel@localhost.localdomain>
	 <200803271257.26820.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 10:31:54 -0400
Message-Id: <1206628314.23336.11.camel@localhost.localdomain> (sfid-20080327_143302_029096_C78E9E7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-03-27 at 12:57 +0100, Holger Schurig wrote:
> > The problem with using upld_buf (and therefore zero-copy in
> > the CF driver) is that you have no idea how long a read from
> > the card will really take, and what errors might happen during
> > the read from the card.
> 
> Yes, this can take a long time. And, BTW, I don't want to use 
> upld_buf.
> 
> 
> My idea is this:
> 
> > > struct lbs_event *lbs_get_free_event(struct lbs_private
> > > *priv);
> 
> This will take out an lbs_event from the event_free_list and 
> return it.
> Taking out has to be done under spinlock, but this is very fast.
> 
> Once the lbs_event is no longer in any of the two event list, 
> we "own" it and can handle it as long as we want, without the 
> need of an additional spinlock.
> 
> Then
> 
> > > void lbs_handle_event(struct lbs_private *priv, struct
> > > lbs_event *event);
> 
> would again take the spinlock, insert the event in the 
> event_list, and release the spinlock. Which again takes only a 
> short time.

well, if this is being done in lbs_thread() then the call from
lbs_get_free_event() is going to be right above lbs_handle_event()
anyway, so you might as well hold the spinlock over both, right?  I'm
just basing that assumption off the existing structure of lbs_thread(),
maybe you've re-ordered it a lot or something.

But it sounds OK.

Dan

> This approach can make receiption of command responses from card 
> zero-copy like, at least insofar the event processing is 
> considered. 
> 
> 
> 
> > I'd argue that the CF driver should also have an internal
> > buffer like the SDIO and USB drivers do, and then there's still
> > only one copy.
> 
> Yeah, but I can reduce easily to a 0-copy-scheme.
> 
> 
> I hope all of this sounds sane.
> 

