Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33198 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZFDGWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 02:22:33 -0400
Subject: [PATCH] wimax: depend on rfkill properly
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 08:22:25 +0200
Message-Id: <1244096545.22576.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My mistake, I should have added that when cleaning up
rfkill and changing wimax.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wimax/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/net/wimax/Kconfig	2009-06-04 08:20:57.000000000 +0200
+++ wireless-testing/net/wimax/Kconfig	2009-06-04 08:21:09.000000000 +0200
@@ -4,6 +4,7 @@
 
 menuconfig WIMAX
 	tristate "WiMAX Wireless Broadband support"
+	depends on RFKILL || !RFKILL
 	help
 
 	  Select to configure support for devices that provide


