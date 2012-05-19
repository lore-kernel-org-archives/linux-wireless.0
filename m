Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:57854 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754147Ab2ESUTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 16:19:39 -0400
Date: Sat, 19 May 2012 22:19:58 +0200
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: linux-wireless@vger.kernel.org
Subject: IWLWIFI should depend on SUSPEND
Message-ID: <20120519201958.GA2313@wolfgang> (sfid-20120519_221944_090598_23FED733)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everybody,

iwlwifi doesn't start without suspend support in the kernel. The last
thing it says when suspend is missing is this:

iwlwifi 0000:03:00.0: Failed to register hw (error -22)
iwlwifi 0000:03:00.0: PCI INT A disabled

Most kernels have suspend support, but maybe somebody thinks he doesn't
need it and leaves it out.

Here's the diff between non-working and working kernel configuration
(kernel 3.2.17):

--- doesnt-work.txt	2012-05-19 16:10:54.000000000 +0200
+++ works.txt	2012-05-19 15:53:56.000000000 +0200
@@ -237,7 +237,7 @@
 CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
 # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
 CONFIG_MUTEX_SPIN_ON_OWNER=y
-# CONFIG_FREEZER is not set
+CONFIG_FREEZER=y
 
 #
 # Processor type and features
@@ -371,12 +371,16 @@
 #
 # Power management and ACPI options
 #
-# CONFIG_SUSPEND is not set
+CONFIG_SUSPEND=y
+CONFIG_SUSPEND_FREEZER=y
 # CONFIG_HIBERNATION is not set
+CONFIG_PM_SLEEP=y
+CONFIG_PM_SLEEP_SMP=y
 CONFIG_PM_RUNTIME=y
 CONFIG_PM=y
 # CONFIG_PM_DEBUG is not set
 CONFIG_ACPI=y
+CONFIG_ACPI_SLEEP=y
 # CONFIG_ACPI_PROCFS is not set
 # CONFIG_ACPI_PROCFS_POWER is not set
 # CONFIG_ACPI_EC_DEBUGFS is not set
@@ -865,6 +869,7 @@
 CONFIG_VT=y
 CONFIG_CONSOLE_TRANSLATIONS=y
 CONFIG_VT_CONSOLE=y
+CONFIG_VT_CONSOLE_SLEEP=y
 CONFIG_HW_CONSOLE=y
 # CONFIG_VT_HW_CONSOLE_BINDING is not set
 CONFIG_UNIX98_PTYS=y

Regards,
Sebastian
