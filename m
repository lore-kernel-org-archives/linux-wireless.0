Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60359 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755834AbYGQMKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 08:10:14 -0400
Date: Thu, 17 Jul 2008 09:10:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: drago01 <drago01@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 4/4] rfkill: mutex fixes
Message-ID: <20080717121009.GE31732@khazad-dum.debian.net> (sfid-20080717_141018_586994_0DFA793A)
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br> <1216150327-10904-5-git-send-email-hmh@hmh.eng.br> <200807170656.37190.mb@bu3sch.de> <f6ca9fed0807170433m5199b66bl7e8bafd1002c566e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6ca9fed0807170433m5199b66bl7e8bafd1002c566e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 17 Jul 2008, drago01 wrote:
> On Thu, Jul 17, 2008 at 6:56 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Tuesday 15 July 2008, Henrique de Moraes Holschuh wrote:
> >> There are two mutexes in rfkill:
> >>
> >> rfkill->mutex, which protects some of the fields of a rfkill struct, and is
> >> also used for callback serialization.
> >>
> >> rfkill_mutex, which protects the global state, the list of registered
> >> rfkill structs and rfkill->claim.
> >>
> >> Make sure to use the correct mutex, and to not miss locking rfkill->mutex
> >> even when we already took rfkill_mutex.
> 
> rfkill_state_mutex ?

rfkill_mutex protects a lot of stuff, and does general serialization inside
rfkill.c.  rfkill_global_mutex is a good name for it, yes.

rfkill->mutex protects more than the state, better leave that one alone.  If
I find a way to do it without LONG periods under spinlock_irqsave, I'd make
it a spinlock to let drivers call some stuff in interrupt/atomic context...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
