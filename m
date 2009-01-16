Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.openmoko.org ([88.198.124.205]:43694 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZAPTxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 14:53:10 -0500
Received: from 175-205-16-190.fibertel.com.ar ([190.16.205.175] helo=ws)
	by mail.openmoko.org with esmtpsa (TLS-1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.63)
	(envelope-from <werner@openmoko.org>)
	id 1LNuq7-0006IS-TL
	for linux-wireless@vger.kernel.org; Fri, 16 Jan 2009 19:58:51 +0000
Date: Fri, 16 Jan 2009 17:52:47 -0200
From: Werner Almesberger <werner@openmoko.org>
To: linux-wireless@vger.kernel.org
Subject: rfkill: life after driver death
Message-ID: <20090116195247.GC13290@almesberger.net> (sfid-20090116_205316_674901_DDCBD0C3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First of all, thanks for the advice on permissible rfkill semantics !
I've implemented rfkill for the AR6k driver on the FreeRunner.

Now there's another interesting problem that seems to want a more
general solution: how to handle devices that regularly disappear and
then get re-created ?


Problem statement:

In our case, the AR6k module sits on the SDIO bus. When we suspend,
the SDIO host driver does a sdio_bus_remove, which removes the entire
AR6k device. This would also include any rfkill device it owns.

Since rfkill is supposed to restore the previous state on resume, I
let a platform driver "own" the rfkill device instead, with a private
interface between the AR6k driver and this platform driver to perform
the actual blocking/unblocking and also to tell the AR6k driver
whether it is allowed to activate the SDIO function or not on resume.

We don't have a simple transmitter on/off line, so we control the
transmitter with the next simplest mechanism, which is through SDIO
function activation.

Furthermore, it's not only suspend/resume that makes the driver
disappear, but user space may also do other things that cause it to
be removed, e.g., unbind through sysfs or module removal.


My present hac^H^H^Hsolution:

This approach works quite satisfyingly, except that the private
interface between driver and platform isn't nice. I could apply some
window dressing to make it look a bit nicer, but I think this is
something that would better be handled by the general rfkill
infrastructure.

What the interface does is to track rfkill changes while the driver
is absent, and notify the driver in a race-free way of the rfkill
state at the time of driver initialization. The initialization of
the driver looks as follows:

my_driver_probe()
{
	...
	not_blocked = query_rfkill_and_block_further_rfkill_changes();
	if (not_blocked) {
		err = finish_initializing_my_driver();
		if (err) {
			unlock_rfkill_changes();
			goto failure;
		}
		atomically_setup_rfkill_handler_and_unblock_changes(
		    my_driver_rfkill_handler);
	}
	...
}


Proposed generalization:

Since there are plenty of other hotpluggable devices around, I think
persistent state would generally be desirable for rfkill. Maybe
something along the lines of allowing a driver to detach its rfkill
device and to let a later instance to re-attach to it. Example:

struct rfkill *rfkill_try_reattach(const char *name)

    Find the named rfkill device, block further state changes, and
    return a pointer to it. If no device is found, return NULL.
    On success, caller can now use rfkill->state to decide what to
    do. On failure, it proceeds by creating a new rfkill device.

void rfkill_attach_handler(struct rfkill *rfkill, int (*toggle_radio)(...),
    void *data);

    Attach a toggle function to a rfkill device previously returned
    by rfkill_try_reattach, and unblock rfkill state changes.

void rfkill_detach(struct rfkill *rfkill);

   Detach a driver from a rfkill device. A new driver instance for
   the same device can later re-attach to the rfkill device with
   rfkill_try_reattach.

Does this sound reasonable so far ?

One potential issue would be name collisions, e.g., two drivers trying
to attach to the same rfkill device. I can think of three possible
solutions for this:

1) require (and enforce) unique names,
2) allow multiple rfkill devices with the same name, or
3) allow multiple devices to share the same rfkill device.

The semantics of 3) would be a bit tricky. 1) would be a bit of a trap,
because it would be just too convenient to assume there's only one
device. In case 2), the kernel would not know to distinguish among
rfkill devices with the same name, so rfkill_try_reattach would yield
an arbitrary one, or NULL if there is one but it's already attached.
This passes the problem of maintaining a consistent state up to user
space. I kind of like that ;-)

Opinions ?

- Werner
