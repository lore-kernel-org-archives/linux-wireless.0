Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38737
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753305AbdFQP1W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Jun 2017 11:27:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 07/26] rfkill.txt: standardize document format
Date: Sat, 17 Jun 2017 12:26:47 -0300
Message-Id: <0cbf26da98f6f6124c440be11452d0df7b537ec7.1497713221.git.mchehab@s-opensource.com> (sfid-20170617_173242_253452_6BEDDD09)
In-Reply-To: <1a82f2bf2de4b016964cb71ff92dc3a472044f40.1497713221.git.mchehab@s-opensource.com>
References: <1a82f2bf2de4b016964cb71ff92dc3a472044f40.1497713221.git.mchehab@s-opensource.com>
In-Reply-To: <1a82f2bf2de4b016964cb71ff92dc3a472044f40.1497713221.git.mchehab@s-opensource.com>
References: <1a82f2bf2de4b016964cb71ff92dc3a472044f40.1497713221.git.mchehab@s-opensource.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each text file under Documentation follows a different
format. Some doesn't even have titles!

Change its representation to follow the adopted standard,
using ReST markups for it to be parseable by Sphinx:

- mark titles;
- comment contents index;
- mark literal blocks;
- adjust identation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/rfkill.txt | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index 8c174063b3f0..a289285d2412 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -1,13 +1,13 @@
+===============================
 rfkill - RF kill switch support
 ===============================
 
-1. Introduction
-2. Implementation details
-3. Kernel API
-4. Userspace support
 
+.. contents::
+   :depth: 2
 
-1. Introduction
+Introduction
+============
 
 The rfkill subsystem provides a generic interface to disabling any radio
 transmitter in the system. When a transmitter is blocked, it shall not
@@ -21,17 +21,24 @@ aircraft.
 The rfkill subsystem has a concept of "hard" and "soft" block, which
 differ little in their meaning (block == transmitters off) but rather in
 whether they can be changed or not:
- - hard block: read-only radio block that cannot be overridden by software
- - soft block: writable radio block (need not be readable) that is set by
-               the system software.
+
+ - hard block
+	read-only radio block that cannot be overridden by software
+
+ - soft block
+	writable radio block (need not be readable) that is set by
+        the system software.
 
 The rfkill subsystem has two parameters, rfkill.default_state and
-rfkill.master_switch_mode, which are documented in admin-guide/kernel-parameters.rst.
+rfkill.master_switch_mode, which are documented in
+admin-guide/kernel-parameters.rst.
 
 
-2. Implementation details
+Implementation details
+======================
 
 The rfkill subsystem is composed of three main components:
+
  * the rfkill core,
  * the deprecated rfkill-input module (an input layer handler, being
    replaced by userspace policy code) and
@@ -55,7 +62,8 @@ use the return value of rfkill_set_hw_state() unless the hardware actually
 keeps track of soft and hard block separately.
 
 
-3. Kernel API
+Kernel API
+==========
 
 
 Drivers for radio transmitters normally implement an rfkill driver.
@@ -69,7 +77,7 @@ For some platforms, it is possible that the hardware state changes during
 suspend/hibernation, in which case it will be necessary to update the rfkill
 core with the current state is at resume time.
 
-To create an rfkill driver, driver's Kconfig needs to have
+To create an rfkill driver, driver's Kconfig needs to have::
 
 	depends on RFKILL || !RFKILL
 
@@ -87,7 +95,8 @@ RFKill provides per-switch LED triggers, which can be used to drive LEDs
 according to the switch state (LED_FULL when blocked, LED_OFF otherwise).
 
 
-5. Userspace support
+Userspace support
+=================
 
 The recommended userspace interface to use is /dev/rfkill, which is a misc
 character device that allows userspace to obtain and set the state of rfkill
@@ -112,11 +121,11 @@ rfkill core framework.
 Additionally, each rfkill device is registered in sysfs and emits uevents.
 
 rfkill devices issue uevents (with an action of "change"), with the following
-environment variables set:
+environment variables set::
 
-RFKILL_NAME
-RFKILL_STATE
-RFKILL_TYPE
+	RFKILL_NAME
+	RFKILL_STATE
+	RFKILL_TYPE
 
 The contents of these variables corresponds to the "name", "state" and
 "type" sysfs files explained above.
-- 
2.9.4
