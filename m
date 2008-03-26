Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751AbYCZReI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 13:34:08 -0400
Subject: Re: [PATCH] libertas: fix spinlock recursion bug
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200803261637.45549.hs4233@mail.mn-solutions.de>
References: <200803191524.21866.hs4233@mail.mn-solutions.de>
	 <200803261541.48877.hs4233@mail.mn-solutions.de>
	 <1206544650.31383.15.camel@localhost.localdomain>
	 <200803261637.45549.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 13:33:11 -0400
Message-Id: <1206552791.31383.99.camel@localhost.localdomain> (sfid-20080326_173414_478871_8197A910)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-26 at 16:37 +0100, Holger Schurig wrote:
> > I agree the indirection in the current SDIO and USB drivers
> > sucks, but I'm getting more and more convinced that the way
> > that the CF driver is handling this sucks too.
> 
> I don't really can say anything about CF/SDIO driver, but for me 
> several things aren't coming into picture:
> 
> a) in "struct lbs_private", we have "struct mutex lock". What 
> exactly does it lock?  Above it is a comment "/* protected with 
> big lock */" but it's not clear to me to what this comment 
> refers. Some lines below is the same comment, so maybe this 
> should be a /* this variables are protected by 'lock' */" 
> and "/* end of protection by 'lock' */".
> 
> b) some lines later there is a comment "/* command related 
> variables protected by priv->driver_lock */", but some 
> variables, like priv->seqnum, are command-related, but in 
> the "struct mutex lock" section.
> 
> c) then there is the "spinlock_t driver_lock" later. Maybe this 
> is what is meant to protect command-related things.

Yes, ->driver_lock is for stuff that might touch hardware or require
commands to be issued and where you want to disable interrupts.  ->lock
is a simple mutex for protecting members of lbs_private from concurrent
accesses via WEXT or command responses.  spinlocks should only be held
for short periods because they spin, mutexes can be held for long
periods because they only sleep.  Any request from userspace like WEXT
should use a mutex (so the user process sleeps) while internally the
driver needs to use spinlocks if it needs to flip interrupts.  AFAIK.

> d) my knowledge about locks is so non-existant that I currently 
> don't know why one lock is a "struct mutex" and the other is 
> a "spinlock_t".
> 
> e) I also don't know (yet) when to use spin_lock_irq, 
> spin_lock_irqsave or a plain spin_lock. However, I hope to fill 
> this knowledge gap with 
> http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/
> 
> But for clarification of the other points I'd need a helping 
> hand :-)  Once we know which variables should be protected by 
> which lock we can go and fix this thing. It might even be the 
> case that one lock is enought.

It's a rat's nest only in the CF driver because the CF driver attempts
to do a s**tload of work in the hw_get_int_status() callback, which was
never meant to do any work at all, and is also under the spinlock for
reasons described below.

So; the main thread sleeps for a while, and will be woken up by the
interface code when something interesting happens (interrupt, new TX
packets from the network stack, firmware events) via lbs_interrupt().
The first thing the main thread does is ask the interface code what,
exactly, it wants the main thread to do.

The main thread grabs the lock for this because the status/event
variables need synchronization.  The main thread needs to read the
interface code's status, but the interface code could be in the
interrupt handler or whatever at the same time, and therefore might
update card->int_cause underneath the main thread if there was no
locking.  Ideally the interface code would, I don't know, atomically
queue up some work or something in the main thread and then wake the
main thread up, and then the thread would already have the interrupt
status and wouldn't need to call back into the interface code to find
out.

Next, if the interface code has some received command responses
(indicated by setting the MRVDRV_CMD_UPLD_RDY bit in it's int_cause
which got returned by hw_get_int_status() call just above), the main
thread will process command responses from the firmware.

Next, if the firmware has raised some event (disassociation, MIC
failures, etc) the main thread will (still under the spinlock!!) ask the
interface code what the firmware raised, and then process that event.

The main thread will then send queued commands down to the interface
code and thus out to the firmware, and then goes back to sleep waiting
for some interrupt/event from the interface code.

So there _definitely_ has to be some synchronization here between the
main thread and the interface code, because the interface code could be
executing in a different context due to interrupts or whatever.  When
the interface code has something interesting for the main thread to do,
it wakes the main thread up.

-----------------------------------------

The objections to the current system are basically that:

1) there's too many stupid callbacks into the interface code;
hw_get_int_status() and hw_get_event_cause() must die because they are
ugly

2) if events come in fast enough, they will get lost because the
interface code only stores the last event in card->event; status
(CARDEVENT, CMD_UPLD_RDY) is OK because it's a bitfield and only ever
OR-ed or selectively cleared

3) the code to handle all of these is just ugly; each card has to hold
onto an 'int_cause' and an 'event', the main thread keeps track of
priv->intcounter, priv->hisregcpy, and priv->eventcause.

4) SBI_EVENT_CAUSE_SHIFT... WTF?  Need I say more?  There's a better
way.

-------------------------------


To start fixing this, lets go back to the basic requirements:

a) the interface code needs to push events to the main thread
b) the interface code needs to push command responses to the main thread
c) the interface code needs to wake up the main thread when (a) or (b)
happens

The way that airo, orinoco, and atmel deal with this issue is to have a
common interrupt handler in the main code that:

1) disables interrupts
2) grabs a driver lock
3) reads interrupt status and event causes from the card
4) processes events and pushes long-running stuff to workqueues or a
main thread like libertas has in the case of airo


Possible fix:
=========================

At the expense of a some memory (solution for that at the end), create a
new structure:

struct lbs_event {
	u32 event;  /* MACREG_INT_CODE_xxxxx */
	u32 len;
	u8 buf[LBS_UPLD_SIZE];
};

then in lbs_private, add:

    struct list_head event_list;
    struct list_head event_free_list;

and pre-fill the free list with ~5 or 10 lbs_event structures.  When the
interface code gets _either_ an event or a new command response, it
calls:

    lbs_interrupt(priv, event, resp_data, resp_len);

lbs_interrupt() then gets rewritten to do something like:

void lbs_interrupt(struct lbs_private *priv, u32 event, u8 *resp_data, u32 resp_len)
{
    unsigned long flags;

    lbs_deb_enter(LBS_DEB_THREAD);

    spin_lock_irqsave (&priv->driver_lock, &flags);

    <grab event struct 'next' off event_free_list>
    if (< no free events>) {
        lbs_pr_alert("event/response queue full!");
        /* do something intelligent */
        goto out;
    }

    next.event = event;
    next.len = resp_len;
    if (resp_len)
        memcpy (next.buf, resp_data, resp_len);

    <add event struct 'next' to tail of event_list>

    if (priv->psstate == PS_STATE_SLEEP)
        priv->psstate = PS_STATE_AWAKE;

    wake_up_interruptible(&priv->waitq);

out:
    spin_unlock_irqrestore (&priv->driver_lock, flags);
    lbs_deb_leave(LBS_DEB_THREAD);
}

then, the main thread can get rid of:

priv->upld_len
priv->upld_buf
hw_get_int_status
hw_read_event_cause
priv->intcounter
priv->eventcause
priv->hisregcpy

and in lbs_thread() right after the "if (priv->surpriseremoved)" bits,
the flow would go like:

  process:
    event = <get first event from priv->event_list>
    if (event->len) {
        spin_unlock_irqrestore(&priv->driver_lock, flags);
	lbs_process_rx_command(priv, event->buf, event->len);
        spin_lock_irqsave(&priv->driver_lock, &flags);
    }

    .... command timeout stuff ....

    if (event->event) {
        spin_unlock_irq(&priv->driver_lock);
        lbs_process_event(priv, event->event);
    }

    .... blah blah blah ....

    < loop to process: until event_list is empty, then sleep >

Seems better than what's there.  I might take a stab at this if people
think it seems sane enough.  The memory hit over what's there now would
be ~15K of allocated memory at driver load per card.  If that's too
much, this could be split into two lists, an event queue and a smaller
command response queue since there should never be more than a few
outstanding command responses, but there might be a lot of events.  You
want to preallocate the list because you don't really want to be
kzalloc()-ing during interrupt handlers and dealing with possible
failures.

Dan


