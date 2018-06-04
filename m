Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([84.19.176.117]:44792 "EHLO ns.pmeerw.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751093AbeFDVCI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 17:02:08 -0400
From: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Subject: [PATCH] rfkill: Fix several typos in documentation
Date: Mon,  4 Jun 2018 23:02:03 +0200
Message-Id: <20180604210203.29684-1-pmeerw@pmeerw.net> (sfid-20180604_230253_073037_E2CE3C90)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
---
 Documentation/rfkill.txt | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index a289285d2412..7d3684e81df6 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -9,7 +9,7 @@ rfkill - RF kill switch support
 Introduction
 ============
 
-The rfkill subsystem provides a generic interface to disabling any radio
+The rfkill subsystem provides a generic interface for disabling any radio
 transmitter in the system. When a transmitter is blocked, it shall not
 radiate any power.
 
@@ -45,7 +45,7 @@ The rfkill subsystem is composed of three main components:
  * the rfkill drivers.
 
 The rfkill core provides API for kernel drivers to register their radio
-transmitter with the kernel, methods for turning it on and off and, letting
+transmitter with the kernel, methods for turning it on and off, and letting
 the system know about hardware-disabled states that may be implemented on
 the device.
 
@@ -54,7 +54,7 @@ ways for userspace to query the current states. See the "Userspace support"
 section below.
 
 When the device is hard-blocked (either by a call to rfkill_set_hw_state()
-or from query_hw_block) set_block() will be invoked for additional software
+or from query_hw_block), set_block() will be invoked for additional software
 block, but drivers can ignore the method call since they can use the return
 value of the function rfkill_set_hw_state() to sync the software state
 instead of keeping track of calls to set_block(). In fact, drivers should
@@ -65,7 +65,6 @@ keeps track of soft and hard block separately.
 Kernel API
 ==========
 
-
 Drivers for radio transmitters normally implement an rfkill driver.
 
 Platform drivers might implement input devices if the rfkill button is just
@@ -75,14 +74,14 @@ a way to turn on/off the transmitter(s).
 
 For some platforms, it is possible that the hardware state changes during
 suspend/hibernation, in which case it will be necessary to update the rfkill
-core with the current state is at resume time.
+core with the current state at resume time.
 
 To create an rfkill driver, driver's Kconfig needs to have::
 
 	depends on RFKILL || !RFKILL
 
 to ensure the driver cannot be built-in when rfkill is modular. The !RFKILL
-case allows the driver to be built when rfkill is not configured, which
+case allows the driver to be built when rfkill is not configured, in which
 case all rfkill API can still be used but will be provided by static inlines
 which compile to almost nothing.
 
@@ -91,7 +90,7 @@ rfkill drivers that control devices that can be hard-blocked unless they also
 assign the poll_hw_block() callback (then the rfkill core will poll the
 device). Don't do this unless you cannot get the event in any other way.
 
-RFKill provides per-switch LED triggers, which can be used to drive LEDs
+rfkill provides per-switch LED triggers, which can be used to drive LEDs
 according to the switch state (LED_FULL when blocked, LED_OFF otherwise).
 
 
@@ -114,7 +113,7 @@ a specified type) into a state which also updates the default state for
 hotplugged devices.
 
 After an application opens /dev/rfkill, it can read the current state of all
-devices. Changes can be either obtained by either polling the descriptor for
+devices. Changes can be obtained by either polling the descriptor for
 hotplug or state change events or by listening for uevents emitted by the
 rfkill core framework.
 
@@ -127,8 +126,7 @@ environment variables set::
 	RFKILL_STATE
 	RFKILL_TYPE
 
-The contents of these variables corresponds to the "name", "state" and
+The content of these variables corresponds to the "name", "state" and
 "type" sysfs files explained above.
 
-
 For further details consult Documentation/ABI/stable/sysfs-class-rfkill.
-- 
2.11.0
