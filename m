Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35303 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbZD3DTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 23:19:07 -0400
Date: Thu, 30 Apr 2009 00:19:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC v6] rfkill: rewrite
Message-ID: <20090430031903.GD18827@khazad-dum.debian.net> (sfid-20090430_051929_493760_B2C0523B)
References: <1238349195.24972.5.camel@johannes.local> <1239745712.4205.17.camel@johannes.local> <1239750483.4205.28.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239750483.4205.28.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am halfway on the thinkpad-acpi conversion. It is going slow because
I have to cleanup the entire thing to have the code look even remotely
sane now that HW and SW states are to be tracked separately by the
backend driver, and I lost the RFKILL_STATE_* stuff.

Anyway, in the process (using v7 of the patch, taken from the URL you
posted sometime ago), I noticed this:

The return values for rfkill_alloc() are not the same on the stub and
real functions.  The stub function uses ERR_PTR, while the real
function uses NULL for any errors.   Please make them do the same
thing, and it is probably a damn good idea to document in the
kerneldoc what kind of return values one should expect when you return
a pointer and the function can fail (i.e. NULL or ERR_PTR).

Also, I have a question: are hooks ever called in atomic/interrupt
context?  Just about every ACPI and I2C driver needs to sleep to do
their magic, so I sure hope the answer is "no", otherwise life
suddenly got a whole lot more complicated for thinkpad-acpi..

Also, due to races, it is _impossible_ to assure the backend driver
that the set_block hook will never be called when the radio is
hard-blocked.  Best to change the description of that hook to make it
clear that it could happen, but that the rfkill core will try to
optimize away such changes.  Here's the race:

           A                                  B
rfkill_set_block
    saves state in "prev"
    ...                            rfkill_set_hw_state(true)
    call set_block hook
      but radio IS hard-blocked
      and the core WAS informed
      of this

Also, it looks like the SW state rollback done by rfkill_set_block can
sw-unblock a radio when it shouldn't on races very similar as the one
above, but involving sw-blocking.

I don't see a way to do safe state rollback in a lockless rfkill core
if set_sw_state can happen at any time.  Please enlighten me if I am
wrong (and I hope I am) :-(

If I am not wrong, one could change rfkill_set_sw_state and
rfkill_set_states to return an error if rfkill_set_block is on the way
(that can be done lockless).  For rfkill_set_states, document that the
hw state WILL be updated regardless, but that the sw state might not
be.

Or one could kick the problem to the backend driver (which will have
any required locking anyway), by giving the set_block hook the duty of
calling set_sw_state when it succeeds.  The return status might be
kept should we ever start passing it down to other layers like
userspace, or you can remove it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
