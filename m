Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:26946 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1BQWeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:34:14 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022262.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:33:36 +0200
Subject: Re: [RFC] AI support (10/14 ssb bus implementation-specific io
	unmap)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980093.13554.5.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 00:25:45 +0200
Message-Id: <1297981545.23381.29.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Introduce iounmap helper for transparent resource
releasing by bus implementation-specific management code.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/scan.c        |    2 +-
 drivers/ssb/ssb_private.h |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)
--- linux-wireless-testing.orig/drivers/ssb/scan.c	2011-02-17 14:45:04.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/scan.c	2011-02-17 14:45:31.000000000 +0200
@@ -199,7 +199,7 @@ static int scan_switchcore(struct ssb_bu
 	return 0;
 }
 
-void ssb_iounmap(struct ssb_bus *bus)
+void ssb_iounmap_sb(struct ssb_bus *bus)
 {
 	switch (bus->bustype) {
 	case SSB_BUSTYPE_SSB:
--- linux-wireless-testing.orig/drivers/ssb/ssb_private.h	2011-02-17 14:34:02.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/ssb_private.h	2011-02-17 14:45:31.000000000 +0200
@@ -159,9 +159,13 @@ static inline int ssb_sdio_init(struct s
 extern const char *ssb_core_name(u16 coreid);
 extern int ssb_bus_scan(struct ssb_bus *bus,
 			unsigned long baseaddr);
-extern void ssb_iounmap(struct ssb_bus *ssb);
+extern void ssb_iounmap_sb(struct ssb_bus *bus);
 extern int ssb_bus_check_core(struct ssb_device *dev, int *nr_80211_cores,
 			      int corenum);
+static inline void ssb_iounmap(struct ssb_bus *bus)
+{
+	ssb_iounmap_sb(bus);
+}
 
 
 /* sprom.c */



