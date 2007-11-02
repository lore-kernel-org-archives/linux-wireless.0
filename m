Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44196
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbXKBTTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2007 15:19:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rfkill: Fix sparse warning
Date: Fri, 2 Nov 2007 20:18:11 +0100
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200711022018.11310.mb@bu3sch.de> (sfid-20071102_191923_609618_02C5ADF2)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Index: wireless-2.6/net/rfkill/rfkill.c
===================================================================
--- wireless-2.6.orig/net/rfkill/rfkill.c	2007-11-02 20:05:54.000000000 +0100
+++ wireless-2.6/net/rfkill/rfkill.c	2007-11-02 20:16:09.000000000 +0100
@@ -27,6 +27,10 @@
 #include <linux/mutex.h>
 #include <linux/rfkill.h>
 
+/* Get declaration of rfkill_switch_all() to shut up sparse. */
+#include "rfkill-input.h"
+
+
 MODULE_AUTHOR("Ivo van Doorn <IvDoorn@gmail.com>");
 MODULE_VERSION("1.0");
 MODULE_DESCRIPTION("RF switch support");
