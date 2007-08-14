Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50348
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763402AbXHNRA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 13:00:57 -0400
Message-Id: <20070814165747.381853000@bu3sch.de>
References: <20070814165746.863593000@bu3sch.de>
Date: Tue, 14 Aug 2007 18:57:47 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [patch 1/7] ssb: generate modaliases for modules
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the build system magic generate the appropriate
modaliases for MODULE_DEVICE_TABLE(ssb, ...)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: ssb-merge-new/include/linux/mod_devicetable.h
===================================================================
--- ssb-merge-new.orig/include/linux/mod_devicetable.h	2007-08-11 01:57:43.000000000 +0200
+++ ssb-merge-new/include/linux/mod_devicetable.h	2007-08-11 20:26:09.000000000 +0200
@@ -339,4 +339,19 @@ struct parisc_device_id {
 #define PA_HVERSION_ANY_ID	0xffff
 #define PA_SVERSION_ANY_ID	0xffffffff
 
+/* SSB core, see drivers/ssb/ */
+struct ssb_device_id {
+	__u16	vendor;
+	__u16	coreid;
+	__u8	revision;
+};
+#define SSB_DEVICE(_vendor, _coreid, _revision)  \
+	{ .vendor = _vendor, .coreid = _coreid, .revision = _revision, }
+#define SSB_DEVTABLE_END  \
+	{ 0, },
+
+#define SSB_ANY_VENDOR		0xFFFF
+#define SSB_ANY_ID		0xFFFF
+#define SSB_ANY_REV		0xFF
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
Index: ssb-merge-new/include/linux/ssb/ssb.h
===================================================================
--- ssb-merge-new.orig/include/linux/ssb/ssb.h	2007-08-11 01:57:44.000000000 +0200
+++ ssb-merge-new/include/linux/ssb/ssb.h	2007-08-11 20:26:09.000000000 +0200
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
+#include <linux/mod_devicetable.h>
 
 #include <linux/ssb/ssb_regs.h>
 
@@ -153,20 +154,6 @@ struct ssb_bus_ops {
 /* Vendor-ID values */
 #define SSB_VENDOR_BROADCOM	0x4243
 
-struct ssb_device_id {
-	u16 vendor;
-	u16 coreid;
-	u8 revision;
-};
-#define SSB_DEVICE(_vendor, _coreid, _revision)  \
-	{ .vendor = _vendor, .coreid = _coreid, .revision = _revision, }
-#define SSB_DEVTABLE_END  \
-	{ 0, },
-
-#define SSB_ANY_VENDOR		0xFFFF
-#define SSB_ANY_ID		0xFFFF
-#define SSB_ANY_REV		0xFF
-
 /* Some kernel subsystems poke with dev->drvdata, so we must use the
  * following ugly workaround to get from struct device to struct ssb_device */
 struct __ssb_dev_wrapper {
Index: ssb-merge-new/scripts/mod/file2alias.c
===================================================================
--- ssb-merge-new.orig/scripts/mod/file2alias.c	2007-08-11 01:57:48.000000000 +0200
+++ ssb-merge-new/scripts/mod/file2alias.c	2007-08-11 20:26:09.000000000 +0200
@@ -484,6 +484,21 @@ static int do_parisc_entry(const char *f
 	return 1;
 }
 
+/* Looks like: ssb:vNidNrevN. */
+static int do_ssb_entry(const char *filename,
+			struct ssb_device_id *id, char *alias)
+{
+	id->vendor = TO_NATIVE(id->vendor);
+	id->coreid = TO_NATIVE(id->coreid);
+	id->revision = TO_NATIVE(id->revision);
+
+	strcpy(alias, "ssb:");
+	ADD(alias, "v", id->vendor != SSB_ANY_VENDOR, id->vendor);
+	ADD(alias, "id", id->coreid != SSB_ANY_ID, id->coreid);
+	ADD(alias, "rev", id->revision != SSB_ANY_REV, id->revision);
+	return 1;
+}
+
 /* Ignore any prefix, eg. v850 prepends _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -599,6 +614,10 @@ void handle_moddevtable(struct module *m
 		do_table(symval, sym->st_size,
 			 sizeof(struct parisc_device_id), "parisc",
 			 do_parisc_entry, mod);
+	else if (sym_is(symname, "__mod_ssb_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct ssb_device_id), "ssb",
+			 do_ssb_entry, mod);
 }
 
 /* Now add out buffered information to the generated C source */

-- 

