Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbZFOO1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 10:27:24 -0400
Subject: [PATCH 2.6.31] rfkill: improve docs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 15:36:38 +0200
Message-Id: <1245072998.23912.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the dust has settled a bit, improve the docs on rfkill
and include more information about /dev/rfkill.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 Documentation/rfkill.txt |  147 +++++++++++++++++++++++------------------------
 1 file changed, 74 insertions(+), 73 deletions(-)

--- wireless-testing.orig/Documentation/rfkill.txt	2009-06-15 15:28:08.000000000 +0200
+++ wireless-testing/Documentation/rfkill.txt	2009-06-15 15:35:23.000000000 +0200
@@ -3,9 +3,8 @@ rfkill - RF kill switch support
 
 1. Introduction
 2. Implementation details
-3. Kernel driver guidelines
-4. Kernel API
-5. Userspace support
+3. Kernel API
+4. Userspace support
 
 
 1. Introduction
@@ -19,82 +18,62 @@ disable all transmitters of a certain ty
 situations where transmitters need to be turned off, for example on
 aircraft.
 
+The rfkill subsystem has a concept of "hard" and "soft" block, which
+differ little in their meaning (block == transmitters off) but rather in
+whether they can be changed or not:
+ - hard block: read-only radio block that cannot be overriden by software
+ - soft block: writable radio block (need not be readable) that is set by
+               the system software.
 
 
 2. Implementation details
 
-The rfkill subsystem is composed of various components: the rfkill class, the
-rfkill-input module (an input layer handler), and some specific input layer
-events.
-
-The rfkill class is provided for kernel drivers to register their radio
-transmitter with the kernel, provide methods for turning it on and off and,
-optionally, letting the system know about hardware-disabled states that may
-be implemented on the device. This code is enabled with the CONFIG_RFKILL
-Kconfig option, which drivers can "select".
-
-The rfkill class code also notifies userspace of state changes, this is
-achieved via uevents. It also provides some sysfs files for userspace to
-check the status of radio transmitters. See the "Userspace support" section
-below.
-
-
-The rfkill-input code implements a basic response to rfkill buttons -- it
-implements turning on/off all devices of a certain class (or all).
+The rfkill subsystem is composed of three main components:
+ * the rfkill core,
+ * the deprecated rfkill-input module (an input layer handler, being
+   replaced by userspace policy code) and
+ * the rfkill drivers.
+
+The rfkill core provides API for kernel drivers to register their radio
+transmitter with the kernel, methods for turning it on and off and, letting
+the system know about hardware-disabled states that may be implemented on
+the device.
+
+The rfkill core code also notifies userspace of state changes, and provides
+ways for userspace to query the current states. See the "Userspace support"
+section below.
 
 When the device is hard-blocked (either by a call to rfkill_set_hw_state()
-or from query_hw_block) set_block() will be invoked but drivers can well
-ignore the method call since they can use the return value of the function
-rfkill_set_hw_state() to sync the software state instead of keeping track
-of calls to set_block().
-
-
-The entire functionality is spread over more than one subsystem:
-
- * The kernel input layer generates KEY_WWAN, KEY_WLAN etc. and
-   SW_RFKILL_ALL -- when the user presses a button. Drivers for radio
-   transmitters generally do not register to the input layer, unless the
-   device really provides an input device (i.e. a button that has no
-   effect other than generating a button press event)
-
- * The rfkill-input code hooks up to these events and switches the soft-block
-   of the various radio transmitters, depending on the button type.
-
- * The rfkill drivers turn off/on their transmitters as requested.
-
- * The rfkill class will generate userspace notifications (uevents) to tell
-   userspace what the current state is.
+or from query_hw_block) set_block() will be invoked for additional software
+block, but drivers can ignore the method call since they can use the return
+value of the function rfkill_set_hw_state() to sync the software state
+instead of keeping track of calls to set_block(). In fact, drivers should
+use the return value of rfkill_set_hw_state() unless the hardware actually
+keeps track of soft and hard block separately.
 
 
+3. Kernel API
 
-3. Kernel driver guidelines
 
-
-Drivers for radio transmitters normally implement only the rfkill class.
-These drivers may not unblock the transmitter based on own decisions, they
-should act on information provided by the rfkill class only.
+Drivers for radio transmitters normally implement an rfkill driver.
 
 Platform drivers might implement input devices if the rfkill button is just
 that, a button. If that button influences the hardware then you need to
-implement an rfkill class instead. This also applies if the platform provides
+implement an rfkill driver instead. This also applies if the platform provides
 a way to turn on/off the transmitter(s).
 
-During suspend/hibernation, transmitters should only be left enabled when
-wake-on wlan or similar functionality requires it and the device wasn't
-blocked before suspend/hibernate. Note that it may be necessary to update
-the rfkill subsystem's idea of what the current state is at resume time if
-the state may have changed over suspend.
-
-
-
-4. Kernel API
-
-To build a driver with rfkill subsystem support, the driver should depend on
-(or select) the Kconfig symbol RFKILL.
-
-The hardware the driver talks to may be write-only (where the current state
-of the hardware is unknown), or read-write (where the hardware can be queried
-about its current state).
+For some platforms, it is possible that the hardware state changes during
+suspend/hibernation, in which case it will be necessary to update the rfkill
+core with the current state is at resume time.
+
+To create an rfkill driver, driver's Kconfig needs to have
+
+	depends on RFKILL || !RFKILL
+
+to ensure the driver cannot be built-in when rfkill is modular. The !RFKILL
+case allows the driver to be built when rfkill is not configured, which which
+case all rfkill API can still be used but will be provided by static inlines
+which compile to almost nothing.
 
 Calling rfkill_set_hw_state() when a state change happens is required from
 rfkill drivers that control devices that can be hard-blocked unless they also
@@ -105,10 +84,33 @@ device). Don't do this unless you cannot
 
 5. Userspace support
 
-The following sysfs entries exist for every rfkill device:
+The recommended userspace interface to use is /dev/rfkill, which is a misc
+character device that allows userspace to obtain and set the state of rfkill
+devices and sets of devices. It also notifies userspace about device addition
+and removal. The API is a simple read/write API that is defined in
+linux/rfkill.h, with one ioctl that allows turning off the deprecated input
+handler in the kernel for the transition period.
+
+Except for the one ioctl, communication with the kernel is done via read()
+and write() of instances of 'struct rfkill_event'. In this structure, the
+soft and hard block are properly separated (unlike sysfs, see below) and
+userspace is able to get a consistent snapshot of all rfkill devices in the
+system. Also, it is possible to switch all rfkill drivers (or all drivers of
+a specified type) into a state which also updates the default state for
+hotplugged devices.
+
+After an application opens /dev/rfkill, it can read the current state of
+all devices, and afterwards can poll the descriptor for hotplug or state
+change events.
+
+Applications must ignore operations (the "op" field) they do not handle,
+this allows the API to be extended in the future.
+
+Additionally, each rfkill device is registered in sysfs and there has the
+following attributes:
 
 	name: Name assigned by driver to this key (interface or driver name).
-	type: Name of the key type ("wlan", "bluetooth", etc).
+	type: Driver type string ("wlan", "bluetooth", etc).
 	state: Current state of the transmitter
 		0: RFKILL_STATE_SOFT_BLOCKED
 			transmitter is turned off by software
@@ -117,7 +119,12 @@ The following sysfs entries exist for ev
 		2: RFKILL_STATE_HARD_BLOCKED
 			transmitter is forced off by something outside of
 			the driver's control.
-	claim: 0: Kernel handles events (currently always reads that value)
+	       This file is deprecated because it can only properly show
+	       three of the four possible states, soft-and-hard-blocked is
+	       missing.
+	claim: 0: Kernel handles events
+	       This file is deprecated because there no longer is a way to
+	       claim just control over a single rfkill instance.
 
 rfkill devices also issue uevents (with an action of "change"), with the
 following environment variables set:
@@ -128,9 +135,3 @@ RFKILL_TYPE
 
 The contents of these variables corresponds to the "name", "state" and
 "type" sysfs files explained above.
-
-An alternative userspace interface exists as a misc device /dev/rfkill,
-which allows userspace to obtain and set the state of rfkill devices and
-sets of devices. It also notifies userspace about device addition and
-removal. The API is a simple read/write API that is defined in
-linux/rfkill.h.


