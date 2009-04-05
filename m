Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:32839 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699AbZDEO7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2009 10:59:49 -0400
Date: Sun, 5 Apr 2009 11:59:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC] rfkill: rewrite
Message-ID: <20090405145941.GA24963@khazad-dum.debian.net> (sfid-20090405_165952_737885_9C3179D8)
References: <1238349195.24972.5.camel@johannes.local> <20090330211513.GF23749@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090330211513.GF23749@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 30 Mar 2009, Henrique de Moraes Holschuh wrote:
> So, far, it looks quite good.  A few initial comments that I want to get out
> ASAP (I am bound to have many more after I take a first try at convert
> thinkpad-acpi to the new API).

And it would have been better if I had looked at it for an extra five
minutes :-(

> > + * @poll_hw_block: poll the rfkill hardware block state (return true
> > + *	for blocked) -- only assign this method when you cannot
> > + *	do without polling
> > + * @query_state: query the rfkill hardware block state (return true
> > + *	for blocked) -- assign this method if software events might
> > + *	cause hardware state changes
> > + * @set_block: turn the transmitter on (blocked == false) or off
> > + *	(blocked == true) -- this is called only while the transmitter
> > + *	is not hard-blocked. This must be assigned.
> > + */
> > +struct rfkill_ops {
> > +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
> > +	bool (*poll_hw_block)(void *data);
> > +	bool (*query_state)(void *data);
> > +	void (*set_block)(void *data, bool blocked);
> >  #endif
> 
> Missing error handling on set_block...  could you change that to:

And also on the rest of the hooks.  I should have noticed it sooner!

As I said, ACPI platform drivers _do_ get errors when calling the ACPI
functions, or trying to do an EC transaction.  That applies to reads
just as well as it applies to writes.

I.e. I can get AE_BUSY or something else while querying the thinkpad
firmware, and then, what should I do to return the data on the
query_state (and, for that matter, poll_hw_block) hooks?

Since there can be a clear error path from userspace to the rfkill
driver for reads and writes in many situations (e.g. on all sysfs
accesses to that driver's rfkill struct), this would be a good reason to
change the hooks to allow for that error path.

There is a second reason as well to change it: the policy on what to do
when the driver cannot query the up-to-date state of the rfkill
controller should not be defined by the driver itself, it is best
defined by the rfkill core so that all drivers behave the same.

Without that, I'd have, for example, to return false (unblocked) on any
errors from thinkpad-acpi, for safety reasons (a blocked radio is never
a hazard, but an unblocked one can be).  This is the kind of stuff that
a driver shouldn't need to decide by itself...


On a related note, it was not clear to me from looking only at
rfkill.txt and the linux/rfkill.h headers, how am I supposed to deal
with the software controlled component of the rfkill controller (the
hardware rfkill line is quite obvious, though).  I know there is a way,
but I haven't finished reading the core code to know which one, and the
docs didn't help, so they need an extra paragraph somewhere...


Anyway, I suggest changing the hook protypes to this (which does _NOT_
change the fact that you now track hw and sw separately in the core, but
lets the rfkill driver deliver both in a single call if it needs to):

int (*poll_block_state)(void *data,
			 bool *is_sw_block_active,
			 bool *is_hw_block_active);
int (*query_block_state)(void *data, 
			 bool *is_sw_block_active,
			 bool *is_hw_block_active);
int (*set_block_state)(void *data, bool do_sw_block);

With the following semanthics:

function return status:  0 if OK, <0 in case of error (i.e. standard
error semanthics).

is_sw_block_active: leave untouched if there is no sw blocking support,
otherwise change it to the up-to-date state of the sw blocking flag
(true=blocked)

is_hw_block_active: leave untouched if there is no hw blocking,
otherwise change it to the up-to-date state of the hw blocking flag
(true=blocked)

The core should ignore the is_* stuff if an error status is returned,
as a defensive approach against driver bugs: doing it that way is less
programmer-error-prone than telling people to not touch is_* in case of
an error.

do_sw_block: true if the driver should software block, false if it
should attempt to software unblock.

BTW: it is probably a good idea to document what the driver should do if
the core tries this on a radio that is hardware blocked, or if the
driver discovers the radio is hardware blocked the instant it tries to
software unblock it...


It would be nice to have the core export a way to "force" both sw and hw
states at once, as well.  This lets the core optimize the issuing of
events and other internal changes and avoids bad mojo if the driver does
sw/hw force calls in the wrong order (which might cause a unblock-block
fast sequence, etc).

This would let drivers that have the worst case software blocking (it
exists, hw blocking also exists and is separate, and both sw and hw
blocking state could change behind the driver's back) work well, without
causing any extra complexity to the other drivers.


IF you don't want the hooks to return both sw and hw states, you can
just change the return type from bool to int, and explicitly document
tha the return status is:

status < 0: error
status = 0: false, implies no error
status > 0: true, implies no error

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
