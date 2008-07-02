Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58631 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987AbYGBTcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 15:32:07 -0400
Date: Wed, 2 Jul 2008 16:32:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: Question on rfkill double block
Message-ID: <20080702193202.GA20410@khazad-dum.debian.net> (sfid-20080702_213214_974667_589F9E41)
References: <1214982208.14590.473.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214982208.14590.473.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 02 Jul 2008, Zhu Yi wrote:
> It doesn't say what to do if both the hardware and software rfkill lines
> are active when RFKILL_STATE_UNBLOCKED is asked. Should we deactivate
> the software rfkill in this case? Otherwise below usage won't turn on
> the radio:

Well, we allow double-blocking to make sure the radio isn't unblocked by
mistake.  The bias in rfkill is to block, as that is safer.

The issue is that if we get a RFKILL_STATE_UNBLOCKED request, and we are at
RFKILL_STATE_HARD_BLOCKED, we need to return an error (we can't set the
requested state).  But since we returned an error, should we do the best we
can, or should we do nothing?

I am really not sure what would be better: to remove the double-blocking
while still returning an error, or to leave the radio as is (be it
double-blocked or just blocked by the hardware rfkill line) and return an
error.

Both would work just fine as far as the rfkill class goes, it wouldn't get
confused by either as far as I can tell (*as long as an error is
returned!*).  But we really should pick one of the two, and document that
IMHO.

My best guess is that doing a half-unblock would be less confusing to the
user, but we can ask the userspace GUI people about it ;-)  Dan?

> hardware rfkill activate
> software rfkill activate
> RFKILL_STATE_UNBLOCKED request
> hardware rfkill deactivate
> 
> Furthermore, if we permit double block, what should get_state() return?

get_state() returns RFKILL_STATE_HARD_BLOCKED when any hardware rfkill lines
are active.  If ALL hardware rfkill lines are inactive, it will return
RFKILL_STATE_SOFT_BLOCKED if any software rfkill lines are ative.

And if EVERY rfkill line is inactive, it returns RFKILL_STATE_UNBLOCKED.

This makes sense, as you are basically stuck without being able to go
anywere when in RFKILL_STATE_HARD_BLOCKED, until something external changes
the hardware rfkill lines.

> Shouldn't rfkill_state ???be bitmap instead of enum?

We could do that, too.  But a bitmap would cause trouble due to the ABI we
inherited from the rfkill in the stable kernels, so it would be cleaner to
just add a fourth state (RFKILL_STATE_DOUBLE_BLOCKED).

However, I am pretty certain we will find firmware (hardware is less likely
to be this stupid) that has erratic behaviour when RFKILL_STATE_HARD_BLOCKED
(and thus you don't really know if you managed to double-block or remove a
double-block).  In fact, that's the kind of crap I am used to fight in
thinkpad-acpi, although I sure hope thinkpads don't have this particular
quirk.

So, I pose this question:  Four states would allow us to tell the user the
radio is JUST hardware-killed or JUST software-killed for some hardware, but
does THAT enhance the user experience in any way?  Do GUIs really need that
detail?

If the answer is "yes, it is good, let's do it", I can certainly try to cook
up a patch.  But if it is "no, it wouldn't do much for the user", or if the
answer is too uncertain, I don't think we should do it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
