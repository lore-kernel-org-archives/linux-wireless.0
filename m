Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47562 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493AbYG0N5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 09:57:41 -0400
Date: Sun, 27 Jul 2008 10:57:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
	linux-wireless@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] RFKILL: set the status of the leds on activation.
Message-ID: <20080727135735.GA18652@khazad-dum.debian.net> (sfid-20080727_155745_224712_42DF1353)
References: <20080722102159.GA32682@doriath.ww600.siemens.net> <200807221911.35975.IvDoorn@gmail.com> <20080727073725.GA20755@doriath.ww600.siemens.net> <200807271003.31610.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807271003.31610.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 27 Jul 2008, Ivo van Doorn wrote:
> On Sunday 27 July 2008, Dmitry Baryshkov wrote:
> > On Tue, Jul 22, 2008 at 07:11:35PM +0200, Ivo van Doorn wrote:
> > > On Tuesday 22 July 2008, Dmitry Baryshkov wrote:
> > > > Provide default activate function to set the state of the led
> > > > when the led becomes bound to the trigger
> > > > 
> > > > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > > > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> > > > Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > > 
> > > Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> > 
> > Sorry to bother you, but can I expect these patches to be merged
> > before 2.6.27, or should I wait for 2.6.28 window?
> 
> Well they are not really bugfixes, but I'll let John decide to which tree
> they should be merged.

FWIW, I consider them to be both the kind of small thing that should go in
for 2.6.27.  It considerably enhances the LED usability of rfkill.

And I think patch 2/2 qualifies as a bug fix.  I believe it makes sense even
without 1/2?

BTW, Dmitry, since you seem to use rfkill LED, could I convince you to try
your hand at moving all the LED functionality from the current "hooks inside
the code paths" we use in rfkill.c to a "rfkill notify handler-based"
approach?  The could should get cleaner and maybe even lose some LOC with
that refactoring...  Maybe it can even go into a separate module.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
