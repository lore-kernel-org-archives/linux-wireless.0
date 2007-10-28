Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56945
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbXJ1Njt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 09:39:49 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rfkill: Use subsys_initcall
Date: Sun, 28 Oct 2007 14:39:02 +0100
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710281439.02701.mb@bu3sch.de> (sfid-20071028_133954_735251_57C26073)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must use subsys_initcall, because we must initialize before a
driver calls rfkill_register().

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/net/rfkill/rfkill.c
===================================================================
--- wireless-2.6.orig/net/rfkill/rfkill.c	2007-10-28 13:09:04.000000000 +0100
+++ wireless-2.6/net/rfkill/rfkill.c	2007-10-28 14:27:30.000000000 +0100
@@ -449,5 +449,5 @@ static void __exit rfkill_exit(void)
 	class_unregister(&rfkill_class);
 }
 
-module_init(rfkill_init);
+subsys_initcall(rfkill_init);
 module_exit(rfkill_exit);
