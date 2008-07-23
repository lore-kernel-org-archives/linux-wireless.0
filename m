Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:12463 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYGWTD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 15:03:29 -0400
Received: by nf-out-0910.google.com with SMTP id d3so942287nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 12:03:27 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: add default global states
Date: Wed, 23 Jul 2008 21:20:42 +0200
Cc: linux-wireless@vger.kernel.org
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <200807232028.49239.IvDoorn@gmail.com> <20080723184257.GD11009@khazad-dum.debian.net>
In-Reply-To: <20080723184257.GD11009@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807232120.42231.IvDoorn@gmail.com> (sfid-20080723_210332_765583_DB32C5C3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 July 2008, Henrique de Moraes Holschuh wrote:
> On Wed, 23 Jul 2008, Ivo van Doorn wrote:
> > >  static enum rfkill_state rfkill_states[RFKILL_TYPE_MAX];
> > > +static enum rfkill_state rfkill_default_states[RFKILL_TYPE_MAX];
> > > +static unsigned long rfkill_states_lockdflt[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
> > 
> > I have a slight distaste for using multiple arrays where each variable is a different
> > variable for the same object. Perhaps it is time to move it into a structure:
> > 
> > struct .. {
> > 	enum rfkill_state current
> > 	enum rfkill_state default
> > };
> > 
> > static struct .. rfkill_states[RFKILL_TYPE_MAX];
> > 
> > It probably won't optimize anything, but I think it looks a bit nicer.
> > 
> > Just a suggestion, if it easier to keep it as multiple arrays I would still ack it. ;)
> 
> Sure, I can do that.  It doesn't work well for the bitfields, though (wastes
> a LOT of memory), so I will keep the bitfields as separate ulong arrays if
> that's OK with you?

Sure sounds good.

> > > + * rfkill_set_default - set initial value for a switch type
> > > + * @type - the type of switch to set the default state of
> > > + * @state - the new default state for that group of switches
> > > + *
> > > + * Sets the initial state rfkill should use for a given type.  Only "soft"
> > > + * states are allowed, i.e. RFKILL_STATE_SOFT_BLOCKED and
> > > + * RFKILL_STATE_UNBLOCKED.
> > > + *
> > > + * This function is meant to be used by platform drivers for platforms that
> > > + * can save switch state across power down/reboot.
> > 
> > As sideinfo: I found a hardware bug in a broadcom rfkill key a few days ago
> > which would not work well with this function:
> > 
> > * laptop was powered on, HW rfkill was set to allow WiFi
> > * laptop halted, something about a missing power supply and a battery which was drained
> > 	without any userspace tool checking the battery status. ;)
> > * laptop was powered on and booted,  HW rkfill decided to block WiFi.
> 
> Heh.  Well, it is a hardware failure mode, it will be up to the broadcomm
> device driver to figure out when NOT to use rfkill_set_default() ;-)

Well even the driver can't do much about it, it is only triggered when the power
is completely drained and it simply cuts the power. On a regular halt/reboot the state
is preserved.
So it is something no driver can actually detect..

> I just found out I can do that (store WWAN and bluetooth state) across
> power cycles on thinkpads as well.  I wonder what kind of weird failures
> will be hidden behind THAT... :)
> 
> > In any case not really important for this patch, but just for information. ;)
> 
> Heh, sure :-)  At least the failure mode for the hardware was safely handled
> (it HW-killed the radio instead of unblocking it :p).

True. :)

> > >   * Rfkill module initialization/deinitialization.
> > >   */
> > > @@ -702,8 +793,8 @@ static int __init rfkill_init(void)
> > >  	    rfkill_default_state != RFKILL_STATE_UNBLOCKED)
> > >  		return -EINVAL;
> > >  
> > > -	for (i = 0; i < ARRAY_SIZE(rfkill_states); i++)
> > > -		rfkill_states[i] = rfkill_default_state;
> > > +	for (i = 0; i < ARRAY_SIZE(rfkill_default_states); i++)
> > > +		rfkill_default_states[i] = rfkill_default_state;
> > 
> > rfkill_states[] is now no longer initialized, I guess that is a bad thing ;)
> 
> It is initialized from the [current] default state on first use... look at
> the hunk for rfkill_add_switch()  :)

Ah ok, I missed that part.

> I could double-initialize it, but since the kernel will already zero it for
> us anyway, and we need to copy the default state to the current state on
> first use (so that rfkill_set_default() is easy to implement...) I would
> just be triple-initializing something :p

Nah, single initialization is good enough. ;)

Ivo
