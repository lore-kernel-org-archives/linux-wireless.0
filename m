Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39819 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYIXQIH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 12:08:07 -0400
From: Helmut Schaa <hschaa@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC v2] basic background scan
Date: Wed, 24 Sep 2008 18:07:58 +0200
Cc: linux-wireless@vger.kernel.org
References: <200809241636.38762.hschaa@suse.de> <200809241755.15950.hschaa@suse.de> <1222271941.4257.40.camel@johannes.berg>
In-Reply-To: <1222271941.4257.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809241807.58687.hschaa@suse.de> (sfid-20080924_180811_422037_BEB7F34D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 24. September 2008 17:59:01 schrieb Johannes Berg:
> On Wed, 2008-09-24 at 17:55 +0200, Helmut Schaa wrote:
> 
> > > What I meant to say is that it'll give problems with drivers that don't
> > > do status reporting properly, and what are you going to do when one of
> > > them fails anyway? retry it? how long? assume the connection was lost if
> > > it isn't acked? I see little point in it to start with.
> > 
> > The main reason why I'd like to know when the frame was acked is that it might 
> > happen (and it did happen in my tests already) that the frame notifying the 
> > AP about entering power save state wasn't send before switching to another 
> > channel. Hence the AP won't buffer any frames for us.
> 
> We should make these frames able to "skip the queue" so to speak, that
> would be smarter either way.

Agreed. That would at least enhance the probability that the frame is sent
out fast enough.

> > > > > > +				netif_tx_wake_all_queues(sdata->dev);
> > > > >
> > > > > This is worsening a problem we already have -- you can enable queues
> > > > > that the driver asked to be disabled. Until we fix that, I don't think
> > > > > we should tempt our luck even more.
> > > >
> > > > I see! That's really problematic.
> > > > Do you have already an idea on how to fix it?
> > >
> > > Not really; introduce bits somewhere to keep track of who wants to
> > > enable/disable queues I guess.
> > 
> > A first trivial solution would be to just store which queues are active
> > when the scan is started and restarting only these queues after the scan
> > completed.
> 
> Actually, well, you have to deal with drivers like adm8211 that
> stop/start the queues for each packet...

Oops. I did not know about drivers behaving like that
=> have to find a better way to deal with starting/stopping queues.

Thanks,
Helmut
