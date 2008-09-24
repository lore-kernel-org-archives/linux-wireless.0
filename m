Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:38740 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbYIXPzU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 11:55:20 -0400
From: Helmut Schaa <hschaa@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC v2] basic background scan
Date: Wed, 24 Sep 2008 17:55:15 +0200
Cc: linux-wireless@vger.kernel.org
References: <200809241636.38762.hschaa@suse.de> <200809241719.28983.hschaa@suse.de> <1222270421.4257.37.camel@johannes.berg>
In-Reply-To: <1222270421.4257.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809241755.15950.hschaa@suse.de> (sfid-20080924_175523_975943_1786D2B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 24. September 2008 17:33:41 schrieb Johannes Berg:
> On Wed, 2008-09-24 at 17:19 +0200, Helmut Schaa wrote:
> > Am Mittwoch, 24. September 2008 16:46:18 schrieb Johannes Berg:
> > > On Wed, 2008-09-24 at 16:36 +0200, Helmut Schaa wrote:
> > > > Could somebody please have a look at the TODO comments (I have no
> > > > idea how to wait until all null-func frames are ACKed)? Thanks.
> > >
> > > It's not really possible.
> > >
> > :(
>
> What I meant to say is that it'll give problems with drivers that don't
> do status reporting properly, and what are you going to do when one of
> them fails anyway? retry it? how long? assume the connection was lost if
> it isn't acked? I see little point in it to start with.

The main reason why I'd like to know when the frame was acked is that it might 
happen (and it did happen in my tests already) that the frame notifying the 
AP about entering power save state wasn't send before switching to another 
channel. Hence the AP won't buffer any frames for us.

> > > > +				netif_tx_wake_all_queues(sdata->dev);
> > >
> > > This is worsening a problem we already have -- you can enable queues
> > > that the driver asked to be disabled. Until we fix that, I don't think
> > > we should tempt our luck even more.
> >
> > I see! That's really problematic.
> > Do you have already an idea on how to fix it?
>
> Not really; introduce bits somewhere to keep track of who wants to
> enable/disable queues I guess.

A first trivial solution would be to just store which queues are active
when the scan is started and restarting only these queues after the scan
completed.

> > > And why is sw_scanning false if bg_scanning is true anyway?
> >
> > During a background scan the sw_scanning flag is set when a scan phase is
> > active and unset when an operation phase is active. Therefore I did not
> > need to adapt all checks for sw_scanning.
>
> Oh, hmm, ok, that might make the enum problematic. Or do something like
>
> SCAN_OFF,
> SCAN_BG,
> SCAN_SW,
> SCAN_HW
>
> then you can check for scan >= SCAN_SW

Maybe. Thinking about it.

Helmut
