Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34165 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836AbZC3VPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 17:15:19 -0400
Date: Mon, 30 Mar 2009 18:15:13 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC] rfkill: rewrite
Message-ID: <20090330211513.GF23749@khazad-dum.debian.net> (sfid-20090330_231525_000688_0BA3685E)
References: <1238349195.24972.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238349195.24972.5.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, far, it looks quite good.  A few initial comments that I want to get out
ASAP (I am bound to have many more after I take a first try at convert
thinkpad-acpi to the new API).

On Sun, 29 Mar 2009, Johannes Berg wrote:
> + * struct rfkill_ops - rfkill driver methods
> + *
> + * @poll_hw_block: poll the rfkill hardware block state (return true
> + *	for blocked) -- only assign this method when you cannot
> + *	do without polling
> + * @query_state: query the rfkill hardware block state (return true
> + *	for blocked) -- assign this method if software events might
> + *	cause hardware state changes
> + * @set_block: turn the transmitter on (blocked == false) or off
> + *	(blocked == true) -- this is called only while the transmitter
> + *	is not hard-blocked. This must be assigned.
> + */
> +struct rfkill_ops {
> +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
> +	bool (*poll_hw_block)(void *data);
> +	bool (*query_state)(void *data);
> +	void (*set_block)(void *data, bool blocked);
>  #endif

Missing error handling on set_block...  could you change that to:

int (*set_block)(void *data, bool blocked)

with the usual kernel error semathics (0 = no error,  < 0 = specific
error)?   And of course, do the error handling on the core?

I don't know about wireless network drivers, but platform drivers want
to be able to return errors, they _do_ happen when you are doing ACPI
dances:  EBUSY, EIO, ENOMEM...

If something in userspace wants to block a transmitter, it better get
an error back if the transmitter could not be blocked.  The opposite
(unblock) is less critical in the safety sense, but no less critical
in the usability sense, so it wants proper error feedback as well.

> +/**
> + * rfkill_register - Register a rfkill structure.
> + * @rfkill: rfkill structure to be registered
> + *
> + * This function should be called by the network driver when the rfkill

minor nit: s/network/rfkill controller/

> -Important terms for the rfkill subsystem:
> -
> -In order to avoid confusion, we avoid the term "switch" in rfkill when it is
> -referring to an electronic control circuit that enables or disables a
> -transmitter.  We reserve it for the physical device a human manipulates
> -(which is an input device, by the way):
> -
> -rfkill switch:
> -
> -	A physical device a human manipulates.  Its state can be perceived by
> -	the kernel either directly (through a GPIO pin, ACPI GPE) or by its
> -	effect on a rfkill line of a wireless device.
> -
> -rfkill controller:
> -
> -	A hardware circuit that controls the state of a rfkill line, which a
> -	kernel driver can interact with *to modify* that state (i.e. it has
> -	either write-only or read/write access).
> -
> -rfkill line:
> -
> -	An input channel (hardware or software) of a wireless device, which
> -	causes a wireless transmitter to stop emitting energy (BLOCK) when it
> -	is active.  Point of view is extremely important here: rfkill lines are
> -	always seen from the PoV of a wireless device (and its driver).
> -
> -soft rfkill line/software rfkill line:
> -
> -	A rfkill line the wireless device driver can directly change the state
> -	of.  Related to rfkill_state RFKILL_STATE_SOFT_BLOCKED.
> -
> -hard rfkill line/hardware rfkill line:
> -
> -	A rfkill line that works fully in hardware or firmware, and that cannot
> -	be overridden by the kernel driver.  The hardware device or the
> -	firmware just exports its status to the driver, but it is read-only.
> -	Related to rfkill_state RFKILL_STATE_HARD_BLOCKED.

Are you sure you want to do away with the above definitions?

The use of 'rfkill switch' for fundamentally different things caused a
lot of confusion in the past.  That's why I had to come up with
'rfkill controller', and 'rfkill line'.   Maybe you can do away with
the 'rfkill line' now, but controller/switch is something that is
helpful to avoid getting input devices and non input devices mixed up.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
