Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:7579 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726AbYFWU7D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 16:59:03 -0400
Received: by rv-out-0506.google.com with SMTP id k40so7262656rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2008 13:59:01 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/2] rfkill: improve documentation for kernel drivers
Date: Mon, 23 Jun 2008 22:58:55 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Fabien Crespel <fabien@crespel.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1214254004-32652-1-git-send-email-hmh@hmh.eng.br> <1214254004-32652-3-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1214254004-32652-3-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806232258.55698.IvDoorn@gmail.com> (sfid-20080623_225919_765262_E12675B7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 June 2008, Henrique de Moraes Holschuh wrote:
> Improve the documentation of how to use the rfkill class in kernel drivers,
> based on the doubts that came up in a thread in linux-wireless.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  Documentation/rfkill.txt |  261 +++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 201 insertions(+), 60 deletions(-)
> 
> diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
> index 5316cea..0843ed0 100644
> --- a/Documentation/rfkill.txt
> +++ b/Documentation/rfkill.txt
> @@ -4,6 +4,9 @@ rfkill - RF switch subsystem support
>  1 Introduction
>  2 Implementation details
>  3 Kernel driver guidelines
> +3.1 wireless device drivers
> +3.2 platform/switch drivers
> +3.3 input device drivers
>  4 Kernel API
>  5 Userspace support
>  
> @@ -14,9 +17,14 @@ The rfkill switch subsystem exists to add a generic interface to circuitry that
>  can enable or disable the signal output of a wireless *transmitter* of any
>  type.  By far, the most common use is to disable radio-frequency transmitters.
>  
> -The rfkill switch subsystem offers support for keys and switches often found on
> -laptops to enable wireless devices like WiFi and Bluetooth to actually perform
> -an action.
> +Note that disabling the signal output means that the the transmitter is to be
> +made to not emit any energy when "blocked".  rfkill is not about blocking data
> +transmissions, it is about blocking energy emission.
> +
> +The rfkill subsystem offers support for keys and switches often found on
> +laptops to enable wireless devices like WiFi and Bluetooth, so that these keys
> +and switches actually perform an action in all wireless devices of a given type
> +attached to the system.
>  
>  The buttons to enable and disable the wireless transmitters are important in
>  situations where the user is for example using his laptop on a location where
> @@ -30,40 +38,81 @@ take over the task to handle the key events.
>  ===============================================================================
>  2: Implementation details
>  
> +The rfkill subsystem is composed of various components: the rfkill class, the
> +rfkill-input module (an input layer handler), and some specific input layer
> +events.
> +
>  The rfkill class provides kernel drivers with an interface that allows them to
>  know when they should enable or disable a wireless network device transmitter.
> +This is enabled by the CONFIG_RFKILL Kconfig option.
> +
> +The rfkill class support makes sure userspace will be notified of all state
> +changes on rfkill devices through uevents.  It provides a notification chain
> +for interested parties in the kernel to also get notified of rfkill state
> +changes in other drivers.  It creates several sysfs entries which can be used
> +by userspace.  See section "Userspace support".
>  
>  The rfkill-input module provides the kernel with the ability to implement a
>  basic response when the user presses a key or button (or toggles a switch)
>  related to rfkill functionality.  It is an in-kernel implementation of default
>  policy of reacting to rfkill-related input events and neither mandatory nor
> -required for wireless drivers to operate.
> +required for wireless drivers to operate.  It is enabled by the
> +CONFIG_RFKILL_INPUT Kconfig option.
> +
> +rfkill-input is a rfkill-related events input layer handler.  This handler will
> +listen to all rfkill key events and will change the rfkill state of the
> +wireless devices accordingly.  With this option enabled userspace could either
> +do nothing or simply perform monitoring tasks.
>  
>  The rfkill-input module also provides EPO (emergency power-off) functionality
> -for all wireless transmitters.  This function cannot be overriden, and it is
> -always active.  rfkill EPO is related to *_RFKILL_ALL input events.
> +for all wireless transmitters.  This function cannot be overridden, and it is
> +always active.  rfkill EPO is related to *_RFKILL_ALL input layer events.
> +
> +
> +Important terms for the rfkill subsystem:
> +
> +In order to avoid confusion, we avoid the term "switch" in rfkill when it is
> +referring to an electronic control circuit that enables or disables a
> +transmitter.  We reserve it for the physical device a human manipulates
> +(which is an input device, by the way):
> +
> +rfkill switch:
> +
> +	A physical device a human manipulates.  Its state can be perceived by
> +	the kernel either directly (through a GPIO pin, ACPI GPE) or by its
> +	effect on a rfkill line of a wireless device.
> +
> +rfkill controller:
>  
> -All state changes on rfkill devices are propagated by the rfkill class to a
> -notification chain and also to userspace through uevents.
> +	A hardware circuit that controls the state of a rfkill line, which a
> +	kernel driver can interact with *to modify* that state (i.e. it has
> +	either write-only or read/write access).
>  
> -The system inside the kernel has been split into 2 separate sections:
> -	1 - RFKILL
> -	2 - RFKILL_INPUT
> +rfkill line:
>  
> -The first option enables rfkill support and will make sure userspace will be
> -notified of any events through uevents.  It provides a notification chain for
> -interested parties in the kernel to also get notified of rfkill state changes
> -in other drivers.  It creates several sysfs entries which can be used by
> -userspace.  See section "Userspace support".
> +	An input channel (hardware or software) of a wireless device, which
> +	causes a wireless transmitter to stop emitting energy (BLOCK) when it
> +	is active.  Point of view is extremely important here: rfkill lines are
> +	always seen from the PoV of a wireless device (and its driver).
>  
> -The second option provides an rfkill input handler. This handler will listen to
> -all rfkill key events and will toggle the radio accordingly.  With this option
> -enabled userspace could either do nothing or simply perform monitoring tasks.
> +soft rfkill line/software rfkill line:
>  
> -When a rfkill switch is in the RFKILL_STATE_UNBLOCKED, the wireless transmitter
> -(radio TX circuit for example) is *enabled*.  When the rfkill switch is in the
> -RFKILL_STATE_SOFT_BLOCKED or RFKILL_STATE_HARD_BLOCKED, the wireless
> -transmitter is to be *blocked* from operating.
> +	A rfkill line the wireless device driver can directly change the state
> +	of.  Related to rfkill_state RFKILL_STATE_SOFT_BLOCKED.
> +
> +hard rfkill line/hardware rfkill line:
> +
> +	A rfkill line that works fully in hardware or firmware, and that cannot
> +	be overridden by the kernel driver.  The hardware device or the
> +	firmware just exports its status to the driver, but it is read-only.
> +	Related to rfkill_state RFKILL_STATE_HARD_BLOCKED.
> +
> +The enum rfkill_state describes the rfkill state of a transmitter:
> +
> +When a rfkill line or rfkill controller is in the RFKILL_STATE_UNBLOCKED state,
> +the wireless transmitter (radio TX circuit for example) is *enabled*.  When the
> +it is in the RFKILL_STATE_SOFT_BLOCKED or RFKILL_STATE_HARD_BLOCKED, the
> +wireless transmitter is to be *blocked* from operating.
>  
>  RFKILL_STATE_SOFT_BLOCKED indicates that a call to toggle_radio() can change
>  that state.  RFKILL_STATE_HARD_BLOCKED indicates that a call to toggle_radio()
> @@ -92,12 +141,12 @@ Kernel Input layer:
>  	used to issue *commands* for the system to change behaviour, and these
>  	commands may or may not be carried out by some kernel driver or
>  	userspace application.  It follows that doing user feedback based only
> -	on input events is broken, there is no guarantee that an input event
> +	on input events is broken, as there is no guarantee that an input event
>  	will be acted upon.
>  
>  	Most wireless communication device drivers implementing rfkill
>  	functionality MUST NOT generate these events, and have no reason to
> -	register themselves with the input layer.  This is a common
> +	register themselves with the input layer.  Doing otherwise is a common
>  	misconception.  There is an API to propagate rfkill status change
>  	information, and it is NOT the input layer.
>  
> @@ -117,11 +166,22 @@ rfkill class:
>  
>  	THE RFKILL CLASS NEVER ISSUES INPUT EVENTS.  THE RFKILL CLASS DOES
>  	NOT LISTEN TO INPUT EVENTS.  NO DRIVER USING THE RFKILL CLASS SHALL
> -	EVER LISTEN TO, OR ACT ON RFKILL INPUT EVENTS.
> +	EVER LISTEN TO, OR ACT ON RFKILL INPUT EVENTS.  Doing otherwise is
> +	a layering violation.
>  
>  	Most wireless data communication drivers in the kernel have just to
>  	implement the rfkill class API to work properly.  Interfacing to the
> -	input layer is not often required (and is very often a *bug*).
> +	input layer is not often required (and is very often a *bug*) on
> +	wireless drivers.
> +
> +	Platform drivers often have to attach to the input layer to *issue*
> +	(but never to listen to) rfkill events for rfkill switches, and also to
> +	the rfkill class to export a control interface for the platform rfkill
> +	controllers to the rfkill subsystem.  This does NOT mean the rfkill
> +	switch is attached to a rfkill class (doing so is almost always wrong).
> +	It just means the same kernel module is the driver for different
> +	devices (rfkill switches and rfkill controllers).
> +
>  
>  Userspace input handlers (uevents) or kernel input handlers (rfkill-input):
>  
> @@ -153,24 +213,34 @@ rfkill notifier chain:
>  ===============================================================================
>  3: Kernel driver guidelines
>  
> +Remember: point-of-view is everything for a driver that connects to the rfkill
> +subsystem.  All the details below must be measured/perceived from the point of
> +view of the specific driver being modified.
> +
>  The first thing one needs to know is whether his driver should be talking to
> -the rfkill class or to the input layer.
> +the rfkill class or to the input layer.  In rare cases (platform drivers), it
> +could happen that you need to do both, as platform drivers often handle a
> +variety of devices in the same driver.
>  
> -Do not mistake input devices for rfkill devices.  The only type of "rfkill
> +Do not mistake input devices for rfkill controllers.  The only type of "rfkill
>  switch" device that is to be registered with the rfkill class are those
>  directly controlling the circuits that cause a wireless transmitter to stop
> -working (or the software equivalent of them).  Every other kind of "rfkill
> -switch" is just an input device and MUST NOT be registered with the rfkill
> -class.
> +working (or the software equivalent of them), i.e. what we call a rfkill
> +controller.  Every other kind of "rfkill switch" is just an input device and
> +MUST NOT be registered with the rfkill class.
>  
>  A driver should register a device with the rfkill class when ALL of the
> -following conditions are met:
> +following conditions are met (they define a rfkill controller):
>  
>  1. The device is/controls a data communications wireless transmitter;
>  
>  2. The kernel can interact with the hardware/firmware to CHANGE the wireless
>     transmitter state (block/unblock TX operation);
>  
> +3. The transmitter can be made to not emit any energy when "blocked":
> +   rfkill is not about blocking data transmissions, it is about blocking
> +   energy emission;
> +
>  A driver should register a device with the input subsystem to issue
>  rfkill-related events (KEY_WLAN, KEY_BLUETOOTH, KEY_WWAN, KEY_WIMAX,
>  SW_RFKILL_ALL, etc) when ALL of the folowing conditions are met:
> @@ -186,9 +256,7 @@ SW_RFKILL_ALL, etc) when ALL of the folowing conditions are met:
>  2. It is NOT slaved to another device, i.e. there is no other device that
>     issues rfkill-related input events in preference to this one.
>  
> -   Typically, the ACPI "radio kill" switch of a laptop is the master input
> -   device to issue rfkill events, and, e.g., the WLAN card is just a slave
> -   device that gets disabled by its hardware radio-kill input pin.
> +   Please refer to the corner cases and examples section for more details.
>  
>  When in doubt, do not issue input events.  For drivers that should generate
>  input events in some platforms, but not in others (e.g. b43), the best solution
> @@ -252,26 +320,102 @@ Add the SW_* events you need for switches, do NOT try to emulate a button using
>  KEY_* events just because there is no such SW_* event yet.  Do NOT try to use,
>  for example, KEY_BLUETOOTH when you should be using SW_BLUETOOTH instead.
>  
> -2. Input device switches (sources of EV_SW events) DO store their current
> -state, and that state CAN be queried from userspace through IOCTLs.  There is
> -no sysfs interface for this, but that doesn't mean you should break things
> -trying to hook it to the rfkill class to get a sysfs interface :-)
> +2. Input device switches (sources of EV_SW events) DO store their current state
> +(so you *must* initialize it by issuing a gratuitous input layer event on
> +driver start-up and also when resuming from sleep), and that state CAN be
> +queried from userspace through IOCTLs.  There is no sysfs interface for this,
> +but that doesn't mean you should break things trying to hook it to the rfkill
> +class to get a sysfs interface :-)
> +
> +3. Do not issue *_RFKILL_ALL events by default, unless you are sure it is the
> +correct event for your switch/button.  These events are emergency power-off
> +events when they are trying to turn the transmitters off.  An example of an
> +input device which SHOULD generate *_RFKILL_ALL events is the wireless-kill
> +switch in a laptop which is NOT a hotkey, but a real switch that kills radios
> +in hardware, even if the O.S. has gone to lunch.  An example of an input device
> +which SHOULD NOT generate *_RFKILL_ALL events by default, is any sort of hot
> +key that does nothing by itself, as well as any hot key that is type-specific
> +(e.g. the one for WLAN).
>  
> -3. Do not issue *_RFKILL_ALL events, unless you are sure it is the correct
> -event for your switch/button.  These events are emergency power-off events when
> -they are trying to turn the transmitters off.  An example of an input device
> -which SHOULD generate *_RFKILL_ALL events is the wireless-kill switch in a
> -laptop which is NOT a hotkey, but a real switch that kills radios in hardware,
> -even if the O.S. has gone to lunch.  An example of an input device which SHOULD
> -NOT generate *_RFKILL_ALL events is any sort of hot key that does nothing by
> -itself, as well as any hot key that is type-specific (e.g. the one for WLAN).
>  
> +3.1 Guidelines for wireless device drivers
> +------------------------------------------
> +
> +1. Each independent transmitter in a wireless device (usually there is only one
> +transmitter per device) should have a SINGLE rfkill class attached to it.
> +
> +2. If the device does not have any sort of hardware assistance to allow the
> +driver to rfkill the device, the driver should emulate it by taking all actions
> +required to silence the transmitter.
> +
> +3. If it is impossible to silence the transmitter (i.e. it still emits energy,
> +even if it is just in brief pulses, when there is no data to transmit and there
> +is no hardware support to turn it off) do NOT lie to the users.  Do not attach
> +it to a rfkill class.  The rfkill subsystem does not deal with data
> +transmission, it deals with energy emission.  If the transmitter is emitting
> +energy, it is not blocked in rfkill terms.
> +
> +4. It doesn't matter if the device has multiple rfkill input lines affecting
> +the same transmitter, their combined state is to be exported as a single state
> +per transmitter (see rule 1).
> +
> +This rule exists because users of the rfkill subsystem expect to get (and set,
> +when possible) the overall transmitter rfkill state, not of a particular rfkill
> +line.
> +
> +Example of a WLAN wireless driver connected to the rfkill subsystem:
> +--------------------------------------------------------------------
> +
> +A certain WLAN card has one input pin that causes it to block the transmitter
> +and makes the status of that input pin available (only for reading!) to the
> +kernel driver.  This is a hard rfkill input line (it cannot be overridden by
> +the kernel driver).
> +
> +The card also has one PCI register that, if manipulated by the driver, causes
> +it to block the transmitter.  This is a soft rfkill input line.
> +
> +It has also a thermal protection circuitry that shuts down its transmitter if
> +the card overheats, and makes the status of that protection available (only for
> +reading!) to the kernel driver.  This is also a hard rfkill input line.
> +
> +If either one of these rfkill lines are active, the transmitter is blocked by
> +the hardware and forced offline.
> +
> +The driver should allocate and attach to its struct device *ONE* instance of
> +the rfkill class (there is only one transmitter).
> +
> +It can implement the get_state() hook, and return RFKILL_STATE_HARD_BLOCKED if
> +either one of its two hard rfkill input lines are active.  If the two hard
> +rfkill lines are inactive, it must return RFKILL_STATE_SOFT_BLOCKED if its soft
> +rfkill input line is active.  Only if none of the rfkill input lines are
> +active, will it return RFKILL_STATE_UNBLOCKED.
> +
> +If it doesn't implement the get_state() hook, it must make sure that its calls
> +to rfkill_force_state() are enough to keep the status always up-to-date, and it
> +must do a rfkill_force_state() on resume from sleep.
> +
> +Every time the driver gets a notification from the card that one of its rfkill
> +lines changed state (polling might be needed on badly designed cards that don't
> +generate interrupts for such events), it recomputes the rfkill state as per
> +above, and calls rfkill_force_state() to update it.
> +
> +The driver should implement the toggle_radio() hook, that:
> +
> +1. Returns an error if one of the hardware rfkill lines are active, and the
> +caller asked for RFKILL_STATE_UNBLOCKED.
> +
> +2. Activates the soft rfkill line if the caller asked for state
> +RFKILL_STATE_SOFT_BLOCKED.  It should do this even if one of the hard rfkill
> +lines are active, effectively double-blocking the transmitter.
> +
> +3. Deactivates the soft rfkill line if none of the hardware rfkill lines are
> +active and the caller asked for RFKILL_STATE_UNBLOCKED.
>  
>  ===============================================================================
>  4: Kernel API
>  
>  To build a driver with rfkill subsystem support, the driver should depend on
> -the Kconfig symbol RFKILL; it should _not_ depend on RKFILL_INPUT.
> +(or select) the Kconfig symbol RFKILL; it should _not_ depend on RKFILL_INPUT.
>  
>  The hardware the driver talks to may be write-only (where the current state
>  of the hardware is unknown), or read-write (where the hardware can be queried
> @@ -338,10 +482,10 @@ is *absolute*; do NOT violate it.
>  ******IMPORTANT******
>  
>  Userspace must not assume it is the only source of control for rfkill switches.
> -Their state CAN and WILL change on its own, due to firmware actions, direct
> -user actions, and the rfkill-input EPO override for *_RFKILL_ALL.
> +Their state CAN and WILL change due to firmware actions, direct user actions,
> +and the rfkill-input EPO override for *_RFKILL_ALL.
>  
> -When rfkill-input is not active, userspace must initiate an rfkill status
> +When rfkill-input is not active, userspace must initiate a rfkill status
>  change by writing to the "state" attribute in order for anything to happen.
>  
>  Take particular care to implement EV_SW SW_RFKILL_ALL properly.  When that
> @@ -354,19 +498,16 @@ The following sysfs entries will be created:
>  	type: Name of the key type ("wlan", "bluetooth", etc).
>  	state: Current state of the transmitter
>  		0: RFKILL_STATE_SOFT_BLOCKED
> -			transmitter is forced off, but you can override it
> -			by a write to the state attribute, or through input
> -			events (if rfkill-input is loaded).
> +			transmitter is forced off, but one can override it
> +			by a write to the state attribute;
>  		1: RFKILL_STATE_UNBLOCKED
>  			transmiter is NOT forced off, and may operate if
>  			all other conditions for such operation are met
> -			(such as interface is up and configured, etc).
> +			(such as interface is up and configured, etc);
>  		2: RFKILL_STATE_HARD_BLOCKED
>  			transmitter is forced off by something outside of
> -			the driver's control.
> -
> -			You cannot set a device to this state through
> -			writes to the state attribute.
> +			the driver's control.  One cannot set a device to
> +			this state through writes to the state attribute;
>  	claim: 1: Userspace handles events, 0: Kernel handles events
>  
>  Both the "state" and "claim" entries are also writable. For the "state" entry


