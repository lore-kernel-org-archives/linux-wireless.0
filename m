Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([207.115.11.52]:64080 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbZDHVSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 17:18:36 -0400
Message-ID: <49DD149B.2060300@lwfinger.net> (sfid-20090408_231858_927100_9BC22398)
Date: Wed, 08 Apr 2009 16:18:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: bcm43xx-dev@lists.berlios.de
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Problems with 2.6.30-rc1
References: <20090408182021.GA4112@aragorn.home.lxtec.de>	<200904082050.00327.mb@bu3sch.de> <49DCF537.8000702@lwfinger.net> <20090408192634.GB3717@samweis.home.lxtec.de>
In-Reply-To: <20090408192634.GB3717@samweis.home.lxtec.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


If you are having problems with wireless networking using 2.6.30-rc1 from
Linus's Linux-2.6 git tree, the fix is the following (Note: This is _NOT_ needed
for wireless-testing!!!):

---
Fix try_then_request_module to use waiting __request_module again.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 include/linux/kmod.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.30-rc1/include/linux/kmod.h
===================================================================
--- linux-2.6.30-rc1.orig/include/linux/kmod.h	2009-04-08 12:47:54.000000000 +0200
+++ linux-2.6.30-rc1/include/linux/kmod.h	2009-04-08 17:39:35.000000000 +0200
@@ -34,7 +34,7 @@ extern int __request_module(bool wait, c
 #define request_module(mod...) __request_module(true, mod)
 #define request_module_nowait(mod...) __request_module(false, mod)
 #define try_then_request_module(x, mod...) \
-	((x) ?: (__request_module(false, mod), (x)))
+	((x) ?: (__request_module(true, mod), (x)))
 #else
 static inline int request_module(const char *name, ...) { return -ENOSYS; }
 static inline int request_module_nowait(const char *name, ...) { return -ENOSYS; }

-- 
