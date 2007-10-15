Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55666
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760065AbXJOM5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 08:57:01 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Richard Purdie <rpurdie@openedhand.com>
Subject: Re: b43 with upstream-davem stacktrace
Date: Mon, 15 Oct 2007 14:56:16 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	bcm43xx-dev@lists.berlios.de,
	Christian Hoffmann <email@christianhoffmann.info>,
	linux-wireless@vger.kernel.org
References: <200710131823.33420.email@christianhoffmann.info> <1192354978.4770.100.camel@johannes.berg> <1192439126.5684.13.camel@localhost.localdomain>
In-Reply-To: <1192439126.5684.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710151456.16459.mb@bu3sch.de> (sfid-20071015_135705_787088_6F86ECF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 October 2007 11:05:26 Richard Purdie wrote:
> On Sun, 2007-10-14 at 11:42 +0200, Johannes Berg wrote:
> > On Sat, 2007-10-13 at 17:26 +0200, Michael Buesch wrote:
> > 
> > > I also saw this sometimes, but I have absolutely no idea how that happens.
> > > Someone any idea?
> > 
> > Nope, but adding more CCs :) I briefly looked at the code and couldn't
> > track it. Got a powerpc oops with disassembly?
> 
> It appears to be having a problem in the strcmp in
> led_trigger_set_default() which is odd. Code above that checks if one of
> the options is NULL so all I can think it either the default_trigger
> string being passed in is invalid or there is a trigger with an invalid
> name registered with the system.
> 
> Is this an SMP system and would something else be registering an LED
> trigger on another processor or similar? There is locking there which
> should be sufficient though. So no, I'm not sure whats going on
> either...
> 

I think this is some kind of a race, as it does only happen rarely and
is not really reproducible.


-- 
Greetings Michael.
