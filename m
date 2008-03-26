Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:25995 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbYCZPko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 11:40:44 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: fix spinlock recursion bug
Date: Wed, 26 Mar 2008 16:37:45 +0100
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
References: <200803191524.21866.hs4233@mail.mn-solutions.de> <200803261541.48877.hs4233@mail.mn-solutions.de> <1206544650.31383.15.camel@localhost.localdomain>
In-Reply-To: <1206544650.31383.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803261637.45549.hs4233@mail.mn-solutions.de> (sfid-20080326_154047_235555_6D719E4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I agree the indirection in the current SDIO and USB drivers
> sucks, but I'm getting more and more convinced that the way
> that the CF driver is handling this sucks too.

I don't really can say anything about CF/SDIO driver, but for me 
several things aren't coming into picture:

a) in "struct lbs_private", we have "struct mutex lock". What 
exactly does it lock?  Above it is a comment "/* protected with 
big lock */" but it's not clear to me to what this comment 
refers. Some lines below is the same comment, so maybe this 
should be a /* this variables are protected by 'lock' */" 
and "/* end of protection by 'lock' */".

b) some lines later there is a comment "/* command related 
variables protected by priv->driver_lock */", but some 
variables, like priv->seqnum, are command-related, but in 
the "struct mutex lock" section.

c) then there is the "spinlock_t driver_lock" later. Maybe this 
is what is meant to protect command-related things.

d) my knowledge about locks is so non-existant that I currently 
don't know why one lock is a "struct mutex" and the other is 
a "spinlock_t".

e) I also don't know (yet) when to use spin_lock_irq, 
spin_lock_irqsave or a plain spin_lock. However, I hope to fill 
this knowledge gap with 
http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/

But for clarification of the other points I'd need a helping 
hand :-)  Once we know which variables should be protected by 
which lock we can go and fix this thing. It might even be the 
case that one lock is enought.
