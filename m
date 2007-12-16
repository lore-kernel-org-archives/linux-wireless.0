Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:42805 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbXLPU66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 15:58:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Richard Purdie <rpurdie@openedhand.com>
Subject: Re: b43 problem with led trigger registration
Date: Sun, 16 Dec 2007 21:57:00 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <1197822019.4138.2.camel@johannes.berg> <1197837505.6769.25.camel@johannes.berg> <1197837799.4653.21.camel@localhost.localdomain>
In-Reply-To: <1197837799.4653.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712162157.00759.mb@bu3sch.de> (sfid-20071216_205904_715038_DF73ABDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 16 December 2007 21:43:19 Richard Purdie wrote:
> On Sun, 2007-12-16 at 21:38 +0100, Johannes Berg wrote:
> > > > drivers/leds/led-triggers.c:led_trigger_register:
> > > > 
> > > > |        read_lock(&leds_list_lock);
> > > > |        list_for_each_entry(led_cdev, &leds_list, node) {
> > > > |                down_write(&led_cdev->trigger_lock);
> > > > 
> > > > introduced in
> > > > 
> > > > commit dc47206e552c0850ad11f7e9a1fca0a3c92f5d65
> > > > Author: Richard Purdie <rpurdie@rpsys.net>
> > > > Date:   Sat Nov 10 13:29:04 2007 +0000
> > > > 
> > > >     leds: Fix led trigger locking bugs
> > > > 
> > > > I guess the read_lock needs to be a mutex/rw semaphore.
> > > 
> > > Uh, yes. Was this patch tested at all?
> > 
> > Not with default triggers, I guess. The code in question only triggers
> > when a default is assigned to any LED I think.
> 
> Amongst other things it was tested on the Zaurus which has default
> triggers. What is the problem you're seeing?

You are scheduling (down_write) while holding a spinlock (leds_list_lock).

-- 
Greetings Michael.
