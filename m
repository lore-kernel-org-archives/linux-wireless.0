Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39659 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509AbZEMVkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 17:40:07 -0400
Date: Wed, 13 May 2009 18:40:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, Will Keaney <keaneyw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT v9] rfkill: rewrite
Message-ID: <20090513214004.GE26299@khazad-dum.debian.net>
References: <1242030669.6930.10.camel@johannes.local> <4A09B130.9000106@gmail.com> <1242151180.3203.19.camel@localhost.localdomain> <1242151479.11924.4.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242151479.11924.4.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 12 May 2009, Johannes Berg wrote:
> On Tue, 2009-05-12 at 13:59 -0400, Dan Williams wrote:
> > > Please leave rfkill-input available as a module, at least until the bug
> > > I reported in my previous e-mail 'Soft Lockup With rfkill_input and
> > > thinkpad_acpi' is resolved.  Otherwise it will render Thinkpads, and
> > > possibly other systems, unusable with rfkill enabled.
> > 
> > The problem gets fixed where the problem is at...  if the actual root
> > cause is in the rfkill rewrite, then maybe Johannes should take a look.
> 
> We don't even know yet whether the bug is present after the rewrite!
> 
> > If the actual root cause is a bug in thinkpad-acpi, then it shouldn't
> > block the rfkill rewrite, but should be fixed in thinkpad-acpi.
> 
> Unfortunately thinkpad-acpi hasn't been ported yet in my rewrite, so we
> can't know. I've poked hmh, but if he doesn't respond soon I'll do a
> crude port and ask Will to test it.

Hmm, I did get your email, but I am overworked and nearing a burn out due
to real-life issues, so I didn't answer right away.  I will see if I can
get something usable by Sunday (I usually get some opportunity to unwind
and work on the kernel during the weekend), but I will not complain if you
come up with something quick-and-dirty should I fail to deliver.

As for the issue Dan reported, I have _no_ _idea_ of what it might be
causing it, and a bissect would help wonders.  It will have to be fixed
anyway (even if it is also fixed by the rfkill rewrite) if it is hosing
2.6.30 :-(

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
