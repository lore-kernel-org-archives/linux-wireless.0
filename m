Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37047 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753318AbYHATgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 15:36:04 -0400
Date: Fri, 1 Aug 2008 16:35:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [GIT PATCH] RFC: next batch of rfkill changes
Message-ID: <20080801193557.GG14352@khazad-dum.debian.net> (sfid-20080801_213609_379737_EE6B3E07)
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <20080801181135.GC14974@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080801181135.GC14974@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 01 Aug 2008, John W. Linville wrote:
> On Tue, Jul 22, 2008 at 10:04:00PM -0300, Henrique de Moraes Holschuh wrote:
> > This is my next batch of rfkill changes.  They add features and address
> > some shortcomings of rfkill-input, mostly.
> > 
> > Please comment.  One thing that is bothering me in the last patch is
> > what happens during suspend/resume to pending delayed rfkill state
> > changes.  Are pending scheduled jobs executed, cancelled, or frozen to
> > fire up when the system resumes itself?
> > 
> > Henrique de Moraes Holschuh (6):
> >       rfkill: detect bogus double-registering
> >       rfkill: add default global states
> >       rfkill: add master_switch_mode functionality
> >       rfkill: add EPO lock to rfkill-input
> >       rfkill: rename rfkill_mutex to rfkill_global_mutex
> >       rfkill: rate-limit rfkill-input workqueue usage
> 
> FYI...because you included RFC in the subject I won't be merging
> these until I hear otherwise from you.

That's fine, they are not for merging yet :-)  I have modified some of them
a lot, added others, and have not found a good way to do the last one
(rate-limiting) properly yet. I will post another "RFC" batch sooner or
later, probably during the weekend.

This is all 2.6.28 material anyway, so there is no hurry to merge early on
wireless-testing, it is best to merge right.  If I find anything that looks
like a somewhat urgent fix, I will post it separately for merging in 2.6.27.

When some of them patch are finally good for merging, I will send a stack
just with those and ask for a merge explicitly.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
