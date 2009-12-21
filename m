Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:55845 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756995AbZLUTGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 14:06:18 -0500
Message-ID: <4B2FC725.400@redfish-solutions.com>
Date: Mon, 21 Dec 2009 11:06:13 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Randy Dunlap <rdunlap@xenotime.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Can't turn off SSB (CONFIG_SSB)?
References: <4B2ECC72.40703@redfish-solutions.com> <20091221080928.cc7c19ee.rdunlap@xenotime.net> <4B2FBEEA.5010002@redfish-solutions.com> <200912211945.25602.mb@bu3sch.de>
In-Reply-To: <200912211945.25602.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2009 10:45 AM, Michael Buesch wrote:
> On Monday 21 December 2009 19:31:06 Philip A. Prindeville wrote:
>> Here's what we have.
> 
> # CONFIG_SSB is not set
> 

Ok, here's what's happening.

We have a "canned" config that we copy over, per platform.

I'm showing diffs of that config with what results (i.e. what's left in the linux-2.6.27.38 directory after running "make silentoldconfig" and "make prepare1"):

--- target/device/via-c7/linux.config   2009-12-21 10:55:55.000000000 -0800
+++ build_i586/linux-2.6.27.38-astlinux/.config 2009-12-21 11:02:34.000000000 -0800
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.27.38
-# Tue Nov 10 16:50:01 2009
+# Mon Dec 21 11:02:34 2009
 #
 # CONFIG_64BIT is not set
 CONFIG_X86_32=y
@@ -1446,8 +1446,16 @@
 #
 # Sonics Silicon Backplane
 #
-CONFIG_SSB_POSSIBLE=n
-CONFIG_SSB=n
+CONFIG_SSB_POSSIBLE=y
+CONFIG_SSB=m
+CONFIG_SSB_SPROM=y
+CONFIG_SSB_PCIHOST_POSSIBLE=y
+CONFIG_SSB_PCIHOST=y
+# CONFIG_SSB_B43_PCI_BRIDGE is not set
+# CONFIG_SSB_SILENT is not set
+# CONFIG_SSB_DEBUG is not set
+CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
+CONFIG_SSB_DRIVER_PCICORE=y

 #
 # Multifunction device drivers
@@ -1621,6 +1629,8 @@
 # CONFIG_USB_DYNAMIC_MINORS is not set
 # CONFIG_USB_SUSPEND is not set
 # CONFIG_USB_OTG is not set
+# CONFIG_USB_OTG_WHITELIST is not set
+# CONFIG_USB_OTG_BLACKLIST_HUB is not set
 # CONFIG_USB_MON is not set

 #
@@ -1955,7 +1965,7 @@
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
-CONFIG_DEBUG_BUGVERBOSE=y
+# CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y


as you can see, a bunch of things are getting "turned on" that we explicitly turned off.

-Philip

