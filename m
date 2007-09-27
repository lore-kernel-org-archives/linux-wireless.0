Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:15830 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbXI0RTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 13:19:01 -0400
Date: Thu, 27 Sep 2007 10:17:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, rjwysocki@sisk.pl
Subject: [PATCH] libertas: fix link errors (bz# 9077)
Message-Id: <20070927101742.44146651.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix missing symbols in libertas USB driver when it is modular and rest
of libertas is built-in.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc8.orig/drivers/net/wireless/Makefile
+++ linux-2.6.23-rc8/drivers/net/wireless/Makefile
@@ -43,7 +43,7 @@ obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
 obj-$(CONFIG_PCMCIA_WL3501)	+= wl3501_cs.o
 
 obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
-obj-$(CONFIG_LIBERTAS_USB)     += libertas/
+obj-$(CONFIG_LIBERTAS)		+= libertas/
 
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
