Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:46453 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbXLPVOW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 16:14:22 -0500
Subject: Re: b43 problem with led trigger registration
From: Richard Purdie <rpurdie@openedhand.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1197837505.6769.25.camel@johannes.berg>
References: <1197822019.4138.2.camel@johannes.berg>
	 <200712162036.11084.mb@bu3sch.de> <1197835176.6769.21.camel@johannes.berg>
	 <200712162126.56483.mb@bu3sch.de>  <1197837505.6769.25.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 20:43:19 +0000
Message-Id: <1197837799.4653.21.camel@localhost.localdomain> (sfid-20071216_211425_811357_40698AA3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-12-16 at 21:38 +0100, Johannes Berg wrote:
> > > drivers/leds/led-triggers.c:led_trigger_register:
> > > 
> > > |        read_lock(&leds_list_lock);
> > > |        list_for_each_entry(led_cdev, &leds_list, node) {
> > > |                down_write(&led_cdev->trigger_lock);
> > > 
> > > introduced in
> > > 
> > > commit dc47206e552c0850ad11f7e9a1fca0a3c92f5d65
> > > Author: Richard Purdie <rpurdie@rpsys.net>
> > > Date:   Sat Nov 10 13:29:04 2007 +0000
> > > 
> > >     leds: Fix led trigger locking bugs
> > > 
> > > I guess the read_lock needs to be a mutex/rw semaphore.
> > 
> > Uh, yes. Was this patch tested at all?
> 
> Not with default triggers, I guess. The code in question only triggers
> when a default is assigned to any LED I think.

Amongst other things it was tested on the Zaurus which has default
triggers. What is the problem you're seeing?

Richard


