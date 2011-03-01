Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:45920 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab1CATDK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 14:03:10 -0500
Subject: [PATCH] lib-average: Make config option selectable
From: Michael Buesch <mb@bu3sch.de>
To: Bruno Randolf <br1@einfach.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 20:03:05 +0100
Message-ID: <1299006185.28897.5.camel@marge>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make CONFIG_AVERAGE selectable for out-of-tree users
such as compat-wireless.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: linux-2.6.38-rc6/lib/Kconfig
===================================================================
--- linux-2.6.38-rc6.orig/lib/Kconfig	2011-03-01 19:24:16.246703947 +0100
+++ linux-2.6.38-rc6/lib/Kconfig	2011-03-01 19:26:58.696312483 +0100
@@ -223,6 +223,13 @@ config LRU_CACHE
 	tristate
 
 config AVERAGE
-	bool
+	bool "Averaging functions"
+	help
+	  This option is provided for the case where no in-kernel-tree
+	  modules require averaging functions, but a module built outside
+	  the kernel tree does. Such modules that use library averaging
+	  functions require Y here.
+
+	  If unsure, say N.
 
 endmenu

-- 
Greetings, Michael.


