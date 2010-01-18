Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sdinet.de ([78.47.32.153]:47436 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab0ARO6X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2010 09:58:23 -0500
Received: from [192.168.22.39] (aurora.sdinet.de [192.168.22.39])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	(Authenticated sender: haegar)
	by mail.sdinet.de (bofa-smtpd) with ESMTPSA id 216E232F4002
	for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2010 15:51:07 +0100 (CET)
Date: Mon, 18 Jan 2010 15:50:48 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: compat-wireless 2.6.33-rc4 + 2.6.31 (ubuntu karmic) problem
Message-ID: <alpine.DEB.2.00.1001181542410.5338@aurora.sdinet.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hallo,

trying to use compat-wireless-2.6.33-rc4 together with an ubuntu karmic 
2.6.31-18.55 kernel I get the following oops at boot time:

Jan 18 14:42:05 aurora kernel: [   13.420298] WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0xb2/0xd0()
Jan 18 14:42:05 aurora kernel: [   13.420428] Hardware name: 2007FRG
Jan 18 14:42:05 aurora kernel: [   13.420557] sysfs: cannot create duplicate filename '/class/firmware'
Jan 18 14:42:05 aurora kernel: [   13.420687] Modules linked in: compat_firmware_class(+) rtc_lib raid10 raid456 raid6_pq async_xor async_memcpy async_tx xor raid1 raid0 linear md_mod sg sr_mod cdrom e1000e video backlight output uhci_hcd ehci_hcd usbcore button intel_agp agpgart thermal fan thermal_sys hwmon [last unloaded: scsi_wait_scan]
Jan 18 14:42:05 aurora kernel: [   13.424553] Pid: 1770, comm: modprobe Not tainted 2.6.31-sdinet52-aurora #280
Jan 18 14:42:05 aurora kernel: [   13.424687] Call Trace:
Jan 18 14:42:05 aurora kernel: [   13.424818]  [<c1039c9a>] ? warn_slowpath_common+0x7a/0xc0
Jan 18 14:42:05 aurora kernel: [   13.424950]  [<c111a232>] ? sysfs_add_one+0xb2/0xd0
Jan 18 14:42:05 aurora kernel: [   13.425085]  [<c1039d57>] ? warn_slowpath_fmt+0x37/0x60
Jan 18 14:42:05 aurora kernel: [   13.425215]  [<c111a232>] ? sysfs_add_one+0xb2/0xd0
Jan 18 14:42:05 aurora kernel: [   13.425345]  [<c111a2af>] ? create_dir+0x5f/0xc0
Jan 18 14:42:05 aurora kernel: [   13.425477]  [<c111a345>] ? sysfs_create_dir+0x35/0x60
Jan 18 14:42:05 aurora kernel: [   13.425608]  [<c11f645d>] ? kobject_get+0x1d/0x40
Jan 18 14:42:05 aurora kernel: [   13.425738]  [<c11f658f>] ? kobject_add_internal+0x8f/0x200
Jan 18 14:42:05 aurora kernel: [   13.425871]  [<c11ff62f>] ? kvasprintf+0x4f/0x80
Jan 18 14:42:05 aurora kernel: [   13.426001]  [<c11f6732>] ? kset_register+0x32/0x70
Jan 18 14:42:05 aurora kernel: [   13.426134]  [<c126dd27>] ? __class_register+0xb7/0x1a0
Jan 18 14:42:05 aurora kernel: [   13.426267]  [<f8412000>] ? firmware_class_init+0x0/0x87 [compat_firmware_class]
Jan 18 14:42:05 aurora kernel: [   13.426408]  [<f841201f>] ? firmware_class_init+0x1f/0x87 [compat_firmware_class]
Jan 18 14:42:05 aurora kernel: [   13.426550]  [<c100115b>] ? do_one_initcall+0x3b/0x1c0
Jan 18 14:42:05 aurora kernel: [   13.426683]  [<c106b7f4>] ? sys_init_module+0xe4/0x230
Jan 18 14:42:05 aurora kernel: [   13.426815]  [<c1024c0c>] ? do_page_fault+0xfc/0x320
Jan 18 14:42:05 aurora kernel: [   13.426946]  [<c10035a0>] ? syscall_call+0x7/0xb
Jan 18 14:42:05 aurora kernel: [   13.427076] ---[ end trace d2a8e2c8642ab805 ]---
Jan 18 14:42:05 aurora kernel: [   13.427207] kobject_add_internal failed for firmware with -EEXIST, don't try to register things with the same name in the same directory.
Jan 18 14:42:05 aurora kernel: [   13.427355] Pid: 1770, comm: modprobe Tainted: G        W  2.6.31-sdinet52-aurora #280
Jan 18 14:42:05 aurora kernel: [   13.427494] Call Trace:
Jan 18 14:42:05 aurora kernel: [   13.427622]  [<c11f6642>] ? kobject_add_internal+0x142/0x200
Jan 18 14:42:05 aurora kernel: [   13.427753]  [<c11f6732>] ? kset_register+0x32/0x70
Jan 18 14:42:05 aurora kernel: [   13.427884]  [<c126dd27>] ? __class_register+0xb7/0x1a0
Jan 18 14:42:05 aurora kernel: [   13.428031]  [<f8412000>] ? firmware_class_init+0x0/0x87 [compat_firmware_class]
Jan 18 14:42:05 aurora kernel: [   13.428174]  [<f841201f>] ? firmware_class_init+0x1f/0x87 [compat_firmware_class]
Jan 18 14:42:05 aurora kernel: [   13.428316]  [<c100115b>] ? do_one_initcall+0x3b/0x1c0
Jan 18 14:42:05 aurora kernel: [   13.428451]  [<c106b7f4>] ? sys_init_module+0xe4/0x230
Jan 18 14:42:05 aurora kernel: [   13.428583]  [<c1024c0c>] ? do_page_fault+0xfc/0x320
Jan 18 14:42:05 aurora kernel: [   13.428714]  [<c10035a0>] ? syscall_call+0x7/0xb
Jan 18 14:42:05 aurora kernel: [   13.428842] firmware_class_init: class_register failed


After the following dirty fix my wireless card (iwl3945) works again:

Index: compat-wireless/config.mk
===================================================================
--- compat-wireless.orig/config.mk
+++ compat-wireless/config.mk
@@ -100,9 +100,9 @@ endif
 endif
  
 
-ifeq ($(CONFIG_COMPAT_KERNEL_33),y)
- CONFIG_COMPAT_FIRMWARE_CLASS=m
-endif
+#ifeq ($(CONFIG_COMPAT_KERNEL_33),y)
+# CONFIG_COMPAT_FIRMWARE_CLASS=m
+#endif
 
 
 # Wireless subsystem stuff
Index: compat-wireless/include/linux/compat-2.6.32.h
===================================================================
--- compat-wireless.orig/include/linux/compat-2.6.32.h
+++ compat-wireless/include/linux/compat-2.6.32.h
@@ -11,6 +11,7 @@
 #include <linux/workqueue.h>
 #include <linux/firmware.h>
 
+/*
 #define release_firmware compat_release_firmware
 #define request_firmware compat_request_firmware
 #define request_firmware_nowait compat_request_firmware_nowait
@@ -43,6 +44,7 @@ static inline void compat_release_firmwa
 {
 }
 #endif
+*/
 
 #define SDIO_VENDOR_ID_INTEL			0x0089
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402


But I am unsure why everything works even without the compat-backport,
perhaps Ubuntu already includes it somehow?

c'ya
sven

-- 
The lights are fading out, once more...
