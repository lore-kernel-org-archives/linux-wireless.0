Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50518 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753687AbYFEMit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 08:38:49 -0400
Date: Thu, 5 Jun 2008 09:38:45 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
Message-ID: <20080605123845.GA3413@khazad-dum.debian.net> (sfid-20080605_143852_387736_4A84FDB1)
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br> <1212549017-30144-2-git-send-email-hmh@hmh.eng.br> <1212611246.4018.12.camel@localhost.localdomain> <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com> <20080605003808.GA16599@khazad-dum.debian.net> <1ba2fa240806050133sd8ee9e2u2773a1bf1cce9bcb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240806050133sd8ee9e2u2773a1bf1cce9bcb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 05 Jun 2008, Tomas Winkler wrote:
> >> Third I think this patch use opposite logic as used currently in
> >> practice. RFKILL_ON means that radio is off .

This is how the code works: RFKILL_STATE_ON does not block the radio.
RFKILL_STATE_OFF blocks the radio.  I documented the *reality* of that
code so that people would know for sure from now on.  And no, I don't
exactly *like* it either.

So, yes, "rfkill.h" and net/rfkill* uses negative logic if you pay
attention to the "kill" in the name and also to the ON/OFF in the state
names, and that is confusing.

What we can do is change the names of those states, since those are just
kernel API and documentation (we cannot change their numerical values,
that is ABI exposed to userspace over sysfs).

But for obvious code maintenance reasons, which I am sure you know
about, we cannot just switch the names around.  The new names have to be
different from the old ones (for the compiler to catch old usage), and
different *enough* from the old ones to not cause confusion on humans
(or the new usage will be misused).

> > The correct reading of rfkill class states are:
> >
> > RFKILL_STATE_ON:  transmitter is UNBLOCKED and *may* operate
> > RFKILL_STATE_OFF: transmitter is BLOCKED and will *NOT* operate.
> > Nothing else is correct.

[snip]

> This is opposite logic as used in industry and you are creating mess
> here. RFKILL_ON means that you killed the radio and it moves
> radio to disable state.

No, I am not *creating* any mess.  I am documenting whatever we already
have, and while I don't like it, I don't think it is bad enough (after
documentation) to qualify as a mess.

> If you want to use your logic the remove the world KILL form it.
> RF_ON, RF_OFF would match your intention.

RFKILL_STATE is in there as a namespace prefix.  The new state names I
proposed are "BLOCKED" and "UNBLOCKED", which I hope are of quite clear
meaning.  If you feel their meaning is not clear, which names would you
propose?

As for the RFKILL_STATE_ part of the name, I consider bad practice not
to have the namespace prefix, but I don't feel too strongly about it
either (still, I won't be the one proposing a change removing a
namespace prefix).  If you want something different, send a patch
(please base it on a tree with this patch set applied, and update the
documentation).  If Ivo ACKS it, it is in.  Certainly, lots of kernel
defines and enums that are specific to some subsystem or to some set of
functions lack any such prefixes in mainline.

Or you could ask Ivo about renaming rfkill, and submit patches to that
effect.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
