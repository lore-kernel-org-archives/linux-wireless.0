Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39978 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758811AbYFEAiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 20:38:13 -0400
Date: Wed, 4 Jun 2008 21:38:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
Message-ID: <20080605003808.GA16599@khazad-dum.debian.net> (sfid-20080605_023817_582914_1BC4D1F7)
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br> <1212549017-30144-2-git-send-email-hmh@hmh.eng.br> <1212611246.4018.12.camel@localhost.localdomain> <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 05 Jun 2008, Tomas Winkler wrote:
> SW should be able to more sw radio switch regardless of hw switch so

Be extremely careful with "should" and any ideas you might have of the
capabilities of rf switch hardware, because chances are firmware-based
switches will frustate you.   In fact, you're wrong.  Some firmware
softswitches don't let you change their status when there is also a
hardware switch present, and that hardware switch is in the "block
transmissions" state.

> I believe it's better to have separate sysfs entry for sw and hw switch states.
> hw sysfs file should be read only.

When you do this (have more than one rfkill class for the same device),
the kernel events and uevents are not able to propagate the real state
of the device anymore:  upon the recepit of any event, you need to
*locate* all rfkill switches attached to that device, query them all,
and only if all of them are in state RFKILL_STATE_ON, will the device be
in RFKILL_STATE_ON.

So, we'd need to change the rfkill class to avoid all that hassle (see
more on this below).

Sincerely, I heavly prefer to add a third state (RFKILL_STATE_HARDOFF or
something like that).  That is a safe path that will have no subtle
interactions with the way rfkill is meant to be used.  I am not so sure
the other possibilities have this advantage, even if I cannot pinpoint
what interactions they could cause right now.

> I agree it good to keep radio state separately as well.

I don't like this either, unless by "separate" you mean outside of
rfkill entirely.

What you seem to be calling "radio state" is the effective state of a
device with more than one kill line (be it software or hardware).  We
could call that "device rfkill state" instead of "switch rfkill state"
to avoid confusion, I suppose.

Anyway, if we are to use various *related* rfkill switches per device,
rfkill needs further changes, including an extra callback into the
driver, so as to be able to export the device rfkill state also in all
switch rfkill state events (otherwise these events become quite useless
for many uses).

It is more complicated and heavyweight a solution for very little gain
when compared to the addition of a third RFKILL_STATE state, IMO.
Remeber that multiple related switches per device adds complexity to the
INTERFACE, and therefore to all applications that use that interface.

> Third I think this patch use opposite logic as used currently in
> practice. RFKILL_ON means that radio is off .

The correct reading of rfkill class states are:

RFKILL_STATE_ON:  transmitter is UNBLOCKED and *may* operate
RFKILL_STATE_OFF: transmitter is BLOCKED and will *NOT* operate.

Nothing else is correct.

We could certainly rename these states to

enum rfkill_state {
	RFKILL_STATE_BLOCKED = 0,
	RFKILL_STATE_UNBLOCKED = 1,
};

#define RFKILL_STATE_ON RFKILL_STATE_UNBLOCKED
#define RFKILL_STATE_OFF RFKILL_STATE_BLOCKED

Ivo, do you want a patch that does the above (plus the documentation
changes, of course)?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
