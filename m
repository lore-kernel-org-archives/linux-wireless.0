Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbXEKDCY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 23:02:24 -0400
Subject: [PATCH 15/19] libertas: Clean up debug defines
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 23:05:55 -0400
Message-Id: <1178852755.8607.45.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/Makefile |    8 --------
 drivers/net/wireless/libertas/defs.h   |    5 +++++
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/libertas/Makefile b/drivers/net/wireless/libertas/Makefile
index 19e38d9..56a8ea1 100644
--- a/drivers/net/wireless/libertas/Makefile
+++ b/drivers/net/wireless/libertas/Makefile
@@ -1,5 +1,3 @@
-# EXTRA_CFLAGS += -Wpacked
-
 usb8xxx-objs := main.o fw.o wext.o \
 		rx.o tx.o cmd.o 	  \
 		cmdresp.o scan.o	  \
@@ -7,12 +5,6 @@ usb8xxx-objs := main.o fw.o wext.o \
 		ioctl.o debugfs.o	  \
 		ethtool.o assoc.o
 
-ifeq ($(CONFIG_LIBERTAS_USB_DEBUG), y)
-EXTRA_CFLAGS += -DDEBUG -DPROC_DEBUG
-endif
-
-
-#EXTRA_CFLAGS +=
 usb8xxx-objs += if_bootcmd.o
 usb8xxx-objs += if_usb.o
 
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 9156bbc..80dd9ea 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -9,6 +9,11 @@
 
 extern unsigned int libertas_debug;
 
+#ifdef CONFIG_LIBERTAS_DEBUG
+#define DEBUG
+#define PROC_DEBUG
+#endif
+
 #define DRV_NAME		"usb8xxx"
 
 #define lbs_pr_info(format, args...) \
-- 
1.5.0.6



